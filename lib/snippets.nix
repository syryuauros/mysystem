pkgs:
let

  inherit (builtins) split filter isString concatStringsSep;

in
rec
{

  partition-format =
    { disk, forced, root-label ? "root", boot-label ? "BOOT", mount-point ? "/mnt" }:
    ''
      ### partition-format ###
      ### https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual-partitioning

      if [ ! -e /dev/disk/by-label/root ] || [ ${forced} == 'true' ]
        then # NOTE: improve conditional?

        # create a GPT partition table
        ${pkgs.parted}/bin/parted -s "${disk}" -- mklabel gpt

        # add a boot partition and format
        ${pkgs.parted}/bin/parted -s "${disk}" -- mkpart ESP fat32 1MB 512MB
        ${pkgs.parted}/bin/parted -s "${disk}" -- set 1 esp on
        ${pkgs.dosfstools}/bin/mkfs.fat -F 32 -n ${boot-label} "${disk}p1"

        # add the other partition
        ${pkgs.parted}/bin/parted -s "${disk}" -- mkpart primary 512MB -0GB

        # encrypt the other partition
        echo "solutionmaster" | ${pkgs.cryptsetup}/bin/cryptsetup -q luksFormat "${disk}p2" --label=root_crypt
        echo "solutionmaster" | ${pkgs.cryptsetup}/bin/cryptsetup open "${disk}p2" enc

        # create LVM
        pvcreate /dev/mapper/enc
        vgcreate lvm /dev/mapper/enc

        # create swap and format
        lvcreate --size 8G --name swap lvm
        mkswap /dev/lvm/swap -L swap
        swapon /dev/lvm/swap

        # create root and format in btrfs
        lvcreate --extents 100%FREE --name ${root-label} lvm
        ${pkgs.btrfs-progs}/bin/mkfs.btrfs /dev/lvm/root -L ${root-label}

      fi

      ########################################
    '';

  create-btrfs-subvolumes = { root-label ? "root", boot-label ? "BOOT", mount-point ? "/mnt" }:
    ''
      ### create subvolumes ###

      mount -t btrfs -L ${root-label} ${mount-point}

      btrfs subvolume create ${mount-point}/root
      btrfs subvolume create ${mount-point}/home
      btrfs subvolume create ${mount-point}/nix
      btrfs subvolume create ${mount-point}/persist
      btrfs subvolume create ${mount-point}/log

      # take an empty *readonly* snapshot of the root subvolume,
      # which we'll eventually rollback to on every boot.
      btrfs subvolume snapshot -r ${mount-point}/root ${mount-point}/root-blank

      umount ${mount-point}
    '';

  mount-btrfs-subvolumes = { root-label ? "root", boot-label ? "BOOT", mount-point ? "/mnt" }:
    ''
      ### Mount the directories ###

      mount -o subvol=root,compress=zstd,noatime -L ${root-label} ${mount-point}

      mkdir ${mount-point}/home
      mount -o subvol=home,compress=zstd,noatime -L ${root-label} ${mount-point}/home

      mkdir ${mount-point}/nix
      mount -o subvol=nix,compress=zstd,noatime -L ${root-label} ${mount-point}/nix

      mkdir ${mount-point}/persist
      mount -o subvol=persist,compress=zstd,noatime -L ${root-label} ${mount-point}/persist

      mkdir -p ${mount-point}/var/log
      mount -o subvol=log,compress=zstd,noatime -L ${root-label} ${mount-point}/var/log

      mkdir -p ${mount-point}/boot
      mount -L ${boot-label} ${mount-point}/boot

    '';

  mount-new-root = { root-label ? "root", boot-label ? "BOOT", mount-point ? "/mnt" }:
    ''
      ### mount-new-root ###

      umask 0022

      echo "mounting ${mount-point}"
      sudo ${pkgs.coreutils}/bin/mkdir -p "${mount-point}"
      sudo ${pkgs.util-linux}/bin/mount -L ${root-label} "${mount-point}"

      echo "mounting ${mount-point}/boot"
      sudo ${pkgs.coreutils}/bin/mkdir -p "${mount-point}/boot"
      sudo ${pkgs.util-linux}/bin/mount -L ${boot-label} "${mount-point}/boot"

      ######################################
    '';

  switch-after-enter = { system-toplevel, mount-point ? "/mnt", switch-command ? "switch" }:
    ''
      ### switch-after-enter ###

      echo "Setting the profile"

      export PATH=$PATH:"${system-toplevel}/sw/bin"

      sudo nix-env --store "${mount-point}" \
                   -p "${mount-point}/nix/var/nix/profiles/system" \
                   --set "${system-toplevel}"

      sudo mkdir -m 0755 -p "${mount-point}/etc"
      sudo touch "${mount-point}/etc/NIXOS"

      sudo ln -sfn /proc/mounts "${mount-point}/etc/mtab"

      NIXOS_INSTALL_BOOTLOADER=1 \
      sudo nixos-enter \
        --root "${mount-point}" \
        -- \
        /run/current-system/bin/switch-to-configuration ${switch-command}

      # TODO: GC

      sync
      echo "switch-after-enter is done"

      #########################################
    '';


  copy-to-remote =
    { host
    , user ? "root"
    , private-key ? null
    , remote-store ? null
    , references
    }:
    let
      store-uri = let
        queries = concatStringsSep "" [
          (if ! isNull private-key then "?ssh-key=${private-key}" else "")
          (if ! isNull remote-store then "?remote-store=${remote-store}" else "")
        ];
      in "ssh://${user}@${host}${queries}";
    in
    ''
      ${pkgs.nixFlakes}/bin/nix copy "${references}" --to "${store-uri}"
    '';


  # `remote-execution-over-ssh` makes sure that whenever a script is executed
  # over ssh, all the contexts are present on remote side.
  remote-execution-over-ssh =
    { host
    , user ? "root"
    , private-key ? null
    , remote-store ? null
    , extraArgs ? []
    , trace ? true
    }:
    script:
    let

      references = pkgs.writeStringReferencesToFile script;

      indent = "\t";

      script' = let
        lines = (if trace then [ "set -x\n" ] else []) ++ (filter isString (split "\n" script));
      in concatStringsSep "\n${indent}" lines;

      extraArgs' = [ "-o StrictHostKeyChecking=no"
                     "-o UserKnownHostsFile=/dev/null"
                     "-o \"ServerAliveInterval 2\""
                   ] ++ (if ! isNull private-key then [ "-i ${private-key}" ] else []) ++
                   extraArgs;

    in ''
        ### remote-execution-over-ssh ###

        ${copy-to-remote { inherit host user private-key remote-store references; }}

        ${pkgs.openssh}/bin/ssh ${user}@${host} -T ${toString extraArgs'} <<EOF
        ${indent}${script'}
        EOF

        #################################
      '';


}

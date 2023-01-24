{ pkgs }:
let

  mylib = import ../../../lib pkgs;
  inherit (mylib) get-toplevel snippets;

in
{

  partition-format = pkgs.writeShellScriptBin "partition-format"
    ''
      if [ -z "$1" ]; then
        echo -e "Please call '$0 <disk>' to run this command!\n"
        exit 1
      fi
      disk=$1
      ${snippets.partition-format { forced = "true"; disk = "\${disk}"; }}
    '';

  create-btrfs-subvolumes = pkgs.writeShellScriptBin "create-btrfs-subvolumes"
    ''${snippets.create-btrfs-subvolumes { }}'';

  mount-btrfs-subvolumes = pkgs.writeShellScriptBin "mount-btrfs-subvolumes"
    ''${snippets.mount-btrfs-subvolumes { }}'';

  switch-after-enter = system-toplevel: pkgs.writeShellScriptBin "switch-after-enter"
    ''${snippets.switch-after-enter { inherit system-toplevel; }}'';

  deploy-to-remote =
    { hostName ? "to-remote"
    , nixos-toplevel
    , remote
    }:
    let profile = "/nix/var/nix/profiles/system";
    in pkgs.writeShellScriptBin "deploy-${hostName}" ''
      nix copy ${nixos-toplevel} \
        --to ssh://${remote} \
        --no-check-sigs \
        --experimental-features nix-command
      ssh ${remote} sudo nix-env --profile ${profile} --set ${nixos-toplevel}
      ssh ${remote} sudo ${profile}/bin/switch-to-configuration switch
    '';

  install-from-usb =
    { mountPoint ? "/mnt"
    , nixos-toplevel
    }:
    let profile = "${mountPoint}/nix/var/nix/profiles/system";
    in pkgs.writeShellScriptBin "deploy-sh" ''
      nix copy ${nixos-toplevel} \
        --from / \
        --to ${mountPoint} \
        --no-check-sigs \
        --experimental-features nix-command
      nix-env --store ${mountPoint} \
              --profile ${profile}  \
              --set ${nixos-toplevel}
      ${profile}/bin/switch-to-configuration switch
      mkdir -m 0755 -p ${mountPoint}/etc
      touch "${mountPoint}/etc/NIXOS"
      ln -sfn /proc/mounts ${mountPoint}/etc/mtab
      NIXOS_INSTALL_BOOTLOADER=1 nixos-enter --root "${mountPoint}" -- /run/current-system/bin/switch-to-configuration boot
    '';

  deploy-ssh-from-to = host: path: store:
    let profile = "/nix/var/nix/profiles/system";
    in pkgs.writeShellScriptBin "deploy-sh" ''
      host="${host}"
      store="${store}"
      nix copy $store --from ssh://$host --to ${path}
      nix-env --profile ${profile} --set $store
      ${profile}/bin/switch-to-configuration switch
    '';

  remote-nixos-install = pkgs.runCommand "remote-nixos-install" {} ''
    mkdir -p $out/bin
    outfile=$out/bin/remote-nixos-install
    cp ${./remote-nixos-install.sh} $outfile
    patchShebangs $outfile
    chmod +x $outfile
  '';


  switch-over-ssh = {
    host
    , nixosConfiguration
    , user ? "jj"
    , extraScripts ? ""
    , switch-command ? "switch"
    }:
    let
      toplevel = get-toplevel nixosConfiguration;
      profile = "/nix/var/nix/profiles/system";
      script =
        snippets.remote-execution-over-ssh { inherit host user; } ''
          sudo nix-env --profile "${profile}" --set "${toplevel}"
          sudo ${profile}/bin/switch-to-configuration ${switch-command}
          ${extraScripts}
        '';
    in pkgs.writeShellScriptBin "switch-over-ssh.sh" script;


  # NOTE: this copies the closure into not /mnt/nix/store but /nix/store,
  # which results in insufficient space error.
  install-over-ssh =
    { host
    , system-toplevel
    , user ? "root"
    , extraScripts ? ""
    , root-label ? "root"
    , boot-label ? "BOOT"
    , mount-point ? "/mnt"
    , forced ? "false"
    , disk ? "/dev/nvme0n1"
    }:
    let
      inherit (snippets)
        partition-format
        create-btrfs-subvolumes
        mount-btrfs-subvolumes
        switch-after-enter;

      remote-script =
        snippets.remote-execution-over-ssh {
          inherit host user;
          remote-store = "/mnt";
        }
        ''
          ${partition-format { inherit forced disk; }}
          ${create-btrfs-subvolumes { inherit root-label boot-label mount-point; }}
          ${mount-btrfs-subvolumes { inherit root-label boot-label mount-point; }}
          ${switch-after-enter { inherit system-toplevel; }}
          ${extraScripts}
        '';

    in pkgs.writeShellScriptBin "install-over-ssh.sh"
        ''
          system-toplevel=$1
          host=$2
          disk=$3
          forced=$4
          ${pkgs.nixFlakes}/bin/nix copy ''${system-toplevel} --to root@host?remote-store=/mnt
          ${remote-script "\${system-toplevel}" "\${host}" "\${disk}" "\${forced}"}
        '';


}

{ pkgs, utils }:

{

  mount-new-root = { root-label ? "root", boot-label ? "BOOT", mount-point ? "/mnt" }:
    ''
      ### mount-new-root ###

      umask 0022

      echo "mounting $mount-point"
      sudo ${pkgs.coreutils}/bin/mkdir -p "${mount-point}"
      sudo ${pkgs.util-linux}/bin/mount -L ${root-label} "${mount-point}"

      echo "mounting ${mount-point}/boot"
      sudo ${pkgs.coreutils}/bin/mkdir -p "${mount-point}/boot"
      sudo ${pkgs.util-linux}/bin/mount -L ${boot-label} "${mount-point}/boot"

      ######################################
    '';


  switch-after-enter = evaled-config: mount-point:
    let
      inherit (evaled-config.config.system.build) toplevel;
    in ''
      ### switch-after-enter ###

      echo "Setting the profile"

      export PATH=$PATH:"${toplevel}/sw/bin"

      sudo nix-env --store "${mount-point}" \
              -p "${mount-point}/nix/var/nix/profiles/system" \
              --set "${toplevel}"

      sudo mkdir -m 0755 -p "${mount-point}/etc"
      sudo touch "${mount-point}/etc/NIXOS"

      sudo ln -sfn /proc/mounts "${mount-point}/etc/mtab"

      NIXOS_INSTALL_BOOTLOADER=1 \
      sudo nixos-enter \
        --root "${mount-point}" \
        -- \
        /run/current-system/bin/switch-to-configuration boot

      # TODO: GC

      sync
      echo "switch-after-enter is done"

      #########################################
    '';


  # `remote-execution-over-ssh` makes sure that whenever a script is executed
  # over ssh, all the contexts are present on remote side.

  remote-execution-over-ssh =

    { host, user ? "root", private-key ? null, extraArgs ? [], trace ? true }:

    script:

    let
      references = pkgs.writeStringReferencesToFile script;
      indent = "\t";
      script' = let
        inherit (builtins) split filter isString concatStringsSep;
        lines = (if trace then [ "set -x\n" ] else []) ++ (filter isString (split "\n" script));
      in concatStringsSep "\n${indent}" lines;
      extraArgs' = (if ! isNull private-key then [ "-i ${private-key}" ] else []) ++ extraArgs;
      store-uri = "ssh://${user}@${host}${if ! isNull private-key then "?ssh-key=${private-key}" else ""}";
    in ''
        ### remote-execution-over-ssh ###

        ${pkgs.nixFlakes}/bin/nix copy "${references}" --to "${store-uri}"

        ${pkgs.openssh}/bin/ssh ${user}@${host} -T ${toString extraArgs'} <<EOF
        ${indent}${script'}
        EOF

        #################################
      '';


}

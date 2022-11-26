args@{ pkgs, utils }: let

  inherit (utils) getToplevel;

  inherit (import ./snippets.nix args)
    mount-new-root
    switch-after-enter
    remote-execution-over-ssh
  ;

in
{

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


  switch-over-ssh = { host, evaled-config, user ? "jj", extraScripts ? "" }:
    let
      toplevel = getToplevel evaled-config;
      profile = "/nix/var/nix/profiles/system";
      script =
        remote-execution-over-ssh { inherit host user; } ''
          sudo nix-env --profile "${profile}" --set "${toplevel}"
          sudo ${profile}/bin/switch-to-configuration switch
          ${extraScripts}
        '';
    in pkgs.writeShellScriptBin "switch-over-ssh.sh" script;


  switch-after-enter = evaled-config: mount-point:
    let
      inherit (evaled-config.config.system.build) toplevel;
    in ''
      ### switch-after-enter ###

      echo "Setting the profile"

      export PATH=$PATH:"${toplevel}/sw/bin"

      nix-env --store "${mount-point}" \
              -p "${mount-point}/nix/var/nix/profiles/system" \
              --set "${toplevel}"

      mkdir -m 0755 -p "${mount-point}/etc"
      touch "${mount-point}/etc/NIXOS"

      ln -sfn /proc/mounts "${mount-point}/etc/mtab"

      NIXOS_INSTALL_BOOTLOADER=1 \
      nixos-enter \
        --root "${mount-point}" \
        -- \
        /run/current-system/bin/switch-to-configuration boot

      # TODO: GC

      sync
      echo "switch-after-enter is done"

      #########################################
    '';


  # FIXME: this copies the closure into not /mnt/nix/store but /nix/store,
  #        which results in insufficient space error.
  install-over-ssh =
    { host
    , evaled-config
    , user ? "jj"
    , extraScripts ? ""
    , root-label ? "root"
    , boot-label ? "BOOT"
    , mount-point ? "/mnt"
    }:
    let
      toplevel = getToplevel evaled-config;
      profile = "/nix/var/nix/profiles/system";
      script =
        remote-execution-over-ssh {
          inherit host user;
          extraArgs = ["-o StrictHostKeyChecking=no"
                       "-o UserKnownHostsFile=/dev/null"
                       "-o \"ServerAliveInterval 2\"" ];
        } ''

          ${mount-new-root { inherit root-label boot-label mount-point; }}
          ${pkgs.nix}/bin/nix copy "${toplevel}" --to "${mount-point}"
          sudo ${pkgs.nix}/nix-env --profile "${profile}" --set "${toplevel}"
          ${switch-after-enter evaled-config mount-point}
          ${extraScripts}
        '';
    in pkgs.writeShellScriptBin "install-over-ssh.sh" script;


}

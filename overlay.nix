{ mkNixOSConfiguration, hosts, inputs }: final: prev: with final;
{

  extra-monitor = callPackage ./packages/scripts/extra-monitor {};
  restart-xmonad = callPackage ./packages/scripts/restart-xmonad {};
  dracula-qutebrowser = callPackage ./packages/dracula-qutebrowser {};
  mychemacs2 = callPackage ./packages/mychemacs2 {  inherit inputs; };

  # linuxPackages = prev.linuxPackages.extend (self: super: {
  #   rtw89 = self.callPackage ./packages/rtw89 {};
  # });
  # linuxPackages_latest = prev.linuxPackages_latest.extend (self: super: {
  #   rtw89 = self.callPackage ./packages/rtw89 {};
  # });
  # rtw89-firmware = callPackage ./packages/rtw89-firmware {};
  #

  doom-emacs = mk-doom-emacs {
    doomPrivateDir = ./packages/doom-emacs/doom.d;
  };


  # failed to pass the test on mac 2021-06-04
  nixUnstable = prev.nixUnstable.overrideAttrs (o: {
    doInstallCheck = false;
  });

  mytex = texlive.combine {
    inherit (texlive)
      collection-basic
      collection-bibtexextra
      collection-latex
      collection-latexextra
      collection-latexrecommended
      collection-binextra
      collection-langenglish
      collection-langkorean
      collection-langcjk
      collection-plaingeneric
      collection-fontutils
      collection-fontsextra
      collection-fontsrecommended
      collection-context
      collection-metapost
      collection-texworks
      collection-luatex
      collection-xetex
      collection-pictures
      collection-pstricks
      collection-publishers
      collection-mathscience
    ;

  };


  deploy = let
    profile = "/nix/var/nix/profiles/system";
  in writeScriptBin "deploy" ''
    host="$1"
    store="$2"
    # nix-copy-closure --to --use-substitutes $host $store
    nix-copy-closure --to $host $store
    ssh $host sudo nix-env --profile ${profile} --set $store
    ssh $host sudo ${profile}/bin/switch-to-configuration switch
  '';

  nixOSApps = (pkgs.lib.mapAttrs
    (name: host: let
      nixOSConf = mkNixOSConfiguration name host;
      nixOSPkg = nixOSConf.config.system.build.toplevel;
    in
    {
      type = "app";
      program = let
        profile = "/nix/var/nix/profiles/system";
        prog = pkgs.writeScriptBin "deploy" ''
          host="${host.ip}"
          store="${nixOSPkg}"
          # nix-copy-closure --to --use-substitutes $host $store
          nix-copy-closure --to $host $store
          ssh $host sudo nix-env --profile ${profile} --set $store
          ssh $host sudo ${profile}/bin/switch-to-configuration switch
        '';
      in "${prog}/bin/deploy";
    })
    hosts);

}

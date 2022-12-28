pkgs:

{

  get-toplevel = nixos: nixos.config.system.build.toplevel;
  get-isoimage = nixos: nixos.config.system.build.isoImage;

  get-boot-essential = nixosConfiguration:
    let build = nixosConfiguration.config.system.build;
    in {
      kernel = "${build.toplevel}/kernel";
      initrd = "${build.netbootRamdisk or build.toplevel}/initrd";
      cmdLine = "init=${build.toplevel}/init";
    };
}

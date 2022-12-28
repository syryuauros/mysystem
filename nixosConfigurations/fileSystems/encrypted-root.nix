{
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-label/root_crypt";
      preLVM = true;
    };
  };
}

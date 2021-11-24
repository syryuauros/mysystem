{ config, lib, pkgs, ... }:

{

  fileSystems."/hds/store" = {
    device = "10.10.100.4:/hds/store";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
  };

}

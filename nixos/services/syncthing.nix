{ pkgs, ... }: {

  services.syncthing = {
    enable = true;
    dataDir = "/home/jj";
    configDir = "/home/jj/.config/syncthing";
    user = "jj";
    group = "users";
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";
    overrideDevices = true;
    overrideFolders = true;
    devices = {
      lapaz = { id = "AYSSCDO-7QIMWCI-ZX6NL23-PAZCL4A-Y5RUZZX-USGFL3T-JRIJPBY-W4CU3AZ"; };
      lima = { id = "EASXHWA-PYUGJDN-STOQU7D-6RUASQW-SC5YAFK-EPV4LW6-CSIDPH3-4N526A3"; };
      bogota = { id = "35ND6IE-TNGZ5KH-U5SIL7L-RKAXD6S-GAXIWBT-KAPYXMD-FELWNBZ-HYXCFAS"; };
      mbp15 = { id = "IP22ZVB-ODDIJK5-JQIXGES-QHP6GNC-HBTMDP3-KLDHUPM-SHNIFN5-QKB7PA5"; };
      urubamba = { id = "XEVAC4R-X6NZWOF-UNC5VFJ-VVV7WWA-R75Q66Q-REGPX33-F5Y76R5-KUCG5QO"; };
    };
    folders = {

      Ocean = {
        path = "/home/jj/Ocean";
        devices = [ "lapaz" "lima" "bogota" "mbp15" ];
        versioning = {
          type = "staggered";
          params = {
            cleanInterval = "3600";  # 1 hour in seconds
            maxAge = "15552000";     # 180 days in seconds
          };
        };
      };

      Dropbox = {
        path = "/home/jj/Dropbox";
        devices = [ "lapaz" "lima" "bogota" "urubamba" "mbp15" ];
        versioning = {
          type = "staggered";
          params = {
            cleanInterval = "3600";  # 1 hour in seconds
            maxAge = "15552000";     # 180 days in seconds
          };
        };
      };

    };
  };

}

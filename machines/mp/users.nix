{ pkgs, ... }:

{

  users.users.jj = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/jj";
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$3nKguLgJMB$leFSKrvWiUAXiay8MJ8i66.ZzufIhkrrbxzv625DV28xSYGBCLp62pyIp4U3s8miHcOdJZpWLgDMEoWljPtT0.";
    shell = pkgs.fish;
  };

  users.users.web = {
    isNormalUser = false;
    uid = 1001;
    home = "/home/web";
    extraGroups = [ ];
    hashedPassword = "$6$RC/dgA4OT$1pf89X8r1iv.DSbzpXR.rj57hSTZE70t.hxB.Olj8Axwz7mf.v8MGgjySvCnzM2EOC4Nf3jYSz7y1hnn6CIkK/";
  };

}

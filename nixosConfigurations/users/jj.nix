{

  users.extraUsers.jj = {
    isNormalUser = true;
    home = "/home/jj";
    extraGroups = [ "wheel" "networkmanager" "uinput" "data" ];
    hashedPassword = "$6$3nKguLgJMB$leFSKrvWiUAXiay8MJ8i66.ZzufIhkrrbxzv625DV28xSYGBCLp62pyIp4U3s8miHcOdJZpWLgDMEoWljPtT0.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXifjBn6gkBCKkpJJAbB1pJC1zSUljf8SFnPqvB6vIR jjdosa"
    ];
  };

}

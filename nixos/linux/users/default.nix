{ pkgs, ... }:

{

  users.users.jj = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/jj";
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$3nKguLgJMB$leFSKrvWiUAXiay8MJ8i66.ZzufIhkrrbxzv625DV28xSYGBCLp62pyIp4U3s8miHcOdJZpWLgDMEoWljPtT0.";
    openssh.authorizedKeys.keys = [
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+XEhhqkpyVtUSu+t2JT3j5QxHUGBwCOiOwyc/4Ukpk8F2XP+ac5i9QuFd+yKXeoQcmgke6y+h7HjVBMDYD5OJRq6N4ep9dfU6svGccVNScbh+dOB+WtzrZco7euddOhtjT4pbSoyhImg5AJxA0SgvHnoTTq4nvMYAbCG9xSWz353FV1nrJPLo0bpEOSqdeb3HTgDntcMv9KaNGHe6hzGIPBQvW/y2FQ3hiHtDS+WIBQzPrQnRRslrCr7hcBwniYfKBdgjENK2yLIgDSoTwUXYFTMZgrjBejCo33+bR2Jrk66isEOR7oThHsI7vnxjSlUKmQ4o+B4e1lsILIyW0GPz0s/vrdTfZdqt+eZ38NJhqJD7mDruhuBf1NNE/rNWazu36afSQnRXhv9XgHo1cF1NMtC10grOrA5fUylGRHS8tS2RZHJ9OXgxBcV0bdIbqOu7jFRTzvm36dcMyJrALrz4ZEg/BJ7IOgtd1cTpcvxcQzDZSd+mSPHaY82urSH7QCc= jj@x1"
    ];
  };

  users.extraUsers.jj.extraGroups = [ "audio" "video" ];

  users.users.web = {
    isNormalUser = false;
    isSystemUser = true;
    uid = 1001;
    home = "/home/web";
    extraGroups = [ ];
    hashedPassword = "$6$RC/dgA4OT$1pf89X8r1iv.DSbzpXR.rj57hSTZE70t.hxB.Olj8Axwz7mf.v8MGgjySvCnzM2EOC4Nf3jYSz7y1hnn6CIkK/";
  };

}

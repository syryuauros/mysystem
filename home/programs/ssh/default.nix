{

  # This is probably not a correct way to set this up
  # home.file.".ssh/id_rsa".source = ./id_rsa;
  # home.file.".ssh/id_rsa.pub".source = ./id_rsa.pub;

  programs.ssh = {

    enable = true;
    matchBlocks = {

      "mp" = {
        identityFile = "~/.ssh/id_rsa.pub";
        identitiesOnly = true;
        forwardX11 = true;
        hostname = "192.168.0.118";
        user = "jj";
      };

      "x230" = {
        identityFile = "~/.ssh/id_rsa.pub";
        identitiesOnly = true;
        forwardX11 = true;
        hostname = "192.168.0.105";
        user = "jj";
      };

      "mx9366" = {
        identityFile = "~/.ssh/id_rsa.pub";
        identitiesOnly = true;
        forwardX11 = true;
        hostname = "192.168.0.119";
        user = "jj";
      };

    };

  };

}

{

  # This is probably not a correct way to set this up
  # home.file.".ssh/id_rsa".source = ./id_rsa;
  # home.file.".ssh/id_rsa.pub".source = ./id_rsa.pub;

  programs.ssh = {

    enable = true;
    matchBlocks = {

      "mp" = {
        forwardX11 = true;
        hostname = "192.168.0.118";
        user = "jj";
      };

      "x230" = {
        forwardX11 = true;
        hostname = "192.168.0.105";
        user = "jj";
      };

      "mx9366" = {
        forwardX11 = true;
        hostname = "192.168.0.119";
        user = "jj";
      };

    };

  };

}

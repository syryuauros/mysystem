{ pkgs, ... } :
{
  services.random-background = {
    enable = true;
    imageDirectory = "${pkgs.mywallpapers-1366}";
    display = "fill";
    interval = "20m";
  };
}

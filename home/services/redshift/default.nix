{ pkgs, ... }:

{

  services.redshift = {

    enable = true;
    dawnTime = "6:00-7:45";
    duskTime = "18:35-20:15";
    temperature.day = 5500;
    temperature.night = 3700;

    settings.redshift.brightness-day = "0.8";
    settings.redshift.brightness-night = "0.6";
    # latitude = "0.0000";
    # longitude = "0.0000";
    provider = "geoclue2";
  };

}

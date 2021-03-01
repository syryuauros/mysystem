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

  } //
  (if pkgs.config.hostname == "x230"
     then {
       settings.redshift.brightness-day = "1.0";
       settings.redshift.brightness-night = "1.0";
     }
     else {}
  );

}

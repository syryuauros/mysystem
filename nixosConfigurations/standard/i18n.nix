{ config, lib, pkgs, ... }:

{

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "kime";
    inputMethod.kime.config = {
      engine = {
        hangul.layout = "sebeolsik-3-91";
        global_hotkeys = let
          hanToggle = {
            behavior.Toggle = ["Hangul" "Latin"];
            result = "Consume";
          };
        in
        {
          S-Space = hanToggle;
          AltR = hanToggle;
          Hangul = hanToggle;
        };
      };
    };
  };

}

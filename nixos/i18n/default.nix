{ pkgs, ... }:

{

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "kime";
    inputMethod.kime.config = {
      engine = {
        hangul = {
          layout = "sebeolsik-3-91";
        };
        global_hotkeys = {
          S-Space = {
            behavior = {
              Toggle = ["Hangul" "Latin"];
            };
            result = "Consume";
          };
        };
      };
    };
  };

}

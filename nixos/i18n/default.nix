{ pkgs, ... }:

{

  # Select internationalisation properties.
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
    # inputMethod.enabled = "uim";
    # inputMethod.uim.toolbar = "gtk-systray";
    # inputMethod.enabled = "nabi";
    # inputMethod.enabled = "fcitx5";
    # inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ hangul ];
    # inputMethod.enabled = "ibus";
    # inputMethod.ibus.engines = with pkgs.ibus-engines; [ hangul ];
  };

}

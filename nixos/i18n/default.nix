{ pkgs, ... }:

{

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "uim";
    inputMethod.uim.toolbar = "gtk-systray";
    # inputMethod.enabled = "nabi";
    # inputMethod.enabled = "fcitx5";
    # inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ hangul ];
    # inputMethod.enabled = "ibus";
    # inputMethod.ibus.engines = with pkgs.ibus-engines; [ hangul ];
  };

}

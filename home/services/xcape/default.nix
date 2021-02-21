{ pkgs, ... }:

{

  services.xcape = {
    enable = true;
    timeout = 500;  # ms
    mapExpression = {
      Shift_L   = "Escape";
      Control_L = "Escape";
    };
  };

}

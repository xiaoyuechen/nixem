{ config, lib, ... }:

with lib;

let
  cfg = config.nixem.taffybar;

in
{
  options = {
    nixem.taffybar.enable = mkEnableOption "taffybar";
  };

  config = mkIf cfg.enable {
    services.taffybar.enable = true;

    xdg.configFile = {
      "taffybar/taffybar.hs".source = ./taffybar.hs;
      "taffybar/taffybar.css".source = ./taffybar.css;
    };
  };
}

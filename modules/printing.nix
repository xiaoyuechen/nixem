{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.nixem.printing;

in
{
  options = {
    nixem.printing.enable = mkEnableOption "printing";
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint ];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.printers = {
      ensurePrinters = [
        {
          name = "eduPrint-UU";
          deviceUri = "smb://edp-uu-prn01.user.uu.se/eduPrint-UU";
          model = "gutenprint.5.3://ricoh-mp_c5504/expert";
        }
      ];

      ensureDefaultPrinter = "eduPrint-UU";
    };

    services.samba.enable = true;
  };
}

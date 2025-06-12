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
      drivers = with pkgs; [ gutenprint hplipWithPlugin ];
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
          location = "UU";
          deviceUri = "smb://edp-uu-prn01.user.uu.se/eduPrint-UU";
          model = "gutenprint.5.3://ricoh-mp_c5504/expert";
        }
        {
          name = "HP-DeskJet-2800";
          location = "Home";
          deviceUri = "ipp://192.168.1.121/ipp/print";
          model = "drv:///hp/hpcups.drv/hp-Deskjet_2800_series.ppd";
        }
      ];

      ensureDefaultPrinter = "HP-DeskJet-2800";
    };

    services.samba.enable = true;
  };
}

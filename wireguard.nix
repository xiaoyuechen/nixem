{ ... }:

{
  networking.wg-quick.interfaces = {
    wg0 = {
      privateKey = "EJrY3uBRHyJBotKwKWRnQrXdzIp++VhU45BDIrjEGHg=";

      autostart = false;

      address = [ "10.100.0.2/24" ];
      dns = [ "10.100.0.1" ];

      peers = [
        {
          publicKey = "3YQtczJTHzBGdBRCr69SHLkLEU5coQivJz7Egk6QdFs=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "wg.vvvu.org:51820";
        }
      ];
    };
  };
}

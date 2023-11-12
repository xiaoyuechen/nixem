# Copyright (C) 2023  Xiaoyue Chen
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

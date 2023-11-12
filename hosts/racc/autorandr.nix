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

{ services, ... }:

{
  services.autorandr = {
    enable = true;
    defaultTarget = "builtin";
    profiles = {
      "builtin" = {
        fingerprint = {
          eDP-1-1 = "00ffffffffffff0006afed82000000000a1c0104a5221378026a75a456529c270b505400000001010101010101010101010101010101ce8f80b6703888403020a50058c210000000ce8f80b670382b473020a50058c110000000000000fe0041554f0a202020202020202020000000fe004231353648414e30382e32200a0017";
        };
        config = {
          eDP-1-1 = {
            enable = true;
            mode = "1920x1080";
            position = "0x0";
            primary = true;
            rate = "144.03";
          };
        };
      };
      "home" = {
        fingerprint = {
          eDP-1-1 = "00ffffffffffff0006afed82000000000a1c0104a5221378026a75a456529c270b505400000001010101010101010101010101010101ce8f80b6703888403020a50058c210000000ce8f80b670382b473020a50058c110000000000000fe0041554f0a202020202020202020000000fe004231353648414e30382e32200a0017";
          HDMI-0 = "00ffffffffffff0010ac05d1563333300d1f010380462878ea3c55ad4f46a827115054a54b00a9c0b300d100714fa9408180d1c0010108e80030f2705a80b0588a00b9882100001a000000ff0033474b515442330a2020202020000000fc0044454c4c20533332323151530a000000fd00283c1d8c3c000a202020202020018e020340f15461050403020716010611121513141f105d5e5f6023090707830100006d030c001000383c20006001020367d85dc401788000681a00000101283ce6565e00a0a0a0295030203500b9882100001a023a801871382d40582c4500b9882100001ea8ac00a0f070338030303500b9882100001a00000000000000000017";
        };
        config = {
          eDP-1-1.enable = false;
          HDMI-0 = {
            enable = true;
            mode = "3840x2160";
            position = "0x0";
            primary = true;
            rate = "60.00";
          };
        };
      };
      "office" = {
        fingerprint = {
          eDP-1-1 = "00ffffffffffff0006afed82000000000a1c0104a5221378026a75a456529c270b505400000001010101010101010101010101010101ce8f80b6703888403020a50058c210000000ce8f80b670382b473020a50058c110000000000000fe0041554f0a202020202020202020000000fe004231353648414e30382e32200a0017";
          DP-0 = "00ffffffffffff0010acbd404c414a430a1b0104a53c22783aee95a3544c99260f5054a54b00d100d1c0b300a94081808100714f01014dd000a0f0703e803020350055502100001a000000ff005634385732373342434a414c0a000000fc0044454c4c205032373135510a20000000fd001d4b1f8c36010a20202020202001a702031df150101f200514041312110302161507060123091f0783010000a36600a0f0701f803020350055502100001a565e00a0a0a029503020350055502100001a023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e000000000000000000000000000000000000000000000000000013";
        };
        config = {
          eDP-1-1.enable = false;
          DP-0 = {
            enable = true;
            mode = "3840x2160";
            position = "0x0";
            primary = true;
            rate = "60.00";
          };
        };
      };
    };
  };
}

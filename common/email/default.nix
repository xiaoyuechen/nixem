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

{ config, lib, pkgs, ... }:

with lib;
{
  options = {
    nixem.email.enable = lib.mkEnableOption "email";
  };

  config = lib.mkIf config.nixem.emacs.enable {
    accounts.email.accounts = {
      vvvu = {
        primary = true;
        address = "xchen@vvvu.org";
        userName = "xchen@vvvu.org";
        passwordCommand = "secret-tool lookup port imaps user xchen host mail.vvvu.org";
        imap.host = "mail.vvvu.org";
        mbsync = {
          enable = true;
          create = "both";
          remove = "both";
          expunge = "both";
          patterns = [ "INBOX" "Drafts" "Junk" "Sent" "Archive" "Trash" ];
        };
        mu.enable = true;
      };

      uu = {
        address = "xiaoyue.chen@it.uu.se";
        userName = "xiach215";
        passwordCommand = "secret-tool lookup port imaps user xiach215 host mail.uu.se";
        imap.host = "mail.uu.se";
        mbsync = {
          enable = true;
          create = "both";
          remove = "both";
          expunge = "both";
          patterns = [ "INBOX" "Drafts" "Junk Email" "Sent Items" "Archive" "Deleted Items" ];
          extraConfig.account = { AuthMechs = "PLAIN"; };
        };
        mu.enable = true;
      };
    };

    programs.mbsync.enable = true;
    programs.mu.enable = true;

    programs.emacs = {
      extraConfig = builtins.readFile ./mu4e.el;
      extraPackages = epkgs: with epkgs; [
        mu4e
        mu4e-alert
      ];
    };

    home.packages = with pkgs; [
      libsecret
    ];
  };
}

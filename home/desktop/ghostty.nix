{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.niks.desktop.ghostty;
in {
  options.niks.desktop.ghostty = { enable = mkEnableOption "Ghostty Terminal Emulator"; };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package = if pkgs.stdenv.isLinux then pkgs.ghostty else null;
      settings = {
        theme = "${pkgs.vimPlugins.nightfox-nvim}/extra/duskfox/duskfox.ghostty";
        font-family = "Cascadia Code";
        font-size = 12;
      };
    };
  };
}

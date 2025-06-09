{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      extra-platforms = x86_64-darwin
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 0; Minute = 0; };
      options = "--delete-older-than 30d";
    };
  };

  # Makes nix-darwin work with zsh. Only bash is enabled by default.
  programs.zsh.enable = true;

  services.lorri.enable = true;

  environment.systemPackages = with pkgs; [
    coreutils
    findutils
    gnugrep
    gnused
  ];

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    brews = [ "hashcat" ];
    casks = [ "obs" "rancher" "postman" "dbeaver-community" "steam" "firefox" ];
  };

  system = {
    primaryUser = "james.behr";
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  ids.gids.nixbld = 30000;

  system.stateVersion = 5;
}

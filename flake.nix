{
  description = "James's system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      nur,
    }:
    {
      nixosConfigurations = {
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ];
        };

        mojito = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit nixpkgs; };
          modules = [
            ./hosts/mojito
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                nur.overlays.default
                (import ./overlays/kitty-themes.nix)
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.james =
                { pkgs, ... }:
                {
                  imports = [ ./home ];
                  home.stateVersion = "22.05";
                  niks = {
                    user = {
                      name = "James Behr";
                      email = "jamesbehr@gmail.com";
                    };
                    nvim.enable = true;
                    desktop = {
                      browser.enable = true;
                      kitty.enable = true;
                      hyprland.enable = true;
                    };
                    dev = {
                      aws.enable = true;
                      c.enable = true;
                      go.enable = true;
                      haskell.enable = true;
                      lua.enable = true;
                      nix.enable = true;
                      node.enable = true;
                      python.enable = true;
                      qmk.enable = true;
                      rust.enable = true;
                      terraform.enable = true;
                      zig.enable = true;
                    };
                  };
                };
            }
          ];
        };
      };

      darwinConfigurations = {
        sidecar = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./hosts/sidecar
            {
              # This is required, otherwise your home directory is assumed to be
              # "/var/empty" which doesn't exist.
              # See https://github.com/LnL7/nix-darwin/issues/423
              users.users."jamesbehr".home = "/Users/jamesbehr";
            }
            home-manager.darwinModules.home-manager
            {
              nixpkgs.overlays = [
                nur.overlays.default
                (import ./overlays/kitty-themes.nix)
              ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."jamesbehr" =
                { pkgs, ... }:
                {
                  imports = [ ./home ];
                  home.stateVersion = "22.05";
                  niks = {
                    user = {
                      name = "James Behr";
                      email = "james.behr@eaglealpha.com";
                    };
                    nvim.enable = true;
                    desktop = {
                      kitty.enable = false;
                      ghostty.enable = true;
                      browser.enable = true;
                    };
                    dev = {
                      ruby.enable = true;
                      python.enable = true;
                      nix.enable = true;
                    };
                  };
                };
            }
          ];
        };
      };
    };
}

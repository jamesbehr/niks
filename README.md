# Niks
Declarative system configuration and dotfile management for all of my machines
using Nix.

## Installation
### NixOS
To automatically select the correct configuration based on your hostname, just
run the following using the repository root as your working directory.

    make switch

You should also remove old generations periodically, to avoid using up all your disk space.
The simplest way to do this is with the `nix-collect-garbage` utility
For example, to delete the generations older than 30 days, and then run the
garbage collector on the Nix store, you can run the following.

    nix-collect-garbage --delete-older-than 30d

This should be done before `nixos-rebuild switch`.

### macOS
To get started, an installation of Nix is required.

    sh <(curl -L https://nixos.org/nix/install)

nix-darwin also manages Homebrew, but this must be installed (if you have not
done so already) before this will work.

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Now clone the repository.

    git clone ssh://git@github.com/jamesbehr/niks ~/niks

You might not have access to Git if this is a fresh machine. In this case you
can just use `nix-shell -p git` to spin up a shell that has `git` installed.

The nix-darwin installer doesn't work with flakes out of the box, so you can
bootstrap it.

    cd ~/niks
    nix build --extra-experimental-features "nix-command flakes" .\#darwinConfigurations.<hostname>.system

If this fails, you probably don't have a `/run` directory. macOS has a
read-only root directory, so you'll need to run the following. The following
only applies on macOS Big Sur (macOS 11) or later.

    printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
    /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

Now you should be able to run the `nix build` command again and have it
complete successfully.

The bootstrap process creates a `darwin-rebuild` binary that you can then use
to initially install the flake. This will correctly select the correct
configuration based on you hostname, just like the NixOS command.

    ./result/sw/bin/darwin-rebuild switch --flake .

After this, the `darwin-rebuild` binary should be in your PATH, so you can just
run the following to update your system after making changes to the
configuration.

    make switch

### Live CD
You can build the custom ISO by running the following command using the
repository root as your working directory.

    nix build .#nixosConfigurations.iso.config.system.build.isoImage

This will create an installation image which you can use to create a bootable
flash drive.

    dd status=progress bs=1M if=./result/iso/nixos-*.iso of=/dev/disk/by-id/<flashdrive>

## Hosts
| Hostname       | OS    | Description              |
|----------------|-------|--------------------------|
| `mojito`       | NixOS | Primary desktop system   |
| `sidecar`      | macOS | 2021 16-inch MacBook Pro |

## Resources
### Manuals
- [Nix](https://nixos.org/manual/nix/stable/)
- [NixOS](https://nixos.org/manual/nixos/stable/)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [Home Manager Appendix](https://rycee.gitlab.io/home-manager/options.html)
- [Nix Darwin](https://daiderd.com/nix-darwin/manual/index.html)

### Reference
- [NixOS Modules](https://nixos.wiki/wiki/NixOS_modules)

### Flakes
- Introduction to Flakes by Eelco Dolstra
  - [Part 1](https://www.tweag.io/blog/2020-05-25-flakes)
  - [Part 2](https://www.tweag.io/blog/2020-06-25-eval-cache)
  - [Part 3](https://www.tweag.io/blog/2020-07-31-nixos-flakes)
- [NixOS Wiki](https://nixos.wiki/wiki/Flakes)
- [Home Manager](https://nix-community.github.io/home-manager/index.html#sec-flakes-nixos-module)

### Articles
- [Nix Darwin Introduction](https://xyno.space/post/nix-darwin-introduction)

### Configurations
- https://gitlab.com/liketechnik/nixos-files
- https://github.com/srid/nixos-config
- https://github.com/EdenEast/nyx
- https://github.com/sherubthakur/dotfiles
- https://github.com/Misterio77/nix-starter-configs
- https://github.com/danielphan2003/flk
- https://github.com/davidtwco/veritas

# raspberrypi config

Home-manager profile for the `raspberrypi` host (Debian 12, aarch64). Configs come from the
[dotfiles](https://github.com/talonlikeaclaw/dotfiles) flake input; Nix installs packages and
links them.

## Bootstrap (once)

```sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/talonlikeaclaw/pi-config ~/Code/pi-config
cd ~/Code/pi-config && nix run home-manager -- switch --flake .#talon@raspberrypi
exec zsh
```

## Commands

```sh
nix flake check
nh home switch . -c talon@raspberrypi
nix flake update dotfiles && nh home switch . -c talon@raspberrypi
```

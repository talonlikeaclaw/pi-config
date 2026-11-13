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

### omp skills

omp reads skills from `~/.omp/agent/skill-sources/*` and `~/.omp/agent/manual-skills`, declared in
its own `config.yml`. Those directories are **git submodules of the `dotfiles` repo** — and a
gitlink contributes an empty directory to a flake input, so they cannot arrive through `dotfiles`.
Each skill repository is therefore pinned as its own `flake = false` input (`skill-caveman`,
`skill-ponytail`, …) and assembled into `~/.omp/agent/skill-sources` with `pkgs.linkFarm`.

To bump a skill set: `nix flake update skill-caveman` (or all at once with `nix flake update`).

### Debian-side services (manual, outside Nix)

`tailscale` and `docker` are installed as **clients only** — home-manager cannot enable system
daemons. The Debian `tailscaled` / `dockerd` keep running as they are:

```sh
sudo tailscale up
sudo systemctl enable --now docker
```

## Commands

```sh
nix flake check
nh home switch . -c talon@raspberrypi
nix flake update dotfiles && nh home switch . -c talon@raspberrypi
```

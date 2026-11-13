# raspberrypi config

Standalone home-manager flake for the `raspberrypi` host (Debian 12 aarch64). Not a NixOS config.

## Commands

- **Apply:** `nh home switch . -c talon@raspberrypi`
- **Test:** `nh home test . -c talon@raspberrypi`
- **Validate:** `nix flake check` — must pass before committing
- **Update dotfiles pin:** `nix flake update dotfiles`

## Structure

- `flake.nix` — inputs (nixpkgs, home-manager, herdr v0.9.5, dotfiles, 8 `skill-*` repos) and the `talon@raspberrypi` output
- `home/raspberrypi.nix` — packages, module imports, home-manager options
- `home/zsh.nix`, `home/starship.nix`, `home/fastfetch.nix`, `home/television.nix` — copied from `nixos-config/home/`, identical content
- `home/lazygit.nix` — copied from `nixos-config/home/`, identical content
- `home/herdr.nix`, `home/omp.nix` — copied from `nixos-config/home/`, arm64 package URLs
- `home/sdr.nix` — rtl-sdr / rtl_433 / SoapySDR / GNU Radio stack
- `home/server.nix` — tailscale, docker, ssh client config, nh

## Conventions

- Dotfiles are linked via `xdg.configFile` / `home.file` pointing at `${dotfiles}/...`; edit configs in the dotfiles repo and bump the pin
- `nixpkgs.config.allowUnfree = true` in `home/raspberrypi.nix`
- New files need `git add` before `nix flake check` (flakes read the git index)
- `programs.*` home-manager modules are used where they exist (`git`, `bat`, `zsh`, `starship`, `fzf`, `eza`, `zoxide`, `direnv`, `ssh`, `lazygit`)
- No tmux: `herdr` is the terminal multiplexer here, with the sesh plugin (`sesh` package installed alongside)
- `neovim` is installed plain — no `programs.neovim`, no LSP/formatter set, no config links
- No `opencode`: omp is the agent here. omp reads skills from `~/.omp/agent/skill-sources/*` and `~/.omp/agent/manual-skills` (declared in its own `config.yml`), independent of opencode
- Skill repos are separate `flake = false` inputs, not `dotfiles` submodules — a gitlink is an empty directory in a flake input. `home/omp.nix` assembles them with `pkgs.linkFarm`; bump with `nix flake update skill-<name>`

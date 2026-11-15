{ lib, pkgs, ... }:

{
  imports = [
    ./fastfetch.nix
    ./herdr.nix
    ./lazygit.nix
    ./omp.nix
    ./server.nix
    ./sdr.nix
    ./ssh.nix
    ./starship.nix
    ./television.nix
    ./zsh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "talon";
    homeDirectory = "/home/talon";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    cargo
    delta
    eza
    fastfetch
    fd
    fzf
    git
    htop
    jq
    neovim
    ripgrep
    sesh
    television
    yazi
  ];

  programs.bat = {
    enable = true;
    config.theme = "base16";
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "talonlikeaclaw";
      user.email = "talonlikeaclaw@proton.me";
      init.defaultBranch = "main";
      diff.colorMoved = "default";
    };
    ignores = [
      "*.swp"
      "*.swo"
      "*~"
      "#*#"
      "*.log"
      ".direnv/"
      ".envrc"
      ".env*"
      "node_modules/"
      ".idea/"
      ".vscode/"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = false;
      line-numbers = true;
      syntax-theme = "Catppuccin Mocha";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}

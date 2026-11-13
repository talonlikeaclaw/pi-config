{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    docker-compose
    nh
    nix-output-monitor
    nix-tree
    tailscale
  ];
}

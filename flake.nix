{
  description = "talon's raspberrypi config (Debian + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    herdr = {
      url = "github:herdrdev/herdr/v0.9.5";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:talonlikeaclaw/dotfiles";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      herdr,
      dotfiles,
      ...
    }:
    let
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."talon@raspberrypi" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/raspberrypi.nix ];
        extraSpecialArgs = { inherit herdr dotfiles; };
      };

      packages.${system}.default = self.homeConfigurations."talon@raspberrypi".activationPackage;
    };
}

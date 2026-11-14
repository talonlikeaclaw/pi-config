{
  description = "talon's raspberrypi config (Debian + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:talonlikeaclaw/dotfiles";
      flake = false;
    };

    # omp skill sources. These are git submodules of `dotfiles`, and a gitlink
    # contributes an empty directory to a flake input, so each repository is
    # pinned here directly instead of arriving through `dotfiles`.
    skill-caveman = {
      url = "github:JuliusBrussee/caveman";
      flake = false;
    };
    skill-ponytail = {
      url = "github:DietrichGebert/ponytail";
      flake = false;
    };
    skill-anthropics = {
      url = "github:anthropics/skills";
      flake = false;
    };
    skill-vercel = {
      url = "github:vercel-labs/agent-skills";
      flake = false;
    };
    skill-mattpocock = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    skill-supabase = {
      url = "github:supabase/agent-skills";
      flake = false;
    };
    skill-impeccable = {
      url = "github:pbakaus/impeccable";
      flake = false;
    };
    skill-superpowers = {
      url = "github:obra/superpowers";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      dotfiles,
      skill-caveman,
      skill-ponytail,
      skill-anthropics,
      skill-vercel,
      skill-mattpocock,
      skill-supabase,
      skill-impeccable,
      skill-superpowers,
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
        extraSpecialArgs = {
          inherit
            dotfiles
            skill-caveman
            skill-ponytail
            skill-anthropics
            skill-vercel
            skill-mattpocock
            skill-supabase
            skill-impeccable
            skill-superpowers
            ;
        };
      };

      packages.${system}.default = self.homeConfigurations."talon@raspberrypi".activationPackage;
    };
}

{
  lib,
  pkgs,
  dotfiles,
  ...
}:

let
  herdrPackage = pkgs.stdenvNoCC.mkDerivation {
    pname = "herdr";
    version = "0.9.5";

    src = pkgs.fetchurl {
      url = "https://github.com/herdrdev/herdr/releases/download/v0.9.5/herdr-linux-aarch64";
      hash = "sha256-F9dTby2lCFlSNoDvJ53/ysjkojX05G/o2mwuxEFBiXw=";
    };

    dontUnpack = true;

    installPhase = ''
      install -Dm755 "$src" "$out/bin/herdr"
    '';
  };
in
{
  home.packages = [ herdrPackage ];

  xdg.configFile."herdr/config.toml".source = "${dotfiles}/herdr/.config/herdr/config.toml";
}

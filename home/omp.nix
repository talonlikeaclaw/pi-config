{ dotfiles, lib, pkgs, ... }@args:

let
  version = "18.18.1";

  # Each skill repository is a separate flake input, linked at the path that
  # omp's config.yml expects under ~/.omp/agent/skill-sources/<name>. The link
  # points at the repository root so the customDirectories entries in
  # dotfiles/omp/.omp/agent/config.yml (which append /skills, /skills/engineering
  # or /.agents/skills) resolve.
  skillSources = {
    caveman = args.skill-caveman;
    ponytail = args.skill-ponytail;
    anthropics-skills = args.skill-anthropics;
    vercel-agent-skills = args.skill-vercel;
    mattpocock-skills = args.skill-mattpocock;
    supabase-agent-skills = args.skill-supabase;
    impeccable = args.skill-impeccable;
  };

  omp = pkgs.stdenvNoCC.mkDerivation {
    pname = "omp";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/omp-linux-arm64";
      hash = "sha256-O9dpn+fqY6jrFPJykNnTxqVuVTiL72xWDLE52AkzBSg=";
    };

    dontUnpack = true;

    installPhase = ''
      install -Dm755 "$src" "$out/bin/omp"
    '';
  };
in
{
  home.packages = [ omp ];

  home.file = lib.optionalAttrs (builtins.pathExists "${dotfiles}/omp/.omp/agent/mcp.json") {
    ".omp/agent/mcp.json".source = "${dotfiles}/omp/.omp/agent/mcp.json";
  }
  // {
    # config.yml declares these as skills.customDirectories; without the links
    # omp silently loads zero skills on this host.
    ".omp/agent/skill-sources".source = pkgs.linkFarm "omp-skill-sources" (
      lib.mapAttrsToList (name: path: {
        inherit name;
        inherit path;
      }) skillSources
    );
    ".omp/agent/manual-skills".source = "${dotfiles}/omp/.omp/agent/manual-skills";
    # manual-skills/superpowers reads its workflows from this path.
    ".omp/agent/skills/superpowers/reference".source = args.skill-superpowers;
  };

  # OMP writes preferences atomically; a Home Manager source link points into
  # /nix/store and therefore cannot serve as its live configuration file. The
  # copy below only seeds a fresh install, since omp rewrites the file afterwards
  # (setupVersion, model roles, theme). The skills block is re-applied on every
  # switch instead: omp reads customDirectories only from the live file, so an
  # omp-written config without it loads zero skills on this host.
  home.activation.installOmpConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    config="$HOME/.omp/agent/config.yml"

    if [ -L "$config" ]; then
      rm "$config"
    fi

    if [ ! -e "$config" ]; then
      mkdir -p "$(dirname "$config")"
      cp "${dotfiles}/omp/.omp/agent/config.yml" "$config"
      chmod u+w "$config"
    fi

    dotfilesConfig=$(mktemp -d)
    cp "${dotfiles}/omp/.omp/agent/config.yml" "$dotfilesConfig/config.yml"
    for key in $(PI_CODING_AGENT_DIR="$dotfilesConfig" ${omp}/bin/omp config list --json --scope=global | ${pkgs.jq}/bin/jq -r 'keys[] | select(startswith("skills."))'); do
      value=$(PI_CODING_AGENT_DIR="$dotfilesConfig" ${omp}/bin/omp config get "$key" --json | ${pkgs.jq}/bin/jq -c '.value')
      ${omp}/bin/omp config set "$key" "$value"
    done
    rm -rf "$dotfilesConfig"
  '';
}

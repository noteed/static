{ nixpkgs ? <nixpkgs>
}:

let
  pkgs = import nixpkgs {};
  lib = pkgs.lib;

  design-system-version = "da8585ecaa62c00d5e32b490581ef41ee09d79d5";
  design-system = pkgs.fetchFromGitHub {
    owner = "hypered";
    repo = "design-system";
    rev = design-system-version;
    sha256 = "1za6hf9ba7wvd0d2y4g0zn7vnvkfqmhpgq5sipc7yj7cxq24b941";
  };
  inherit (import design-system {}) template lua-filter static;

  to-html = src: pkgs.runCommand "html" {} ''
    ${pkgs.pandoc}/bin/pandoc \
      --from markdown \
      --to html \
      --standalone \
      --template ${template} \
      -M prefix="" \
      -M font="ibm-plex" \
      --lua-filter ${lua-filter} \
      --output $out \
      ${./metadata.yml} \
      ${src}
  '';

in rec
{
  # nix-instanciate --eval --strict site/ -A md.index
  md.index = ../README.md;

  # nix-build site/ -A html.index
  html.index = to-html md.index;

  html.all = pkgs.runCommand "all" {} ''
    mkdir -p $out
    cp -r ${static} $out/static
    cp ${html.index} $out/index.html
  '';

  inherit static;
}

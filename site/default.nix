{ nixpkgs ? <nixpkgs>
}:

let
  pkgs = import nixpkgs {};
  design-system-version = "da8585ecaa62c00d5e32b490581ef41ee09d79d5";
  design-system = pkgs.fetchFromGitHub {
    owner = "hypered";
    repo = "design-system";
    rev = design-system-version;
    sha256 = "1za6hf9ba7wvd0d2y4g0zn7vnvkfqmhpgq5sipc7yj7cxq24b941";
  };
  inherit (import design-system {}) static;

in
{
  inherit static;
}

{
  description = "Python environment for simplicial voting project";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.poetry2nix = {
    url = "github:nix-community/poetry2nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (poetry2nix.legacyPackages.${system}) mkPoetryEnv;
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default =
          let
            simplicial-voting = poetry2nix.legacyPackages.${system}.mkPoetryEnv {
              projectDir = ./.;
            };
          in simplicial-voting.env;
      });
}

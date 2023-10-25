{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";

  outputs = { self, nixpkgs, poetry2nix }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
      {
        # packages = forAllSystems (system: {
        #   default = poetry2nix.legacyPackages.${system}.mkPoetryApplication { projectDir = self; };
        # });

        devShells = forAllSystems (system: {
          default = pkgs.${system}.mkShellNoCC {
            packages = [
              (poetry2nix.legacyPackages.${system}.mkPoetryEnv { projectDir = self; })
              poetry2nix.poetry
            ];
          };
        });
      };
}

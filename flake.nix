{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        packageName = "calendar-halogen";
      in {
        defaultPackage = self.packages.${system}.${packageName};

        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            purescript
            esbuild
            spago
            nodePackages.purescript-language-server
            nodePackages.pscid
            nodejs-16_x
          ];
        };
      });
}


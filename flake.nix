{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = with pkgs; pkgs.mkShell {
          buildInputs = [
            nodejs-18_x
            (yarn.override { nodejs = nodejs-18_x; })
          ];

          shellHook = ''
            if [ ! -d "node_modules" ]
            then
              yarn add caniuse-lite --dev
              npx update-browserslist-db@latest
              yarn install
            fi

            yarn unused
            yarn build
          '';
        };
      });
}

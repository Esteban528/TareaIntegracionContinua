{
  description = "minimal flake for js dev";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

  outputs =
    inputs:
    let
      nodeVersion = 24; # Latest LTS

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.self.overlays.default ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: {
        node = final.symlinkJoin {
          name = "nodejs-${toString nodeVersion}-without-npm";
          paths = [ final."nodejs_${toString nodeVersion}" ];
          postBuild = ''
            rm -f $out/bin/npm
            rm -f $out/bin/npx
            rm -f $out/bin/corepack
          '';
        };
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              node
              pnpm

              (writeShellScriptBin "npm" ''
                exec pnpm "$@"
              '')

              (writeShellScriptBin "pn" ''
                exec pnpm "$@"
              '')
            ];
            shellHook = ''
              echo "Development environment loaded"
              mkdir -p .cache/pnpm
              export npm_config_cache=".cache/npm"
              pnpm config set store-dir ~/.cache/pnpm
            '';
          };
        }
      );
    };
}

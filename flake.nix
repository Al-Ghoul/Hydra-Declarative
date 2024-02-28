{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    devenv = {
      url = "github:cachix/devenv/6a30b674fb5a54eff8c422cc7840257227e0ead2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, devenv, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

    in {
      devShells."${system}".default = devenv.lib.mkShell {
        inherit pkgs inputs;

        modules = [
          ({ pkgs, ... }: {

            packages = with pkgs; [ cz-cli yarn ];

            pre-commit.hooks = {

              nil.enable = true;
              nixfmt.enable = true;
              statix.enable = true;
              deadnix.enable = true;

              markdownlint.enable = true;

              commitizen.enable = true;
            };

          })

        ];
      };

    };
}

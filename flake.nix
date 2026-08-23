{
  description = "Declarative Grok Build CLI on Nix (xAI terminal coding agent)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      packagesFor =
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        rec {
          grok-build = pkgs.callPackage ./pkgs/grok-build { };
          default = grok-build;
        };
    in
    {
      packages = forAllSystems packagesFor;

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.grok-build}/bin/grok";
        };
      });

      homeModules.grok-build =
        { lib, pkgs, ... }:
        {
          imports = [ ./modules/home-manager/grok-build.nix ];
          programs.grok-build.package = lib.mkDefault (
            self.packages.${pkgs.stdenv.hostPlatform.system}.grok-build
          );
        };
      homeModules.default = self.homeModules.grok-build;

      overlays.default = final: _prev: {
        inherit (self.packages.${final.stdenv.hostPlatform.system}) grok-build;
      };
    };
}

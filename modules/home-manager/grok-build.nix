{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.grok-build;
in
{
  options.programs.grok-build = {
    enable = mkEnableOption "Grok Build (xAI terminal coding agent via nix-grok-build)";

    package = mkOption {
      type = types.nullOr types.package;
      default = null;
      defaultText = literalExpression "nix-grok-build.packages.\${pkgs.stdenv.hostPlatform.system}.grok-build";
      example = literalExpression "nix-grok-build.packages.\${pkgs.stdenv.hostPlatform.system}.grok-build";
      description = ''
        grok-build package to install. When you import
        `nix-grok-build.homeModules.grok-build` from the flake, this defaults
        to that flake's `grok-build` — you usually do not need to set it.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = lib.optional (cfg.package != null) cfg.package;

    assertions = [
      {
        assertion = cfg.package != null;
        message = ''
          programs.grok-build.package is unset. Import
          nix-grok-build.homeModules.grok-build from the flake
          (which sets a default), or set package explicitly to
          nix-grok-build.packages.''${pkgs.stdenv.hostPlatform.system}.grok-build.
        '';
      }
    ];
  };
}

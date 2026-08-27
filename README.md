<div align="center">

# nix-grok-build

**Grok Build on NixOS** — xAI's terminal coding agent as a pinned static binary.

[![NixOS](https://img.shields.io/badge/NixOS-unstable-informational?logo=NixOS)](https://nixos.org)
[![Flake](https://img.shields.io/badge/Flake-enabled-success)](https://nixos.wiki/wiki/Flakes)

</div>

[Grok Build](https://x.ai/cli) is xAI's terminal coding agent (`grok`). This flake packages the official Linux binaries for `x86_64-linux` and `aarch64-linux` so you can install it declaratively with flakes and Home Manager.

A SuperGrok or X Premium Plus subscription is required to use the agent after install.

## Quick Start

```bash
nix run github:gaavin/nix-grok-build
```

Requires `x86_64-linux` or `aarch64-linux`, and flakes.

## Install with Home Manager

### 1. Add to flake inputs

```nix
{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-grok-build.url = "github:gaavin/nix-grok-build";
    nix-grok-build.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-grok-build, ... }:
    {
      nixosConfigurations.YOUR_CONFIGURATION = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # or aarch64-linux
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.YOUR_USERNAME = import ./home.nix;
              sharedModules = [
                nix-grok-build.homeModules.grok-build
              ];
            };
          }
        ];
      };
    };
}
```

### 2. Enable in `home.nix`

```nix
{
  programs.grok-build.enable = true;
}
```

### 3. Build & launch

```bash
nix flake update nix-grok-build
sudo nixos-rebuild switch --flake .#YOUR_CONFIGURATION
grok
```

On first launch, Grok opens a browser for authentication. In non-browser environments, set `XAI_API_KEY`.

## Commands

| Command | Purpose |
|---------|---------|
| `grok` | Interactive TUI session |
| `grok -p "…"` | Headless / scripting prompt |
| `grok --version` | Show installed version |
| `grok inspect` | Show discovered config / skills / MCP |

## Paths

```
~/.grok/
  auth.json     Login / tokens (created by `grok`)
  config.toml   User config (models, defaults)
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Auth / subscription error | Sign in with a SuperGrok or X Premium Plus account, or set `XAI_API_KEY` |
| Browser auth unavailable | `export XAI_API_KEY=xai-…` then run `grok` |
| Wrong / stale binary | Bump `version` + hashes in `pkgs/grok-build/default.nix`, or `nix flake update nix-grok-build` after a release bump |
| Start fresh | Remove `~/.grok/` |

## Advanced

Package only:

```nix
home.packages = [
  inputs.nix-grok-build.packages.${pkgs.stdenv.hostPlatform.system}.grok-build
];
```

```bash
nix build github:gaavin/nix-grok-build
nix build github:gaavin/nix-grok-build#grok-build
```

Latest upstream version string (for packaging bumps):

```bash
curl -fsSL https://x.ai/cli/stable
```

## Credits

- [xAI / Grok Build](https://x.ai/cli) — official CLI and docs
- [xai-org/grok-build](https://github.com/xai-org/grok-build) — open-source agent runtime

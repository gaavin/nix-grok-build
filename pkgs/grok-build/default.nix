{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "1.0.41";
  sources = {
    x86_64-linux = {
      url = "https://x.ai/cli/grok-${version}-linux-x86_64";
      hash = "sha256-nOA+0j4W6gEHK0SWJj1iE6J4meHj4QfwCNNu34LnBAc=";
    };
    aarch64-linux = {
      url = "https://x.ai/cli/grok-${version}-linux-aarch64";
      hash = "sha256-fAuMlzr2p44gN/Ge2TAzRxuMXnIvn/BLhrCS4GbmDXQ=";
    };
  };
in
stdenvNoCC.mkDerivation {
  pname = "grok-build";
  inherit version;

  src = fetchurl sources.${system};

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/grok
    runHook postInstall
  '';

  meta = {
    description = "Grok Build — xAI terminal coding agent";
    homepage = "https://x.ai/cli";
    license = lib.licenses.asl20;
    mainProgram = "grok";
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

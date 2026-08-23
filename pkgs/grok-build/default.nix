{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  version = "1.0.5";
  sources = {
    x86_64-linux = {
      url = "https://x.ai/cli/grok-${version}-linux-x86_64";
      hash = "sha256-m6h0ROGBno9hBK279GdqhwwgQ4CqXD4cOKkmxOpncjg=";
    };
    aarch64-linux = {
      url = "https://x.ai/cli/grok-${version}-linux-aarch64";
      hash = "sha256-HB/mfXw1SX+wn0SkUfV6zDeHrdTJrqLFb1x8ddxf/PE=";
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

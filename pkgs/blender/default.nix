{pkgs}: let
  inherit (pkgs) lib stdenv;
  # https://github.com/NixOS/nixpkgs/pull/487020
  sse2neon = pkgs.sse2neon.overrideAttrs {doCheck = false;};
in
  (pkgs.blender.overrideAttrs (final: prev: {
    patches = prev.patches ++ lib.optional stdenv.hostPlatform.isDarwin ./darwin.patch;
    meta.broken = false;
  })).override {inherit sse2neon;}

{
  cmake,
  fetchFromGitHub,
  ffmpeg_7,
  fftwFloat,
  lib,
  libjack2,
  libsndfile,
  openal,
  pipewire,
  pkg-config,
  pulseaudio,
  python3,
  python3Packages,
  rubberband,
  SDL2,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "audaspace";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "audaspace";
    repo = "audaspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1Ms6HyisIzIm74u93ybdSpQpCNZidMl6zfCX4evCyBE=";
  };

  nativeBuildInputs = [cmake pkg-config python3Packages.setuptools];

  buildInputs =
    [
      ffmpeg_7
      fftwFloat
      libsndfile
      python3
      python3Packages.numpy
      rubberband
      SDL2
    ]
    ++ (
      if (!stdenv.hostPlatform.isDarwin)
      then [
        libjack2
        openal
        pipewire
        pulseaudio
      ]
      else []
    );

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DEMOS" false)
    (lib.cmakeFeature "DEFAULT_PLUGIN_PATH" "${placeholder "out"}/share/audaspace/plugins")
    "-Wno-dev"
  ];

  meta = {
    description = "A high level audio library written in C++11 with language bindings";
    homepage = "https://audaspace.github.io";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = ["yrns"];
    sourceProvenance = with lib.sourceTypes; [fromSource];
  };
})

{ lib,
  stdenv,
  fetchurl,
  #autoPatchelfHook,
  makeWrapper,
  glib,
  udev,
  dbus,
  zlib,
  fontconfig,
  libGL,
  libxkbcommon_7,
  sqlite,
  libpulseaudio,
  xorg
}:

stdenv.mkDerivation rec {
  pname = "talon";
  version = "0.1.5";

  src = fetchurl {
    url = "https://talonvoice.com/dl/latest/talon-linux.tar.xz";
    sha256 = "08ssgq5j3lyb5q6nmpi5rsf30fr46grqjs1pdxsakf8m26fgysyr";
  };

  nativeBuildInputs = [
    #autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [
    stdenv.cc.cc glib udev dbus zlib fontconfig libGL libxkbcommon_7 sqlite libpulseaudio
  ] ++ (with xorg; [ libX11 libxcb libXrender ]);

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;

  # TODO: tobii udev rules?
  installPhase = ''
    runHook preInstall
    mkdir -p $out/{opt,bin}
    tar -C $out/opt -xaf $src
    rm $out/opt/talon/run.sh
    runHook postInstall
  '';

  postFixup = let
    opt = "$out/opt/talon";
    libs = "${opt}/lib"
           + ":${opt}/resources/python/lib"
           + ":${opt}/resources/talon/pypy/lib"
           + ":" + lib.makeLibraryPath buildInputs;

  # need to patch python3 for "view log" and repl
  in ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ${opt}/talon ${opt}/resources/python/bin/python3

    makeWrapper ${opt}/talon $out/bin/talon \
      --unset QT_AUTO_SCREEN_SCALE_FACTOR \
      --unset QT_SCALE_FACTOR \
      --set LC_NUMERIC C \
      --set QT_PLUGIN_PATH "${opt}/plugins" \
      --prefix LD_LIBRARY_PATH ":" ${libs}
  '';

  meta = {
    description = "Powerful hands-free input";
    homepage = "https://talonvoice.com";
  };
}

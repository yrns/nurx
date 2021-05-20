{ stdenv, lib, fetchurl, cudatoolkit }:

stdenv.mkDerivation rec {
  pname = "alicevision-bin";
  version = "2021.1.0";

  src = fetchurl {
    url = "https://github.com/alicevision/meshroom/releases/download/v${version}/Meshroom-${version}-linux-cuda10.tar.gz";
    sha256 = "1r4ysy93i5mc2l5nn29v8i66pk3bb5hlg71j6rdxac2v9ckfp56y";
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  #nativeBuildInputs = [ cudatoolkit ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r aliceVision/bin/* $out/bin/

    mkdir -p $out/share
    cp -r aliceVision/share/* $out/share/

    mkdir -p $out/lib
    cp -r aliceVision/lib/* $out/lib/
  '';

  # need \$ORIGIN ? wrapProgram?
  # ${ORIGIN}/../lib:${ORIGIN}/lib
  preFixup = ''
    find $out/bin/* -executable -type f -exec patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc ]}:$out/lib" {} \;
    find $out/lib/* -executable -type f -exec patchelf \
      --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc ]}:$out/lib" {} \;
  '';
}

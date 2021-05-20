{ stdenv, lib, fetchurl, alicevision-bin }:

stdenv.mkDerivation rec {
  pname = "meshroom-bin";
  version = "2021.1.0";

  src = fetchurl {
    url = "https://github.com/alicevision/meshroom/releases/download/v${version}/Meshroom-${version}-linux-cuda10.tar.gz";
    sha256 = "1r4ysy93i5mc2l5nn29v8i66pk3bb5hlg71j6rdxac2v9ckfp56y";
  };

  # since alivevision builds maybe use that?
  buildInputs = [ alicevision-bin ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    mkdir -p $out/bin
    cp Meshroom meshroom_batch meshroom_compute $out/bin/

    mkdir -p $out/share/meshroom
    cp *.md $out/share/meshroom

    mkdir -p $out/lib
    cp -r lib/* $out/lib
    cp -r qtPlugins $out/lib
  '';

  preFixup = ''
    find $out/bin/* -executable -type f -exec patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc ]}:$out/lib" {} \;
    find $out/lib/* -executable -type f -exec patchelf \
      --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc ]}:$out/lib" {} \;
  '';
}

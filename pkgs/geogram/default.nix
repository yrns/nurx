{ stdenv, fetchurl, cmake, pkg-config, glfw3 }:

stdenv.mkDerivation rec {
  pname = "geogram";
  version = "1.7.6";

  src = fetchurl {
    # there is also a mirror at https://github.com/alicevision/geogram
    url = "https://gforge.inria.fr/frs/download.php/file/38361/geogram_v${version}.tar.gz";
    sha256 = "sha256:0hl15vf1kx1sq72kpll6ndzdj3i6r9pgfx966nq9wkh1m9dxcmj4";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ glfw3 ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DVORPALINE_PLATFORM=Linux64-gcc-dynamic"
    "-DGEOGRAM_LIB_ONLY=ON"
    #"-DGEOGRAM_USE_SYSTEM_GLFW3=ON"
    "-DGEOGRAM_WITH_GRAPHICS=OFF"
    "-DGEOGRAM_WITH_LUA=OFF"
  ];

  meta = {
    description = "A library of geometric algorithms";
    homepage = http://alice.loria.fr/index.php/software.html;
  };
}

{ stdenv, fetchurl, cmake, pkg-config, bzip2, cbc, clp, glpk }:

stdenv.mkDerivation rec {
  pname = "coin-or-lemon";
  version = "1.3.1";

  src = fetchurl {
    url = "http://lemon.cs.elte.hu/pub/sources/lemon-${version}.tar.gz";
    sha256 = "1j6kp9axhgna47cfnmk1m7vnqn01hwh7pf1fp76aid60yhjwgdvi";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ bzip2 cbc clp glpk ];

  meta = {
    description = "A C++ template library providing many common graph algorithms";
    homepage = http://lemon.cs.elte.hu/trac/lemon;
  };
}

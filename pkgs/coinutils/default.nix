{ stdenv, fetchurl, pkg-config, gfortran, zlib, bzip2, glpk, blas }:

stdenv.mkDerivation rec {
  pname = "coinutils";
  version = "2.11.4";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/CoinUtils/CoinUtils-${version}.tgz";
    sha256 = "1b24f8f6057661b3225d24f4e671527f53bf13aff66e06cbbbd4f20cc7d31dce";
  };

  nativeBuildInputs = [ pkg-config gfortran ];
  buildInputs = [ zlib bzip2 glpk blas ];

  meta = {
    description = "COIN-OR collection of utility classes";
    homepage = https://projects.coin-or.org/CoinUtils;
  };
}

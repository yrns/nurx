{ stdenv, fetchFromGitHub, cmake, pkg-config, boost, eigen, flann, clp, osi, coinutils, coin-or-lemon, glog, ceres-solver, suitesparse, blas, lapack, openexr, openimageio2, cudatoolkit_11, zlib, geogram }:

# TODO: missing tbb and metis, does ceres-solver need these inputs too?

let
  # TODO: the right solution is to use flakes? this requires unstable?
  # need this fix: https://github.com/OpenImageIO/oiio/pull/2914
  openimageio2-fix = openimageio2.overrideAttrs (old: rec {
    version = "2.2.14.0";
    src = fetchFromGitHub {
      owner = "OpenImageIO";
      repo = "oiio";
      rev = "Release-${version}";
      sha256 = "1pbf8d3drwqw22zaapqx1kg0dkyx59afx4vl0bki1brqgkdq4hkh";
    };
  });
in stdenv.mkDerivation rec {
  pname = "alicevision";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "AliceVision";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zgyzy69wns6dqjmnjvj6wnr4s8n4c0x295xqgym77h20n80n6gm";
    #fetchSubmodules = true;
  };

  # patch this error?
  # src/dependencies/osi_clp/CoinUtils/src/CoinMessageHandler.cpp:823:35
  hardeningDisable = [ "format" ];

  #patches = [ ./cmake_cxx_std_14.patch ];

  nativeBuildInputs = [ cmake pkg-config ];

  # use all external dependencies
  buildInputs = [ boost eigen flann clp osi coinutils coin-or-lemon glog ceres-solver suitesparse blas lapack openexr openimageio2-fix cudatoolkit_11 zlib geogram ];

  cmakeFlags = [
    #"-DEIGEN_INCLUDE_DIR_HINTS=${eigen}/include/eigen3"
    "-DFLANN_INCLUDE_DIR_HINTS=${flann}/include/flann"
    "-DCLP_INCLUDE_DIR_HINTS=${clp}/include/coin"
    "-DOSI_INCLUDE_DIR_HINTS=${osi}/include/coin"
    "-DCOINUTILS_INCLUDE_DIR_HINTS=${coinutils}/include/coin"
    "-DLEMON_INCLUDE_DIR_HINTS=${coin-or-lemon}/include/lemon"
    "-DCERES_DIR=${ceres-solver}/include/ceres"
    "-DBOOST_NO_CXX11=ON"
  ];

  meta = {
    description = "Photogrammetric Computer Vision Framework which provides a 3D Reconstruction and Camera Tracking algorithms";
    homepage = https://alicevision.github.io;
  };
}

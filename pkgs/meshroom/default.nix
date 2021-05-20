{ fetchurl, python3, cmake, alicevision, openimageio, qt5 }:

let
  # this fixes the 1980 issue w/ zipfiles
  # cx_Freeze = python3.pkgs.cx_Freeze.overrideAttrs (old: {
  #   prePatch = "";
  #   patches = [ ./mtime.patch ];
  # });
in python3.pkgs.buildPythonPackage rec {
  pname = "meshroom";
  version = "2021.1.0";

  src = fetchurl {
    url = "https://github.com/alicevision/${pname}/archive/refs/tags/v${version}.tar.gz";
    sha256 = "012l55d36gvfad4pfw9d2jkn0bbbsbylqx3hc38lm4ri46w95x0l";
  };

  ALICEVISION_SENSOR_DB = "${alicevision}/share/aliceVision/sensorDB/cameraSensors.db";
  #ALICEVISION_VOCTREE=/path/to/voctree

  #nativeBuildInputs = with python3.pkgs; [ cx_Freeze idna ];
  #propagatedBuildInputs = with python3.pkgs; [ importlib-metadata ];
  buildInputs = [ alicevision ];

  meta = {
    description = "3D Reconstruction Software based on the AliceVision framework";
    homepage = https://alicevision.github.io;
  };
}

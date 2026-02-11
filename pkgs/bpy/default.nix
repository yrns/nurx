{
  blender,
  lib,
  pkg-config,
  python311,
  python311Packages,
  stdenv,
}:
python311Packages.buildPythonPackage {
  inherit (blender) version src patches postPatch preConfigure buildInputs pythonPath;

  pname = "bpy";

  # Blender has its own script to build a wheel.
  pyproject = false;

  cmakeFlags =
    blender.cmakeFlags
    ++ [
      "-C../build_files/cmake/config/bpy_module.cmake"
      # (lib.cmakeBool "WITH_PYTHON_SAFETY" true)
      (lib.cmakeBool "WITH_INSTALL_PORTABLE" true)
      (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/${python311.sitePackages}")
    ];

  # Remove wrapPython? Not sure why the Python module requires pkg-config.
  nativeBuildInputs = blender.nativeBuildInputs ++ [pkg-config]; # needed for bpy?

  propagatedBuildInputs = blender.pythonPath;

  meta =
    builtins.removeAttrs blender.meta ["mainProgram"]
    // {
      description = "Blender Python module";
      homepage = "https://builder.blender.org/download/bpy/";
    };
}

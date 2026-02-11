{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}: let
  version = "20260211";
in
  # For use with ty. There is also https://github.com/mysticfall/bpystubgen and https://pypi.org/project/blender-stubs/ (which seems out of date).
  buildPythonPackage {
    pname = "fake-bpy-module";
    inherit version;
    pyproject = true;
    # wheel = true;

    src = fetchPypi {
      inherit version;
      pname = "fake_bpy_module";
      hash = "sha256-ei+MOiErDpF1Lptv5m14VDtLfXwrS+gYJk+uB65WxNo=";
    };

    build-system = [setuptools];

    meta = {
      description = "Fake Blender Python API module collection for the code completion";
      homepage = "https://github.com/nutti/fake-bpy-module";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  }

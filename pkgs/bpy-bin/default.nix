{
  autoPatchelfHook,
  blender,
  buildPythonPackage,
  fetchurl,
  lib,
  materialx,
  numpy_1,
  pkgs,
  requests,
  stdenv,
  zstandard,
}: let
  system = stdenv.hostPlatform.system;
  version = "5.0.1";
  plat =
    {
      x86_64-darwin = "macosx_11_0_x86_64";
      aarch64-darwin = "macosx_11_0_arm64";
      x86_64-linux = "manylinux_2_28_x86_64";
      x86_64-windows = "win_amd64";
      aarch64-windows = "win_arm64";
    }
    .${
      system
    } or (throw "Unsupported system: ${system}");
  sums = builtins.listToAttrs (map (line: let
      pair = lib.strings.splitString "  " line;
    in {
      name = builtins.elemAt pair 1;
      value = builtins.elemAt pair 0;
    })
    # fetchurl { url = "https://download.blender.org/pypi/bpy/SHA256SUMS"; hash = "sha256-j7iWzn5BtrsM78cPDiMHhtkhZL2Y50Oii5c13PK8fzc="; }
    (lib.strings.splitString "\n" (lib.strings.removeSuffix "\n" (builtins.readFile ./SHA256SUMS))));
  whl = "bpy-${version}-cp311-cp311-${plat}.whl";
in
  buildPythonPackage {
    pname = "bpy-bin";
    inherit version;
    format = "wheel";

    # https://pypi.org/project/bpy only has the latest version
    # https://builder.blender.org/download/bpy/ ?
    src = fetchurl {
      url = "https://download.blender.org/pypi/bpy/${whl}";
      sha256 = sums.${whl};
    };

    propagatedBuildInputs = [
      materialx
      numpy_1
      requests
      zstandard
    ];

    meta = {
      homepage = "https://www.blender.org";
      description = "Blender Python module.";
      license = blender.meta.license;
      platforms = lib.platforms.all;
      # No official build for aarch64-linux.
      badPlatforms = ["aarch64-linux"];
    };
  }
  // lib.mkIf stdenv.hostPlatform.isLinux {
    nativeBuildInputs = [autoPatchelfHook];

    # The wheel includes many libs already. We include all Blender's inputs too (minus optional ones).
    buildInputs = blender.buildInputs;

    # These are possibly missing optional Blender dependencies.
    autoPatchelfIgnoreMissingDeps = ["libamdhip64.so.6" "libcuda.so.1" "libze_loader.so.1"];
    # autoPatchelfIgnoreMissingDeps = [ "*" ];
  }

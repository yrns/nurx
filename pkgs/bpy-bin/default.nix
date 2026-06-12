{
  autoPatchelfHook,
  blender,
  buildPythonPackage,
  cattrs,
  charset-normalizer,
  cython,
  fetchurl,
  lib,
  materialx,
  numpy,
  python,
  requests,
  runCommand,
  stdenv,
  # toPythonModule,
  zstandard,
}:
let
  system = stdenv.hostPlatform.system;
  version = "5.1.2";
  plat =
    {
      x86_64-darwin = "macosx_11_0_x86_64";
      aarch64-darwin = "macosx_11_0_arm64";
      x86_64-linux = "manylinux_2_28_x86_64";
      x86_64-windows = "win_amd64";
      aarch64-windows = "win_arm64";
    }
    .${system} or (throw "Unsupported system: ${system}");
  sums = builtins.listToAttrs (
    map
      (
        line:
        let
          pair = lib.strings.splitString "  " line;
        in
        {
          name = builtins.elemAt pair 1;
          value = builtins.elemAt pair 0;
        }
      )
      # fetchurl { url = "https://download.blender.org/pypi/bpy/SHA256SUMS"; hash = "sha256-j7iWzn5BtrsM78cPDiMHhtkhZL2Y50Oii5c13PK8fzc="; }
      (lib.strings.splitString "\n" (lib.strings.removeSuffix "\n" (builtins.readFile ./SHA256SUMS)))
  );
  whl = "bpy-${version}-cp313-cp313-${plat}.whl";
  bpy-bin = buildPythonPackage (
    {
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
        cattrs
        charset-normalizer
        cython
        materialx
        numpy
        requests
        zstandard
      ];

      meta = {
        homepage = "https://builder.blender.org/download/bpy/";
        description = "Blender Python module.";
        license = blender.meta.license;
        # No official build for aarch64-linux.
        platforms = # lib.platforms.all;
          [
            "aarch64-darwin"
            "x86_64-darwin"
            "x86_64-linux"
            "x86_64-windows"
            "aarch64-windows"
          ];
        # badPlatforms = [ ];
      };
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      nativeBuildInputs = [ autoPatchelfHook ];

      # The wheel includes many libs already. We include all Blender's inputs too (minus optional ones).
      buildInputs = # builtins.trace blender.buildInputs
        blender.buildInputs;

      # These are possibly missing optional Blender dependencies.
      autoPatchelfIgnoreMissingDeps = [
        "libamdhip64.so.6"
        "libcuda.so.1"
        "libze_loader.so.1"
      ];
      # autoPatchelfIgnoreMissingDeps = [ "*" ];
    }
  );
in
# toPythonModule and/or finalAttrs causes a stack overflow. "old" attributes are just attributes, not a derivation.
bpy-bin.overridePythonAttrs (
  old:
  let
    env =
      # assert lib.asserts.assertMsg (old.pythonModule == python) "invalid pythonModule";
      python.withPackages (_: [ bpy-bin ]);
  in
  {
    passthru = (old.passthru or { }) // {
      tests.smoke =
        runCommand "bpy-bin-smoke"
          {
            # buildInputs = [ env ];
          }
          ''
            # ${lib.getExe env} -c "import sys; print(sys.path); print(sys.executable); print(sys.prefix)"
            ${lib.getExe env} -c "import bpy"
            touch $out
          '';
    };
  }
)

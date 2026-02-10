{pkgs ? import <nixpkgs> {}}: let
  # Working Blender for darwin.
  blender = import ./pkgs/blender {inherit pkgs;};
in {
  audaspace = pkgs.callPackage ./pkgs/audaspace {};
  inherit blender;
  bpy = pkgs.callPackage ./pkgs/bpy {inherit blender;};

  # See <https://github.com/nix-community/talon-nix>.
  # talon = pkgs.callPackage ./pkgs/talon {};

  # In nixpkgs now:
  # geogram = pkgs.callPackage ./pkgs/geogram {};
  # ceres-solver = pkgs.callPackage ./pkgs/ceres-solver {};
  # coinutils = pkgs.callPackage ./pkgs/coinutils {};
  # aka pkgs.lemon-graph:
  # coin-or-lemon = pkgs.callPackage ./pkgs/coin-or-lemon {};

  # TODO: Resurrect these. See <https://github.com/NixOS/nixpkgs/pull/256115>, <https://github.com/NixOS/nixpkgs/issues/94127>, and various others.
  # alicevision = pkgs.callPackage ./pkgs/alicevision {
  #   inherit geogram ceres-solver coinutils coin-or-lemon;
  # };
  # meshroom = pkgs.callPackage ./pkgs/meshroom {
  #   inherit alicevision;
  # };

  # TODO: These could still be useful.
  # alicevision-bin = pkgs.callPackage ./pkgs/alicevision-bin {};
  # meshroom-bin = pkgs.callPackage ./pkgs/meshroom-bin {
  #   inherit alicevision-bin;
  # };
}

{ pkgs ? import <nixpkgs> {} }:

rec {
  geogram = pkgs.callPackage ./pkgs/geogram {};
  ceres-solver = pkgs.callPackage ./pkgs/ceres-solver {};
  coinutils = pkgs.callPackage ./pkgs/coinutils {};
  coin-or-lemon = pkgs.callPackage ./pkgs/coin-or-lemon {};
  alicevision = pkgs.callPackage ./pkgs/alicevision {
    inherit geogram ceres-solver coinutils coin-or-lemon;
  };
  # meshroom = pkgs.callPackage ./pkgs/meshroom {
  #   inherit alicevision;
  # };
  alicevision-bin = pkgs.callPackage ./pkgs/alicevision-bin {};
  meshroom-bin = pkgs.callPackage ./pkgs/meshroom-bin {
    inherit alicevision-bin;
  };
}

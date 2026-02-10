{
  description = "yrns' NUR repository";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = {
    self,
    nixpkgs,
  }: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    attrs = drv: {
      name = drv.name;
      value = drv;
    };
  in {
    legacyPackages = forAllSystems (system:
      import ./default.nix {
        pkgs = import nixpkgs {inherit system;};
      });
    packages = forAllSystems (system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system});

    # CI cached outputs.
    checks = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      cacheOutputs = (import ./ci.nix {inherit pkgs;}).cacheOutputs;
    in
      builtins.listToAttrs (map attrs cacheOutputs));
  };
}

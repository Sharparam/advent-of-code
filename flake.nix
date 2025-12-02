{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs) lib;
    supportedSystems = lib.systems.flakeExposed;
    forAllSystems = lib.genAttrs supportedSystems;
  in {
    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.callPackage ./shell.nix {};
    });
  };
}

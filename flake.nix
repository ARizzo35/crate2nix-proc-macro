{
  inputs = {
    crate2nix.url    = "github:nix-community/crate2nix";
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-25.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { crate2nix, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) crate2nix.overlays.default ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "clippy"
            "rust-analyzer"
            "rustfmt"
          ];
        };
        cargoWorkspace = pkgs.callPackage ./Cargo.nix { };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          nativeBuildInputs = [
            cargo-machete
            pkgs.crate2nix
            nixd
            rustToolchain
            tombi
          ];
        };

        packages.demo = cargoWorkspace.workspaceMembers.demo.build;
      }
    );
}

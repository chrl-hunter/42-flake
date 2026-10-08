{
  description = "42 Barcelona - reproducible C development shell";

  inputs = {
    # Immutable nixpkgs revisions: versions will not drift with branch updates.
    nixpkgs.url = "github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b";
    nixpkgs-norminette.url = "github:NixOS/nixpkgs/ac62194c3917d5f474c1a844b6fd6da2db95077d";
  };

  outputs = { nixpkgs, nixpkgs-norminette, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      tools = import nixpkgs-norminette { inherit system; };
      llvm12 = pkgs.llvmPackages_12;
      clangStdenv = pkgs.overrideCC pkgs.stdenv llvm12.clang;

      # This package is pinned to Norminette 3.3.58, with Python 3.13.
      norminette42 = tools.callPackage
        (nixpkgs-norminette.outPath + "/pkgs/by-name/no/norminette/package.nix") {
          python3Packages = tools.python313Packages;
        };
    in {
      devShells.${system}.default =
        (pkgs.mkShell.override { stdenv = clangStdenv; }) {
          name = "42-c";

          packages = [
            llvm12.clang-unwrapped
            pkgs.gnumake
            pkgs.gdb
            pkgs.valgrind
            pkgs.git
            pkgs.binutils
            tools.python313
            norminette42
          ];

          shellHook = ''
            export CC=cc
            export CFLAGS="-Wall -Wextra -Werror"
          '';
        };
    };
}

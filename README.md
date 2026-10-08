# 42 Barcelona - Nix development shell

Small Nix flake for C exercises, without containers, system-wide changes, or editor configuration.

## Install

Extract this directory to `~/42-env`, then from Fish:

```fish
cd ~/42-env
nix flake lock
nix develop -c fish
```

To enter from any project:

```fish
nix develop ~/42-env -c fish
```

Check the environment:

```fish
cc --version
clangd --version
make --version | head -n 1
gdb --version | head -n 1
valgrind --version
norminette --version
python3 --version
```

Test the compiler:

```fish
printf 'int main(void){return 0;}\n' > /tmp/42-check.c
cc -Wall -Wextra -Werror /tmp/42-check.c -o /tmp/42-check-bin
/tmp/42-check-bin
echo $status
```

## Version policy

- Clang and clangd: LLVM 12.0.1 from a fixed Nixpkgs 22.11 commit.
- Norminette: 3.3.58 from a fixed Nixpkgs 25.05 commit, built with Python 3.13.
- Make, GDB, Valgrind, Git and Binutils: versions from the fixed Nixpkgs 22.11 commit. They are stable but are **not guaranteed** to match Ubuntu 22.04 campus versions.
- Python 3.13: from a fixed Nixpkgs 25.05 commit, patch version may differ from campus 3.13.1.
- These are upstream Nix builds, not Ubuntu-patched binaries; exact binary compatibility is not claimed.
- `flake.lock` is generated locally the first time; commit it alongside `flake.nix` for fully locked inputs.
- `CFLAGS` is exported for tools that use it; direct `cc` commands still need explicit `-Wall -Wextra -Werror` flags.
- Fish and Neovim are not installed or modified by this flake. `fish` must be available on the host.

## Note

This flake has not been evaluated or built in a Nix-enabled environment. If old LLVM dependencies fail to build on current NixOS, inspect the `nix develop` error before changing the pinned inputs.

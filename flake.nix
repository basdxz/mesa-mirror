{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.chaotic.url = "github:chaotic-cx/nyx/e84e243d10c138885b9d01aa1494b6b0cb6b1d32";

  outputs = {self, ...}@inputs:
  
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.chaotic.overlays.default
              ];
            };
          }
        );
    in {
    devShells = forEachSupportedSystem(
      {pkgs}: {
        default = pkgs.mkShell {
            packages = pkgs.mesa_git.buildInputs ++ pkgs.mesa_git.nativeBuildInputs;
            shellHook = pkgs.mesa_git.preConfigure;
            mesonFlags = pkgs.mesa_git.mesonFlags;
        };
      }
    );
  };
}

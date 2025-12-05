{
  inputs.nixpkgs.url = "nixpkgs/4f92f68f31251e2a710f4619df1b9f6bf5983b0f";

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
            pkgs = import inputs.nixpkgs { inherit system; };
          }
        );
    in {
    devShells = forEachSupportedSystem(
      {pkgs}: {
        default = pkgs.mkShell {
            packages = pkgs.mesa.buildInputs ++ pkgs.mesa.nativeBuildInputs;
            shellHook = pkgs.mesa.preConfigure;
            mesonFlags = pkgs.mesa.mesonFlags;
        };
      }
    );
  };
}

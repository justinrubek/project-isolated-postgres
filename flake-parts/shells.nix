{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    inputs',
    self',
    lib,
    ...
  }: let
    devTools = [
      self'.packages.postgresql
      pkgs.pgcli
      self'.packages."scripts/init-database"
      self'.packages."scripts/start-database"
      self'.packages."scripts/stop-database"
    ];
  in {
    devShells = {
      default = pkgs.mkShell {
        packages = devTools;
      };
    };
  };
}

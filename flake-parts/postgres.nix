{...}: {
  perSystem = {
    pkgs,
    inputs',
    self',
    ...
  }: let
    db-name = "test-db";
    data-dir = ".data/${db-name}";
    log-file = "${data-dir}.log";

    init-database = pkgs.writeScriptBin "init-database" ''
      set -euo pipefail

      ${self'.packages.postgresql}/bin/initdb -D ${data-dir}
      ${self'.packages.postgresql}/bin/pg_ctl -D ${data-dir} -l ${log-file} -o "--unix_socket_directories='$PWD'" start
      ${self'.packages.postgresql}/bin/createdb ${db-name} -h $PWD
    '';

    start-database = pkgs.writeScriptBin "start-database" ''
      set -euo pipefail

      ${self'.packages.postgresql}/bin/pg_ctl -D ${data-dir} -l ${log-file} -o "--unix_socket_directories='$PWD'" start
    '';

    stop-database = pkgs.writeScriptBin "stop-database" ''
      set -euo pipefail

      ${self'.packages.postgresql}/bin/pg_ctl -D ${data-dir} stop
    '';
  in rec {
    packages = {
      postgresql = pkgs.postgresql_15;

      "scripts/init-database" = init-database;
      "scripts/start-database" = start-database;
      "scripts/stop-database" = stop-database;
    };
  };
}

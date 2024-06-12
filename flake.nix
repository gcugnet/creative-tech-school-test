{
  description = "Creative Tech School test";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devshell.flakeModule ];
      systems = [ "x86_64-linux" ];

      perSystem = { inputs', system, ... }:
        let
          pkgs = inputs'.nixpkgs.legacyPackages;
        in
        {
          devshells.default = {
            name = "Creative Tech School test";

            motd = ''

              {202}🔨 Welcome to the Creative Tech School test devshell!{reset}
              $(type -p menu &>/dev/null && menu)
            '';

            packages = with pkgs; [
              # Build toolchain.
              beam.packages.erlang_26.elixir_1_16
              gcc
              gnumake

              # Project dependencies.
              postgresql_16

              # Development dependencies.
              inotify-tools
              libnotify

              # IDE toolchain.
              nil
              nixpkgs-fmt

              # Tools.
              git
            ];

            env = [
              { name = "PGDATA"; eval = "$PWD/db"; }
            ];

            commands = [
              {
                name = "setup";
                help = "Compiles the application, and sets the database up";
                command = builtins.readFile ./scripts/setup;
              }

              {
                name = "start-db";
                help = "Starts a local instance of PostgreSQL";
                command = builtins.readFile ./scripts/start-db;
              }

              {
                name = "stop-db";
                help = "Stops the local instance of PostgreSQL";
                command = builtins.readFile ./scripts/stop-db;
              }
            ];
          };
        };
    };
}

{
  description = "A flake for getting started with Scala.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    ,
    }:
    let
      supportedSystems = [
        # "aarch64-darwin"
        # "aarch64-linux"
        # "x86_64-linux"
        "x86_64-darwin"
      ];
      mkPakgs = nixpkgs: system:
        let
          makeOverlays = java:
            let
              armOverlay = _: prev:
                let
                  pkgsForx86 = import nixpkgs {
                    localSystem = "x86_64-darwin";
                  };
                in
                prev.lib.optionalAttrs (prev.stdenv.isDarwin && prev.stdenv.isAarch64) {
                  inherit (pkgsForx86) bloop;
                };

              ammoniteOverlay = final: prev: {
                # hardcoded because ammonite requires no more than 17 for now
                ammonite = prev.ammonite.override {
                  jre = final.temurin-bin-17;
                };
              };

              bloopOverlay = final: prev: {
                bloop = prev.bloop.override {
                  jre = final.jre;
                };
              };

              millOverlay = final: prev: {
                mill = prev.mill.override {
                  jre = final.jre;
                };
              };

              javaOverlay = final: _: {
                jdk = final.${java};
                jre = final.${java};
              };

              scalaCliOverlay = final: prev: {
                scala-cli = prev.scala-cli.override {
                  # hardcoded because scala-cli requires 17 or above
                  jre = final.graalvm-ce;
                };
              };
            in
            [
              javaOverlay
              armOverlay
              bloopOverlay
              scalaCliOverlay
              ammoniteOverlay
              millOverlay
            ];

          makePackages = java:
            let
              overlays = makeOverlays java;
            in
            import nixpkgs {
              inherit system overlays;
            };

          # select a java version
          default = pkgs21;
          pkgs21 = makePackages "graalvm-ce";
          pkgs17 = makePackages "temurin-bin-17";
          pkgs11 = makePackages "temurin-bin-11";
          pkgs8 = makePackages "openjdk8";
        in
        {
          inherit default pkgs21 pkgs17 pkgs11 pkgs8;
        };
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = mkPakgs nixpkgs system;

        makeShell = p:
          p.mkShell {
            buildInputs = with p; [
              ammonite
              bloop
              coursier
              jdk
              mill
              sbt
              scala-cli
              scalafmt
            ];
          };
      in
      {
        devShells = {
          default = makeShell pkgs.default;
          java21 = makeShell pkgs.pkgs21;
          java17 = makeShell pkgs.pkgs17;
          java11 = makeShell pkgs.pkgs11;
          java8 = makeShell pkgs.pkgs8;
        };

        formatter = pkgs.default.alejandra;
      }
    );
}

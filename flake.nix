outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "leafpad";
        version = "0.8.18.1-tracey";

        src = ./leafpad-nix/leafpad-src;

        nativeBuildInputs = [
          pkgs.pkg-config
          pkgs.automake
          pkgs.autoconf
          pkgs.libtool
          pkgs.intltool
        ];

        buildInputs = [ pkgs.gtk2 ];

        configurePhase = ''
          ./autogen.sh || autoreconf -vi
          ./configure --prefix=$out
        '';

        buildPhase = "make";
        installPhase = "make install";

        meta = {
          description = "Custom Leafpad build by Tracey";
          license = pkgs.lib.licenses.gpl2;
          maintainers = [];
        };
      };

      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.pkg-config
          pkgs.automake
          pkgs.autoconf
          pkgs.libtool
          pkgs.intltool
          pkgs.gtk2
        ];
      };
    }
  );

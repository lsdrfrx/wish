{ pkgs, lib, ... }:

let
  wish = pkgs.stdenv.mkDerivation rec {
    name = "wish-${version}";
    version = "0.1.0";
    src = ./.;

    nativeBuildInputs = with pkgs; [ crystal shards ];

    buildPhase = ''
      crystal build --release -o wish src/wish.cr
    '';

    installPhase = ''
      install -Dm755 wish $out/bin/wish
    '';

    meta = with pkgs.lib; {
      description = "Wish is a yet another modern, lightweight shell written in Crystal";
      homepage = "https://github.com/lsdrfrx/wish";
      license = licenses.mit;
      maintainers = [ maintainers."Christian Guetnga" ];
    };
  };
in {
  packages = [ wish ];

  languages.crystal.enable = true;
}

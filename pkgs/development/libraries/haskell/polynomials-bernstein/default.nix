# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, vector }:

cabal.mkDerivation (self: {
  pname = "polynomials-bernstein";
  version = "1.1.1";
  sha256 = "0pjdwi84gz5j1rij4m89nyljjafzjnakmf4yd6vj4xz54nmmygg6";
  buildDepends = [ vector ];
  meta = {
    description = "A solver for systems of polynomial equations in bernstein form";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ jpbernardy ];
  };
})

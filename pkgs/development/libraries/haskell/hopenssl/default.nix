# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, mtl, openssl }:

cabal.mkDerivation (self: {
  pname = "hopenssl";
  version = "1.7";
  sha256 = "1zs69kxwz5fnm62mdscbpfz78vwnda75gyx1vxmmlisfhfslprly";
  buildDepends = [ mtl ];
  extraLibraries = [ openssl ];
  meta = {
    homepage = "http://github.com/peti/hopenssl";
    description = "FFI bindings to OpenSSL's EVP digest interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ simons ];
  };
})

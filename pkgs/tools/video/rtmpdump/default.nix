{ stdenv, fetchgit, zlib
, gnutlsSupport ? true, gnutls ? null
, opensslSupport ? false, openssl ? null
}:

# Must have an ssl library enabled
assert (gnutlsSupport || opensslSupport);
assert gnutlsSupport -> ((gnutlsSupport != null) && (!opensslSupport));
assert opensslSupport -> ((openssl != null) && (!gnutlsSupport));

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "rtmpdump-${version}";
  version = "2.4";

  src = fetchgit {
    url = git://git.ffmpeg.org/rtmpdump;
    # Currently the latest commit is used (a release has not been made since 2011, i.e. '2.4')
    rev = "a107cef9b392616dff54fabfd37f985ee2190a6f";
    sha256 = "178h5j7w20g2h9mn6cb7dfr3fa4g4850hpl1lzxmi0nk3blzcsvl";
  };

  makeFlags = [ ''prefix=$(out)'' ]
    ++ optional gnutlsSupport "CRYPTO=GNUTLS"
    ++ optional opensslSupport "CRYPTO=OPENSSL";

  buildInputs = [ zlib ]
    ++ optional gnutlsSupport gnutls
    ++ optional opensslSupport openssl;

  meta = {
    description = "Toolkit for RTMP streams";
    homepage    = http://rtmpdump.mplayerhq.hu/;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ codyopel viric ];
  };
}

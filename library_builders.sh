
BUILD_PREFIX="${BUILD_PREFIX:-/usr/local}"
DSDP_VERSION="${DSDP_VERSION:-5.8}"
DSDP_SHA256="26aa624525a636de272c0b329e2dfd01a0d5b7827f1c1c76f393d71e37dead70"
GLPK_VERSION="${GLPK_VERSION:-4.65}"
GLPK_SHA256="4281e29b628864dfe48d393a7bedd781e5b475387c20d8b0158f329994721a10"
GSL_VERSION="${GSL_VERSION:-2.4}"
GSL_SHA256="4d46d07b946e7b31c19bbf33dda6204d7bedc2f5462a1bae1d4013426cd1ce9b"
FFTW_VERSION="${FFTW_VERSION:-3.3.7}"
FFTW_SHA256="3b609b7feba5230e8f6dd8d245ddbefac324c5a6ae4186947670d9ac2cd25573"
SUITESPARSE_VERSION="${SUITESPARSE_VERSION:-5.2.0}"
SUITESPARSE_SHA256="3c46c035ea8217649958a0f73360e825b0c9dcca4e32a9349d2c7678c0d48813"


type fetch_unpack &> /dev/null || source multibuild/library_builders.sh

function build_dsdp {
  if [ -e dsdp-stamp ]; then return; fi
  fetch_unpack http://www.mcs.anl.gov/hs/software/DSDP/DSDP${DSDP_VERSION}.tar.gz
  check_sha256sum archives/DSDP${DSDP_VERSION}.tar.gz ${DSDP_SHA256}
  if [ -n "${IS_OSX}" ]; then
    (cd DSDP${DSDP_VERSION} \
        && patch -p1 < ../dsdp.patch \
        && make PREFIX=${BUILD_PREFIX} IS_OSX=1 DSDPROOT=`pwd` install)
  else
    build_openblas
    (cd DSDP${DSDP_VERSION} \
        && patch -p1 < ../dsdp.patch \
        && make LAPACKBLAS="-L${BUILD_PREFIX}/lib -lopenblas" PREFIX=${BUILD_PREFIX} DSDPROOT=`pwd` install)
  fi
  touch dsdp-stamp
}

function build_fftw {
  if [ -e fftw-stamp ]; then return; fi
  fetch_unpack http://www.fftw.org/fftw-${FFTW_VERSION}.tar.gz
  check_sha256sum archives/fftw-${FFTW_VERSION}.tar.gz ${FFTW_SHA256}
  (cd fftw-${FFTW_VERSION} \
      && ./configure --prefix=${BUILD_PREFIX} --enable-shared \
      && make \
      && make install)
  touch fftw-stamp
}

function build_glpk {
  if [ -e glpk-stamp ]; then return; fi
  fetch_unpack http://ftp.gnu.org/gnu/glpk/glpk-${GLPK_VERSION}.tar.gz
  check_sha256sum archives/glpk-${GLPK_VERSION}.tar.gz ${GLPK_SHA256}
  (cd glpk-${GLPK_VERSION} \
      && ./configure --prefix=${BUILD_PREFIX} \
      && make \
      && make install)
  touch glpk-stamp
}

function build_gsl {
  if [ -e gsl-stamp ]; then return; fi
  fetch_unpack http://mirrors.peers.community/mirrors/gnu/gsl/gsl-${GSL_VERSION}.tar.gz
  check_sha256sum archives/gsl-${GSL_VERSION}.tar.gz ${GSL_SHA256}
  (cd gsl-${GSL_VERSION} \
      && ./configure --prefix=${BUILD_PREFIX} \
      && make \
      && make install)
  touch gsl-stamp
}


BUILD_PREFIX="${BUILD_PREFIX:-/usr/local}"
DSDP_VERSION="5.8"
DSDP_SHA256="26aa624525a636de272c0b329e2dfd01a0d5b7827f1c1c76f393d71e37dead70"
GLPK_VERSION="5.0"
GLPK_SHA256="4a1013eebb50f728fc601bdd833b0b2870333c3b3e5a816eeba921d95bec6f15"
GSL_VERSION="2.7.1"
GSL_SHA256="dcb0fbd43048832b757ff9942691a8dd70026d5da0ff85601e52687f6deeb34b"
FFTW_VERSION="3.3.10"
FFTW_SHA256="56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467"
SUITESPARSE_VERSION="5.10.1"
SUITESPARSE_SHA256="acb4d1045f48a237e70294b950153e48dce5b5f9ca8190e86c2b8c54ce00a7ee"


type fetch_unpack &> /dev/null || source multibuild/library_builders.sh

function build_dsdp {
  if [ -e dsdp-stamp ]; then return; fi
  fetch_unpack http://www.mcs.anl.gov/hs/software/DSDP/DSDP${DSDP_VERSION}.tar.gz
  check_sha256sum archives/DSDP${DSDP_VERSION}.tar.gz ${DSDP_SHA256}
  if [ -n "${IS_OSX}" ]; then
    (cd DSDP${DSDP_VERSION} \
        && patch -p1 < ../dsdp.patch \
        && make LAPACKBLAS="-L${BUILD_PREFIX}/lib -lopenblas" PREFIX=${BUILD_PREFIX} IS_OSX=1 DSDPROOT=`pwd` install)
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
  fetch_unpack https://ftp.gnu.org/gnu/gsl/gsl-${GSL_VERSION}.tar.gz
  check_sha256sum archives/gsl-${GSL_VERSION}.tar.gz ${GSL_SHA256}
  (cd gsl-${GSL_VERSION} \
      && ./configure --prefix=${BUILD_PREFIX} \
      && make \
      && make install)
  touch gsl-stamp
}


BUILD_PREFIX="${BUILD_PREFIX:-/usr/local}"
DSDP_VERSION="5.8"
DSDP_SHA256="26aa624525a636de272c0b329e2dfd01a0d5b7827f1c1c76f393d71e37dead70"
GLPK_VERSION="5.0"
GLPK_SHA256="4a1013eebb50f728fc601bdd833b0b2870333c3b3e5a816eeba921d95bec6f15"
GSL_VERSION="2.7.1"
GSL_SHA256="dcb0fbd43048832b757ff9942691a8dd70026d5da0ff85601e52687f6deeb34b"

type fetch_unpack &> /dev/null || source multibuild/library_builders.sh

function build_dsdp {
  if [ -e dsdp-stamp ]; then return; fi
  fetch_unpack http://www.mcs.anl.gov/hs/software/DSDP/DSDP${DSDP_VERSION}.tar.gz
  check_sha256sum archives/DSDP${DSDP_VERSION}.tar.gz ${DSDP_SHA256}
  if [ -n "${IS_OSX}" ]; then
    if [ PLAT = "arm64" ]; then
        export ARCH_FLAGS="-target arm64-apple-macos11"
    fi
    (cd DSDP${DSDP_VERSION} \
        && patch -p1 < ../dsdp.patch \
        && make LAPACKBLAS="-framework Accelerate" PREFIX=${BUILD_PREFIX} IS_OSX=1 DSDPROOT=`pwd` install)
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
  if [ -n "$IS_MACOS" ]; then
      brew install fftw
      brew link --force fftw
  else
      fetch_unpack http://www.fftw.org/fftw-${FFTW_VERSION}.tar.gz
      check_sha256sum archives/fftw-${FFTW_VERSION}.tar.gz ${FFTW_SHA256}
      (cd fftw-${FFTW_VERSION} \
          && ./configure --prefix=${BUILD_PREFIX} --enable-shared \
          && make \
          && make install)
  fi
  touch fftw-stamp
}

function build_glpk {
  if [ -e glpk-stamp ]; then return; fi
  if [ -n "$IS_MACOS" ]; then
      brew install glpk
      brew link --force glpk
  else
      fetch_unpack http://ftp.gnu.org/gnu/glpk/glpk-${GLPK_VERSION}.tar.gz
      check_sha256sum archives/glpk-${GLPK_VERSION}.tar.gz ${GLPK_SHA256}
      (cd glpk-${GLPK_VERSION} \
          && ./configure --prefix=${BUILD_PREFIX} \
          && make \
          && make install)
  fi
  touch glpk-stamp
}

function build_gsl {
  if [ -e gsl-stamp ]; then return; fi
  if [ -n "$IS_MACOS" ]; then
      brew install gsl
      brew link --force gsl
  else
      fetch_unpack https://ftp.gnu.org/gnu/gsl/gsl-${GSL_VERSION}.tar.gz
      check_sha256sum archives/gsl-${GSL_VERSION}.tar.gz ${GSL_SHA256}
      (cd gsl-${GSL_VERSION} \
          && ./configure --prefix=${BUILD_PREFIX} \
          && make \
          && make install)
  fi
  touch gsl-stamp
}

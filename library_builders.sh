
BUILD_PREFIX="${BUILD_PREFIX:-/usr/local}"
DSDP_VERSION="${DSDP_VERSION:-5.8}"
DSDP_SHA256="26aa624525a636de272c0b329e2dfd01a0d5b7827f1c1c76f393d71e37dead70"
GLPK_VERSION="${GLPK_VERSION:-4.61}"
GLPK_SHA256="9866de41777782d4ce21da11b88573b66bb7858574f89c28be6967ac22dfaba9"
GSL_VERSION="${GSL_VERSION:-2.3}"
GSL_SHA256="562500b789cd599b3a4f88547a7a3280538ab2ff4939504c8b4ac4ca25feadfb"
FFTW_VERSION="${FFTW_VERSION:-3.3.6-pl1}"
FFTW_SHA256="1ef4aa8427d9785839bc767f3eb6a84fcb5e9a37c31ed77a04e7e047519a183d"
SUITESPARSE_VERSION="${SUITESPARSE_VERSION:-4.5.4}"
SUITESPARSE_SHA256="698b5c455645bb1ad29a185f0d52025f3bd7cb7261e182c8878b0eb60567a714"

type fetch_unpack &> /dev/null || source multibuild/library_builders.sh

function build_dsdp {
  if [ -e dsdp-stamp ]; then return; fi
  fetch_unpack http://www.mcs.anl.gov/hs/software/DSDP/DSDP${DSDP_VERSION}.tar.gz
  check_sha256sum archives/DSDP${DSDP_VERSION}.tar.gz ${DSDP_SHA256}
  if [ -n "${IS_OSX}" ]; then
    (cd DSDP${DSDP_VERSION} \
        && patch -p1 < ../dsdp.patch \
        && make LAPACKBLAS="-L${BUILD_PREFIX}/lib -lopenblas" DSDPROOT=`pwd` dylib \
        && cp lib/libdsdp.dylib ${BUILD_PREFIX}/lib)
  else
    (cd DSDP${DSDP_VERSION} \
        && patch -p1 < ../dsdp.patch \
        && make LAPACKBLAS="-L${BUILD_PREFIX}/lib -lopenblas" DSDPROOT=`pwd` oshared \
        && cp lib/libdsdp.so ${BUILD_PREFIX}/lib)
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

# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

# Configure which optional extensions to build
export CVXOPT_BUILD_DSDP=1
export CVXOPT_BUILD_FFTW=1
export CVXOPT_BUILD_GLPK=1
export CVXOPT_BUILD_GSL=1
TESTS_DIR="$(pwd)/cvxopt/tests"

source library_builders.sh

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.

    # Build dependencies
    if [ -z "${IS_OSX}" ]; then
        build_openblas  # defined in multibuild/library_builders.sh
    fi
    if [ "${CVXOPT_BUILD_DSDP}" == "1" ]; then build_dsdp; fi
    if [ "${CVXOPT_BUILD_FFTW}" == "1" ]; then build_fftw; fi
    if [ "${CVXOPT_BUILD_GLPK}" == "1" ]; then build_glpk; fi
    if [ "${CVXOPT_BUILD_GSL}" == "1" ]; then build_gsl; fi

    # Download SuiteSparse
    if [ ! -e suitesparse-stamp ]; then
        fetch_unpack http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-${SUITESPARSE_VERSION}.tar.gz
        check_sha256sum archives/SuiteSparse-${SUITESPARSE_VERSION}.tar.gz ${SUITESPARSE_SHA256}
        touch suitesparse-stamp
    fi

    if [ -z "${IS_OSX}" ]; then
        export CVXOPT_BLAS_LIB=openblas
        export CVXOPT_LAPACK_LIB=openblas
        export CVXOPT_BLAS_LIB_DIR=${BUILD_PREFIX}/lib
    fi
    export CVXOPT_GLPK_LIB_DIR=${BUILD_PREFIX}/lib
    export CVXOPT_GLPK_INC_DIR=${BUILD_PREFIX}/include
    export CVXOPT_GSL_LIB_DIR=${BUILD_PREFIX}/lib
    export CVXOPT_GSL_INC_DIR=${BUILD_PREFIX}/include/gsl
    export CVXOPT_FFTW_LIB_DIR=${BUILD_PREFIX}/lib
    export CVXOPT_FFTW_INC_DIR=${BUILD_PREFIX}/include
    export CVXOPT_DSDP_LIB_DIR=${BUILD_PREFIX}/lib
    export CVXOPT_DSDP_INC_DIR=${BUILD_PREFIX}/include
    export CVXOPT_SUITESPARSE_SRC_DIR=`pwd`/SuiteSparse
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    python -c 'from cvxopt import blas,lapack,cholmod,umfpack'
    if [ "${CVXOPT_BUILD_DSDP}" == "1" ]; then python -c 'from cvxopt import dsdp'; fi
    if [ "${CVXOPT_BUILD_FFTW}" == "1" ]; then python -c 'from cvxopt import fftw'; fi
    if [ "${CVXOPT_BUILD_GLPK}" == "1" ]; then python -c 'from cvxopt import glpk'; fi
    if [ "${CVXOPT_BUILD_GSL}" == "1" ]; then python -c 'from cvxopt import gsl'; fi
    python -m unittest discover -s ${TESTS_DIR}
}

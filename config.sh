# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

# Configure which optional extensions to build
export CVXOPT_BUILD_DSDP=0
export CVXOPT_BUILD_FFTW=0
export CVXOPT_BUILD_GLPK=0
export CVXOPT_BUILD_GSL=0
export OPENBLAS_VERSION=0.3.20
export FFTW_VERSION="3.3.10"
export FFTW_SHA256="56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467"
export SUITESPARSE_VERSION="5.10.1"
export SUITESPARSE_SHA256="acb4d1045f48a237e70294b950153e48dce5b5f9ca8190e86c2b8c54ce00a7ee"

TESTS_DIR="$(pwd)/cvxopt/tests"

if [ -n "${IS_MACOS}" ]; then
    echo "--insecure" >> $HOME/.curlrc
fi

source library_builders.sh

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.

    # Download SuiteSparse source 
    if [ ! -e suitesparse-stamp ]; then
		mkdir -p archives
		curl -L https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v${SUITESPARSE_VERSION}.tar.gz > archives/SuiteSparse-${SUITESPARSE_VERSION}.tar.gz
    	check_sha256sum archives/SuiteSparse-${SUITESPARSE_VERSION}.tar.gz ${SUITESPARSE_SHA256}
		mkdir SuiteSparse && tar -xf archives/SuiteSparse-${SUITESPARSE_VERSION}.tar.gz -C SuiteSparse --strip-components 1
      touch suitesparse-stamp
      export CVXOPT_SUITESPARSE_SRC_DIR=$(pwd)/SuiteSparse
    fi

    # Build dependencies
    # build_suitesparse
    # export CVXOPT_SUITESPARSE_LIB_DIR=${BUILD_PREFIX}/lib
    # export CVXOPT_SUITESPARSE_INC_DIR=${BUILD_PREFIX}/include/suitesparse

    build_openblas
    export CVXOPT_BLAS_LIB=openblas
    export CVXOPT_LAPACK_LIB=openblas
    export CVXOPT_BLAS_LIB_DIR=${BUILD_PREFIX}/lib
    
    #export CVXOPT_BLAS_EXTRA_LINK_ARGS="-framework Accelerate"
    
    if [ "${CVXOPT_BUILD_DSDP}" == "1" ]; then 
        build_dsdp
        export CVXOPT_DSDP_LIB_DIR=${BUILD_PREFIX}/lib
        export CVXOPT_DSDP_INC_DIR=${BUILD_PREFIX}/include
    fi

    if [ "${CVXOPT_BUILD_FFTW}" == "1" ]; then 
        build_fftw
        export CVXOPT_FFTW_LIB_DIR=${BUILD_PREFIX}/lib
        export CVXOPT_FFTW_INC_DIR=${BUILD_PREFIX}/include
    fi

    if [ "${CVXOPT_BUILD_GLPK}" == "1" ]; then 
        build_glpk
        export CVXOPT_GLPK_LIB_DIR=${BUILD_PREFIX}/lib
        export CVXOPT_GLPK_INC_DIR=${BUILD_PREFIX}/include
    fi

    if [ "${CVXOPT_BUILD_GSL}" == "1" ]; then 
        build_gsl
        export CVXOPT_GSL_LIB_DIR=${BUILD_PREFIX}/lib
        export CVXOPT_GSL_INC_DIR=${BUILD_PREFIX}/include/gsl
    fi

     # Travis only clones the last 50 commits (--depth=50), but we require the
     # entire repository to generate the package version with setuptools_scm
    git config --global --add safe.directory /io/cvxopt
    (cd $(pwd)/cvxopt && git fetch --unshallow)
}

function build_wheel {
    wrap_wheel_builder build_bdist_wheel $@
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    python -c 'from cvxopt import blas,lapack,cholmod,umfpack'
    if [ "${CVXOPT_BUILD_DSDP}" == "1" ]; then python -c 'from cvxopt import dsdp'; fi
    if [ "${CVXOPT_BUILD_FFTW}" == "1" ]; then python -c 'from cvxopt import fftw'; fi
    if [ "${CVXOPT_BUILD_GLPK}" == "1" ]; then python -c 'from cvxopt import glpk'; fi
    if [ "${CVXOPT_BUILD_GSL}" == "1" ]; then python -c 'from cvxopt import gsl'; fi
    pytest ${TESTS_DIR}
}

# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

# Configure which optional extensions to build
export CVXOPT_BUILD_DSDP=1
export CVXOPT_BUILD_FFTW=1
export CVXOPT_BUILD_GLPK=1
export CVXOPT_BUILD_GSL=1
export OPENBLAS_VERSION=0.3.23
export FFTW_VERSION="3.3.10"
export FFTW_SHA256="56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467"
export SUITESPARSE_VERSION="5.13.0"
export SUITESPARSE_SHA256="59c6ca2959623f0c69226cf9afb9a018d12a37fab3a8869db5f6d7f83b6b147d"

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
        curl -L https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v${SUITESPARSE_VERSION}.tar.gz -o archives/v${SUITESPARSE_VERSION}.tar.gz
        check_sha256sum archives/v${SUITESPARSE_VERSION}.tar.gz ${SUITESPARSE_SHA256}
        tar -zxf archives/v${SUITESPARSE_VERSION}.tar.gz
        touch suitesparse-stamp
        export CVXOPT_SUITESPARSE_SRC_DIR=$(pwd)/SuiteSparse-${SUITESPARSE_VERSION}
    fi
    # export CVXOPT_SUITESPARSE_LIB_DIR=${BUILD_PREFIX}/lib
    # export CVXOPT_SUITESPARSE_INC_DIR=${BUILD_PREFIX}/include/suitesparse

    # Build dependencies
    build_openblas
    export CVXOPT_BLAS_LIB=openblas
    export CVXOPT_LAPACK_LIB=openblas
    if [ -n "$IS_MACOS" ]; then
        export CVXOPT_BLAS_LIB_DIR=/usr/local/opt/openblas/lib
        #export CVXOPT_BLAS_EXTRA_LINK_ARGS="-framework Accelerate"
    else
        export CVXOPT_BLAS_LIB_DIR=${BUILD_PREFIX}/lib
    fi
    
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

    git config --global --add safe.directory /io/cvxopt
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

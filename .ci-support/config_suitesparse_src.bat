set SUITESPARSE_VERSION=5.8.1
set SUITESPARSE_SHA256=06726e471fbaa55f792578f9b4ab282ea9d008cf39ddcc3b42b73400acddef40

wget -nv https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v%SUITESPARSE_VERSION%.tar.gz -O SuiteSparse-%SUITESPARSE_VERSION%.tar.gz
checksum -t sha256 -c %SUITESPARSE_SHA256% SuiteSparse-%SUITESPARSE_VERSION%.tar.gz
mkdir SuiteSparse
7z x -bso0 -bsp0 SuiteSparse-%SUITESPARSE_VERSION%.tar.gz 
7z x -bso0 -bsp0 SuiteSparse-%SUITESPARSE_VERSION%.tar
SET CVXOPT_SUITESPARSE_SRC_DIR=%cd%\SuiteSparse-%SUITESPARSE_VERSION%

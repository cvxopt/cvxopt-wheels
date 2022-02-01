set SUITESPARSE_VERSION=5.10.1
set SUITESPARSE_SHA256=acb4d1045f48a237e70294b950153e48dce5b5f9ca8190e86c2b8c54ce00a7ee

wget -nv https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v%SUITESPARSE_VERSION%.tar.gz -O SuiteSparse-%SUITESPARSE_VERSION%.tar.gz
checksum -t sha256 -c %SUITESPARSE_SHA256% SuiteSparse-%SUITESPARSE_VERSION%.tar.gz
mkdir SuiteSparse
7z x -bso0 -bsp0 SuiteSparse-%SUITESPARSE_VERSION%.tar.gz 
7z x -bso0 -bsp0 SuiteSparse-%SUITESPARSE_VERSION%.tar
SET CVXOPT_SUITESPARSE_SRC_DIR=%cd%\SuiteSparse-%SUITESPARSE_VERSION%

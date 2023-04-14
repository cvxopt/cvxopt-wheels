set SUITESPARSE_VERSION=5.13.0
set SUITESPARSE_SHA256=59c6ca2959623f0c69226cf9afb9a018d12a37fab3a8869db5f6d7f83b6b147d

wget -nv https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v%SUITESPARSE_VERSION%.tar.gz -O SuiteSparse-%SUITESPARSE_VERSION%.tar.gz
checksum -t sha256 -c %SUITESPARSE_SHA256% SuiteSparse-%SUITESPARSE_VERSION%.tar.gz
mkdir SuiteSparse
7z x -bso0 -bsp0 SuiteSparse-%SUITESPARSE_VERSION%.tar.gz 
7z x -bso0 -bsp0 SuiteSparse-%SUITESPARSE_VERSION%.tar
SET CVXOPT_SUITESPARSE_SRC_DIR=%cd%\SuiteSparse-%SUITESPARSE_VERSION%

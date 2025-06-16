set OPENBLAS_VERSION=0.3.31
set OPENBLAS_SHA256=e7595359700e8bb5a15c41af1920850b1be37078eb22813201b3d4bc5bd9227e

wget -nv https://github.com/OpenMathLib/OpenBLAS/releases/download/v%OPENBLAS_VERSION%/OpenBLAS-%OPENBLAS_VERSION%-x64.zip
checksum -t sha256 -c %OPENBLAS_SHA256% OpenBLAS-%OPENBLAS_VERSION%-x64.zip 
mkdir OpenBLAS 
7z x -oOpenBLAS -bso0 -bsp0 OpenBLAS-%OPENBLAS_VERSION%-x64.zip 

set "CVXOPT_BLAS_LIB=libopenblas" 
set "CVXOPT_LAPACK_LIB=libopenblas" 
set "OPENBLAS_DLL=%cd%\OpenBLAS\win64\bin\libopenblas.dll"
set "OPENBLAS_LIB=%cd%\OpenBLAS\win64\lib\libopenblas.lib"

wget https://raw.githubusercontent.com/OpenMathLib/OpenBLAS/v%OPENBLAS_VERSION%/LICENSE -O LICENSE_OpenBLAS-%OPENBLAS_VERSION% &
set OPENBLAS_LICENSE=%cd%\LICENSE_OpenBLAS-%OPENBLAS_VERSION%        

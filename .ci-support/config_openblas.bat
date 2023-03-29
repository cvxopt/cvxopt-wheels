set OPENBLAS_VERSION=0.3.22
set OPENBLAS_SHA256_x64=ff08774f0d33077c46b501abffc8ddf90a246c1d714ec8aedccd1de45286d566
set OPENBLAS_SHA256_x86=2eb2a21fc9eaa374132a491aa7f7b28840040e634075c86fb97fc277038e7c15
if [%PLATFORM%]==[x64] ( 
    set OPENBLAS_SHA256=%OPENBLAS_SHA256_x64%
) else (
    set OPENBLAS_SHA256=%OPENBLAS_SHA256_x86%
)

wget -nv https://github.com/xianyi/OpenBLAS/releases/download/v%OPENBLAS_VERSION%/OpenBLAS-%OPENBLAS_VERSION%-%PLATFORM%.zip 
checksum -t sha256 -c %OPENBLAS_SHA256% OpenBLAS-%OPENBLAS_VERSION%-%PLATFORM%.zip 
mkdir OpenBLAS 
7z x -oOpenBLAS -bso0 -bsp0 OpenBLAS-%OPENBLAS_VERSION%-%PLATFORM%.zip 
set "CVXOPT_BLAS_LIB=libopenblas" 
set "CVXOPT_LAPACK_LIB=libopenblas" 
set "CVXOPT_BLAS_LIB_DIR=%cd%\OpenBLAS\lib" 
set "OPENBLAS_DLL=%cd%\OpenBLAS\bin\libopenblas.dll"

wget https://raw.githubusercontent.com/xianyi/OpenBLAS/v%OPENBLAS_VERSION%/LICENSE -O LICENSE_OpenBLAS-%OPENBLAS_VERSION% &
set OPENBLAS_LICENSE=%cd%\LICENSE_OpenBLAS-%OPENBLAS_VERSION%        

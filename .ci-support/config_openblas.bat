set OPENBLAS_VERSION=0.3.10
set OPENBLAS_SHA256_x64=a307629479260ebfed057a3fc466d2be83a2bb594739a99c06ec830173273135
set OPENBLAS_SHA256_x86=7eab2be38e4c79f0ce496e7cb3ae28be457aef1b21e70eb7e32147b479b7bb57
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

set OPENBLAS_VERSION=0.3.19
set OPENBLAS_SHA256_x64=d85b09d80bbb40442d608fa60353ccec5f112cebeccd805c0e139057e26d1795
set OPENBLAS_SHA256_x86=478cbaeb9364b4681a7c982626e637a5a936514a45e12b6f0caddbcb9483b795
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

set GLPK_VERSION=4.65
set GLPK_SHA256=4281e29b628864dfe48d393a7bedd781e5b475387c20d8b0158f329994721a10

wget -nv http://ftp.gnu.org/gnu/glpk/glpk-%GLPK_VERSION%.tar.gz 
checksum -t sha256 -c %GLPK_SHA256% glpk-%GLPK_VERSION%.tar.gz 
7z x -bso0 -bsp0 glpk-%GLPK_VERSION%.tar.gz && 7z x -bso0 -bsp0 glpk-%GLPK_VERSION%.tar 
cd glpk-%GLPK_VERSION%\w64 
copy config_VC config.h 
nmake /f Makefile_VC glpk.lib 
cd ..\.. 
SET "CVXOPT_GLPK_LIB_DIR=%cd%\glpk-%GLPK_VERSION%\w64" 
SET "CVXOPT_GLPK_INC_DIR=%cd%\glpk-%GLPK_VERSION%\src"
set GENERATE_OPTIONS= -G "Visual Studio 16 2019" -A x64 -D PROJECT_NO_NPM_PACK=ON
set GENERATE_PROJECT_NAME=.build-2019-x64
set GENERATE_DEF=-D PROJECT_NO_NPM_PACK=ON

cd %~dp0
mkdir %GENERATE_PROJECT_NAME%
cd %GENERATE_PROJECT_NAME%
call cmake %GENERATE_OPTIONS% %GENERATE_DEF% %* -D "PROJECT_DEV_DIR=%~dp0.output" -D "DELIVERY_OUTPUT_DIR=%~dp0.output/delivery" "%~dp0"

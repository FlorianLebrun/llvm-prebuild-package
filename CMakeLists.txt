cmake_minimum_required(VERSION 3.19)
include(./cmake-toolkit.cmake)

# Describe project
project("llvm-prebuild" 
  LANGUAGES ASM_MASM C CXX CSharp
  VERSION ${PROJECT_PACKAGE_VERSION}
)

add_subdirectory(llvm)
add_subdirectory(packages/llvm-jit-package)

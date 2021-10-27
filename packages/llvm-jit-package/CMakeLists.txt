set(target "llvm-jit")
set(packageDir "${PROJECT_DEV_DIR}/${target}")

# define LLVM JIT libraries list
set(LLVM_package_libnames
  LLVMX86Info
  LLVMX86Desc
  LLVMX86CodeGen
  LLVMVectorize
  LLVMTransformUtils
  LLVMTextAPI
  LLVMTarget
  LLVMSupport
  LLVMSelectionDAG
  LLVMScalarOpts
  LLVMRuntimeDyld
  LLVMRemarks
  LLVMProfileData
  LLVMPasses
  LLVMOrcJIT
  LLVMOrcTargetProcess
  LLVMOrcShared
  LLVMObject
  LLVMMCParser
  LLVMMCDisassembler
  LLVMMC
  LLVMLinker
  LLVMJITLink
  LLVMIRReader
  LLVMipo
  LLVMInstrumentation
  LLVMInstCombine
  LLVMGlobalISel
  LLVMFrontendOpenMP
  LLVMExecutionEngine
  LLVMDemangle
  LLVMDebugInfoMSF
  LLVMDebugInfoDWARF
  LLVMDebugInfoCodeView
  LLVMCoroutines
  LLVMCore
  LLVMCodeGen
  LLVMCFGuard
  LLVMBitWriter
  LLVMBitstreamReader
  LLVMBitReader
  LLVMBinaryFormat
  LLVMAsmPrinter
  LLVMAsmParser
  LLVMAnalysis
  LLVMAggressiveInstCombine
  LLVMX86Info
  LLVMMCJIT
  LLVMInterpreter
)

# Create resource files
append_static_directory_copy(commands 
  FROM
    "${CMAKE_CURRENT_SOURCE_DIR}/resources"
  TO
    "${packageDir}"
)

# Create include directory
append_static_directory_copy(commands FILTER "*.h|*.hpp|*.hxx|*.inc|*.def"
  FROM
    "${CMAKE_BINARY_DIR}/llvm-${CMAKE_PROJECT_VERSION}.src/include"
    "${CMAKE_BINARY_DIR}/llvm-${CMAKE_PROJECT_VERSION}.src-build/include"
  TO
    "${packageDir}/include"
)

# Make lib file
set(outputLib "${packageDir}/lib")
get_filename_component(MSVC_LIB_TOOL "${CMAKE_LINKER}/../lib.exe" ABSOLUTE)
if(EXISTS ${MSVC_LIB_TOOL})
  foreach(libname ${LLVM_package_libnames})
    list(APPEND LLVM_package_libs $<TARGET_LINKER_FILE:${libname}>)
  endforeach()
  add_custom_command(OUTPUT ${outputLib} DEPENDS ${LLVM_RT_LIBNAMES}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${packageDir}/lib
    COMMAND ${MSVC_LIB_TOOL} 
      "/OUT:${outputLib}/${target}-$<IF:$<CONFIG:Debug>,debug,release>.lib" 
      ${LLVM_package_libs}
  )
  list(APPEND commands ${outputLib})
else()
  message(ERROR ": MSVC lib tool not exists at ${MSVC_LIB_TOOL}")
endif()

# Create package.json
append_package_json(commands
  NAME ${target}
  PRODUCTION
  SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/package.cmake.json
  DESTINATION ${packageDir}
)

# Make package
if(PROJECT_NO_NPM_PACK)
  add_custom_target(${target} ALL DEPENDS ${commands})
else()
  package_npm_archive(outputFile DEPENDS ${resources} ${commands}
    DIRECTORY ${packageDir}
    DESTINATION ${DELIVERY_OUTPUT_DIR} 
  )
  add_custom_target(${target} ALL DEPENDS ${outputFile})
endif()

set_target_properties(${target} PROPERTIES FOLDER "Packages")

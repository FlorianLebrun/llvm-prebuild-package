
add_library(llvm-jit INTERFACE)
set_target_properties(llvm-jit PROPERTIES FOLDER "ThirdParty")
target_include_directories(llvm-jit INTERFACE "${CMAKE_CURRENT_LIST_DIR}/include")
target_link_libraries(llvm-jit INTERFACE "${CMAKE_CURRENT_LIST_DIR}/lib/llvm-jit-$<IF:$<CONFIG:Debug>,debug,release>.lib")

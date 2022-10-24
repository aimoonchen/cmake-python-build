function(extproj_cmake name url tag cmake_args subdir)

list(PREPEND args
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=on
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
-DBUILD_TESTING:BOOL=false
)

ExternalProject_Add(${name}
GIT_REPOSITORY ${url}
GIT_TAG ${tag}
GIT_SHALLOW true
CMAKE_ARGS ${args}
CMAKE_GENERATOR "$<IF:$<BOOL:${WIN32}>,MinGW Makefiles,Unix Makefiles>"
INACTIVITY_TIMEOUT 60
CONFIGURE_HANDLED_BY_BUILD true
TEST_COMMAND ""
SOURCE_SUBDIR ${subdir}
)

endfunction()

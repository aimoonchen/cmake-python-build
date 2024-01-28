# installs CMAKE_INSTALL_PREFIX/lib64/libffi.{a,so}

if(find)
  find_library(libffi NAMES ffi)

  if(libffi)
    message(STATUS "Found FFI: ${libffi}")
    add_custom_target(ffi)
    return()
  endif()
endif()

if(NOT LIBTOOL_EXECUTABLE)
  message(FATAL_ERROR "FFI needs libtool")
endif()

set(ffi_args --disable-docs)

extproj_autotools(ffi ${ffi_url} "${ffi_args}")

ExternalProject_Add_Step(ffi
autogen
COMMAND <SOURCE_DIR>/autogen.sh
DEPENDEES download
DEPENDERS configure
WORKING_DIRECTORY <SOURCE_DIR>
)
# autogen.sh needs to be executed in SOURCE_DIR, not in build directory

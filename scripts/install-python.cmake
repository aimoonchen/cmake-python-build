# Download Windows executable

cmake_minimum_required(VERSION 3.24)

include(FetchContent)

option(CMAKE_TLS_VERIFY "verify TLS certificates" on)

if(NOT python_version)
  file(READ ${CMAKE_CURRENT_LIST_DIR}/../libraries.json json_meta)
  string(JSON python_version GET ${json_meta} "python" "version")
endif()

if(NOT prefix)
  file(REAL_PATH "~/python-${python_version}" prefix EXPAND_TILDE)
endif()

if(NOT DEFINED ENV{PROCESSOR_ARCHITECTURE})
  message(FATAL_ERROR "PROCESSOR_ARCHITECTURE not set, could not determine CPU arch")
endif()
set(arch $ENV{PROCESSOR_ARCHITECTURE})

if(arch STREQUAL "ARM64")
  set(pyarch arm64)
elseif(arch STREQUAL "AMD64")
  set(pyarch amd64)
elseif(arch STREQUAL "x86")
  set(pyarch win32)
else()
  message(FATAL_ERROR "unknown arch: ${arch}")
endif()

if(NOT python_url)
  # omit "rc*" from the url dir
  string(REGEX REPLACE "rc[0-9]+$" "" python_url_dir "${python_version}")
  set(python_url https://www.python.org/ftp/python/${python_url_dir}/python-${python_version}-embed-${pyarch}.zip)
endif()

message(STATUS "Python ${python_version}  ${python_url}")
message(STATUS "Python ${python_version}  ${prefix}")

set(FETCHCONTENT_QUIET false)

FetchContent_Populate(cmake URL ${python_url} SOURCE_DIR ${prefix})

file(MAKE_DIRECTORY ${prefix})
file(COPY ${cmake_SOURCE_DIR}/ DESTINATION ${prefix})

# --- so Python can find libs
string(REGEX MATCH "(^[0-9]+)\\.([0-9]+)" python_version_short ${python_version})
set(python_version_short ${CMAKE_MATCH_1}${CMAKE_MATCH_2})

find_file(pth
NAMES python${python_version_short}._pth
HINTS ${prefix}
NO_DEFAULT_PATH
REQUIRE
)

file(RENAME ${pth} ${prefix}/python${python_version_short}.pth)

set(pth ${prefix}/python${python_version_short}.pth)

# --- verify
find_program(python_exe
NAMES python3 python
HINTS ${prefix}
NO_DEFAULT_PATH
REQUIRED
)

# --- add paths to Python
file(APPEND "${pth}" "${prefix}/Lib\n")

# --- pip
file(DOWNLOAD https://bootstrap.pypa.io/get-pip.py ${prefix}/get-pip.py)

execute_process(COMMAND ${python_exe} ${prefix}/get-pip.py)

cmake_path(GET python_exe PARENT_PATH bindir)
message(STATUS "installed Python ${python_version} to ${bindir}")

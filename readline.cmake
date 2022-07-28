# readline
include(ExternalProject)

if(find)
  find_library(libreadline NAMES readline)
endif()

if(libreadline)
  add_custom_target(readline)
  return()
endif()

string(JSON readline_url GET ${json_meta} readline url)
string(JSON readline_tag GET ${json_meta} readline tag)

set(readline_args)

extproj_autotools(readline ${readline_url} ${readline_tag} "${readline_args}")

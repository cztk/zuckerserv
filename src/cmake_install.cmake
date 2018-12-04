# Install script for directory: /home/suckerserv/orig/zuckerserv/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/suckerserv/orig/zuckerserv/script/package/luatz/gettime.lua;/home/suckerserv/orig/zuckerserv/script/package/luatz/init.lua;/home/suckerserv/orig/zuckerserv/script/package/luatz/parse.lua;/home/suckerserv/orig/zuckerserv/script/package/luatz/strftime.lua;/home/suckerserv/orig/zuckerserv/script/package/luatz/timetable.lua;/home/suckerserv/orig/zuckerserv/script/package/luatz/tzcache.lua;/home/suckerserv/orig/zuckerserv/script/package/luatz/tzfile.lua;/home/suckerserv/orig/zuckerserv/script/package/luatz/tzinfo.lua")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/suckerserv/orig/zuckerserv/script/package/luatz" TYPE FILE FILES
    "/home/suckerserv/orig/zuckerserv/src/luatz/luatz/gettime.lua"
    "/home/suckerserv/orig/zuckerserv/src/luatz/luatz/init.lua"
    "/home/suckerserv/orig/zuckerserv/src/luatz/luatz/parse.lua"
    "/home/suckerserv/orig/zuckerserv/src/luatz/luatz/strftime.lua"
    "/home/suckerserv/orig/zuckerserv/src/luatz/luatz/timetable.lua"
    "/home/suckerserv/orig/zuckerserv/src/luatz/luatz/tzcache.lua"
    "/home/suckerserv/orig/zuckerserv/src/luatz/luatz/tzfile.lua"
    "/home/suckerserv/orig/zuckerserv/src/luatz/luatz/tzinfo.lua"
    )
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/sauer_server" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/sauer_server")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/sauer_server"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/suckerserv/orig/zuckerserv/bin/sauer_server")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/suckerserv/orig/zuckerserv/bin" TYPE EXECUTABLE FILES "/home/suckerserv/orig/zuckerserv/src/sauer_server")
  if(EXISTS "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/sauer_server" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/sauer_server")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/sauer_server")
    endif()
  endif()
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/monitor" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/monitor")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/monitor"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/suckerserv/orig/zuckerserv/bin/monitor")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/suckerserv/orig/zuckerserv/bin" TYPE EXECUTABLE FILES "/home/suckerserv/orig/zuckerserv/src/monitor")
  if(EXISTS "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/monitor" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/monitor")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/monitor")
    endif()
  endif()
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/utils/keygen" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/utils/keygen")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/utils/keygen"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/suckerserv/orig/zuckerserv/bin/utils/keygen")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/suckerserv/orig/zuckerserv/bin/utils" TYPE EXECUTABLE FILES "/home/suckerserv/orig/zuckerserv/src/keygen")
  if(EXISTS "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/utils/keygen" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/utils/keygen")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/suckerserv/orig/zuckerserv/bin/utils/keygen")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/suckerserv/orig/zuckerserv/src/enet/cmake_install.cmake")
  include("/home/suckerserv/orig/zuckerserv/src/lsqlite3/cmake_install.cmake")
  include("/home/suckerserv/orig/zuckerserv/src/hopmod/standalone/luapp/cmake_install.cmake")
  include("/home/suckerserv/orig/zuckerserv/src/luasql/cmake_install.cmake")
  include("/home/suckerserv/orig/zuckerserv/src/authserver/cmake_install.cmake")

endif()


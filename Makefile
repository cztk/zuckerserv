# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.7

# Default target executed when no arguments are given to make.
default_target: all

.PHONY : default_target

# Allow only one "make -f Makefile2" at a time, but pass parallelism.
.NOTPARALLEL:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/suckerserv/orig/zuckerserv

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/suckerserv/orig/zuckerserv

#=============================================================================
# Targets provided globally by CMake.

# Special rule for the target install/strip
install/strip: preinstall
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Installing the project stripped..."
	/usr/bin/cmake -DCMAKE_INSTALL_DO_STRIP=1 -P cmake_install.cmake
.PHONY : install/strip

# Special rule for the target install/strip
install/strip/fast: install/strip

.PHONY : install/strip/fast

# Special rule for the target install/local
install/local: preinstall
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Installing only the local directory..."
	/usr/bin/cmake -DCMAKE_INSTALL_LOCAL_ONLY=1 -P cmake_install.cmake
.PHONY : install/local

# Special rule for the target install/local
install/local/fast: install/local

.PHONY : install/local/fast

# Special rule for the target edit_cache
edit_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "No interactive CMake dialog available..."
	/usr/bin/cmake -E echo No\ interactive\ CMake\ dialog\ available.
.PHONY : edit_cache

# Special rule for the target edit_cache
edit_cache/fast: edit_cache

.PHONY : edit_cache/fast

# Special rule for the target rebuild_cache
rebuild_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake to regenerate build system..."
	/usr/bin/cmake -H$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : rebuild_cache

# Special rule for the target rebuild_cache
rebuild_cache/fast: rebuild_cache

.PHONY : rebuild_cache/fast

# Special rule for the target list_install_components
list_install_components:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Available install components are: \"Unspecified\""
.PHONY : list_install_components

# Special rule for the target list_install_components
list_install_components/fast: list_install_components

.PHONY : list_install_components/fast

# Special rule for the target install
install: preinstall
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Install the project..."
	/usr/bin/cmake -P cmake_install.cmake
.PHONY : install

# Special rule for the target install
install/fast: preinstall/fast
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Install the project..."
	/usr/bin/cmake -P cmake_install.cmake
.PHONY : install/fast

# The main all target
all: cmake_check_build_system
	$(CMAKE_COMMAND) -E cmake_progress_start /home/suckerserv/orig/zuckerserv/CMakeFiles /home/suckerserv/orig/zuckerserv/CMakeFiles/progress.marks
	$(MAKE) -f CMakeFiles/Makefile2 all
	$(CMAKE_COMMAND) -E cmake_progress_start /home/suckerserv/orig/zuckerserv/CMakeFiles 0
.PHONY : all

# The main clean target
clean:
	$(MAKE) -f CMakeFiles/Makefile2 clean
.PHONY : clean

# The main clean target
clean/fast: clean

.PHONY : clean/fast

# Prepare targets for installation.
preinstall: all
	$(MAKE) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall

# Prepare targets for installation.
preinstall/fast:
	$(MAKE) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall/fast

# clear depends
depend:
	$(CMAKE_COMMAND) -H$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 1
.PHONY : depend

#=============================================================================
# Target rules for targets named sauer_server

# Build rule for target.
sauer_server: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 sauer_server
.PHONY : sauer_server

# fast build rule for target.
sauer_server/fast:
	$(MAKE) -f src/CMakeFiles/sauer_server.dir/build.make src/CMakeFiles/sauer_server.dir/build
.PHONY : sauer_server/fast

#=============================================================================
# Target rules for targets named lua_modules

# Build rule for target.
lua_modules: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 lua_modules
.PHONY : lua_modules

# fast build rule for target.
lua_modules/fast:
	$(MAKE) -f src/CMakeFiles/lua_modules.dir/build.make src/CMakeFiles/lua_modules.dir/build
.PHONY : lua_modules/fast

#=============================================================================
# Target rules for targets named sauertools

# Build rule for target.
sauertools: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 sauertools
.PHONY : sauertools

# fast build rule for target.
sauertools/fast:
	$(MAKE) -f src/CMakeFiles/sauertools.dir/build.make src/CMakeFiles/sauertools.dir/build
.PHONY : sauertools/fast

#=============================================================================
# Target rules for targets named monitor

# Build rule for target.
monitor: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 monitor
.PHONY : monitor

# fast build rule for target.
monitor/fast:
	$(MAKE) -f src/CMakeFiles/monitor.dir/build.make src/CMakeFiles/monitor.dir/build
.PHONY : monitor/fast

#=============================================================================
# Target rules for targets named keygen

# Build rule for target.
keygen: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 keygen
.PHONY : keygen

# fast build rule for target.
keygen/fast:
	$(MAKE) -f src/CMakeFiles/keygen.dir/build.make src/CMakeFiles/keygen.dir/build
.PHONY : keygen/fast

#=============================================================================
# Target rules for targets named enet

# Build rule for target.
enet: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 enet
.PHONY : enet

# fast build rule for target.
enet/fast:
	$(MAKE) -f src/enet/CMakeFiles/enet.dir/build.make src/enet/CMakeFiles/enet.dir/build
.PHONY : enet/fast

#=============================================================================
# Target rules for targets named lsqlite3

# Build rule for target.
lsqlite3: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 lsqlite3
.PHONY : lsqlite3

# fast build rule for target.
lsqlite3/fast:
	$(MAKE) -f src/lsqlite3/CMakeFiles/lsqlite3.dir/build.make src/lsqlite3/CMakeFiles/lsqlite3.dir/build
.PHONY : lsqlite3/fast

#=============================================================================
# Target rules for targets named luapp

# Build rule for target.
luapp: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 luapp
.PHONY : luapp

# fast build rule for target.
luapp/fast:
	$(MAKE) -f src/hopmod/standalone/luapp/CMakeFiles/luapp.dir/build.make src/hopmod/standalone/luapp/CMakeFiles/luapp.dir/build
.PHONY : luapp/fast

#=============================================================================
# Target rules for targets named luasql_mysql

# Build rule for target.
luasql_mysql: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 luasql_mysql
.PHONY : luasql_mysql

# fast build rule for target.
luasql_mysql/fast:
	$(MAKE) -f src/luasql/CMakeFiles/luasql_mysql.dir/build.make src/luasql/CMakeFiles/luasql_mysql.dir/build
.PHONY : luasql_mysql/fast

#=============================================================================
# Target rules for targets named sauer_authserver

# Build rule for target.
sauer_authserver: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 sauer_authserver
.PHONY : sauer_authserver

# fast build rule for target.
sauer_authserver/fast:
	$(MAKE) -f src/authserver/CMakeFiles/sauer_authserver.dir/build.make src/authserver/CMakeFiles/sauer_authserver.dir/build
.PHONY : sauer_authserver/fast

# Help Target
help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... all (the default if no target is provided)"
	@echo "... clean"
	@echo "... depend"
	@echo "... install/strip"
	@echo "... install/local"
	@echo "... edit_cache"
	@echo "... rebuild_cache"
	@echo "... list_install_components"
	@echo "... install"
	@echo "... sauer_server"
	@echo "... lua_modules"
	@echo "... sauertools"
	@echo "... monitor"
	@echo "... keygen"
	@echo "... enet"
	@echo "... lsqlite3"
	@echo "... luapp"
	@echo "... luasql_mysql"
	@echo "... sauer_authserver"
.PHONY : help



#=============================================================================
# Special targets to cleanup operation of make.

# Special rule to run CMake to check the build system integrity.
# No rule that depends on this can have commands that come from listfiles
# because they might be regenerated.
cmake_check_build_system:
	$(CMAKE_COMMAND) -H$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 0
.PHONY : cmake_check_build_system

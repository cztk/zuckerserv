# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.7

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


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

# Include any dependencies generated for this target.
include src/lsqlite3/CMakeFiles/lsqlite3.dir/depend.make

# Include the progress variables for this target.
include src/lsqlite3/CMakeFiles/lsqlite3.dir/progress.make

# Include the compile flags for this target's objects.
include src/lsqlite3/CMakeFiles/lsqlite3.dir/flags.make

src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o: src/lsqlite3/CMakeFiles/lsqlite3.dir/flags.make
src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o: src/lsqlite3/lsqlite3.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/suckerserv/orig/zuckerserv/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o"
	cd /home/suckerserv/orig/zuckerserv/src/lsqlite3 && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/lsqlite3.dir/lsqlite3.c.o   -c /home/suckerserv/orig/zuckerserv/src/lsqlite3/lsqlite3.c

src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/lsqlite3.dir/lsqlite3.c.i"
	cd /home/suckerserv/orig/zuckerserv/src/lsqlite3 && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/suckerserv/orig/zuckerserv/src/lsqlite3/lsqlite3.c > CMakeFiles/lsqlite3.dir/lsqlite3.c.i

src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/lsqlite3.dir/lsqlite3.c.s"
	cd /home/suckerserv/orig/zuckerserv/src/lsqlite3 && /usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/suckerserv/orig/zuckerserv/src/lsqlite3/lsqlite3.c -o CMakeFiles/lsqlite3.dir/lsqlite3.c.s

src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o.requires:

.PHONY : src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o.requires

src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o.provides: src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o.requires
	$(MAKE) -f src/lsqlite3/CMakeFiles/lsqlite3.dir/build.make src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o.provides.build
.PHONY : src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o.provides

src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o.provides.build: src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o


# Object files for target lsqlite3
lsqlite3_OBJECTS = \
"CMakeFiles/lsqlite3.dir/lsqlite3.c.o"

# External object files for target lsqlite3
lsqlite3_EXTERNAL_OBJECTS =

src/lsqlite3/liblsqlite3.so: src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o
src/lsqlite3/liblsqlite3.so: src/lsqlite3/CMakeFiles/lsqlite3.dir/build.make
src/lsqlite3/liblsqlite3.so: /usr/lib/x86_64-linux-gnu/libluajit-5.1.so
src/lsqlite3/liblsqlite3.so: src/lsqlite3/CMakeFiles/lsqlite3.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/suckerserv/orig/zuckerserv/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C shared library liblsqlite3.so"
	cd /home/suckerserv/orig/zuckerserv/src/lsqlite3 && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/lsqlite3.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/lsqlite3/CMakeFiles/lsqlite3.dir/build: src/lsqlite3/liblsqlite3.so

.PHONY : src/lsqlite3/CMakeFiles/lsqlite3.dir/build

src/lsqlite3/CMakeFiles/lsqlite3.dir/requires: src/lsqlite3/CMakeFiles/lsqlite3.dir/lsqlite3.c.o.requires

.PHONY : src/lsqlite3/CMakeFiles/lsqlite3.dir/requires

src/lsqlite3/CMakeFiles/lsqlite3.dir/clean:
	cd /home/suckerserv/orig/zuckerserv/src/lsqlite3 && $(CMAKE_COMMAND) -P CMakeFiles/lsqlite3.dir/cmake_clean.cmake
.PHONY : src/lsqlite3/CMakeFiles/lsqlite3.dir/clean

src/lsqlite3/CMakeFiles/lsqlite3.dir/depend:
	cd /home/suckerserv/orig/zuckerserv && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/suckerserv/orig/zuckerserv /home/suckerserv/orig/zuckerserv/src/lsqlite3 /home/suckerserv/orig/zuckerserv /home/suckerserv/orig/zuckerserv/src/lsqlite3 /home/suckerserv/orig/zuckerserv/src/lsqlite3/CMakeFiles/lsqlite3.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/lsqlite3/CMakeFiles/lsqlite3.dir/depend


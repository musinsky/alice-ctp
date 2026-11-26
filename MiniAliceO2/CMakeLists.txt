# 2026-11-26

# cmake -S . -B build/ # -DWITH_BunchFilling_cxx=OFF # -Wdev -Wdeprecated --warn-uninitialized
# cmake --build build/ --verbose

cmake_minimum_required(VERSION 3.31 FATAL_ERROR)
project(MiniAliceO2 LANGUAGES CXX)

find_package(ROOT REQUIRED COMPONENTS Core)
message(STATUS ">>> ROOT ${ROOT_VERSION}: ${ROOT_BINDIR}")
option(WITH_BunchFilling_cxx "Build shared library including BunchFilling.cxx" ON)
message(STATUS ">>> With BunchFilling.cxx: ${WITH_BunchFilling_cxx}")
message(STATUS ">>> Build type: ${CMAKE_BUILD_TYPE}")
add_compile_options(-Wall -Wextra -Wpedantic)

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/Parameters/include
  ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/common/include
  ${CMAKE_CURRENT_SOURCE_DIR}/Common/Constants/include
  ${CMAKE_CURRENT_SOURCE_DIR}/Common/Types/include
  ${CMAKE_CURRENT_SOURCE_DIR}/GPU/Common)

set(DICT_HDRS
    ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/Parameters/include/DataFormatsParameters/GRPLHCIFData.h
    ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/common/include/CommonDataFormat/BunchFilling.h)

ROOT_GENERATE_DICTIONARY(G__${PROJECT_NAME} ${DICT_HDRS} LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/LinkDef.h)

set(LIB_SRCS G__${PROJECT_NAME}.cxx) # library with dictionaries only
if(WITH_BunchFilling_cxx) # library with dictionaries and BunchFilling.cxx (specific case)
  list(PREPEND LIB_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/common/src/BunchFilling.cxx)
endif()

add_library(${PROJECT_NAME} SHARED ${LIB_SRCS})
target_link_libraries(${PROJECT_NAME} PUBLIC ROOT::Core)

set(MAO2_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/include)
# find_program(RSYNC_COMMAND rsync REQUIRED)
# COMMAND ${RSYNC_COMMAND} --archive --delete             SRC DST # less portable
# COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different SRC DST # more universal than rsync
add_custom_target(
  custom_copy_headers
  ALL
  COMMAND
    ${CMAKE_COMMAND}
    -E
    copy_directory_if_different
    ${CMAKE_CURRENT_SOURCE_DIR}/Common/Constants/include
    ${MAO2_INCLUDE_DIR}
  COMMAND
    ${CMAKE_COMMAND}
    -E
    copy_directory_if_different
    ${CMAKE_CURRENT_SOURCE_DIR}/Common/Types/include
    ${MAO2_INCLUDE_DIR}
  COMMAND
    ${CMAKE_COMMAND}
    -E
    copy_directory_if_different
    ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/Parameters/include
    ${MAO2_INCLUDE_DIR}
  COMMAND
    ${CMAKE_COMMAND}
    -E
    copy_directory_if_different
    ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/common/include
    ${MAO2_INCLUDE_DIR}
  COMMAND
    ${CMAKE_COMMAND}
    -E
    copy_directory_if_different
    ${CMAKE_CURRENT_SOURCE_DIR}/GPU/Common
    ${MAO2_INCLUDE_DIR}/GPU
  VERBATIM)

add_dependencies(${PROJECT_NAME} custom_copy_headers)

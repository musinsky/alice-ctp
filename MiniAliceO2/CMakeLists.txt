# 2026-11-26

# cmake -S . -B build/ # -DWITH_BunchFilling_cxx=OFF # -Wdev -Wdeprecated --warn-uninitialized
# cmake --build build/ --verbose

cmake_minimum_required(VERSION 3.31 FATAL_ERROR)

project(MiniAliceO2 LANGUAGES CXX)

find_package(ROOT REQUIRED COMPONENTS Core)

include(${ROOT_USE_FILE})

option(WITH_BunchFilling_cxx "Build shared library including BunchFilling.cxx" ON)
message(STATUS ">>> With BunchFilling.cxx: ${WITH_BunchFilling_cxx}")
message(STATUS ">>> Build type: ${CMAKE_BUILD_TYPE}")

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

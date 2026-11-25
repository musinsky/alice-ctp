# 2026-11-25
# https://root.cern/manual/integrate_root_into_my_cmake_project/
# https://root.cern/manual/io_custom_classes/#using-cmake
# https://github.com/root-project/root/tree/master/tutorials/io/tree/dictionary
# https://cliutils.gitlab.io/modern-cmake/root/

# cmake -S . -B build
# cmake --build build --verbose

cmake_minimum_required(VERSION 3.31 FATAL_ERROR)

project(MiniAliceO2 LANGUAGES CXX)

find_package(ROOT REQUIRED COMPONENTS Core)

include(${ROOT_USE_FILE})

# # To ensure compatibility between ROOT's C++ interpreter, Cling, and compiled
# # code, your application (target in CMake) must be compiled with the same
# # C++ standard with which ROOT was compiled.
# #
# # root/cmake/ROOTConfig.cmake  => set(ROOT_CXX_STANDARD 20)
# # root/cmake/ROOTUseFile.cmake => set(CMAKE_CXX_STANDARD ${ROOT_CXX_STANDARD})
# set(CMAKE_CXX_STANDARD ${ROOT_CXX_STANDARD})
# set(CMAKE_CXX_STANDARD 23)
# message(NOTICE "ROOT_CXX_STANDARD =  ${ROOT_CXX_STANDARD}")
# message(NOTICE "CMAKE_CXX_STANDARD = ${CMAKE_CXX_STANDARD}")
# set(CMAKE_CXX_STANDARD_REQUIRED ON) # enforce the specified C++ standard
# set(CMAKE_CXX_EXTENSIONS OFF) # compiler specific extensions (gnu++ vs c++)
# #
# # CMake, resp. ROOTConfig.cmake automaticky nastavi potrebny C++ standard.
# #
# # POZOR
# # https://cmake.org/cmake/help/latest/prop_tgt/CXX_STANDARD.html
# # CMake interpretuje CXX_STANDARD ako pozadovany minimalny C++ standard,
# # nie ako presny prikaz pre dany standard. Ak kompilator uz splna pozadovany
# # C++ standard, nemusi pridat ziaden '-std=' parameter navyse.

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/Parameters/include
  ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/common/include
  ${CMAKE_CURRENT_SOURCE_DIR}/Common/Constants/include
  ${CMAKE_CURRENT_SOURCE_DIR}/Common/Types/include
  ${CMAKE_CURRENT_SOURCE_DIR}/GPU/Common)

set(HDRS_CLING
    ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/Parameters/include/DataFormatsParameters/GRPLHCIFData.h
    ${CMAKE_CURRENT_SOURCE_DIR}/DataFormats/common/include/CommonDataFormat/BunchFilling.h)

ROOT_GENERATE_DICTIONARY(G__${PROJECT_NAME} ${HDRS_CLING} LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/LinkDef.h)

add_library(${PROJECT_NAME} SHARED G__${PROJECT_NAME}.cxx)
target_link_libraries(${PROJECT_NAME} PUBLIC ROOT::Core)

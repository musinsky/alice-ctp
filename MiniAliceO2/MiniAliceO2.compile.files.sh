#!/usr/bin/env bash

# 2026-11-25
# shellcheck disable=SC2046

set -e -x
OUT_NAME="MiniAliceO4"
INC=(
  "-IDataFormats/Parameters/include"
  "-IDataFormats/common/include"
  "-ICommon/Constants/include"
  "-ICommon/Types/include"
  "-IGPU/Common"
)

rootcling -f "G__${OUT_NAME}.cxx" \
  -s "lib${OUT_NAME}.so" -rml "lib${OUT_NAME}.so" -rmf "lib${OUT_NAME}.rootmap" \
  "${INC[@]}" \
  DataFormats/Parameters/include/DataFormatsParameters/GRPLHCIFData.h \
  DataFormats/common/include/CommonDataFormat/BunchFilling.h \
  LinkDef.h

g++ -fPIC -shared "G__${OUT_NAME}.cxx" "${INC[@]}" \
  -o "lib${OUT_NAME}.so" $(root-config --cflags --libs)

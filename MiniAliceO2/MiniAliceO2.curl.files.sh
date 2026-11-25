#!/usr/bin/env bash

# 2026-11-25

curl_file() {
  local file="${1}"
  local commit_date tmp_file
  tmp_file="$(mktemp)"

  curl --fail --silent --show-error --write-out "%{url}\n" \
    --location "${ALICEO2_GH_RAW}/${file}" --output "${file}" --create-dirs || return 1

  commit_date="$(curl --silent "${ALICEO2_GH_API}?sha=dev&path=${file}&per_page=1" \
    | jq --raw-output '.[0].commit.committer.date')"
  # prepend info
  {
    printf "// %s (%s)\n\n" "${ALICEO2_GH_BLOB}/${file}" "$(date --date "${commit_date}" +%F)"
    cat "${file}"
  } > "${tmp_file}" && mv "${tmp_file}" "${file}"
  # change file timestamp
  touch --date "${commit_date}" "${file}"
}

ALICEO2_GH='AliceO2Group/AliceO2'
ALICEO2_GH_BLOB="https://github.com/${ALICEO2_GH}/blob/dev"
ALICEO2_GH_RAW="https://raw.githubusercontent.com/${ALICEO2_GH}/dev"
ALICEO2_GH_API="https://api.github.com/repos/${ALICEO2_GH}/commits"

curl_file "DataFormats/Parameters/include/DataFormatsParameters/GRPLHCIFData.h"
# curl_file "DataFormats/Parameters/src/GRPLHCIFData.cxx"
# curl_file "DataFormats/Parameters/src/ParametersDataLinkDef.h"
curl_file "DataFormats/common/include/CommonDataFormat/BunchFilling.h"
# curl_file "DataFormats/common/src/BunchFilling.cxx"
# curl_file "DataFormats/common/src/CommonDataFormatLinkDef.h"

curl_file "Common/Constants/include/CommonConstants/LHCConstants.h" # header only file
curl_file "Common/Types/include/CommonTypes/Units.h"                # header only file

curl_file "GPU/Common/GPUCommonDef.h"         # header only file
curl_file "GPU/Common/GPUCommonDefSettings.h" # header only file
curl_file "GPU/Common/GPUCommonDefAPI.h"      # header only file

tree -- */ > "${PWD##*/}.structure.tree" # SC2035 correct

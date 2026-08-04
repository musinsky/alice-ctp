#!/usr/bin/env bash

# 2026-08-08

# General Run Parameters from LHC InterFace data
# http://alice-ccdb.cern.ch/browse/GLO/Config/GRPLHCIF
# 2021-12-10   first entry (created)

# Run Condition Table
# http://alice-ccdb.cern.ch/latest/RCT/Info/RunInformation   !!! very large  !!!
# 2022-05-02   first entry (created)

# http://ali-qcdb-gpn.cern.ch:8083/browse/qc/CTP/MO/RawData
# 2024-10-01   QC starts saving qc/CTP/MO/RawData/bcMinBias<N>
# 2026-03-12   QC starts saving qc/CTP/MO/RawData/input<NN>

# 2026-06-25   LHC Run 3 ends, latest Alice Run (COMMISSIONING, PHYSICS)
# https://ali-bookkeeping.cern.ch/?page=lhc-fill-details&fillNumber=12014
# https://ali-bookkeeping.cern.ch/?page=run-detail&runNumber=572822

export SNAPSHOT_BASE="${HOME}/ALICE-DATA-2/ccdb"
export CCDB_HOST='alice-ccdb.cern.ch'
export CCDB_PATH='GLO/Config/GRPLHCIF'
export TS_LOWER='2026-03-01'
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh
export TS_LOWER='2024-10-01'
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh
export TS_LOWER="0"
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh

export CCDB_PATH='RCT/Info/RunInformation'
export TS_LOWER='2026-03-01'
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh
export TS_LOWER='2024-10-01'
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh
export TS_LOWER="0"
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh

printf "\n!!! QCDB access is restricted to CERN GPN (CERN network only) !!!\n"
export SNAPSHOT_BASE="${HOME}/ALICE-DATA-2/qcdb"
export CCDB_HOST='ali-qcdb-gpn.cern.ch:8083'
export CCDB_PATH='qc/CTP/MO/RawData/bcMinBias1'
export TS_LOWER='2026-03-01'
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh
export TS_LOWER='0'
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh

export CCDB_PATH='qc/CTP/MO/RawData/bcMinBias2'
export TS_LOWER='2026-03-01'
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh
export TS_LOWER='0'
export TS_UPPER='2026-07-01'
./ccdb.json.snapshot.sh

#!/usr/bin/env bash
set -Eeuxo pipefail

BIDS_DIR="/media/peripheral/Code/Comp432/machine-learning-mechanism-of-multisensory-learning/ds007436"
OUT_DIR="/media/peripheral/Code/Comp432/dataset/derivatives"
WORK_DIR="/media/peripheral/Code/Comp432/dataset/work"
FS_LICENSE="/media/peripheral/Code/Comp432/machine-learning-mechanism-of-multisensory-learning/license.txt"

NTHREADS=8
OMP_NTHREADS=4
MEM_MB=24000

mkdir -p "$OUT_DIR" "$WORK_DIR"

command -v fmriprep-docker >/dev/null
docker ps >/dev/null

SUB="01"   # change to a subject you know exists

fmriprep-docker \
  "$BIDS_DIR" \
  "$OUT_DIR" \
  participant \
  --participant-label "$SUB" \
  --fs-license-file "$FS_LICENSE" \
  --nthreads "$NTHREADS" \
  --omp-nthreads "$OMP_NTHREADS" \
  --mem-mb "$MEM_MB" \
  --output-spaces MNI152NLin2009cAsym \
  --fs-no-reconall \
  -w "$WORK_DIR"
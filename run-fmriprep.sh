#!/usr/bin/env bash

# =========================
# CONFIGURATION
# =========================

# Path to your BIDS dataset
BIDS_DIR="/media/peripheral/Code/Comp432/machine-learning-mechanism-of-multisensory-learning/ds007436-download"

# Output directory (will contain derivatives/fmriprep)
OUT_DIR="/media/peripheral/Code/Comp432/dataset/derivatives/"

# Working directory (VERY important for speed)
WORK_DIR="/media/peripheral/Code/Comp432/dataset/work/"

# FreeSurfer license (NOT needed since we skip recon-all, but keep for safety)
FS_LICENSE="/media/peripheral/Code/Comp432/machine-learning-mechanism-of-multisensory-learning/license.txt"

# Number of CPUs and memory (tuned for your machine)
NTHREADS=8
OMP_NTHREADS=4
MEM_MB=24000   # ~24GB of your 32GB RAM

# Docker image
IMAGE="nipreps/fmriprep:latest"

# =========================
# SUBJECT LIST
# =========================

# Automatically detect subjects
SUBJECTS=$(ls -d ${BIDS_DIR}/sub-* | xargs -n 1 basename | sed 's/sub-//')

# =========================
# RUN FUNCTION
# =========================

run_subject () {
    SUB=$1
    echo "Running subject: $SUB"

    docker run --rm -it \
        -v ${BIDS_DIR}:/data:ro \
        -v ${OUT_DIR}:/out \
        -v ${WORK_DIR}:/work \
        -v ${FS_LICENSE}:/opt/freesurfer/license.txt \
        ${IMAGE} \
        /data /out participant \
        --participant-label ${SUB} \
        --nthreads ${NTHREADS} \
        --omp-nthreads ${OMP_NTHREADS} \
        --mem-mb ${MEM_MB} \
        --output-spaces MNI152NLin2009cAsym \
        --fs-no-reconall \
        --skip-bids-validation \
        --use-aroma \
        -w /work
}

# =========================
# PARALLEL EXECUTION
# =========================

MAX_PARALLEL=3   # SAFE for your CPU/RAM

running=0

for sub in $SUBJECTS; do
    run_subject $sub &

    ((running+=1))

    if [ "$running" -ge "$MAX_PARALLEL" ]; then
        wait -n
        ((running-=1))
    fi
done

wait

echo "All subjects completed."
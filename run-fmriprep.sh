#!/usr/bin/env bash
set -uo pipefail

BIDS_DIR="/media/peripheral/Code/Comp432/machine-learning-mechanism-of-multisensory-learning/original-dataset"
OUT_DIR="/media/peripheral/Code/Comp432/dataset/derivatives"
WORK_DIR="/media/peripheral/Code/Comp432/dataset/work"
FS_LICENSE="/media/peripheral/Code/Comp432/machine-learning-mechanism-of-multisensory-learning/license.txt"

NTHREADS=8
OMP_NTHREADS=4
MEM_MB=24000
MAX_PARALLEL=2

LOG_DIR="$OUT_DIR/logs"

mkdir -p "$OUT_DIR" "$WORK_DIR" "$LOG_DIR"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

[[ -d "$BIDS_DIR" ]] || fail "BIDS_DIR does not exist: $BIDS_DIR"
[[ -f "$FS_LICENSE" ]] || fail "FreeSurfer license not found: $FS_LICENSE"
[[ -w "$OUT_DIR" ]] || fail "OUT_DIR is not writable: $OUT_DIR"
[[ -w "$WORK_DIR" ]] || fail "WORK_DIR is not writable: $WORK_DIR"
[[ -w "$LOG_DIR" ]] || fail "LOG_DIR is not writable: $LOG_DIR"

command -v fmriprep-docker >/dev/null 2>&1 || fail "fmriprep-docker not found in PATH"
docker ps >/dev/null 2>&1 || fail "Docker is not accessible for this user"

mapfile -t SUBJECTS < <(
  find "$BIDS_DIR" -mindepth 1 -maxdepth 1 -type d -name 'sub-*' -printf '%f\n' \
  | sed 's/^sub-//' \
  | sort
)

(( ${#SUBJECTS[@]} > 0 )) || fail "No subjects found under $BIDS_DIR"

echo "Found ${#SUBJECTS[@]} subjects"
echo "Logs: $LOG_DIR"

run_subject() {
  local sub="$1"
  local log_file="$LOG_DIR/sub-${sub}.log"

  {
    echo "[$(date '+%F %T')] START sub-${sub}"

    fmriprep-docker \
      --no-tty \
      --fs-license-file "$FS_LICENSE" \
      "$BIDS_DIR" \
      "$OUT_DIR" \
      participant \
      --participant-label "$sub" \
      --nthreads "$NTHREADS" \
      --omp-nthreads "$OMP_NTHREADS" \
      --mem-mb "$MEM_MB" \
      --fs-no-reconall \
      --skip-bids-validation \
      --output-spaces MNI152NLin2009cAsym \
      -w "$WORK_DIR"

    status=$?
    echo "[$(date '+%F %T')] END sub-${sub} status=${status}"
    exit "$status"
  } >"$log_file" 2>&1
}

declare -A PID_TO_SUB=()
running=0
failures=0

for sub in "${SUBJECTS[@]}"; do
  echo "[$(date '+%F %T')] Launching sub-${sub}"
  run_subject "$sub" &
  pid=$!
  PID_TO_SUB["$pid"]="$sub"
  ((running+=1))

  if (( running >= MAX_PARALLEL )); then
    if wait -n; then
      :
    else
      echo "A job failed. Check logs in $LOG_DIR" >&2
      ((failures+=1))
    fi
    ((running-=1))
  fi
done

for pid in "${!PID_TO_SUB[@]}"; do
  if wait "$pid"; then
    echo "sub-${PID_TO_SUB[$pid]} completed successfully"
  else
    echo "sub-${PID_TO_SUB[$pid]} failed. See $LOG_DIR/sub-${PID_TO_SUB[$pid]}.log" >&2
    ((failures+=1))
  fi
done

if (( failures > 0 )); then
  echo "Finished with $failures failed subject(s)." >&2
  exit 1
fi

echo "All subjects completed successfully."
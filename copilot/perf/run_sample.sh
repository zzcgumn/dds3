#!/usr/bin/env bash
# Helper script to run bazel dtest under macOS `sample` and save output to artifacts.
# Usage:
#   ./copilot/perf/run_sample.sh [--duration seconds] [--bench hands/list100.txt]
# Example:
#   ./copilot/perf/run_sample.sh --duration 20 --bench hands/list100.txt

set -euo pipefail
DURATION=20
BENCH=hands/list100.txt
OUTDIR=copilot/perf/artifacts
mkdir -p "$OUTDIR"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --duration)
      DURATION="$2"; shift 2;;
    --bench)
      BENCH="$2"; shift 2;;
    --help)
      echo "Usage: $0 [--duration seconds] [--bench file]"; exit 0;;
    *)
      echo "Unknown arg: $1"; exit 1;;
  esac
done

# Build the binary with symbols (optimized)
bazel build //library/tests:dtest -c opt --copt=-g --define=new_heuristic=true

# Start the dtest in background and capture PID
./bazel-bin/library/tests/dtest --file "$BENCH" >/dev/null 2>&1 &
PID=$!

echo "Started dtest PID=$PID"

# Run sample for DURATION seconds
sudo sample $PID "$DURATION" > "$OUTDIR/sample-new-$(date +%Y%m%dT%H%M%S).txt" || true

# Ensure dtest is terminated
kill $PID 2>/dev/null || true
sleep 1

echo "Sample saved to $OUTDIR"

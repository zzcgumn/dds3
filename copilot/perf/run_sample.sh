#!/usr/bin/env bash
# Helper script to run bazel dtest under macOS `sample` and save output to artifacts.
# Usage:
#   ./copilot/perf/run_sample.sh [--duration seconds] [--bench hands/list100.txt]
# Example:
#   ./copilot/perf/run_sample.sh --duration 20 --bench hands/list100.txt

set -euo pipefail

# Configurable defaults
DURATION=20
BENCH=hands/list100.txt
OUTDIR=copilot/perf/artifacts
NAME="sample-new-$(date +%Y%m%dT%H%M%S)"
BUILD=true

mkdir -p "$OUTDIR"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --duration)
      DURATION="$2"; shift 2;;
    --bench)
      BENCH="$2"; shift 2;;
    --no-build)
      BUILD=false; shift 1;;
    --outdir)
      OUTDIR="$2"; shift 2;;
    --name)
      NAME="$2"; shift 2;;
    --help)
      echo "Usage: $0 [--duration seconds] [--bench file] [--no-build] [--name NAME] [--outdir DIR]"; exit 0;;
    *)
      echo "Unknown arg: $1"; exit 1;;
  esac
done

# Build the binary with symbols (optimized) unless user asked to skip build
if [ "$BUILD" = true ]; then
  echo "Building //library/tests:dtest (opt, with debug symbols)"
  bazel build //library/tests:dtest -c opt --copt=-g
else
  echo "Skipping build (user requested --no-build)"
fi

# Start the dtest in background and capture PID
./bazel-bin/library/tests/dtest --file "$BENCH" >/dev/null 2>&1 &
PID=$!

echo "Started dtest PID=$PID"

# Platform-specific capture
OS_NAME=$(uname -s)
case "$OS_NAME" in
  Darwin)
    # macOS: prefer `sample`. Try without sudo first for CI-friendly runs.
    SAMPLE_CMD=$(command -v sample || true)
    if [ -n "$SAMPLE_CMD" ]; then
      OUTFILE="$OUTDIR/${NAME}.txt"
      echo "Running macOS 'sample' for PID $PID for $DURATION s -> $OUTFILE"
      if $SAMPLE_CMD $PID $DURATION > "$OUTFILE" 2>&1; then
        echo "Sample saved to $OUTFILE"
      else
        echo "Warning: 'sample' failed (permission or unsupported). See $OUTFILE for details if any." >&2
      fi
    else
      echo "macOS 'sample' not found on PATH. Skipping capture." >&2
    fi
    ;;
  Linux)
    # Linux: use perf if available. Record perf.data by attaching to PID for duration.
    PERF_CMD=$(command -v perf || true)
    if [ -n "$PERF_CMD" ]; then
      OUTFILE="$OUTDIR/${NAME}.data"
      echo "Recording perf for PID $PID for $DURATION s -> $OUTFILE"
      # perf record will run until the sleep completes
      if $PERF_CMD record -F 99 -g -p $PID -o "$OUTFILE" -- sleep "$DURATION"; then
        echo "perf data saved to $OUTFILE"
      else
        echo "perf failed. You may need CAP_SYS_ADMIN or run in a privileged CI job." >&2
      fi
    else
      echo "perf not found on PATH. Skipping perf capture." >&2
    fi
    ;;
  *)
    echo "Unsupported OS: $OS_NAME. Skipping capture." >&2
    ;;
esac

# Ensure dtest is terminated
kill $PID 2>/dev/null || true
sleep 1

echo "Run complete; artifacts (if any) are under $OUTDIR"

#!/usr/bin/env bash
set -euo pipefail

SCAD_FILE="${1:-dual_pi5_macmini_v2_1_corrected_stack_koya.scad}"
OUT_DIR="${2:-exports/inspection}"

if ! command -v openscad >/dev/null 2>&1; then
  echo "ERROR: openscad CLI not found on PATH."
  exit 1
fi

if [ ! -f "$SCAD_FILE" ]; then
  echo "ERROR: SCAD file not found: $SCAD_FILE"
  exit 1
fi

mkdir -p "$OUT_DIR"

echo "Exporting inspection assembly..."
openscad \
  -o "$OUT_DIR/koya_assembly_inspection.stl" \
  -D "EXPORT_PART=\"assembly\"; SHOW_GHOSTS=true;" \
  "$SCAD_FILE"

echo "Exporting exploded inspection assembly..."
openscad \
  -o "$OUT_DIR/koya_assembly_exploded.stl" \
  -D "EXPORT_PART=\"assembly_exploded\"; SHOW_GHOSTS=true;" \
  "$SCAD_FILE"

echo "Inspection assembly written to $OUT_DIR/koya_assembly_inspection.stl"
echo "Exploded assembly written to $OUT_DIR/koya_assembly_exploded.stl"
echo "Do not print this as one part; it is for fit/orientation review only."

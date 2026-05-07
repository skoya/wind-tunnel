#!/usr/bin/env bash
set -euo pipefail

SCAD_FILE="${1:-dual_pi5_macmini_v2_1_corrected_stack_koya.scad}"
OUT_DIR="${2:-exports}"

if ! command -v openscad >/dev/null 2>&1; then
  echo "ERROR: openscad CLI not found on PATH."
  exit 1
fi

if [ ! -f "$SCAD_FILE" ]; then
  echo "ERROR: SCAD file not found: $SCAD_FILE"
  exit 1
fi

mkdir -p "$OUT_DIR"

parts=(
  base_duct
  front_fan_cassette
  lid_mac_saddle
  pi_frame_bridge
  pi_cassette_left
  pi_cassette_right
  upper_mac_fan_bridge
)

for part in "${parts[@]}"; do
  echo "Exporting $part..."
  openscad -o "$OUT_DIR/${part}.stl" -D "EXPORT_PART=\"${part}\"; SHOW_GHOSTS=false;" "$SCAD_FILE"
done

echo "Done. STLs written to $OUT_DIR/"

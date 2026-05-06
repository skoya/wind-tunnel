#!/usr/bin/env bash
set -euo pipefail

SCAD_FILE="${1:-dual_pi5_macmini_v2_1_corrected_stack_koya.scad}"

if ! command -v openscad >/dev/null 2>&1; then
  echo "ERROR: openscad CLI not found on PATH."
  exit 1
fi

if [ ! -f "$SCAD_FILE" ]; then
  echo "ERROR: SCAD file not found: $SCAD_FILE"
  exit 1
fi

mkdir -p exports/validation

parts=(
  assembly
  assembly_exploded
  fitted_with_hardware
  fitted_parts
  base_duct
  front_fan_cassette
  lid_mac_saddle
  pi_cassette_left
  pi_cassette_right
  upper_mac_fan_bridge
  front_noctua_grille
  front_cassette_with_grille
  mac_upper_cooler_preview
)

for part in "${parts[@]}"; do
  echo "Validating $part..."
  openscad -o "exports/validation/${part}.off" -D "EXPORT_PART=\"${part}\";" "$SCAD_FILE" >/tmp/openscad_${part}.log 2>&1 || {
    echo "FAILED: $part"
    cat /tmp/openscad_${part}.log
    exit 1
  }
done

echo "OpenSCAD validation completed."

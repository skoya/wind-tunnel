#!/usr/bin/env bash
set -euo pipefail

# Removes CFD tooling installed for KOYA airflow checks.
# Review before running. It uses apt only; it does not delete project outputs.

if ! command -v apt-get >/dev/null 2>&1; then
  echo "apt-get not found; nothing to do."
  exit 0
fi

packages=(
  openfoam
  openfoam-dev
  gmsh
  paraview
)

installed=()
for p in "${packages[@]}"; do
  if dpkg -s "$p" >/dev/null 2>&1; then
    installed+=("$p")
  fi
done

if [ "${#installed[@]}" -eq 0 ]; then
  echo "No known CFD packages from this setup are installed."
else
  echo "Removing: ${installed[*]}"
  sudo apt-get remove --purge -y "${installed[@]}"
  sudo apt-get autoremove -y
fi

echo "Cleanup complete. Project CFD files under exports/ or openfoam/ were left untouched."

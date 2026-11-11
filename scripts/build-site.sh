#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Assemble the landing site into _site/: site/ plus the images from docs/social and docs/ux.
#   ./scripts/build-site.sh [outdir]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/_site}"
rm -rf "$OUT" && mkdir -p "$OUT/social" "$OUT/ux"
cp -R "$ROOT"/site/. "$OUT/"
cp "$ROOT"/docs/social/*.jpg "$OUT/social/"
cp "$ROOT"/docs/ux/console-*.png "$OUT/ux/"
touch "$OUT/.nojekyll"
echo "built ${OUT#$ROOT/} ($(du -sh "$OUT" | cut -f1))"

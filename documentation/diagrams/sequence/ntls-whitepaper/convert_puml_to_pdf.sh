#!/usr/bin/env bash
set -e

# ------------------------------------------------------------------
# Script: convert_puml_to_pdf.sh
# Purpose: For each .puml in the current folder (except style.puml),
#          generate an SVG, convert it to PDF, delete the SVG, and
#          place the PDF in ./pdf.
# Requirements:
#   • plantuml  (brew install plantuml)
#   • librsvg   (brew install librsvg) → provides rsvg-convert
# Usage:
#   chmod +x convert_puml_to_pdf.sh
#   ./convert_puml_to_pdf.sh
# ------------------------------------------------------------------

# 1) Verify that required commands are available
if ! command -v plantuml &>/dev/null; then
  echo "Error: plantuml is not installed. Install via 'brew install plantuml' and try again."
  exit 1
fi

if ! command -v rsvg-convert &>/dev/null; then
  echo "Error: rsvg-convert is not installed. Install via 'brew install librsvg' and try again."
  exit 1
fi

# 2) Operate in the current directory
INPUT_DIR="."
OUTPUT_DIR="./pdf"

# 3) Create the output folder if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# 4) Loop over every .puml file in INPUT_DIR (skip style.puml)
for PUML_FILE in "$INPUT_DIR"/*.puml; do
  BASENAME="$(basename "$PUML_FILE" .puml)"

  # Skip style.puml entirely
  if [ "$BASENAME" = "style" ]; then
    continue
  fi

  SVG_FILE="$INPUT_DIR/$BASENAME.svg"
  PDF_FILE="$OUTPUT_DIR/$BASENAME.pdf"

  echo "Processing $BASENAME.puml …"

  # 4a) Generate SVG from the .puml
  plantuml -tsvg "$PUML_FILE" &>/dev/null || true

  # 4b) Check if PlantUML actually created the SVG
  if [ ! -f "$SVG_FILE" ]; then
    echo "  → No diagram found in $BASENAME.puml; skipping."
    continue
  fi

  # 4c) Convert the generated SVG to PDF
  rsvg-convert -f pdf "$SVG_FILE" -o "$PDF_FILE"
  echo "  → Created $PDF_FILE"

  # 4d) Remove the intermediate SVG
  rm "$SVG_FILE"
done

echo "✅ Done. PDFs are in: $OUTPUT_DIR"

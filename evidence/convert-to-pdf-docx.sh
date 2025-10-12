#!/bin/bash

# Evidence Files PDF/DOCX Conversion Script
# Converts all evidence markdown files to PDF and DOCX formats

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Create output directories
mkdir -p pdf
mkdir -p docx

echo "🔄 Converting evidence files to PDF and DOCX..."
echo ""

# Find all markdown files that match evidence pattern (MC-*.md or OC*.md)
FILES=(*.md)

# Check if any files exist
if [ ! -f "${FILES[0]}" ]; then
    echo "❌ No markdown files found in evidence directory"
    exit 1
fi

# Convert each file
for file in "${FILES[@]}"; do
    # Skip if not a file (shouldn't happen, but just in case)
    if [ -f "$file" ]; then
        basename="${file%.md}"
        echo "📄 Converting $file..."

        # Convert to DOCX
        pandoc "$file" \
            --resource-path="." \
            -o "docx/${basename}.docx" \
            --standalone \
            2>/dev/null || echo "⚠️  Warning: Failed to convert $file to DOCX"

        # Convert to PDF
        pandoc "$file" \
            --resource-path="." \
            -o "pdf/${basename}.pdf" \
            --pdf-engine=xelatex \
            -V geometry:margin=1in \
            --standalone \
            2>/dev/null || echo "⚠️  Warning: Failed to convert $file to PDF"

        echo "✅ $basename converted"
        echo ""
    fi
done

echo "✨ Conversion complete!"
echo ""
echo "📁 Output locations:"
echo "   PDF:  evidence/pdf/"
echo "   DOCX: evidence/docx/"
echo ""
echo "📊 Summary:"
ls -lh pdf/*.pdf 2>/dev/null | tail -n +2 | wc -l | xargs echo "   PDF files: "
ls -lh docx/*.docx 2>/dev/null | tail -n +2 | wc -l | xargs echo "   DOCX files:"
echo ""
echo "Total file sizes:"
du -sh pdf/ 2>/dev/null | awk '{print "   PDF:  " $1}'
du -sh docx/ 2>/dev/null | awk '{print "   DOCX: " $1}'

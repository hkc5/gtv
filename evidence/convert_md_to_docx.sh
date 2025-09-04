#!/bin/bash

# Convert all .md files in current directory to .docx using pandoc
# Usage: ./convert_md_to_docx.sh

echo "Converting all .md files to .docx format..."

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed. Please install it first:"
    echo "  brew install pandoc"
    exit 1
fi

# Count total files to convert
total_files=$(find . -name "*.md" | wc -l | tr -d ' ')
echo "Found $total_files .md files to convert"

# Convert each .md file to .docx
count=0
for file in *.md; do
    if [ -f "$file" ]; then
        # Get filename without extension
        basename="${file%.md}"
        output_file="${basename}.docx"
        
        echo "Converting: $file -> $output_file"
        
        # Convert with pandoc, preserving formatting
        pandoc "$file" -o "$output_file" \
            --from markdown \
            --to docx \
            --reference-doc=/dev/null 2>/dev/null || \
        pandoc "$file" -o "$output_file" \
            --from markdown \
            --to docx
        
        if [ $? -eq 0 ]; then
            count=$((count + 1))
            echo "  ✓ Successfully converted"
        else
            echo "  ✗ Failed to convert $file"
        fi
    fi
done

echo ""
echo "Conversion complete: $count/$total_files files converted successfully"
echo "Word documents created in current directory"
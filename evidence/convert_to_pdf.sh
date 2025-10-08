#!/bin/bash

# Convert all evidence markdown files to PDF
# Usage: ./convert_to_pdf.sh

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo -e "${YELLOW}Converting markdown files to PDF...${NC}\n"

# Counter for converted files
count=0
errors=0

# Find all .md files in current directory (not subdirectories)
for md_file in *.md; do
    # Skip if no .md files found
    if [ "$md_file" = "*.md" ]; then
        echo -e "${RED}No markdown files found in current directory${NC}"
        exit 1
    fi

    # Get filename without extension
    filename="${md_file%.md}"
    pdf_file="${filename}.pdf"

    echo -e "Converting: ${YELLOW}${md_file}${NC} -> ${GREEN}${pdf_file}${NC}"

    # Convert with pandoc
    # Options:
    #   -f markdown: from markdown format
    #   -t pdf: to PDF format
    #   --pdf-engine=pdflatex: use pdflatex as PDF engine
    #   -V geometry:margin=0.75in: 0.75 inch margins (for more content)
    #   -V fontsize=11pt: 11pt font size
    #   -V linkcolor=blue: blue hyperlinks
    #   --highlight-style=tango: syntax highlighting style
    #   --resource-path=.: look for images in current directory
    pandoc "$md_file" \
        -f markdown \
        -t pdf \
        --pdf-engine=pdflatex \
        -V geometry:margin=0.75in \
        -V fontsize=11pt \
        -V linkcolor=blue \
        --highlight-style=tango \
        --resource-path=. \
        -o "$pdf_file" 2>&1 | grep -v "Missing character" || true

    # Check if PDF was created successfully
    if [ -f "$pdf_file" ]; then
        echo -e "${GREEN}✓ Successfully created: ${pdf_file}${NC}\n"
        ((count++))
    else
        echo -e "${RED}✗ Failed to convert: ${md_file}${NC}\n"
        ((errors++))
    fi
done

# Summary
echo -e "${YELLOW}===================${NC}"
echo -e "${GREEN}Successfully converted: ${count} files${NC}"
if [ $errors -gt 0 ]; then
    echo -e "${RED}Failed: ${errors} files${NC}"
fi
echo -e "${YELLOW}===================${NC}"

# List generated PDFs
if [ $count -gt 0 ]; then
    echo -e "\n${YELLOW}Generated PDFs:${NC}"
    ls -lh *.pdf 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}'
fi

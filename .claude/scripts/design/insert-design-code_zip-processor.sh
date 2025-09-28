#!/bin/bash

# execute-design-styles_zip-processor.sh
# Extracts and processes Figma Make export zip files
# Usage: ./execute-design-styles_zip-processor.sh <zip-file-path>

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate arguments
if [ $# -ne 1 ]; then
    echo -e "${RED}❌ Error: Missing zip file path argument${NC}"
    echo "Usage: $0 <zip-file-path>"
    exit 1
fi

ZIP_FILE="$1"

# Validate zip file exists
if [ ! -f "$ZIP_FILE" ]; then
    echo -e "${RED}❌ Error: Zip file not found: $ZIP_FILE${NC}"
    exit 1
fi

# Create extraction directory
EXTRACT_DIR="/tmp/figma-extract-$(date +%s)"
mkdir -p "$EXTRACT_DIR"

echo -e "${BLUE}📦 Processing Figma Make export...${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Extract zip file
echo -e "\n${YELLOW}📂 Extracting zip file...${NC}"
if unzip -q "$ZIP_FILE" -d "$EXTRACT_DIR"; then
    echo -e "${GREEN}✅ Extraction successful${NC}"
else
    echo -e "${RED}❌ Error: Failed to extract zip file${NC}"
    rm -rf "$EXTRACT_DIR"
    exit 1
fi

# Analyze directory structure
echo -e "\n${YELLOW}🔍 Directory structure:${NC}"
find "$EXTRACT_DIR" -type d | head -20 | sed 's/^/  /'

# Count file types
echo -e "\n${YELLOW}📊 File type summary:${NC}"
echo "  Components: $(find "$EXTRACT_DIR" -name "*.tsx" -o -name "*.jsx" | wc -l)"
echo "  Stylesheets: $(find "$EXTRACT_DIR" -name "*.css" -o -name "*.scss" | wc -l)"
echo "  Config files: $(find "$EXTRACT_DIR" -name "*.json" -o -name "*.config.*" | wc -l)"
echo "  Images: $(find "$EXTRACT_DIR" -name "*.png" -o -name "*.jpg" -o -name "*.svg" | wc -l)"

# List main components
echo -e "\n${YELLOW}🧩 Main components found:${NC}"
find "$EXTRACT_DIR" -name "*.tsx" -o -name "*.jsx" | grep -v node_modules | head -10 | xargs -I {} basename {} | sed 's/^/  /'

# Check for important files
echo -e "\n${YELLOW}📄 Key files:${NC}"
for file in "package.json" "tailwind.config.js" "styles/globals.css" "components/ui/button.tsx"; do
    if find "$EXTRACT_DIR" -path "*/$file" | grep -q .; then
        echo -e "  ${GREEN}✓${NC} $file"
    else
        echo -e "  ${RED}✗${NC} $file"
    fi
done

# Return extraction directory path
echo -e "\n${GREEN}✅ Processing complete!${NC}"
echo -e "${BLUE}📁 Extracted to: $EXTRACT_DIR${NC}"
echo "$EXTRACT_DIR"
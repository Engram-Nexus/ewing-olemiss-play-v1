#!/bin/bash

# execute-design-styles_style-analyzer.sh
# Analyzes Figma Make export for style patterns and design tokens
# Usage: ./execute-design-styles_style-analyzer.sh <extract-dir>

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate arguments
if [ $# -ne 1 ]; then
    echo -e "${RED}❌ Error: Missing extract directory argument${NC}"
    echo "Usage: $0 <extract-dir>"
    exit 1
fi

EXTRACT_DIR="$1"

# Validate directory exists
if [ ! -d "$EXTRACT_DIR" ]; then
    echo -e "${RED}❌ Error: Directory does not exist: $EXTRACT_DIR${NC}"
    exit 1
fi

echo -e "${BLUE}🔍 Analyzing Figma Make export...${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Function to analyze CSS files
analyze_css() {
    echo -e "\n${YELLOW}📋 CSS Analysis:${NC}"
    
    # Find all CSS files
    CSS_FILES=$(find "$EXTRACT_DIR" -name "*.css" -o -name "*.scss" 2>/dev/null || true)
    
    if [ -z "$CSS_FILES" ]; then
        echo "  No CSS files found"
        return
    fi
    
    # Count CSS files
    CSS_COUNT=$(echo "$CSS_FILES" | wc -l)
    echo "  Found $CSS_COUNT CSS file(s)"
    
    # Extract CSS variables
    echo -e "\n  ${BLUE}CSS Variables:${NC}"
    grep -h "^\s*--" $CSS_FILES 2>/dev/null | sed 's/^\s*//' | sort -u | head -10 || echo "  No CSS variables found"
    
    # Extract color values
    echo -e "\n  ${BLUE}Color Palette:${NC}"
    grep -hEo "#[0-9a-fA-F]{3,8}|rgb\([^)]+\)|hsl\([^)]+\)" $CSS_FILES 2>/dev/null | sort -u | head -10 || echo "  No colors found"
    
    # Extract font families
    echo -e "\n  ${BLUE}Typography:${NC}"
    grep -hEo "font-family:\s*[^;]+" $CSS_FILES 2>/dev/null | sed 's/font-family:\s*//' | sort -u | head -5 || echo "  No font families found"
}

# Function to analyze component styles
analyze_components() {
    echo -e "\n${YELLOW}🧩 Component Analysis:${NC}"
    
    # Find all TSX/JSX files
    COMPONENT_FILES=$(find "$EXTRACT_DIR" -name "*.tsx" -o -name "*.jsx" 2>/dev/null || true)
    
    if [ -z "$COMPONENT_FILES" ]; then
        echo "  No component files found"
        return
    fi
    
    # Count components
    COMPONENT_COUNT=$(echo "$COMPONENT_FILES" | wc -l)
    echo "  Found $COMPONENT_COUNT component file(s)"
    
    # Extract className patterns
    echo -e "\n  ${BLUE}Tailwind Classes:${NC}"
    grep -hEo 'className="[^"]*"' $COMPONENT_FILES 2>/dev/null | \
        sed 's/className="//' | sed 's/"$//' | \
        tr ' ' '\n' | grep -E "^(bg-|text-|border-|rounded-|p-|m-|flex|grid)" | \
        sort | uniq -c | sort -rn | head -10 || echo "  No Tailwind classes found"
    
    # Find styled components
    echo -e "\n  ${BLUE}Styled Components:${NC}"
    grep -l "styled\." $COMPONENT_FILES 2>/dev/null | head -5 || echo "  No styled components found"
}

# Function to analyze design tokens
analyze_tokens() {
    echo -e "\n${YELLOW}🎨 Design Tokens:${NC}"
    
    # Look for token files
    TOKEN_FILES=$(find "$EXTRACT_DIR" -name "*token*" -o -name "*theme*" -o -name "*config*" 2>/dev/null | grep -E "\.(json|js|ts)$" || true)
    
    if [ -z "$TOKEN_FILES" ]; then
        echo "  No design token files found"
        return
    fi
    
    echo "  Found token/theme files:"
    echo "$TOKEN_FILES" | sed 's/^/    /'
    
    # Extract spacing values
    echo -e "\n  ${BLUE}Spacing Values:${NC}"
    grep -hEo '"spacing":\s*{[^}]+}|spacing:\s*{[^}]+}' $TOKEN_FILES 2>/dev/null | head -5 || echo "  No spacing tokens found"
}

# Function to generate summary
generate_summary() {
    echo -e "\n${YELLOW}📊 Style Integration Summary:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Create recommendations
    echo -e "\n${GREEN}✅ Recommended Actions:${NC}"
    
    # Check for CSS variables
    if grep -q "^\s*--" $(find "$EXTRACT_DIR" -name "*.css" 2>/dev/null) 2>/dev/null; then
        echo "  1. Extract CSS variables to src/styles/variables.css"
    fi
    
    # Check for Tailwind usage
    if grep -q 'className=' $(find "$EXTRACT_DIR" -name "*.tsx" -o -name "*.jsx" 2>/dev/null) 2>/dev/null; then
        echo "  2. Review and merge Tailwind classes with existing components"
    fi
    
    # Check for design tokens
    if find "$EXTRACT_DIR" -name "*token*" -o -name "*theme*" 2>/dev/null | grep -q .; then
        echo "  3. Integrate design tokens into theme configuration"
    fi
    
    echo -e "\n${YELLOW}⚠️  Potential Conflicts:${NC}"
    echo "  - Review existing CSS variables before merging"
    echo "  - Check for conflicting class names"
    echo "  - Validate color palette consistency"
}

# Main execution
{
    analyze_css
    analyze_components
    analyze_tokens
    generate_summary
} 2>&1

echo -e "\n${GREEN}✅ Analysis complete!${NC}"
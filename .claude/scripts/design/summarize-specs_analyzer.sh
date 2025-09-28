#!/bin/bash
# summarize-specs_analyzer.sh - Analyzes and summarizes ingested specification documents
# Usage: summarize-specs_analyzer.sh <specs-folder> <detail-level>
# Version: v0.5.0 - Outputs SUMMARY.md in spec project directories

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Arguments
SPECS_FOLDER="${1:-}"
DETAIL_LEVEL="${2:-standard}"

# Base directories
SPECS_BASE="designs/specs"
OUTPUT_BASE="designs/specs"  # v0.5.0 - Summaries saved as SUMMARY.md in spec project directories

# Counters for statistics
SCREEN_COUNT=0
COMPONENT_COUNT=0
FEATURE_COUNT=0
WORKFLOW_COUNT=0
MISSING_COUNT=0
UNDEFINED_COUNT=0
INCOMPLETE_COUNT=0

# Arrays to store extracted information
declare -A SCREENS
declare -A COMPONENTS
declare -A FEATURES
declare -A WORKFLOWS
declare -A COMPONENT_USAGE
declare -A FEATURE_DISTRIBUTION

# Function to extract information from a spec file
extract_spec_info() {
    local file="$1"
    local content=$(cat "$file")
    local filename=$(basename "$file" .md)
    
    # Detect spec type based on content patterns
    if echo "$content" | grep -qi "screen\|page\|view"; then
        SCREENS["$filename"]="$file"
        ((SCREEN_COUNT++))
    fi
    
    if echo "$content" | grep -qi "component\|widget\|element"; then
        COMPONENTS["$filename"]="$file"
        ((COMPONENT_COUNT++))
    fi
    
    if echo "$content" | grep -qi "feature\|functionality\|capability"; then
        FEATURES["$filename"]="$file"
        ((FEATURE_COUNT++))
    fi
    
    if echo "$content" | grep -qi "workflow\|process\|flow\|journey"; then
        WORKFLOWS["$filename"]="$file"
        ((WORKFLOW_COUNT++))
    fi
    
    # Extract component references
    local component_refs=$(echo "$content" | grep -oE '\b[A-Z][a-zA-Z]+(?:Button|Input|Card|List|Form|Modal|Dialog|Menu|Tab)\b' | sort -u)
    for comp in $component_refs; do
        COMPONENT_USAGE["$comp"]+="$filename "
    done
    
    # Check for missing information
    if ! echo "$content" | grep -qi "purpose\|description\|overview"; then
        ((MISSING_COUNT++))
    fi
}

# Function to generate markdown summary
generate_markdown_summary() {
    local output_file="$1"
    local folder_name="$2"
    
    cat > "$output_file" << EOF
# Specification Summary: $folder_name

Generated on: $(date +"%Y-%m-%d %H:%M:%S")

## Overview

This document summarizes the specifications found in \`$SPECS_BASE/$folder_name\`.

### Statistics
- **Total Screens**: $SCREEN_COUNT
- **Total Components**: $COMPONENT_COUNT  
- **Total Features**: $FEATURE_COUNT
- **Total Workflows**: $WORKFLOW_COUNT

EOF

    # Add screens section if detail level permits
    if [[ "$DETAIL_LEVEL" != "brief" ]]; then
        echo "## Screens" >> "$output_file"
        for screen in "${!SCREENS[@]}"; do
            echo "### $screen" >> "$output_file"
            
            # Extract first paragraph as description
            local desc=$(head -n 20 "${SCREENS[$screen]}" | grep -A 5 -E "^#|purpose|description" | grep -v "^#" | head -n 3)
            if [[ -n "$desc" ]]; then
                echo "$desc" >> "$output_file"
            fi
            echo "" >> "$output_file"
        done
    fi
    
    # Add components section for standard and above
    if [[ "$DETAIL_LEVEL" == "standard" ]] || [[ "$DETAIL_LEVEL" == "detailed" ]] || [[ "$DETAIL_LEVEL" == "technical" ]]; then
        echo "## Components" >> "$output_file"
        for component in "${!COMPONENTS[@]}"; do
            echo "### $component" >> "$output_file"
            
            # Show usage information
            if [[ -n "${COMPONENT_USAGE[$component]:-}" ]]; then
                echo "**Used in**: ${COMPONENT_USAGE[$component]}" >> "$output_file"
            fi
            echo "" >> "$output_file"
        done
    fi
    
    # Add cross-reference index for detailed and technical levels
    if [[ "$DETAIL_LEVEL" == "detailed" ]] || [[ "$DETAIL_LEVEL" == "technical" ]]; then
        echo "## Cross-Reference Index" >> "$output_file"
        echo "" >> "$output_file"
        echo "### Component Usage Map" >> "$output_file"
        for comp in "${!COMPONENT_USAGE[@]}"; do
            echo "- **$comp**: ${COMPONENT_USAGE[$comp]}" >> "$output_file"
        done
        echo "" >> "$output_file"
    fi
    
    # Add quality report
    echo "## Quality Report" >> "$output_file"
    echo "" >> "$output_file"
    echo "- Files with missing descriptions: $MISSING_COUNT" >> "$output_file"
    echo "- Undefined component references: $UNDEFINED_COUNT" >> "$output_file"
    echo "- Incomplete specifications: $INCOMPLETE_COUNT" >> "$output_file"
}

# Function to generate JSON summary
generate_json_summary() {
    local output_file="$1"
    local folder_name="$2"
    
    # Start JSON structure
    cat > "$output_file" << EOF
{
  "project": "$folder_name",
  "generated": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "summary": {
    "total_screens": $SCREEN_COUNT,
    "total_components": $COMPONENT_COUNT,
    "total_features": $FEATURE_COUNT,
    "total_workflows": $WORKFLOW_COUNT
  },
EOF
    
    # Add screens array
    echo '  "screens": [' >> "$output_file"
    local first=true
    for screen in "${!SCREENS[@]}"; do
        if [[ "$first" != true ]]; then
            echo "," >> "$output_file"
        fi
        echo -n '    {"name": "'$screen'"}' >> "$output_file"
        first=false
    done
    echo '' >> "$output_file"
    echo '  ],' >> "$output_file"
    
    # Add components array
    echo '  "components": [' >> "$output_file"
    first=true
    for component in "${!COMPONENTS[@]}"; do
        if [[ "$first" != true ]]; then
            echo "," >> "$output_file"
        fi
        echo -n '    {"name": "'$component'"}' >> "$output_file"
        first=false
    done
    echo '' >> "$output_file"
    echo '  ],' >> "$output_file"
    
    # Add quality metrics
    echo '  "quality": {' >> "$output_file"
    echo '    "missing_descriptions": '$MISSING_COUNT',' >> "$output_file"
    echo '    "undefined_references": '$UNDEFINED_COUNT',' >> "$output_file"
    echo '    "incomplete_specs": '$INCOMPLETE_COUNT >> "$output_file"
    echo '  }' >> "$output_file"
    echo '}' >> "$output_file"
}

# Function to generate structured format
generate_structured_summary() {
    local output_dir="$1"
    local folder_name="$2"
    
    # Create directory structure
    mkdir -p "$output_dir"/{screens,components,features,workflows}
    
    # Create index file
    cat > "$output_dir/index.md" << EOF
# $folder_name - Structured Summary

## Directory Structure
- \`screens/\` - Individual screen specifications
- \`components/\` - Component definitions
- \`features/\` - Feature descriptions  
- \`workflows/\` - Workflow documentation

## Statistics
- Screens: $SCREEN_COUNT
- Components: $COMPONENT_COUNT
- Features: $FEATURE_COUNT
- Workflows: $WORKFLOW_COUNT

Generated: $(date +"%Y-%m-%d %H:%M:%S")
EOF
    
    # Copy and organize files
    for screen in "${!SCREENS[@]}"; do
        cp "${SCREENS[$screen]}" "$output_dir/screens/$screen.md"
    done
    
    for component in "${!COMPONENTS[@]}"; do
        cp "${COMPONENTS[$component]}" "$output_dir/components/$component.md"
    done
    
    for feature in "${!FEATURES[@]}"; do
        cp "${FEATURES[$feature]}" "$output_dir/features/$feature.md"
    done
    
    for workflow in "${!WORKFLOWS[@]}"; do
        cp "${WORKFLOWS[$workflow]}" "$output_dir/workflows/$workflow.md"
    done
}

# Function to process a single folder
process_folder() {
    local folder_path="$1"
    local folder_name=$(basename "$folder_path")
    
    echo -e "${BLUE}📁 Processing: $folder_name${NC}"
    
    # Reset counters for this folder
    SCREEN_COUNT=0
    COMPONENT_COUNT=0
    FEATURE_COUNT=0
    WORKFLOW_COUNT=0
    MISSING_COUNT=0
    UNDEFINED_COUNT=0
    INCOMPLETE_COUNT=0
    
    # Clear arrays
    SCREENS=()
    COMPONENTS=()
    FEATURES=()
    WORKFLOWS=()
    COMPONENT_USAGE=()
    FEATURE_DISTRIBUTION=()
    
    # Find and process all .md files
    while IFS= read -r -d '' file; do
        echo -e "  📄 Analyzing: $(basename "$file")"
        extract_spec_info "$file"
    done < <(find "$folder_path" -name "*.md" -type f -print0)
    
    # Always generate markdown output as SUMMARY.md in the spec project directory
    local output_dir="$OUTPUT_BASE/${folder_name}"
    local output_file="$output_dir/SUMMARY.md"
    mkdir -p "$output_dir"
    generate_markdown_summary "$output_file" "$folder_name"
    echo -e "${GREEN}✅ Markdown summary created: $output_file${NC}"
    
    # Display statistics
    echo ""
    echo -e "${BLUE}📊 Summary Statistics for $folder_name:${NC}"
    echo "  - Screens analyzed: $SCREEN_COUNT"
    echo "  - Components catalogued: $COMPONENT_COUNT"
    echo "  - Features documented: $FEATURE_COUNT"
    echo "  - Workflows mapped: $WORKFLOW_COUNT"
    echo ""
}

# Main execution
main() {
    echo -e "${BLUE}🚀 Specification Summary Generator${NC}"
    echo "=================================="
    echo ""
    
    # Validate specs folder exists
    if [[ "$SPECS_FOLDER" == "all" ]]; then
        echo -e "${BLUE}📁 Processing all specification folders...${NC}"
        
        # Check if specs base exists
        if [[ ! -d "$SPECS_BASE" ]]; then
            echo -e "${RED}❌ Error: Specs directory not found: $SPECS_BASE${NC}"
            exit 1
        fi
        
        # Process each folder
        for folder in "$SPECS_BASE"/*; do
            if [[ -d "$folder" ]]; then
                process_folder "$folder"
                echo "---"
                echo ""
            fi
        done
    else
        # Process single folder
        local target_folder="$SPECS_BASE/$SPECS_FOLDER"
        
        if [[ ! -d "$target_folder" ]]; then
            echo -e "${RED}❌ Error: Specs folder not found: $target_folder${NC}"
            echo ""
            echo "Available folders:"
            if [[ -d "$SPECS_BASE" ]]; then
                ls -1 "$SPECS_BASE/" 2>/dev/null | sed 's/^/  - /'
            else
                echo "  No specs folders found"
            fi
            exit 1
        fi
        
        process_folder "$target_folder"
    fi
    
    echo ""
    echo -e "${GREEN}✅ Summary generation complete!${NC}"
    echo ""
    echo "Output location: $OUTPUT_BASE"
}

# Run main function
main
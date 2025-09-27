#!/bin/bash
# Script to regenerate all matrix files with consistent structure
# Used by update-knowledge command to ensure matrix consistency

set -e

# Function to generate a consistent matrix file
generate_matrix() {
    local DIR="$1"
    local MATRIX_FILE="$DIR/README.md"
    local TOPIC_NAME=$(basename "$DIR")
    
    # Get relative path from knowledge base
    local KNOWLEDGE_BASE=".knowledge"
    # Remove everything up to and including .knowledge/
    local REL_PATH=$(echo "$DIR" | sed 's|.*\.knowledge/||')
    
    echo "📋 Generating matrix for: $DIR"
    
    # Find all blocks (md files except README.md)
    local BLOCKS=$(find "$DIR" -maxdepth 1 -name "*.md" -not -name "README.md" 2>/dev/null | sort)
    
    # Find all subtopics (directories)
    local SUBTOPICS=$(find "$DIR" -maxdepth 1 -type d -not -path "$DIR" 2>/dev/null | sort)
    
    # Start building the matrix file with consistent structure
    cat > "$MATRIX_FILE" << EOF
# $TOPIC_NAME Knowledge Matrix

This matrix integrates knowledge from all blocks and subtopics in this ${REL_PATH//\// > } path.

EOF

    # Add subtopics section with hyperlinks
    echo "## Subtopics" >> "$MATRIX_FILE"
    if [[ -n "$SUBTOPICS" ]]; then
        for subtopic in $SUBTOPICS; do
            local SUBTOPIC_NAME=$(basename "$subtopic")
            echo "- [📁 $SUBTOPIC_NAME]($SUBTOPIC_NAME/)" >> "$MATRIX_FILE"
        done
    else
        echo "*No subtopics in this section.*" >> "$MATRIX_FILE"
    fi
    echo "" >> "$MATRIX_FILE"
    
    # Add blocks section with hyperlinks
    echo "## Blocks" >> "$MATRIX_FILE"
    if [[ -n "$BLOCKS" ]]; then
        for block in $BLOCKS; do
            local BLOCK_NAME=$(basename "$block" .md)
            echo "- [📄 $BLOCK_NAME]($BLOCK_NAME.md)" >> "$MATRIX_FILE"
        done
    else
        echo "*No blocks in this section.*" >> "$MATRIX_FILE"
    fi
    echo "" >> "$MATRIX_FILE"
    
    # Add integrated knowledge section - unified synthesis
    echo "## Integrated Knowledge" >> "$MATRIX_FILE"
    echo "" >> "$MATRIX_FILE"
    
    if [[ -n "$BLOCKS" ]]; then
        echo "This section synthesizes knowledge from all blocks in this path. Please review the individual blocks for detailed information:" >> "$MATRIX_FILE"
        echo "" >> "$MATRIX_FILE"
        
        # List blocks for reference
        for block in $BLOCKS; do
            local BLOCK_NAME=$(basename "$block" .md)
            echo "- $BLOCK_NAME" >> "$MATRIX_FILE"
        done
        echo "" >> "$MATRIX_FILE"
        echo "*[Integrated knowledge synthesis should be manually created based on the content of all blocks above]*" >> "$MATRIX_FILE"
    else
        echo "*No blocks to integrate.*" >> "$MATRIX_FILE"
    fi
    
    echo "✅ Matrix generated: $MATRIX_FILE"
}

# Main execution
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <directory-path>"
    echo "Example: $0 .knowledge/authentication"
    exit 1
fi

TARGET_DIR="$1"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "❌ Error: Directory '$TARGET_DIR' does not exist"
    exit 1
fi

# Regenerate matrix for the target directory
generate_matrix "$TARGET_DIR"

# Optionally regenerate all child matrices recursively
if [[ "${2:-}" == "--recursive" ]]; then
    echo "🔄 Regenerating all child matrices recursively..."
    find "$TARGET_DIR" -type d | while read -r dir; do
        if [[ "$dir" != "$TARGET_DIR" ]]; then
            generate_matrix "$dir"
        fi
    done
fi

echo "✅ Matrix regeneration complete"
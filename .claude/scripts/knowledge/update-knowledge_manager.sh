#!/bin/bash
# update-knowledge_manager.sh - Enhanced knowledge manager with subtopic architecture support
# Handles topic/subtopic:block parsing, directory creation, and matrix generation

set -euo pipefail

# Function to show usage
show_usage() {
    echo "Usage: $0 <topic/subtopic:block> [statement]"
    echo "Examples:"
    echo "  $0 authentication"
    echo "  $0 authentication/oauth"
    echo "  $0 authentication/oauth:jwt-implementation \"JWT content\""
    echo "  $0 security/compliance/gdpr:data-protection \"GDPR content\""
    exit 1
}

# Check arguments
if [ $# -lt 1 ]; then
    show_usage
fi

ARG1="$1"
STATEMENT="${2:-}"

# Parse topic/subtopic:block structure
if [[ "$ARG1" == *":"* ]]; then
    # Contains block specification
    PATH_PART=$(echo "$ARG1" | cut -d':' -f1)
    BLOCK=$(echo "$ARG1" | cut -d':' -f2)
    echo "📄 Block specified: $BLOCK"
else
    # No block, just path
    PATH_PART="$ARG1"
    BLOCK=""
fi

# Parse path into topic and subtopics
IFS='/' read -ra PATH_ARRAY <<< "$PATH_PART"
TOPIC="${PATH_ARRAY[0]}"

# Build subtopic path if exists
SUBTOPIC_PATH=""
if [ ${#PATH_ARRAY[@]} -gt 1 ]; then
    # Properly join array elements with /
    SUBTOPIC_PATH=""
    for ((i=1; i<${#PATH_ARRAY[@]}; i++)); do
        if [[ -n "$SUBTOPIC_PATH" ]]; then
            SUBTOPIC_PATH="$SUBTOPIC_PATH/${PATH_ARRAY[i]}"
        else
            SUBTOPIC_PATH="${PATH_ARRAY[i]}"
        fi
    done
    echo "📁 Subtopics: $SUBTOPIC_PATH"
fi

# Build full path for knowledge storage
KNOWLEDGE_BASE=".knowledge"
FULL_PATH="$KNOWLEDGE_BASE/$TOPIC"

if [[ -n "$SUBTOPIC_PATH" ]]; then
    FULL_PATH="$FULL_PATH/$SUBTOPIC_PATH"
fi

echo "📍 Target path: $FULL_PATH"

# Create directory structure
mkdir -p "$FULL_PATH"

# Function to generate matrix README
generate_matrix() {
    local DIR="$1"
    local MATRIX_FILE="$DIR/README.md"
    local TOPIC_NAME=$(basename "$DIR")
    
    # Get relative path from knowledge base
    local REL_PATH="${DIR#$KNOWLEDGE_BASE/}"
    
    echo "📋 Generating matrix for: $DIR"
    
    # Find all blocks (md files except README.md)
    local BLOCKS=$(find "$DIR" -maxdepth 1 -name "*.md" -not -name "README.md" 2>/dev/null | sort || true)
    
    # Find all subtopics (directories)
    local SUBTOPICS=$(find "$DIR" -maxdepth 1 -type d -not -path "$DIR" 2>/dev/null | sort || true)
    
    # Start generating matrix file
    cat > "$MATRIX_FILE" << EOF
# $TOPIC_NAME Knowledge Matrix

This matrix integrates knowledge from all blocks and subtopics in this ${REL_PATH//\// > } path.

## Structure

EOF
    
    # Add subtopics section if any exist
    if [[ -n "$SUBTOPICS" ]]; then
        echo "### Subtopics" >> "$MATRIX_FILE"
        for subtopic in $SUBTOPICS; do
            local SUBTOPIC_NAME=$(basename "$subtopic")
            local SUBTOPIC_README="$subtopic/README.md"
            local BLOCK_COUNT=$(find "$subtopic" -name "*.md" -not -name "README.md" 2>/dev/null | wc -l || echo "0")
            local SUBTOPIC_COUNT=$(find "$subtopic" -maxdepth 1 -type d -not -path "$subtopic" 2>/dev/null | wc -l || echo "0")
            
            echo -n "- [📁 $SUBTOPIC_NAME]($SUBTOPIC_NAME/)" >> "$MATRIX_FILE"
            if [[ $BLOCK_COUNT -gt 0 || $SUBTOPIC_COUNT -gt 0 ]]; then
                echo " - $BLOCK_COUNT blocks, $SUBTOPIC_COUNT subtopics" >> "$MATRIX_FILE"
            else
                echo " - *empty*" >> "$MATRIX_FILE"
            fi
        done
        echo "" >> "$MATRIX_FILE"
    fi
    
    # Add blocks section if any exist
    if [[ -n "$BLOCKS" ]]; then
        echo "### Blocks" >> "$MATRIX_FILE"
        for block in $BLOCKS; do
            local BLOCK_NAME=$(basename "$block" .md)
            local BLOCK_SIZE=$(stat -c%s "$block" 2>/dev/null || echo "0")
            echo "- [📄 $BLOCK_NAME]($BLOCK_NAME.md) - ${BLOCK_SIZE} bytes" >> "$MATRIX_FILE"
        done
        echo "" >> "$MATRIX_FILE"
    fi
    
    # Add integrated knowledge section
    echo "## Integrated Knowledge" >> "$MATRIX_FILE"
    echo "" >> "$MATRIX_FILE"
    
    # Include content from blocks
    if [[ -n "$BLOCKS" ]]; then
        for block in $BLOCKS; do
            local BLOCK_NAME=$(basename "$block" .md)
            local FORMATTED_NAME=$(echo "$BLOCK_NAME" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
            echo "### $FORMATTED_NAME" >> "$MATRIX_FILE"
            echo "" >> "$MATRIX_FILE"
            cat "$block" >> "$MATRIX_FILE"
            echo "" >> "$MATRIX_FILE"
            echo "---" >> "$MATRIX_FILE"
            echo "" >> "$MATRIX_FILE"
        done
    fi
    
    # Include summary from subtopic matrices
    if [[ -n "$SUBTOPICS" ]]; then
        echo "## Subtopic Summaries" >> "$MATRIX_FILE"
        echo "" >> "$MATRIX_FILE"
        
        for subtopic in $SUBTOPICS; do
            local SUBTOPIC_NAME=$(basename "$subtopic")
            local SUBTOPIC_README="$subtopic/README.md"
            
            if [[ -f "$SUBTOPIC_README" ]]; then
                echo "### 📁 $SUBTOPIC_NAME" >> "$MATRIX_FILE"
                echo "" >> "$MATRIX_FILE"
                # Extract first paragraph or description from subtopic README
                # Skip headers and empty lines, get first 3 content lines
                grep -v "^#" "$SUBTOPIC_README" | grep -v "^$" | head -n 3 >> "$MATRIX_FILE" || true
                echo "" >> "$MATRIX_FILE"
                echo "[View full $SUBTOPIC_NAME matrix]($SUBTOPIC_NAME/)" >> "$MATRIX_FILE"
                echo "" >> "$MATRIX_FILE"
            fi
        done
    fi
    
    # Add generation timestamp
    echo "" >> "$MATRIX_FILE"
    echo "---" >> "$MATRIX_FILE"
    echo "*Matrix generated at: $(date -u +"%Y-%m-%d %H:%M:%S UTC")*" >> "$MATRIX_FILE"
    
    echo "✅ Matrix generated: $MATRIX_FILE"
}

# Process based on block specification
if [[ -n "$BLOCK" ]]; then
    # Block-specific update
    BLOCK_FILE="$FULL_PATH/$BLOCK.md"
    
    if [[ -n "$STATEMENT" ]]; then
        echo "📝 Creating/updating block: $BLOCK_FILE"
        echo "$STATEMENT" > "$BLOCK_FILE"
        echo "✅ Block updated successfully"
    else
        echo "❌ ERROR: Block specified but no content provided"
        echo "When creating/updating a block, you must provide content"
        exit 1
    fi
    
    # After block update, regenerate matrix for containing folder
    echo "🔄 Regenerating matrix for: $FULL_PATH"
    generate_matrix "$FULL_PATH"
else
    # Matrix update mode
    if [[ -n "$STATEMENT" ]]; then
        # First, indicate research phase
        echo "🔍 Researching topic: $TOPIC/$SUBTOPIC_PATH"
        echo "Context: Analyzing knowledge domain and existing structure..."
        echo ""
        
        # ENHANCED: Invoke dual-agent orchestration for comprehensive knowledge management
        echo "🔀 INVOKING DUAL-AGENT ORCHESTRATION"
        echo "══════════════════════════════════════════════════"
        echo ""
        
        # Check for enhanced orchestration script
        ORCHESTRATOR_SCRIPT=".claude/scripts/knowledge/update-knowledge_agent-orchestrator.sh"
        if [[ ! -f "$ORCHESTRATOR_SCRIPT" ]]; then
            # Get the directory of this script
            SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
            ORCHESTRATOR_SCRIPT="$SCRIPT_DIR/update-knowledge_agent-orchestrator.sh"
        fi
        
        if [[ -f "$ORCHESTRATOR_SCRIPT" ]]; then
            echo "🚀 Using enhanced agent orchestration script..."
            "$ORCHESTRATOR_SCRIPT" "$TOPIC" "$SUBTOPIC_PATH" "$STATEMENT" "dual-agent"
            echo ""
            echo "✅ Dual-agent orchestration completed"
        else
            echo "⚠️ Orchestrator script not found, using fallback single-agent mode..."
            
            # Fallback to original architect-only guidance
            echo "🏗️ INVOKING KNOWLEDGE:ARCHITECT AGENT (FALLBACK)"
            echo ""
            echo "🚨 TASK TOOL INVOCATION REQUIRED 🚨"
            echo ""
            echo "The executing agent MUST use the Task tool with these parameters:"
            echo "┌─────────────────────────────────────────────────┐"
            echo "│ Tool: Task                                      │"
            echo "│ subagent_type: knowledge:architect              │"
            echo "│ description: Analyze knowledge structure        │"
            echo "│ prompt: (see below)                            │"
            echo "└─────────────────────────────────────────────────┘"
            echo ""
            echo "PROMPT FOR KNOWLEDGE:ARCHITECT:"
            echo "\"Analyze the following knowledge update request:"
            echo ""
            echo "Topic: $TOPIC"
            if [[ -n "$SUBTOPIC_PATH" ]]; then
                echo "Subtopic path: $SUBTOPIC_PATH"
            fi
            echo "Statement to add: $STATEMENT"
            echo ""
            echo "Please provide specific guidance on:"
            echo "1. Recommended subtopic organization for this content"
            echo "2. Suggested block name (replace the auto-generated timestamp)"
            echo "3. Whether this should be a new subtopic instead of a block"
            echo "4. Integration patterns with existing $TOPIC knowledge"
            echo "5. Any structural improvements for better discoverability\""
            echo ""
            echo "⏸️ PAUSING FOR ARCHITECT AGENT EXECUTION..."
        fi
        echo ""
        echo "══════════════════════════════════════════════════"
        echo ""
        
        # After architect guidance, determine block name
        echo "🤔 Analyzing statement with architect guidance to determine block structure..."
        
        # Create a descriptive block name from the first few words of the statement
        # Remove special characters and limit length
        BLOCK_NAME=$(echo "$STATEMENT" | \
            tr '[:upper:]' '[:lower:]' | \
            sed 's/[^a-z0-9 ]//g' | \
            awk '{for(i=1;i<=5&&i<=NF;i++) printf "%s-", $i}' | \
            sed 's/-$//' | \
            cut -c1-50)
        
        # If block name is empty or too short, use timestamp
        if [[ ${#BLOCK_NAME} -lt 3 ]]; then
            BLOCK_NAME="knowledge-$(date +%Y%m%d-%H%M%S)"
        fi
        
        echo "$STATEMENT" > "$FULL_PATH/$BLOCK_NAME.md"
        echo "📝 Created new block: $BLOCK_NAME.md"
        echo ""
        echo "💡 Note: Block name should be refined based on architect guidance"
    fi
    
    echo "🔄 Updating matrix for: $FULL_PATH"
    generate_matrix "$FULL_PATH"
fi

# Recursively update parent matrices up to topic level
CURRENT_PATH="$FULL_PATH"
while [[ "$CURRENT_PATH" != "$KNOWLEDGE_BASE/$TOPIC" && "$CURRENT_PATH" != "$KNOWLEDGE_BASE" ]]; do
    CURRENT_PATH=$(dirname "$CURRENT_PATH")
    if [[ "$CURRENT_PATH" == "$KNOWLEDGE_BASE" ]]; then
        break
    fi
    echo "🔄 Updating parent matrix: $CURRENT_PATH"
    generate_matrix "$CURRENT_PATH"
done

# If we updated a subtopic, also update the main topic matrix
if [[ -n "$SUBTOPIC_PATH" && "$FULL_PATH" != "$KNOWLEDGE_BASE/$TOPIC" ]]; then
    echo "🔄 Updating main topic matrix: $KNOWLEDGE_BASE/$TOPIC"
    generate_matrix "$KNOWLEDGE_BASE/$TOPIC"
fi

# Display final structure
echo ""
echo "📊 Final structure:"
if command -v tree &> /dev/null; then
    tree "$KNOWLEDGE_BASE/$TOPIC" -I '__pycache__|*.pyc'
else
    find "$KNOWLEDGE_BASE/$TOPIC" -type f -name "*.md" | sort | sed 's|^|  |'
fi

echo ""
echo "✅ Knowledge update completed successfully!"
echo "📍 Path: $FULL_PATH"
if [[ -n "$BLOCK" ]]; then
    echo "📄 Block: $BLOCK.md"
fi
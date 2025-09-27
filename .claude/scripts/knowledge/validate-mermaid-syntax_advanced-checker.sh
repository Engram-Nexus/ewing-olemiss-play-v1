#!/bin/bash
# validate-mermaid-syntax_advanced-checker.sh
# Advanced syntax validation for Mermaid diagrams

set -euo pipefail

# Function to display usage
usage() {
    echo "Usage: $0 <diagram_content> <diagram_type>"
    echo "Advanced syntax validation for Mermaid diagrams"
    echo ""
    echo "Arguments:"
    echo "  diagram_content - Mermaid diagram code to validate"
    echo "  diagram_type   - Type of diagram (flowchart|class|sequence|auto)"
    echo ""
    echo "Example:"
    echo "  $0 'flowchart TD\n    A --> B' flowchart"
    exit 1
}

# Check arguments
if [ $# -lt 2 ]; then
    usage
fi

DIAGRAM_CONTENT="$1"
DIAGRAM_TYPE="$2"

# Detect diagram type if auto
detect_diagram_type() {
    local content="$1"
    
    if echo "$content" | grep -q "^flowchart\|^graph"; then
        echo "flowchart"
    elif echo "$content" | grep -q "^classDiagram"; then
        echo "class"
    elif echo "$content" | grep -q "^sequenceDiagram"; then
        echo "sequence"
    elif echo "$content" | grep -q "^gitgraph\|^journey\|^pie\|^state"; then
        echo "other"
    else
        echo "unknown"
    fi
}

if [ "$DIAGRAM_TYPE" = "auto" ]; then
    DIAGRAM_TYPE=$(detect_diagram_type "$DIAGRAM_CONTENT")
fi

# Advanced validation functions

# Validate flowchart syntax
validate_flowchart_advanced() {
    local content="$1"
    local errors=()
    
    # Check flowchart declaration
    if ! echo "$content" | grep -q "^flowchart\|^graph"; then
        errors+=("Missing flowchart/graph declaration")
    fi
    
    # Validate direction
    local direction=$(echo "$content" | grep -E "^(flowchart|graph)" | awk '{print $2}')
    if [ -n "$direction" ] && ! echo "$direction" | grep -qE "^(TD|TB|BT|RL|LR)$"; then
        errors+=("Invalid direction: $direction (valid: TD, TB, BT, RL, LR)")
    fi
    
    # Check node definitions
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*%% ]]; then
            continue
        fi
        
        # Check node syntax
        if echo "$line" | grep -qE '\[|\(|\{'; then
            validate_node_syntax "$line" errors
        fi
        
        # Check connection syntax
        if echo "$line" | grep -qE '-->|-.->|==>|--'; then
            validate_connection_syntax "$line" errors
        fi
    done <<< "$content"
    
    # Check for balanced brackets
    validate_balanced_brackets "$content" errors
    
    # Check for orphaned nodes
    validate_node_connections "$content" errors
    
    printf '%s\n' "${errors[@]}"
}

# Validate class diagram syntax
validate_class_advanced() {
    local content="$1"
    local errors=()
    
    # Check class diagram declaration
    if ! echo "$content" | grep -q "^classDiagram"; then
        errors+=("Missing classDiagram declaration")
    fi
    
    # Validate class definitions
    local in_class=false
    local class_name=""
    local brace_count=0
    
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*%% ]]; then
            continue
        fi
        
        # Check class definition start
        if echo "$line" | grep -qE "^[[:space:]]*class[[:space:]]+[A-Za-z0-9_]+[[:space:]]*\{"; then
            if [ "$in_class" = true ]; then
                errors+=("Nested class definition not allowed: $line")
            fi
            in_class=true
            class_name=$(echo "$line" | sed -E 's/^[[:space:]]*class[[:space:]]+([A-Za-z0-9_]+).*/\1/')
            ((brace_count++))
        elif echo "$line" | grep -qE "^[[:space:]]*\}"; then
            if [ "$in_class" = false ]; then
                errors+=("Closing brace without opening class: $line")
            fi
            in_class=false
            ((brace_count--))
        elif [ "$in_class" = true ]; then
            # Validate class member syntax
            validate_class_member "$line" "$class_name" errors
        elif echo "$line" | grep -qE '--|>|-->|\.\.>|\.\.'; then
            # Validate relationship syntax
            validate_relationship_syntax "$line" errors
        fi
    done <<< "$content"
    
    # Check balanced braces
    if [ "$brace_count" -ne 0 ]; then
        errors+=("Unbalanced braces in class definitions")
    fi
    
    printf '%s\n' "${errors[@]}"
}

# Validate sequence diagram syntax
validate_sequence_advanced() {
    local content="$1"
    local errors=()
    
    # Check sequence diagram declaration
    if ! echo "$content" | grep -q "^sequenceDiagram"; then
        errors+=("Missing sequenceDiagram declaration")
    fi
    
    # Collect participants
    local participants=()
    while IFS= read -r line; do
        if echo "$line" | grep -qE "^[[:space:]]*participant"; then
            local participant=$(echo "$line" | sed -E 's/^[[:space:]]*participant[[:space:]]+([A-Za-z0-9_]+).*/\1/')
            participants+=("$participant")
        fi
    done <<< "$content"
    
    # Validate interactions
    while IFS= read -r line; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*%% ]]; then
            continue
        fi
        
        # Check participant definitions
        if echo "$line" | grep -qE "^[[:space:]]*participant"; then
            validate_participant_syntax "$line" errors
        fi
        
        # Check interaction syntax
        if echo "$line" | grep -qE '->>|-->>|-\)|--\)|->|-->'; then
            validate_interaction_syntax "$line" participants errors
        fi
        
        # Check control structures
        if echo "$line" | grep -qE "^[[:space:]]*(alt|opt|loop|par|critical|break)"; then
            validate_control_structure "$line" errors
        fi
    done <<< "$content"
    
    printf '%s\n' "${errors[@]}"
}

# Helper validation functions

validate_node_syntax() {
    local line="$1"
    local errors_ref="$2"
    
    # Check for valid node patterns
    if ! echo "$line" | grep -qE '^[[:space:]]*[A-Za-z0-9_-]+[[:space:]]*(\[.*\]|\(.*\)|\{.*\}|>.*\]|\[\[.*\]\]|\(\(.*\)\)|(\[.*\)))'; then
        eval "$errors_ref+=(\"Invalid node syntax: $line\")"
    fi
    
    # Check for invalid characters in node ID
    local node_id=$(echo "$line" | sed -E 's/^[[:space:]]*([A-Za-z0-9_-]+).*/\1/')
    if [[ "$node_id" =~ [^A-Za-z0-9_-] ]]; then
        eval "$errors_ref+=(\"Invalid characters in node ID: $node_id\")"
    fi
}

validate_connection_syntax() {
    local line="$1"
    local errors_ref="$2"
    
    # Check for valid connection patterns
    if ! echo "$line" | grep -qE '^[[:space:]]*[A-Za-z0-9_-]+[[:space:]]*(-->|-.->|==>|--[[:space:]]*[|][^|]*[|][[:space:]]*-->)[[:space:]]*[A-Za-z0-9_-]+'; then
        # Check for simple connections without labels
        if ! echo "$line" | grep -qE '^[[:space:]]*[A-Za-z0-9_-]+[[:space:]]*(-->|-.->|==>)[[:space:]]*[A-Za-z0-9_-]+'; then
            eval "$errors_ref+=(\"Invalid connection syntax: $line\")"
        fi
    fi
}

validate_balanced_brackets() {
    local content="$1"
    local errors_ref="$2"
    
    local square_open=$(echo "$content" | grep -o '\[' | wc -l)
    local square_close=$(echo "$content" | grep -o '\]' | wc -l)
    local paren_open=$(echo "$content" | grep -o '(' | wc -l)
    local paren_close=$(echo "$content" | grep -o ')' | wc -l)
    local brace_open=$(echo "$content" | grep -o '{' | wc -l)
    local brace_close=$(echo "$content" | grep -o '}' | wc -l)
    
    if [ "$square_open" -ne "$square_close" ]; then
        eval "$errors_ref+=(\"Unmatched square brackets: $square_open open, $square_close close\")"
    fi
    
    if [ "$paren_open" -ne "$paren_close" ]; then
        eval "$errors_ref+=(\"Unmatched parentheses: $paren_open open, $paren_close close\")"
    fi
    
    if [ "$brace_open" -ne "$brace_close" ]; then
        eval "$errors_ref+=(\"Unmatched braces: $brace_open open, $brace_close close\")"
    fi
}

validate_node_connections() {
    local content="$1"
    local errors_ref="$2"
    
    # Extract all node IDs
    local nodes=$(echo "$content" | grep -oE '^[[:space:]]*[A-Za-z0-9_-]+[[:space:]]*[\[\(\{]' | sed -E 's/^[[:space:]]*([A-Za-z0-9_-]+).*/\1/' | sort -u)
    local connections=$(echo "$content" | grep -oE '[A-Za-z0-9_-]+[[:space:]]*--[>-]+[[:space:]]*[A-Za-z0-9_-]+' | sed -E 's/[[:space:]]*--[>-]+[[:space:]]*/\n/g' | sort -u)
    
    # Check for orphaned nodes (nodes with no connections)
    for node in $nodes; do
        if ! echo "$connections" | grep -q "$node"; then
            eval "$errors_ref+=(\"Warning: Orphaned node detected: $node\")"
        fi
    done
}

validate_class_member() {
    local line="$1"
    local class_name="$2"
    local errors_ref="$3"
    
    # Check for valid member syntax (attributes and methods)
    if ! echo "$line" | grep -qE '^[[:space:]]*[+#-].*' && ! echo "$line" | grep -qE '^[[:space:]]*<<.*>>.*'; then
        # Check if it's a valid attribute or method
        if ! echo "$line" | grep -qE '^[[:space:]]*[A-Za-z0-9_]+([[:space:]]*:[[:space:]]*[A-Za-z0-9_]+)?[[:space:]]*$' && \
           ! echo "$line" | grep -qE '^[[:space:]]*[A-Za-z0-9_]+\([^)]*\)[[:space:]]*:[[:space:]]*[A-Za-z0-9_]+[[:space:]]*$'; then
            eval "$errors_ref+=(\"Invalid class member syntax in $class_name: $line\")"
        fi
    fi
}

validate_relationship_syntax() {
    local line="$1"
    local errors_ref="$2"
    
    # Check for valid relationship patterns
    if ! echo "$line" | grep -qE '^[[:space:]]*[A-Za-z0-9_]+[[:space:]]*(--|>|-->|\.\.>|\.\.)[[:space:]]*[A-Za-z0-9_]+([[:space:]]*:[[:space:]]*.*)?[[:space:]]*$'; then
        eval "$errors_ref+=(\"Invalid relationship syntax: $line\")"
    fi
}

validate_participant_syntax() {
    local line="$1"
    local errors_ref="$2"
    
    # Check for valid participant definition
    if ! echo "$line" | grep -qE '^[[:space:]]*participant[[:space:]]+[A-Za-z0-9_]+([[:space:]]+as[[:space:]]+.*)?[[:space:]]*$'; then
        eval "$errors_ref+=(\"Invalid participant syntax: $line\")"
    fi
}

validate_interaction_syntax() {
    local line="$1"
    local participants=("${@:2}")
    local errors_ref="${@: -1}"
    
    # Extract participants from interaction
    local from=$(echo "$line" | sed -E 's/^[[:space:]]*([A-Za-z0-9_]+).*/\1/')
    local to=$(echo "$line" | sed -E 's/.*[[:space:]]([A-Za-z0-9_]+)[[:space:]]*:[[:space:]]*.*$/\1/')
    
    # Check if participants are defined (if any participants are explicitly defined)
    if [ ${#participants[@]} -gt 0 ]; then
        local from_found=false
        local to_found=false
        
        for participant in "${participants[@]}"; do
            if [ "$participant" = "$from" ]; then from_found=true; fi
            if [ "$participant" = "$to" ]; then to_found=true; fi
        done
        
        if [ "$from_found" = false ]; then
            eval "$errors_ref+=(\"Undefined participant in interaction: $from\")"
        fi
        if [ "$to_found" = false ]; then
            eval "$errors_ref+=(\"Undefined participant in interaction: $to\")"
        fi
    fi
    
    # Check for valid interaction patterns
    if ! echo "$line" | grep -qE '^[[:space:]]*[A-Za-z0-9_]+[[:space:]]*(->>|-->>|-\)|--\)|->|-->)[[:space:]]*[A-Za-z0-9_]+[[:space:]]*:[[:space:]]*.+[[:space:]]*$'; then
        eval "$errors_ref+=(\"Invalid interaction syntax: $line\")"
    fi
}

validate_control_structure() {
    local line="$1"
    local errors_ref="$2"
    
    # Check for valid control structure syntax
    if echo "$line" | grep -qE '^[[:space:]]*(alt|opt|loop|par|critical)[[:space:]]+'; then
        # These require conditions
        if ! echo "$line" | grep -qE '^[[:space:]]*(alt|opt|loop|par|critical)[[:space:]]+.+[[:space:]]*$'; then
            eval "$errors_ref+=(\"Control structure missing condition: $line\")"
        fi
    elif echo "$line" | grep -qE '^[[:space:]]*(end|else)[[:space:]]*$'; then
        # These are valid without conditions
        return 0
    else
        eval "$errors_ref+=(\"Invalid control structure: $line\")"
    fi
}

# Main validation logic
echo "🔍 Advanced Mermaid Syntax Validation"
echo "═══════════════════════════════════════"
echo "Diagram Type: $DIAGRAM_TYPE"
echo ""

case "$DIAGRAM_TYPE" in
    "flowchart")
        errors=$(validate_flowchart_advanced "$DIAGRAM_CONTENT")
        ;;
    "class")
        errors=$(validate_class_advanced "$DIAGRAM_CONTENT")
        ;;
    "sequence")
        errors=$(validate_sequence_advanced "$DIAGRAM_CONTENT")
        ;;
    "unknown")
        echo "❌ Cannot determine diagram type for validation"
        exit 1
        ;;
    *)
        echo "⚠️ Advanced validation not implemented for type: $DIAGRAM_TYPE"
        echo "Performing basic validation..."
        errors=""
        ;;
esac

# Output results
if [ -n "$errors" ]; then
    echo "❌ Validation Errors Found:"
    echo "$errors" | sed 's/^/  - /'
    echo ""
    echo "Total errors: $(echo "$errors" | wc -l)"
    exit 1
else
    echo "✅ Advanced validation passed"
    echo "No syntax errors detected"
    exit 0
fi
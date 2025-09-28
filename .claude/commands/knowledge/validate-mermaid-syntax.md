---
description: "Validate Mermaid diagram syntax and provide corrections"
arguments:
  - name: "diagram-content"
    description: "Mermaid diagram code to validate"
    required: true
  - name: "--fix"
    description: "Automatically fix errors when possible (true/false)"
    required: false
  - name: "--output"
    description: "Output format preference (report/fixed)"
    required: false
  - name: "--strict"
    description: "Validation strictness level (true/false)"
    required: false
  - name: "_preview"
    description: "validate-mermaid-syntax <diagram-content> [--fix] [--output] [--strict]"
    required: false
version: "1.0.0"
category: "knowledge"
icon: "🔍"
---

## Summary

Validates Mermaid diagram syntax against established standards and provides detailed error reports with automatic correction capabilities. This command ensures diagram code follows proper Mermaid syntax rules, identifies common issues, and can automatically fix many syntax problems. It supports all major Mermaid diagram types and provides comprehensive validation with clear error messages and correction suggestions.

## Usage

```bash
/knowledge:validate-mermaid-syntax "<diagram-content>" [--fix=true|false] [--output=report|fixed] [--strict=true|false]
```

## Arguments

- `<diagram-content>`: Mermaid diagram code to validate (REQUIRED)
  - Can be complete diagram code or code blocks
  - Supports flowchart, class, sequence, and other Mermaid diagram types
  - Can include multiple diagrams separated by empty lines
- `[--fix=true|false]`: Automatically fix errors when possible (OPTIONAL)
  - `true`: Attempt to fix syntax errors and return corrected code
  - `false` (default): Only report errors without making changes
- `[--output=report|fixed]`: Output format preference (OPTIONAL)
  - `report` (default): Detailed validation report with error descriptions
  - `fixed`: Return only the corrected diagram code (requires --fix=true)
- `[--strict=true|false]`: Validation strictness level (OPTIONAL)
  - `true`: Enforce strict Mermaid standards and best practices
  - `false` (default): Allow minor variations and focus on critical errors

## Examples

```bash
# Basic syntax validation
/knowledge:validate-mermaid-syntax "flowchart TD
    A --> B
    B --> C"

# Validate and fix syntax errors
/knowledge:validate-mermaid-syntax "classDiagram
    User --> Order
    Order -> Product" --fix=true

# Strict validation with detailed report
/knowledge:validate-mermaid-syntax "sequenceDiagram
    Alice->>Bob: Hello
    Bob-->>Alice: Hi" --strict=true

# Fix errors and return only corrected code
/knowledge:validate-mermaid-syntax "flowchart LR
    Start([Begin])
    Process[Do Something
    End([Finish])" --fix=true --output=fixed

# Validate complex diagram from file
/knowledge:validate-mermaid-syntax "$(cat diagram.md | grep -A 50 '```mermaid' | grep -B 50 '```' | sed '1d;$d')"
```

## What This Command Does

### Validation Process

1. **Diagram Type Detection**
   ```bash
   # Detect diagram type from content
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
   
   DIAGRAM_TYPE=$(detect_diagram_type "$DIAGRAM_CONTENT")
   echo "🎯 Detected diagram type: $DIAGRAM_TYPE"
   ```

2. **Syntax Pattern Validation**
   ```bash
   # Validate syntax patterns based on diagram type
   validate_syntax_patterns() {
       local content="$1"
       local type="$2"
       local errors=()
       
       case "$type" in
           "flowchart")
               # Check flowchart syntax patterns
               if ! echo "$content" | grep -q "^flowchart\|^graph"; then
                   errors+=("Missing flowchart declaration")
               fi
               
               # Validate node definitions
               while IFS= read -r line; do
                   if echo "$line" | grep -q "-->"; then
                       validate_flowchart_connection "$line" errors
                   elif echo "$line" | grep -qE '\[|\(|\{'; then
                       validate_flowchart_node "$line" errors
                   fi
               done <<< "$content"
               ;;
               
           "class")
               # Check class diagram syntax
               if ! echo "$content" | grep -q "^classDiagram"; then
                   errors+=("Missing classDiagram declaration")
               fi
               
               # Validate class definitions and relationships
               validate_class_syntax "$content" errors
               ;;
               
           "sequence")
               # Check sequence diagram syntax
               if ! echo "$content" | grep -q "^sequenceDiagram"; then
                   errors+=("Missing sequenceDiagram declaration")
               fi
               
               # Validate participant and interaction syntax
               validate_sequence_syntax "$content" errors
               ;;
       esac
       
       printf '%s\n' "${errors[@]}"
   }
   ```

3. **Common Error Detection**
   ```bash
   # Check for common syntax errors
   check_common_errors() {
       local content="$1"
       local errors=()
       
       # Check for unmatched brackets/parentheses
       local open_brackets=$(echo "$content" | grep -o '\[' | wc -l)
       local close_brackets=$(echo "$content" | grep -o '\]' | wc -l)
       if [ "$open_brackets" -ne "$close_brackets" ]; then
           errors+=("Unmatched square brackets: $open_brackets open, $close_brackets close")
       fi
       
       # Check for invalid characters in node IDs
       local invalid_nodes=$(echo "$content" | grep -oE '[^a-zA-Z0-9_-]+\[' | wc -l)
       if [ "$invalid_nodes" -gt 0 ]; then
           errors+=("Invalid characters in node IDs")
       fi
       
       # Check for missing arrow types
       if echo "$content" | grep -qE ' [A-Z]+ [A-Z]+'; then
           errors+=("Missing arrow syntax between nodes")
       fi
       
       # Check for indentation issues
       if echo "$content" | grep -qE '^[^ ].*[[]|[{]|[(]' | grep -v '^flowchart\|^classDiagram\|^sequenceDiagram'; then
           errors+=("Possible indentation issues detected")
       fi
       
       printf '%s\n' "${errors[@]}"
   }
   ```

4. **Error Fixing Engine**
   ```bash
   # Attempt to automatically fix common errors
   fix_syntax_errors() {
       local content="$1"
       local fixed="$content"
       
       echo "🔧 Attempting to fix syntax errors..."
       
       # Fix missing diagram declarations
       if ! echo "$fixed" | grep -qE '^(flowchart|classDiagram|sequenceDiagram)'; then
           if echo "$fixed" | grep -q "-->"; then
               fixed="flowchart TD\n$fixed"
               echo "  ✅ Added missing flowchart declaration"
           elif echo "$fixed" | grep -q "class.*{"; then
               fixed="classDiagram\n$fixed"
               echo "  ✅ Added missing classDiagram declaration"
           elif echo "$fixed" | grep -q "->>"; then
               fixed="sequenceDiagram\n$fixed"
               echo "  ✅ Added missing sequenceDiagram declaration"
           fi
       fi
       
       # Fix indentation issues
       fixed=$(echo "$fixed" | sed 's/^[^[:space:]]/    &/')
       fixed=$(echo "$fixed" | sed '1s/^[[:space:]]*//')  # Remove indentation from first line
       
       # Fix common arrow syntax issues
       fixed=$(echo "$fixed" | sed 's/ -> / --> /g')      # Fix arrow syntax
       fixed=$(echo "$fixed" | sed 's/-->/-->/g')         # Ensure proper arrow format
       
       # Fix unmatched brackets (basic cases)
       local open_count=$(echo "$fixed" | grep -o '\[' | wc -l)
       local close_count=$(echo "$fixed" | grep -o '\]' | wc -l)
       
       if [ "$open_count" -gt "$close_count" ]; then
           local diff=$((open_count - close_count))
           for ((i=1; i<=diff; i++)); do
               fixed="$fixed\n    ]"
           done
           echo "  ✅ Added $diff missing closing brackets"
       fi
       
       echo "$fixed"
   }
   ```

5. **Strict Validation Rules**
   ```bash
   # Apply strict validation rules if requested
   apply_strict_validation() {
       local content="$1"
       local warnings=()
       
       if [ "$STRICT" = "true" ]; then
           echo "🔍 Applying strict validation rules..."
           
           # Check for best practice violations
           if ! echo "$content" | grep -q "    "; then
               warnings+=("Inconsistent indentation (should use 4 spaces)")
           fi
           
           # Check for descriptive node labels
           if echo "$content" | grep -qE '\[[A-Z]+\]'; then
               warnings+=("Consider using more descriptive node labels")
           fi
           
           # Check for proper styling consistency
           if echo "$content" | grep -qE '\([^)]*\).*\[[^]]*\]'; then
               warnings+=("Mixed node styles detected - consider consistency")
           fi
           
           # Report warnings
           if [ ${#warnings[@]} -gt 0 ]; then
               echo "⚠️ Style warnings:"
               printf '  - %s\n' "${warnings[@]}"
           fi
       fi
   }
   ```

6. **Output Generation**
   ```bash
   # Generate validation report or fixed code
   generate_output() {
       local content="$1"
       local errors="$2"
       local fixed_content="$3"
       
       if [ "$OUTPUT_FORMAT" = "fixed" ] && [ "$FIX_ERRORS" = "true" ]; then
           # Return only fixed code
           echo "$fixed_content"
       else
           # Generate comprehensive report
           echo ""
           echo "════════════════════════════════════════════════"
           echo "🔍 MERMAID SYNTAX VALIDATION REPORT"
           echo "════════════════════════════════════════════════"
           echo ""
           echo "📊 Diagram Analysis:"
           echo "  Type: $DIAGRAM_TYPE"
           echo "  Lines: $(echo "$content" | wc -l)"
           echo "  Characters: $(echo "$content" | wc -c)"
           echo ""
           
           if [ -n "$errors" ]; then
               echo "❌ Syntax Errors Found:"
               echo "$errors" | sed 's/^/  - /'
               echo ""
               
               if [ "$FIX_ERRORS" = "true" ]; then
                   echo "🔧 Fixed Diagram Code:"
                   echo "```mermaid"
                   echo "$fixed_content"
                   echo "```"
               else
                   echo "💡 Use --fix=true to automatically correct errors"
               fi
           else
               echo "✅ No syntax errors detected"
               echo ""
               echo "📋 Validated Diagram:"
               echo "```mermaid"
               echo "$content"
               echo "```"
           fi
           
           # Apply strict validation if requested
           apply_strict_validation "$content"
       fi
   }
   ```

### Script Integration

```bash
# Enhanced validation using supporting scripts
if [[ -f "../scripts/validate-mermaid-syntax_advanced-checker.sh" ]]; then
    echo "🚀 Using advanced syntax checker..."
    ADVANCED_ERRORS=$(../scripts/validate-mermaid-syntax_advanced-checker.sh "$DIAGRAM_CONTENT" "$DIAGRAM_TYPE")
fi

if [[ -f "../scripts/validate-mermaid-syntax_best-practices.sh" ]]; then
    echo "📋 Checking best practices..."
    BEST_PRACTICE_WARNINGS=$(../scripts/validate-mermaid-syntax_best-practices.sh "$DIAGRAM_CONTENT")
fi
```

### Specialized Validation Functions

```bash
# Validate flowchart node syntax
validate_flowchart_node() {
    local line="$1"
    local errors_ref="$2"
    
    # Check for valid node patterns
    if echo "$line" | grep -qE '\[[^]]*\]|\([^)]*\)|\{[^}]*\}'; then
        return 0  # Valid node syntax
    else
        eval "$errors_ref+=(\"Invalid node syntax: $line\")"
    fi
}

# Validate flowchart connection syntax
validate_flowchart_connection() {
    local line="$1"
    local errors_ref="$2"
    
    if ! echo "$line" | grep -qE '^[[:space:]]*[A-Za-z0-9_-]+[[:space:]]*--[>-]+[[:space:]]*[A-Za-z0-9_-]+'; then
        eval "$errors_ref+=(\"Invalid connection syntax: $line\")"
    fi
}

# Validate class diagram syntax
validate_class_syntax() {
    local content="$1"
    local errors_ref="$2"
    
    # Check for class definitions
    while IFS= read -r line; do
        if echo "$line" | grep -q "class.*{"; then
            # Validate class definition
            if ! echo "$line" | grep -qE '^[[:space:]]*class[[:space:]]+[A-Za-z0-9_]+[[:space:]]*\{'; then
                eval "$errors_ref+=(\"Invalid class definition: $line\")"
            fi
        elif echo "$line" | grep -qE '--|>|-->|\.\.|>'; then
            # Validate relationship syntax
            validate_class_relationship "$line" "$errors_ref"
        fi
    done <<< "$content"
}

# Validate sequence diagram syntax
validate_sequence_syntax() {
    local content="$1"
    local errors_ref="$2"
    
    # Check for participant definitions and interactions
    while IFS= read -r line; do
        if echo "$line" | grep -q "participant"; then
            if ! echo "$line" | grep -qE '^[[:space:]]*participant[[:space:]]+[A-Za-z0-9_]+'; then
                eval "$errors_ref+=(\"Invalid participant definition: $line\")"
            fi
        elif echo "$line" | grep -qE '->>|-->>|-[)]'; then
            # Validate interaction syntax
            if ! echo "$line" | grep -qE '^[[:space:]]*[A-Za-z0-9_]+-[>)]+[A-Za-z0-9_]+:'; then
                eval "$errors_ref+=(\"Invalid interaction syntax: $line\")"
            fi
        fi
    done <<< "$content"
}
```

## Common RUN Commands

```bash
# Quick syntax check
/knowledge:validate-mermaid-syntax "flowchart TD\n    A --> B"

# Validate and fix errors
/knowledge:validate-mermaid-syntax "classDiagram\n    User -> Order" --fix=true

# Strict validation
/knowledge:validate-mermaid-syntax "sequenceDiagram\n    A->>B: test" --strict=true

# Get only fixed code
/knowledge:validate-mermaid-syntax "invalid diagram code" --fix=true --output=fixed

# Validate diagram from file
/knowledge:validate-mermaid-syntax "$(cat my-diagram.md)"
```

## Requirements

- Mermaid diagram code to validate
- Optional: error fixing preferences
- Optional: output format and strictness preferences

## Error Handling

- **Invalid Content**: Provides guidance on proper Mermaid syntax
- **Unknown Diagram Type**: Attempts validation with general rules
- **Fixing Failures**: Reports which errors couldn't be automatically fixed
- **Empty Content**: Requests valid diagram content
- **Complex Errors**: Breaks down complex validation issues

## Notes

- **Comprehensive Validation**: Supports all major Mermaid diagram types
- **Automatic Fixing**: Intelligent error correction for common issues
- **Best Practices**: Enforces Mermaid community standards
- **Detailed Reporting**: Clear error messages with line-specific feedback
- **Script Enhanced**: Leverages supporting scripts for advanced validation
- **Integration Ready**: Designed to work with other create-diagrams commands
- **Flexible Output**: Supports both reporting and code-only output modes

This command ensures all generated diagrams meet Mermaid syntax standards and provides the foundation for reliable diagram creation in the create-diagrams agent complex.
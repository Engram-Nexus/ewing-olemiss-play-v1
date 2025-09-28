---
description: "Generate specific Mermaid diagram types with syntax validation and formatting"
arguments:
  - name: "type"
    description: "Mermaid diagram type (flowchart, class, sequence)"
    required: true
  - name: "description"
    description: "Detailed description of what to diagram"
    required: true
  - name: "--output"
    description: "Output format (inline|file)"
    required: false
  - name: "--validate"
    description: "Enable syntax validation (true|false)"
    required: false
  - name: "--style"
    description: "Diagram complexity level (default|minimal|detailed)"
    required: false
  - name: "_preview"
    description: "flowchart \"User login process\" --output=file"
    required: false
version: "1.0.0"
category: "knowledge"
icon: "📊"
---

## Summary

Generates syntactically correct Mermaid diagrams based on specified type and description. This command creates well-structured diagrams following established patterns from `creating-diagrams.md`, with automatic syntax validation, proper formatting, and markdown integration support. The command specializes in creating flowcharts, class diagrams, and sequence diagrams with appropriate complexity levels and consistent styling.

## Usage

```bash
/knowledge:generate-mermaid-diagram <type> "<description>" [--output=inline|file] [--validate=true|false] [--style=default|minimal|detailed]
```

## Arguments

- `<type>`: Mermaid diagram type (REQUIRED)
  - `flowchart`: Process workflows, decision trees, system flows
  - `class`: Object relationships, data models, system structure
  - `sequence`: Interactions, API flows, communication patterns
  - Values: `flowchart`, `class`, `sequence`
- `<description>`: Detailed description of what to diagram (REQUIRED)
  - Comprehensive description of entities, relationships, and flows
  - Can include technical specifications and implementation details
  - Should specify key components and their interactions
- `[--output=inline|file]`: Output format (OPTIONAL)
  - `inline` (default): Output diagram code directly for copy-paste
  - `file`: Create/update markdown file with diagram and documentation
- `[--validate=true|false]`: Enable syntax validation (OPTIONAL)
  - `true` (default): Validate syntax before output and fix errors
  - `false`: Output diagram without validation (faster but potentially incorrect)
- `[--style=default|minimal|detailed]`: Diagram complexity and detail level (OPTIONAL)
  - `default`: Balanced detail appropriate for documentation
  - `minimal`: Simplified view focusing on core relationships
  - `detailed`: Comprehensive view with full specifications

## Examples

```bash
# Generate authentication flowchart
/knowledge:generate-mermaid-diagram flowchart "User authentication: user enters credentials, system validates against database, creates session if valid, redirects to dashboard or shows error"

# Generate data model class diagram with detailed output
/knowledge:generate-mermaid-diagram class "E-commerce system: User has profile and can create Orders, Order contains multiple OrderItems, each OrderItem references a Product, Product belongs to Category" --style=detailed

# Generate API sequence diagram and save to file
/knowledge:generate-mermaid-diagram sequence "REST API flow: Client sends request to API Gateway, API Gateway forwards to User Service, User Service queries Database, returns user data through the chain" --output=file

# Generate minimal flowchart without validation for speed
/knowledge:generate-mermaid-diagram flowchart "Simple approval process: request submitted, manager reviews, approves or rejects" --style=minimal --validate=false

# Generate complex system class diagram
/knowledge:generate-mermaid-diagram class "Microservices architecture: API Gateway connects to User Service, Product Service, Order Service, and Payment Service. Each service has its own database. Notification Service subscribes to events from all services."
```

## What This Command Does

### Diagram Generation Process

1. **Type-Specific Template Selection**
   ```bash
   # Load appropriate template based on diagram type
   case "$DIAGRAM_TYPE" in
       "flowchart")
           TEMPLATE="flowchart TD"
           NODE_PATTERNS="rectangular|diamond|circle|stadium|subroutine"
           ;;
       "class")
           TEMPLATE="classDiagram"
           RELATIONSHIP_PATTERNS="inheritance|association|dependency|composition"
           ;;
       "sequence")
           TEMPLATE="sequenceDiagram"
           INTERACTION_PATTERNS="synchronous|asynchronous|response|activation"
           ;;
   esac
   
   echo "🎯 Using $DIAGRAM_TYPE template: $TEMPLATE"
   ```

2. **Entity and Relationship Extraction**
   ```bash
   # Parse description for diagram-specific components
   echo "🔍 Extracting components from description..."
   
   # Extract entities using enhanced pattern matching
   if [[ -f "../scripts/generate-mermaid-diagram_entity-extractor.sh" ]]; then
       ENTITIES=$(../scripts/generate-mermaid-diagram_entity-extractor.sh "$DESCRIPTION" "$DIAGRAM_TYPE")
   else
       # Fallback pattern matching
       ENTITIES=$(echo "$DESCRIPTION" | grep -oE '[A-Z][a-zA-Z]*' | sort -u)
   fi
   
   echo "📊 Extracted entities: $ENTITIES"
   ```

3. **Flowchart Generation**
   ```bash
   # Generate flowchart diagrams
   generate_flowchart() {
       local description="$1"
       local style="$2"
       
       echo "flowchart TD"
       
       # Extract process steps and decisions
       local steps=$(extract_process_steps "$description")
       local decisions=$(extract_decisions "$description")
       
       # Generate start node
       echo "    Start([Start Process])"
       
       # Generate process nodes
       local node_id=1
       for step in $steps; do
           case "$style" in
               "minimal")
                   echo "    Step$node_id[$step]"
                   ;;
               "detailed")
                   echo "    Step$node_id[$step Process]"
                   echo "    Step${node_id}Note[Additional details for $step]"
                   ;;
               *)
                   echo "    Step$node_id[$step]"
                   ;;
           esac
           ((node_id++))
       done
       
       # Generate decision nodes
       for decision in $decisions; do
           echo "    Decision$node_id{$decision?}"
           ((node_id++))
       done
       
       # Generate end node
       echo "    End([End Process])"
       
       # Generate connections based on description flow
       generate_flowchart_connections "$description" "$steps" "$decisions"
   }
   ```

4. **Class Diagram Generation**
   ```bash
   # Generate class diagrams
   generate_class_diagram() {
       local description="$1"
       local style="$2"
       
       echo "classDiagram"
       
       # Extract classes and their properties
       local classes=$(extract_classes "$description")
       
       for class in $classes; do
           echo "    class $class {"
           
           # Extract attributes for this class
           local attributes=$(extract_attributes "$description" "$class")
           for attr in $attributes; do
               case "$style" in
                   "minimal")
                       echo "        +$attr"
                       ;;
                   "detailed")
                       echo "        -String id"
                       echo "        +$attr"
                       echo "        +Date createdAt"
                       echo "        +Date updatedAt"
                       ;;
                   *)
                       echo "        +$attr"
                       ;;
               esac
           done
           
           # Extract methods for this class
           local methods=$(extract_methods "$description" "$class")
           for method in $methods; do
               echo "        +$method() void"
           done
           
           echo "    }"
       done
       
       # Generate relationships
       generate_class_relationships "$description" "$classes"
   }
   ```

5. **Sequence Diagram Generation**
   ```bash
   # Generate sequence diagrams
   generate_sequence_diagram() {
       local description="$1"
       local style="$2"
       
       echo "sequenceDiagram"
       
       # Extract participants
       local participants=$(extract_participants "$description")
       
       # Define participants
       for participant in $participants; do
           echo "    participant $participant"
       done
       
       # Generate interactions based on description flow
       generate_sequence_interactions "$description" "$participants" "$style"
   }
   ```

6. **Syntax Validation and Error Correction**
   ```bash
   # Validate generated diagram if requested
   if [ "$VALIDATE" = "true" ]; then
       echo "🔧 Validating Mermaid syntax..."
       
       # Use validation script if available
       if [[ -f "../scripts/generate-mermaid-diagram_syntax-validator.sh" ]]; then
           VALIDATION_RESULT=$(../scripts/generate-mermaid-diagram_syntax-validator.sh "$DIAGRAM_CODE")
           
           if [ "$VALIDATION_RESULT" != "valid" ]; then
               echo "⚠️ Syntax issues detected, applying corrections..."
               DIAGRAM_CODE=$(apply_syntax_corrections "$DIAGRAM_CODE" "$VALIDATION_RESULT")
           else
               echo "✅ Syntax validation passed"
           fi
       else
           # Basic validation patterns
           validate_basic_syntax "$DIAGRAM_CODE" "$DIAGRAM_TYPE"
       fi
   fi
   ```

7. **Output Generation**
   ```bash
   # Generate final output based on format option
   if [ "$OUTPUT_FORMAT" = "file" ]; then
       # Create markdown file with diagram
       FILENAME="diagram-$(date +%Y%m%d-%H%M%S).md"
       cat << EOF > "$FILENAME"
   # Generated Mermaid Diagram
   
   ## Description
   $DESCRIPTION
   
   ## Diagram
   
   \`\`\`mermaid
   $DIAGRAM_CODE
   \`\`\`
   
   ## Generated On
   $(date)
   
   ## Type
   $DIAGRAM_TYPE ($STYLE style)
   
   ## Usage
   Copy the diagram code above and paste into your markdown documentation.
   
   EOF
       
       echo "📄 Diagram saved to: $FILENAME"
   else
       # Inline output for direct use
       echo ""
       echo "════════════════════════════════════════════════"
       echo "📊 GENERATED MERMAID DIAGRAM"
       echo "════════════════════════════════════════════════"
       echo ""
       echo "🎯 Type: $DIAGRAM_TYPE"
       echo "🎨 Style: $STYLE"
       echo "✅ Validated: $VALIDATE"
       echo ""
       echo "```mermaid"
       echo "$DIAGRAM_CODE"
       echo "```"
       echo ""
       echo "💡 Copy the code above and paste into your markdown file"
   fi
   ```

### Script Integration

```bash
# Enhanced generation using supporting scripts
if [[ -f "../scripts/generate-mermaid-diagram_template-engine.sh" ]]; then
    echo "🚀 Using template engine for advanced generation..."
    DIAGRAM_CODE=$(../scripts/generate-mermaid-diagram_template-engine.sh "$DIAGRAM_TYPE" "$DESCRIPTION" "$STYLE")
fi

if [[ -f "../scripts/generate-mermaid-diagram_style-enhancer.sh" ]]; then
    echo "🎨 Applying style enhancements..."
    DIAGRAM_CODE=$(../scripts/generate-mermaid-diagram_style-enhancer.sh "$DIAGRAM_CODE" "$STYLE")
fi
```

### Utility Functions

```bash
# Extract process steps from description
extract_process_steps() {
    local desc="$1"
    echo "$desc" | sed 's/[,.]/ /g' | grep -oE '\b[a-z]+s?\b' | grep -vE '^(the|and|or|but|with|for|in|on|at|to|from|if|when)$' | sort -u
}

# Extract decision points
extract_decisions() {
    local desc="$1"
    echo "$desc" | grep -ioE '\b(if|when|whether|check|validate|verify)[^,.]*' | sed 's/^[a-z]* //' | sort -u
}

# Extract classes from description
extract_classes() {
    local desc="$1"
    echo "$desc" | grep -oE '[A-Z][a-zA-Z]*' | grep -vE '^(API|HTTP|REST|JSON|XML|SQL)$' | sort -u
}

# Extract attributes for a specific class
extract_attributes() {
    local desc="$1"
    local class="$2"
    echo "$desc" | grep -ioE "$class [^,.]*" | sed "s/$class //i" | grep -oE '\b[a-z]+\b' | sort -u
}

# Generate class relationships
generate_class_relationships() {
    local desc="$1"
    local classes="$2"
    
    # Look for relationship keywords
    echo "$desc" | grep -ioE '[A-Z][a-zA-Z]* (has|contains|extends|implements|uses) [A-Z][a-zA-Z]*' | while read relationship; do
        local from=$(echo "$relationship" | awk '{print $1}')
        local type=$(echo "$relationship" | awk '{print $2}')
        local to=$(echo "$relationship" | awk '{print $3}')
        
        case "$type" in
            "extends"|"implements")
                echo "    $from --|> $to"
                ;;
            "has"|"contains")
                echo "    $from --> $to"
                ;;
            "uses")
                echo "    $from ..> $to"
                ;;
        esac
    done
}

# Validate basic syntax patterns
validate_basic_syntax() {
    local code="$1"
    local type="$2"
    
    case "$type" in
        "flowchart")
            if ! echo "$code" | grep -q "^flowchart"; then
                echo "❌ Missing flowchart declaration"
                return 1
            fi
            ;;
        "class")
            if ! echo "$code" | grep -q "^classDiagram"; then
                echo "❌ Missing classDiagram declaration"
                return 1
            fi
            ;;
        "sequence")
            if ! echo "$code" | grep -q "^sequenceDiagram"; then
                echo "❌ Missing sequenceDiagram declaration"
                return 1
            fi
            ;;
    esac
    
    return 0
}
```

## Common RUN Commands

```bash
# Quick flowchart generation
/knowledge:generate-mermaid-diagram flowchart "User login process with validation"

# Detailed class diagram
/knowledge:generate-mermaid-diagram class "User management system with roles and permissions" --style=detailed

# API sequence diagram with file output
/knowledge:generate-mermaid-diagram sequence "OAuth authentication flow" --output=file

# Fast generation without validation
/knowledge:generate-mermaid-diagram flowchart "Simple approval workflow" --validate=false

# Minimal complexity diagram
/knowledge:generate-mermaid-diagram class "Basic user-post relationship" --style=minimal
```

## Requirements

- Valid Mermaid diagram type (flowchart, class, sequence)
- Detailed description with entities and relationships
- Optional: output format preference
- Optional: validation and styling preferences

## Error Handling

- **Invalid Type**: Lists valid diagram types and suggests alternatives
- **Empty Description**: Provides guidance on creating effective descriptions
- **Syntax Errors**: Attempts automatic correction or provides specific error details
- **Complex Descriptions**: Breaks down complex content into manageable components
- **Template Failures**: Falls back to basic generation patterns

## Notes

- **Pattern-Based Generation**: Uses established Mermaid patterns for consistency
- **Automatic Validation**: Ensures syntactically correct output by default
- **Flexible Styling**: Supports multiple complexity levels for different use cases
- **Script Enhancement**: Leverages supporting scripts for advanced features
- **Integration Ready**: Designed to work with other create-diagrams commands
- **Documentation Friendly**: Provides markdown-ready output with proper formatting
- **Error Recovery**: Robust error handling with fallback generation methods

This command serves as the core generation engine for the create-diagrams agent complex, providing reliable, syntactically correct Mermaid diagrams with appropriate complexity and styling for various documentation needs.
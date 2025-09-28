#!/bin/bash
# generate-mermaid-diagram_template-engine.sh
# Advanced template engine for generating Mermaid diagrams

set -euo pipefail

# Function to display usage
usage() {
    echo "Usage: $0 <diagram_type> <description> <style>"
    echo "Advanced template engine for Mermaid diagram generation"
    echo ""
    echo "Arguments:"
    echo "  diagram_type  - Type of diagram (flowchart|class|sequence)"
    echo "  description   - Content description for the diagram"
    echo "  style        - Style level (minimal|default|detailed)"
    echo ""
    echo "Example:"
    echo "  $0 flowchart \"User authentication process\" default"
    exit 1
}

# Check arguments
if [ $# -lt 3 ]; then
    usage
fi

DIAGRAM_TYPE="$1"
DESCRIPTION="$2"
STYLE="$3"

# Advanced entity extraction functions
extract_entities() {
    local text="$1"
    echo "$text" | grep -oE '\b[A-Z][a-zA-Z]*\b' | grep -vE '^(API|HTTP|REST|JSON|XML|SQL|URL|ID|UI|UX)$' | sort -u
}

extract_verbs() {
    local text="$1"
    echo "$text" | grep -ioE '\b(create|update|delete|process|validate|check|send|receive|calculate|generate|transform|analyze|authenticate|authorize|login|logout|register|submit|approve|reject|notify|store|retrieve|query|connect|disconnect)[a-z]*\b' | sort -u
}

extract_decisions() {
    local text="$1"
    echo "$text" | grep -ioE '\b(if|when|whether|check|validate|verify|approve|reject|confirm|is|has|can|should|must)[^,.]*' | sed 's/^[a-z]* //' | sort -u
}

# Generate flowchart diagrams
generate_flowchart() {
    local description="$1"
    local style="$2"
    
    echo "flowchart TD"
    
    # Extract components
    local entities=($(extract_entities "$description"))
    local verbs=($(extract_verbs "$description"))
    local decisions=($(extract_decisions "$description"))
    
    # Generate start node
    echo "    Start([Start])"
    
    # Generate process nodes based on verbs
    local node_counter=1
    local process_nodes=()
    
    for verb in "${verbs[@]}"; do
        local node_id="Process$node_counter"
        process_nodes+=("$node_id")
        
        case "$style" in
            "minimal")
                echo "    $node_id[$verb]"
                ;;
            "detailed")
                echo "    $node_id[$verb Process]"
                echo "    ${node_id}Note[\"Additional processing for $verb\"]"
                ;;
            *)
                echo "    $node_id[$(echo "$verb" | sed 's/^./\U&/')]"
                ;;
        esac
        ((node_counter++))
    done
    
    # Generate decision nodes
    local decision_nodes=()
    for decision in "${decisions[@]}"; do
        if [ ${#decision} -lt 50 ]; then  # Reasonable length for decision text
            local node_id="Decision$node_counter"
            decision_nodes+=("$node_id")
            echo "    $node_id{$decision?}"
            ((node_counter++))
        fi
    done
    
    # Generate end node
    echo "    End([End])"
    
    # Generate connections
    echo ""
    echo "    Start --> ${process_nodes[0]:-End}"
    
    # Connect process nodes
    for ((i=0; i<${#process_nodes[@]}-1; i++)); do
        if [ $((i % 3)) -eq 2 ] && [ ${#decision_nodes[@]} -gt $((i/3)) ]; then
            # Insert decision node every 3 processes
            local decision_index=$((i/3))
            echo "    ${process_nodes[i]} --> ${decision_nodes[decision_index]}"
            echo "    ${decision_nodes[decision_index]} -->|Yes| ${process_nodes[i+1]}"
            echo "    ${decision_nodes[decision_index]} -->|No| End"
        else
            echo "    ${process_nodes[i]} --> ${process_nodes[i+1]}"
        fi
    done
    
    # Connect last process to end
    if [ ${#process_nodes[@]} -gt 0 ]; then
        echo "    ${process_nodes[-1]} --> End"
    fi
    
    # Add styling for detailed mode
    if [ "$style" = "detailed" ]; then
        echo ""
        echo "    classDef processClass fill:#e1f5fe,stroke:#01579b,stroke-width:2px"
        echo "    classDef decisionClass fill:#fff3c4,stroke:#f57f17,stroke-width:2px"
        echo "    classDef startEndClass fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px"
        
        for node in "${process_nodes[@]}"; do
            echo "    class $node processClass"
        done
        
        for node in "${decision_nodes[@]}"; do
            echo "    class $node decisionClass"
        done
        
        echo "    class Start,End startEndClass"
    fi
}

# Generate class diagrams
generate_class_diagram() {
    local description="$1"
    local style="$2"
    
    echo "classDiagram"
    
    # Extract entities as classes
    local entities=($(extract_entities "$description"))
    local verbs=($(extract_verbs "$description"))
    
    # Generate class definitions
    for entity in "${entities[@]}"; do
        echo "    class $entity {"
        
        # Add common attributes based on style
        case "$style" in
            "minimal")
                echo "        +id"
                echo "        +name"
                ;;
            "detailed")
                echo "        -UUID id"
                echo "        +String name"
                echo "        +Date createdAt"
                echo "        +Date updatedAt"
                # Add entity-specific attributes
                generate_entity_attributes "$entity" "$description"
                ;;
            *)
                echo "        +id: String"
                echo "        +name: String"
                # Add some relevant methods
                for verb in "${verbs[@]}"; do
                    if echo "$description" | grep -iq "$entity.*$verb\|$verb.*$entity"; then
                        echo "        +$(echo "$verb" | sed 's/^./\l&/')() void"
                    fi
                done | head -3  # Limit to 3 methods
                ;;
        esac
        
        echo "    }"
    done
    
    # Generate relationships based on description analysis
    echo ""
    generate_class_relationships "$description" "${entities[@]}"
}

# Generate entity-specific attributes
generate_entity_attributes() {
    local entity="$1"
    local description="$2"
    
    case "${entity,,}" in
        "user"|"customer"|"person")
            echo "        +String email"
            echo "        +String firstName"
            echo "        +String lastName"
            ;;
        "order"|"purchase")
            echo "        +String orderNumber"
            echo "        +Money totalAmount"
            echo "        +OrderStatus status"
            ;;
        "product"|"item")
            echo "        +String sku"
            echo "        +Money price"
            echo "        +Integer inventory"
            ;;
        "payment")
            echo "        +Money amount"
            echo "        +String method"
            echo "        +PaymentStatus status"
            ;;
        *)
            # Generic attributes based on common patterns
            if echo "$description" | grep -iq "status\|state"; then
                echo "        +String status"
            fi
            if echo "$description" | grep -iq "amount\|price\|cost"; then
                echo "        +Money amount"
            fi
            ;;
    esac
}

# Generate class relationships
generate_class_relationships() {
    local description="$1"
    shift
    local entities=("$@")
    
    # Look for relationship patterns in description
    for entity1 in "${entities[@]}"; do
        for entity2 in "${entities[@]}"; do
            if [ "$entity1" != "$entity2" ]; then
                # Check for different relationship types
                if echo "$description" | grep -iq "$entity1.*has.*$entity2\|$entity1.*contains.*$entity2"; then
                    echo "    $entity1 \"1\" --> \"*\" $entity2 : has"
                elif echo "$description" | grep -iq "$entity1.*extends.*$entity2\|$entity1.*inherits.*$entity2"; then
                    echo "    $entity1 --|> $entity2 : extends"
                elif echo "$description" | grep -iq "$entity1.*uses.*$entity2\|$entity1.*depends.*$entity2"; then
                    echo "    $entity1 ..> $entity2 : uses"
                elif echo "$description" | grep -iq "$entity1.*belongs.*$entity2\|$entity2.*owns.*$entity1"; then
                    echo "    $entity1 --> $entity2 : belongs to"
                fi
            fi
        done
    done
}

# Generate sequence diagrams
generate_sequence_diagram() {
    local description="$1"
    local style="$2"
    
    echo "sequenceDiagram"
    
    # Extract participants
    local entities=($(extract_entities "$description"))
    local verbs=($(extract_verbs "$description"))
    
    # Define participants
    for entity in "${entities[@]}"; do
        echo "    participant $entity"
    done
    
    echo ""
    
    # Generate interactions based on verbs and entities
    generate_sequence_interactions "$description" "$style" "${entities[@]}"
}

# Generate sequence interactions
generate_sequence_interactions() {
    local description="$1"
    local style="$2"
    shift 2
    local participants=("$@")
    
    # Simple interaction pattern based on common flows
    if [ ${#participants[@]} -ge 2 ]; then
        local client="${participants[0]}"
        local server="${participants[1]}"
        
        # Authentication flow pattern
        if echo "$description" | grep -iq "auth\|login"; then
            echo "    $client->>+$server: Login Request"
            echo "    $server->>$server: Validate Credentials"
            
            if [ "$style" = "detailed" ]; then
                echo "    alt Valid Credentials"
                echo "        $server-->>$client: Success + Token"
                echo "    else Invalid Credentials"
                echo "        $server-->>-$client: Error Response"
                echo "    end"
            else
                echo "    $server-->>-$client: Response"
            fi
        fi
        
        # Data processing pattern
        if echo "$description" | grep -iq "process\|create\|update"; then
            echo "    $client->>+$server: Process Request"
            
            if [ ${#participants[@]} -ge 3 ]; then
                local database="${participants[2]}"
                echo "    $server->>+$database: Query Data"
                echo "    $database-->>-$server: Data Result"
            fi
            
            echo "    $server->>$server: Process Data"
            echo "    $server-->>-$client: Processed Result"
        fi
        
        # Payment flow pattern
        if echo "$description" | grep -iq "payment\|pay\|charge"; then
            if [ ${#participants[@]} -ge 3 ]; then
                local payment_gateway="${participants[2]}"
                echo "    $client->>+$server: Payment Request"
                echo "    $server->>+$payment_gateway: Process Payment"
                echo "    $payment_gateway-->>-$server: Payment Result"
                echo "    $server-->>-$client: Payment Confirmation"
            fi
        fi
    fi
    
    # Add notes for detailed style
    if [ "$style" = "detailed" ]; then
        echo ""
        echo "    Note over ${participants[0]},${participants[-1]}: End-to-end flow"
    fi
}

# Add styling based on diagram type and style
add_diagram_styling() {
    local diagram_type="$1"
    local style="$2"
    
    if [ "$style" = "detailed" ]; then
        case "$diagram_type" in
            "flowchart")
                echo ""
                echo "    classDef default fill:#f9f9f9,stroke:#333,stroke-width:2px"
                echo "    classDef highlight fill:#e1f5fe,stroke:#01579b,stroke-width:3px"
                ;;
            "class")
                echo ""
                echo "    %%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#e1f5fe'}}}%%"
                ;;
        esac
    fi
}

# Main generation logic
case "$DIAGRAM_TYPE" in
    "flowchart")
        generate_flowchart "$DESCRIPTION" "$STYLE"
        ;;
    "class")
        generate_class_diagram "$DESCRIPTION" "$STYLE"
        ;;
    "sequence")
        generate_sequence_diagram "$DESCRIPTION" "$STYLE"
        ;;
    *)
        echo "Error: Unsupported diagram type '$DIAGRAM_TYPE'" >&2
        echo "Supported types: flowchart, class, sequence" >&2
        exit 1
        ;;
esac

# Add styling if requested
add_diagram_styling "$DIAGRAM_TYPE" "$STYLE"
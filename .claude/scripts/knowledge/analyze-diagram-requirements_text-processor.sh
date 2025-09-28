#!/bin/bash
# analyze-diagram-requirements_text-processor.sh
# Enhanced text processing for diagram requirement analysis

set -euo pipefail

# Function to display usage
usage() {
    echo "Usage: $0 <description> <diagram_type>"
    echo "Enhanced text processing for diagram requirements analysis"
    echo ""
    echo "Arguments:"
    echo "  description   - Text description to analyze"
    echo "  diagram_type  - Target diagram type (flowchart|class|sequence)"
    echo ""
    echo "Example:"
    echo "  $0 \"User authentication with OAuth\" sequence"
    exit 1
}

# Check arguments
if [ $# -lt 2 ]; then
    usage
fi

DESCRIPTION="$1"
DIAGRAM_TYPE="$2"

echo "🔍 Enhanced Text Processing Analysis"
echo "══════════════════════════════════════"

# Advanced entity extraction with semantic analysis
extract_semantic_entities() {
    local text="$1"
    local type="$2"
    
    echo "📊 Semantic Entity Extraction for $type diagrams:"
    
    case "$type" in
        "flowchart")
            # Extract process steps, decisions, and states
            echo "  Process Steps:"
            echo "$text" | grep -ioE '\b(create|update|delete|process|validate|check|send|receive|calculate|generate|transform|analyze)[a-z]*\b' | sort -u | sed 's/^/    - /'
            
            echo "  Decision Points:"
            echo "$text" | grep -ioE '\b(if|when|whether|check|validate|verify|approve|reject|confirm)[^,.]*' | sed 's/^[a-z]* //' | sort -u | sed 's/^/    - /'
            
            echo "  States/Conditions:"
            echo "$text" | grep -ioE '\b(valid|invalid|active|inactive|pending|complete|success|failure|error)[a-z]*\b' | sort -u | sed 's/^/    - /'
            ;;
            
        "class")
            # Extract classes, attributes, and relationships
            echo "  Classes/Entities:"
            echo "$text" | grep -oE '\b[A-Z][a-zA-Z]*\b' | grep -vE '^(API|HTTP|REST|JSON|XML|SQL|URL|ID)$' | sort -u | sed 's/^/    - /'
            
            echo "  Attributes/Properties:"
            echo "$text" | grep -ioE '\b(has|contains|includes|with)\s+[a-z]+\b' | sed 's/.* //' | sort -u | sed 's/^/    - /'
            
            echo "  Relationships:"
            echo "$text" | grep -ioE '\b[A-Z][a-zA-Z]*\s+(has|contains|extends|implements|uses|belongs to|owns)\s+[A-Z][a-zA-Z]*\b' | sort -u | sed 's/^/    - /'
            ;;
            
        "sequence")
            # Extract participants and interactions
            echo "  Participants/Actors:"
            echo "$text" | grep -oE '\b[A-Z][a-zA-Z]*\b' | grep -vE '^(API|HTTP|REST|JSON|XML|SQL|URL|ID)$' | sort -u | sed 's/^/    - /'
            
            echo "  Interactions/Messages:"
            echo "$text" | grep -ioE '\b(sends?|receives?|calls?|responds?|requests?|returns?|notifies?)[^,.]*' | sort -u | sed 's/^/    - /'
            
            echo "  Communication Patterns:"
            echo "$text" | grep -ioE '\b(synchronous|asynchronous|request-response|publish-subscribe|event-driven)\b' | sort -u | sed 's/^/    - /'
            ;;
    esac
}

# Analyze text complexity and structure
analyze_text_complexity() {
    local text="$1"
    
    echo ""
    echo "📈 Text Complexity Analysis:"
    
    local word_count=$(echo "$text" | wc -w)
    local sentence_count=$(echo "$text" | grep -o '[.!?]' | wc -l)
    local entity_count=$(echo "$text" | grep -oE '\b[A-Z][a-zA-Z]*\b' | sort -u | wc -l)
    local verb_count=$(echo "$text" | grep -ioE '\b(create|update|delete|process|validate|send|receive)[a-z]*\b' | sort -u | wc -l)
    
    echo "  Words: $word_count"
    echo "  Sentences: $sentence_count"
    echo "  Unique Entities: $entity_count"
    echo "  Action Verbs: $verb_count"
    
    # Determine complexity level
    local complexity_score=0
    
    if [ "$word_count" -gt 50 ]; then ((complexity_score++)); fi
    if [ "$entity_count" -gt 8 ]; then ((complexity_score++)); fi
    if [ "$verb_count" -gt 6 ]; then ((complexity_score++)); fi
    
    case "$complexity_score" in
        0) echo "  Complexity Level: Simple" ;;
        1) echo "  Complexity Level: Medium" ;;
        *) echo "  Complexity Level: Complex" ;;
    esac
}

# Extract domain-specific patterns
extract_domain_patterns() {
    local text="$1"
    
    echo ""
    echo "🎯 Domain Pattern Recognition:"
    
    # Web application patterns
    if echo "$text" | grep -iqE '\b(web|browser|client|server|api|endpoint|route|controller|view|model)\b'; then
        echo "  Domain: Web Application"
        echo "  Patterns: MVC, REST API, Client-Server"
    fi
    
    # Authentication patterns
    if echo "$text" | grep -iqE '\b(auth|login|password|token|oauth|jwt|session|permission|role)\b'; then
        echo "  Domain: Authentication/Authorization"
        echo "  Patterns: OAuth, JWT, RBAC, Session Management"
    fi
    
    # Database patterns
    if echo "$text" | grep -iqE '\b(database|table|query|schema|migration|orm|sql|nosql)\b'; then
        echo "  Domain: Data Management"
        echo "  Patterns: CRUD, Repository, Active Record"
    fi
    
    # Microservices patterns
    if echo "$text" | grep -iqE '\b(service|microservice|gateway|queue|event|message|distributed)\b'; then
        echo "  Domain: Distributed Systems"
        echo "  Patterns: Microservices, Event-Driven, CQRS, Saga"
    fi
    
    # E-commerce patterns
    if echo "$text" | grep -iqE '\b(order|product|payment|cart|customer|invoice|shipping)\b'; then
        echo "  Domain: E-commerce"
        echo "  Patterns: Order Management, Payment Processing, Inventory"
    fi
}

# Generate structural recommendations
generate_structural_recommendations() {
    local text="$1"
    local type="$2"
    
    echo ""
    echo "💡 Structural Recommendations for $type:"
    
    case "$type" in
        "flowchart")
            echo "  - Start with clear entry/exit points"
            echo "  - Use diamond shapes for decision points"
            echo "  - Group related processes in subgraphs"
            echo "  - Include error handling paths"
            
            # Check for error handling
            if ! echo "$text" | grep -iqE '\b(error|fail|exception|timeout|retry)\b'; then
                echo "  ⚠️  Consider adding error handling scenarios"
            fi
            ;;
            
        "class")
            echo "  - Use consistent naming conventions"
            echo "  - Show key attributes and methods"
            echo "  - Include relationship multiplicities"
            echo "  - Group related classes logically"
            
            # Check for inheritance patterns
            if echo "$text" | grep -iqE '\b(extends|inherits|parent|base|abstract)\b'; then
                echo "  💡 Inheritance detected - consider using inheritance arrows"
            fi
            ;;
            
        "sequence")
            echo "  - Order participants logically"
            echo "  - Use activation bars for processing"
            echo "  - Include alt/opt blocks for conditions"
            echo "  - Show return messages clearly"
            
            # Check for async patterns
            if echo "$text" | grep -iqE '\b(async|asynchronous|callback|promise|event)\b'; then
                echo "  💡 Async patterns detected - consider using async arrows"
            fi
            ;;
    esac
}

# Extract technical keywords and concepts
extract_technical_concepts() {
    local text="$1"
    
    echo ""
    echo "🔧 Technical Concepts Identified:"
    
    # Architecture patterns
    local arch_patterns=$(echo "$text" | grep -ioE '\b(mvc|mvp|mvvm|microservices|monolith|soa|event-driven|cqrs|saga)\b' | sort -u)
    if [ -n "$arch_patterns" ]; then
        echo "  Architecture Patterns:"
        echo "$arch_patterns" | sed 's/^/    - /'
    fi
    
    # Technology stack
    local technologies=$(echo "$text" | grep -ioE '\b(react|angular|vue|node|express|spring|django|rails|postgres|mysql|mongodb|redis|kafka|rabbitmq)\b' | sort -u)
    if [ -n "$technologies" ]; then
        echo "  Technologies:"
        echo "$technologies" | sed 's/^/    - /'
    fi
    
    # Protocols and standards
    local protocols=$(echo "$text" | grep -ioE '\b(http|https|rest|graphql|grpc|websocket|oauth|jwt|ssl|tls)\b' | sort -u)
    if [ -n "$protocols" ]; then
        echo "  Protocols/Standards:"
        echo "$protocols" | sed 's/^/    - /'
    fi
}

# Main processing
echo "Input Description: $DESCRIPTION"
echo "Target Diagram Type: $DIAGRAM_TYPE"
echo ""

# Run all analysis functions
extract_semantic_entities "$DESCRIPTION" "$DIAGRAM_TYPE"
analyze_text_complexity "$DESCRIPTION"
extract_domain_patterns "$DESCRIPTION"
extract_technical_concepts "$DESCRIPTION"
generate_structural_recommendations "$DESCRIPTION" "$DIAGRAM_TYPE"

echo ""
echo "✅ Enhanced text processing analysis completed"
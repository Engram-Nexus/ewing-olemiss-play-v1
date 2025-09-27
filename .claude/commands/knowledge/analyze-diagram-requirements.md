# Args: `<description>` `[--type=auto|flowchart|class|sequence]` `[--output=analysis|json]`. v1.0.0. Analyze text descriptions to determine optimal Mermaid diagram type and extract key components.

## Summary

Analyzes text descriptions to identify the most appropriate Mermaid diagram type and extracts key components, relationships, and structure requirements. This command serves as the foundation for intelligent diagram generation by parsing natural language descriptions and providing structured analysis that guides the diagram creation process. The analysis considers complexity, audience, and use case to recommend optimal diagram patterns.

## Usage

```bash
/knowledge:analyze-diagram-requirements "<description>" [--type=auto|flowchart|class|sequence] [--output=analysis|json]
```

## Arguments

- `<description>`: Text description of what needs to be diagrammed (REQUIRED)
  - Natural language description of system, process, or concept
  - Can include technical specifications, user stories, or architectural descriptions
  - Examples: "User authentication flow", "Database schema for e-commerce", "API request lifecycle"
- `[--type=auto|flowchart|class|sequence]`: Force specific diagram type (OPTIONAL)
  - `auto` (default): Automatically determine best diagram type
  - `flowchart`: Force flowchart analysis for process/workflow diagrams
  - `class`: Force class diagram analysis for structure/relationship diagrams
  - `sequence`: Force sequence diagram analysis for interaction/time-based diagrams
- `[--output=analysis|json]`: Output format (OPTIONAL)
  - `analysis` (default): Human-readable analysis with recommendations
  - `json`: Structured JSON for programmatic consumption

## Examples

```bash
# Automatic analysis of authentication process
/knowledge:analyze-diagram-requirements "User logs in with email and password, system validates credentials against database, creates session token, and redirects to dashboard"

# Force class diagram analysis for data modeling
/knowledge:analyze-diagram-requirements "User has profile with name and email, can create multiple posts, each post has title and content, users can comment on posts" --type=class

# JSON output for integration with other tools
/knowledge:analyze-diagram-requirements "API receives request, validates input, queries database, transforms data, and returns response" --output=json

# Complex system analysis
/knowledge:analyze-diagram-requirements "Microservices architecture with API gateway, user service, product service, order service, payment service, and notification service communicating via REST APIs and message queues"
```

## What This Command Does

### Analysis Process

1. **Text Parsing and Entity Extraction**
   ```bash
   # Parse description for key elements
   echo "🔍 Analyzing description for diagram requirements..."
   
   # Extract entities using natural language processing patterns
   ENTITIES=$(echo "$DESCRIPTION" | grep -oE '[A-Z][a-z]+' | sort -u)
   VERBS=$(echo "$DESCRIPTION" | grep -oE '\b(creates?|validates?|sends?|receives?|processes?|stores?|retrieves?|updates?|deletes?)\b' | sort -u)
   
   echo "📊 Extracted entities: $ENTITIES"
   echo "⚡ Identified actions: $VERBS"
   ```

2. **Pattern Recognition and Classification**
   ```bash
   # Analyze for different diagram type indicators
   PROCESS_INDICATORS="flow|workflow|process|step|procedure|algorithm"
   STRUCTURE_INDICATORS="has|contains|inherits|extends|implements|relationship"
   INTERACTION_INDICATORS="sends|receives|calls|responds|sequence|timeline|interaction"
   
   # Count pattern matches to determine diagram type
   PROCESS_SCORE=$(echo "$DESCRIPTION" | grep -ioE "$PROCESS_INDICATORS" | wc -l)
   STRUCTURE_SCORE=$(echo "$DESCRIPTION" | grep -ioE "$STRUCTURE_INDICATORS" | wc -l)
   INTERACTION_SCORE=$(echo "$DESCRIPTION" | grep-ioE "$INTERACTION_INDICATORS" | wc -l)
   
   echo "📈 Pattern analysis:"
   echo "  Process indicators: $PROCESS_SCORE"
   echo "  Structure indicators: $STRUCTURE_SCORE"
   echo "  Interaction indicators: $INTERACTION_SCORE"
   ```

3. **Complexity Assessment**
   ```bash
   # Assess complexity based on entity count and relationship density
   ENTITY_COUNT=$(echo "$ENTITIES" | wc -w)
   VERB_COUNT=$(echo "$VERBS" | wc -w)
   
   if [ "$ENTITY_COUNT" -le 5 ] && [ "$VERB_COUNT" -le 5 ]; then
       COMPLEXITY="Simple"
   elif [ "$ENTITY_COUNT" -le 10 ] && [ "$VERB_COUNT" -le 10 ]; then
       COMPLEXITY="Medium"
   else
       COMPLEXITY="Complex"
   fi
   
   echo "🎯 Complexity assessment: $COMPLEXITY"
   ```

4. **Diagram Type Recommendation**
   ```bash
   # Determine optimal diagram type based on analysis
   if [ "$TYPE_FLAG" = "auto" ]; then
       if [ "$INTERACTION_SCORE" -gt "$PROCESS_SCORE" ] && [ "$INTERACTION_SCORE" -gt "$STRUCTURE_SCORE" ]; then
           RECOMMENDED_TYPE="sequence"
           RATIONALE="High interaction/communication patterns detected"
       elif [ "$STRUCTURE_SCORE" -gt "$PROCESS_SCORE" ]; then
           RECOMMENDED_TYPE="class"
           RATIONALE="Strong structural/relationship patterns detected"
       else
           RECOMMENDED_TYPE="flowchart"
           RATIONALE="Process/workflow patterns detected or general purpose visualization"
       fi
   else
       RECOMMENDED_TYPE="$TYPE_FLAG"
       RATIONALE="User-specified diagram type"
   fi
   
   echo "💡 Recommended diagram type: $RECOMMENDED_TYPE"
   echo "📝 Rationale: $RATIONALE"
   ```

5. **Component and Relationship Extraction**
   ```bash
   # Extract key components for diagram structure
   echo "🔧 Extracting diagram components..."
   
   # For flowcharts: identify decision points, processes, start/end
   if [ "$RECOMMENDED_TYPE" = "flowchart" ]; then
       DECISIONS=$(echo "$DESCRIPTION" | grep -ioE '\b(if|when|whether|check|validate|verify)\b' | sort -u)
       PROCESSES=$(echo "$DESCRIPTION" | grep -ioE '\b[a-z]+[s]?\b' | grep -vE '^(the|and|or|but|with|for|in|on|at|to|from)$' | sort -u)
       
       echo "  Decisions: $DECISIONS"
       echo "  Processes: $PROCESSES"
   fi
   
   # For class diagrams: identify classes, attributes, methods
   if [ "$RECOMMENDED_TYPE" = "class" ]; then
       CLASSES=$(echo "$ENTITIES")
       ATTRIBUTES=$(echo "$DESCRIPTION" | grep -ioE '\bhas [a-z]+\b|\bwith [a-z]+\b' | sed 's/has\|with //g' | sort -u)
       
       echo "  Classes: $CLASSES"
       echo "  Attributes: $ATTRIBUTES"
   fi
   
   # For sequence diagrams: identify participants and interactions
   if [ "$RECOMMENDED_TYPE" = "sequence" ]; then
       PARTICIPANTS=$(echo "$ENTITIES")
       INTERACTIONS=$(echo "$VERBS")
       
       echo "  Participants: $PARTICIPANTS"
       echo "  Interactions: $INTERACTIONS"
   fi
   ```

6. **Output Generation**
   ```bash
   # Generate structured analysis output
   if [ "$OUTPUT_FORMAT" = "json" ]; then
       # Generate JSON output for programmatic consumption
       cat << EOF
   {
     "analysis": {
       "recommended_type": "$RECOMMENDED_TYPE",
       "complexity": "$COMPLEXITY",
       "confidence": "$(calculate_confidence_score)",
       "rationale": "$RATIONALE"
     },
     "components": {
       "entities": $(echo "$ENTITIES" | jq -Rn 'input | split(" ")'),
       "actions": $(echo "$VERBS" | jq -Rn 'input | split(" ")'),
       "relationships": $(extract_relationships)
     },
     "recommendations": {
       "diagram_structure": "$(generate_structure_recommendation)",
       "styling_notes": "$(generate_styling_recommendation)",
       "complexity_handling": "$(generate_complexity_recommendation)"
     }
   }
   EOF
   else
       # Generate human-readable analysis
       echo ""
       echo "════════════════════════════════════════════════"
       echo "📋 DIAGRAM REQUIREMENTS ANALYSIS"
       echo "════════════════════════════════════════════════"
       echo ""
       echo "🎯 RECOMMENDATION"
       echo "  Diagram Type: $RECOMMENDED_TYPE"
       echo "  Complexity: $COMPLEXITY"
       echo "  Rationale: $RATIONALE"
       echo ""
       echo "🔧 KEY COMPONENTS"
       echo "  Entities: $ENTITIES"
       echo "  Actions: $VERBS"
       echo ""
       echo "📊 STRUCTURE ANALYSIS"
       echo "  Process Score: $PROCESS_SCORE"
       echo "  Structure Score: $STRUCTURE_SCORE"
       echo "  Interaction Score: $INTERACTION_SCORE"
       echo ""
       echo "💡 IMPLEMENTATION NOTES"
       echo "  $(generate_implementation_notes)"
       echo ""
       echo "📚 PATTERN RECOMMENDATIONS"
       echo "  $(generate_pattern_recommendations)"
   fi
   ```

### Script Integration

```bash
# Enhanced analysis using supporting scripts
if [[ -f "../scripts/analyze-diagram-requirements_text-processor.sh" ]]; then
    echo "🚀 Using enhanced text processing..."
    ../scripts/analyze-diagram-requirements_text-processor.sh "$DESCRIPTION" "$RECOMMENDED_TYPE"
fi

if [[ -f "../scripts/analyze-diagram-requirements_pattern-matcher.sh" ]]; then
    echo "🎯 Applying pattern matching algorithms..."
    ../scripts/analyze-diagram-requirements_pattern-matcher.sh "$DESCRIPTION" "$COMPLEXITY"
fi
```

## Common RUN Commands

```bash
# Quick analysis for common scenarios
/knowledge:analyze-diagram-requirements "User authentication flow with email and password"

# Detailed analysis with specific type
/knowledge:analyze-diagram-requirements "Database schema with users, orders, and products" --type=class

# JSON output for automation
/knowledge:analyze-diagram-requirements "API request-response cycle" --output=json

# Complex system analysis
/knowledge:analyze-diagram-requirements "Microservices communication with API gateway, multiple services, and message queues"
```

## Requirements

- Text description of system, process, or concept to be diagrammed
- Basic understanding of Mermaid diagram types and use cases
- Optional: specific diagram type preference
- Optional: output format preference for integration

## Error Handling

- **Empty Description**: Provides guidance on creating effective descriptions
- **Ambiguous Content**: Requests clarification or provides multiple options
- **Invalid Type Flag**: Lists valid type options and defaults to auto
- **Complex Analysis**: Breaks down complex descriptions into manageable components
- **Pattern Conflicts**: Explains reasoning when multiple diagram types are viable

## Notes

- **Intelligent Analysis**: Uses natural language processing patterns to extract meaning
- **Pattern Recognition**: Identifies common architectural and process patterns
- **Complexity Assessment**: Evaluates appropriate detail level for diagram
- **Type Optimization**: Recommends optimal diagram type based on content analysis
- **Structured Output**: Provides both human-readable and machine-readable formats
- **Integration Ready**: Designed to work seamlessly with diagram generation commands
- **Extensible**: Supports custom pattern recognition through scripts

This command serves as the foundation for the create-diagrams agent complex, providing intelligent analysis that guides optimal diagram creation and ensures appropriate visualization choices for different scenarios.
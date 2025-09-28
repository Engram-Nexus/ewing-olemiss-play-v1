#!/bin/bash
# update-knowledge_agent-orchestrator.sh - Agent orchestration controller for update-knowledge command
# Coordinates between knowledge:researcher and knowledge:architect agents for optimal knowledge management

set -euo pipefail

# Function to show usage
show_usage() {
    echo "Usage: $0 <topic> <subtopic_path> <statement> <orchestration_mode>"
    echo "Orchestration modes:"
    echo "  - dual-agent: Research + Architecture coordination"
    echo "  - single-agent: Architecture guidance only"
    echo "  - matrix-only: No agent orchestration"
    exit 1
}

# Check arguments
if [ $# -lt 4 ]; then
    show_usage
fi

TOPIC="$1"
SUBTOPIC_PATH="$2"
STATEMENT="$3"
ORCHESTRATION_MODE="$4"

# Create coordination workspace
WORKSPACE="/tmp/knowledge-orchestration-$(date +%s)"
mkdir -p "$WORKSPACE"

# Initialize coordination log
COORD_LOG="$WORKSPACE/coordination.log"
echo "Knowledge Agent Orchestration Log" > "$COORD_LOG"
echo "Started: $(date)" >> "$COORD_LOG"
echo "Topic: $TOPIC" >> "$COORD_LOG"
echo "Subtopic: $SUBTOPIC_PATH" >> "$COORD_LOG"
echo "Mode: $ORCHESTRATION_MODE" >> "$COORD_LOG"
echo "Workspace: $WORKSPACE" >> "$COORD_LOG"
echo "" >> "$COORD_LOG"

# Function to display research invocation
display_research_invocation() {
    local topic="$1"
    local subtopic_path="$2"
    local statement="$3"
    
    echo "=== KNOWLEDGE:RESEARCHER AGENT INVOCATION ===" | tee -a "$COORD_LOG"
    cat << EOF

🚨 REQUIRED TASK TOOL INVOCATION FOR RESEARCH PHASE 🚨

┌─────────────────────────────────────────────────┐
│ Tool: Task                                      │
│ subagent_type: knowledge:researcher             │  
│ description: Multi-perspective knowledge research│
│ prompt: [see detailed prompt below]             │
└─────────────────────────────────────────────────┘

RESEARCH PROMPT:
"Conduct comprehensive multi-angle research on: $topic$(if [[ -n "$subtopic_path" ]]; then echo "/$subtopic_path"; fi)

Statement to research: $statement

Research Framework:
1. PARALLEL FOUNDATION THREADS:
   - Perplexity MCP: Technical foundations and theory
   - Context7 MCP: Framework-specific documentation  
   - Web Search: Current implementations and trends

2. CREATIVE INVESTIGATION VECTORS:
   - Technical perspective: Implementation patterns
   - Stakeholder perspective: Developer, business, operational views
   - Temporal perspective: Historical evolution, current state, future trends
   - Contrarian analysis: Limitations and alternative approaches

3. CHAINED INVESTIGATION:
   - Follow promising leads discovered in foundation research
   - Investigate relationships and dependencies
   - Explore practical application scenarios

4. SYNTHESIS REQUIREMENTS:
   - Provide knowledge organization recommendations
   - Identify optimal subtopic boundaries
   - Suggest block structure and naming patterns
   - Note integration points with existing knowledge

Please provide comprehensive research findings with specific recommendations for knowledge architecture."

⏳ Execute this Task tool invocation and wait for completion before proceeding.

EOF
    echo "Research phase initiated at: $(date)" >> "$COORD_LOG"
}

# Function to display architecture invocation with research context
display_architecture_invocation_with_context() {
    local topic="$1"
    local subtopic_path="$2"
    local statement="$3"
    
    echo "=== KNOWLEDGE:ARCHITECT AGENT INVOCATION ===" | tee -a "$COORD_LOG"
    cat << EOF

🚨 REQUIRED TASK TOOL INVOCATION FOR ARCHITECTURE PHASE 🚨

┌─────────────────────────────────────────────────┐
│ Tool: Task                                      │
│ subagent_type: knowledge:architect              │
│ description: Structure analysis with research context│
│ prompt: [see detailed prompt below]             │
└─────────────────────────────────────────────────┘

ARCHITECTURE PROMPT:
"Analyze knowledge structure incorporating research findings: $topic$(if [[ -n "$subtopic_path" ]]; then echo "/$subtopic_path"; fi)

Original statement: $statement

CONTEXT: The knowledge:researcher agent has completed comprehensive research.
Please consider the research findings in your architectural recommendations.

Architecture Analysis Requirements:
1. STRUCTURE DESIGN:
   - Optimal subtopic organization based on research scope
   - Block naming conventions that reflect discovered patterns
   - Hierarchy design that accommodates research breadth/depth

2. INTEGRATION PLANNING:
   - How new knowledge fits existing architecture patterns
   - Cross-referencing strategies for related concepts
   - Navigation flow optimization

3. SCALABILITY CONSIDERATIONS:
   - Structure that grows with additional research
   - Organization patterns that support discovery
   - Maintenance strategies for long-term growth

4. IMPLEMENTATION GUIDANCE:
   - Specific directory and file names
   - Content organization within blocks
   - Matrix generation requirements
   - Validation and quality checkpoints

Please provide specific structural recommendations that optimize both the research findings and long-term knowledge architecture."

⏳ Execute this Task tool invocation and wait for completion before proceeding.

EOF
    echo "Architecture phase initiated at: $(date)" >> "$COORD_LOG"
}

# Function to display synthesis guidance
display_synthesis_guidance() {
    local topic="$1"
    local subtopic_path="$2"
    local statement="$3"
    
    echo "=== IMPLEMENTATION SYNTHESIS GUIDANCE ===" | tee -a "$COORD_LOG"
    cat << EOF

🔄 Phase 3: Implementation Synthesis

Based on the completed research and architectural analysis phases:

1. AGENT FINDINGS INTEGRATION:
   - Combine research insights with structural recommendations
   - Create knowledge blocks that reflect discovered patterns
   - Implement cross-references identified during research

2. OPTIMAL BLOCK NAMING:
   - Use researcher's domain insights for naming conventions
   - Apply architect's structural patterns for consistency
   - Create descriptive yet maintainable file names

3. CONTENT ORGANIZATION:
   - Structure block content based on research findings
   - Apply architectural guidelines for readability
   - Include cross-references and related concepts

4. MATRIX GENERATION:
   - Update matrices to reflect new organizational patterns
   - Include navigation aids discovered during research
   - Maintain architectural consistency across all levels

Implementation Notes:
- Topic: $topic
- Subtopic: $subtopic_path
- Original statement: $statement
- Workspace: $WORKSPACE

EOF
    echo "Synthesis phase initiated at: $(date)" >> "$COORD_LOG"
}

# Function to create agent communication protocol
create_agent_communication_protocol() {
    local protocol_file="$WORKSPACE/agent-protocol.md"
    
    cat > "$protocol_file" << EOF
# Agent Communication Protocol

## Research Phase Output Format
- **Scope**: Topic domain and boundaries explored
- **Findings**: Key insights and patterns discovered  
- **Relationships**: Connections to existing knowledge areas
- **Recommendations**: Structural suggestions for knowledge organization

## Architecture Phase Input Requirements
- **Research Context**: Complete research findings and scope
- **Existing Structure**: Current knowledge organization analysis
- **Integration Goals**: How new knowledge should fit existing patterns

## Architecture Phase Output Format
- **Structure Design**: Recommended subtopic and block organization
- **Naming Conventions**: Specific file and directory names
- **Integration Plan**: How to merge with existing knowledge
- **Cross-References**: Links and relationships to establish

## Implementation Phase Requirements
- **Block Names**: Specific filenames for knowledge blocks
- **Content Structure**: Organization of information within blocks
- **Matrix Updates**: Changes needed to README files
- **Validation Steps**: Quality checks and verification procedures

## Quality Assurance Framework
- **Source Validation**: Research sources must be verified
- **Structural Consistency**: Architecture must follow established patterns
- **Integration Testing**: New knowledge must fit existing structure
- **Documentation Standards**: All changes must be properly documented
EOF

    echo "📋 Agent communication protocol created: $protocol_file"
    echo "Protocol created at: $(date)" >> "$COORD_LOG"
}

# Main orchestration function
orchestrate_agents() {
    echo "🚀 Knowledge Agent Orchestration Starting" | tee -a "$COORD_LOG"
    echo "Mode: $ORCHESTRATION_MODE" | tee -a "$COORD_LOG"
    echo ""
    
    # Create communication protocol
    create_agent_communication_protocol
    echo ""
    
    case "$ORCHESTRATION_MODE" in
        "dual-agent")
            echo "🔀 Dual-agent orchestration initiated" | tee -a "$COORD_LOG"
            echo ""
            
            # Phase 1: Research
            echo "=== PHASE 1: KNOWLEDGE RESEARCH ==="
            echo "Phase 1: Research starting..." | tee -a "$COORD_LOG"
            display_research_invocation "$TOPIC" "$SUBTOPIC_PATH" "$STATEMENT"
            
            # Wait for research completion
            echo ""
            read -p "Press Enter when research phase is complete..."
            echo "Research phase completed at: $(date)" >> "$COORD_LOG"
            
            # Phase 2: Architecture  
            echo ""
            echo "=== PHASE 2: ARCHITECTURAL ANALYSIS ==="
            echo "Phase 2: Architecture starting..." | tee -a "$COORD_LOG"
            display_architecture_invocation_with_context "$TOPIC" "$SUBTOPIC_PATH" "$STATEMENT"
            
            # Wait for architecture completion
            echo ""
            read -p "Press Enter when architecture phase is complete..."
            echo "Architecture phase completed at: $(date)" >> "$COORD_LOG"
            
            # Phase 3: Synthesis
            echo ""
            echo "=== PHASE 3: IMPLEMENTATION SYNTHESIS ==="
            echo "Phase 3: Synthesis starting..." | tee -a "$COORD_LOG"
            display_synthesis_guidance "$TOPIC" "$SUBTOPIC_PATH" "$STATEMENT"
            ;;
            
        "single-agent")
            echo "🔀 Single-agent orchestration initiated" | tee -a "$COORD_LOG"
            echo ""
            echo "=== ARCHITECTURE GUIDANCE PHASE ==="
            display_architecture_invocation_with_context "$TOPIC" "$SUBTOPIC_PATH" "$STATEMENT"
            ;;
            
        "matrix-only")
            echo "🔀 Matrix-only update initiated" | tee -a "$COORD_LOG"
            echo "No agent orchestration required for matrix-only updates"
            ;;
            
        *)
            echo "❌ Unknown orchestration mode: $ORCHESTRATION_MODE"
            echo "Error: Unknown mode at $(date)" >> "$COORD_LOG"
            exit 1
            ;;
    esac
    
    echo ""
    echo "✅ Agent orchestration complete" | tee -a "$COORD_LOG"
    echo "Coordination workspace: $WORKSPACE"
    echo "Orchestration completed at: $(date)" >> "$COORD_LOG"
}

# Execute orchestration
orchestrate_agents

# Display workspace location for reference
echo ""
echo "📁 Orchestration artifacts saved in: $WORKSPACE"
echo "📋 Coordination log: $COORD_LOG"
echo "📄 Communication protocol: $WORKSPACE/agent-protocol.md"
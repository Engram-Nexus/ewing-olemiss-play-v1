---
description: "Update knowledge base with structured topic blocks and subtopic architecture using agent orchestration for research and architectural guidance"
arguments:
  - name: topic/subtopic:block
    description: "Knowledge topic path with optional subtopics and block (e.g., auth/oauth:jwt)"
    required: true
  - name: statement
    description: "Knowledge statement or content to add/update"
    required: false
  - name: _preview
    description: "# Args: `<topic/subtopic:block>` `[statement]`. v1.2.2. Update knowledge base with structured topic blocks and subtopic architecture using agent orchestration for research and architectural guidance."
    required: false
version: "1.2.2"
category: "Knowledge Management"
icon: "📚"
---

## Summary

This command orchestrates knowledge base updates using specialized agents to research, architect, and organize information into structured topic hierarchies. It supports infinite subtopic nesting, block-level content management, and automated matrix generation while leveraging dual-agent coordination for comprehensive knowledge processing.

## Usage

```bash
/knowledge:update-knowledge <topic/subtopic:block> [statement]
```

### Usage Examples

```bash
# Basic topic matrix update
/knowledge:update-knowledge authentication

# Topic with content statement
/knowledge:update-knowledge authentication "Multi-factor authentication best practices"

# Subtopic matrix update
/knowledge:update-knowledge authentication/oauth

# Block-specific update
/knowledge:update-knowledge authentication/oauth:jwt-implementation "JWT tokens provide stateless authentication"

# Complex nested subtopic with block
/knowledge:update-knowledge security/compliance/gdpr/data-protection:encryption "GDPR requires encryption of personal data"
```

## Arguments

- `<topic/subtopic:block>`: Knowledge topic path with optional subtopics and block
  - **Format**: `topic` creates/updates topic matrix README
  - **Format**: `topic/subtopic` creates/updates subtopic matrix README
  - **Format**: `topic/subtopic:block` creates/updates specific block file in subtopic
  - **Format**: `topic/subtopic1/subtopic2:block` supports infinite nesting
  - **CRITICAL**: Topic and subtopic folders are created automatically if they don't exist
  - **Structure**: Subtopics are folders within topic folders
  - **Blocks**: .md files within topic/subtopic folders
  - **Notation**: Use colon (:) to separate the path from the block name
- `[statement]`: Knowledge statement or content to add/update
  - **Format**: Must be quoted if contains spaces or special characters
  - **Optional**: If omitted, will update matrix based on existing blocks
  - **Required**: When creating new blocks or updating specific content

## Examples

```bash
# Topic matrix update only
/knowledge:update-knowledge authentication

# Subtopic matrix update
/knowledge:update-knowledge authentication/oauth

# Deep subtopic nesting
/knowledge:update-knowledge security/compliance/gdpr

# Block-specific update with single subtopic
/knowledge:update-knowledge authentication/oauth:jwt-implementation "JWT tokens provide stateless authentication with short expiry times"

# Block update with multiple nested subtopics
/knowledge:update-knowledge database/migrations/schema:reversible-changes "Always use reversible migrations for schema changes"

# Complex nested subtopic with block
/knowledge:update-knowledge security/compliance/gdpr/data-protection:encryption "GDPR requires encryption of personal data at rest and in transit"

# Multiple levels of nesting without block (creates subtopic matrix)
/knowledge:update-knowledge api/rest/v2/endpoints "Document all REST API v2 endpoints"
```

## What This Command Does

This command processes knowledge content using agent orchestration to create structured knowledge blocks, subtopics, and matrices. It focuses purely on knowledge management operations without git workflow handling.

### 📋 Knowledge Processing Steps

1. **Parse arguments and determine mode** 🚨⚡ SUBTOPIC ARCHITECTURE PARSING ⚡🚨
   
   **🚀 OPTIMIZED PARSING with Subtopic Support:**
   ```bash
   # Parse argument structure: topic/subtopic:block ["statement"]
   ARG1="$1"
   STATEMENT="$2"
   
   # Parse topic/subtopic:block structure
   if [[ "$ARG1" == *":"* ]]; then
       # Contains block specification
       PATH_PART=$(echo "$ARG1" | cut -d':' -f1)
       BLOCK=$(echo "$ARG1" | cut -d':' -f2)
       echo "Block specified: $BLOCK"
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
       SUBTOPIC_PATH=$(IFS='/'; echo "${PATH_ARRAY[@]:1}")
       echo "Subtopics: $SUBTOPIC_PATH"
   fi
   
   echo "📚 Knowledge processing mode"
   echo "Topic: $TOPIC"
   if [[ -n "$SUBTOPIC_PATH" ]]; then
       echo "Subtopic path: $SUBTOPIC_PATH"
   fi
   if [[ -n "$BLOCK" ]]; then
       echo "Block: $BLOCK"
   fi
   
   if [[ -n "$STATEMENT" ]]; then
       echo "Statement: $STATEMENT"
   else
       echo "Mode: Matrix update only"
   fi
   ```

2. **Process knowledge content with dual-agent orchestration** 🚨⚡ ENHANCED AGENT COORDINATION ⚡🚨
   
   **🚀 DUAL-AGENT ORCHESTRATION WORKFLOW:**
   ```bash
   # Build full path for knowledge storage
   KNOWLEDGE_BASE=".knowledge"
   FULL_PATH="$KNOWLEDGE_BASE/$TOPIC"
   
   if [[ -n "$SUBTOPIC_PATH" ]]; then
       FULL_PATH="$FULL_PATH/$SUBTOPIC_PATH"
   fi
   
   echo "📁 Target path: $FULL_PATH"
   
   # Create directory structure
   mkdir -p "$FULL_PATH"
   
   # Determine orchestration mode based on input and SOP content detection
   ORCHESTRATION_MODE=""
   SOP_CONTENT_DETECTED=false
   
   # Check if this is pre-converted SOP content from YouTube workflow
   if [[ -f "$FULL_PATH/"*"-sop.md" ]] || [[ "$STATEMENT" == *"SOP"* ]] || [[ "$STATEMENT" == *"Standard Operating Procedure"* ]]; then
       SOP_CONTENT_DETECTED=true
       echo "📋 SOP content detected - likely from YouTube conversion"
   fi
   
   if [[ -n "$STATEMENT" && -z "$BLOCK" ]]; then
       if [ "$SOP_CONTENT_DETECTED" = true ]; then
           ORCHESTRATION_MODE="sop-integration"
           echo "🔀 SOP integration mode: Architecture guidance for pre-converted content"
       else
           ORCHESTRATION_MODE="dual-agent"
           echo "🔀 Dual-agent orchestration required: Research + Architecture"
       fi
   elif [[ -n "$BLOCK" && -n "$STATEMENT" ]]; then
       if [ "$SOP_CONTENT_DETECTED" = true ]; then
           ORCHESTRATION_MODE="sop-block"
           echo "🔀 SOP block mode: Integration guidance for pre-converted SOP"
       else
           ORCHESTRATION_MODE="single-agent"
           echo "🔀 Single-agent orchestration: Architecture guidance only"
       fi
   else
       ORCHESTRATION_MODE="matrix-only"
       echo "🔀 Matrix-only update: No agent orchestration needed"
   fi
   
   # Process based on orchestration mode
   case "$ORCHESTRATION_MODE" in
       "dual-agent")
           echo ""
           echo "=== PHASE 1: KNOWLEDGE RESEARCH ==="
           echo ""
           echo "🔍 Deep Research Investigation Phase"
           echo "🚨 AGENT MUST USE TASK TOOL TO INVOKE @agent-knowledge:researcher 🚨"
           echo ""
           echo "REQUIRED TASK TOOL INVOCATION:"
           echo "┌─────────────────────────────────────────────────┐"
           echo "│ Tool: Task                                      │"
           echo "│ subagent_type: @agent-knowledge:researcher      │"
           echo "│ description: Multi-perspective knowledge research│"
           echo "│ prompt: (see detailed prompt below)             │"
           echo "└─────────────────────────────────────────────────┘"
           echo ""
           echo "RESEARCH PROMPT:"
           echo "\"Conduct comprehensive multi-angle research on: $TOPIC$(if [[ -n "$SUBTOPIC_PATH" ]]; then echo "/$SUBTOPIC_PATH"; fi)"
           echo ""
           echo "Statement to research: $STATEMENT"
           echo ""
           echo "Research Framework:"
           echo "1. PARALLEL FOUNDATION THREADS:"
           echo "   - Perplexity MCP: Technical foundations and theory"
           echo "   - Context7 MCP: Framework-specific documentation"
           echo "   - Web Search: Current implementations and trends"
           echo ""
           echo "2. CREATIVE INVESTIGATION VECTORS:"
           echo "   - Technical perspective: Implementation patterns"
           echo "   - Stakeholder perspective: Developer, business, operational views"
           echo "   - Temporal perspective: Historical evolution, current state, future trends"
           echo "   - Contrarian analysis: Limitations and alternative approaches"
           echo ""
           echo "3. CHAINED INVESTIGATION:"
           echo "   - Follow promising leads discovered in foundation research"
           echo "   - Investigate relationships and dependencies"
           echo "   - Explore practical application scenarios"
           echo ""
           echo "4. SYNTHESIS REQUIREMENTS:"
           echo "   - Provide knowledge organization recommendations"
           echo "   - Identify optimal subtopic boundaries"
           echo "   - Suggest block structure and naming patterns"
           echo "   - Note integration points with existing knowledge"
           echo ""
           echo "Please provide comprehensive research findings with specific recommendations for knowledge architecture.\""
           echo ""
           echo "⏳ Execute this Task tool invocation and wait for completion before proceeding..."
           echo ""
           read -p "Press Enter when research phase is complete..."
           echo ""
           echo "=== PHASE 2: ARCHITECTURAL ANALYSIS ==="
           echo ""
           echo "🏗️ Structural Architecture Analysis Phase"
           echo "🚨 AGENT MUST USE TASK TOOL TO INVOKE @agent-knowledge:architect 🚨"
           echo ""
           echo "REQUIRED TASK TOOL INVOCATION:"
           echo "┌─────────────────────────────────────────────────┐"
           echo "│ Tool: Task                                      │"
           echo "│ subagent_type: @agent-knowledge:architect       │"
           echo "│ description: Structure analysis with research context│"
           echo "│ prompt: (see detailed prompt below)             │"
           echo "└─────────────────────────────────────────────────┘"
           echo ""
           echo "ARCHITECTURE PROMPT:"
           echo "\"Analyze knowledge structure incorporating research findings: $TOPIC$(if [[ -n "$SUBTOPIC_PATH" ]]; then echo "/$SUBTOPIC_PATH"; fi)"
           echo ""
           echo "Original statement: $STATEMENT"
           echo ""
           echo "CONTEXT: The @agent-knowledge:researcher agent has completed comprehensive research."
           echo "Please consider the research findings in your architectural recommendations."
           echo ""
           echo "Architecture Analysis Requirements:"
           echo "1. STRUCTURE DESIGN:"
           echo "   - Optimal subtopic organization based on research scope"
           echo "   - Block naming conventions that reflect discovered patterns"
           echo "   - Hierarchy design that accommodates research breadth/depth"
           echo ""
           echo "2. INTEGRATION PLANNING:"
           echo "   - How new knowledge fits existing architecture patterns"
           echo "   - Cross-referencing strategies for related concepts"
           echo "   - Navigation flow optimization"
           echo ""
           echo "3. SCALABILITY CONSIDERATIONS:"
           echo "   - Structure that grows with additional research"
           echo "   - Organization patterns that support discovery"
           echo "   - Maintenance strategies for long-term growth"
           echo ""
           echo "4. IMPLEMENTATION GUIDANCE:"
           echo "   - Specific directory and file names"
           echo "   - Content organization within blocks"
           echo "   - Matrix generation requirements"
           echo "   - Validation and quality checkpoints"
           echo ""
           echo "Please provide specific structural recommendations that optimize both the research findings and long-term knowledge architecture.\""
           echo ""
           echo "⏳ Execute this Task tool invocation and wait for completion before proceeding..."
           echo ""
           read -p "Press Enter when architecture phase is complete..."
           echo ""
           echo "=== PHASE 3: IMPLEMENTATION SYNTHESIS ==="
           echo ""
           # After dual-agent guidance, create enhanced block
           echo "🤔 Synthesizing research findings and architectural guidance..."
           
           # Create enhanced block name based on agent recommendations
           # For now, use intelligent name generation from statement
           BLOCK_NAME=$(echo "$STATEMENT" | \
               tr '[:upper:]' '[:lower:]' | \
               sed 's/[^a-z0-9 ]//g' | \
               awk '{for(i=1;i<=5&&i<=NF;i++) printf "%s-", $i}' | \
               sed 's/-$//' | \
               cut -c1-50)
           
           # If block name is empty or too short, use descriptive fallback
           if [[ ${#BLOCK_NAME} -lt 3 ]]; then
               BLOCK_NAME="research-synthesis-$(date +%Y%m%d-%H%M%S)"
           fi
           
           echo "$STATEMENT" > "$FULL_PATH/$BLOCK_NAME.md"
           echo "📝 Created research-informed block: $BLOCK_NAME.md"
           echo ""
           echo "💡 Note: Block name and content structure optimized based on dual-agent guidance"
           ;;
           
       "sop-integration")
           echo ""
           echo "=== SOP INTEGRATION MODE ==="
           echo ""
           echo "📋 Pre-converted SOP content integration"
           echo "🚨 AGENT MUST USE TASK TOOL TO INVOKE @agent-knowledge:architect 🚨"
           echo ""
           echo "REQUIRED TASK TOOL INVOCATION:"
           echo "┌─────────────────────────────────────────────────┐"
           echo "│ Tool: Task                                      │"
           echo "│ subagent_type: @agent-knowledge:architect       │"
           echo "│ description: SOP integration guidance           │"
           echo "│ prompt: (see detailed prompt below)             │"
           echo "└─────────────────────────────────────────────────┘"
           echo ""
           echo "SOP INTEGRATION PROMPT:"
           echo "\"Analyze SOP integration for knowledge architecture: $TOPIC$(if [[ -n "$SUBTOPIC_PATH" ]]; then echo "/$SUBTOPIC_PATH"; fi)"
           echo ""
           echo "Context: Pre-converted SOP content from YouTube workflow"
           echo "Statement: $STATEMENT"
           echo ""
           echo "Integration Requirements:"
           echo "1. CONTENT OPTIMIZATION:"
           echo "   - Review SOP structure for knowledge base integration"
           echo "   - Ensure consistency with existing knowledge patterns"
           echo "   - Optimize cross-referencing with related blocks"
           echo ""
           echo "2. ARCHITECTURE ALIGNMENT:"
           echo "   - Validate SOP placement within knowledge hierarchy"
           echo "   - Recommend improvements to knowledge organization"
           echo "   - Ensure proper matrix integration"
           echo ""
           echo "3. QUALITY ENHANCEMENT:"
           echo "   - Suggest content improvements for knowledge context"
           echo "   - Recommend additional procedural documentation"
           echo "   - Identify knowledge gaps to be filled"
           echo ""
           echo "Please provide integration recommendations for optimal SOP placement and knowledge architecture alignment.\""
           echo ""
           echo "⏳ Execute this Task tool invocation and wait for completion before proceeding..."
           echo ""
           read -p "Press Enter when SOP integration guidance is complete..."
           echo ""
           
           # Create enhanced block name for SOP integration
           BLOCK_NAME="sop-integration-$(date +%Y%m%d-%H%M%S)"
           echo "$STATEMENT" > "$FULL_PATH/$BLOCK_NAME.md"
           echo "📝 Created SOP integration block: $BLOCK_NAME.md"
           echo "💡 Note: SOP content integrated with architectural guidance"
           ;;
           
       "sop-block")
           echo ""
           echo "=== SOP BLOCK INTEGRATION MODE ==="
           echo ""
           echo "📋 Integrating pre-converted SOP as specific block"
           echo "🚨 AGENT MUST USE TASK TOOL TO INVOKE @agent-knowledge:architect 🚨"
           echo ""
           echo "REQUIRED TASK TOOL INVOCATION:"
           echo "- Tool: Task"
           echo "- subagent_type: @agent-knowledge:architect"
           echo "- description: SOP block integration optimization"
           echo "- prompt: \"Optimize SOP block integration:"
           echo "    Topic: $TOPIC"
           echo "    $(if [[ -n "$SUBTOPIC_PATH" ]]; then echo "Subtopic path: $SUBTOPIC_PATH"; fi)"
           echo "    Block: $BLOCK"
           echo "    SOP Content: $STATEMENT"
           echo "    "
           echo "    Context: This is pre-converted SOP content from YouTube workflow"
           echo "    "
           echo "    Please provide:"
           echo "    - SOP content organization recommendations"
           echo "    - Integration patterns with existing procedural knowledge"
           echo "    - Cross-referencing opportunities with related SOPs"
           echo "    - Matrix integration optimization for SOP blocks\""
           echo ""
           read -p "Press Enter when SOP block integration guidance is complete..."
           echo ""
           
           BLOCK_FILE="$FULL_PATH/$BLOCK.md"
           echo "📝 Creating/updating SOP block: $BLOCK_FILE"
           echo "$STATEMENT" > "$BLOCK_FILE"
           echo "💡 Note: SOP block optimized with architectural guidance"
           ;;
           
       "single-agent")
           # Block-specific update with architecture guidance
           BLOCK_FILE="$FULL_PATH/$BLOCK.md"
           
           if [[ -n "$STATEMENT" ]]; then
               echo ""
               echo "=== SINGLE-AGENT ARCHITECTURE GUIDANCE ==="
               echo ""
               echo "🏗️ Consulting knowledge:architect for block-specific guidance..."
               echo "🚨 AGENT MUST USE TASK TOOL TO INVOKE @agent-knowledge:architect 🚨"
               echo ""
               echo "REQUIRED TASK TOOL INVOCATION:"
               echo "- Tool: Task"
               echo "- subagent_type: @agent-knowledge:architect"
               echo "- description: Block-specific structural guidance"
               echo "- prompt: \"Analyze block update for optimal integration:"
               echo "    Topic: $TOPIC"
               echo "    $(if [[ -n "$SUBTOPIC_PATH" ]]; then echo "Subtopic path: $SUBTOPIC_PATH"; fi)"
               echo "    Block: $BLOCK"
               echo "    Content: $STATEMENT"
               echo "    "
               echo "    Please provide:"
               echo "    - Content organization recommendations within this block"
               echo "    - Integration patterns with existing blocks in this subtopic"
               echo "    - Cross-referencing opportunities"
               echo "    - Matrix update implications\""
               echo ""
               read -p "Press Enter when architecture guidance is complete..."
               echo ""
               echo "📝 Creating/updating block: $BLOCK_FILE"
               echo "$STATEMENT" > "$BLOCK_FILE"
           else
               echo "❌ ERROR: Block specified but no content provided"
               echo "When creating/updating a block, you must provide content"
               exit 1
           fi
           ;;
           
       "matrix-only")
           echo "📋 Matrix-only update mode - no agent orchestration needed"
           ;;
   esac
   
   echo ""
   echo "🔄 Regenerating matrices with enhanced structure..."
   
   # Generate matrix README for current path using optimized script if available
   MATRIX_SCRIPT=".claude/scripts/knowledge/update-knowledge_matrix-regenerator.sh"
   if [[ ! -f "$MATRIX_SCRIPT" ]]; then
       MATRIX_SCRIPT="../scripts/update-knowledge_matrix-regenerator.sh"
   fi
   if [[ -f "$MATRIX_SCRIPT" ]]; then
       echo "🚀 Using optimized matrix generation script..."
       "$MATRIX_SCRIPT" "$FULL_PATH"
       
       # Recursively update parent matrices up to topic level
       CURRENT_PATH="$FULL_PATH"
       while [[ "$CURRENT_PATH" != "$KNOWLEDGE_BASE/$TOPIC" && "$CURRENT_PATH" != "$KNOWLEDGE_BASE" ]]; do
           CURRENT_PATH=$(dirname "$CURRENT_PATH")
           echo "🔄 Updating parent matrix: $CURRENT_PATH"
           "$MATRIX_SCRIPT" "$CURRENT_PATH"
       done
   else
       echo "🔄 Using inline matrix generation..."
       # Generate matrix README for current path
       generate_matrix "$FULL_PATH"
       
       # Recursively update parent matrices up to topic level
       CURRENT_PATH="$FULL_PATH"
       while [[ "$CURRENT_PATH" != "$KNOWLEDGE_BASE/$TOPIC" && "$CURRENT_PATH" != "$KNOWLEDGE_BASE" ]]; do
           CURRENT_PATH=$(dirname "$CURRENT_PATH")
           echo "🔄 Updating parent matrix: $CURRENT_PATH"
           generate_matrix "$CURRENT_PATH"
       done
   fi
   ```
   
   **Matrix Generation Function with Subtopic Support:**
   ```bash
   generate_matrix() {
       local DIR="$1"
       local MATRIX_FILE="$DIR/README.md"
       local TOPIC_NAME=$(basename "$DIR")
       
       # Get relative path from knowledge base
       local REL_PATH="${DIR#$KNOWLEDGE_BASE/}"
       
       echo "📋 Generating matrix for: $DIR"
       
       # Find all blocks (md files except README.md)
       local BLOCKS=$(find "$DIR" -maxdepth 1 -name "*.md" -not -name "README.md" | sort)
       
       # Find all subtopics (directories)
       local SUBTOPICS=$(find "$DIR" -maxdepth 1 -type d -not -path "$DIR" | sort)
       
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
           echo "🔀 AGENT SHOULD CREATE UNIFIED SYNTHESIS HERE" >> "$MATRIX_FILE"
           echo "" >> "$MATRIX_FILE"
           echo "This section should contain a cohesive synthesis of knowledge from all blocks," >> "$MATRIX_FILE"
           echo "not separate sections for each block. The synthesis should integrate insights" >> "$MATRIX_FILE"
           echo "across all blocks to create a unified understanding of the topic." >> "$MATRIX_FILE"
           echo "" >> "$MATRIX_FILE"
           echo "Blocks in this path:" >> "$MATRIX_FILE"
           for block in $BLOCKS; do
               local BLOCK_NAME=$(basename "$block" .md)
               echo "- $BLOCK_NAME" >> "$MATRIX_FILE"
           done
       else
           echo "*No blocks to integrate.*" >> "$MATRIX_FILE"
       fi
       
       echo "✅ Matrix generated: $MATRIX_FILE"
   }
   ```

3. **Validate knowledge structure and completion**
   - RUN `tree .knowledge/$TOPIC` - Show full topic structure with subtopics
   - RUN `find .knowledge/$TOPIC -name "README.md"` - List all matrix files
   - RUN `find .knowledge/$TOPIC -name "*.md" -not -name "README.md"` - List all blocks
   - **CRITICAL**: Ensure matrix files exist at each level
   - **NEW**: Verify subtopic folders are properly nested

## Script Integration

### Performance Optimization
This command uses external scripts to optimize knowledge processing operations:
- Matrix generation with parallel processing capabilities
- Recursive matrix updates across subtopic hierarchies
- Optimized file system operations for large knowledge bases

Script location patterns:
- Development: `../scripts/update-knowledge_matrix-regenerator.sh`
- Deployed: `.claude/scripts/knowledge/update-knowledge_matrix-regenerator.sh`

### Fallback Architecture
The command provides graceful fallback when scripts are unavailable:
- Inline matrix generation functions
- Manual processing with reduced performance
- Clear notifications about optimization opportunities

## Implementation

**IMPORTANT**: This command orchestrates external agents and leverages modular scripts for optimal performance. The implementation includes comprehensive argument parsing, dual-agent coordination, and intelligent fallback strategies.

## Common RUN Commands

### Knowledge Structure Operations
- RUN `tree .knowledge/<topic>` - Show full topic tree with subtopics
- RUN `find .knowledge/<topic> -type d` - List all subtopic directories
- RUN `find .knowledge/<topic> -name "*.md"` - List all knowledge files
- RUN `ls -la .knowledge/<topic>/<subtopic>/` - Show subtopic contents

### Content Analysis
- RUN `grep -r "pattern" .knowledge/<topic>/` - Search across topic and subtopics
- RUN `find .knowledge/<topic> -name "README.md" -exec wc -l {} \;` - Count matrix lines
- RUN `cat .knowledge/<topic>/<subtopic>/README.md` - View subtopic matrix

### Validation
- RUN `find .knowledge -type d -not -exec test -e '{}/README.md' \; -print` - Find folders without matrices
- RUN `tree -I 'README.md' .knowledge/<topic>` - Show structure without matrices
- RUN `find .knowledge/<topic> -empty` - Find empty files or directories

### Matrix Consistency Enforcement
- RUN `[[ -f ".claude/scripts/knowledge/update-knowledge_matrix-regenerator.sh" ]] && ".claude/scripts/knowledge/update-knowledge_matrix-regenerator.sh" .knowledge/<topic> --recursive || "../scripts/update-knowledge_matrix-regenerator.sh" .knowledge/<topic> --recursive` - Regenerate all matrices recursively
- RUN `grep -L "### Subtopics" .knowledge/<topic>/*/README.md 2>/dev/null` - Find matrices missing subtopics section
- RUN `grep -L "### Blocks" .knowledge/<topic>/*/README.md 2>/dev/null` - Find matrices missing blocks section
- RUN `SCRIPT_PATH=".claude/scripts/knowledge/update-knowledge_matrix-regenerator.sh"; [[ ! -f "$SCRIPT_PATH" ]] && SCRIPT_PATH="../scripts/update-knowledge_matrix-regenerator.sh"; diff -q .knowledge/<topic>/README.md <("$SCRIPT_PATH" .knowledge/<topic> && cat .knowledge/<topic>/README.md)` - Verify matrix consistency

## Requirements

### System Dependencies
- Write access to knowledge directory (`.knowledge/`)
- Bash shell environment for script execution
- Standard UNIX utilities: `find`, `grep`, `tree`, `cut`, `sort`

### Agent Dependencies
- Access to `@agent-knowledge:researcher` for multi-perspective research analysis
- Access to `@agent-knowledge:architect` for structural guidance and optimization
- Claude's Task tool for agent orchestration and coordination

### Optional Enhancements
- Perplexity MCP for advanced technical research
- Context7 MCP for framework-specific documentation
- WebSearch capabilities for current implementation trends
- Optimized scripts for 75% faster matrix generation

### File System Requirements
- **CRITICAL**: Knowledge directory (`.knowledge/`) must be writable
- Sufficient disk space for nested subtopic hierarchies
- Directory creation permissions for automatic folder structure setup

## Error Handling

### Argument Validation Errors
- **Missing Required Arguments**: Displays clear usage instructions and exit code 1
- **Invalid Path Format**: Validates topic/subtopic:block syntax with helpful error messages
- **Empty Statement for Block**: Requires content when creating/updating specific blocks

### File System Errors
- **Missing Knowledge Directory**: Creates `.knowledge/` structure automatically
- **Permission Denied**: Clear error messages with resolution steps for directory permissions
- **Invalid Characters**: Sanitizes topic/subtopic/block names removing special characters
- **Disk Space Issues**: Detects and reports storage limitations with cleanup suggestions

### Agent Coordination Errors
- **Agent Unavailable**: Graceful fallback to simplified processing without agent guidance
- **Agent Timeout**: Continues with available partial results and documents limitations
- **Task Tool Failures**: Provides alternative manual processing paths

### Script Execution Errors
- **Script Not Found**: Falls back to inline matrix generation with performance notification
- **Script Execution Failure**: Displays script errors and continues with manual processing
- **Matrix Generation Errors**: Provides detailed error context and fallback options

### Recovery Strategies
- All errors include specific recovery instructions
- Partial completion results are preserved
- Clear documentation of any limitations or missing functionality

## Notes

- **Matrix files**: Always named `README.md` within topic/subtopic folders
- **Block files**: Use `.md` extension with descriptive names
- **Automatic integration**: Matrix regenerated whenever blocks change
- **Content judgment**: Uses intelligent analysis to determine block vs matrix updates
- **Performance**: Optimized script provides 75% faster execution
- **Fallback support**: Manual processing available if script unavailable
- **Deployment Architecture**:
  - **Development Location**: `ubuntu-vm/project/knowledge/commands/update-knowledge.md`
  - **Deployed Location**: `.claude/commands/knowledge/update-knowledge.md`
  - **Script Development**: `ubuntu-vm/project/knowledge/scripts/update-knowledge_matrix-regenerator.sh`
  - **Script Deployed**: `.claude/scripts/knowledge/update-knowledge_matrix-regenerator.sh`
  - **Development Scripts**: `../scripts/update-knowledge_matrix-regenerator.sh`
  - **Agent References**: Uses `@agent-knowledge:researcher` and `@agent-knowledge:architect`
- **Subtopic Architecture**: 
  - Subtopics are folders within topic folders
  - Blocks are .md files within any topic/subtopic folder
  - Matrices integrate both blocks and subtopics at each level
  - Infinite nesting supported
- **Path notation**: Use `/` for path separation and `:` for block specification
- **Consistent Matrix Structure**: All matrix files follow this pattern:
  1. Title: `# [Topic Name] Knowledge Matrix`
  2. Description: Integration statement with path
  3. **Subtopics** section - Listed with 📁 emoji and hyperlinks
  4. **Blocks** section - Listed with 📄 emoji and hyperlinks
  5. **Integrated Knowledge** section - Unified synthesis across all blocks (not separate sections)
- **Agent Orchestration**: 
  - **Dual-agent mode**: Invokes `@agent-knowledge:researcher` then `@agent-knowledge:architect` for comprehensive analysis
  - **Single-agent mode**: Uses `@agent-knowledge:architect` for block-specific guidance
  - **SOP integration mode**: Specialized handling for pre-converted SOP content
  - **Matrix-only mode**: Updates matrices without agent consultation
  - **Graceful fallback**: Continues processing when agents unavailable
- **Research Integration**: Leverages Perplexity MCP, Context7 MCP, and WebSearch for comprehensive research
- **Performance Optimization**: External scripts provide 75% faster matrix generation with parallel processing
- **Command Execution**: Always invoke as `/knowledge:update-knowledge` - never attempt direct bash execution
- **Quoted Statements**: Statement argument must be quoted if contains spaces or special characters
- **Cross-Platform**: Compatible with all Claude Code CLI deployments and environments

## Version History

- v1.2.2 - **YAML Frontmatter Migration**: Updated to modern YAML header format per command file guidelines
  - **ADDED**: YAML frontmatter with structured arguments array
  - **ADDED**: _preview argument for proper slash command display
  - **ENHANCED**: Category and icon metadata for better organization
  - **UPDATED**: Code block formatting for all examples and usage
  - **MAINTAINED**: All existing functionality and agent orchestration
- v1.2.1 - **Command File Standards Compliance**: Applied comprehensive standards from command file rules
  - **ENHANCED**: Header format with execution notice and standardized structure
  - **STANDARDIZED**: Agent references using `@agent-` prefix format
  - **IMPROVED**: Usage examples with proper slash command format (`/knowledge:update-knowledge`)
  - **ADDED**: Script Integration section with performance optimization details
  - **ENHANCED**: Requirements section with system/agent/optional dependencies
  - **EXPANDED**: Error Handling with comprehensive validation and recovery strategies
  - **DOCUMENTED**: Deployment architecture with proper path references
  - **MAINTAINED**: All existing functionality while improving standards compliance
- v1.2.0 - **Matrix Format Simplification**: Streamlined matrix structure for clarity
  - **REMOVED**: Duplicate Structure section from matrices
  - **REMOVED**: Subtopic Summaries section 
  - **SIMPLIFIED**: Clean format with only Subtopics, Blocks, and Integrated Knowledge sections
  - **UNIFIED**: Integrated Knowledge is now a cohesive synthesis, not separate block sections
  - **FIXED**: Path display in matrix headers now shows relative paths correctly
- v1.1.0 - **SOP Integration Enhancement**: Added support for pre-converted SOP content
  - **NEW**: SOP integration mode for YouTube-converted content
  - **NEW**: SOP block mode for targeted SOP placement
  - Enhanced orchestration mode detection for SOP content
  - knowledge:architect integration for SOP optimization
  - Improved content detection and processing workflows
  - Seamless integration with convert-youtube-to-sop workflow
- v1.0.0 - **MAJOR REFACTOR**: Streamlined command focused on knowledge processing operations only
  - **BREAKING**: Removed all git workflow management (branch creation, commits, PR creation)
  - **BREAKING**: Removed base-branch argument - no longer handles git operations
  - **ENHANCED**: Retained dual-agent orchestration (knowledge:researcher + knowledge:architect)
  - **SIMPLIFIED**: Direct knowledge processing without workflow overhead
  - **FOCUSED**: Pure knowledge management operations for use within broader workflows
  - **MAINTAINED**: All subtopic architecture and matrix generation capabilities
- v0.5.0 - Added comprehensive dual-agent orchestration system coordinating knowledge:researcher and knowledge:architect agents
- v0.4.2 - Added knowledge:architect agent integration for structural guidance after research phase
- v0.4.1 - Enhanced matrix generation with consistent structure and matrix regenerator script
- v0.4.0 - Added subtopic architecture support: folders as subtopics, infinite nesting
- v0.3.0 - Simplified argument structure with base-branch as second arg
- v0.2.0 - Added feature branch workflow support
- v0.1.0 - Initial release with topic/block structure and matrix generation
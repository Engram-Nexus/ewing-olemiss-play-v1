---
description: "Identify missing or outdated knowledge content, analyze coverage gaps, and provide recommendations for knowledge base improvement"
arguments:
  - name: "topic/subtopic"
    description: "Knowledge topic path to analyze for gaps"
    required: true
  - name: "--depth"
    description: "Analysis depth level (shallow or deep)"
    required: false
  - name: "--suggest-fixes"
    description: "Generate specific recommendations for addressing gaps"
    required: false
  - name: "_preview"
    description: "analyze-knowledge-gaps <topic/subtopic> [--depth=shallow|deep] [--suggest-fixes]"
    required: false
version: "1.0.0"
category: "knowledge"
icon: "🔍"
---

Input: $ARGUMENTS (format: topic/subtopic [--depth=shallow|deep] [--suggest-fixes])

## Usage

```bash
/analyze-knowledge-gaps <topic>
/analyze-knowledge-gaps <topic/subtopic>
/analyze-knowledge-gaps <topic> --depth=deep
/analyze-knowledge-gaps <topic/subtopic> --suggest-fixes
/analyze-knowledge-gaps <topic> --depth=deep --suggest-fixes
```

## Arguments

- `<topic/subtopic>`: Knowledge topic path to analyze for gaps
  - **Format**: `topic` analyzes entire topic for missing coverage
  - **Format**: `topic/subtopic` analyzes specific subtopic gaps
  - **Format**: `topic/subtopic1/subtopic2` supports nested analysis
  - **CRITICAL**: Path must exist in docs/knowledge directory
- `[--depth=shallow|deep]`: Analysis depth level (default: shallow)
  - **shallow**: Surface-level gap analysis focusing on structure
  - **deep**: Comprehensive analysis including content quality and relationships
- `[--suggest-fixes]`: Generate specific recommendations for addressing gaps
  - **Optional**: If omitted, identifies gaps without solutions
  - **Output**: Actionable recommendations and implementation guidance

## Examples

```bash
# Basic gap analysis for authentication topic
/analyze-knowledge-gaps authentication

# Deep analysis of OAuth subtopic
/analyze-knowledge-gaps authentication/oauth --depth=deep

# Analysis with fix suggestions
/analyze-knowledge-gaps security/compliance --suggest-fixes

# Comprehensive analysis with solutions
/analyze-knowledge-gaps database/migrations --depth=deep --suggest-fixes

# Nested subtopic gap analysis
/analyze-knowledge-gaps api/rest/v2/endpoints --depth=deep --suggest-fixes
```

## What This Command Does

This command performs intelligent analysis of knowledge structures to identify missing content, outdated information, and coverage gaps, providing actionable recommendations for improvement.

### 📋 Gap Analysis Process

1. **Parse arguments and determine analysis scope** 🚨⚡ PARAMETER PROCESSING ⚡🚨
   
   ```bash
   # Parse analysis parameters
   TOPIC_PATH="$1"
   ANALYSIS_DEPTH="shallow"
   SUGGEST_FIXES=false
   
   # Process optional flags
   for arg in "$@"; do
       case $arg in
           --depth=*)
               ANALYSIS_DEPTH="${arg#*=}"
               echo "🔍 Analysis depth: $ANALYSIS_DEPTH"
               ;;
           --suggest-fixes)
               SUGGEST_FIXES=true
               echo "💡 Fix suggestion mode enabled"
               ;;
       esac
   done
   
   # Validate depth parameter
   if [[ "$ANALYSIS_DEPTH" != "shallow" && "$ANALYSIS_DEPTH" != "deep" ]]; then
       echo "❌ Invalid depth parameter. Use 'shallow' or 'deep'"
       exit 1
   fi
   
   # Parse topic/subtopic structure
   IFS='/' read -ra PATH_ARRAY <<< "$TOPIC_PATH"
   TOPIC="${PATH_ARRAY[0]}"
   
   # Build subtopic path if exists
   SUBTOPIC_PATH=""
   if [ ${#PATH_ARRAY[@]} -gt 1 ]; then
       SUBTOPIC_PATH=$(IFS='/'; echo "${PATH_ARRAY[@]:1}")
   fi
   
   # Determine analysis target
   KNOWLEDGE_BASE="docs/knowledge"
   FULL_PATH="$KNOWLEDGE_BASE/$TOPIC"
   
   if [[ -n "$SUBTOPIC_PATH" ]]; then
       FULL_PATH="$FULL_PATH/$SUBTOPIC_PATH"
   fi
   
   echo "🔍 Analyzing knowledge gaps in: $FULL_PATH"
   echo "📊 Depth: $ANALYSIS_DEPTH"
   echo "💡 Suggest fixes: $SUGGEST_FIXES"
   ```

2. **Structural gap analysis** 🚨⚡ STRUCTURAL COVERAGE ANALYSIS ⚡🚨
   
   **🚀 COMPREHENSIVE STRUCTURE EVALUATION:**
   ```bash
   STRUCTURAL_GAPS=()
   CONTENT_GAPS=()
   QUALITY_ISSUES=()
   RECOMMENDATIONS=()
   
   echo "🏗️  Analyzing structural coverage..."
   
   # Check if target path exists
   if [[ ! -d "$FULL_PATH" ]]; then
       STRUCTURAL_GAPS+=("❌ Target knowledge path does not exist: $FULL_PATH")
       echo "Cannot analyze non-existent knowledge structure"
       return 1
   fi
   
   # Analyze directory structure depth
   MAX_DEPTH=$(find "$FULL_PATH" -type d | awk -F/ '{print NF}' | sort -nr | head -1)
   CURRENT_DEPTH=$((MAX_DEPTH - $(echo "$FULL_PATH" | awk -F/ '{print NF}')))
   
   echo "📏 Structure depth: $CURRENT_DEPTH levels"
   
   if [[ $CURRENT_DEPTH -eq 0 ]]; then
       STRUCTURAL_GAPS+=("⚠️  Flat structure detected - consider organizing into subtopics")
   elif [[ $CURRENT_DEPTH -gt 3 ]]; then
       QUALITY_ISSUES+=("⚠️  Deep nesting detected ($CURRENT_DEPTH levels) - may impact navigation")
   fi
   
   # Count blocks vs subtopics ratio
   BLOCK_COUNT=$(find "$FULL_PATH" -name "*.md" -not -name "README.md" | wc -l)
   SUBTOPIC_COUNT=$(find "$FULL_PATH" -mindepth 1 -type d | wc -l)
   
   echo "📄 Blocks: $BLOCK_COUNT"
   echo "📁 Subtopics: $SUBTOPIC_COUNT"
   
   # Analyze structure balance
   if [[ $BLOCK_COUNT -eq 0 && $SUBTOPIC_COUNT -eq 0 ]]; then
       STRUCTURAL_GAPS+=("❌ Empty knowledge area - no blocks or subtopics found")
   elif [[ $BLOCK_COUNT -eq 0 && $SUBTOPIC_COUNT -gt 0 ]]; then
       STRUCTURAL_GAPS+=("⚠️  No blocks in root topic - all content nested in subtopics")
   elif [[ $BLOCK_COUNT -gt 10 && $SUBTOPIC_COUNT -eq 0 ]]; then
       QUALITY_ISSUES+=("⚠️  Many blocks ($BLOCK_COUNT) without subtopic organization")
       if [[ "$SUGGEST_FIXES" == true ]]; then
           RECOMMENDATIONS+=("💡 Consider organizing $BLOCK_COUNT blocks into logical subtopics")
       fi
   fi
   
   # Check for orphaned directories (directories without README.md)
   find "$FULL_PATH" -type d | while read -r dir; do
       if [[ ! -f "$dir/README.md" ]]; then
           STRUCTURAL_GAPS+=("❌ Missing README.md in directory: $dir")
           if [[ "$SUGGEST_FIXES" == true ]]; then
               RECOMMENDATIONS+=("💡 Create README.md matrix in: $dir")
           fi
       fi
   done
   ```

3. **Content gap analysis** 🚨⚡ CONTENT COVERAGE EVALUATION ⚡🚨
   
   **🚀 INTELLIGENT CONTENT GAP DETECTION:**
   ```bash
   echo "📝 Analyzing content coverage gaps..."
   
   # Analyze block content quality
   find "$FULL_PATH" -name "*.md" -not -name "README.md" | while read -r block_file; do
       block_name=$(basename "$block_file" .md)
       word_count=$(wc -w < "$block_file")
       line_count=$(wc -l < "$block_file")
       
       echo "📄 Analyzing block: $block_name ($word_count words, $line_count lines)"
       
       # Check for minimal content
       if [[ $word_count -lt 10 ]]; then
           CONTENT_GAPS+=("⚠️  Minimal content in block: $block_name ($word_count words)")
           if [[ "$SUGGEST_FIXES" == true ]]; then
               RECOMMENDATIONS+=("💡 Expand content in $block_name - add examples, use cases, or detailed explanation")
           fi
       fi
       
       # Check for header structure
       if ! grep -q "^#" "$block_file"; then
           QUALITY_ISSUES+=("⚠️  No headers in block: $block_name - impacts readability")
           if [[ "$SUGGEST_FIXES" == true ]]; then
               RECOMMENDATIONS+=("💡 Add header structure to $block_name for better organization")
           fi
       fi
       
       # Check for code examples (if relevant to topic)
       if [[ "$TOPIC" =~ ^(api|database|security|authentication)$ ]]; then
           if ! grep -q '```' "$block_file"; then
               CONTENT_GAPS+=("⚠️  No code examples in technical block: $block_name")
               if [[ "$SUGGEST_FIXES" == true ]]; then
                   RECOMMENDATIONS+=("💡 Add code examples to $block_name for practical guidance")
               fi
           fi
       fi
       
       # Deep analysis mode
       if [[ "$ANALYSIS_DEPTH" == "deep" ]]; then
           # Check for external links
           if ! grep -q "http" "$block_file"; then
               QUALITY_ISSUES+=("⚠️  No external references in block: $block_name - may lack authoritative sources")
           fi
           
           # Check for cross-references to other knowledge
           if ! grep -q "\[.*\](" "$block_file"; then
               QUALITY_ISSUES+=("⚠️  No internal links in block: $block_name - lacks knowledge integration")
               if [[ "$SUGGEST_FIXES" == true ]]; then
                   RECOMMENDATIONS+=("💡 Add cross-references in $block_name to related knowledge blocks")
               fi
           fi
       fi
   done
   ```

4. **Domain-specific gap analysis** 🚨⚡ INTELLIGENT DOMAIN ANALYSIS ⚡🚨
   
   **🚀 DOMAIN-AWARE GAP DETECTION:**
   ```bash
   echo "🎯 Performing domain-specific gap analysis..."
   
   # Define expected patterns for different knowledge domains
   case "$TOPIC" in
       "authentication")
           expected_subtopics=("oauth" "jwt" "saml" "mfa" "session-management")
           expected_blocks=("best-practices" "security-considerations" "implementation-guide")
           ;;
       "database")
           expected_subtopics=("design" "optimization" "security" "migrations" "monitoring")
           expected_blocks=("indexing" "query-optimization" "backup-strategies")
           ;;
       "api")
           expected_subtopics=("rest" "graphql" "authentication" "versioning" "documentation")
           expected_blocks=("design-principles" "error-handling" "rate-limiting")
           ;;
       "security")
           expected_subtopics=("authentication" "authorization" "encryption" "compliance")
           expected_blocks=("threat-modeling" "vulnerability-assessment" "incident-response")
           ;;
       *)
           expected_subtopics=()
           expected_blocks=()
           ;;
   esac
   
   # Check for missing expected subtopics
   if [[ ${#expected_subtopics[@]} -gt 0 ]]; then
       echo "🔍 Checking for expected $TOPIC subtopics..."
       for expected_subtopic in "${expected_subtopics[@]}"; do
           if [[ ! -d "$FULL_PATH/$expected_subtopic" ]]; then
               CONTENT_GAPS+=("⚠️  Missing expected $TOPIC subtopic: $expected_subtopic")
               if [[ "$SUGGEST_FIXES" == true ]]; then
                   RECOMMENDATIONS+=("💡 Consider adding $expected_subtopic subtopic to $TOPIC knowledge area")
               fi
           fi
       done
   fi
   
   # Check for missing expected blocks
   if [[ ${#expected_blocks[@]} -gt 0 ]]; then
       echo "🔍 Checking for expected $TOPIC blocks..."
       for expected_block in "${expected_blocks[@]}"; do
           if [[ ! -f "$FULL_PATH/$expected_block.md" ]]; then
               CONTENT_GAPS+=("⚠️  Missing expected $TOPIC block: $expected_block")
               if [[ "$SUGGEST_FIXES" == true ]]; then
                   RECOMMENDATIONS+=("💡 Create $expected_block.md block in $TOPIC for comprehensive coverage")
               fi
           fi
       done
   fi
   ```

5. **Generate comprehensive gap analysis report** 🚨⚡ DETAILED REPORTING ⚡🚨
   
   **🚀 COMPREHENSIVE ANALYSIS SUMMARY:**
   ```bash
   echo ""
   echo "📊 KNOWLEDGE GAP ANALYSIS REPORT"
   echo "================================="
   echo "📁 Target: $FULL_PATH"
   echo "🔍 Depth: $ANALYSIS_DEPTH"
   echo "💡 Suggestions: $SUGGEST_FIXES"
   echo "📅 Analysis Date: $(date)"
   echo ""
   
   # Count summary
   STRUCTURAL_COUNT=${#STRUCTURAL_GAPS[@]}
   CONTENT_COUNT=${#CONTENT_GAPS[@]}
   QUALITY_COUNT=${#QUALITY_ISSUES[@]}
   RECOMMENDATION_COUNT=${#RECOMMENDATIONS[@]}
   
   echo "📈 SUMMARY"
   echo "----------"
   echo "🏗️  Structural gaps: $STRUCTURAL_COUNT"
   echo "📝 Content gaps: $CONTENT_COUNT"
   echo "⚠️  Quality issues: $QUALITY_COUNT"
   echo "💡 Recommendations: $RECOMMENDATION_COUNT"
   echo ""
   
   # Display structural gaps
   if [[ $STRUCTURAL_COUNT -gt 0 ]]; then
       echo "🏗️  STRUCTURAL GAPS"
       echo "-------------------"
       for gap in "${STRUCTURAL_GAPS[@]}"; do
           echo "$gap"
       done
       echo ""
   fi
   
   # Display content gaps
   if [[ $CONTENT_COUNT -gt 0 ]]; then
       echo "📝 CONTENT GAPS"
       echo "---------------"
       for gap in "${CONTENT_GAPS[@]}"; do
           echo "$gap"
       done
       echo ""
   fi
   
   # Display quality issues
   if [[ $QUALITY_COUNT -gt 0 ]]; then
       echo "⚠️  QUALITY ISSUES"
       echo "------------------"
       for issue in "${QUALITY_ISSUES[@]}"; do
           echo "$issue"
       done
       echo ""
   fi
   
   # Display recommendations
   if [[ $RECOMMENDATION_COUNT -gt 0 ]]; then
       echo "💡 RECOMMENDATIONS"
       echo "------------------"
       for rec in "${RECOMMENDATIONS[@]}"; do
           echo "$rec"
       done
       echo ""
   fi
   
   # Overall assessment
   TOTAL_ISSUES=$((STRUCTURAL_COUNT + CONTENT_COUNT + QUALITY_COUNT))
   
   if [[ $TOTAL_ISSUES -eq 0 ]]; then
       echo "✅ EXCELLENT COVERAGE"
       echo "Knowledge area shows comprehensive coverage with no significant gaps identified"
   elif [[ $TOTAL_ISSUES -le 3 ]]; then
       echo "🟡 GOOD COVERAGE WITH MINOR GAPS"
       echo "Knowledge area is well-structured with only minor improvements needed"
   elif [[ $TOTAL_ISSUES -le 7 ]]; then
       echo "🟠 MODERATE GAPS IDENTIFIED"
       echo "Knowledge area needs attention to address coverage and quality issues"
   else
       echo "🔴 SIGNIFICANT GAPS FOUND"
       echo "Knowledge area requires substantial improvement for comprehensive coverage"
   fi
   
   # Priority actions
   echo ""
   echo "🎯 PRIORITY ACTIONS"
   echo "------------------"
   if [[ $STRUCTURAL_COUNT -gt 0 ]]; then
       echo "1. 🏗️  Address structural gaps first - these impact navigation and usability"
   fi
   if [[ $CONTENT_COUNT -gt 0 ]]; then
       echo "2. 📝 Fill content gaps - these represent missing knowledge coverage"
   fi
   if [[ $QUALITY_COUNT -gt 0 ]]; then
       echo "3. ⚠️  Improve content quality - these enhance knowledge effectiveness"
   fi
   ```

## Common RUN Commands During Execution

### Analysis Preparation
- RUN `tree $FULL_PATH` - Display structure for visual analysis
- RUN `find $FULL_PATH -name "*.md" | wc -l` - Count total markdown files
- RUN `du -sh $FULL_PATH` - Check knowledge area size

### Gap Detection
- RUN `find $FULL_PATH -empty` - Find empty files or directories
- RUN `find $FULL_PATH -name "*.md" -exec wc -w {} \;` - Word count analysis
- RUN `grep -r "TODO\\|FIXME\\|XXX" $FULL_PATH` - Find explicit gaps or notes

### Content Quality Analysis  
- RUN `grep -r "^#" $FULL_PATH` - Analyze header structure across files
- RUN `grep -r "http" $FULL_PATH` - Find external reference usage
- RUN `grep -r "\\[.*\\](" $FULL_PATH` - Analyze internal linking patterns

## Requirements

- Read access to docs/knowledge directory
- Find, grep, wc, and awk utilities
- Bash shell for advanced analysis
- Tree command for structure visualization
- **CRITICAL**: Target knowledge path must exist for analysis

## Error Handling

- **Target path not found**: Fails with clear error message and suggestions
- **Permission denied**: Provides guidance for resolving access issues
- **Invalid depth parameter**: Validates and provides correct usage
- **Empty knowledge areas**: Handles analysis of sparse content gracefully
- **Corrupted files**: Reports files that cannot be analyzed
- **Large knowledge areas**: Provides progress indicators for extensive analysis

## Notes

- **Intelligence scaling**: Shallow analysis focuses on structure, deep analysis includes content quality
- **Domain awareness**: Recognizes patterns specific to different knowledge domains
- **Actionable insights**: Distinguishes between structural gaps, content gaps, and quality issues
- **Recommendation engine**: Provides specific, implementable suggestions when requested
- **Comprehensive coverage**: Analyzes both what exists and what's missing
- **Quality assessment**: Evaluates not just presence but quality of knowledge content
- **Cross-domain patterns**: Applies knowledge management best practices across different topics

## Version History

- v1.0.0 - Initial release: Intelligent knowledge gap analysis system
  - Structural gap detection for topics and subtopics
  - Content coverage analysis with quality assessment
  - Domain-specific gap identification for common knowledge areas
  - Shallow vs deep analysis modes with different focus areas
  - Actionable recommendation generation for identified gaps
  - Comprehensive reporting with prioritized action items
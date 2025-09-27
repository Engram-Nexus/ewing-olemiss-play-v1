# Args: `<type>` `<description>`. v2.1.0. Validate documentation completeness and AI optimization

## Summary

Validates documentation completeness, AI optimization, and quality across agent complex components. Performs comprehensive documentation audits to ensure all components have proper documentation that enhances AI understanding and usage. Focuses on documentation patterns, completeness metrics, and AI-friendly formatting standards.

## Usage

```bash
/agent-complex:check-documentation <type> "<description>"
```

## Arguments

- `<type>`: Validation scope (REQUIRED)
  - `all` - Complete documentation audit across all components
  - `agents` - Focus on agent documentation validation
  - `commands` - Focus on command documentation validation
  - `docs` - Focus on standalone documentation validation
  - `meta` - Focus on meta-command documentation validation
- `<description>`: Specific validation focus or component description (REQUIRED)
  - Brief description of what to validate or focus area
  - Quote if contains spaces
  - Examples: "Complete audit for deployment readiness", "Agent documentation optimization", "Command reference validation"

## Examples

```bash
# Complete documentation audit
/agent-complex:check-documentation all "Complete audit for deployment readiness"

# Agent-specific documentation validation
/agent-complex:check-documentation agents "Validate agent documentation completeness and AI optimization"

# Command documentation validation
/agent-complex:check-documentation commands "Ensure command documentation follows best practices"

# Standalone docs validation
/agent-complex:check-documentation docs "Validate documentation quality and AI-friendly formatting"

# Meta-command documentation validation
/agent-complex:check-documentation meta "Ensure meta-command documentation is complete and clear"
```

## What This Command Does

### Documentation Validation Framework

This command provides comprehensive documentation quality assurance through systematic validation patterns:

1. **Documentation Discovery** 🔍
   ```bash
   # Scan for all documentation files
   find .claude/ -name "*.md" -type f | head -20
   find ubuntu-vm/ -name "*.md" -type f | head -20
   
   # Categorize by documentation type
   echo "📋 Found documentation categories:"
   echo "  - Agent documentation"
   echo "  - Command documentation" 
   echo "  - Standalone documentation"
   echo "  - Meta-command documentation"
   ```

2. **Completeness Validation** ✅
   ```bash
   # Check for required documentation sections
   for doc_file in $DOCUMENTATION_FILES; do
     echo "Validating: $doc_file"
     
     # Check for essential sections
     check_section_exists "$doc_file" "Summary"
     check_section_exists "$doc_file" "Usage"
     check_section_exists "$doc_file" "Examples"
     
     # Validate AI-friendly formatting
     validate_ai_formatting "$doc_file"
   done
   ```

3. **AI Optimization Analysis** 🤖
   ```bash
   # Analyze documentation for AI understanding
   check_ai_optimization() {
     local file="$1"
     
     # Check for clear structure
     if grep -q "^## Summary" "$file"; then
       echo "✅ Has summary section"
     else
       echo "❌ Missing summary section"
     fi
     
     # Check for usage patterns
     if grep -q "^## Usage" "$file" || grep -q "^## Command Execution" "$file"; then
       echo "✅ Has usage documentation"
     else
       echo "❌ Missing usage documentation"
     fi
     
     # Check for examples
     if grep -q "^## Examples" "$file"; then
       echo "✅ Has examples"
     else
       echo "❌ Missing examples"
     fi
   }
   ```

4. **Quality Metrics Collection** 📊
   ```bash
   # Generate documentation quality metrics
   calculate_documentation_metrics() {
     local total_docs=0
     local docs_with_summary=0
     local docs_with_usage=0
     local docs_with_examples=0
     
     for doc in $DOCUMENTATION_FILES; do
       ((total_docs++))
       
       grep -q "^## Summary" "$doc" && ((docs_with_summary++))
       grep -q "^## Usage\|^## Command Execution" "$doc" && ((docs_with_usage++))
       grep -q "^## Examples" "$doc" && ((docs_with_examples++))
     done
     
     echo "📈 Documentation Quality Metrics:"
     echo "  - Total documents: $total_docs"
     echo "  - With summary: $docs_with_summary ($((docs_with_summary * 100 / total_docs))%)"
     echo "  - With usage: $docs_with_usage ($((docs_with_usage * 100 / total_docs))%)"
     echo "  - With examples: $docs_with_examples ($((docs_with_examples * 100 / total_docs))%)"
   }
   ```

## Documentation Validation Categories

### Agent Documentation Standards

**Required Sections for Agent Files:**
```markdown
# Agent Name - Agent Description

name: agent-name
description: Clear agent purpose description

## Overview
[Purpose and capabilities]

## Key Features
[Main functionality points]

## Usage Patterns
[How to invoke and use the agent]

## Integration
[How this agent works with others]

## Examples
[Practical usage examples]
```

**AI Optimization Patterns:**
- Clear, descriptive agent names
- Comprehensive capability descriptions
- Usage pattern documentation
- Integration guidance
- Practical examples with context

### Command Documentation Standards

**Required Sections for Command Files:**
```markdown
# Args: `<arg1>` `<arg2>`. vX.Y.Z. Brief command description

## Summary
[Clear purpose and functionality]

## Usage
```bash
/topic:command-name <arguments>
```

## Arguments
[Detailed argument descriptions]

## Examples
[Multiple practical examples]

## What This Command Does
[Detailed implementation explanation]
```

**AI Optimization Elements:**
- Version tracking in header
- Clear argument specification
- Comprehensive usage examples
- Implementation details for understanding
- Error handling documentation

### Documentation Quality Metrics

**Completeness Scoring:**
```bash
# Calculate documentation completeness score
calculate_completeness_score() {
  local file="$1"
  local score=0
  local max_score=10
  
  # Essential sections (weighted)
  grep -q "^## Summary" "$file" && score=$((score + 2))
  grep -q "^## Usage\|^## Command Execution" "$file" && score=$((score + 2))
  grep -q "^## Examples" "$file" && score=$((score + 2))
  grep -q "^## Arguments\|^## Parameters" "$file" && score=$((score + 1))
  grep -q "^## What This.*Does" "$file" && score=$((score + 1))
  grep -q "^## Error Handling\|^## Troubleshooting" "$file" && score=$((score + 1))
  grep -q "^## Notes\|^## Important" "$file" && score=$((score + 1))
  
  echo "$score/$max_score"
}
```

**AI-Friendly Formatting Check:**
```bash
# Validate AI-optimized formatting
validate_ai_formatting() {
  local file="$1"
  local issues=0
  
  # Check for clear headings
  if ! grep -q "^# " "$file"; then
    echo "⚠️ Missing main heading"
    ((issues++))
  fi
  
  # Check for code block formatting
  if grep -q '```' "$file"; then
    echo "✅ Contains code examples"
  else
    echo "⚠️ No code examples found"
    ((issues++))
  fi
  
  # Check for structured lists
  if grep -q '^- \|^[0-9]\. \|^\* ' "$file"; then
    echo "✅ Contains structured lists"
  else
    echo "⚠️ No structured lists found"
    ((issues++))
  fi
  
  return $issues
}
```

## Validation Reports

### Standard Validation Output

```bash
echo "📊 Documentation Validation Report"
echo "=================================="
echo ""
echo "🎯 Validation Scope: $TYPE"
echo "📝 Focus: $DESCRIPTION"
echo ""
echo "📋 Documentation Inventory:"
echo "  - Agent files: $AGENT_COUNT"
echo "  - Command files: $COMMAND_COUNT"
echo "  - Documentation files: $DOC_COUNT"
echo "  - Meta-command files: $META_COUNT"
echo ""
echo "✅ Quality Metrics:"
echo "  - Overall completeness: $OVERALL_COMPLETENESS%"
echo "  - AI optimization score: $AI_OPTIMIZATION_SCORE%"
echo "  - Documentation coverage: $COVERAGE_PERCENTAGE%"
echo ""
echo "🔧 Recommendations:"
for recommendation in "${RECOMMENDATIONS[@]}"; do
  echo "  - $recommendation"
done
```

### Detailed Component Analysis

**Per-File Validation:**
```bash
validate_documentation_file() {
  local file="$1"
  local filename=$(basename "$file")
  
  echo "📄 Analyzing: $filename"
  echo "   Path: $file"
  
  # Calculate metrics
  local completeness=$(calculate_completeness_score "$file")
  local ai_score=$(validate_ai_formatting "$file")
  local word_count=$(wc -w < "$file")
  
  echo "   Completeness: $completeness"
  echo "   AI Optimization: $ai_score issues"
  echo "   Word Count: $word_count"
  
  # Check for specific patterns
  check_documentation_patterns "$file"
  
  echo ""
}
```

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "📚 CHECK-DOCUMENTATION v2.1.0"
echo "Comprehensive documentation validation and AI optimization audit"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 2 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:check-documentation <type> \"<description>\""
    echo "  type: all|agents|commands|docs|meta"
    echo "  description: Validation focus or description"
    exit 1
fi

TYPE="$1"
DESCRIPTION="$2"

# Validate type
case "$TYPE" in
  all|agents|commands|docs|meta)
    echo "✅ Validation type: $TYPE"
    ;;
  *)
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Valid types: all, agents, commands, docs, meta"
    exit 1
    ;;
esac

echo "📝 Validation focus: $DESCRIPTION"
echo ""

# Initialize counters and arrays
declare -a DOCUMENTATION_FILES=()
declare -a VALIDATION_ISSUES=()
declare -a RECOMMENDATIONS=()
TOTAL_FILES=0
FILES_WITH_ISSUES=0
OVERALL_SCORE=0

echo "🔍 Discovering documentation files..."
echo "────────────────────────────────────"

# Discover documentation based on type
case "$TYPE" in
  "all")
    mapfile -t DOCUMENTATION_FILES < <(find .claude/ ubuntu-vm/ -name "*.md" -type f 2>/dev/null | sort)
    ;;
  "agents")
    mapfile -t DOCUMENTATION_FILES < <(find .claude/agents/ ubuntu-vm/*/agents/ -name "*.md" -type f 2>/dev/null | sort)
    ;;
  "commands")
    mapfile -t DOCUMENTATION_FILES < <(find .claude/commands/ ubuntu-vm/*/commands/ -name "*.md" -type f 2>/dev/null | sort)
    ;;
  "docs")
    mapfile -t DOCUMENTATION_FILES < <(find .claude/docs/ ubuntu-vm/*/docs/ -name "*.md" -type f 2>/dev/null | sort)
    ;;
  "meta")
    mapfile -t DOCUMENTATION_FILES < <(find .claude/commands/ ubuntu-vm/*/commands/ -name "run-*.md" -type f 2>/dev/null | sort)
    ;;
esac

TOTAL_FILES=${#DOCUMENTATION_FILES[@]}

if [ $TOTAL_FILES -eq 0 ]; then
    echo "❌ No documentation files found for type: $TYPE"
    exit 1
fi

echo "📋 Found $TOTAL_FILES documentation files"
echo ""

# Validation functions
validate_essential_sections() {
    local file="$1"
    local issues=0
    
    # Check for Summary
    if ! grep -q "^## Summary" "$file"; then
        echo "  ❌ Missing ## Summary section"
        ((issues++))
    fi
    
    # Check for Usage or Command Execution
    if ! grep -q "^## Usage\|^## Command Execution" "$file"; then
        echo "  ❌ Missing ## Usage or ## Command Execution section"
        ((issues++))
    fi
    
    # Check for Examples
    if ! grep -q "^## Examples" "$file"; then
        echo "  ❌ Missing ## Examples section"
        ((issues++))
    fi
    
    return $issues
}

validate_ai_optimization() {
    local file="$1"
    local issues=0
    
    # Check for clear headings structure
    if [ $(grep -c "^# " "$file") -eq 0 ]; then
        echo "  ⚠️  No main heading found"
        ((issues++))
    fi
    
    # Check for code blocks
    if ! grep -q '```' "$file"; then
        echo "  ⚠️  No code examples found"
        ((issues++))
    fi
    
    # Check for structured content
    if ! grep -q '^- \|^[0-9]\. \|^\* ' "$file"; then
        echo "  ⚠️  Limited structured content (lists, etc.)"
        ((issues++))
    fi
    
    # Check for argument documentation patterns
    if grep -q "^## Arguments\|^## Parameters" "$file"; then
        echo "  ✅ Has argument documentation"
    else
        echo "  ⚠️  Missing argument/parameter documentation"
        ((issues++))
    fi
    
    return $issues
}

calculate_file_score() {
    local file="$1"
    local score=100
    
    # Essential sections check (40 points)
    if ! grep -q "^## Summary" "$file"; then score=$((score - 15)); fi
    if ! grep -q "^## Usage\|^## Command Execution" "$file"; then score=$((score - 15)); fi
    if ! grep -q "^## Examples" "$file"; then score=$((score - 10)); fi
    
    # AI optimization check (30 points)
    if ! grep -q '```' "$file"; then score=$((score - 10)); fi
    if ! grep -q '^- \|^[0-9]\. \|^\* ' "$file"; then score=$((score - 10)); fi
    if ! grep -q "^## Arguments\|^## Parameters" "$file"; then score=$((score - 10)); fi
    
    # Additional quality factors (30 points)
    if ! grep -q "^## What.*Does\|^## Implementation" "$file"; then score=$((score - 10)); fi
    if ! grep -q "^## Error\|^## Notes\|^## Troubleshooting" "$file"; then score=$((score - 10)); fi
    local word_count=$(wc -w < "$file")
    if [ $word_count -lt 200 ]; then score=$((score - 10)); fi
    
    echo $score
}

echo "📊 Validating documentation quality..."
echo "─────────────────────────────────────"

# Process each documentation file
for doc_file in "${DOCUMENTATION_FILES[@]}"; do
    if [ ! -f "$doc_file" ]; then
        continue
    fi
    
    filename=$(basename "$doc_file")
    echo "📄 $filename"
    echo "   Path: $doc_file"
    
    file_issues=0
    
    # Validate essential sections
    if ! validate_essential_sections "$doc_file"; then
        file_issues=$((file_issues + $?))
    fi
    
    # Validate AI optimization
    if ! validate_ai_optimization "$doc_file"; then
        file_issues=$((file_issues + $?))
    fi
    
    # Calculate file score
    file_score=$(calculate_file_score "$doc_file")
    OVERALL_SCORE=$((OVERALL_SCORE + file_score))
    
    echo "   Score: $file_score/100"
    
    if [ $file_issues -gt 0 ]; then
        FILES_WITH_ISSUES=$((FILES_WITH_ISSUES + 1))
        VALIDATION_ISSUES+=("$filename: $file_issues issues")
    else
        echo "   ✅ All validations passed"
    fi
    
    echo ""
done

# Calculate overall metrics
if [ $TOTAL_FILES -gt 0 ]; then
    AVERAGE_SCORE=$((OVERALL_SCORE / TOTAL_FILES))
else
    AVERAGE_SCORE=0
fi

PASS_RATE=$(( (TOTAL_FILES - FILES_WITH_ISSUES) * 100 / TOTAL_FILES ))

echo "═══════════════════════════════════════════════════════════════════"
echo "📈 Documentation Validation Results"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 Validation Summary:"
echo "  - Scope: $TYPE"
echo "  - Focus: $DESCRIPTION"
echo "  - Files analyzed: $TOTAL_FILES"
echo ""
echo "📊 Quality Metrics:"
echo "  - Average score: $AVERAGE_SCORE/100"
echo "  - Pass rate: $PASS_RATE% ($((TOTAL_FILES - FILES_WITH_ISSUES))/$TOTAL_FILES files)"
echo "  - Files with issues: $FILES_WITH_ISSUES"
echo ""

# Generate recommendations based on common issues
if [ $FILES_WITH_ISSUES -gt 0 ]; then
    echo "🔧 Improvement Recommendations:"
    
    # Count missing sections across all files
    missing_summary=$(grep -c "❌ Missing ## Summary" <<< "$(for f in "${DOCUMENTATION_FILES[@]}"; do validate_essential_sections "$f" 2>&1; done)" || true)
    missing_usage=$(grep -c "❌ Missing ## Usage" <<< "$(for f in "${DOCUMENTATION_FILES[@]}"; do validate_essential_sections "$f" 2>&1; done)" || true)
    missing_examples=$(grep -c "❌ Missing ## Examples" <<< "$(for f in "${DOCUMENTATION_FILES[@]}"; do validate_essential_sections "$f" 2>&1; done)" || true)
    
    if [ $missing_summary -gt 0 ]; then
        echo "  - Add Summary sections to $missing_summary files for better AI understanding"
        RECOMMENDATIONS+=("Add Summary sections for AI comprehension")
    fi
    
    if [ $missing_usage -gt 0 ]; then
        echo "  - Add Usage sections to $missing_usage files for clear invocation patterns"
        RECOMMENDATIONS+=("Add Usage sections for invocation clarity")
    fi
    
    if [ $missing_examples -gt 0 ]; then
        echo "  - Add Examples sections to $missing_examples files for practical guidance"
        RECOMMENDATIONS+=("Add Examples sections for practical guidance")
    fi
    
    # AI optimization recommendations
    if [ $AVERAGE_SCORE -lt 80 ]; then
        echo "  - Focus on AI-friendly formatting (code blocks, structured lists)"
        RECOMMENDATIONS+=("Improve AI-friendly formatting")
    fi
    
    if [ $AVERAGE_SCORE -lt 60 ]; then
        echo "  - Consider comprehensive documentation rewrite for low-scoring files"
        RECOMMENDATIONS+=("Consider comprehensive documentation overhaul")
    fi
else
    echo "✅ All documentation meets quality standards!"
fi

echo ""
echo "📋 Detailed Issues:"
for issue in "${VALIDATION_ISSUES[@]}"; do
    echo "  - $issue"
done

echo ""
echo "═══════════════════════════════════════════════════════════════════"
if [ $PASS_RATE -ge 90 ]; then
    echo "✅ EXCELLENT: Documentation quality exceeds standards"
elif [ $PASS_RATE -ge 75 ]; then
    echo "✅ GOOD: Documentation quality meets standards with minor improvements needed"
elif [ $PASS_RATE -ge 50 ]; then
    echo "⚠️  NEEDS IMPROVEMENT: Documentation quality requires attention"
else
    echo "❌ CRITICAL: Documentation quality needs significant improvement"
fi
echo "═══════════════════════════════════════════════════════════════════"
```

## Quality Standards

### Documentation Completeness Requirements

**Essential Sections (Required):**
- **Summary**: Clear purpose and functionality description
- **Usage**: Command invocation patterns and syntax
- **Examples**: Practical usage scenarios with context

**Recommended Sections:**
- **Arguments/Parameters**: Detailed input specifications
- **What This Command Does**: Implementation details
- **Error Handling**: Common issues and solutions
- **Notes**: Important considerations and caveats

### AI Optimization Standards

**Formatting Requirements:**
- Clear hierarchical heading structure (H1, H2, H3)
- Code blocks for all command examples and syntax
- Structured lists for parameters, features, and steps
- Consistent markdown formatting throughout

**Content Requirements:**
- Descriptive section headings that explain purpose
- Contextual examples with realistic use cases
- Clear parameter descriptions with types and constraints
- Implementation details that help AI understand functionality

## Error Handling

The command handles various documentation validation scenarios:

**File Discovery Issues:**
- No documentation files found for specified type
- Missing or inaccessible documentation directories
- Permission issues accessing files

**Validation Errors:**
- Malformed markdown structure
- Missing critical sections
- Poor AI optimization formatting
- Insufficient content length or depth

**Reporting Issues:**
- Calculation errors in scoring metrics
- Issues with file content analysis
- Problems generating recommendations

## Version History

- v2.1.0 - Enhanced AI optimization validation
  - Added comprehensive AI-friendly formatting checks
  - Improved scoring algorithm with weighted sections
  - Added detailed recommendations based on common patterns
  - Enhanced reporting with pass rates and quality metrics
- v2.0.0 - Complete validation framework
  - Restructured for comprehensive documentation auditing
  - Added multiple validation types (all, agents, commands, docs, meta)
  - Implemented scoring system and quality metrics
  - Added AI optimization validation patterns
- v1.0.0 - Initial documentation validation
  - Basic file discovery and section checking
  - Simple completeness validation
  - Basic reporting functionality
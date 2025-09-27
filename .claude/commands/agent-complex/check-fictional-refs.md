# Args: `<type>` `<description>`. v2.0.0. Validate that entity references in documentation and code actually exist

## Summary

Validates that all entity references (files, commands, agents, URLs, etc.) mentioned in documentation and code actually exist. Prevents broken references and fictional entities from being deployed. Performs comprehensive reference validation across the agent complex ecosystem to ensure all documented entities are real and accessible.

## Usage

```bash
/agent-complex:check-fictional-refs <type> "<description>"
```

## Arguments

- `<type>`: Validation scope (REQUIRED)
  - `all` - Complete reference validation across all components
  - `docs` - Focus on documentation reference validation
  - `commands` - Focus on command reference validation
  - `agents` - Focus on agent reference validation
  - `file` - Validate specific file's references
- `<description>`: Specific validation focus or file path (REQUIRED)
  - For `all`, `docs`, `commands`, `agents`: Brief description of validation focus
  - For `file`: Path to specific file to validate
  - Quote if contains spaces
  - Examples: "Complete reference audit", "docs/api-guide.md", "Validate command references"

## Examples

```bash
# Complete reference validation
/agent-complex:check-fictional-refs all "Complete reference audit for deployment readiness"

# Documentation-specific validation
/agent-complex:check-fictional-refs docs "Validate all documentation references exist"

# Command reference validation
/agent-complex:check-fictional-refs commands "Ensure command references are valid"

# Agent reference validation
/agent-complex:check-fictional-refs agents "Validate agent references and imports"

# Specific file validation
/agent-complex:check-fictional-refs file "docs/deployment-guide.md"

# Validate specific command file
/agent-complex:check-fictional-refs file ".claude/commands/dev/deploy-stack.md"
```

## What This Command Does

### Reference Validation Framework

This command provides comprehensive validation of entity references to prevent broken links and fictional references:

1. **Reference Discovery** 🔍
   ```bash
   # Extract all reference patterns from files
   extract_references() {
     local file="$1"
     
     # File path references
     grep -oE '\.[^[:space:]]*\.md' "$file" | sort -u > "$TEMP_DIR/file_refs.txt"
     grep -oE '/[^[:space:]]*\.md' "$file" | sort -u >> "$TEMP_DIR/file_refs.txt"
     
     # Command references  
     grep -oE '/[a-z-]+:[a-z-]+' "$file" | sort -u > "$TEMP_DIR/command_refs.txt"
     
     # Agent references
     grep -oE '@agent-[a-z-]+:[a-z-]+' "$file" | sort -u > "$TEMP_DIR/agent_refs.txt"
     
     # URL references
     grep -oE 'https?://[^[:space:]]+' "$file" | sort -u > "$TEMP_DIR/url_refs.txt"
   }
   ```

2. **File Reference Validation** 📁
   ```bash
   # Validate file references exist
   validate_file_references() {
     local file="$1"
     local issues=0
     
     echo "📁 Validating file references in: $(basename "$file")"
     
     while IFS= read -r file_ref; do
       if [ -n "$file_ref" ]; then
         # Convert relative paths to absolute
         if [[ "$file_ref" == ./* ]]; then
           local abs_path="$(dirname "$file")/$file_ref"
         else
           local abs_path="$file_ref"
         fi
         
         if [ ! -f "$abs_path" ]; then
           echo "  ❌ Missing file: $file_ref"
           ((issues++))
         else
           echo "  ✅ Found: $file_ref"
         fi
       fi
     done < "$TEMP_DIR/file_refs.txt"
     
     return $issues
   }
   ```

3. **Command Reference Validation** ⚙️
   ```bash
   # Validate command references exist
   validate_command_references() {
     local file="$1"
     local issues=0
     
     echo "⚙️ Validating command references in: $(basename "$file")"
     
     while IFS= read -r cmd_ref; do
       if [ -n "$cmd_ref" ]; then
         # Parse command reference: /topic:command-name
         local topic=$(echo "$cmd_ref" | cut -d: -f1 | sed 's|^/||')
         local command=$(echo "$cmd_ref" | cut -d: -f2)
         
         # Check in multiple possible locations
         local found=false
         for location in ".claude/commands/$topic" "ubuntu-vm/user/$topic/commands" "ubuntu-vm/project/$topic/commands"; do
           if [ -f "$location/$command.md" ]; then
             echo "  ✅ Found: $cmd_ref ($location/$command.md)"
             found=true
             break
           fi
         done
         
         if [ "$found" = false ]; then
           echo "  ❌ Missing command: $cmd_ref"
           ((issues++))
         fi
       fi
     done < "$TEMP_DIR/command_refs.txt"
     
     return $issues
   }
   ```

4. **Agent Reference Validation** 🤖
   ```bash
   # Validate agent references exist
   validate_agent_references() {
     local file="$1"
     local issues=0
     
     echo "🤖 Validating agent references in: $(basename "$file")"
     
     while IFS= read -r agent_ref; do
       if [ -n "$agent_ref" ]; then
         # Parse agent reference: @agent-topic:agent-name
         local topic_agent=$(echo "$agent_ref" | sed 's/@agent-//')
         local topic=$(echo "$topic_agent" | cut -d: -f1)
         local agent=$(echo "$topic_agent" | cut -d: -f2)
         
         # Check in multiple possible locations
         local found=false
         for location in ".claude/agents" "ubuntu-vm/user/$topic/agents" "ubuntu-vm/project/$topic/agents"; do
           if [ -f "$location/$agent.md" ]; then
             echo "  ✅ Found: $agent_ref ($location/$agent.md)"
             found=true
             break
           fi
         done
         
         if [ "$found" = false ]; then
           echo "  ❌ Missing agent: $agent_ref"
           ((issues++))
         fi
       fi
     done < "$TEMP_DIR/agent_refs.txt"
     
     return $issues
   }
   ```

5. **URL Reference Validation** 🌐
   ```bash
   # Validate URL references are accessible
   validate_url_references() {
     local file="$1"
     local issues=0
     
     echo "🌐 Validating URL references in: $(basename "$file")"
     
     while IFS= read -r url_ref; do
       if [ -n "$url_ref" ]; then
         # Skip localhost and example URLs
         if [[ "$url_ref" =~ ^https?://localhost ]] || [[ "$url_ref" =~ example\.(com|org) ]]; then
           echo "  ⏭️ Skipped: $url_ref (localhost/example)"
           continue
         fi
         
         # Check if URL is accessible (with timeout)
         if curl -s --head --connect-timeout 5 --max-time 10 "$url_ref" > /dev/null 2>&1; then
           echo "  ✅ Accessible: $url_ref"
         else
           echo "  ❌ Inaccessible: $url_ref"
           ((issues++))
         fi
       fi
     done < "$TEMP_DIR/url_refs.txt"
     
     return $issues
   }
   ```

## Reference Types and Patterns

### File References

**Common File Reference Patterns:**
```bash
# Relative file references
./relative-file.md
../parent-dir/file.md
docs/guide.md

# Absolute file references
/absolute/path/to/file.md
.claude/commands/topic/command.md
ubuntu-vm/project/topic/agents/agent.md
```

**Validation Strategy:**
- Convert relative paths to absolute based on file location
- Check multiple possible locations for referenced files
- Validate file accessibility and permissions

### Command References

**Command Reference Patterns:**
```bash
# Standard command references
/topic:command-name
/dev:create-pr
/agent-complex:check-documentation

# Meta-command references
/topic:run-workflow-name
/dev:run-deployment
/agent-complex:run-qa
```

**Validation Locations:**
- `.claude/commands/{topic}/{command}.md`
- `ubuntu-vm/user/{topic}/commands/{command}.md`
- `ubuntu-vm/project/{topic}/commands/{command}.md`

### Agent References

**Agent Reference Patterns:**
```bash
# Standard agent references
@agent-topic:agent-name
@agent-dev:deployment-manager
@agent-figma-make:design-dev

# Complex agent references
@agent-agent-complex:builder
@agent-agent-complex:researcher
```

**Validation Locations:**
- `.claude/agents/{agent}.md`
- `ubuntu-vm/user/{topic}/agents/{agent}.md`
- `ubuntu-vm/project/{topic}/agents/{agent}.md`

### URL References

**URL Reference Patterns:**
```bash
# Documentation URLs
https://docs.example.com/api
https://github.com/user/repo

# API endpoints
https://api.service.com/v1/endpoint
https://webhook.site/unique-id

# External resources
https://npmjs.com/package/package-name
```

**Validation Strategy:**
- HTTP HEAD requests with timeout
- Skip localhost and example domains
- Report accessibility status
- Handle redirects and status codes

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🔍 CHECK-FICTIONAL-REFS v2.0.0"
echo "Comprehensive entity reference validation and verification"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 2 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:check-fictional-refs <type> \"<description>\""
    echo "  type: all|docs|commands|agents|file"
    echo "  description: Validation focus or file path"
    exit 1
fi

TYPE="$1"
DESCRIPTION="$2"

# Validate type
case "$TYPE" in
  all|docs|commands|agents|file)
    echo "✅ Validation type: $TYPE"
    ;;
  *)
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Valid types: all, docs, commands, agents, file"
    exit 1
    ;;
esac

echo "📝 Validation focus: $DESCRIPTION"
echo ""

# Create temporary directory for reference extraction
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Initialize counters
declare -a TARGET_FILES=()
declare -a VALIDATION_ISSUES=()
TOTAL_FILES=0
TOTAL_REFERENCES=0
BROKEN_REFERENCES=0

echo "🔍 Discovering target files..."
echo "─────────────────────────────"

# Determine target files based on type
case "$TYPE" in
  "all")
    mapfile -t TARGET_FILES < <(find .claude/ ubuntu-vm/ -name "*.md" -type f 2>/dev/null | sort)
    ;;
  "docs")
    mapfile -t TARGET_FILES < <(find .claude/docs/ ubuntu-vm/*/docs/ -name "*.md" -type f 2>/dev/null | sort)
    ;;
  "commands")
    mapfile -t TARGET_FILES < <(find .claude/commands/ ubuntu-vm/*/commands/ -name "*.md" -type f 2>/dev/null | sort)
    ;;
  "agents")
    mapfile -t TARGET_FILES < <(find .claude/agents/ ubuntu-vm/*/agents/ -name "*.md" -type f 2>/dev/null | sort)
    ;;
  "file")
    if [ -f "$DESCRIPTION" ]; then
      TARGET_FILES=("$DESCRIPTION")
    else
      echo "❌ Error: File not found: $DESCRIPTION"
      exit 1
    fi
    ;;
esac

TOTAL_FILES=${#TARGET_FILES[@]}

if [ $TOTAL_FILES -eq 0 ]; then
    echo "❌ No files found for validation type: $TYPE"
    exit 1
fi

echo "📋 Found $TOTAL_FILES files to validate"
echo ""

# Reference extraction functions
extract_file_references() {
    local file="$1"
    # Extract file path references
    grep -oE '\.[^[:space:]]*\.md|/[^[:space:]]*\.md|[^[:space:]]*\.md' "$file" 2>/dev/null | \
    grep '\.md$' | sort -u > "$TEMP_DIR/file_refs_$(basename "$file").txt" || touch "$TEMP_DIR/file_refs_$(basename "$file").txt"
}

extract_command_references() {
    local file="$1"
    # Extract command references (/topic:command)
    grep -oE '/[a-z][a-z0-9-]*:[a-z][a-z0-9-]*' "$file" 2>/dev/null | \
    sort -u > "$TEMP_DIR/command_refs_$(basename "$file").txt" || touch "$TEMP_DIR/command_refs_$(basename "$file").txt"
}

extract_agent_references() {
    local file="$1"
    # Extract agent references (@agent-topic:agent)
    grep -oE '@agent-[a-z][a-z0-9-]*:[a-z][a-z0-9-]*' "$file" 2>/dev/null | \
    sort -u > "$TEMP_DIR/agent_refs_$(basename "$file").txt" || touch "$TEMP_DIR/agent_refs_$(basename "$file").txt"
}

extract_url_references() {
    local file="$1"
    # Extract URL references
    grep -oE 'https?://[^[:space:]]+' "$file" 2>/dev/null | \
    sort -u > "$TEMP_DIR/url_refs_$(basename "$file").txt" || touch "$TEMP_DIR/url_refs_$(basename "$file").txt"
}

# Validation functions
validate_file_refs() {
    local source_file="$1"
    local ref_file="$TEMP_DIR/file_refs_$(basename "$source_file").txt"
    local issues=0
    
    if [ ! -s "$ref_file" ]; then
        return 0
    fi
    
    echo "📁 File references:"
    while IFS= read -r file_ref; do
        if [ -n "$file_ref" ]; then
            # Handle relative paths
            if [[ "$file_ref" == ./* ]]; then
                local abs_path="$(dirname "$source_file")/$file_ref"
            elif [[ "$file_ref" == /* ]]; then
                local abs_path="$file_ref"
            else
                # Try multiple search paths
                local found=false
                for search_path in "$(dirname "$source_file")" ".claude" "ubuntu-vm" "."; do
                    if [ -f "$search_path/$file_ref" ]; then
                        abs_path="$search_path/$file_ref"
                        found=true
                        break
                    fi
                done
                if [ "$found" = false ]; then
                    abs_path="$file_ref"
                fi
            fi
            
            if [ -f "$abs_path" ]; then
                echo "  ✅ $file_ref"
            else
                echo "  ❌ $file_ref (not found)"
                ((issues++))
                ((BROKEN_REFERENCES++))
            fi
            ((TOTAL_REFERENCES++))
        fi
    done < "$ref_file"
    
    return $issues
}

validate_command_refs() {
    local source_file="$1"
    local ref_file="$TEMP_DIR/command_refs_$(basename "$source_file").txt"
    local issues=0
    
    if [ ! -s "$ref_file" ]; then
        return 0
    fi
    
    echo "⚙️ Command references:"
    while IFS= read -r cmd_ref; do
        if [ -n "$cmd_ref" ]; then
            # Parse /topic:command
            local topic=$(echo "$cmd_ref" | cut -d: -f1 | sed 's|^/||')
            local command=$(echo "$cmd_ref" | cut -d: -f2)
            
            # Search in multiple locations
            local found=false
            for location in ".claude/commands/$topic" "ubuntu-vm/user/$topic/commands" "ubuntu-vm/project/$topic/commands"; do
                if [ -f "$location/$command.md" ]; then
                    echo "  ✅ $cmd_ref"
                    found=true
                    break
                fi
            done
            
            if [ "$found" = false ]; then
                echo "  ❌ $cmd_ref (command not found)"
                ((issues++))
                ((BROKEN_REFERENCES++))
            fi
            ((TOTAL_REFERENCES++))
        fi
    done < "$ref_file"
    
    return $issues
}

validate_agent_refs() {
    local source_file="$1"
    local ref_file="$TEMP_DIR/agent_refs_$(basename "$source_file").txt"
    local issues=0
    
    if [ ! -s "$ref_file" ]; then
        return 0
    fi
    
    echo "🤖 Agent references:"
    while IFS= read -r agent_ref; do
        if [ -n "$agent_ref" ]; then
            # Parse @agent-topic:agent
            local topic_agent=$(echo "$agent_ref" | sed 's/@agent-//')
            local topic=$(echo "$topic_agent" | cut -d: -f1)
            local agent=$(echo "$topic_agent" | cut -d: -f2)
            
            # Search in multiple locations
            local found=false
            for location in ".claude/agents" "ubuntu-vm/user/$topic/agents" "ubuntu-vm/project/$topic/agents"; do
                if [ -f "$location/$agent.md" ]; then
                    echo "  ✅ $agent_ref"
                    found=true
                    break
                fi
            done
            
            if [ "$found" = false ]; then
                echo "  ❌ $agent_ref (agent not found)"
                ((issues++))
                ((BROKEN_REFERENCES++))
            fi
            ((TOTAL_REFERENCES++))
        fi
    done < "$ref_file"
    
    return $issues
}

validate_url_refs() {
    local source_file="$1"
    local ref_file="$TEMP_DIR/url_refs_$(basename "$source_file").txt"
    local issues=0
    
    if [ ! -s "$ref_file" ]; then
        return 0
    fi
    
    echo "🌐 URL references:"
    while IFS= read -r url_ref; do
        if [ -n "$url_ref" ]; then
            # Skip localhost and example URLs
            if [[ "$url_ref" =~ ^https?://localhost ]] || [[ "$url_ref" =~ example\.(com|org|net) ]]; then
                echo "  ⏭️ $url_ref (skipped - localhost/example)"
            else
                # Check URL accessibility with timeout
                if curl -s --head --connect-timeout 5 --max-time 10 "$url_ref" > /dev/null 2>&1; then
                    echo "  ✅ $url_ref"
                else
                    echo "  ❌ $url_ref (inaccessible)"
                    ((issues++))
                    ((BROKEN_REFERENCES++))
                fi
            fi
            ((TOTAL_REFERENCES++))
        fi
    done < "$ref_file"
    
    return $issues
}

echo "🔬 Extracting and validating references..."
echo "─────────────────────────────────────────"

# Process each target file
for target_file in "${TARGET_FILES[@]}"; do
    if [ ! -f "$target_file" ]; then
        continue
    fi
    
    filename=$(basename "$target_file")
    echo "📄 Processing: $filename"
    echo "   Path: $target_file"
    
    # Extract all reference types
    extract_file_references "$target_file"
    extract_command_references "$target_file"
    extract_agent_references "$target_file"
    extract_url_references "$target_file"
    
    file_issues=0
    
    # Validate each reference type
    if ! validate_file_refs "$target_file"; then
        file_issues=$((file_issues + $?))
    fi
    
    if ! validate_command_refs "$target_file"; then
        file_issues=$((file_issues + $?))
    fi
    
    if ! validate_agent_refs "$target_file"; then
        file_issues=$((file_issues + $?))
    fi
    
    if ! validate_url_refs "$target_file"; then
        file_issues=$((file_issues + $?))
    fi
    
    if [ $file_issues -eq 0 ]; then
        echo "   ✅ All references validated"
    else
        echo "   ❌ $file_issues broken references found"
        VALIDATION_ISSUES+=("$filename: $file_issues broken references")
    fi
    
    echo ""
done

# Calculate validation metrics
if [ $TOTAL_REFERENCES -gt 0 ]; then
    ACCURACY_RATE=$(( (TOTAL_REFERENCES - BROKEN_REFERENCES) * 100 / TOTAL_REFERENCES ))
else
    ACCURACY_RATE=100
fi

FILES_WITH_ISSUES=${#VALIDATION_ISSUES[@]}

echo "═══════════════════════════════════════════════════════════════════"
echo "📊 Reference Validation Results"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 Validation Summary:"
echo "  - Scope: $TYPE"
echo "  - Focus: $DESCRIPTION"
echo "  - Files processed: $TOTAL_FILES"
echo ""
echo "📈 Reference Metrics:"
echo "  - Total references: $TOTAL_REFERENCES"
echo "  - Broken references: $BROKEN_REFERENCES"
echo "  - Accuracy rate: $ACCURACY_RATE%"
echo "  - Files with issues: $FILES_WITH_ISSUES"
echo ""

if [ $FILES_WITH_ISSUES -gt 0 ]; then
    echo "❌ Files with broken references:"
    for issue in "${VALIDATION_ISSUES[@]}"; do
        echo "  - $issue"
    done
    echo ""
fi

# Generate recommendations
echo "🔧 Recommendations:"
if [ $BROKEN_REFERENCES -eq 0 ]; then
    echo "  ✅ All references are valid - no action needed"
elif [ $ACCURACY_RATE -ge 95 ]; then
    echo "  - Fix $BROKEN_REFERENCES minor reference issues"
    echo "  - Overall reference quality is excellent"
elif [ $ACCURACY_RATE -ge 80 ]; then
    echo "  - Address $BROKEN_REFERENCES broken references"
    echo "  - Review file organization and reference patterns"
elif [ $ACCURACY_RATE -ge 60 ]; then
    echo "  - Priority: Fix $BROKEN_REFERENCES broken references"
    echo "  - Consider reference management improvements"
    echo "  - Review documentation organization structure"
else
    echo "  - CRITICAL: $BROKEN_REFERENCES broken references need immediate attention"
    echo "  - Consider comprehensive reference audit"
    echo "  - Review and standardize reference patterns"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════"
if [ $BROKEN_REFERENCES -eq 0 ]; then
    echo "✅ SUCCESS: All entity references validated successfully"
    exit 0
elif [ $ACCURACY_RATE -ge 90 ]; then
    echo "✅ GOOD: Reference validation passed with minor issues"
    exit 0
elif [ $ACCURACY_RATE -ge 70 ]; then
    echo "⚠️  WARNING: Reference validation completed with issues requiring attention"
    exit 1
else
    echo "❌ CRITICAL: Reference validation failed - immediate action required"
    exit 1
fi
echo "═══════════════════════════════════════════════════════════════════"
```

## Error Handling

**File Discovery Errors:**
- No files found for specified validation type
- File access permission issues
- Invalid file paths in `file` type validation

**Reference Extraction Errors:**
- Malformed reference patterns
- Issues with regex pattern matching
- File reading problems during extraction

**Validation Errors:**
- Network connectivity issues for URL validation
- File system access problems for file references
- Command/agent lookup failures

**Reporting Errors:**
- Temporary directory creation failures
- Issues calculating validation metrics
- Problems generating recommendations

## Quality Metrics

### Reference Accuracy Calculation

```bash
# Calculate reference accuracy percentage
ACCURACY_RATE=$(( (TOTAL_REFERENCES - BROKEN_REFERENCES) * 100 / TOTAL_REFERENCES ))

# Quality thresholds
# 100%: Perfect - all references valid
# 95-99%: Excellent - minor issues only
# 80-94%: Good - some issues need attention
# 60-79%: Fair - significant issues present
# <60%: Poor - critical issues requiring immediate action
```

### Validation Categories

**Critical References (Must Be Valid):**
- Command references used in workflows
- Agent references in delegation patterns
- Core documentation file references
- Essential URL endpoints

**Warning References (Should Be Valid):**
- Example documentation links
- Optional tool references
- External resource links
- Supplementary file references

## Version History

- v2.0.0 - Comprehensive reference validation framework
  - Added support for multiple reference types (files, commands, agents, URLs)
  - Implemented accuracy metrics and quality scoring
  - Added validation type filtering (all, docs, commands, agents, file)
  - Enhanced error reporting with detailed recommendations
- v1.0.0 - Initial fictional reference detection
  - Basic file reference validation
  - Simple broken link detection
  - Basic reporting functionality
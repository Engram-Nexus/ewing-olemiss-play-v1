---
description: "Validate knowledge structure and content integrity with optional automated fixes and detailed reporting"
arguments:
  - name: topic_path
    description: "Knowledge topic path to validate (topic or topic/subtopic format)"
    required: true
  - name: fix
    description: "Automatically fix discovered issues where possible (--fix flag)"
    required: false
  - name: verbose
    description: "Provide detailed validation reporting (--verbose flag)"
    required: false
  - name: _preview
    description: "# Args: `<topic/subtopic>` `[--fix]` `[--verbose]`. v1.0.0. Validate knowledge structure and content integrity with optional automated fixes and detailed reporting"
    required: false
version: "1.0.0"
category: "Knowledge Management"
icon: "🔍"
---

Input: $ARGUMENTS (format: topic/subtopic [--fix] [--verbose])

## Usage

```bash
/validate-knowledge <topic>
/validate-knowledge <topic/subtopic>
/validate-knowledge <topic/subtopic> --fix
/validate-knowledge <topic> --verbose
/validate-knowledge <topic/subtopic> --fix --verbose
```

## Arguments

- `<topic/subtopic>`: Knowledge topic path to validate
  - **Format**: `topic` validates entire topic structure
  - **Format**: `topic/subtopic` validates specific subtopic
  - **Format**: `topic/subtopic1/subtopic2` supports nested validation
  - **CRITICAL**: Path must exist in .knowledge directory
- `[--fix]`: Automatically fix discovered issues where possible
  - **Optional**: If omitted, validation is read-only
  - **Actions**: Creates missing README files, fixes formatting issues
  - **Safety**: Only applies safe, non-destructive fixes
- `[--verbose]`: Provide detailed validation reporting
  - **Optional**: If omitted, shows summary only
  - **Output**: Detailed structure analysis and recommendations

## Examples

```bash
# Basic topic validation
/validate-knowledge authentication

# Subtopic validation with detailed output
/validate-knowledge authentication/oauth --verbose

# Validate and fix issues automatically
/validate-knowledge security/compliance --fix

# Comprehensive validation with auto-fix and verbose output
/validate-knowledge database/migrations --fix --verbose

# Deep nested subtopic validation
/validate-knowledge api/rest/v2/endpoints --verbose
```

## What This Command Does

This command performs comprehensive validation of knowledge structures, ensuring integrity, consistency, and adherence to established patterns.

### 📋 Validation Process

1. **Parse arguments and determine scope** 🚨⚡ ARGUMENT PROCESSING ⚡🚨
   
   ```bash
   # Parse validation arguments
   TOPIC_PATH="$1"
   FIX_MODE=false
   VERBOSE_MODE=false
   
   # Process optional flags
   for arg in "$@"; do
       case $arg in
           --fix)
               FIX_MODE=true
               echo "🔧 Auto-fix mode enabled"
               ;;
           --verbose)
               VERBOSE_MODE=true
               echo "📝 Verbose reporting enabled"
               ;;
       esac
   done
   
   # Parse topic/subtopic structure
   IFS='/' read -ra PATH_ARRAY <<< "$TOPIC_PATH"
   TOPIC="${PATH_ARRAY[0]}"
   
   # Build subtopic path if exists
   SUBTOPIC_PATH=""
   if [ ${#PATH_ARRAY[@]} -gt 1 ]; then
       SUBTOPIC_PATH=$(IFS='/'; echo "${PATH_ARRAY[@]:1}")
   fi
   
   # Determine validation target
   KNOWLEDGE_BASE=".knowledge"
   FULL_PATH="$KNOWLEDGE_BASE/$TOPIC"
   
   if [[ -n "$SUBTOPIC_PATH" ]]; then
       FULL_PATH="$FULL_PATH/$SUBTOPIC_PATH"
   fi
   
   echo "🔍 Validating knowledge structure: $FULL_PATH"
   ```

2. **Validate directory structure** 🚨⚡ STRUCTURAL INTEGRITY CHECK ⚡🚨
   
   **🚀 COMPREHENSIVE STRUCTURE VALIDATION:**
   ```bash
   VALIDATION_ERRORS=()
   VALIDATION_WARNINGS=()
   VALIDATION_FIXES=()
   
   # Check if target path exists
   if [[ ! -d "$FULL_PATH" ]]; then
       VALIDATION_ERRORS+=("❌ Target path does not exist: $FULL_PATH")
       echo "Cannot validate non-existent knowledge structure"
       return 1
   fi
   
   echo "✅ Target directory exists: $FULL_PATH"
   
   # Validate directory structure
   echo "🔍 Analyzing directory structure..."
   
   # Check for README.md in target directory
   README_FILE="$FULL_PATH/README.md"
   if [[ ! -f "$README_FILE" ]]; then
       VALIDATION_ERRORS+=("❌ Missing README.md in: $FULL_PATH")
       if [[ "$FIX_MODE" == true ]]; then
           echo "🔧 Creating missing README.md..."
           create_missing_readme "$FULL_PATH"
           VALIDATION_FIXES+=("✅ Created README.md in: $FULL_PATH")
       fi
   else
       echo "✅ README.md exists: $README_FILE"
   fi
   
   # Validate all subdirectories have README files
   find "$FULL_PATH" -type d -not -path "$FULL_PATH" | while read -r subdir; do
       subdir_readme="$subdir/README.md"
       if [[ ! -f "$subdir_readme" ]]; then
           VALIDATION_ERRORS+=("❌ Missing README.md in subdirectory: $subdir")
           if [[ "$FIX_MODE" == true ]]; then
               create_missing_readme "$subdir"
               VALIDATION_FIXES+=("✅ Created README.md in: $subdir")
           fi
       else
           echo "✅ Subdirectory README exists: $subdir_readme"
       fi
   done
   ```

3. **Validate README content structure** 🚨⚡ CONTENT VALIDATION ⚡🚨
   
   **🚀 README STRUCTURE AND CONTENT VALIDATION:**
   ```bash
   echo "📋 Validating README content structure..."
   
   validate_readme_structure() {
       local readme_file="$1"
       local dir_path="$2"
       
       if [[ ! -f "$readme_file" ]]; then
           return 1
       fi
       
       local content=$(cat "$readme_file")
       local dir_name=$(basename "$dir_path")
       
       # Check for required sections
       if ! grep -q "^# .*Knowledge Matrix" "$readme_file"; then
           VALIDATION_WARNINGS+=("⚠️  README missing standard title format: $readme_file")
           if [[ "$VERBOSE_MODE" == true ]]; then
               echo "   Expected: # $dir_name Knowledge Matrix"
           fi
       fi
       
       if ! grep -q "## Subtopics" "$readme_file"; then
           VALIDATION_WARNINGS+=("⚠️  README missing Subtopics section: $readme_file")
       fi
       
       if ! grep -q "## Blocks" "$readme_file"; then
           VALIDATION_WARNINGS+=("⚠️  README missing Blocks section: $readme_file")
       fi
       
       if ! grep -q "## Integrated Knowledge" "$readme_file"; then
           VALIDATION_WARNINGS+=("⚠️  README missing Integrated Knowledge section: $readme_file")
       fi
       
       # Validate links to actual files
       echo "🔗 Validating internal links..."
       
       # Check subtopic links
       grep -E "\\[📁.*\\]\\(.*\\)" "$readme_file" | while read -r line; do
           # Extract link target
           local link_target=$(echo "$line" | sed -n 's/.*](\\(.*\\))/\\1/p')
           if [[ -n "$link_target" && ! -d "$dir_path/$link_target" ]]; then
               VALIDATION_ERRORS+=("❌ Broken subtopic link in $readme_file: $link_target")
           fi
       done
       
       # Check block links  
       grep -E "\\[📄.*\\]\\(.*\\.md\\)" "$readme_file" | while read -r line; do
           # Extract link target
           local link_target=$(echo "$line" | sed -n 's/.*](\\(.*\\))/\\1/p')
           if [[ -n "$link_target" && ! -f "$dir_path/$link_target" ]]; then
               VALIDATION_ERRORS+=("❌ Broken block link in $readme_file: $link_target")
           fi
       done
       
       echo "✅ README validation completed: $readme_file"
   }
   
   # Validate main README
   validate_readme_structure "$README_FILE" "$FULL_PATH"
   
   # Validate all subdirectory READMEs
   find "$FULL_PATH" -name "README.md" | while read -r readme; do
       readme_dir=$(dirname "$readme")
       validate_readme_structure "$readme" "$readme_dir"
   done
   ```

4. **Validate block files and consistency** 🚨⚡ BLOCK VALIDATION ⚡🚨
   
   **🚀 BLOCK FILE INTEGRITY VALIDATION:**
   ```bash
   echo "📄 Validating knowledge block files..."
   
   # Find all .md files that aren't README.md
   find "$FULL_PATH" -name "*.md" -not -name "README.md" | while read -r block_file; do
       echo "🔍 Validating block: $block_file"
       
       # Check if file has content
       if [[ ! -s "$block_file" ]]; then
           VALIDATION_WARNINGS+=("⚠️  Empty block file: $block_file")
       fi
       
       # Check if block is referenced in parent README
       block_name=$(basename "$block_file" .md)
       parent_dir=$(dirname "$block_file")
       parent_readme="$parent_dir/README.md"
       
       if [[ -f "$parent_readme" ]]; then
           if ! grep -q "$block_name" "$parent_readme"; then
               VALIDATION_WARNINGS+=("⚠️  Block not referenced in README: $block_file")
               if [[ "$VERBOSE_MODE" == true ]]; then
                   echo "   Block $block_name should be referenced in $parent_readme"
               fi
           fi
       fi
       
       # Validate basic markdown structure
       if grep -q "^#" "$block_file"; then
           echo "✅ Block has headers: $block_file"
       else
           VALIDATION_WARNINGS+=("⚠️  Block lacks header structure: $block_file")
       fi
   done
   ```

5. **Generate validation report** 🚨⚡ COMPREHENSIVE REPORTING ⚡🚨
   
   **🚀 DETAILED VALIDATION SUMMARY:**
   ```bash
   echo ""
   echo "📊 VALIDATION REPORT"
   echo "==================="
   echo "📁 Target: $FULL_PATH"
   echo "🔧 Fix Mode: $FIX_MODE"
   echo "📝 Verbose: $VERBOSE_MODE"
   echo ""
   
   # Count summary
   ERROR_COUNT=${#VALIDATION_ERRORS[@]}
   WARNING_COUNT=${#VALIDATION_WARNINGS[@]}
   FIX_COUNT=${#VALIDATION_FIXES[@]}
   
   echo "📈 SUMMARY"
   echo "----------"
   echo "❌ Errors: $ERROR_COUNT"
   echo "⚠️  Warnings: $WARNING_COUNT"
   echo "🔧 Fixes Applied: $FIX_COUNT"
   echo ""
   
   # Display errors
   if [[ $ERROR_COUNT -gt 0 ]]; then
       echo "❌ ERRORS FOUND"
       echo "---------------"
       for error in "${VALIDATION_ERRORS[@]}"; do
           echo "$error"
       done
       echo ""
   fi
   
   # Display warnings
   if [[ $WARNING_COUNT -gt 0 ]]; then
       echo "⚠️  WARNINGS FOUND"
       echo "------------------"
       for warning in "${VALIDATION_WARNINGS[@]}"; do
           echo "$warning"
       done
       echo ""
   fi
   
   # Display fixes applied
   if [[ $FIX_COUNT -gt 0 ]]; then
       echo "🔧 FIXES APPLIED"
       echo "----------------"
       for fix in "${VALIDATION_FIXES[@]}"; do
           echo "$fix"
       done
       echo ""
   fi
   
   # Validation status
   if [[ $ERROR_COUNT -eq 0 ]]; then
       echo "✅ VALIDATION PASSED"
       echo "Knowledge structure is valid and consistent"
   else
       echo "❌ VALIDATION FAILED"
       echo "Knowledge structure has $ERROR_COUNT error(s) that need attention"
       return 1
   fi
   ```

## Supporting Functions

```bash
create_missing_readme() {
    local target_dir="$1"
    local dir_name=$(basename "$target_dir")
    local readme_file="$target_dir/README.md"
    
    echo "📝 Generating README for: $dir_name"
    
    # Create basic README structure
    cat > "$readme_file" << EOF
# $dir_name Knowledge Matrix

This matrix integrates knowledge from all blocks and subtopics in this $(basename $(dirname "$target_dir")) > $dir_name path.

## Subtopics

*No subtopics in this section.*

## Blocks

*No blocks in this section.*

## Structure

### Subtopics
*None currently.*

### Blocks  
*None currently.*

## Integrated Knowledge

*No content blocks available.*

---

*README generated by validate-knowledge command. Please update with actual content.*
EOF
    
    echo "✅ Created basic README: $readme_file"
}
```

## Common RUN Commands During Execution

### Structure Analysis
- RUN `tree $FULL_PATH` - Display complete directory structure
- RUN `find $FULL_PATH -name "*.md"` - List all markdown files
- RUN `find $FULL_PATH -name "README.md"` - List all matrix files
- RUN `find $FULL_PATH -type d` - List all directories

### Content Validation
- RUN `grep -r "^#" $FULL_PATH` - Show all headers across files
- RUN `find $FULL_PATH -empty` - Find empty files or directories
- RUN `wc -l $FULL_PATH/*/*.md` - Count lines in knowledge blocks

### Link Validation
- RUN `grep -r "](.*)" $FULL_PATH/README.md` - Extract all links
- RUN `find $FULL_PATH -name "*.md" -exec grep -l "http" {} \;` - Find files with external links

## Requirements

- Read access to .knowledge directory
- Find, grep, and tree utilities
- Bash shell for advanced pattern matching
- Write access when using --fix mode
- **CRITICAL**: Knowledge directory structure must exist

## Error Handling

- **Target path not found**: Fails with clear error message
- **Permission denied**: Provides guidance for access issues
- **Corrupted README files**: Reports specific structural problems
- **Broken links**: Identifies and reports all broken references
- **Empty or malformed files**: Categorizes as warnings vs errors
- **Fix mode failures**: Reports which automatic fixes succeeded/failed

## Notes

- **Non-destructive by default**: Validation is read-only unless --fix flag is used
- **Comprehensive reporting**: Distinguishes between errors (must fix) and warnings (should fix)
- **Automated fixes**: Only applies safe, reversible changes when --fix is enabled
- **Link validation**: Checks internal references between knowledge components
- **Structure enforcement**: Validates adherence to established matrix patterns
- **Verbose mode**: Provides detailed analysis and recommendations for improvements
- **Recursive validation**: Checks all subdirectories and nested structures
- **Content analysis**: Validates both structure and basic content quality

## Version History

- v1.0.0 - Initial release: Comprehensive knowledge validation system
  - Structural integrity validation for topics and subtopics
  - README content structure and format validation
  - Block file consistency and reference validation
  - Automated fix capabilities for common issues
  - Comprehensive reporting with errors, warnings, and fixes
  - Verbose mode for detailed analysis and recommendations
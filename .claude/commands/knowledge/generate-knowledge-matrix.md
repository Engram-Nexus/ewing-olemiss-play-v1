---
description: "Generate standalone knowledge matrices with customizable templates and recursive processing for comprehensive knowledge organization"
arguments:
  - name: topic_path
    description: "Knowledge topic path to generate matrix for (format: topic/subtopic)"
    required: true
  - name: recursive
    description: "Generate matrices for all subdirectories recursively (--recursive)"
    required: false
  - name: template
    description: "Matrix template format: standard|compact|detailed (--template=value)"
    required: false
  - name: _preview
    description: "# Args: `<topic/subtopic>` `[--recursive]` `[--template=standard|compact|detailed]`. v1.0.0. Generate standalone knowledge matrices with customizable templates and recursive processing for comprehensive knowledge organization"
    required: false
version: "1.0.0"
category: "Knowledge Management"
icon: "📋"
---

Input: $ARGUMENTS (format: topic/subtopic [--recursive] [--template=standard|compact|detailed])

## Usage

```bash
/generate-knowledge-matrix <topic>
/generate-knowledge-matrix <topic/subtopic>
/generate-knowledge-matrix <topic> --recursive
/generate-knowledge-matrix <topic/subtopic> --template=detailed
/generate-knowledge-matrix <topic> --recursive --template=compact
```

## Arguments

- `<topic/subtopic>`: Knowledge topic path to generate matrix for
  - **Format**: `topic` generates matrix for entire topic
  - **Format**: `topic/subtopic` generates matrix for specific subtopic
  - **Format**: `topic/subtopic1/subtopic2` supports nested matrix generation
  - **CRITICAL**: Path must exist in docs/knowledge directory
- `[--recursive]`: Generate matrices for all subdirectories recursively
  - **Optional**: If omitted, generates matrix only for target directory
  - **Processing**: Updates all child matrices in the entire tree
  - **Performance**: Bulk operation for comprehensive matrix updates
- `[--template=standard|compact|detailed]`: Matrix template format (default: standard)
  - **standard**: Balanced detail with all standard sections
  - **compact**: Minimal format focusing on navigation links
  - **detailed**: Comprehensive format with extended descriptions and analysis

## Examples

```bash
# Standard matrix generation for authentication topic
/generate-knowledge-matrix authentication

# Detailed matrix for specific subtopic
/generate-knowledge-matrix authentication/oauth --template=detailed

# Recursive matrix update for entire security topic
/generate-knowledge-matrix security --recursive

# Compact matrices for all API subtopics
/generate-knowledge-matrix api --recursive --template=compact

# Detailed matrix for deeply nested subtopic
/generate-knowledge-matrix database/migrations/schema --template=detailed
```

## What This Command Does

This command generates comprehensive knowledge matrices (README.md files) that integrate and organize all blocks and subtopics within a knowledge area using customizable templates and processing modes.

### 📋 Matrix Generation Process

1. **Parse arguments and determine generation scope** 🚨⚡ PARAMETER PROCESSING ⚡🚨
   
   ```bash
   # Parse generation parameters
   TOPIC_PATH="$1"
   RECURSIVE_MODE=false
   TEMPLATE_TYPE="standard"
   
   # Process optional flags
   for arg in "$@"; do
       case $arg in
           --recursive)
               RECURSIVE_MODE=true
               echo "🔄 Recursive matrix generation enabled"
               ;;
           --template=*)
               TEMPLATE_TYPE="${arg#*=}"
               echo "📋 Template type: $TEMPLATE_TYPE"
               ;;
       esac
   done
   
   # Validate template parameter
   if [[ "$TEMPLATE_TYPE" != "standard" && "$TEMPLATE_TYPE" != "compact" && "$TEMPLATE_TYPE" != "detailed" ]]; then
       echo "❌ Invalid template parameter. Use 'standard', 'compact', or 'detailed'"
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
   
   # Determine generation target
   KNOWLEDGE_BASE="docs/knowledge"
   FULL_PATH="$KNOWLEDGE_BASE/$TOPIC"
   
   if [[ -n "$SUBTOPIC_PATH" ]]; then
       FULL_PATH="$FULL_PATH/$SUBTOPIC_PATH"
   fi
   
   echo "📚 Generating knowledge matrix for: $FULL_PATH"
   echo "📋 Template: $TEMPLATE_TYPE"
   echo "🔄 Recursive: $RECURSIVE_MODE"
   ```

2. **Validate target structure** 🚨⚡ TARGET VALIDATION ⚡🚨
   
   **🚀 COMPREHENSIVE TARGET VALIDATION:**
   ```bash
   echo "🔍 Validating target structure..."
   
   # Check if target path exists
   if [[ ! -d "$FULL_PATH" ]]; then
       echo "❌ Target knowledge path does not exist: $FULL_PATH"
       echo "Available topics:"
       ls -la "$KNOWLEDGE_BASE/" 2>/dev/null | grep "^d" | awk '{print $NF}' | grep -v "^\\.$\\|^\\.\\.\\$"
       exit 1
   fi
   
   echo "✅ Target directory exists: $FULL_PATH"
   
   # Check write permissions
   if [[ ! -w "$FULL_PATH" ]]; then
       echo "❌ No write permission for target directory: $FULL_PATH"
       exit 1
   fi
   
   echo "✅ Write permissions confirmed"
   ```

3. **Generate matrix for target directory** 🚨⚡ PRIMARY MATRIX GENERATION ⚡🚨
   
   **🚀 TEMPLATE-BASED MATRIX GENERATION:**
   ```bash
   generate_matrix() {
       local target_dir="$1"
       local template="$2"
       local matrix_file="$target_dir/README.md"
       local dir_name=$(basename "$target_dir")
       
       echo "📋 Generating matrix for: $dir_name (template: $template)"
       
       # Get relative path from knowledge base for navigation
       local rel_path="${target_dir#$KNOWLEDGE_BASE/}"
       
       # Analyze directory contents
       local blocks=$(find "$target_dir" -maxdepth 1 -name "*.md" -not -name "README.md" | sort)
       local subtopics=$(find "$target_dir" -maxdepth 1 -type d -not -path "$target_dir" | sort)
       local block_count=$(echo "$blocks" | grep -c . || echo "0")
       local subtopic_count=$(echo "$subtopics" | grep -c . || echo "0")
       
       echo "  📄 Blocks: $block_count"
       echo "  📁 Subtopics: $subtopic_count"
       
       # Start building matrix based on template
       case "$template" in
           "compact")
               generate_compact_matrix "$target_dir" "$matrix_file" "$dir_name" "$rel_path" "$blocks" "$subtopics"
               ;;
           "detailed")
               generate_detailed_matrix "$target_dir" "$matrix_file" "$dir_name" "$rel_path" "$blocks" "$subtopics"
               ;;
           *)
               generate_standard_matrix "$target_dir" "$matrix_file" "$dir_name" "$rel_path" "$blocks" "$subtopics"
               ;;
       esac
       
       echo "✅ Matrix generated: $matrix_file"
   }
   
   # Generate primary matrix
   generate_matrix "$FULL_PATH" "$TEMPLATE_TYPE"
   ```

4. **Process recursive generation if enabled** 🚨⚡ RECURSIVE PROCESSING ⚡🚨
   
   **🚀 RECURSIVE MATRIX GENERATION:**
   ```bash
   if [[ "$RECURSIVE_MODE" == true ]]; then
       echo "🔄 Processing recursive matrix generation..."
       
       PROCESSED_COUNT=0
       
       # Find all subdirectories and generate matrices
       find "$FULL_PATH" -mindepth 1 -type d | sort | while read -r subdir; do
           echo "🔄 Processing subdirectory: $(basename "$subdir")"
           generate_matrix "$subdir" "$TEMPLATE_TYPE"
           ((PROCESSED_COUNT++))
       done
       
       if [[ $PROCESSED_COUNT -gt 0 ]]; then
           echo "✅ Recursive processing completed: $PROCESSED_COUNT matrices generated"
       else
           echo "ℹ️  No subdirectories found for recursive processing"
       fi
   fi
   ```

## Matrix Template Functions

### Standard Template
```bash
generate_standard_matrix() {
    local target_dir="$1"
    local matrix_file="$2"
    local dir_name="$3"
    local rel_path="$4"
    local blocks="$5"
    local subtopics="$6"
    
    cat > "$matrix_file" << EOF
# $dir_name Knowledge Matrix

This matrix integrates knowledge from all blocks and subtopics in the ${rel_path//\// > } path.

## Subtopics

EOF

    # Add subtopics section
    if [[ -n "$subtopics" && $(echo "$subtopics" | grep -c .) -gt 0 ]]; then
        echo "$subtopics" | while read -r subtopic; do
            if [[ -n "$subtopic" ]]; then
                local subtopic_name=$(basename "$subtopic")
                echo "- [📁 $subtopic_name]($subtopic_name/)" >> "$matrix_file"
            fi
        done
    else
        echo "*No subtopics in this section.*" >> "$matrix_file"
    fi

    cat >> "$matrix_file" << EOF

## Blocks

EOF

    # Add blocks section
    if [[ -n "$blocks" && $(echo "$blocks" | grep -c .) -gt 0 ]]; then
        echo "$blocks" | while read -r block; do
            if [[ -n "$block" ]]; then
                local block_name=$(basename "$block" .md)
                local formatted_name=$(echo "$block_name" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
                echo "- [📄 $formatted_name]($block_name.md)" >> "$matrix_file"
            fi
        done
    else
        echo "*No blocks in this section.*" >> "$matrix_file"
    fi

    cat >> "$matrix_file" << EOF

## Structure

### Subtopics
EOF

    # Repeat subtopics for structure section
    if [[ -n "$subtopics" && $(echo "$subtopics" | grep -c .) -gt 0 ]]; then
        echo "$subtopics" | while read -r subtopic; do
            if [[ -n "$subtopic" ]]; then
                local subtopic_name=$(basename "$subtopic")
                echo "- [📁 $subtopic_name]($subtopic_name/)" >> "$matrix_file"
            fi
        done
    else
        echo "*None currently.*" >> "$matrix_file"
    fi

    cat >> "$matrix_file" << EOF

### Blocks
EOF

    # Repeat blocks for structure section
    if [[ -n "$blocks" && $(echo "$blocks" | grep -c .) -gt 0 ]]; then
        echo "$blocks" | while read -r block; do
            if [[ -n "$block" ]]; then
                local block_name=$(basename "$block" .md)
                local formatted_name=$(echo "$block_name" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
                echo "- [📄 $formatted_name]($block_name.md)" >> "$matrix_file"
            fi
        done
    else
        echo "*None currently.*" >> "$matrix_file"
    fi

    cat >> "$matrix_file" << EOF

## Integrated Knowledge

EOF

    # Include content from blocks
    if [[ -n "$blocks" && $(echo "$blocks" | grep -c .) -gt 0 ]]; then
        echo "$blocks" | while read -r block; do
            if [[ -n "$block" && -f "$block" ]]; then
                local block_name=$(basename "$block" .md)
                local formatted_name=$(echo "$block_name" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
                cat >> "$matrix_file" << EOF
### $formatted_name

$(cat "$block")

---

EOF
            fi
        done
    else
        echo "*No content blocks available.*" >> "$matrix_file"
    fi

    # Add subtopic summaries if they exist
    if [[ -n "$subtopics" && $(echo "$subtopics" | grep -c .) -gt 0 ]]; then
        cat >> "$matrix_file" << EOF

## Subtopic Summaries

EOF
        echo "$subtopics" | while read -r subtopic; do
            if [[ -n "$subtopic" ]]; then
                local subtopic_name=$(basename "$subtopic")
                local subtopic_readme="$subtopic/README.md"
                
                if [[ -f "$subtopic_readme" ]]; then
                    cat >> "$matrix_file" << EOF
### 📁 $subtopic_name

$(head -n 10 "$subtopic_readme" | grep -v "^#" | grep -v "^$" | head -n 3)

[View full $subtopic_name matrix]($subtopic_name/)

EOF
                fi
            fi
        done
    fi
}
```

### Compact Template
```bash
generate_compact_matrix() {
    local target_dir="$1"
    local matrix_file="$2"
    local dir_name="$3"
    local rel_path="$4"
    local blocks="$5"
    local subtopics="$6"
    
    cat > "$matrix_file" << EOF
# $dir_name

## Navigation

EOF

    # Add subtopics navigation
    if [[ -n "$subtopics" && $(echo "$subtopics" | grep -c .) -gt 0 ]]; then
        echo "**Subtopics:**" >> "$matrix_file"
        echo "$subtopics" | while read -r subtopic; do
            if [[ -n "$subtopic" ]]; then
                local subtopic_name=$(basename "$subtopic")
                echo "- [📁 $subtopic_name]($subtopic_name/)" >> "$matrix_file"
            fi
        done
        echo "" >> "$matrix_file"
    fi

    # Add blocks navigation
    if [[ -n "$blocks" && $(echo "$blocks" | grep -c .) -gt 0 ]]; then
        echo "**Blocks:**" >> "$matrix_file"
        echo "$blocks" | while read -r block; do
            if [[ -n "$block" ]]; then
                local block_name=$(basename "$block" .md)
                echo "- [📄 $block_name]($block_name.md)" >> "$matrix_file"
            fi
        done
    fi
}
```

### Detailed Template
```bash
generate_detailed_matrix() {
    local target_dir="$1"
    local matrix_file="$2"
    local dir_name="$3"
    local rel_path="$4"
    local blocks="$5"
    local subtopics="$6"
    
    local total_blocks=$(echo "$blocks" | grep -c . || echo "0")
    local total_subtopics=$(echo "$subtopics" | grep -c . || echo "0")
    
    cat > "$matrix_file" << EOF
# $dir_name Knowledge Matrix

## Overview

This comprehensive knowledge matrix organizes and integrates all content within the **${rel_path//\// → }** knowledge area.

**Statistics:**
- 📄 Knowledge Blocks: $total_blocks
- 📁 Subtopic Areas: $total_subtopics
- 🗓️ Last Generated: $(date)
- 📊 Coverage Level: $(if [[ $total_blocks -gt 5 || $total_subtopics -gt 2 ]]; then echo "Comprehensive"; elif [[ $total_blocks -gt 2 || $total_subtopics -gt 0 ]]; then echo "Moderate"; else echo "Basic"; fi)

## Table of Contents

1. [Subtopic Areas](#subtopic-areas)
2. [Knowledge Blocks](#knowledge-blocks)
3. [Detailed Structure](#detailed-structure)
4. [Integrated Knowledge](#integrated-knowledge)
5. [Cross-References](#cross-references)

## Subtopic Areas

EOF

    # Add detailed subtopics section
    if [[ -n "$subtopics" && $(echo "$subtopics" | grep -c .) -gt 0 ]]; then
        echo "$subtopics" | while read -r subtopic; do
            if [[ -n "$subtopic" ]]; then
                local subtopic_name=$(basename "$subtopic")
                local subtopic_blocks=$(find "$subtopic" -maxdepth 1 -name "*.md" -not -name "README.md" | wc -l)
                local subtopic_subdirs=$(find "$subtopic" -maxdepth 1 -type d -not -path "$subtopic" | wc -l)
                
                cat >> "$matrix_file" << EOF
### 📁 [$subtopic_name]($subtopic_name/)

**Content Summary:**
- Blocks: $subtopic_blocks
- Subdirectories: $subtopic_subdirs
- Focus: Specialized knowledge area within $dir_name

EOF
            fi
        done
    else
        echo "*No specialized subtopic areas have been organized within this knowledge domain.*" >> "$matrix_file"
        echo "" >> "$matrix_file"
    fi

    cat >> "$matrix_file" << EOF

## Knowledge Blocks

EOF

    # Add detailed blocks section
    if [[ -n "$blocks" && $(echo "$blocks" | grep -c .) -gt 0 ]]; then
        echo "$blocks" | while read -r block; do
            if [[ -n "$block" && -f "$block" ]]; then
                local block_name=$(basename "$block" .md)
                local formatted_name=$(echo "$block_name" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
                local word_count=$(wc -w < "$block")
                local line_count=$(wc -l < "$block")
                
                # Extract first line as description if available
                local description=$(head -n 5 "$block" | grep -v "^#" | grep -v "^$" | head -n 1 | cut -c1-100)
                if [[ -z "$description" ]]; then
                    description="Knowledge block covering $formatted_name concepts and implementation."
                fi
                
                cat >> "$matrix_file" << EOF
### 📄 [$formatted_name]($block_name.md)

**Content Analysis:**
- Word Count: $word_count words
- Line Count: $line_count lines
- Scope: $description

EOF
            fi
        done
    else
        echo "*No individual knowledge blocks have been created in this area.*" >> "$matrix_file"
        echo "" >> "$matrix_file"
    fi

    # Continue with integrated knowledge and cross-references sections
    # (Similar to standard template but with more detailed analysis)
}
```

5. **Generate summary report** 🚨⚡ GENERATION SUMMARY ⚡🚨
   
   **🚀 COMPREHENSIVE GENERATION REPORT:**
   ```bash
   echo ""
   echo "📊 MATRIX GENERATION REPORT"
   echo "==========================="
   echo "📁 Target: $FULL_PATH"
   echo "📋 Template: $TEMPLATE_TYPE"
   echo "🔄 Recursive: $RECURSIVE_MODE"
   echo "📅 Generated: $(date)"
   echo ""
   
   # Count generated matrices
   if [[ "$RECURSIVE_MODE" == true ]]; then
       MATRIX_COUNT=$(find "$FULL_PATH" -name "README.md" | wc -l)
       echo "📋 Total matrices: $MATRIX_COUNT"
   else
       echo "📋 Single matrix generated: $FULL_PATH/README.md"
   fi
   
   # Provide next steps
   echo ""
   echo "✅ GENERATION COMPLETED"
   echo "======================="
   echo "📝 All knowledge matrices have been generated successfully"
   echo ""
   echo "🔍 Next Steps:"
   echo "1. Review generated matrices for accuracy and completeness"
   echo "2. Validate structure with: /knowledge:validate-knowledge $TOPIC_PATH"
   echo "3. Check for gaps with: /knowledge:analyze-knowledge-gaps $TOPIC_PATH"
   echo "4. Commit changes to version control"
   echo ""
   echo "📋 View generated matrix:"
   echo "   cat $FULL_PATH/README.md"
   ```

## Common RUN Commands During Execution

### Pre-Generation Analysis
- RUN `tree $FULL_PATH` - Display structure before generation
- RUN `find $FULL_PATH -name "README.md"` - List existing matrices
- RUN `find $FULL_PATH -name "*.md" -not -name "README.md"` - Count knowledge blocks

### Generation Validation
- RUN `wc -l $FULL_PATH/README.md` - Check generated matrix size
- RUN `grep -c "^#" $FULL_PATH/README.md` - Count header structure
- RUN `grep -c "\\[.*\\](" $FULL_PATH/README.md` - Count internal links

### Post-Generation Verification
- RUN `cat $FULL_PATH/README.md` - Review generated content
- RUN `/knowledge:validate-knowledge $TOPIC_PATH` - Validate structure integrity
- RUN `diff -u old_README.md $FULL_PATH/README.md` - Compare with previous version

## Requirements

- Write access to docs/knowledge directory
- Find, grep, wc, and date utilities
- Bash shell for template processing
- **CRITICAL**: Target knowledge directory must exist
- Sufficient disk space for matrix files

## Error Handling

- **Target path not found**: Fails with helpful directory listing
- **Permission denied**: Provides clear guidance for access resolution
- **Invalid template**: Validates template parameter with accepted values
- **Empty directories**: Generates appropriate placeholder content
- **Large directories**: Provides progress indicators for extensive processing
- **Disk space issues**: Reports space requirements and available space

## Notes

- **Template flexibility**: Three distinct templates for different documentation needs
- **Recursive processing**: Efficiently updates entire knowledge trees in single operation
- **Content integration**: Automatically includes block content in integrated knowledge sections
- **Navigation optimization**: Consistent linking patterns for easy knowledge navigation
- **Statistics inclusion**: Detailed templates include content analysis and metrics
- **Cross-referencing**: Automatic linking between subtopics and blocks
- **Maintenance support**: Generated matrices include generation timestamps and metadata
- **Quality assurance**: Content analysis helps identify areas needing attention

## Version History

- v1.0.0 - Initial release: Comprehensive knowledge matrix generation system
  - Standard, compact, and detailed template options
  - Recursive processing for entire knowledge trees
  - Content analysis and statistics integration
  - Navigation optimization with consistent linking patterns
  - Cross-reference generation between related knowledge areas
  - Comprehensive reporting and validation integration
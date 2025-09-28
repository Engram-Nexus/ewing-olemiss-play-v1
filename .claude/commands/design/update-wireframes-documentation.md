# Args: `<base-branch>` `[target-documentation]` `[enhancement-mode]`. v1.0.0. Update screenflows-wireframes.md documentation with embedded image examples following patterns from screenflows-storyboarding.md, enforcing embedded image validation

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/update-wireframes-documentation` in bash.

**✨ ENHANCED FUNCTIONALITY**: This command enhances the screenflows-wireframes.md documentation to use embedded image examples like those in screenflows-storyboarding.md:
- **Embedded Image Examples**: Adds visual examples using existing SVG files in examples/ directory
- **Image Validation Enforcement**: Uses the same validation system as update-screenflows command to ensure embedded images only
- **GitHub-Compatible Rendering**: Ensures all images render properly in GitHub markdown
- **Pattern Consistency**: Follows the same embedded image patterns established in screenflows-storyboarding.md
- **🔒 External URL Prevention**: Validates and prevents hyperlinked images (external URLs) in favor of relative paths

**This command specifically targets the screenflows-wireframes.md documentation enhancement requirements.**

## Summary

Updates the screenflows-wireframes.md documentation to include embedded image examples following the established patterns from screenflows-storyboarding.md. The command validates that all image references use embedded (relative path) patterns rather than external URLs, ensuring GitHub compatibility and consistent visual documentation. This addresses the core validation system requirement in v2.2.0 to enforce embedded images in all screenflow markdown files.

## Usage

```bash
# Update wireframes documentation with embedded examples (default target)
/design:update-wireframes-documentation <base-branch>

# Target specific documentation file
/design:update-wireframes-documentation <base-branch> screenflows-wireframes.md

# Enhanced mode with additional validation
/design:update-wireframes-documentation <base-branch> screenflows-wireframes.md enhanced
```

## Arguments

- `<base-branch>`: The branch to base the feature branch on (REQUIRED)
  - Examples: `main`, `dev`, `develop`, `release/v2.0`
  - Used for proper git workflow integration

- `[target-documentation]`: Target documentation file to enhance (OPTIONAL)
  - Default: `screenflows-wireframes.md`
  - Alternative: `screenflows-storyboarding.md` (for consistency checks)
  - Full path: `ubuntu-vm/project/design/docs/{target-documentation}`

- `[enhancement-mode]`: Level of enhancement to apply (OPTIONAL)
  - Default: `standard` - Add embedded image examples and validate
  - `enhanced` - Include additional validation and comprehensive image auditing
  - `validate-only` - Only run validation without making changes

## Examples

### Standard Usage

```bash
# Update wireframes documentation with embedded examples
/design:update-wireframes-documentation main

# Update wireframes documentation from develop branch
/design:update-wireframes-documentation develop

# Enhanced validation mode
/design:update-wireframes-documentation main screenflows-wireframes.md enhanced
```

### Validation Only

```bash
# Validate existing documentation without changes
/design:update-wireframes-documentation main screenflows-wireframes.md validate-only
```

## What This Command Does

This command enhances the screenflows-wireframes.md documentation to align with the embedded image patterns established in screenflows-storyboarding.md and enforces the image validation requirements from the v2.2.0 update-screenflows command.

### Core Operations

1. **Documentation Analysis**: Reviews current screenflows-wireframes.md structure and image references
2. **Embedded Image Integration**: Adds embedded image examples using existing SVG files from examples/
3. **Pattern Alignment**: Ensures consistency with screenflows-storyboarding.md embedded image patterns
4. **Image Validation**: Applies the same validation system used in update-screenflows command
5. **GitHub Compatibility**: Ensures all images render properly in GitHub markdown
6. **Documentation Enhancement**: Improves visual examples and reference patterns

### Enhancement Process

1. **Pre-Analysis**: Review existing documentation structure and identify enhancement opportunities
2. **Image Reference Audit**: Scan for external URLs and hyperlinked images that need conversion
3. **Embedded Example Addition**: Add embedded image references using relative paths to examples/
4. **Validation Enforcement**: Apply image validation to ensure compliance with v2.2.0 requirements
5. **Pattern Consistency**: Verify alignment with screenflows-storyboarding.md patterns
6. **Documentation Update**: Update content with enhanced embedded image examples

### Validation System Integration

Uses the same image validation functions from update-screenflows command:

```bash
# Image validation function to enforce embedded images
validate_markdown_images() {
    local file_path="$1"
    echo "🔒 Validating image references in $file_path..."
    
    # Check for hyperlinked images (external URLs)
    local hyperlinked_images
    hyperlinked_images=$(grep -n '!\[.*\](http[s]*://' "$file_path" 2>/dev/null || true)
    
    if [[ -n "$hyperlinked_images" ]]; then
        echo "❌ ERROR: Hyperlinked images found in $file_path"
        echo "   The following images must be embedded (use relative paths) instead of hyperlinked:"
        echo "$hyperlinked_images"
        echo ""
        echo "🔧 SOLUTION: Replace hyperlinked images with embedded images:"
        echo "   ❌ Wrong: ![Example](https://example.com/image.png)"
        echo "   ✅ Correct: ![Example](./examples/image.png)"
        echo "   ✅ Correct: ![Example](../wireframes/wireframe.svg)"
        echo ""
        return 1
    fi
    
    return 0
}
```

### File Structure Operations

```
ubuntu-vm/project/design/docs/
├── screenflows-wireframes.md        # TARGET FILE (enhanced with embedded images)
├── screenflows-storyboarding.md     # REFERENCE PATTERN (successful embedded images)
└── examples/                        # SOURCE IMAGES
    ├── wireframe-inline.svg          # Available for embedded reference
    ├── wireframe-dashboard.html      # Additional examples
    ├── wireframe-drawer-open.html    # Additional examples
    ├── wireframe-modal.html          # Additional examples
    └── storyboard-complete.html      # Additional examples
```

### Image Enhancement Strategy

1. **Reference Existing Examples**: Use actual files from examples/ directory
2. **Follow Storyboarding Patterns**: Replicate successful patterns from screenflows-storyboarding.md
3. **Maintain GitHub Compatibility**: Ensure all images render in GitHub
4. **Preserve Validation**: Apply same validation rules as update-screenflows command
5. **Document Best Practices**: Include clear examples of correct embedded image usage

## Implementation Details

```bash
#!/bin/bash
set -euo pipefail

# Parse arguments
if [ $# -lt 1 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /design:update-wireframes-documentation <base-branch> [target-documentation] [enhancement-mode]"
    echo "Example: /design:update-wireframes-documentation main"
    echo "Example: /design:update-wireframes-documentation develop screenflows-wireframes.md enhanced"
    exit 1
fi

BASE_BRANCH="$1"
TARGET_DOC="${2:-screenflows-wireframes.md}"
ENHANCEMENT_MODE="${3:-standard}"
DOCS_DIR="ubuntu-vm/project/design/docs"
TARGET_FILE="$DOCS_DIR/$TARGET_DOC"

# Validate target documentation file
if [[ ! -f "$TARGET_FILE" ]]; then
    echo "❌ Error: Target documentation file not found: $TARGET_FILE"
    echo "Available documentation files:"
    ls -la "$DOCS_DIR"/*.md 2>/dev/null || echo "No markdown files found"
    exit 1
fi

# Validate enhancement mode
if [[ ! "$ENHANCEMENT_MODE" =~ ^(standard|enhanced|validate-only)$ ]]; then
    echo "❌ Error: Invalid enhancement mode. Must be one of: standard, enhanced, validate-only"
    echo "Default: standard"
    exit 1
fi

echo "🚀 Starting wireframes documentation enhancement..."
echo "📂 Target: $TARGET_FILE"
echo "🔧 Enhancement mode: $ENHANCEMENT_MODE"
echo "🌿 Base branch: $BASE_BRANCH"

# Image validation function (copied from update-screenflows)
validate_markdown_images() {
    local file_path="$1"
    echo "🔒 Validating image references in $file_path..."
    
    # Check for hyperlinked images (external URLs)
    local hyperlinked_images
    hyperlinked_images=$(grep -n '!\[.*\](http[s]*://' "$file_path" 2>/dev/null || true)
    
    if [[ -n "$hyperlinked_images" ]]; then
        echo "❌ ERROR: Hyperlinked images found in $file_path"
        echo "   The following images must be embedded (use relative paths) instead of hyperlinked:"
        echo "$hyperlinked_images"
        echo ""
        echo "🔧 SOLUTION: Replace hyperlinked images with embedded images:"
        echo "   ❌ Wrong: ![Example](https://example.com/image.png)"
        echo "   ✅ Correct: ![Example](./examples/image.png)"
        echo "   ✅ Correct: ![Example](../wireframes/wireframe.svg)"
        echo ""
        return 1
    fi
    
    # Check for properly embedded images (relative paths)
    local embedded_images
    embedded_images=$(grep -n '!\[.*\](\./\|!\[.*\](\.\./\|!\[.*\]([^h][^t][^t][^p]' "$file_path" 2>/dev/null || true)
    
    if [[ -n "$embedded_images" ]]; then
        echo "✅ Found properly embedded images:"
        echo "$embedded_images" | head -5  # Show first 5 examples
        if [[ $(echo "$embedded_images" | wc -l) -gt 5 ]]; then
            echo "   ... and $(( $(echo "$embedded_images" | wc -l) - 5 )) more"
        fi
    fi
    
    return 0
}

# Validate existing documentation if in validate-only mode
if [[ "$ENHANCEMENT_MODE" == "validate-only" ]]; then
    echo -e "\n🔒 VALIDATION ONLY MODE"
    
    if validate_markdown_images "$TARGET_FILE"; then
        echo "✅ Validation successful: All images are properly embedded"
        exit 0
    else
        echo "❌ Validation failed: Some images need to be converted to embedded format"
        exit 1
    fi
fi

# Analysis phase
echo -e "\n📊 Analyzing current documentation..."

# Check what examples are available
EXAMPLES_DIR="$DOCS_DIR/examples"
if [[ -d "$EXAMPLES_DIR" ]]; then
    echo "📁 Available examples in $EXAMPLES_DIR:"
    ls -la "$EXAMPLES_DIR"
else
    echo "⚠️  Examples directory not found: $EXAMPLES_DIR"
    echo "   Creating examples directory for future use..."
    mkdir -p "$EXAMPLES_DIR"
fi

# Enhancement phase (standard or enhanced mode)
echo -e "\n🔧 Enhancing documentation with embedded image examples..."
echo "📄 Target file: $TARGET_FILE"
echo "🎯 Following patterns from screenflows-storyboarding.md"

# Backup existing file
BACKUP_FILE="${TARGET_FILE}.backup-$(date +%Y%m%d-%H%M%S)"
cp "$TARGET_FILE" "$BACKUP_FILE"
echo "💾 Created backup: $BACKUP_FILE"

# The actual enhancement will be performed by Claude
echo -e "\n✨ Ready for documentation enhancement..."
echo "📋 Target: Update $TARGET_DOC with embedded image examples"
echo "🎨 Pattern: Follow screenflows-storyboarding.md embedded image approach"
echo "🔒 Validation: Enforce embedded images only (no external URLs)"

# Final validation after enhancement
echo -e "\n🔒 Final validation will be performed after enhancement..."
```

## Requirements

### System Requirements
- Write access to figma-make docs directory
- `grep` for pattern matching and validation
- `sed` for text processing
- Standard UNIX utilities (find, mkdir, cp)

### File Requirements
- Target documentation file must exist
- examples/ directory should contain referenced SVG/HTML files
- Backup directory access for file preservation

### Validation Requirements
- All image references must use relative paths
- No external URLs allowed in image references
- Images must exist in examples/ or related directories

## Error Handling

### Common Errors

- **Missing Target File**: Validates target documentation file exists
- **Invalid Enhancement Mode**: Ensures mode is one of: standard, enhanced, validate-only
- **Permission Denied**: Checks write access to docs directory
- **Image Validation Failure**: Detects and reports hyperlinked images with specific line numbers

### Error Messages

The command provides clear, actionable error messages:
- Missing file with available alternatives listed
- Invalid mode with valid options shown
- Permission issues with troubleshooting steps
- Image validation errors with conversion examples

## Related Commands

- `/design:update-screenflows` - Creates screen flow diagrams with embedded image validation
- `/design:run-design-dev --screenflow` - Meta-command that coordinates screenflow development
- `/design:execute-screen-flow-dev` - Executes AI-assisted screen flow development

## Notes

- **Pattern Consistency**: Follows the same embedded image patterns established in screenflows-storyboarding.md
- **Validation Integration**: Uses the same image validation system from update-screenflows v2.2.0
- **GitHub Compatibility**: Ensures all images render properly in GitHub markdown
- **Non-Destructive**: Creates backups before making changes
- **Incremental Enhancement**: Can be run multiple times to progressively improve documentation
- **🔒 Security**: Prevents external image loading by enforcing relative paths only

## Version History

- **v1.0.0** - Initial implementation
  - Embedded image enhancement for screenflows-wireframes.md
  - Integration with update-screenflows validation system
  - Pattern alignment with screenflows-storyboarding.md
  - Support for standard, enhanced, and validate-only modes
  - GitHub-compatible embedded image enforcement
  - Backup and recovery functionality
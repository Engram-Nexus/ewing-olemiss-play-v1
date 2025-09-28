# Wireframes Documentation Enhancement Guide

Best practices for enhancing screenflow wireframes documentation with embedded image examples, following the successful patterns established in screenflows-storyboarding.md and enforcing the image validation requirements from v2.2.0.

## Overview

This guide provides comprehensive instructions for updating wireframes documentation to use embedded image examples that render properly in GitHub. The approach ensures consistency with the established storyboarding patterns while enforcing the validation system that prevents external image URLs in favor of relative paths.

## Table of Contents

- [Prerequisites](#prerequisites)
- [🔒 Image Validation Requirements](#-image-validation-requirements)
- [Embedded Image Patterns](#embedded-image-patterns)
- [Enhancement Process](#enhancement-process)
- [Validation System](#validation-system)
- [GitHub Compatibility](#github-compatibility)
- [Best Practices](#best-practices)
- [Common Issues](#common-issues)
- [References](#references)

## Prerequisites

- Understanding of GitHub markdown rendering
- Familiarity with screenflows-storyboarding.md embedded image patterns
- Knowledge of the v2.2.0 image validation system from update-screenflows command
- Access to examples/ directory containing reference SVG and HTML files

## 🔒 Image Validation Requirements

### Critical Embedded Image Standards

**MANDATORY**: All wireframe documentation must use embedded images with relative paths. The `/design:update-wireframes-documentation` command enforces this requirement through comprehensive validation derived from the update-screenflows command.

#### ✅ CORRECT - Embedded References (REQUIRED)

```markdown
<!-- SVG wireframes embedded with relative paths -->
![Dashboard Wireframe](./examples/wireframe-dashboard.html)
![Inline SVG Example](./examples/wireframe-inline.svg)
![Modal State Example](./examples/wireframe-modal.html)
```

```html
<!-- HTML wireframe references -->
<img src="./examples/wireframe-dashboard.html" alt="Dashboard Layout" />
<img src="./examples/wireframe-drawer-open.html" alt="Drawer Open State" />
```

#### ❌ INCORRECT - External Links (FORBIDDEN)

```markdown
<!-- These will cause validation failure and command exit -->
![External Wireframe](https://example.com/wireframe.png)
![Remote SVG](http://site.com/dashboard.svg)
![Hyperlinked Image](https://htmlpreview.github.io/?wireframe.html)
```

### Validation Enforcement

The enhanced workflow includes automatic image validation using the proven system from update-screenflows:

1. **Validation Trigger**: Runs automatically after documentation enhancement
2. **File Coverage**: Scans target documentation files for image references
3. **Pattern Detection**: Identifies external URLs (http://, https://) in image references
4. **Error Reporting**: Provides specific file names and line numbers for violations
5. **Command Termination**: Exits with error code 1 if any hyperlinked images found
6. **Conversion Guidance**: Clear examples for fixing hyperlinked to embedded references

### Benefits of Embedded Images

- **Instant GitHub Rendering**: Images display immediately in GitHub markdown
- **Version Control Integration**: All image changes tracked with code changes
- **Offline Documentation**: Works without internet connectivity
- **Team Accessibility**: No external dependencies for viewing wireframes
- **Performance Optimization**: Local images load faster than external resources
- **Security Enhancement**: Eliminates external image loading risks

## Embedded Image Patterns

### Pattern Reference: screenflows-storyboarding.md

The successful embedded image implementation in screenflows-storyboarding.md provides the reference patterns:

```markdown
### Example 1: E-commerce Application Storyboard

![E-commerce Storyboard Example](./images/storyboards/ecommerce-storyboard.svg)

*Example storyboard showing e-commerce user journey from home to checkout*

### Example 2: Dashboard Application with Navigation States

![Dashboard Storyboard Example](./images/storyboards/dashboard-storyboard.svg)

*Example dashboard application showing consistent navigation structure across screens*
```

### Wireframes Documentation Adaptation

Following the storyboarding patterns, wireframes documentation should include:

```markdown
### Interactive Examples

View these example wireframes as live HTML pages:

#### Dashboard Wireframe (SVG)
![Dashboard Wireframe](./examples/wireframe-inline.svg)

*SVG wireframe example showing dashboard layout structure*

#### HTML Wireframe Examples

![Dashboard HTML Example](./examples/wireframe-dashboard.html)

*Interactive HTML wireframe demonstrating dashboard layout*

![Drawer Open State](./examples/wireframe-drawer-open.html)

*HTML wireframe showing navigation drawer expanded state*

![Modal Dialog State](./examples/wireframe-modal.html)

*HTML wireframe demonstrating modal dialog overlay*
```

### Enhanced Visual Preview Section

```markdown
### Visual Examples with Embedded Images

#### SVG Wireframe Rendering
![Inline SVG Wireframe](./examples/wireframe-inline.svg)

This SVG wireframe demonstrates:
- **GitHub Native Rendering**: Displays directly in GitHub markdown
- **Scalable Vector Format**: Maintains quality at all zoom levels  
- **Embedded Implementation**: Uses relative path for reliable access
- **No External Dependencies**: Renders without internet connectivity

#### HTML Preview Integration
![Dashboard Example](./examples/wireframe-dashboard.html)

This HTML wireframe shows:
- **Interactive Elements**: Hover states and navigation patterns
- **Responsive Layout**: Mobile and desktop considerations
- **State Management**: Different UI states demonstrated
- **Component Structure**: Clear hierarchy and relationships
```

## Enhancement Process

### 1. Documentation Analysis

First, analyze the current documentation structure:

```bash
# Review current image references
grep -n '!\[.*\](.*' ubuntu-vm/project/design/docs/screenflows-wireframes.md

# Check available examples
ls -la ubuntu-vm/project/design/docs/examples/
```

### 2. Pattern Implementation

Add embedded image examples following the storyboarding patterns:

```markdown
## Live Examples

### Interactive Examples
View these example wireframes with embedded rendering:

- [Dashboard Wireframe](./examples/wireframe-dashboard.html) - Main dashboard layout
- [Drawer Open State](./examples/wireframe-drawer-open.html) - Navigation expanded
- [Modal Dialog State](./examples/wireframe-modal.html) - Modal overlay example

### Visual Preview

#### Dashboard Wireframe (SVG)
![Dashboard Wireframe](./examples/wireframe-inline.svg)

*SVG wireframe showing standard dashboard components and layout*

#### HTML Wireframe Examples

![Dashboard HTML](./examples/wireframe-dashboard.html)

*Interactive dashboard wireframe with navigation and content areas*

![Drawer Open](./examples/wireframe-drawer-open.html)

*Dashboard with expanded navigation drawer state*

![Modal State](./examples/wireframe-modal.html)

*Dashboard with modal dialog overlay example*
```

### 3. Validation Integration

Apply the same validation system used in update-screenflows:

```bash
# Image validation function
validate_markdown_images() {
    local file_path="$1"
    echo "🔒 Validating image references in $file_path..."
    
    # Check for hyperlinked images (external URLs)
    local hyperlinked_images
    hyperlinked_images=$(grep -n '!\[.*\](http[s]*://' "$file_path" 2>/dev/null || true)
    
    if [[ -n "$hyperlinked_images" ]]; then
        echo "❌ ERROR: Hyperlinked images found in $file_path"
        echo "   The following images must be embedded (use relative paths):"
        echo "$hyperlinked_images"
        return 1
    fi
    
    return 0
}
```

## Validation System

### Validation Functions

The wireframes documentation enhancement uses the proven validation functions from update-screenflows v2.2.0:

#### Image Reference Validation

```bash
# Check for external URLs in image references
grep -n '!\[.*\](http[s]*://' target-file.md

# Validate relative paths are used
grep -n '!\[.*\](\./\|!\[.*\](\.\.' target-file.md
```

#### Error Detection and Reporting

The validation system provides:

- **Line-by-line Analysis**: Specific location of problematic images
- **Clear Error Messages**: Actionable guidance for fixing issues
- **Conversion Examples**: Before/after patterns for reference
- **Exit Codes**: Proper error handling for automation

#### Validation Workflow

1. **Pre-Enhancement**: Check existing documentation state
2. **Enhancement Phase**: Add embedded image examples
3. **Post-Enhancement**: Validate all image references
4. **Error Handling**: Report and fix any validation failures
5. **Final Verification**: Confirm all images use relative paths

## GitHub Compatibility

### Markdown Rendering

GitHub markdown supports various image formats with embedded references:

```markdown
<!-- SVG files render directly -->
![SVG Wireframe](./examples/wireframe.svg)

<!-- HTML files can be referenced but don't render inline -->
![HTML Example](./examples/wireframe.html)

<!-- Image formats render inline -->
![PNG Example](./examples/screenshot.png)
```

### File Organization

```
ubuntu-vm/project/design/docs/
├── screenflows-wireframes.md        # TARGET DOCUMENTATION
├── screenflows-storyboarding.md     # REFERENCE PATTERNS
├── examples/                        # EMBEDDED IMAGE SOURCES
│   ├── wireframe-inline.svg          # Direct SVG rendering
│   ├── wireframe-dashboard.html      # HTML wireframe reference
│   ├── wireframe-drawer-open.html    # State-based example
│   ├── wireframe-modal.html          # Modal example
│   └── storyboard-complete.html      # Complete storyboard
└── images/                          # ADDITIONAL IMAGES
    └── storyboards/
        ├── ecommerce-storyboard.svg
        ├── dashboard-storyboard.svg
        └── mobile-storyboard.svg
```

### Relative Path Structure

All embedded images use relative paths from the documentation file location:

- Same directory: `![Example](./wireframe.svg)`
- Examples subdirectory: `![Example](./examples/wireframe.html)`
- Images subdirectory: `![Example](./images/storyboards/example.svg)`
- Parent directory: `![Example](../wireframes/example.svg)`

## Best Practices

### 1. Pattern Consistency

- **Follow Storyboarding Success**: Use the same embedded image patterns that work in screenflows-storyboarding.md
- **Maintain Formatting**: Keep consistent image caption and description formatting
- **Preserve Structure**: Use the same section organization and hierarchy

### 2. Image Organization

- **Logical Grouping**: Group related images in appropriate subdirectories
- **Descriptive Names**: Use clear, descriptive filenames for all images
- **Format Selection**: Choose appropriate formats (SVG for wireframes, HTML for interactive examples)

### 3. Documentation Quality

- **Clear Descriptions**: Provide meaningful captions for all embedded images
- **Context Setting**: Explain what each image demonstrates
- **Usage Guidance**: Include notes on when and how to use different patterns

### 4. Validation Compliance

- **Pre-commit Validation**: Always validate before committing changes
- **Regular Audits**: Periodically check for any external URL creep
- **Team Training**: Ensure all team members understand embedded image requirements

### 5. Maintenance

- **Keep Examples Updated**: Ensure embedded examples reflect current patterns
- **Version Consistency**: Maintain alignment with validation system updates
- **Documentation Sync**: Keep wireframes documentation aligned with storyboarding patterns

## Common Issues

### Problem: External URLs in Image References

**Symptoms**: Validation fails with hyperlinked image errors
**Solution**: Convert all external URLs to embedded relative paths

```bash
# Before (causes validation failure)
![External Example](https://example.com/wireframe.png)

# After (validation passes)
![Embedded Example](./examples/wireframe.svg)
```

### Problem: Missing Image Files

**Symptoms**: Broken image links in GitHub rendering
**Solution**: Verify all referenced files exist in the correct locations

```bash
# Check file existence
ls -la ubuntu-vm/project/design/docs/examples/wireframe-inline.svg
```

### Problem: Inconsistent Path References

**Symptoms**: Some images render, others don't
**Solution**: Use consistent relative path formatting

```bash
# Consistent pattern
![Example 1](./examples/wireframe-1.svg)
![Example 2](./examples/wireframe-2.svg)
![Example 3](./examples/wireframe-3.svg)
```

### Problem: Validation System Bypassed

**Symptoms**: External URLs present but not caught
**Solution**: Ensure validation functions are properly executed

```bash
# Manual validation check
validate_markdown_images "ubuntu-vm/project/design/docs/screenflows-wireframes.md"
```

## References

### Documentation Sources
- `ubuntu-vm/project/design/docs/screenflows-storyboarding.md` - Reference patterns for embedded images
- `ubuntu-vm/project/design/docs/screenflows-wireframes.md` - Target documentation for enhancement
- `ubuntu-vm/project/design/commands/update-screenflows.md` - Source of validation system (v2.2.0)

### Command Integration
- `/design:update-wireframes-documentation` - Primary enhancement command
- `/design:update-screenflows` - Related command with proven validation system
- `/design:run-design-dev --screenflow` - Meta-command coordination

### Examples Directory
- `ubuntu-vm/project/design/docs/examples/wireframe-inline.svg` - SVG wireframe example
- `ubuntu-vm/project/design/docs/examples/wireframe-dashboard.html` - HTML dashboard example
- `ubuntu-vm/project/design/docs/examples/wireframe-drawer-open.html` - Drawer state example
- `ubuntu-vm/project/design/docs/examples/wireframe-modal.html` - Modal dialog example

### Validation Standards
- External URLs (http://, https://) in image references are forbidden
- All images must use relative paths from the documentation file location
- Validation functions provide clear error messages with line numbers
- Command exits with error code 1 if any validation failures occur

## Implementation Notes

- **Non-Destructive**: Always create backups before making changes
- **Incremental**: Can be run multiple times for progressive enhancement
- **Validation-First**: Validation compliance is mandatory, not optional
- **GitHub-Optimized**: All patterns tested for GitHub markdown compatibility
- **Team-Friendly**: Clear patterns that any team member can follow and maintain
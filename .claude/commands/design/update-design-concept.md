# Args: `<concept-name>` `[description]`. v0.1.0. Create or update a design concept in designs/concepts. If designs/concepts/README.md is not created, then create it - it should be a TOC for the design concepts. Each design concept should have a directory and MD file (linked in the concepts/README.md) that describes the concept. Do not embellish on concepts unless requested to by the user. The main purpose of these concepts is to capture the user's thoughts and if requested, to research deeper into them.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/update-design-concept` in bash.

## Summary

Creates or updates a design concept in the `designs/concepts/` directory. This command ensures the concepts directory structure exists, creates or updates individual concept files, and maintains a centralized README.md as a table of contents for all design concepts. The primary purpose is to capture user thoughts and design ideas without embellishment, serving as a repository for design concepts that can be researched and developed further when requested.

## Usage

```bash
/design:update-design-concept <concept-name> [description]
```

## Arguments

- `<concept-name>`: Name of the design concept (REQUIRED)
  - Will be used for directory and file naming
  - Should be descriptive but concise
  - Will be converted to kebab-case for file/directory names
  - Examples: "responsive-grid", "color-system", "typography-hierarchy"

- `[description]`: Brief description or details about the concept (OPTIONAL)
  - If provided: Used as the initial content for the concept
  - If omitted: Creates a basic template structure
  - Should capture the core idea without embellishment
  - Examples: "Flexible grid system for mobile-first design", "Semantic color tokens for theming"

## Examples

```bash
# Create a new responsive grid concept
/design:update-design-concept responsive-grid "Flexible grid system based on CSS Grid with breakpoint considerations"

# Create a concept with minimal description
/design:update-design-concept accessibility-patterns "Design patterns for inclusive user interfaces"

# Create a concept without description (template only)
/design:update-design-concept animation-system

# Update an existing concept
/design:update-design-concept color-tokens "Updated semantic color system with dark mode support"
```

## What This Command Does

### 1. Ensure Directory Structure
- Creates `designs/concepts/` directory if it doesn't exist
- Verifies proper permissions and accessibility

### 2. Manage Concepts README
- Checks if `designs/concepts/README.md` exists
- Creates it if missing with proper TOC structure
- Updates existing README to include new concepts
- Maintains alphabetical ordering of concept entries

### 3. Create/Update Concept Directory
- Creates `designs/concepts/<concept-name>/` directory
- Ensures kebab-case naming convention
- Sets up proper directory structure

### 4. Generate Concept Documentation
- Creates `designs/concepts/<concept-name>/<concept-name>.md` file
- Uses provided description or creates template structure
- Follows consistent documentation format
- Captures concept without unnecessary embellishment

### 5. Update TOC Links
- Adds or updates entry in `designs/concepts/README.md`
- Creates proper markdown links to concept files
- Maintains organized table of contents structure

### 6. Commit and Push Changes
- Automatically commits the concept changes to the current branch
- Uses `/dev:update-branch <feature-branch> push` to commit and push to remote
- Ensures concept updates are immediately saved and synchronized

## Script Integration

This command leverages the script architecture for performance optimization:

```bash
# Script: .claude/scripts/design/update-design-concept_processor.sh
# Purpose: Handle file operations and directory management
# Usage: Called internally for atomic operations

# Performance benefits:
# - Parallel directory creation and validation
# - Efficient file I/O operations
# - Atomic concept file updates
```

## Implementation

After creating or updating the design concept, the command automatically commits and pushes changes:

```bash
# Get current branch name
CURRENT_BRANCH=$(git branch --show-current)

# Commit and push changes using dev:update-branch
/dev:update-branch "$CURRENT_BRANCH" push
```

This ensures that:
- Concept changes are immediately committed with proper messaging
- Changes are pushed to remote for backup and collaboration
- Branch state is synchronized across the development team

## Common RUN Commands

This command is often used as part of larger design workflows:

```bash
# As part of design initialization
/design:run-design-dev --concepts

# Combined with other design commands
/design:update-design-concept new-concept "Initial idea"
/design:update-design-philosophy
/design:config-designs
```

## Requirements

### File Structure Requirements
- Must be run from project root directory
- Requires `designs/` directory (will be created if needed)
- Creates standardized directory structure

### Content Requirements
- Concept names should be descriptive but concise
- Descriptions should capture core ideas without embellishment
- Follow established naming conventions (kebab-case)

### Documentation Requirements
- All concepts must be linked in README.md TOC
- Concept files must follow standard markdown structure
- Maintain consistency with existing concept format

## Error Handling

### Missing Arguments
```bash
❌ Error: Concept name is required
Usage: /design:update-design-concept <concept-name> [description]
```

### Invalid Concept Names
```bash
❌ Error: Invalid concept name format
Concept names should be descriptive and will be converted to kebab-case
Examples: "responsive-grid", "color-system", "typography-hierarchy"
```

### File System Issues
```bash
❌ Error: Cannot create designs/concepts directory
Check permissions and disk space
```

### Directory Access
```bash
❌ Error: designs/ directory not accessible
Ensure you're running from the project root directory
```

## Notes

### Design Philosophy
- **Capture, Don't Embellish**: The primary purpose is to capture user thoughts and ideas as-is
- **Research on Request**: Deeper research and development should only occur when explicitly requested
- **Structured Storage**: All concepts are organized in a consistent, discoverable structure
- **Version Control Friendly**: All concept files are designed to work well with git workflows

### File Naming Conventions
- Concept directories: `designs/concepts/<kebab-case-name>/`
- Concept files: `designs/concepts/<kebab-case-name>/<kebab-case-name>.md`
- README file: `designs/concepts/README.md`

### Integration Points
- Works seamlessly with other design commands
- Concepts can be referenced by other design workflows
- Supports research and development expansion when requested
- Integrates with design documentation systems

### Best Practices
- Keep concept names clear and descriptive
- Use descriptions to capture the essence of the idea
- Don't over-engineer concepts initially
- Allow concepts to evolve through updates
- Maintain the TOC for discoverability

## Example Output Structure

After execution, the command creates this structure:

```
designs/
└── concepts/
    ├── README.md                    # Table of contents
    ├── responsive-grid/
    │   └── responsive-grid.md       # Concept documentation
    ├── color-system/
    │   └── color-system.md          # Concept documentation
    └── accessibility-patterns/
        └── accessibility-patterns.md # Concept documentation
```

### README.md Structure
```markdown
# Design Concepts

This directory contains design concepts for the project. Each concept represents a design idea or pattern that can be developed further.

## Concepts

- [Accessibility Patterns](./accessibility-patterns/accessibility-patterns.md) - Design patterns for inclusive user interfaces
- [Color System](./color-system/color-system.md) - Semantic color tokens for theming
- [Responsive Grid](./responsive-grid/responsive-grid.md) - Flexible grid system for mobile-first design

## Usage

Concepts are created and managed using the `/design:update-design-concept` command. Each concept captures core design ideas that can be researched and developed further when needed.
```

### Individual Concept File Structure
```markdown
# [Concept Name]

## Overview
[Brief description of the concept]

## Details
[Concept details and considerations]

## Notes
[Additional thoughts and considerations]

## References
[Any relevant links or resources]
```
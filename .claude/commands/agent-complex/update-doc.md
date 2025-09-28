# Args: `<type:topic>` `<doc-name>` `<description>`. v2.0.0. Create or update documentation files with clean markdown structure.

## Summary

Creates new documentation files with clean markdown structure. Supports topic-based organization for both user-level docs (`~/.claude/docs/{topic}/`), project-specific docs (`.claude/{topic}/docs/`), and nexus docs (`.claude/docs/nexus/{topic}/`). The command generates a minimal template that should be customized based on the doc's specific purpose and requirements. This command focuses solely on documentation file creation and does not manage git workflows.

## Command Execution

This command directly creates or updates documentation files without managing git workflows. Users should handle branch creation and PR management separately.

## Usage

```bash
/agent-complex:update-doc <type:topic> <doc-name> "<description>"
```

## Arguments

- `<type:topic>`: Doc type and topic combined (REQUIRED)
  - Format: `type:topic` where:
    - `type` is either `user`, `project`, or `nexus`
    - `topic` is the category (e.g., `dev`, `git`, `supabase`, `security`, `auth`, `database`)
  - Examples: `user:dev`, `project:supabase`, `user:general`, `nexus:auth`
  - `user` docs go to `~/.claude/docs/{topic}/`
  - `project` docs go to `.claude/docs/{topic}/`
  - `nexus` docs go to `.claude/docs/nexus/{topic}/`
- `<doc-name>`: Name for the doc file (REQUIRED)
  - Kebab-case format (lowercase with hyphens)
  - Should be descriptive but concise
  - Examples: `edge-function-best-practices`, `git-workflow-guide`, `security-checklist`
  - Maximum 40 characters recommended
- `<description>`: Purpose and content of the doc (REQUIRED)
  - Brief description of what the doc covers
  - Used in the document header
  - Quote if contains spaces
  - Examples: "Best practices for Supabase edge functions", "Security guidelines for API development"

## Examples

```bash
# Create user doc in dev topic
/agent-complex:update-doc user:dev typescript-style-guide "TypeScript coding standards and best practices"
# Creates: ~/.claude/docs/dev/typescript-style-guide.md

# Create user doc in git topic
/agent-complex:update-doc user:git pr-review-checklist "Pull request review guidelines and checklist"
# Creates: ~/.claude/docs/git/pr-review-checklist.md

# Create flat user doc (general topic)
/agent-complex:update-doc user:general project-setup-guide "General project setup and configuration guide"
# Creates: ~/.claude/docs/general/project-setup-guide.md

# Create project doc in supabase topic
/agent-complex:update-doc project:supabase edge-function-best-practices "Best practices for Supabase edge functions"
# Creates: .claude/docs/supabase/edge-function-best-practices.md

# Create project doc in cloudflare topic
/agent-complex:update-doc project:cloudflare worker-deployment-guide "Guide for deploying Cloudflare Workers"
# Creates: .claude/docs/cloudflare/worker-deployment-guide.md

# Create nexus doc in auth topic
/agent-complex:update-doc nexus:auth authentication-patterns "Authentication patterns and security best practices"
# Creates: .claude/docs/nexus/auth/authentication-patterns.md
```

## What This Command Does

### Documentation Creation Workflow

This command focuses on creating well-structured documentation files:

1. **Validate Arguments** ✅
   ```bash
   # Validate type:topic format (e.g., user:dev, project:supabase, nexus:auth)
   if [[ ! "$TYPE_TOPIC" =~ ^([^:]+):([^:]+)$ ]]; then
       echo "❌ Error: Invalid type:topic format '$TYPE_TOPIC'"
       echo "Expected format: type:topic (e.g., user:dev, project:supabase)"
       exit 1
   fi
   
   TYPE="${BASH_REMATCH[1]}"
   TOPIC="${BASH_REMATCH[2]}"
   
   # Validate type
   if [ "$TYPE" != "user" ] && [ "$TYPE" != "project" ] && [ "$TYPE" != "nexus" ]; then
       echo "❌ Error: Invalid type '$TYPE'"
       echo "Type must be 'user', 'project', or 'nexus'"
       exit 1
   fi
   ```

2. **Generate Doc Configuration** ⚙️
   ```bash
   # Generate document structure and location
   echo "⚙️ Generating document configuration..."
   echo "────────────────────────────────────────"
   
   # Determine target directory and deployment path
   if [ "$TYPE" = "user" ]; then
       if [ "$TOPIC" = "general" ]; then
           TARGET_DIR="ubuntu-vm/user/docs"
           DEPLOYED_PATH="~/.claude/docs/$DOC_NAME.md"
       else
           TARGET_DIR="ubuntu-vm/user/docs/$TOPIC"
           DEPLOYED_PATH="~/.claude/docs/$TOPIC/$DOC_NAME.md"
       fi
       SCOPE="user-level ($TOPIC topic)"
   elif [ "$TYPE" = "project" ]; then
       TARGET_DIR="ubuntu-vm/project/docs/$TOPIC"
       DEPLOYED_PATH=".claude/docs/$TOPIC/$DOC_NAME.md"
       SCOPE="project-specific ($TOPIC topic)"
   elif [ "$TYPE" = "nexus" ]; then
       TARGET_DIR="ubuntu-vm/project/docs/nexus/$TOPIC"
       DEPLOYED_PATH=".claude/docs/nexus/$TOPIC/$DOC_NAME.md"
       SCOPE="nexus ($TOPIC topic)"
   fi
   
   echo "📁 Source: $TARGET_DIR/$DOC_NAME.md"
   echo "🎯 Deployed: $DEPLOYED_PATH"
   echo "📋 Scope: $SCOPE"
   ```

3. **Create Doc File** 📝
   ```bash
   # Create target directory
   mkdir -p "$TARGET_DIR"
   
   # Check if doc already exists
   if [ -f "$DOC_FILE" ]; then
       echo "📝 Documentation already exists: $DOC_FILE"
       echo "🔄 File will be overwritten with new template"
   fi
   
   # Generate clean document template
   cat > "$DOC_FILE" << EOF
# $DESCRIPTION

## Overview

[Provide a brief overview of this document's purpose and scope]

## Prerequisites

[List any prerequisites, dependencies, or required knowledge]

## [Section 1]

[Replace with appropriate section heading and content]

### Subsection

[Add subsections as needed]

## [Section 2]

[Replace with appropriate section heading and content]

## Examples

[Provide practical examples, code snippets, or use cases]

\`\`\`bash
# Example command or code
echo "Replace with actual examples"
\`\`\`

## Best Practices

[List key best practices, guidelines, or recommendations]

- Practice 1
- Practice 2
- Practice 3

## Troubleshooting

[Common issues and their solutions]

### Issue 1

**Problem**: [Description of the issue]
**Solution**: [How to resolve it]

## Related Documentation

[Links to related documents or external resources]

- [Related Doc 1](path/to/doc1.md)
- [Related Doc 2](path/to/doc2.md)

## Notes

[Additional notes, caveats, or important information]
EOF
   ```

4. **Directory Structure Management** 📁
   ```bash
   # Create necessary directories if they don't exist
   echo "📁 Managing directory structure..."
   
   # For user docs
   if [ "$TYPE" = "user" ]; then
       if [ "$TOPIC" = "general" ]; then
           mkdir -p "ubuntu-vm/user/docs"
           echo "✅ Created user docs directory"
       else
           mkdir -p "ubuntu-vm/user/docs/$TOPIC"
           echo "✅ Created user topic docs directory: $TOPIC"
       fi
   fi
   
   # For project docs
   if [ "$TYPE" = "project" ]; then
       mkdir -p "ubuntu-vm/project/docs/$TOPIC"
       echo "✅ Created project topic docs directory: $TOPIC"
   fi
   
   # For nexus docs
   if [ "$TYPE" = "nexus" ]; then
       mkdir -p "ubuntu-vm/project/docs/nexus/$TOPIC"
       echo "✅ Created nexus topic docs directory: $TOPIC"
   fi
   ```

## Documentation Template Structure

### Standard Documentation Components

**Essential Sections:**
- **Title**: Based on provided description
- **Overview**: Document purpose and scope
- **Prerequisites**: Required knowledge or dependencies
- **Main Sections**: Placeholder sections for customization
- **Examples**: Code snippets and practical use cases
- **Best Practices**: Guidelines and recommendations
- **Troubleshooting**: Common issues and solutions
- **Related Documentation**: Links to related resources
- **Notes**: Additional information and caveats

### Advanced Documentation Features

**Structured Content:**
- Clear hierarchical organization (H1, H2, H3)
- Practical examples with context
- Code blocks for technical content
- Structured lists for guidelines and best practices

**Integration Patterns:**
- Links to related documentation
- Cross-references to commands and agents
- Integration with broader documentation ecosystem
- Topic-specific organization and categorization

## Documentation Types and Deployment

### User Documentation

**Deployment Locations:**
- General docs: `~/.claude/docs/{doc-name}.md`
- Topic docs: `~/.claude/docs/{topic}/{doc-name}.md`

**Characteristics:**
- Personal knowledge and reference materials
- Cross-project guidelines and standards
- Development best practices and patterns
- Tool usage and workflow documentation

### Project Documentation

**Deployment Location:** `.claude/docs/{topic}/{doc-name}.md`

**Characteristics:**
- Project-specific guides and references
- Technology stack documentation
- Integration patterns and configurations
- Domain-specific best practices

### Nexus Documentation

**Deployment Location:** `.claude/docs/nexus/{topic}/{doc-name}.md`

**Characteristics:**
- Enterprise-level documentation
- Cross-project standards and patterns
- Organizational guidelines and policies
- System integration documentation

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "📚 UPDATE-DOC v2.0.0"
echo "This command will create or update a documentation file."
echo "Note: Git workflow management (branches, commits, PRs) should be handled separately."
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 3 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:update-doc <type:topic> <doc-name> \"<description>\""
    echo "  type:topic: Combined type and topic (e.g., user:dev, project:supabase)"
    echo "  doc-name: Name for the doc file (kebab-case)"
    echo "  description: Purpose and content of the doc"
    exit 1
fi

TYPE_TOPIC="$1"
DOC_NAME="$2"
DESCRIPTION="$3"

# Parse type:topic format
if [[ ! "$TYPE_TOPIC" =~ ^([^:]+):([^:]+)$ ]]; then
    echo "❌ Error: Invalid type:topic format '$TYPE_TOPIC'"
    echo "Expected format: type:topic (e.g., user:dev, project:supabase)"
    exit 1
fi

TYPE="${BASH_REMATCH[1]}"
TOPIC="${BASH_REMATCH[2]}"

# Validate type
if [ "$TYPE" != "user" ] && [ "$TYPE" != "project" ] && [ "$TYPE" != "nexus" ]; then
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Type must be 'user', 'project', or 'nexus'"
    exit 1
fi

# Validate topic (non-empty)
if [ -z "$TOPIC" ]; then
    echo "❌ Error: Topic cannot be empty"
    echo "Examples: dev, git, supabase, security, general"
    exit 1
fi

# Validate doc name format (kebab-case)
if ! [[ "$DOC_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "❌ Error: Invalid doc name format"
    echo "Doc name must be kebab-case (lowercase letters, numbers, and hyphens)"
    echo "Examples: edge-function-best-practices, git-workflow-guide, security-checklist"
    exit 1
fi

# Validate doc name length
if [ ${#DOC_NAME} -gt 40 ]; then
    echo "❌ Error: Doc name too long (${#DOC_NAME} characters)"
    echo "Maximum 40 characters recommended"
    exit 1
fi

# Validate git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

echo ""
echo "📋 Creating documentation file..."
echo "───────────────────────────────────────"

# Determine target directory based on type and topic
if [ "$TYPE" = "user" ]; then
    if [ "$TOPIC" = "general" ]; then
        TARGET_DIR="ubuntu-vm/user/docs"
        DEPLOYED_PATH="~/.claude/docs/$DOC_NAME.md"
    else
        TARGET_DIR="ubuntu-vm/user/docs/$TOPIC"
        DEPLOYED_PATH="~/.claude/docs/$TOPIC/$DOC_NAME.md"
    fi
    SCOPE="user-level ($TOPIC topic)"
elif [ "$TYPE" = "project" ]; then
    TARGET_DIR="ubuntu-vm/project/docs/$TOPIC"
    DEPLOYED_PATH=".claude/docs/$TOPIC/$DOC_NAME.md"
    SCOPE="project-specific ($TOPIC topic)"
elif [ "$TYPE" = "nexus" ]; then
    TARGET_DIR="ubuntu-vm/project/docs/nexus/$TOPIC"
    DEPLOYED_PATH=".claude/docs/nexus/$TOPIC/$DOC_NAME.md"
    SCOPE="nexus ($TOPIC topic)"
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Define doc file path
DOC_FILE="$TARGET_DIR/$DOC_NAME.md"

# Check if doc already exists
if [ -f "$DOC_FILE" ]; then
    echo "📝 Documentation already exists: $DOC_FILE"
    echo "🔄 File will be overwritten with new template"
fi

echo "📁 Location: $DOC_FILE"
echo "📖 Creating doc: $DOC_NAME"

# Create documentation file with clean template
cat > "$DOC_FILE" << EOF
# $DESCRIPTION

## Overview

[Provide a brief overview of this document's purpose and scope]

## Prerequisites

[List any prerequisites, dependencies, or required knowledge]

## [Section 1]

[Replace with appropriate section heading and content]

### Subsection

[Add subsections as needed]

## [Section 2]

[Replace with appropriate section heading and content]

## Examples

[Provide practical examples, code snippets, or use cases]

\`\`\`bash
# Example command or code
echo "Replace with actual examples"
\`\`\`

## Best Practices

[List key best practices, guidelines, or recommendations]

- Practice 1
- Practice 2
- Practice 3

## Troubleshooting

[Common issues and their solutions]

### Issue 1

**Problem**: [Description of the issue]
**Solution**: [How to resolve it]

## Related Documentation

[Links to related documents or external resources]

- [Related Doc 1](path/to/doc1.md)
- [Related Doc 2](path/to/doc2.md)

## Notes

[Additional notes, caveats, or important information]
EOF

echo ""
echo "✅ Documentation file created successfully!"
echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "✅ SUCCESS: Documentation file created!"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "📋 Summary:"
echo "  - Doc: $DOC_NAME"
echo "  - File: $DOC_FILE"
echo "  - Type: $SCOPE"
echo "  - Topic: $TOPIC"
echo "  - Deployed: $DEPLOYED_PATH"
echo ""
echo "🎯 Next Steps:"
echo "  1. Review and customize the generated template"
echo "  2. Replace placeholder sections with actual content"
echo "  3. Add specific examples and best practices"
echo "  4. Update related documentation links"
echo "  5. Commit changes when satisfied with the documentation"
```

## Directory Structure

### User Docs (Source Structure)
```
ubuntu-vm/user/docs/
├── general/
│   ├── project-setup-guide.md
│   └── coding-standards.md
├── dev/
│   ├── typescript-style-guide.md
│   └── testing-guidelines.md
├── git/
│   ├── pr-review-checklist.md
│   └── branch-naming-conventions.md
└── security/
    ├── api-security-guide.md
    └── authentication-patterns.md
```

### User Docs (Deployed Structure)
```
~/.claude/docs/
├── general/
│   ├── project-setup-guide.md
│   └── coding-standards.md
├── dev/
│   ├── typescript-style-guide.md
│   └── testing-guidelines.md
├── git/
│   ├── pr-review-checklist.md
│   └── branch-naming-conventions.md
└── security/
    ├── api-security-guide.md
    └── authentication-patterns.md
```

### Project Docs (Source Structure)
```
ubuntu-vm/project/docs/
├── supabase/
│   ├── edge-function-best-practices.md
│   └── database-migration-guide.md
├── cloudflare/
│   ├── worker-deployment-guide.md
│   └── edge-routing-patterns.md
└── vercel/
    ├── serverless-optimization.md
    └── deployment-strategies.md
```

### Project Docs (Deployed Structure)
```
.claude/docs/
├── supabase/
│   ├── edge-function-best-practices.md
│   └── database-migration-guide.md
├── cloudflare/
│   ├── worker-deployment-guide.md
│   └── edge-routing-patterns.md
└── vercel/
    ├── serverless-optimization.md
    └── deployment-strategies.md
```

### Nexus Docs (Source Structure)
```
ubuntu-vm/project/docs/nexus/
├── auth/
│   ├── authentication-patterns.md
│   └── security-best-practices.md
├── deployment/
│   ├── multi-environment-strategies.md
│   └── release-coordination.md
└── integration/
    ├── system-integration-patterns.md
    └── api-coordination-guidelines.md
```

### Nexus Docs (Deployed Structure)
```
.claude/docs/nexus/
├── auth/
│   ├── authentication-patterns.md
│   └── security-best-practices.md
├── deployment/
│   ├── multi-environment-strategies.md
│   └── release-coordination.md
└── integration/
    ├── system-integration-patterns.md
    └── api-coordination-guidelines.md
```

## Documentation Template

Generated docs provide a clean starting structure:

### Template Sections
- **Title**: Based on provided description
- **Overview**: Document purpose and scope
- **Prerequisites**: Required knowledge or dependencies
- **Main Sections**: Placeholder sections for customization
- **Examples**: Code snippets and practical use cases
- **Best Practices**: Guidelines and recommendations
- **Troubleshooting**: Common issues and solutions
- **Related Documentation**: Links to related resources
- **Notes**: Additional information and caveats

### Customization Guidelines

**Content Development:**
- Replace placeholder sections with actual content
- Add domain-specific examples and use cases
- Include relevant code snippets and configurations
- Link to related documentation and resources

**Structure Optimization:**
- Organize content logically with clear headings
- Use consistent formatting and style
- Include practical examples for all concepts
- Provide troubleshooting for common issues

## Implementation

[The implementation bash script is included in the file content above]

## Quality Standards

### Documentation Requirements

**Essential Content:**
- Clear purpose and scope documentation
- Comprehensive examples with context
- Practical troubleshooting guidance
- Links to related resources and documentation

**Quality Metrics:**
- All template sections filled with relevant content
- Practical examples for key concepts
- Clear organization with proper heading hierarchy
- Integration with broader documentation ecosystem

### Template Quality

**Professional Structure:**
- Clean markdown formatting throughout
- Consistent section organization
- Comprehensive placeholder guidance
- Clear customization instructions

**Topic Integration:**
- Organized by topic for easy discovery
- Integrated with topic-specific infrastructure
- Related to topic commands and agents
- Supports topic-based workflow patterns

## Validation

The command validates:
- **Type**: Must be 'user', 'project', or 'nexus'
- **Topic**: Required, non-empty string
- **Doc Name**: Must follow kebab-case format
- **Name Length**: Maximum 40 characters recommended
- **File Overwrite**: Warns when overwriting existing files

## Error Handling

- **Missing Arguments**: Clear usage instructions with format examples
- **Invalid Format**: Explains type:topic format with examples
- **Invalid Type**: Must be 'user', 'project', or 'nexus'
- **Invalid Topic**: Must be non-empty
- **File System**: Handles directory creation and file permissions

## Notes

- **Topic-Based Organization**:
  - User docs: Deploy to `~/.claude/docs/{topic}/{doc-name}.md`
  - Project docs: Deploy to `.claude/docs/{topic}/{doc-name}.md`
  - Nexus docs: Deploy to `.claude/docs/nexus/{topic}/{doc-name}.md`
- **Clean Templates**: Minimal but comprehensive starting structure
- **Naming Conventions**:
  - Doc names must be kebab-case (lowercase with hyphens)
  - Maximum 40 characters recommended
- **Directory Creation**: Creates necessary topic directories automatically
- **Template Quality**: Provides professional template with common sections
- **Customization**: Generated file serves as starting point for enhancement

## Version History

- v2.0.0 - Enhanced documentation system with nexus support
  - Added nexus documentation type with special directory structure
  - Enhanced template structure with comprehensive sections
  - Improved directory management for all documentation types
  - Added deployment path documentation for clarity
  - Removed git workflow management (now handled separately)
- v1.5.0 - Topic-based organization
  - Added support for topic-based documentation organization
  - Enhanced template with structured sections
  - Improved directory structure management
- v1.0.0 - Initial documentation creation
  - Basic documentation file creation
  - Simple template structure
  - Basic validation and error handling
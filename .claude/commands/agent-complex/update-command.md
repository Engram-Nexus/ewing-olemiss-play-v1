---
description: "Create or update command files with comprehensive implementation patterns"
arguments:
  - name: type_topic
    description: "Command type and topic combined (e.g., user:dev, project:supabase, nexus:auth)"
    required: true
  - name: command_name
    description: "Name for the command file (kebab-case, max 40 chars)"
    required: true
  - name: description
    description: "Command purpose and functionality"
    required: true
  - name: _preview
    description: "# Args: `<type:topic>` `<command-name>` `<description>`. v2.3.0. Create or update command files with comprehensive implementation patterns and downstream revision awareness"
    required: false
version: "2.3.0"
category: "Command Management"
icon: "⚙️"
---

## Summary

Creates or updates command files with comprehensive implementation patterns, documentation, and validation. Supports topic-based organization for user-level commands (`~/.claude/commands/{topic}/`), project-specific commands (`.claude/commands/{topic}/`), and nexus commands (`.claude/commands/nexus/{topic}/`).

## Usage

```bash
/agent-complex:update-command <type:topic> <command-name> "<description>"
```

## Examples

```bash
# User command
/agent-complex:update-command user:dev deploy-stack "Deploy full application stack with validation"

# Project command
/agent-complex:update-command project:supabase update-edge-functions "Update and deploy Supabase edge functions"

# Nexus command
/agent-complex:update-command nexus:deployment orchestrate-release "Orchestrate multi-environment release workflow"
```

## What This Command Does

1. **Validates Arguments** - Ensures type:topic format is correct and command name follows kebab-case conventions per `.claude/docs/agent-complex/claude-command-file-rules.md`

2. **Determines Target Directory** - Based on type:
   - `user`: Creates/updates in `~/.claude/commands/{topic}/`
   - `project`: Creates/updates in `.claude/commands/{topic}/`
   - `nexus`: Creates/updates in `.claude/commands/nexus/{topic}/`

3. **Checks Existing Command** - If command already exists, notifies that it will be updated/overwritten

4. **Generates Command File** - Creates or updates command file following standards from `.claude/docs/agent-complex/claude-command-file-rules.md`:
   - YAML frontmatter with required fields (description, arguments, version)
   - Structured arguments with name, description, and required flags
   - `_preview` dummy argument for proper slash command display (workaround per documentation)
   - Intelligent argument suggestions based on command name pattern
   - Complete implementation template with error handling
   - Standard sections: Summary, Usage, Arguments, Examples, Implementation

5. **Identifies Associated Files** - Checks for and lists related files that may need updates:
   - Documentation files in `.claude/docs/` related to the command
   - Agent files in `.claude/agents/` that reference the command
   - Script files in `~/.claude/scripts/` that may call the command
   - Other commands in the same topic that may integrate with this command

6. **Provides Next Steps** - Clear guidance on:
   - Customizing the generated template
   - Implementing command logic
   - Reviewing and updating associated files
   - Testing functionality and integrations
   - Following command development best practices

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "⚙️ UPDATE-COMMAND v2.3.0"
echo "Creating command file with comprehensive implementation pattern"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 3 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:update-command <type:topic> <command-name> \"<description>\""
    exit 1
fi

TYPE_TOPIC="$1"
COMMAND_NAME="$2"
DESCRIPTION="$3"

# Parse type:topic format
if [[ ! "$TYPE_TOPIC" =~ ^([^:]+):([^:]+)$ ]]; then
    echo "❌ Error: Invalid type:topic format '$TYPE_TOPIC'"
    echo "Expected: user:dev, project:supabase, nexus:auth"
    exit 1
fi

TYPE="${BASH_REMATCH[1]}"
TOPIC="${BASH_REMATCH[2]}"

# Validate type
if [ "$TYPE" != "user" ] && [ "$TYPE" != "project" ] && [ "$TYPE" != "nexus" ]; then
    echo "❌ Error: Invalid type '$TYPE' (must be user, project, or nexus)"
    exit 1
fi

# Validate command name format
if ! [[ "$COMMAND_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "❌ Error: Command name must be kebab-case"
    exit 1
fi

# Determine target directory
if [ "$TYPE" = "user" ]; then
    TARGET_DIR="$HOME/.claude/commands/$TOPIC"
elif [ "$TYPE" = "project" ]; then
    TARGET_DIR=".claude/commands/$TOPIC"
else
    TARGET_DIR=".claude/commands/nexus/$TOPIC"
fi

mkdir -p "$TARGET_DIR"
COMMAND_FILE="$TARGET_DIR/$COMMAND_NAME.md"

# Generate argument structure based on command name pattern
generate_argument_structure() {
    local cmd_name="$1"

    if [[ "$cmd_name" =~ deploy|build|create ]]; then
        echo "target options"
    elif [[ "$cmd_name" =~ update|sync|refresh ]]; then
        echo "source description"
    elif [[ "$cmd_name" =~ validate|check|scan ]]; then
        echo "scope criteria"
    elif [[ "$cmd_name" =~ delete|remove|cleanup ]]; then
        echo "target confirmation"
    else
        echo "input description"
    fi
}

SUGGESTED_ARGS=$(generate_argument_structure "$COMMAND_NAME")
ARG1=$(echo $SUGGESTED_ARGS | cut -d' ' -f1)
ARG2=$(echo $SUGGESTED_ARGS | cut -d' ' -f2)

# Check if command exists
if [ -f "$COMMAND_FILE" ]; then
    echo "📝 Updating existing command file..."
    echo "  Location: $COMMAND_FILE"
else
    echo "📋 Creating new command file..."
    echo "  Location: $COMMAND_FILE"
fi
echo "  Type: $TYPE ($TOPIC topic)"
echo "  Command: $COMMAND_NAME"

# Check for associated files that may need updates
echo ""
echo "🔍 Checking for associated files..."
echo "────────────────────────────"

# Check for related documentation
DOC_FILES=$(find .claude/docs -name "*$COMMAND_NAME*" -o -name "*$TOPIC*" 2>/dev/null | head -5)
if [ -n "$DOC_FILES" ]; then
    echo "📚 Related documentation found:"
    echo "$DOC_FILES" | while read -r file; do
        echo "  - $file"
    done
fi

# Check for related agents
AGENT_FILES=$(find .claude/agents -name "*$TOPIC*" 2>/dev/null | head -5)
if [ -n "$AGENT_FILES" ]; then
    echo "🤖 Related agents found:"
    echo "$AGENT_FILES" | while read -r file; do
        echo "  - $file"
    done
fi

# Check for related scripts
if [ "$TYPE" = "user" ]; then
    SCRIPT_FILES=$(find ~/.claude/scripts -name "*$COMMAND_NAME*" -o -name "*$TOPIC*" 2>/dev/null | head -5)
    if [ -n "$SCRIPT_FILES" ]; then
        echo "📜 Related scripts found:"
        echo "$SCRIPT_FILES" | while read -r file; do
            echo "  - $file"
        done
    fi
fi

# Check for other commands in same topic
OTHER_COMMANDS=$(find "$TARGET_DIR" -name "*.md" ! -name "$COMMAND_NAME.md" 2>/dev/null | head -5)
if [ -n "$OTHER_COMMANDS" ]; then
    echo "🔗 Other commands in $TOPIC topic:"
    echo "$OTHER_COMMANDS" | while read -r file; do
        echo "  - $file"
    done
fi

# Create/update command file with YAML frontmatter
cat > "$COMMAND_FILE" << EOF
---
description: "$DESCRIPTION"
arguments:
  - name: $ARG1
    description: "[Description of $ARG1 argument]"
    required: true
  - name: $ARG2
    description: "[Description of $ARG2 argument]"
    required: false
  - name: _preview
    description: "# Args: \`<$ARG1>\` \`[$ARG2]\`. v1.0.0. $DESCRIPTION"
    required: false
version: "1.0.0"
category: "[Category]"
icon: "🚀"
---

## Summary

$DESCRIPTION

This command provides functionality for the $TOPIC domain with comprehensive validation and error handling.

## Usage

\`\`\`bash
/$TOPIC:$COMMAND_NAME <$ARG1> [$ARG2]
\`\`\`

## Arguments

- \`<$ARG1>\`: [Detailed description of $ARG1] (REQUIRED)
- \`[$ARG2]\`: [Detailed description of $ARG2] (OPTIONAL)

## Examples

\`\`\`bash
# Basic usage
/$TOPIC:$COMMAND_NAME example-$ARG1

# With optional argument
/$TOPIC:$COMMAND_NAME example-$ARG1 "example-$ARG2"
\`\`\`

## Implementation

\`\`\`bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🚀 $(echo $COMMAND_NAME | tr '[:lower:]' '[:upper:]' | tr '-' '_') v1.0.0"
echo "$DESCRIPTION"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ \\\$# -lt 1 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /$TOPIC:$COMMAND_NAME <$ARG1> [$ARG2]"
    exit 1
fi

$(echo $ARG1 | tr '[:lower:]' '[:upper:]')="\\\$1"
$(echo $ARG2 | tr '[:lower:]' '[:upper:]')="\\\${2:-}"

# Validate required argument
if [ -z "\\\$$(echo $ARG1 | tr '[:lower:]' '[:upper:]')" ]; then
    echo "❌ Error: $ARG1 cannot be empty"
    exit 1
fi

echo "📋 Configuration:"
echo "  - $(echo $ARG1 | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g'): \\\$$(echo $ARG1 | tr '[:lower:]' '[:upper:]')"
if [ -n "\\\$$(echo $ARG2 | tr '[:lower:]' '[:upper:]')" ]; then
    echo "  - $(echo $ARG2 | sed 's/_/ /g' | sed 's/\b\(.\)/\u\1/g'): \\\$$(echo $ARG2 | tr '[:lower:]' '[:upper:]')"
fi
echo ""

echo "🚀 Executing command..."
echo "────────────────────────"

# Step 1: [Implementation step]
echo "1️⃣ [Step description]"
# [Add implementation logic]

# Step 2: [Implementation step]
echo ""
echo "2️⃣ [Step description]"
# [Add implementation logic]

echo ""
echo "✅ Command completed successfully!"
echo ""
echo "📊 Summary:"
echo "  - [Summary item 1]"
echo "  - [Summary item 2]"
\`\`\`

## Error Handling

- **Invalid Arguments**: Validates all required arguments are provided
- **[Error Type]**: [Description and resolution]

## Notes

- This command is part of the $TOPIC topic in the $TYPE scope
- [Additional implementation notes]

## Version History

- v1.0.0 - Initial implementation
EOF

echo ""
if [ -f "$COMMAND_FILE" ]; then
    echo "✅ Command file updated successfully!"
else
    echo "✅ Command file created successfully!"
fi
echo ""
echo "📋 Summary:"
echo "  - File: $COMMAND_FILE"
echo "  - Invocation: /$TOPIC:$COMMAND_NAME"
echo "  - Standards: .claude/docs/agent-complex/claude-command-file-rules.md"
echo ""
echo "🎯 Next Steps:"
echo "  1. Review and customize the generated template"
echo "  2. Update argument descriptions and examples"
echo "  3. Implement the command logic following standards"
echo "  4. Review and update any associated files listed above"
echo "  5. Test the command functionality and integrations"
echo ""
echo "📚 Reference Documentation:"
echo "  - Command standards: .claude/docs/agent-complex/claude-command-file-rules.md"
echo "  - YAML format guide: See 'YAML Header Format' section in standards doc"
echo "  - Preview workaround: See 'Preview Display Workaround' section"
echo ""
echo "⚠️ Important: Review any associated files identified above to ensure consistency"
```

## Version History

- v2.3.0 - Added downstream revision awareness and associated file detection
  - Scans for related documentation, agents, scripts, and commands
  - Reports associated files that may need updates
  - Enhanced guidance for maintaining consistency across related files
- v2.2.0 - Simplified and converted to YAML frontmatter format
  - Converted to YAML frontmatter with structured arguments
  - Removed redundant documentation (refers to command file rules doc)
  - Streamlined implementation with focus on essential functionality
  - Added _preview argument for proper slash command display
- v2.1.0 - Enhanced command templates and intelligent argument generation
- v2.0.0 - Removed git workflow management, focus on file creation
- v1.8.0 - Comprehensive command templates with all essential sections
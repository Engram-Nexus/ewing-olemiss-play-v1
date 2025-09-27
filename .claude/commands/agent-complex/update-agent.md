# Args: `<type:topic>` `<agent-name>` `<description>`. v3.0.0. Create or update agent files with comprehensive capabilities and documentation

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/update-agent` in bash.

## Summary

Creates or updates agent files with comprehensive capabilities, documentation, and integration patterns. Supports topic-based organization for user-level agents (`ubuntu-vm/user/{topic}/agents/`), project-specific agents (`ubuntu-vm/project/{topic}/agents/`), and nexus agents (`.claude/agents/nexus:{topic}:{agent-name}.md`). The command generates professional agent templates with proper frontmatter, capabilities documentation, and usage patterns.

## Command Execution

This command directly creates or updates agent files without managing git workflows. Users should handle branch creation and PR management separately.

## Usage

```bash
/agent-complex:update-agent <type:topic> <agent-name> "<description>"
```

## Arguments

- `<type:topic>`: Agent type and topic combined (REQUIRED)
  - Format: `type:topic` where:
    - `type` is either `user`, `project`, or `nexus`
    - `topic` is the category (e.g., `dev`, `supabase`, `figma-make`, `auth`, `database`)
  - Examples: `user:dev`, `project:supabase`, `user:tools`, `nexus:auth`
  - `user` agents go to `ubuntu-vm/user/{topic}/agents/`
  - `project` agents go to `ubuntu-vm/project/{topic}/agents/`
  - `nexus` agents go to `.claude/agents/nexus:{topic}:{agent-name}.md`
- `<agent-name>`: Name for the agent file (REQUIRED)
  - Kebab-case format (lowercase with hyphens)
  - Should be descriptive of the agent's primary capability
  - Examples: `deployment-manager`, `code-reviewer`, `security-scanner`, `design-coordinator`
  - Maximum 40 characters recommended
- `<description>`: Agent purpose and capabilities (REQUIRED)
  - Brief description of what this agent does
  - Will be used in the agent frontmatter and documentation
  - Focus on primary capabilities and specialization
  - Examples: "Orchestrate deployment workflows with validation", "Review code for security and best practices"

## Examples

```bash
# Basic agent creation
/agent-complex:update-agent user:dev deployment-manager "Orchestrate deployment workflows with comprehensive validation and monitoring"
# Creates: ubuntu-vm/user/dev/agents/deployment-manager.md

# Project-specific agent
/agent-complex:update-agent project:supabase edge-function-specialist "Manage Supabase edge functions with testing, deployment, and optimization"
# Creates: ubuntu-vm/project/supabase/agents/edge-function-specialist.md

# Security agent
/agent-complex:update-agent user:security vulnerability-scanner "Scan code and configurations for security vulnerabilities and compliance issues"
# Creates: ubuntu-vm/user/security/agents/vulnerability-scanner.md

# Design coordination agent
/agent-complex:update-agent project:figma-make design-coordinator "Coordinate design-to-development workflows with Figma integration"
# Creates: ubuntu-vm/project/figma-make/agents/design-coordinator.md

# Nexus agent
/agent-complex:update-agent nexus:auth authentication-manager "Manage authentication workflows and security patterns across projects"
# Creates: .claude/agents/nexus:auth:authentication-manager.md

# Database agent
/agent-complex:update-agent project:database schema-manager "Manage database schemas, migrations, and optimization workflows"
# Creates: ubuntu-vm/project/database/agents/schema-manager.md
```

## What This Command Does

### Agent Creation Workflow

This command focuses on creating comprehensive agent files. Git workflow management should be handled separately:

1. **Validate Arguments** ✅
   ```bash
   # Validate type:topic format (e.g., user:dev, project:supabase)
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

2. **Generate Agent Configuration** ⚙️
   ```bash
   # Generate agent frontmatter and structure
   echo "⚙️ Generating agent configuration..."
   echo "───────────────────────────────────"
   
   # Determine agent file location and naming
   if [ "$TYPE" = "user" ]; then
       AGENT_PATH="ubuntu-vm/user/$TOPIC/agents/$AGENT_NAME.md"
       SCOPE="user-level ($TOPIC topic)"
       INVOCATION="@agent-$TOPIC:$AGENT_NAME"
   elif [ "$TYPE" = "project" ]; then
       AGENT_PATH="ubuntu-vm/project/$TOPIC/agents/$AGENT_NAME.md"
       SCOPE="project-specific ($TOPIC topic)"
       INVOCATION="@agent-$TOPIC:$AGENT_NAME"
   elif [ "$TYPE" = "nexus" ]; then
       AGENT_PATH=".claude/agents/nexus:$TOPIC:$AGENT_NAME.md"
       SCOPE="nexus ($TOPIC topic)"
       INVOCATION="@agent-nexus:$TOPIC:$AGENT_NAME"
   fi
   
   echo "📁 Location: $AGENT_PATH"
   echo "🎯 Agent: $AGENT_NAME"
   echo "📋 Scope: $SCOPE"
   echo "📞 Invocation: $INVOCATION"
   ```

3. **Create Agent File** 📝
   ```bash
   # Create target directory
   mkdir -p "$(dirname "$AGENT_PATH")"
   
   # Check if agent already exists
   if [ -f "$AGENT_PATH" ]; then
       echo "📝 Agent already exists: $AGENT_PATH"
       echo "🔄 File will be overwritten with updated template"
   fi
   
   # Generate comprehensive agent template
   cat > "$AGENT_PATH" << EOF
name: $AGENT_NAME
description: $DESCRIPTION
topic: $TOPIC
type: $TYPE
version: 1.0.0

# $DESCRIPTION

## Overview

$DESCRIPTION

This agent specializes in $TOPIC domain operations and provides comprehensive capabilities for [specific functionality area]. The agent is designed to integrate seamlessly with existing workflows and provide intelligent automation for complex tasks.

## Key Features

- **[Primary Capability]**: [Detailed description of main functionality]
- **[Secondary Capability]**: [Description of supporting functionality]  
- **[Integration Feature]**: [How this agent integrates with other components]
- **[Automation Feature]**: [Automated workflow capabilities]

## Usage Patterns

### Direct Invocation
\`\`\`bash
# Basic agent invocation
$INVOCATION [task description]

# Specific operation
$INVOCATION "Perform [specific operation] with [parameters]"

# Complex workflow
$INVOCATION "Orchestrate [workflow type] including [requirements]"
\`\`\`

### Integration Patterns
\`\`\`bash
# Delegate to this agent from other agents
Task tool: "$INVOCATION - [specific task description]"

# Chain with other agents
Task tool: "$INVOCATION - [task 1]"
Task tool: "@agent-[other-topic]:[other-agent] - [task 2 using results]"

# Use in meta-commands
Task tool: "$INVOCATION - [orchestrate specific workflow step]"
\`\`\`

## Capabilities

### Primary Capabilities

1. **[Main Capability Name]**
   - Purpose: [What this capability does]
   - Usage: [When to use this capability]
   - Integration: [How it works with other components]

2. **[Secondary Capability Name]**
   - Purpose: [What this capability does]
   - Usage: [When to use this capability]
   - Integration: [How it works with other components]

### Supporting Capabilities

- **Validation**: [Validation capabilities specific to this domain]
- **Documentation**: [Documentation generation and management]
- **Integration**: [Integration with other tools and systems]
- **Monitoring**: [Monitoring and reporting capabilities]

## Integration

### Agent Ecosystem Integration

This agent integrates with the broader agent ecosystem:

- **Upstream Agents**: [Agents that delegate to this agent]
- **Downstream Agents**: [Agents this agent delegates to]
- **Peer Agents**: [Agents this agent collaborates with]
- **Meta-Commands**: [Meta-commands that utilize this agent]

### Command Integration

The agent works with topic-specific commands:

- **[Topic Commands]**: Leverages /$TOPIC:* commands for specific operations
- **Cross-Topic Commands**: Integrates with other topic commands when needed
- **Utility Commands**: Uses general utility commands for common operations

### Documentation Integration

- **Agent Documentation**: Maintains comprehensive capability documentation
- **Usage Examples**: Provides practical usage examples and patterns
- **Best Practices**: Documents best practices for agent utilization
- **Troubleshooting**: Includes common issues and resolution patterns

## Examples

### Basic Operations

\`\`\`bash
# Example 1: [Specific operation example]
$INVOCATION "Perform [specific task] for [target]"

# Example 2: [Complex workflow example]  
$INVOCATION "Orchestrate [workflow type] including [step 1], [step 2], and [step 3]"

# Example 3: [Integration example]
$INVOCATION "Coordinate with @agent-[other-topic]:[other-agent] to [accomplish goal]"
\`\`\`

### Advanced Workflows

\`\`\`bash
# Comprehensive workflow orchestration
$INVOCATION "Execute comprehensive [workflow type] including:
- [Step 1 description]
- [Step 2 description]  
- [Step 3 description]
- [Validation and reporting]"

# Multi-agent coordination
$INVOCATION "Coordinate [multi-step process] by:
1. [Initial analysis/preparation]
2. Delegating [specific tasks] to specialized agents
3. [Integration and validation]
4. [Final reporting and handoff]"
\`\`\`

## Best Practices

### Agent Utilization

- **Specific Tasks**: Use for [specific domain] tasks requiring [expertise area]
- **Complex Workflows**: Delegate complex [domain] workflows to this agent
- **Integration Points**: Leverage for [integration scenarios]
- **Validation**: Use for [validation requirements] in [domain area]

### Performance Optimization

- **Batch Operations**: Group similar tasks for efficient processing
- **Parallel Execution**: Coordinate with other agents for parallel processing
- **Resource Management**: Optimize resource usage for [specific resource type]
- **Caching**: Leverage caching for [cacheable operations]

### Integration Guidelines

- **Clear Delegation**: Provide specific, actionable task descriptions
- **Context Sharing**: Include relevant context and requirements
- **Result Validation**: Validate agent outputs before proceeding
- **Error Handling**: Implement proper error handling for agent interactions

## Troubleshooting

### Common Issues

**Issue 1: [Common Problem]**
- **Symptoms**: [How to identify this issue]
- **Cause**: [Root cause explanation]
- **Solution**: [Step-by-step resolution]

**Issue 2: [Integration Problem]**
- **Symptoms**: [How to identify this issue]
- **Cause**: [Root cause explanation]
- **Solution**: [Step-by-step resolution]

### Performance Issues

**Slow Response Times**
- Check for [resource bottleneck]
- Optimize [specific operations]
- Consider [alternative approach]

**Integration Failures**
- Validate [integration requirements]
- Check [dependency availability]
- Verify [configuration settings]

## Related Documentation

- [Agent Complex Rules](../docs/agent-complex-rules.md) - Architecture and design patterns
- [Topic Command Reference](../commands/) - Available topic commands
- [Integration Patterns](../docs/integration-patterns.md) - Agent integration guidelines
- [Best Practices](../docs/agent-best-practices.md) - Agent development best practices

## Notes

- **Topic Specialization**: This agent specializes in $TOPIC domain operations
- **Type Classification**: Classified as $TYPE-level agent for appropriate deployment
- **Integration Ready**: Designed for seamless integration with existing infrastructure
- **Extensible**: Can be extended with additional capabilities as needed
- **Documentation**: Comprehensive documentation ensures effective utilization
- **Best Practices**: Follows established agent development and deployment patterns

## Version History

- v1.0.0 - Initial agent implementation
  - Core [primary capability] functionality
  - Basic [secondary capability] support
  - Standard integration patterns
  - Comprehensive documentation

---

*This agent was generated using the agent-complex:update-agent command v3.0.0*
EOF
   ```

## Agent Template Structure

### Standard Agent Components

**Required Frontmatter:**
```yaml
name: agent-name
description: Agent purpose and capabilities
topic: topic-name
type: user|project|nexus
version: semantic-version
```

**Essential Sections:**
- **Overview**: Agent purpose and specialization
- **Key Features**: Primary capabilities and differentiators
- **Usage Patterns**: How to invoke and integrate the agent
- **Capabilities**: Detailed capability descriptions
- **Integration**: How the agent works with other components
- **Examples**: Practical usage examples and workflows
- **Best Practices**: Guidelines for effective agent utilization
- **Troubleshooting**: Common issues and resolution patterns

### Advanced Agent Features

**Capability Documentation:**
- Primary and secondary capabilities clearly defined
- Integration points with other agents and commands
- Workflow orchestration patterns
- Validation and error handling approaches

**Usage Pattern Documentation:**
- Direct invocation examples
- Integration with other agents
- Meta-command utilization
- Complex workflow coordination

## Agent Types and Deployment

### User-Level Agents

**Deployment Location:** `~/.claude/agents/{topic}/{agent-name}.md`
**Scope:** Available across all user projects
**Invocation:** `@agent-{topic}:{agent-name}`

**Characteristics:**
- Personal productivity and workflow agents
- Cross-project utilities and tools
- Development environment management
- General-purpose automation

### Project-Level Agents

**Deployment Location:** `.claude/agents/{topic}/{agent-name}.md`
**Scope:** Specific to individual projects
**Invocation:** `@agent-{topic}:{agent-name}`

**Characteristics:**
- Project-specific automation
- Technology stack specialists
- Integration with project infrastructure
- Domain-specific workflows

### Nexus Agents

**Deployment Location:** `.claude/agents/nexus:{topic}:{agent-name}.md`
**Scope:** Nexus-level coordination and orchestration
**Invocation:** `@agent-nexus:{topic}:{agent-name}`

**Characteristics:**
- Cross-project coordination
- Enterprise-level orchestration
- Complex workflow management
- Multi-system integration

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🤖 UPDATE-AGENT v3.0.0"
echo "This command creates or updates agent files with comprehensive capabilities."
echo "Note: Git workflow management (branches, commits, PRs) should be handled separately."
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 3 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:update-agent <type:topic> <agent-name> \"<description>\""
    echo "  type:topic: Combined type and topic (e.g., user:dev, project:supabase)"
    echo "  agent-name: Name for the agent file (kebab-case)"
    echo "  description: Agent purpose and capabilities"
    exit 1
fi

TYPE_TOPIC="$1"
AGENT_NAME="$2"
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
    echo "Examples: dev, supabase, figma-make, security, auth"
    exit 1
fi

# Validate agent name format (kebab-case)
if ! [[ "$AGENT_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    echo "❌ Error: Invalid agent name format"
    echo "Agent name must be kebab-case (lowercase letters, numbers, and hyphens)"
    echo "Examples: deployment-manager, code-reviewer, security-scanner"
    exit 1
fi

# Validate agent name length
if [ ${#AGENT_NAME} -gt 40 ]; then
    echo "❌ Error: Agent name too long (${#AGENT_NAME} characters)"
    echo "Maximum 40 characters recommended"
    exit 1
fi

# Validate git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

echo ""
echo "📋 Creating agent file..."
echo "───────────────────────────"

# Determine target directory and invocation based on type
if [ "$TYPE" = "user" ]; then
    TARGET_DIR="ubuntu-vm/user/$TOPIC/agents"
    SCOPE="user-level ($TOPIC topic)"
    INVOCATION="@agent-$TOPIC:$AGENT_NAME"
elif [ "$TYPE" = "project" ]; then
    TARGET_DIR="ubuntu-vm/project/$TOPIC/agents"
    SCOPE="project-specific ($TOPIC topic)"
    INVOCATION="@agent-$TOPIC:$AGENT_NAME"
elif [ "$TYPE" = "nexus" ]; then
    TARGET_DIR=".claude/agents"
    SCOPE="nexus ($TOPIC topic)"
    INVOCATION="@agent-nexus:$TOPIC:$AGENT_NAME"
    # Nexus agents use special naming convention
    AGENT_FILE_NAME="nexus:$TOPIC:$AGENT_NAME.md"
else
    AGENT_FILE_NAME="$AGENT_NAME.md"
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Define agent file path
if [ "$TYPE" = "nexus" ]; then
    AGENT_FILE="$TARGET_DIR/$AGENT_FILE_NAME"
else
    AGENT_FILE="$TARGET_DIR/$AGENT_NAME.md"
fi

# Check if agent already exists
if [ -f "$AGENT_FILE" ]; then
    echo "📝 Agent already exists: $AGENT_FILE"
    echo "🔄 File will be overwritten with updated template"
fi

echo "📁 Location: $AGENT_FILE"
echo "🤖 Creating agent: $AGENT_NAME"

# Create agent file with comprehensive template
cat > "$AGENT_FILE" << EOF
name: $AGENT_NAME
description: $DESCRIPTION
topic: $TOPIC
type: $TYPE
version: 1.0.0

# $DESCRIPTION

## Overview

$DESCRIPTION

This agent specializes in $TOPIC domain operations and provides comprehensive capabilities for [specific functionality area]. The agent is designed to integrate seamlessly with existing workflows and provide intelligent automation for complex tasks.

## Key Features

- **[Primary Capability]**: [Detailed description of main functionality]
- **[Secondary Capability]**: [Description of supporting functionality]  
- **[Integration Feature]**: [How this agent integrates with other components]
- **[Automation Feature]**: [Automated workflow capabilities]

## Usage Patterns

### Direct Invocation
\`\`\`bash
# Basic agent invocation
$INVOCATION [task description]

# Specific operation
$INVOCATION "Perform [specific operation] with [parameters]"

# Complex workflow
$INVOCATION "Orchestrate [workflow type] including [requirements]"
\`\`\`

### Integration Patterns
\`\`\`bash
# Delegate to this agent from other agents
Task tool: "$INVOCATION - [specific task description]"

# Chain with other agents
Task tool: "$INVOCATION - [task 1]"
Task tool: "@agent-[other-topic]:[other-agent] - [task 2 using results]"

# Use in meta-commands
Task tool: "$INVOCATION - [orchestrate specific workflow step]"
\`\`\`

## Capabilities

### Primary Capabilities

1. **[Main Capability Name]**
   - Purpose: [What this capability does]
   - Usage: [When to use this capability]
   - Integration: [How it works with other components]

2. **[Secondary Capability Name]**
   - Purpose: [What this capability does]
   - Usage: [When to use this capability]
   - Integration: [How it works with other components]

### Supporting Capabilities

- **Validation**: [Validation capabilities specific to this domain]
- **Documentation**: [Documentation generation and management]
- **Integration**: [Integration with other tools and systems]
- **Monitoring**: [Monitoring and reporting capabilities]

## Integration

### Agent Ecosystem Integration

This agent integrates with the broader agent ecosystem:

- **Upstream Agents**: [Agents that delegate to this agent]
- **Downstream Agents**: [Agents this agent delegates to]
- **Peer Agents**: [Agents this agent collaborates with]
- **Meta-Commands**: [Meta-commands that utilize this agent]

### Command Integration

The agent works with topic-specific commands:

- **[$TOPIC Commands]**: Leverages /$TOPIC:* commands for specific operations
- **Cross-Topic Commands**: Integrates with other topic commands when needed
- **Utility Commands**: Uses general utility commands for common operations

### Documentation Integration

- **Agent Documentation**: Maintains comprehensive capability documentation
- **Usage Examples**: Provides practical usage examples and patterns
- **Best Practices**: Documents best practices for agent utilization
- **Troubleshooting**: Includes common issues and resolution patterns

## Examples

### Basic Operations

\`\`\`bash
# Example 1: [Specific operation example]
$INVOCATION "Perform [specific task] for [target]"

# Example 2: [Complex workflow example]  
$INVOCATION "Orchestrate [workflow type] including [step 1], [step 2], and [step 3]"

# Example 3: [Integration example]
$INVOCATION "Coordinate with @agent-[other-topic]:[other-agent] to [accomplish goal]"
\`\`\`

### Advanced Workflows

\`\`\`bash
# Comprehensive workflow orchestration
$INVOCATION "Execute comprehensive [workflow type] including:
- [Step 1 description]
- [Step 2 description]  
- [Step 3 description]
- [Validation and reporting]"

# Multi-agent coordination
$INVOCATION "Coordinate [multi-step process] by:
1. [Initial analysis/preparation]
2. Delegating [specific tasks] to specialized agents
3. [Integration and validation]
4. [Final reporting and handoff]"
\`\`\`

## Best Practices

### Agent Utilization

- **Specific Tasks**: Use for [$TOPIC] tasks requiring [expertise area]
- **Complex Workflows**: Delegate complex [$TOPIC] workflows to this agent
- **Integration Points**: Leverage for [integration scenarios]
- **Validation**: Use for [validation requirements] in [$TOPIC area]

### Performance Optimization

- **Batch Operations**: Group similar tasks for efficient processing
- **Parallel Execution**: Coordinate with other agents for parallel processing
- **Resource Management**: Optimize resource usage for [specific resource type]
- **Caching**: Leverage caching for [cacheable operations]

### Integration Guidelines

- **Clear Delegation**: Provide specific, actionable task descriptions
- **Context Sharing**: Include relevant context and requirements
- **Result Validation**: Validate agent outputs before proceeding
- **Error Handling**: Implement proper error handling for agent interactions

## Troubleshooting

### Common Issues

**Issue 1: [Common Problem]**
- **Symptoms**: [How to identify this issue]
- **Cause**: [Root cause explanation]
- **Solution**: [Step-by-step resolution]

**Issue 2: [Integration Problem]**
- **Symptoms**: [How to identify this issue]
- **Cause**: [Root cause explanation]
- **Solution**: [Step-by-step resolution]

### Performance Issues

**Slow Response Times**
- Check for [resource bottleneck]
- Optimize [specific operations]
- Consider [alternative approach]

**Integration Failures**
- Validate [integration requirements]
- Check [dependency availability]
- Verify [configuration settings]

## Related Documentation

- [Agent Complex Rules](../docs/agent-complex-rules.md) - Architecture and design patterns
- [Topic Command Reference](../commands/) - Available topic commands
- [Integration Patterns](../docs/integration-patterns.md) - Agent integration guidelines
- [Best Practices](../docs/agent-best-practices.md) - Agent development best practices

## Notes

- **Topic Specialization**: This agent specializes in $TOPIC domain operations
- **Type Classification**: Classified as $TYPE-level agent for appropriate deployment
- **Integration Ready**: Designed for seamless integration with existing infrastructure
- **Extensible**: Can be extended with additional capabilities as needed
- **Documentation**: Comprehensive documentation ensures effective utilization
- **Best Practices**: Follows established agent development and deployment patterns

## Version History

- v1.0.0 - Initial agent implementation
  - Core [primary capability] functionality
  - Basic [secondary capability] support
  - Standard integration patterns
  - Comprehensive documentation

---

*This agent was generated using the agent-complex:update-agent command v3.0.0*
EOF

echo ""
echo "✅ Agent file created successfully!"
echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "✅ SUCCESS: Agent file created!"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "📋 Summary:"
echo "  - Agent: $AGENT_NAME"
echo "  - File: $AGENT_FILE"
echo "  - Type: $SCOPE"
echo "  - Topic: $TOPIC"
echo "  - Invocation: $INVOCATION"
echo ""
echo "🎯 Next Steps:"
echo "  1. Review and customize the generated agent template"
echo "  2. Replace placeholder sections with actual capabilities"
echo "  3. Add specific examples and integration patterns"
echo "  4. Update troubleshooting and best practices"
echo "  5. Test agent functionality and integration"
echo "  6. Commit changes when satisfied with the agent"
```

## Directory Structure

### User Agents (Deployed Structure)
```
~/.claude/agents/
├── dev/
│   ├── deployment-manager.md
│   └── project-coordinator.md
├── security/
│   ├── vulnerability-scanner.md
│   └── compliance-checker.md
└── tools/
    ├── automation-helper.md
    └── workflow-optimizer.md
```

### Project Agents (Deployed Structure)
```
.claude/agents/
├── supabase/
│   ├── edge-function-specialist.md
│   └── database-manager.md
├── figma-make/
│   ├── design-coordinator.md
│   └── component-builder.md
└── cloudflare/
    ├── worker-manager.md
    └── dns-coordinator.md
```

### Nexus Agents (Deployed Structure)
```
.claude/agents/
├── nexus:auth:authentication-manager.md
├── nexus:deploy:deployment-orchestrator.md
├── nexus:security:compliance-coordinator.md
└── nexus:integration:system-coordinator.md
```

## Agent Quality Standards

### Documentation Requirements

**Essential Documentation:**
- Clear capability descriptions
- Comprehensive usage examples
- Integration patterns and guidelines
- Troubleshooting and best practices

**Quality Metrics:**
- Complete frontmatter (name, description, topic, type, version)
- All template sections filled with relevant content
- Practical examples for common use cases
- Clear integration and invocation patterns

### Capability Standards

**Primary Capabilities:**
- Clearly defined and documented
- Focused on agent's specialization area
- Integrated with existing command infrastructure
- Validated with practical examples

**Integration Capabilities:**
- Works seamlessly with other agents
- Supports delegation and coordination patterns
- Integrates with meta-command workflows
- Provides clear handoff and validation points

## Validation

The command validates:
- **Type**: Must be 'user', 'project', or 'nexus'
- **Topic**: Required, non-empty string
- **Agent Name**: Must follow kebab-case format
- **Name Length**: Maximum 40 characters recommended
- **File Overwrite**: Warns when overwriting existing agents

## Error Handling

- **Missing Arguments**: Clear usage instructions with format examples
- **Invalid Format**: Explains type:topic format with examples
- **Invalid Type**: Must be 'user', 'project', or 'nexus'
- **Invalid Topic**: Must be non-empty
- **File System**: Handles directory creation and file permissions

## Version History

- v3.0.0 - Enhanced agent template system
  - Removed git workflow management (now handled separately)
  - Added nexus agent support with special naming convention
  - Enhanced template with comprehensive sections and examples
  - Improved frontmatter with version tracking
  - Added detailed integration and capability documentation
- v2.2.0 - Comprehensive agent templates
  - Enhanced template structure with all essential sections
  - Added integration patterns and usage examples
  - Improved troubleshooting and best practices sections
  - Added related documentation references
- v2.1.0 - Agent ecosystem integration
  - Added agent ecosystem integration patterns
  - Enhanced command integration documentation
  - Improved agent invocation examples
- v2.0.0 - Topic-based organization and templates
  - Added support for topic-based agent organization
  - Enhanced agent template with comprehensive sections
  - Added validation and error handling
  - Improved directory structure management
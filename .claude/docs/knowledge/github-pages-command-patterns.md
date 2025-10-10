# GitHub Pages Command Patterns

Command patterns for managing GitHub Pages knowledge base deployments using Claude commands.

## Table of Contents

- [Overview](#overview)
- [Command Architecture](#command-architecture)
- [Core Commands](#core-commands)
- [Command Specifications](#command-specifications)
- [Integration Patterns](#integration-patterns)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)

## Overview

This document defines command patterns for managing GitHub Pages knowledge bases through Claude Code CLI commands. These commands provide reliable, repeatable operations for initializing, updating, and deploying knowledge base sites.

### Design Principles

1. **Idempotent**: Commands can be run multiple times safely
2. **Validated**: All inputs are checked before operations
3. **Atomic**: Operations complete fully or roll back
4. **Documented**: Clear usage and error messages
5. **Composable**: Commands work together in workflows

## Command Architecture

### Command Organization

```
.claude/commands/knowledge/
├── init-github-pages.md       # Initialize GitHub Pages setup
├── update-index.md            # Update index.html viewer
├── validate-structure.md      # Validate knowledge structure
├── sync-knowledge.md          # Sync from .knowledge to docs/knowledge
└── deploy-pages.md            # Trigger GitHub Pages deployment
```

### Command Invocation Pattern

```bash
# User-level commands (if in ~/.claude/commands/knowledge/)
/knowledge:init-github-pages

# Project-level commands (if in .claude/commands/knowledge/)
/knowledge:init-github-pages
```

## Core Commands

### 1. init-github-pages

**Purpose**: Initialize GitHub Pages setup for knowledge base

**Usage**:
```bash
/knowledge:init-github-pages [--topic <topic-name>]
```

**Arguments**:
- `--topic` (optional): Initialize with specific knowledge topic

**Operations**:
1. Create `docs/` directory if missing
2. Create `docs/.nojekyll` file
3. Copy `index.html` template from reference repository
4. Create `docs/knowledge/` directory structure
5. Initialize sample knowledge topic (if --topic specified)
6. Verify directory structure

**Example**:
```bash
# Initialize with default structure
/knowledge:init-github-pages

# Initialize with specific topic
/knowledge:init-github-pages --topic my-project
```

**Output**:
```
✅ GitHub Pages initialized successfully
  - Created docs/ directory
  - Added .nojekyll file
  - Copied index.html template
  - Created knowledge/ structure
  - Next: Configure GitHub Pages in repository settings
```

### 2. update-index

**Purpose**: Update index.html viewer with latest template

**Usage**:
```bash
/knowledge:update-index [--backup] [--theme <name>]
```

**Arguments**:
- `--backup` (optional): Create backup before updating
- `--theme <name>` (optional): Apply theme (default, dark, light)

**Operations**:
1. Backup existing index.html (if --backup)
2. Download latest template from reference repository
3. Preserve custom theme colors (if exists)
4. Apply specified theme (if --theme)
5. Validate HTML syntax
6. Update file

**Example**:
```bash
# Update with backup
/knowledge:update-index --backup

# Update and apply dark theme
/knowledge:update-index --theme dark
```

**Output**:
```
✅ Index.html updated successfully
  - Backup created: docs/index.html.backup
  - Template version: v1.2.0
  - Theme: default
  - Features: markdown, syntax highlighting, mermaid
```

### 3. validate-structure

**Purpose**: Validate knowledge base directory structure and links

**Usage**:
```bash
/knowledge:validate-structure [--fix] [--verbose]
```

**Arguments**:
- `--fix` (optional): Automatically fix common issues
- `--verbose` (optional): Show detailed validation output

**Operations**:
1. Check `docs/knowledge/` exists
2. Verify `.nojekyll` file present
3. Validate `index.html` exists
4. Check all README.md files exist
5. Validate internal markdown links
6. Check for broken references
7. Verify file naming conventions
8. Fix issues (if --fix specified)

**Example**:
```bash
# Validate structure
/knowledge:validate-structure

# Validate and fix issues
/knowledge:validate-structure --fix --verbose
```

**Output**:
```
🔍 Validating knowledge base structure...

✅ Directory structure valid
✅ .nojekyll file present
✅ index.html exists
⚠️  Missing README in: docs/knowledge/topic-1/subtopic-1/
❌ Broken link in: docs/knowledge/topic-1/README.md
   Line 10: [Missing Block](missing.md)

Summary:
  - Total files: 45
  - Valid: 43
  - Warnings: 1
  - Errors: 1

Use --fix to automatically resolve issues
```

### 4. sync-knowledge

**Purpose**: Sync knowledge from legacy `.knowledge` to `docs/knowledge`

**Usage**:
```bash
/knowledge:sync-knowledge [--source <path>] [--target <path>] [--dry-run]
```

**Arguments**:
- `--source` (optional): Source directory (default: `.knowledge`)
- `--target` (optional): Target directory (default: `docs/knowledge`)
- `--dry-run` (optional): Show what would be synced without doing it

**Operations**:
1. Verify source directory exists
2. Create target directory if missing
3. Copy all markdown files
4. Update internal path references
5. Convert `.knowledge/` paths to `docs/knowledge/`
6. Preserve file timestamps
7. Generate sync report

**Example**:
```bash
# Dry run to see what would be synced
/knowledge:sync-knowledge --dry-run

# Perform actual sync
/knowledge:sync-knowledge

# Sync from custom source
/knowledge:sync-knowledge --source old-docs --target docs/knowledge
```

**Output**:
```
📦 Syncing knowledge base...

Source: .knowledge/
Target: docs/knowledge/

Files to sync:
  ✅ ewing-proposal/README.md
  ✅ ewing-proposal/overview/README.md
  ✅ ewing-proposal/technology/README.md
  ... (42 more files)

Path updates:
  - Updated 15 references from .knowledge/ to docs/knowledge/

✅ Sync completed successfully
  - Files synced: 45
  - Paths updated: 15
  - Errors: 0
```

### 5. deploy-pages

**Purpose**: Deploy knowledge base to GitHub Pages

**Usage**:
```bash
/knowledge:deploy-pages [--branch <name>] [--message <text>]
```

**Arguments**:
- `--branch` (optional): Target branch (default: main)
- `--message` (optional): Commit message (default: "docs: update knowledge base")

**Operations**:
1. Validate knowledge structure
2. Check for uncommitted changes
3. Add `docs/` directory to staging
4. Create commit with message
5. Push to specified branch
6. Trigger GitHub Pages rebuild
7. Wait for deployment
8. Verify deployment success

**Example**:
```bash
# Deploy with default message
/knowledge:deploy-pages

# Deploy with custom message
/knowledge:deploy-pages --message "docs: add new knowledge blocks"

# Deploy to specific branch
/knowledge:deploy-pages --branch gh-pages
```

**Output**:
```
🚀 Deploying to GitHub Pages...

1️⃣ Validating structure... ✅
2️⃣ Checking git status... ✅
3️⃣ Staging changes... ✅
4️⃣ Creating commit... ✅
   Message: docs: update knowledge base
5️⃣ Pushing to main... ✅
6️⃣ Triggering rebuild... ✅
7️⃣ Waiting for deployment... ✅
8️⃣ Verifying site... ✅

✅ Deployment successful!
  - URL: https://username.github.io/repository/
  - Build time: 45 seconds
  - Status: Live

Next: Visit your knowledge base at the URL above
```

## Command Specifications

### Command File Structure

Each command file follows this structure:

```markdown
# Command Name

Brief description of what the command does.

**Usage**: `/knowledge:command-name [arguments]`

## Arguments

- `--arg1` (required): Description
- `--arg2` (optional): Description (default: value)

## Description

Detailed explanation of command behavior.

## Operations

1. Step 1 description
2. Step 2 description
3. Step 3 description

## Examples

\`\`\`bash
# Example 1
/knowledge:command-name --arg1 value

# Example 2
/knowledge:command-name --arg1 value --arg2 value
\`\`\`

## Output Format

\`\`\`
Example output
\`\`\`

## Error Handling

| Error Code | Description | Resolution |
|------------|-------------|------------|
| KN001 | Error description | How to fix |

## Implementation

\`\`\`bash
#!/bin/bash
set -euo pipefail

# Implementation code
\`\`\`
```

### Error Code System

Knowledge commands use `KN` prefix:

| Code | Category | Example |
|------|----------|---------|
| KN001-KN099 | Validation | KN001: Missing required argument |
| KN100-KN199 | File Operations | KN101: Cannot read file |
| KN200-KN299 | Git Operations | KN201: Uncommitted changes |
| KN300-KN399 | GitHub API | KN301: API rate limit exceeded |
| KN400-KN499 | Deployment | KN401: Build failed |

### Output Standards

**Success Format**:
```
✅ Operation completed successfully
  - Detail 1: value
  - Detail 2: value

Next: Suggested action
```

**Error Format**:
```
❌ Error: Brief description (KN001)

Details:
  - Context information
  - Relevant file/line

Resolution:
  1. Step to resolve
  2. Another step

Use --help for more information
```

**Progress Format**:
```
🔄 Operation in progress...

1️⃣ Step 1... ✅
2️⃣ Step 2... ⏳
3️⃣ Step 3... ⏸️
```

## Integration Patterns

### Workflow Orchestration

Commands work together in common workflows:

#### Initial Setup Workflow

```bash
# 1. Initialize GitHub Pages
/knowledge:init-github-pages --topic my-project

# 2. Validate structure
/knowledge:validate-structure --verbose

# 3. Deploy to GitHub Pages
/knowledge:deploy-pages --message "Initial knowledge base setup"
```

#### Migration Workflow

```bash
# 1. Sync from legacy .knowledge
/knowledge:sync-knowledge --dry-run

# 2. Review sync plan, then execute
/knowledge:sync-knowledge

# 3. Validate migrated structure
/knowledge:validate-structure --fix

# 4. Deploy updated content
/knowledge:deploy-pages --message "Migrate to docs/knowledge structure"
```

#### Maintenance Workflow

```bash
# 1. Validate before making changes
/knowledge:validate-structure

# 2. Make content updates (manual)

# 3. Validate after changes
/knowledge:validate-structure --fix

# 4. Deploy updates
/knowledge:deploy-pages
```

### Agent Integration

Commands integrate with knowledge management agents:

```markdown
## Available Claude Slash Commands

| Command File | Arguments | Usage |
|--------------|-----------|-------|
| `init-github-pages.md` | `[--topic <name>]` | `/knowledge:init-github-pages` |
| `validate-structure.md` | `[--fix] [--verbose]` | `/knowledge:validate-structure` |
| `deploy-pages.md` | `[--branch <name>]` | `/knowledge:deploy-pages` |

### Usage in Agents

Agents should:
1. Load command documentation into context
2. Execute commands based on task requirements
3. Parse command output for decision-making
4. Handle command errors gracefully
```

## Error Handling

### Validation Errors

**KN001: Missing Required Argument**
```bash
❌ Error: Missing required argument '--topic' (KN001)

Usage: /knowledge:init-github-pages --topic <topic-name>

Example:
  /knowledge:init-github-pages --topic my-project
```

**Resolution**: Provide the required argument

**KN002: Invalid Path**
```bash
❌ Error: Invalid path 'invalid/path' (KN002)

The specified path does not exist or is not accessible.

Resolution:
  1. Verify the path exists: ls -la invalid/path
  2. Check permissions: ls -ld invalid/path
  3. Use absolute path if needed
```

**Resolution**: Fix the path or create missing directories

### File Operation Errors

**KN101: Cannot Read File**
```bash
❌ Error: Cannot read file 'docs/index.html' (KN101)

File may not exist or permissions are insufficient.

Resolution:
  1. Check file exists: ls -la docs/index.html
  2. Check permissions: ls -l docs/index.html
  3. Verify you have read access
```

**Resolution**: Fix file permissions or restore missing file

### Git Operation Errors

**KN201: Uncommitted Changes**
```bash
❌ Error: Uncommitted changes detected (KN201)

Cannot deploy with uncommitted changes in:
  - docs/knowledge/topic/block.md
  - docs/index.html

Resolution:
  1. Review changes: git status
  2. Commit changes: git commit -am "message"
  3. Or stash changes: git stash
  4. Then retry deployment
```

**Resolution**: Commit or stash changes before deploying

### Deployment Errors

**KN401: Build Failed**
```bash
❌ Error: GitHub Pages build failed (KN401)

Build log:
  Error: Could not access .knowledge/ directory

This is typically caused by using dotfiles that GitHub Pages ignores.

Resolution:
  1. Verify using docs/knowledge/ not .knowledge/
  2. Check .nojekyll file exists: ls docs/.nojekyll
  3. Review build logs in GitHub Actions
  4. Retry deployment after fixing
```

**Resolution**: Fix path issues and redeploy

## Best Practices

### Command Design

1. **Validate Early**: Check all inputs before operations
2. **Provide Feedback**: Show progress for long operations
3. **Be Idempotent**: Safe to run multiple times
4. **Handle Errors**: Graceful degradation and clear messages
5. **Document Thoroughly**: Usage, examples, and error codes

### Command Usage

1. **Use Validation**: Run validate-structure before deployments
2. **Test Changes**: Use --dry-run flags when available
3. **Backup Important Files**: Use --backup flags
4. **Read Output**: Pay attention to warnings and suggestions
5. **Check Status**: Verify operations succeeded

### Integration

1. **Agent Context**: Load command docs into agent context
2. **Parse Output**: Use structured output for decision-making
3. **Error Recovery**: Implement fallback strategies
4. **Workflow Composition**: Chain commands logically
5. **Documentation**: Keep command docs updated

### Maintenance

1. **Version Control**: Track command file changes
2. **Testing**: Test commands after updates
3. **Documentation**: Update examples and error codes
4. **Backwards Compatibility**: Maintain parameter compatibility
5. **Deprecation**: Provide migration paths for removed features

## Reference Implementation

See the ewing-olemiss-play-v1 repository for working examples:

- **Commands**: `.claude/commands/knowledge/`
- **Documentation**: `.claude/docs/knowledge/`
- **Usage**: See GitHub Pages setup guide

## Related Documentation

- `github-pages-setup-guide.md` - Complete setup guide
- `knowledge-management-guide.md` - Content organization
- `.claude/docs/agent-complex/agent-complex-rules.md` - Agent patterns

## Version History

- v1.0.0 (2025-09-30) - Initial command patterns
  - Defined core command set
  - Documented error codes
  - Created integration patterns
  - Established best practices

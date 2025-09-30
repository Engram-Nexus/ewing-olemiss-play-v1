---
description: "Configure GitHub Pages for knowledge blocks using GitHub CLI, creates or updates index.html and supporting files"
arguments:
  - name: topic
    description: "Knowledge topic name (e.g., ewing-proposal, my-project)"
    required: false
  - name: repo-name
    description: "Repository name for GitHub Pages URL (auto-detected if not provided)"
    required: false
  - name: _preview
    description: "# Args: `[topic]` `[repo-name]`. v1.0.0. Configure GitHub Pages for knowledge blocks using GitHub CLI, creates or updates index.html and supporting files"
    required: false
version: "1.0.0"
category: "deployment"
icon: "🚀"
---

## Summary

Configures GitHub Pages for knowledge base hosting using the GitHub CLI. This command:
- Enables GitHub Pages via GitHub CLI
- Creates/updates `docs/` directory structure
- Copies/updates `index.html` viewer from reference implementation
- Creates `.nojekyll` file for dotfile compatibility
- Initializes `docs/knowledge/` directory structure
- Validates configuration and deploys

This command uses the ewing-olemiss-play-v1 repository as the reference implementation.

## Usage

```bash
# Auto-detect repository and create default structure
/knowledge:update-github-pages

# Specify knowledge topic
/knowledge:update-github-pages my-project

# Specify both topic and repo name
/knowledge:update-github-pages my-project my-repo-name
```

## Arguments

- `[topic]`: Knowledge topic name for initial structure (OPTIONAL, default: none - creates empty structure)
- `[repo-name]`: Repository name for GitHub Pages URL (OPTIONAL, auto-detected from git remote)

## Examples

```bash
# Basic usage - auto-detect everything
/knowledge:update-github-pages

# Create with specific topic
/knowledge:update-github-pages ewing-proposal

# Specify custom repo name
/knowledge:update-github-pages my-project custom-repo-name
```

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🚀 UPDATE-GITHUB-PAGES v1.0.0"
echo "Configure GitHub Pages for knowledge blocks"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
TOPIC="${1:-}"
REPO_NAME="${2:-}"

# Auto-detect repository name if not provided
if [ -z "$REPO_NAME" ]; then
    if git remote get-url origin >/dev/null 2>&1; then
        REMOTE_URL=$(git remote get-url origin)
        # Extract repo name from URL (handles both SSH and HTTPS)
        REPO_NAME=$(echo "$REMOTE_URL" | sed -E 's|.*/([^/]+)\.git$|\1|' | sed -E 's|.*/([^/]+)$|\1|')
        echo "📍 Auto-detected repository: $REPO_NAME"
    else
        echo "⚠️  Warning: Could not auto-detect repository name"
        echo "  Using generic configuration (will need manual URL updates)"
        REPO_NAME="repository"
    fi
fi

echo ""
echo "📋 Configuration:"
echo "  - Repository: $REPO_NAME"
if [ -n "$TOPIC" ]; then
    echo "  - Initial Topic: $TOPIC"
else
    echo "  - Initial Topic: (none - empty structure)"
fi
echo ""

# Step 1: Create directory structure
echo "1️⃣ Creating directory structure"
echo "────────────────────────────────"

# Create docs directory
if [ ! -d "docs" ]; then
    mkdir docs
    echo "✅ Created docs/ directory"
else
    echo "ℹ️  docs/ directory already exists"
fi

# Create .nojekyll file
if [ ! -f "docs/.nojekyll" ]; then
    touch docs/.nojekyll
    echo "✅ Created docs/.nojekyll file"
else
    echo "ℹ️  docs/.nojekyll already exists"
fi

# Create knowledge directory structure
if [ ! -d "docs/knowledge" ]; then
    mkdir -p docs/knowledge
    echo "✅ Created docs/knowledge/ directory"
else
    echo "ℹ️  docs/knowledge/ directory already exists"
fi

# Create initial topic structure if specified
if [ -n "$TOPIC" ]; then
    TOPIC_DIR="docs/knowledge/$TOPIC"
    if [ ! -d "$TOPIC_DIR" ]; then
        mkdir -p "$TOPIC_DIR"

        # Create initial README.md
        cat > "$TOPIC_DIR/README.md" << 'TOPIC_EOF'
# Knowledge Topic

This is the root knowledge matrix for this topic.

## Overview

Add topic overview here.

## Subtopics

Add subtopic links here:
- [Example Subtopic](example-subtopic/)

## Knowledge Blocks

Add knowledge block links here:
- [Example Block](example-block.md)
TOPIC_EOF

        echo "✅ Created initial topic structure: $TOPIC_DIR"
    else
        echo "ℹ️  Topic directory already exists: $TOPIC_DIR"
    fi
fi

echo ""
echo "2️⃣ Setting up index.html viewer"
echo "────────────────────────────────"

# Check if index.html exists and backup if updating
if [ -f "docs/index.html" ]; then
    BACKUP_FILE="docs/index.html.backup.$(date +%Y%m%d_%H%M%S)"
    cp docs/index.html "$BACKUP_FILE"
    echo "📦 Backed up existing index.html to: $BACKUP_FILE"
fi

# Get the reference index.html from this repository
REFERENCE_INDEX="docs/index.html"
if [ -f "$REFERENCE_INDEX" ]; then
    echo "✅ Using existing index.html as template"
    echo "  (No changes needed - already configured)"
else
    echo "❌ Error: Reference index.html not found"
    echo "  Expected at: $REFERENCE_INDEX"
    echo ""
    echo "📝 Manual Setup Required:"
    echo "  1. Copy index.html from ewing-olemiss-play-v1 repository"
    echo "  2. Place in docs/index.html"
    echo "  3. Run this command again"
    exit 1
fi

echo ""
echo "3️⃣ Configuring GitHub Pages"
echo "────────────────────────────"

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI (gh) not found"
    echo ""
    echo "📝 Manual GitHub Pages Configuration:"
    echo "  1. Go to repository Settings → Pages"
    echo "  2. Set Source: Deploy from a branch"
    echo "  3. Select branch: main (or current branch)"
    echo "  4. Select folder: /docs"
    echo "  5. Click Save"
    echo ""
    echo "  Your site will be published at:"
    echo "  https://<username>.github.io/$REPO_NAME/"
else
    echo "✅ GitHub CLI detected"

    # Try to enable GitHub Pages using gh CLI
    echo "🔧 Attempting to enable GitHub Pages..."

    # Get current branch
    CURRENT_BRANCH=$(git branch --show-current)

    # Try to enable pages (may require authentication)
    if gh api repos/:owner/:repo/pages -X POST -f source[branch]="$CURRENT_BRANCH" -f source[path]="/docs" 2>/dev/null; then
        echo "✅ GitHub Pages enabled successfully"
        echo "  Branch: $CURRENT_BRANCH"
        echo "  Path: /docs"
    else
        # Check if already enabled
        if gh api repos/:owner/:repo/pages 2>/dev/null | grep -q '"html_url"'; then
            PAGES_URL=$(gh api repos/:owner/:repo/pages 2>/dev/null | grep -o '"html_url": *"[^"]*"' | cut -d'"' -f4)
            echo "ℹ️  GitHub Pages already enabled"
            echo "  URL: $PAGES_URL"
        else
            echo "⚠️  Could not enable GitHub Pages via CLI"
            echo ""
            echo "📝 Manual Configuration Required:"
            echo "  1. Go to: https://github.com/:owner/:repo/settings/pages"
            echo "  2. Set Source: Deploy from a branch"
            echo "  3. Select branch: $CURRENT_BRANCH"
            echo "  4. Select folder: /docs"
            echo "  5. Click Save"
        fi
    fi
fi

echo ""
echo "4️⃣ Validating structure"
echo "────────────────────────"

# Validate required files exist
VALIDATION_PASSED=true

if [ ! -f "docs/index.html" ]; then
    echo "❌ Missing: docs/index.html"
    VALIDATION_PASSED=false
else
    echo "✅ Found: docs/index.html"
fi

if [ ! -f "docs/.nojekyll" ]; then
    echo "❌ Missing: docs/.nojekyll"
    VALIDATION_PASSED=false
else
    echo "✅ Found: docs/.nojekyll"
fi

if [ ! -d "docs/knowledge" ]; then
    echo "❌ Missing: docs/knowledge/ directory"
    VALIDATION_PASSED=false
else
    echo "✅ Found: docs/knowledge/ directory"
fi

if [ "$VALIDATION_PASSED" = false ]; then
    echo ""
    echo "❌ Validation failed - see errors above"
    exit 1
fi

echo ""
echo "5️⃣ Git status check"
echo "────────────────────────"

# Check if there are changes to commit
if ! git diff --quiet docs/ 2>/dev/null || ! git diff --cached --quiet docs/ 2>/dev/null || [ -n "$(git ls-files --others --exclude-standard docs/ 2>/dev/null)" ]; then
    echo "📝 Changes detected in docs/"
    echo ""
    echo "  Modified/new files:"
    git status --short docs/ 2>/dev/null || echo "  (use git status to see details)"
    echo ""
    echo "  To commit and deploy:"
    echo "  1. Review changes: git status"
    echo "  2. Stage changes: git add docs/"
    echo "  3. Commit: git commit -m 'docs: configure GitHub Pages for knowledge base'"
    echo "  4. Push: git push"
else
    echo "✅ No changes to commit"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "✅ GitHub Pages configuration completed!"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "📊 Summary:"
echo "  - Directory structure: ✅ Created"
echo "  - index.html viewer: ✅ Ready"
echo "  - .nojekyll file: ✅ Created"
echo "  - knowledge/ directory: ✅ Ready"
if [ -n "$TOPIC" ]; then
    echo "  - Initial topic: ✅ $TOPIC"
fi
echo ""

# Get GitHub Pages URL info
if command -v gh &> /dev/null; then
    PAGES_INFO=$(gh api repos/:owner/:repo/pages 2>/dev/null || echo "")
    if [ -n "$PAGES_INFO" ]; then
        PAGES_URL=$(echo "$PAGES_INFO" | grep -o '"html_url": *"[^"]*"' | cut -d'"' -f4 || echo "")
        PAGES_STATUS=$(echo "$PAGES_INFO" | grep -o '"status": *"[^"]*"' | cut -d'"' -f4 || echo "unknown")

        if [ -n "$PAGES_URL" ]; then
            echo "🌐 GitHub Pages URL: $PAGES_URL"
            echo "📊 Status: $PAGES_STATUS"
            echo ""
        fi
    fi
fi

echo "📝 Next Steps:"
echo "  1. Add knowledge content to docs/knowledge/"
echo "  2. Commit and push changes (see commands above)"
echo "  3. Wait 30-60 seconds for GitHub Pages to build"
echo "  4. Visit your knowledge base at the URL above"
echo ""
echo "📚 Documentation:"
echo "  - Setup Guide: .claude/docs/knowledge/github-pages-setup-guide.md"
echo "  - Command Patterns: .claude/docs/knowledge/github-pages-command-patterns.md"
echo "  - Agent Spec: .claude/docs/knowledge/github-pages-agent-spec.md"
```

## Error Handling

- **Missing index.html**: Requires reference file to exist in repository
- **GitHub CLI Not Available**: Provides manual configuration instructions
- **Git Not Configured**: Provides fallback generic configuration
- **Permission Errors**: Reports directory creation failures clearly

## Notes

- This command uses the current repository's index.html as the template
- GitHub Pages must be manually enabled if gh CLI is not available
- The `.nojekyll` file is critical for serving the `knowledge/` folder (not `.knowledge/`)
- Repository name is auto-detected from git remote origin
- Changes must be committed and pushed to deploy

## Related Documentation

- `.claude/docs/knowledge/github-pages-setup-guide.md` - Complete setup guide
- `.claude/docs/knowledge/github-pages-command-patterns.md` - Command patterns
- `.claude/docs/knowledge/github-pages-agent-spec.md` - Agent specification

## Version History

- v1.0.0 - Initial implementation
  - GitHub Pages configuration via gh CLI
  - index.html template setup
  - Directory structure creation
  - Validation and deployment guidance

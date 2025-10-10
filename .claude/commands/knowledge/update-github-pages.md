---
description: "Configure GitHub Pages for knowledge blocks using GitHub CLI, creates or updates index.html viewer with bug fixes and optimizations"
arguments:
  - name: topic
    description: "Knowledge topic name (e.g., ewing-proposal, my-project)"
    required: false
  - name: repo-name
    description: "Repository name for GitHub Pages URL (auto-detected if not provided)"
    required: false
  - name: _preview
    description: "# Args: `[topic]` `[repo-name]`. v2.0.0. Configure GitHub Pages for knowledge blocks using GitHub CLI, creates or updates index.html viewer with bug fixes and optimizations"
    required: false
version: "2.0.0"
category: "deployment"
icon: "🚀"
---

## Summary

Configures GitHub Pages for knowledge base hosting with a production-ready viewer. This command:
- Enables GitHub Pages via GitHub CLI
- Creates/updates `docs/` directory structure with optimized index.html viewer
- Implements critical bug fixes for navigation and path handling
- Creates `.nojekyll` file and placeholder favicon
- Initializes `docs/knowledge/` directory structure
- Validates configuration and provides deployment guidance

**NEW in v2.0.0**: Incorporates production fixes for variable scoping, navigation handling, directory link resolution, and favicon management.

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

## Key Improvements in v2.0.0

### Bug Fixes Applied

1. **Variable Scope Fix**: `fetchPath` moved outside try block to prevent ReferenceError in error handlers
2. **Navigation 404 Prevention**: Changed `href="#"` to `href="javascript:void(0)"` to prevent browser navigation
3. **Directory Link Resolution**: Auto-appends `README.md` to directory links ending with `/`
4. **Favicon Support**: Adds placeholder favicon.ico to eliminate 404 errors
5. **Repository Auto-Detection**: Extracts repo name from git remote for GitHub Pages URLs

### Production-Ready Features

- **Markdown Rendering**: marked.js integration with syntax highlighting
- **Mermaid Diagrams**: Full support for diagram rendering
- **Internal Navigation**: Smart link processing with directory awareness
- **Error Handling**: Comprehensive error display with debugging info
- **Responsive Design**: Mobile-friendly viewer layout

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🚀 UPDATE-GITHUB-PAGES v2.0.0"
echo "Configure GitHub Pages for knowledge blocks with optimized viewer"
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

# Create placeholder favicon (prevents 404 errors)
if [ ! -f "docs/favicon.ico" ]; then
    echo "📚" > docs/favicon.ico
    echo "✅ Created docs/favicon.ico placeholder"
else
    echo "ℹ️  docs/favicon.ico already exists"
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
echo "2️⃣ Creating optimized index.html viewer"
echo "────────────────────────────────────────"

# Backup existing index.html if it exists
if [ -f "docs/index.html" ]; then
    BACKUP_FILE="docs/index.html.backup.$(date +%Y%m%d_%H%M%S)"
    cp docs/index.html "$BACKUP_FILE"
    echo "📦 Backed up existing index.html to: $BACKUP_FILE"
fi

# Create production-ready index.html with all bug fixes
cat > "docs/index.html" << 'HTML_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Knowledge Base</title>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/prism.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-bash.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-python.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-javascript.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-typescript.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-json.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/themes/prism-tomorrow.min.css">
    <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #1e293b;
            --accent-color: #3b82f6;
            --background: #ffffff;
            --surface: #f8fafc;
            --text-primary: #0f172a;
            --text-secondary: #475569;
            --border-color: #e2e8f0;
            --code-background: #1e293b;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: var(--text-primary);
            background: var(--background);
        }

        .container {
            display: flex;
            height: 100vh;
        }

        .sidebar {
            width: 280px;
            background: var(--surface);
            border-right: 1px solid var(--border-color);
            overflow-y: auto;
            padding: 2rem 1.5rem;
        }

        .sidebar h2 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            font-size: 1.25rem;
        }

        .sidebar nav ul {
            list-style: none;
        }

        .sidebar nav ul li {
            margin-bottom: 0.5rem;
        }

        .sidebar nav ul li a {
            color: var(--text-secondary);
            text-decoration: none;
            display: block;
            padding: 0.5rem 0.75rem;
            border-radius: 0.375rem;
            transition: all 0.2s;
        }

        .sidebar nav ul li a:hover {
            background: var(--primary-color);
            color: white;
        }

        .content {
            flex: 1;
            overflow-y: auto;
            padding: 3rem 4rem;
            max-width: 900px;
        }

        #markdownContent h1 {
            color: var(--primary-color);
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--border-color);
        }

        #markdownContent h2 {
            color: var(--secondary-color);
            font-size: 1.875rem;
            margin-top: 2.5rem;
            margin-bottom: 1rem;
        }

        #markdownContent h3 {
            color: var(--secondary-color);
            font-size: 1.5rem;
            margin-top: 2rem;
            margin-bottom: 0.75rem;
        }

        #markdownContent p {
            margin-bottom: 1rem;
            color: var(--text-primary);
        }

        #markdownContent ul, #markdownContent ol {
            margin-left: 2rem;
            margin-bottom: 1rem;
        }

        #markdownContent li {
            margin-bottom: 0.5rem;
        }

        #markdownContent code {
            background: var(--surface);
            padding: 0.2rem 0.4rem;
            border-radius: 0.25rem;
            font-size: 0.875rem;
            font-family: 'Courier New', monospace;
        }

        #markdownContent pre {
            background: var(--code-background);
            padding: 1.5rem;
            border-radius: 0.5rem;
            overflow-x: auto;
            margin-bottom: 1.5rem;
        }

        #markdownContent pre code {
            background: none;
            padding: 0;
            color: #e2e8f0;
        }

        #markdownContent a {
            color: var(--primary-color);
            text-decoration: none;
        }

        #markdownContent a:hover {
            text-decoration: underline;
        }

        #markdownContent blockquote {
            border-left: 4px solid var(--primary-color);
            padding-left: 1rem;
            margin: 1.5rem 0;
            color: var(--text-secondary);
            font-style: italic;
        }

        #markdownContent table {
            width: 100%;
            border-collapse: collapse;
            margin: 1.5rem 0;
        }

        #markdownContent th, #markdownContent td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        #markdownContent th {
            background: var(--surface);
            font-weight: 600;
            color: var(--secondary-color);
        }

        .loading {
            text-align: center;
            padding: 3rem;
            color: var(--text-secondary);
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
            padding: 1rem;
            border-radius: 0.5rem;
            margin: 1rem 0;
        }

        .mermaid {
            margin: 2rem 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <aside class="sidebar">
            <h2>📚 Knowledge Base</h2>
            <nav>
                <ul id="navigation">
                    <li><a href="javascript:void(0)" onclick="loadMarkdown('knowledge/README.md')">Home</a></li>
                </ul>
            </nav>
        </aside>
        <main class="content">
            <div id="markdownContent">
                <div class="loading">
                    <h2>👋 Welcome to Knowledge Base</h2>
                    <p>Select a topic from the sidebar to get started.</p>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Initialize Mermaid
        mermaid.initialize({
            startOnLoad: true,
            theme: 'default',
            securityLevel: 'loose'
        });

        // Get repository name from URL for GitHub Pages
        const pathParts = window.location.pathname.split('/').filter(p => p);
        const repoName = pathParts.length > 0 ? pathParts[0] : '';

        async function loadMarkdown(path) {
            const content = document.getElementById('markdownContent');
            content.innerHTML = '<div class="loading">Loading...</div>';

            // BUG FIX: Move fetchPath outside try block for error handler access
            let fetchPath = path;

            try {
                // Handle GitHub Pages path construction
                if (window.location.hostname.endsWith('.github.io')) {
                    // Remove leading ./ if present
                    if (fetchPath.startsWith('./')) {
                        fetchPath = fetchPath.substring(2);
                    }
                    // Ensure absolute path
                    if (!fetchPath.startsWith('/')) {
                        fetchPath = '/' + fetchPath;
                    }
                    // Prepend repo name for GitHub Pages
                    if (repoName && !fetchPath.startsWith('/' + repoName + '/')) {
                        fetchPath = '/' + repoName + fetchPath;
                    }
                }

                const response = await fetch(fetchPath);
                if (!response.ok) {
                    throw new Error(`Failed to load: ${response.statusText}`);
                }

                let markdown = await response.text();

                // Process internal links to use onclick handlers
                markdown = markdown.replace(/\[([^\]]+)\]\(([^)]+)\)/g, (match, text, href) => {
                    if (href.startsWith('http://') || href.startsWith('https://')) {
                        return match; // Keep external links as-is
                    }
                    // Convert relative links to absolute knowledge/ paths
                    let absolutePath = href;
                    if (!href.startsWith('knowledge/')) {
                        const currentDir = path.substring(0, path.lastIndexOf('/'));
                        absolutePath = currentDir + '/' + href;
                        // Clean up path
                        absolutePath = absolutePath.replace(/\/\.\//g, '/').replace(/\/[^/]+\/\.\./g, '');
                    }
                    // BUG FIX: If link ends with /, append README.md
                    if (absolutePath.endsWith('/')) {
                        absolutePath += 'README.md';
                    }
                    return `[${text}](#__INTERNAL_LINK__${absolutePath})`;
                });

                // Render markdown
                content.innerHTML = marked.parse(markdown);

                // Apply syntax highlighting
                Prism.highlightAllUnder(content);

                // Render Mermaid diagrams
                const mermaidElements = content.querySelectorAll('code.language-mermaid');
                mermaidElements.forEach(async (element) => {
                    const code = element.textContent;
                    const pre = element.parentElement;
                    const container = document.createElement('div');
                    container.className = 'mermaid';
                    container.textContent = code;
                    pre.replaceWith(container);
                });

                if (mermaidElements.length > 0) {
                    await mermaid.run();
                }

                // Process internal links
                document.querySelectorAll('#markdownContent a[href^="#__INTERNAL_LINK__"]').forEach(link => {
                    const href = link.getAttribute('href');
                    const linkPath = href.replace('#__INTERNAL_LINK__', '');
                    link.onclick = function(e) {
                        e.preventDefault();
                        loadMarkdown(linkPath);
                        return false;
                    };
                });

            } catch (error) {
                content.innerHTML = `
                    <div class="error">
                        <h3>Error Loading Content</h3>
                        <p>${error.message}</p>
                        <p>Path attempted: ${fetchPath}</p>
                    </div>
                `;
            }
        }

        // Load initial page from hash or default
        window.addEventListener('DOMContentLoaded', () => {
            const hash = window.location.hash.substring(1);
            if (hash) {
                loadMarkdown(hash);
            } else {
                loadMarkdown('knowledge/README.md');
            }
        });

        // Handle hash changes
        window.addEventListener('hashchange', () => {
            const hash = window.location.hash.substring(1);
            if (hash) {
                loadMarkdown(hash);
            }
        });
    </script>
</body>
</html>
HTML_EOF

echo "✅ Created optimized index.html with production fixes:"
echo "  - Variable scope fix (fetchPath outside try block)"
echo "  - Navigation fix (javascript:void(0) instead of href='#')"
echo "  - Directory link resolution (auto-append README.md)"
echo "  - Repository auto-detection for GitHub Pages URLs"

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

if [ ! -f "docs/favicon.ico" ]; then
    echo "❌ Missing: docs/favicon.ico"
    VALIDATION_PASSED=false
else
    echo "✅ Found: docs/favicon.ico"
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
    echo "  3. Commit: git commit -m 'docs: configure GitHub Pages with optimized viewer'"
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
echo "  - Optimized index.html: ✅ Ready (v2.0 with bug fixes)"
echo "  - .nojekyll file: ✅ Created"
echo "  - favicon.ico: ✅ Created"
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

echo "🔧 Production Fixes Applied:"
echo "  ✓ Variable scoping (fetchPath error handler fix)"
echo "  ✓ Navigation prevention (javascript:void(0))"
echo "  ✓ Directory link resolution (auto-append README.md)"
echo "  ✓ Favicon support (eliminates 404 errors)"
echo "  ✓ Repository auto-detection"
echo ""
echo "📝 Next Steps:"
echo "  1. Add knowledge content to docs/knowledge/"
echo "  2. Commit and push changes (see commands above)"
echo "  3. Wait 30-60 seconds for GitHub Pages to build"
echo "  4. Visit your knowledge base at the URL above"
echo "  5. Test navigation and verify no console errors"
echo ""
echo "📚 Documentation:"
echo "  - Setup Guide: .claude/docs/knowledge/github-pages-setup-guide.md"
echo "  - Command Patterns: .claude/docs/knowledge/github-pages-command-patterns.md"
echo "  - Agent Spec: .claude/docs/knowledge/github-pages-agent-spec.md"
```

## Error Handling

- **Missing index.html**: Auto-creates optimized viewer with all production fixes
- **GitHub CLI Not Available**: Provides manual configuration instructions
- **Git Not Configured**: Provides fallback generic configuration
- **Permission Errors**: Reports directory creation failures clearly
- **Favicon Missing**: Auto-creates placeholder to prevent 404s

## Notes

- **v2.0 Changes**: Complete rewrite of index.html with production bug fixes
- **Automatic Creation**: No longer requires reference file - creates optimized viewer automatically
- **GitHub Pages**: Must be manually enabled if gh CLI is not available
- **Critical Files**: `.nojekyll` enables serving from `docs/knowledge/`, favicon prevents console errors
- **Auto-Detection**: Repository name extracted from git remote origin
- **Deployment**: Changes must be committed and pushed to deploy

## Bug Fixes in v2.0

1. **fetchPath Scope Error**: Variable now declared outside try block for error handler access
2. **Navigation 404s**: Links use `javascript:void(0)` instead of `href="#"` to prevent navigation
3. **Directory Links**: Automatically appends `README.md` to links ending with `/`
4. **Favicon 404**: Creates placeholder favicon.ico to eliminate console errors
5. **Path Resolution**: Improved GitHub Pages path handling with repository name detection

## Related Documentation

- `.claude/docs/knowledge/github-pages-setup-guide.md` - Complete setup guide
- `.claude/docs/knowledge/github-pages-command-patterns.md` - Command patterns
- `.claude/docs/knowledge/github-pages-agent-spec.md` - Agent specification

## Version History

- v2.0.0 - Production optimization release
  - Incorporated bug fixes from production deployment
  - Fixed variable scoping error in error handler
  - Prevented navigation 404s with javascript:void(0)
  - Auto-append README.md to directory links
  - Added favicon support to eliminate 404 errors
  - Auto-creates optimized viewer instead of requiring reference
  - Enhanced error reporting with attempted path display
- v1.0.0 - Initial implementation
  - GitHub Pages configuration via gh CLI
  - index.html template setup
  - Directory structure creation
  - Validation and deployment guidance

# GitHub Pages Knowledge Base Setup Guide

Complete guide for setting up and managing GitHub Pages for knowledge base documentation using the `docs/knowledge/` structure.

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Initial Setup](#initial-setup)
- [GitHub Pages Configuration](#github-pages-configuration)
- [Index.html Template](#indexhtml-template)
- [Knowledge Organization](#knowledge-organization)
- [Deployment Process](#deployment-process)
- [Maintenance and Updates](#maintenance-and-updates)
- [Troubleshooting](#troubleshooting)

## Overview

This guide documents the standard approach for hosting knowledge bases on GitHub Pages using a universal `docs/knowledge/` directory structure. This pattern enables:

- **Consistent Organization**: All knowledge bases use the same root path
- **GitHub Pages Compatibility**: Works seamlessly with GitHub's static site hosting
- **Easy Navigation**: Browser-based interface with markdown rendering
- **Version Control**: Full git integration for tracking changes
- **Cross-Repository Portability**: Same structure works across projects

## Directory Structure

### Standard Layout

```
repository-root/
├── docs/                          # GitHub Pages root
│   ├── .nojekyll                  # Disables Jekyll processing
│   ├── index.html                 # Knowledge base viewer
│   └── knowledge/                 # Knowledge base content (NOT .knowledge)
│       └── topic-name/            # Top-level knowledge topic
│           ├── README.md          # Topic overview and matrix
│           ├── subtopic-1/        # Subtopic directory
│           │   ├── README.md      # Subtopic overview
│           │   ├── block-1.md     # Knowledge block
│           │   └── block-2.md     # Knowledge block
│           └── subtopic-2/        # Another subtopic
│               └── README.md
└── .claude/                       # Agent complex infrastructure
    ├── commands/
    │   └── knowledge/
    │       ├── init-github-pages.md
    │       ├── update-index.md
    │       └── deploy-pages.md
    └── docs/
        └── knowledge/
            └── github-pages-setup-guide.md  # This file
```

### Key Path Standard

**IMPORTANT**: Use `docs/knowledge/` (without dot) as the universal path:

- ✅ **Correct**: `docs/knowledge/topic-name/README.md`
- ❌ **Incorrect**: `.knowledge/topic-name/README.md`
- ❌ **Incorrect**: `docs/.knowledge/topic-name/README.md`

**Rationale**: GitHub Pages ignores dotfiles/folders even with `.nojekyll`, causing 404 errors. The `docs/knowledge/` path works universally across all GitHub Pages deployments.

## Initial Setup

### 1. Create Directory Structure

```bash
# Navigate to repository root
cd /path/to/repository

# Create docs directory structure
mkdir -p docs/knowledge

# Create .nojekyll file to disable Jekyll
touch docs/.nojekyll

# Verify structure
tree docs
```

### 2. Copy Index.html Template

Copy the knowledge base viewer from the reference implementation:

```bash
# Copy from ewing-olemiss-play-v1 repository
cp /path/to/ewing-olemiss-play-v1/docs/index.html docs/index.html
```

**Index.html Features**:
- Dynamic repository name detection
- Markdown rendering with marked.js
- Syntax highlighting with Prism.js
- Mermaid diagram support
- Responsive sidebar navigation
- Hash-based routing
- Internal link processing

### 3. Create Initial Knowledge Structure

```bash
# Create a sample topic
mkdir -p docs/knowledge/example-topic

# Create README with knowledge matrix
cat > docs/knowledge/example-topic/README.md << 'EOF'
# Example Topic Knowledge Matrix

This matrix integrates knowledge from all blocks and subtopics in this topic path.

## Subtopics

[📁 subtopic-1](subtopic-1)
[📁 subtopic-2](subtopic-2)

## Knowledge Blocks

- [Block 1](block-1.md)
- [Block 2](block-2.md)
EOF

# Create sample subtopic
mkdir -p docs/knowledge/example-topic/subtopic-1
echo "# Subtopic 1" > docs/knowledge/example-topic/subtopic-1/README.md
```

## GitHub Pages Configuration

### 1. Enable GitHub Pages

1. Go to repository **Settings**
2. Navigate to **Pages** section
3. Under **Source**, select:
   - **Branch**: `main` (or your default branch)
   - **Folder**: `/docs`
4. Click **Save**

### 2. Verify Deployment

After enabling, GitHub will:
- Build the site automatically
- Deploy to `https://<username>.github.io/<repository-name>/`
- Show build status in Settings > Pages

**Build Time**: Usually 30-60 seconds

### 3. Access Your Knowledge Base

Navigate to: `https://<username>.github.io/<repository-name>/`

Example: `https://engram-nexus.github.io/ewing-olemiss-play-v1/`

## Index.html Template

### Key Features

The index.html template includes:

#### 1. Dynamic Repository Detection

```javascript
// Automatically detects repo name from URL
const pathParts = window.location.pathname.split('/').filter(p => p);
const repoName = pathParts.length > 0 ? pathParts[0] : '';
```

#### 2. GitHub Pages Path Handling

```javascript
// Handles GitHub Pages publishing from /docs/ folder
if (window.location.hostname.endsWith('.github.io')) {
    // Remove leading ./ if present
    if (fetchPath.startsWith('./')) {
        fetchPath = fetchPath.substring(2);
    }
    // Ensure absolute path
    if (!fetchPath.startsWith('/')) {
        fetchPath = '/' + fetchPath;
    }
    // Prepend repo name (GitHub Pages serves from /docs/ but URLs don't include it)
    if (repoName && !fetchPath.startsWith('/' + repoName + '/')) {
        fetchPath = '/' + repoName + fetchPath;
    }
}
```

#### 3. Internal Link Processing

```javascript
// Converts markdown links to onclick handlers
document.querySelectorAll('#markdownContent a[href^="#__INTERNAL_LINK__"]').forEach(link => {
    const href = link.getAttribute('href');
    const path = href.replace('#__INTERNAL_LINK__', '');
    link.onclick = function(e) {
        e.preventDefault();
        loadMarkdown(path);
        return false;
    };
});
```

#### 4. Markdown Rendering

- **Marked.js**: Converts markdown to HTML
- **Prism.js**: Syntax highlighting for code blocks
- **Mermaid**: Diagram rendering from code blocks

### Customization

To customize for your project:

1. **Update Title**: Change page title in `<head>` section
2. **Update Header**: Modify h1 text in header
3. **Update Sidebar**: Modify navigation links to match your knowledge structure
4. **Update Theme**: Modify CSS variables in `:root` section

```css
:root {
    --primary-color: #CE1126;      /* Your primary brand color */
    --secondary-color: #14213D;    /* Your secondary color */
    --accent-color: #FFC72C;       /* Accent highlights */
}
```

## Knowledge Organization

### Topic Structure

Each knowledge topic follows this pattern:

```
knowledge/topic-name/
├── README.md                  # Knowledge matrix (required)
├── subtopic-1/               # Subtopic directory
│   ├── README.md             # Subtopic overview
│   ├── block-1.md           # Knowledge block
│   └── block-2.md           # Knowledge block
└── subtopic-2/               # Another subtopic
    └── README.md
```

### Knowledge Matrix (README.md)

The top-level README.md serves as the knowledge matrix:

```markdown
# Topic Name Knowledge Matrix

Integration of all knowledge blocks and subtopics.

## Subtopics

[📁 subtopic-1](subtopic-1/)
[📁 subtopic-2](subtopic-2/)

## Knowledge Blocks

- [Block Name](block-name.md) - Brief description
- [Another Block](another-block.md) - Brief description

## Overview

High-level summary of the topic and how subtopics relate.
```

### Link Formats

Use relative links for internal navigation:

```markdown
<!-- Link to subtopic -->
[Subtopic Name](subtopic-name/)

<!-- Link to block in same directory -->
[Block Name](block-name.md)

<!-- Link to block in subdirectory -->
[Block Name](subtopic/block-name.md)

<!-- Link with anchor -->
[Section Name](block-name.md#section-anchor)
```

## Deployment Process

### Manual Deployment

1. **Update Content**: Edit markdown files in `docs/knowledge/`
2. **Test Locally**: Open `docs/index.html` in browser
3. **Commit Changes**:
   ```bash
   git add docs/
   git commit -m "docs: update knowledge base content"
   ```
4. **Push to GitHub**:
   ```bash
   git push origin main
   ```
5. **Verify Deployment**: Check GitHub Actions for build status
6. **Access Site**: Navigate to GitHub Pages URL

### Automated Deployment (CI/CD)

GitHub automatically rebuilds when changes are pushed to the configured branch.

**Build Triggers**:
- Push to main branch
- Changes in `/docs` folder
- Manual rebuild via GitHub API

**Build Process**:
1. GitHub detects changes
2. Copies `/docs` content to hosting
3. Serves static files
4. Updates within 30-60 seconds

## Maintenance and Updates

### Adding New Knowledge

```bash
# Create new subtopic
mkdir -p docs/knowledge/topic-name/new-subtopic
echo "# New Subtopic" > docs/knowledge/topic-name/new-subtopic/README.md

# Create new block
cat > docs/knowledge/topic-name/new-subtopic/new-block.md << 'EOF'
# New Block

Content here...
EOF

# Update parent README to include links
# Edit docs/knowledge/topic-name/README.md
```

### Updating Index.html

When updating the viewer:

```bash
# Make changes to docs/index.html
# Test locally by opening in browser
# Commit and push
git add docs/index.html
git commit -m "fix: update knowledge base viewer"
git push
```

### Reorganizing Structure

To reorganize knowledge structure:

1. **Move Files**: Use `git mv` to preserve history
2. **Update Links**: Update all internal references
3. **Update README**: Modify knowledge matrix links
4. **Test**: Verify all links work
5. **Deploy**: Commit and push changes

```bash
# Example: Move subtopic
git mv docs/knowledge/topic/old-name docs/knowledge/topic/new-name

# Update README references
# Edit docs/knowledge/topic/README.md

# Commit
git commit -m "refactor: reorganize knowledge structure"
```

## Troubleshooting

### Common Issues

#### 404 Errors on Knowledge Files

**Symptom**: `GET https://username.github.io/repo/docs/knowledge/file.md 404`

**Cause**: Path construction error in JavaScript

**Solution**:
1. Verify files exist in `docs/knowledge/` (not `docs/.knowledge/`)
2. Check index.html path handling code
3. Clear browser cache and hard refresh (Ctrl+Shift+R)

#### Links Not Working

**Symptom**: Clicking links doesn't navigate to content

**Cause**: Internal link processing issue

**Solution**:
1. Check browser console for JavaScript errors
2. Verify link format in markdown
3. Check onclick handler attachment in index.html

#### Styles Not Loading

**Symptom**: Plain HTML with no styling

**Cause**: CSS not loading or JavaScript error

**Solution**:
1. Check browser console for errors
2. Verify CDN links are accessible
3. Check for JavaScript syntax errors

#### Mermaid Diagrams Not Rendering

**Symptom**: Code blocks display instead of diagrams

**Cause**: Mermaid initialization issue

**Solution**:
1. Verify Mermaid CDN is loaded
2. Check diagram syntax is valid
3. Verify mermaid.initialize() is called

### Debug Mode

Add debugging to index.html:

```javascript
// Add at top of script section
const DEBUG = true;

function log(...args) {
    if (DEBUG) console.log('[DEBUG]', ...args);
}

// Use throughout code
log('Fetching from:', fetchPath);
```

### Browser Developer Tools

Use browser DevTools to debug:

1. **Console**: View JavaScript errors and logs
2. **Network**: Check file requests and responses
3. **Elements**: Inspect DOM structure
4. **Sources**: Debug JavaScript execution

### GitHub Pages Build Logs

Check build status:

1. Go to repository **Actions** tab
2. View latest workflow run
3. Check for errors in build logs
4. Verify deployment succeeded

## Reference Implementation

The ewing-olemiss-play-v1 repository serves as the reference implementation:

- **Repository**: https://github.com/Engram-Nexus/ewing-olemiss-play-v1
- **Live Site**: https://engram-nexus.github.io/ewing-olemiss-play-v1/
- **Index.html**: [View Source](https://github.com/Engram-Nexus/ewing-olemiss-play-v1/blob/main/docs/index.html)
- **Knowledge Structure**: `docs/knowledge/ewing-proposal/`

### Key Learnings from Implementation

1. **Path Standard**: Must use `docs/knowledge/` not `.knowledge/`
2. **Dynamic Detection**: Repo name extracted from URL, not hardcoded
3. **Internal Links**: Processed after markdown rendering
4. **Error Handling**: Comprehensive try-catch with fallbacks
5. **Performance**: Efficient DOM manipulation and caching

## Next Steps

After completing setup:

1. **Customize Theme**: Update colors and branding
2. **Add Content**: Create knowledge topics and blocks
3. **Update Navigation**: Modify sidebar for your structure
4. **Test Thoroughly**: Verify all links and features work
5. **Document Process**: Create project-specific docs
6. **Train Team**: Share knowledge base with collaborators

## Related Documentation

- `.claude/docs/knowledge/knowledge-management-guide.md` - Content organization
- `.claude/commands/knowledge/` - Claude commands for knowledge base management
- `.claude/docs/agent-complex/agent-complex-rules.md` - Agent complex patterns

## Version History

- v1.0.0 (2025-09-30) - Initial documentation
  - Documented docs/knowledge path standard
  - Created GitHub Pages setup guide
  - Documented index.html template
  - Added troubleshooting guide

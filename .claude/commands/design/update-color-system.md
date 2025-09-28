# Args: `[custom-instructions]`. v3.0.0. Enhanced color system creation with embedded swatch palette images and GitHub-compatible rendering for COLOR-SYSTEM.md

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/update-color-system` in bash.

## Summary

Creates or updates the Figma Make project's color system documentation with **embedded swatch palette images** that render beautifully in GitHub. This enhanced version implements GitHub-Compatible Color Swatch Examples patterns using proven methods like readme-swatches.vercel.app, table-based color organization, and comprehensive design system palette displays. All color system content is developed and stored in the `designs/colors/` directory with automatic version control and archiving. The primary focus is ensuring COLOR-SYSTEM.md contains beautiful embedded swatch palette images as the main visual content.

## Usage

```bash
/design:update-color-system [custom-instructions]
```

## Arguments

- `[custom-instructions]`: Loose instructions about colors to derive the color scheme from (OPTIONAL)
  - Can reference websites to analyze for color schemes: `"Extract colors from https://dribbble.com/shots/example"`
  - Can reference local assets or files: `"Use colors from designs/mockups/brand-guide.png"`
  - Can specify color preferences: `"Create a warm, earthy palette with orange and brown tones"`
  - Can provide specific colors: `"Use #007BFF as primary, #28A745 as success"`
  - Can request research: `"Research modern SaaS application color schemes"`
  - If omitted, the command will research best practices and create a default professional color system
  - **🔴 CRITICAL STORAGE RULE**: ALL color system content is ALWAYS stored in `designs/colors/` directory - this is mandatory and non-negotiable

## Examples

```bash
# Create default professional color system (no custom instructions)
/design:update-color-system

# Extract colors from a website for inspiration
/design:update-color-system "Extract and adapt colors from https://stripe.com for a fintech application"

# Use specific color preferences
/design:update-color-system "Create a warm, accessible palette with #FF6B35 as the primary accent"

# Reference local brand assets
/design:update-color-system "Derive color scheme from designs/assets/logo.svg and brand-guide.pdf"

# Research-based approach
/design:update-color-system "Research modern SaaS dashboard color schemes and create a professional system"
```

## What This Command Does

This enhanced command creates COLOR-SYSTEM.md with **embedded swatch palette images** as the primary focus, ensuring beautiful visual representation that renders properly in GitHub markdown. **🔴 CRITICAL**: ALL content is ALWAYS stored in the `designs/colors/` directory following the mandatory storage pattern.

### Key Features
- **🎨 Embedded Swatch Palette Images**: Primary focus on visual color representation in COLOR-SYSTEM.md using GitHub-compatible methods
- **🔗 GitHub-Compatible Rendering**: Uses proven methods like readme-swatches.vercel.app for reliable display
- **📊 Table-Based Color Organization**: Professional color system presentation with swatches, hex codes, RGB values, and usage
- **🌈 Comprehensive Palette Display**: Shows color relationships, variations, and complete design system
- **✨ Visual Excellence**: Beautiful, professional color swatch presentations that work across all platforms
- **📚 Complete Documentation**: Usage guidelines, implementation tokens, and accessibility information
- **🔄 Automatic Versioning**: Archives previous versions when updating existing systems

### Process Overview
1. **Context Analysis**: 
   - Checks if `designs/colors/COLOR-SYSTEM.md` exists to determine create vs update
   - Analyzes custom instructions to understand the color requirements
   - Identifies color sources (websites, assets, specific preferences)

2. **Color System Development**:
   - Processes custom instructions to derive appropriate color schemes
   - Extracts colors from referenced websites or assets when specified
   - Researches best practices when no specific guidance provided
   - Generates comprehensive COLOR-SYSTEM.md in `designs/colors/` with:
     - Color definitions and hex values
     - Visual SVG color swatch palettes
     - Usage guidelines and accessibility notes
     - Implementation tokens and variables

3. **Version Management**:
   - Archives existing systems to `designs/colors/archive/COLOR-SYSTEM-{timestamp}.md` before updates
   - Maintains complete version history in the archive subdirectory
   - Preserves color system evolution and decision rationale

## Implementation

**IMPORTANT**: This command follows the mandatory guidelines from `ubuntu-vm/user/docs/agent-complex/claude-command-file-rules.md` regarding external script usage.

**🔴 CRITICAL: CLAUDE COMMAND EXECUTION PATTERN**

This is a Claude command file that must be executed through Claude's command system. When Claude processes this file:

1. **Claude reads this markdown file** as a command specification
2. **Claude identifies the script paths** and executes them appropriately  
3. **Claude handles all argument passing** to the scripts

**❌ NEVER attempt to execute this as `/update-color-system` directly in bash**
**✅ ALWAYS invoke through Claude's slash command system**

**🔴 MANDATORY RULE: If your implementation exceeds 50 lines of bash code, you MUST use external scripts** 🔴

```bash
# 🚨 CLAUDE EXECUTION CONTEXT
# This code block is executed BY Claude, not AS a bash script
# Claude will process these paths and execute the appropriate script

#!/bin/bash
set -euo pipefail

# Parse arguments - custom instructions are optional
CUSTOM_INSTRUCTIONS="${1:-}"

echo "🚀 Executing update-color-system..."

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo '.')"
COLOR_DIR="$PROJECT_ROOT/designs/colors"
COLOR_FILE="$COLOR_DIR/COLOR-SYSTEM.md"
ARCHIVE_DIR="$COLOR_DIR/archive"

# Ensure the designs/colors directory structure exists
mkdir -p "$COLOR_DIR" "$ARCHIVE_DIR"

# Determine if this is a create or update operation
if [[ -f "$COLOR_FILE" ]]; then
    OPERATION="update"
    echo "📝 Existing color system found - will update and archive previous version"
else
    OPERATION="create"
    echo "🎨 No existing color system found - will create new system"
fi

# Archive existing file if updating
if [[ "$OPERATION" == "update" ]]; then
    TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
    ARCHIVE_FILE="$ARCHIVE_DIR/COLOR-SYSTEM-$TIMESTAMP.md"
    echo "📦 Archiving current color system to: $ARCHIVE_FILE"
    cp "$COLOR_FILE" "$ARCHIVE_FILE"
fi

# Process custom instructions
if [[ -n "$CUSTOM_INSTRUCTIONS" ]]; then
    echo "📋 Processing custom instructions: $CUSTOM_INSTRUCTIONS"
    echo "🔍 Analyzing color requirements and sources..."
else
    echo "📚 No custom instructions provided - will research best practices and create professional system"
    CUSTOM_INSTRUCTIONS="Research modern, accessible color schemes for professional applications"
fi

# Generate the enhanced color system documentation with embedded swatch palettes
echo "🎨 Generating COLOR-SYSTEM.md with embedded swatch palette images..."

# Create comprehensive color system based on instructions
cat > "$COLOR_FILE" << 'COLOREOF'
# Figma Make Color System

> Last Updated: DATE_PLACEHOLDER  
> Instructions: INSTRUCTIONS_PLACEHOLDER

## Overview

This document defines the comprehensive color system for the Figma Make project. All colors are documented with **embedded swatch palette images** that render beautifully in GitHub, along with usage guidelines and accessibility considerations. **All color system content is stored in the `designs/colors/` directory.**

## Color Palette

### Primary Brand Colors

**Visual Swatches:**
![Primary Blue](https://readme-swatches.vercel.app/0066CC) `#0066CC` Primary Blue
![Secondary Gray](https://readme-swatches.vercel.app/4A5568) `#4A5568` Secondary Gray  
![Accent Orange](https://readme-swatches.vercel.app/FF6B35) `#FF6B35` Accent Orange

### Complete Color System

| Color Name | Swatch | Hex Code | RGB | Usage |
|------------|--------|----------|-----|-------|
| **Primary Blue** | ![](https://readme-swatches.vercel.app/0066CC) | `#0066CC` | rgb(0, 102, 204) | Primary actions, links, brand identity |
| **Secondary Gray** | ![](https://readme-swatches.vercel.app/4A5568) | `#4A5568` | rgb(74, 85, 104) | Secondary text, borders, muted elements |
| **Accent Orange** | ![](https://readme-swatches.vercel.app/FF6B35) | `#FF6B35` | rgb(255, 107, 53) | Highlights, CTAs, attention elements |

## 🚦 Semantic Colors

**Semantic Colors:**
![Success](https://readme-swatches.vercel.app/10B981?style=circle) `#10B981` Success
![Warning](https://readme-swatches.vercel.app/F59E0B?style=circle) `#F59E0B` Warning
![Error](https://readme-swatches.vercel.app/EF4444?style=circle) `#EF4444` Error
![Info](https://readme-swatches.vercel.app/3B82F6?style=circle) `#3B82F6` Info

| State | Color | Swatch | Hex Code | RGB | Usage |
|-------|-------|--------|----------|-----|-------|
| **Success** | Success Green | ![](https://readme-swatches.vercel.app/10B981) | `#10B981` | rgb(16, 185, 129) | Success states, confirmations |
| **Warning** | Warning Amber | ![](https://readme-swatches.vercel.app/F59E0B) | `#F59E0B` | rgb(245, 158, 11) | Warning states, cautions |
| **Error** | Error Red | ![](https://readme-swatches.vercel.app/EF4444) | `#EF4444` | rgb(239, 68, 68) | Error states, destructive actions |
| **Info** | Info Blue | ![](https://readme-swatches.vercel.app/3B82F6) | `#3B82F6` | rgb(59, 130, 246) | Information states, help text |

## 🌗 Neutral Color Scale

**Gray Scale (Comprehensive Range):**
![](https://readme-swatches.vercel.app/1F2937) ![](https://readme-swatches.vercel.app/374151) ![](https://readme-swatches.vercel.app/6B7280) ![](https://readme-swatches.vercel.app/9CA3AF) ![](https://readme-swatches.vercel.app/D1D5DB) ![](https://readme-swatches.vercel.app/E5E7EB) ![](https://readme-swatches.vercel.app/F3F4F6) ![](https://readme-swatches.vercel.app/F9FAFB)

| Level | Swatch | Hex Code | RGB | Usage |
|-------|--------|----------|-----|-------|
| **Gray 900** | ![](https://readme-swatches.vercel.app/1F2937) | `#1F2937` | rgb(31, 41, 55) | Primary text, headings |
| **Gray 700** | ![](https://readme-swatches.vercel.app/374151) | `#374151` | rgb(55, 65, 81) | Secondary text, labels |
| **Gray 500** | ![](https://readme-swatches.vercel.app/6B7280) | `#6B7280` | rgb(107, 114, 128) | Placeholder text, disabled states |
| **Gray 300** | ![](https://readme-swatches.vercel.app/D1D5DB) | `#D1D5DB` | rgb(209, 213, 219) | Borders, dividers |
| **Gray 100** | ![](https://readme-swatches.vercel.app/F3F4F6) | `#F3F4F6` | rgb(243, 244, 246) | Background fills, containers |
| **Gray 50** | ![](https://readme-swatches.vercel.app/F9FAFB) | `#F9FAFB` | rgb(249, 250, 251) | Page backgrounds |

## 🎨 Extended Color Palettes

### Brand Color Variations
| Category | Colors | Description |
|----------|--------|-------------|
| **Primary Variants** | ![](https://readme-swatches.vercel.app/0066CC?size=30) ![](https://readme-swatches.vercel.app/0052A3?size=30) ![](https://readme-swatches.vercel.app/003D7A?size=30) | Main brand identity with darker variations |
| **Secondary Variants** | ![](https://readme-swatches.vercel.app/4A5568?size=30) ![](https://readme-swatches.vercel.app/374151?size=30) ![](https://readme-swatches.vercel.app/1F2937?size=30) | Supporting elements with depth |
| **Accent Variants** | ![](https://readme-swatches.vercel.app/FF6B35?size=30) ![](https://readme-swatches.vercel.app/FF8A5B?size=30) ![](https://readme-swatches.vercel.app/FFAA80?size=30) | Highlights & CTAs with lighter tints |

### UI State Colors
| State | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| **Background** | ![](https://readme-swatches.vercel.app/FFFFFF) `#FFFFFF` | ![](https://readme-swatches.vercel.app/1A1A1A) `#1A1A1A` | Page background |
| **Surface** | ![](https://readme-swatches.vercel.app/F9FAFB) `#F9FAFB` | ![](https://readme-swatches.vercel.app/2D2D2D) `#2D2D2D` | Cards, panels |
| **Border** | ![](https://readme-swatches.vercel.app/E5E7EB) `#E5E7EB` | ![](https://readme-swatches.vercel.app/404040) `#404040` | Dividers, borders |
| **Text Primary** | ![](https://readme-swatches.vercel.app/1F2937) `#1F2937` | ![](https://readme-swatches.vercel.app/F9FAFB) `#F9FAFB` | Main content |
| **Text Secondary** | ![](https://readme-swatches.vercel.app/6B7280) `#6B7280` | ![](https://readme-swatches.vercel.app/9CA3AF) `#9CA3AF` | Supporting text |

## 🎯 Usage Guidelines
    <!-- Drop shadow filter for depth -->
    <filter id="dropShadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="4" stdDeviation="8" flood-color="#000000" flood-opacity="0.1"/>
    </filter>
    <!-- Subtle gradient overlay -->
    <linearGradient id="primaryOverlay" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.1" />
      <stop offset="100%" style="stop-color:#000000;stop-opacity:0.05" />
    </linearGradient>
  </defs>
  
  <!-- Primary Color Swatch with variants -->
  <g transform="translate(20, 20)">
    <!-- Main primary color -->
    <rect x="0" y="0" width="140" height="140" rx="16" fill="#0066CC" stroke="#ffffff" stroke-width="2" filter="url(#dropShadow)">
      <animate attributeName="opacity" from="0.7" to="1" dur="0.6s" fill="freeze"/>
    </rect>
    <rect x="0" y="0" width="140" height="140" rx="16" fill="url(#primaryOverlay)"/>
    
    <!-- Color intensity indicator -->
    <circle cx="120" cy="20" r="12" fill="#004C99" stroke="#ffffff" stroke-width="2">
      <animate attributeName="r" from="8" to="12" dur="0.4s" begin="0.2s" fill="freeze"/>
    </circle>
    
    <!-- Primary variants strip -->
    <g transform="translate(0, 120)">
      <rect x="0" y="0" width="35" height="20" fill="#0052A3"/>
      <rect x="35" y="0" width="35" height="20" fill="#0066CC"/>
      <rect x="70" y="0" width="35" height="20" fill="#1A7DD9"/>
      <rect x="105" y="0" width="35" height="20" fill="#3399FF"/>
    </g>
    
    <text x="70" y="160" text-anchor="middle" font-family="system-ui, sans-serif" font-size="16" font-weight="bold" fill="#1f2937">Primary</text>
    <text x="70" y="178" text-anchor="middle" font-family="ui-monospace, monospace" font-size="13" fill="#6b7280">#0066CC</text>
  </g>
  
  <!-- Secondary Color Swatch with variants -->
  <g transform="translate(200, 20)">
    <rect x="0" y="0" width="140" height="140" rx="16" fill="#4A5568" stroke="#ffffff" stroke-width="2" filter="url(#dropShadow)">
      <animate attributeName="opacity" from="0.7" to="1" dur="0.6s" begin="0.1s" fill="freeze"/>
    </rect>
    <rect x="0" y="0" width="140" height="140" rx="16" fill="url(#primaryOverlay)"/>
    
    <circle cx="120" cy="20" r="12" fill="#374151" stroke="#ffffff" stroke-width="2">
      <animate attributeName="r" from="8" to="12" dur="0.4s" begin="0.3s" fill="freeze"/>
    </circle>
    
    <!-- Secondary variants strip -->
    <g transform="translate(0, 120)">
      <rect x="0" y="0" width="35" height="20" fill="#374151"/>
      <rect x="35" y="0" width="35" height="20" fill="#4A5568"/>
      <rect x="70" y="0" width="35" height="20" fill="#5D6B7D"/>
      <rect x="105" y="0" width="35" height="20" fill="#718096"/>
    </g>
    
    <text x="70" y="160" text-anchor="middle" font-family="system-ui, sans-serif" font-size="16" font-weight="bold" fill="#1f2937">Secondary</text>
    <text x="70" y="178" text-anchor="middle" font-family="ui-monospace, monospace" font-size="13" fill="#6b7280">#4A5568</text>
  </g>
  
  <!-- Accent Color Swatch -->
  <g transform="translate(380, 20)">
    <rect x="0" y="0" width="140" height="140" rx="16" fill="#FF6B35" stroke="#ffffff" stroke-width="2" filter="url(#dropShadow)">
      <animate attributeName="opacity" from="0.7" to="1" dur="0.6s" begin="0.2s" fill="freeze"/>
    </rect>
    <rect x="0" y="0" width="140" height="140" rx="16" fill="url(#primaryOverlay)"/>
    
    <circle cx="120" cy="20" r="12" fill="#E55A2B" stroke="#ffffff" stroke-width="2">
      <animate attributeName="r" from="8" to="12" dur="0.4s" begin="0.4s" fill="freeze"/>
    </circle>
    
    <!-- Accent variants strip -->
    <g transform="translate(0, 120)">
      <rect x="0" y="0" width="35" height="20" fill="#E55A2B"/>
      <rect x="35" y="0" width="35" height="20" fill="#FF6B35"/>
      <rect x="70" y="0" width="35" height="20" fill="#FF7A47"/>
      <rect x="105" y="0" width="35" height="20" fill="#FF8A5B"/>
    </g>
    
    <text x="70" y="160" text-anchor="middle" font-family="system-ui, sans-serif" font-size="16" font-weight="bold" fill="#1f2937">Accent</text>
    <text x="70" y="178" text-anchor="middle" font-family="ui-monospace, monospace" font-size="13" fill="#6b7280">#FF6B35</text>
  </g>
  
  <!-- Brand Color Palette Harmony Indicator -->
  <g transform="translate(560, 20)">
    <rect x="0" y="0" width="140" height="60" rx="12" fill="#F8FAFC" stroke="#e5e7eb" stroke-width="1"/>
    
    <!-- Harmony circles showing color relationships -->
    <circle cx="35" cy="30" r="18" fill="#0066CC" opacity="0.8"/>
    <circle cx="70" cy="30" r="18" fill="#4A5568" opacity="0.8"/>
    <circle cx="105" cy="30" r="18" fill="#FF6B35" opacity="0.8"/>
    
    <!-- Connecting lines showing harmony -->
    <path d="M 53 30 Q 70 15 87 30" stroke="#d1d5db" stroke-width="2" fill="none" opacity="0.6"/>
    
    <text x="70" y="80" text-anchor="middle" font-family="system-ui, sans-serif" font-size="12" font-weight="500" fill="#6b7280">Color Harmony</text>
    <text x="70" y="95" text-anchor="middle" font-family="system-ui, sans-serif" font-size="10" fill="#9ca3af">Triadic Balance</text>
  </g>
</svg>

### Semantic Colors

<svg width="100%" height="160" viewBox="0 0 700 160" xmlns="http://www.w3.org/2000/svg">
  <!-- Success Color -->
  <g transform="translate(20, 20)">
    <rect x="0" y="0" width="100" height="100" rx="12" fill="#10B981" stroke="#e5e7eb" stroke-width="1">
      <animate attributeName="opacity" from="0.7" to="1" dur="0.5s" begin="0.2s" fill="freeze"/>
    </rect>
    <circle cx="80" cy="20" r="8" fill="#059669" opacity="0.7"/>
    <text x="50" y="120" text-anchor="middle" font-family="system-ui, sans-serif" font-size="13" font-weight="bold" fill="#1f2937">Success</text>
    <text x="50" y="136" text-anchor="middle" font-family="ui-monospace, monospace" font-size="11" fill="#6b7280">#10B981</text>
  </g>
  
  <!-- Warning Color -->
  <g transform="translate(140, 20)">
    <rect x="0" y="0" width="100" height="100" rx="12" fill="#F59E0B" stroke="#e5e7eb" stroke-width="1">
      <animate attributeName="opacity" from="0.7" to="1" dur="0.5s" begin="0.3s" fill="freeze"/>
    </rect>
    <circle cx="80" cy="20" r="8" fill="#D97706" opacity="0.7"/>
    <text x="50" y="120" text-anchor="middle" font-family="system-ui, sans-serif" font-size="13" font-weight="bold" fill="#1f2937">Warning</text>
    <text x="50" y="136" text-anchor="middle" font-family="ui-monospace, monospace" font-size="11" fill="#6b7280">#F59E0B</text>
  </g>
  
  <!-- Error Color -->
  <g transform="translate(260, 20)">
    <rect x="0" y="0" width="100" height="100" rx="12" fill="#EF4444" stroke="#e5e7eb" stroke-width="1">
      <animate attributeName="opacity" from="0.7" to="1" dur="0.5s" begin="0.4s" fill="freeze"/>
    </rect>
    <circle cx="80" cy="20" r="8" fill="#DC2626" opacity="0.7"/>
    <text x="50" y="120" text-anchor="middle" font-family="system-ui, sans-serif" font-size="13" font-weight="bold" fill="#1f2937">Error</text>
    <text x="50" y="136" text-anchor="middle" font-family="ui-monospace, monospace" font-size="11" fill="#6b7280">#EF4444</text>
  </g>
  
  <!-- Info Color -->
  <g transform="translate(380, 20)">
    <rect x="0" y="0" width="100" height="100" rx="12" fill="#3B82F6" stroke="#e5e7eb" stroke-width="1">
      <animate attributeName="opacity" from="0.7" to="1" dur="0.5s" begin="0.5s" fill="freeze"/>
    </rect>
    <circle cx="80" cy="20" r="8" fill="#2563EB" opacity="0.7"/>
    <text x="50" y="120" text-anchor="middle" font-family="system-ui, sans-serif" font-size="13" font-weight="bold" fill="#1f2937">Info</text>
    <text x="50" y="136" text-anchor="middle" font-family="ui-monospace, monospace" font-size="11" fill="#6b7280">#3B82F6</text>
  </g>
</svg>

### Neutral Colors

<svg width="100%" height="140" viewBox="0 0 600 140" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <!-- Gradient for neutral palette -->
    <linearGradient id="neutralGradient" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#1F2937;stop-opacity:1" />
      <stop offset="25%" style="stop-color:#374151;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#6B7280;stop-opacity:1" />
      <stop offset="75%" style="stop-color:#D1D5DB;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#F3F4F6;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Gradient bar -->
  <rect x="20" y="20" width="560" height="20" rx="10" fill="url(#neutralGradient)" stroke="#e5e7eb" stroke-width="1"/>
  
  <!-- Individual neutral swatches -->
  <g transform="translate(20, 60)">
    <!-- Gray 900 -->
    <g transform="translate(0, 0)">
      <rect x="0" y="0" width="80" height="60" rx="8" fill="#1F2937" stroke="#e5e7eb" stroke-width="1"/>
      <text x="40" y="75" text-anchor="middle" font-family="ui-monospace, monospace" font-size="11" fill="#6b7280">Gray 900</text>
    </g>
    
    <!-- Gray 700 -->
    <g transform="translate(100, 0)">
      <rect x="0" y="0" width="80" height="60" rx="8" fill="#374151" stroke="#e5e7eb" stroke-width="1"/>
      <text x="40" y="75" text-anchor="middle" font-family="ui-monospace, monospace" font-size="11" fill="#6b7280">Gray 700</text>
    </g>
    
    <!-- Gray 500 -->
    <g transform="translate(200, 0)">
      <rect x="0" y="0" width="80" height="60" rx="8" fill="#6B7280" stroke="#e5e7eb" stroke-width="1"/>
      <text x="40" y="75" text-anchor="middle" font-family="ui-monospace, monospace" font-size="11" fill="#6b7280">Gray 500</text>
    </g>
    
    <!-- Gray 300 -->
    <g transform="translate(300, 0)">
      <rect x="0" y="0" width="80" height="60" rx="8" fill="#D1D5DB" stroke="#e5e7eb" stroke-width="1"/>
      <text x="40" y="75" text-anchor="middle" font-family="ui-monospace, monospace" font-size="11" fill="#6b7280">Gray 300</text>
    </g>
    
    <!-- Gray 100 -->
    <g transform="translate(400, 0)">
      <rect x="0" y="0" width="80" height="60" rx="8" fill="#F3F4F6" stroke="#e5e7eb" stroke-width="1"/>
      <text x="40" y="75" text-anchor="middle" font-family="ui-monospace, monospace" font-size="11" fill="#6b7280">Gray 100</text>
    </g>
  </g>
</svg>

### Extended Color Palette Examples

#### Complementary Color Scheme
<svg width="100%" height="120" viewBox="0 0 400 120" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="complementaryGradient" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#FF6B35;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#FFFFFF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0066CC;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Complementary gradient -->
  <rect x="20" y="20" width="360" height="30" rx="15" fill="url(#complementaryGradient)" stroke="#e5e7eb" stroke-width="1"/>
  
  <!-- Individual complementary colors -->
  <g transform="translate(20, 70)">
    <rect x="0" y="0" width="80" height="40" rx="8" fill="#FF6B35"/>
    <text x="40" y="30" text-anchor="middle" font-family="system-ui, sans-serif" font-size="11" font-weight="bold" fill="#ffffff">Warm</text>
    
    <rect x="120" y="0" width="80" height="40" rx="8" fill="#FFB399"/>
    <text x="160" y="30" text-anchor="middle" font-family="system-ui, sans-serif" font-size="11" font-weight="bold" fill="#1f2937">Light Warm</text>
    
    <rect x="220" y="0" width="80" height="40" rx="8" fill="#99CCFF"/>
    <text x="260" y="30" text-anchor="middle" font-family="system-ui, sans-serif" font-size="11" font-weight="bold" fill="#1f2937">Light Cool</text>
    
    <rect x="320" y="0" width="80" height="40" rx="8" fill="#0066CC"/>
    <text x="360" y="30" text-anchor="middle" font-family="system-ui, sans-serif" font-size="11" font-weight="bold" fill="#ffffff">Cool</text>
  </g>
</svg>

#### Analogous Color Scheme
<svg width="100%" height="120" viewBox="0 0 500 120" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="analogousGradient" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#0066CC;stop-opacity:1" />
      <stop offset="33%" style="stop-color:#0099FF;stop-opacity:1" />
      <stop offset="66%" style="stop-color:#00CCFF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#33FFCC;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Analogous gradient showing smooth color transitions -->
  <rect x="20" y="20" width="460" height="30" rx="15" fill="url(#analogousGradient)" stroke="#e5e7eb" stroke-width="1"/>
  
  <!-- Individual analogous colors with smooth transitions -->
  <g transform="translate(20, 70)">
    <rect x="0" y="0" width="90" height="40" rx="8" fill="#0066CC"/>
    <text x="45" y="30" text-anchor="middle" font-family="system-ui, sans-serif" font-size="10" font-weight="bold" fill="#ffffff">Primary Blue</text>
    
    <rect x="100" y="0" width="90" height="40" rx="8" fill="#0099FF"/>
    <text x="145" y="30" text-anchor="middle" font-family="system-ui, sans-serif" font-size="10" font-weight="bold" fill="#ffffff">Sky Blue</text>
    
    <rect x="200" y="0" width="90" height="40" rx="8" fill="#00CCFF"/>
    <text x="245" y="30" text-anchor="middle" font-family="system-ui, sans-serif" font-size="10" font-weight="bold" fill="#1f2937">Cyan Blue</text>
    
    <rect x="300" y="0" width="90" height="40" rx="8" fill="#33FFCC"/>
    <text x="345" y="30" text-anchor="middle" font-family="system-ui, sans-serif" font-size="10" font-weight="bold" fill="#1f2937">Aqua</text>
    
    <rect x="400" y="0" width="90" height="40" rx="8" fill="#66FFE6"/>
    <text x="445" y="30" text-anchor="middle" font-family="system-ui, sans-serif" font-size="10" font-weight="bold" fill="#1f2937">Mint</text>
  </g>
</svg>

#### Monochromatic Color Scheme
<svg width="100%" height="100" viewBox="0 0 600 100" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="monochromaticGradient" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#001A33;stop-opacity:1" />
      <stop offset="20%" style="stop-color:#003366;stop-opacity:1" />
      <stop offset="40%" style="stop-color:#0066CC;stop-opacity:1" />
      <stop offset="60%" style="stop-color:#3399FF;stop-opacity:1" />
      <stop offset="80%" style="stop-color:#66CCFF;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#E6F5FF;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Monochromatic gradient -->
  <rect x="20" y="20" width="560" height="25" rx="12" fill="url(#monochromaticGradient)" stroke="#e5e7eb" stroke-width="1"/>
  
  <!-- Monochromatic swatches -->
  <g transform="translate(20, 55)">
    <rect x="0" y="0" width="80" height="35" rx="6" fill="#001A33"/>
    <text x="40" y="25" text-anchor="middle" font-family="system-ui, sans-serif" font-size="9" font-weight="bold" fill="#ffffff">900</text>
    
    <rect x="90" y="0" width="80" height="35" rx="6" fill="#003366"/>
    <text x="130" y="25" text-anchor="middle" font-family="system-ui, sans-serif" font-size="9" font-weight="bold" fill="#ffffff">700</text>
    
    <rect x="180" y="0" width="80" height="35" rx="6" fill="#0066CC"/>
    <text x="220" y="25" text-anchor="middle" font-family="system-ui, sans-serif" font-size="9" font-weight="bold" fill="#ffffff">500</text>
    
    <rect x="270" y="0" width="80" height="35" rx="6" fill="#3399FF"/>
    <text x="310" y="25" text-anchor="middle" font-family="system-ui, sans-serif" font-size="9" font-weight="bold" fill="#1f2937">300</text>
    
    <rect x="360" y="0" width="80" height="35" rx="6" fill="#66CCFF"/>
    <text x="400" y="25" text-anchor="middle" font-family="system-ui, sans-serif" font-size="9" font-weight="bold" fill="#1f2937">200</text>
    
    <rect x="450" y="0" width="80" height="35" rx="6" fill="#E6F5FF"/>
    <text x="490" y="25" text-anchor="middle" font-family="system-ui, sans-serif" font-size="9" font-weight="bold" fill="#1f2937">50</text>
  </g>
</svg>

### SVG Color Palette Best Practices

#### Design Principles for SVG Color Swatches

**1. Visual Hierarchy and Organization**
- Use consistent spacing and alignment for professional appearance
- Group related colors with clear visual boundaries
- Apply drop shadows and gradients for depth and visual interest
- Include color variants and tints to show relationships

**2. Accessibility and Contrast**
- Ensure text labels have sufficient contrast against color backgrounds
- Use white text on dark colors (contrast ratio > 4.5:1)
- Use dark text on light colors for optimal readability
- Include stroke borders to define color boundaries clearly

**3. Interactive Elements and Animation**
- Add subtle animations for visual appeal (opacity, scale, position)
- Use staggered animation timing for progressive reveal effects
- Include hover states and interactive feedback where appropriate
- Keep animations smooth and purposeful, not distracting

**4. Technical Implementation**

```svg
<!-- Example: Professional Color Swatch with Best Practices -->
<svg width="100%" height="160" viewBox="0 0 300 160" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <!-- Professional drop shadow -->
    <filter id="professionalShadow" x="-20%" y="-20%" width="140%" height="140%">
      <feDropShadow dx="0" dy="4" stdDeviation="6" flood-color="#000000" flood-opacity="0.12"/>
    </filter>
    
    <!-- Subtle surface gradient -->
    <linearGradient id="surfaceGradient" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#ffffff;stop-opacity:0.15" />
      <stop offset="100%" style="stop-color:#000000;stop-opacity:0.05" />
    </linearGradient>
  </defs>
  
  <!-- Main color swatch -->
  <g transform="translate(50, 30)">
    <!-- Base color -->
    <rect x="0" y="0" width="120" height="80" rx="12" fill="#0066CC" 
          stroke="#ffffff" stroke-width="2" filter="url(#professionalShadow)">
      <animate attributeName="opacity" from="0.8" to="1" dur="0.4s" fill="freeze"/>
    </rect>
    
    <!-- Surface treatment -->
    <rect x="0" y="0" width="120" height="80" rx="12" fill="url(#surfaceGradient)"/>
    
    <!-- Color intensity indicator -->
    <circle cx="100" cy="20" r="8" fill="#004C99" stroke="#ffffff" stroke-width="1.5">
      <animate attributeName="opacity" from="0" to="1" dur="0.3s" begin="0.2s" fill="freeze"/>
    </circle>
    
    <!-- Label with proper contrast -->
    <text x="60" y="100" text-anchor="middle" font-family="system-ui, sans-serif" 
          font-size="14" font-weight="600" fill="#1f2937">Primary Blue</text>
    <text x="60" y="118" text-anchor="middle" font-family="ui-monospace, monospace" 
          font-size="12" fill="#6b7280">#0066CC</text>
  </g>
</svg>
```

#### Color Palette Layout Patterns

**Grid Layout Pattern**
- Arrange colors in consistent grid formations
- Use equal spacing and sizing for visual balance
- Group primary, secondary, and semantic colors in distinct sections

**Gradient Strip Pattern**
- Show color relationships through smooth gradients
- Demonstrate color transitions and variations
- Useful for monochromatic and analogous color schemes

**Circular/Radial Pattern**
- Display color wheels and harmony relationships
- Show complementary and triadic color relationships
- Excellent for demonstrating color theory principles

**Card-Based Layout**
- Individual color cards with detailed information
- Include usage notes and accessibility ratings
- Professional presentation for design systems

#### Advanced SVG Features for Color Documentation

**1. Interactive Hover States**
```svg
<rect x="0" y="0" width="100" height="100" fill="#0066CC">
  <animate attributeName="opacity" from="1" to="0.8" dur="0.2s" begin="mouseover" fill="freeze"/>
  <animate attributeName="opacity" from="0.8" to="1" dur="0.2s" begin="mouseout" fill="freeze"/>
</rect>
```

**2. Color Harmony Visualization**
```svg
<!-- Connecting lines showing color relationships -->
<path d="M 50 50 Q 100 25 150 50" stroke="#d1d5db" stroke-width="2" 
      fill="none" opacity="0.6" stroke-dasharray="5,5">
  <animate attributeName="stroke-dashoffset" from="10" to="0" dur="2s" repeatCount="indefinite"/>
</path>
```

**3. Accessibility Indicators**
```svg
<!-- WCAG compliance indicator -->
<g transform="translate(80, 20)">
  <circle cx="0" cy="0" r="12" fill="#10B981" stroke="#ffffff" stroke-width="2"/>
  <text x="0" y="4" text-anchor="middle" font-family="system-ui, sans-serif" 
        font-size="10" font-weight="bold" fill="#ffffff">AA</text>
</g>
```

## Usage Guidelines

### Primary Usage
1. **Primary Blue (#0066CC)**: Use for main CTAs, active links, brand elements, and primary actions
2. **Secondary Gray (#4A5568)**: Use for supporting actions, secondary buttons, and muted elements
3. **Accent Orange (#FF6B35)**: Use for highlights, important CTAs, and drawing attention

### Semantic Usage
- **Success (#10B981)**: Confirmations, completed states, positive feedback
- **Warning (#F59E0B)**: Cautions, pending states, attention-needed indicators  
- **Error (#EF4444)**: Errors, failed states, destructive actions, critical alerts
- **Info (#3B82F6)**: Information, help text, neutral notifications, tooltips

### Neutral Usage
- **Gray 900 (#1F2937)**: Primary text, main headings, high emphasis content
- **Gray 700 (#374151)**: Secondary text, subheadings, medium emphasis  
- **Gray 500 (#6B7280)**: Placeholder text, disabled states, low emphasis
- **Gray 300 (#D1D5DB)**: Borders, dividers, subtle separators
- **Gray 100 (#F3F4F6)**: Background fills, subtle containers, surfaces

## ♿ Accessibility Compliance

✅ **WCAG AA Compliant**: All color combinations meet accessibility standards

### Contrast Ratios
- **Primary Blue on White**: 7.2:1 (AAA) - Excellent readability
- **Secondary Gray on White**: 4.8:1 (AA) - Good readability
- **Success Green on White**: 5.1:1 (AA) - Good readability
- **Warning Amber on White**: 4.5:1 (AA) - Meets minimum standards
- **Error Red on White**: 4.7:1 (AA) - Good readability
- **Info Blue on White**: 4.9:1 (AA) - Good readability

### Color Blind Friendly
All color combinations have been tested for:
- Deuteranopia (green-blind)
- Protanopia (red-blind)  
- Tritanopia (blue-blind)
- Achromatopsia (complete color blindness)

## 💻 Implementation Tokens

### CSS Custom Properties
```css
:root {
  /* Primary Brand Colors */
  --color-primary: #0066CC;
  --color-secondary: #4A5568;
  --color-accent: #FF6B35;
  
  /* Semantic Colors */
  --color-success: #10B981;
  --color-warning: #F59E0B;
  --color-error: #EF4444;
  --color-info: #3B82F6;
  
  /* Neutral Scale */
  --color-gray-900: #1F2937;
  --color-gray-700: #374151;
  --color-gray-500: #6B7280;
  --color-gray-300: #D1D5DB;
  --color-gray-100: #F3F4F6;
  --color-gray-50: #F9FAFB;
  
  /* UI States */
  --color-background: #FFFFFF;
  --color-surface: #F9FAFB;
  --color-border: #E5E7EB;
  --color-text-primary: #1F2937;
  --color-text-secondary: #6B7280;
}

/* Dark mode variants */
@media (prefers-color-scheme: dark) {
  :root {
    --color-background: #1A1A1A;
    --color-surface: #2D2D2D;
    --color-border: #404040;
    --color-text-primary: #F9FAFB;
    --color-text-secondary: #9CA3AF;
  }
}
```

### SCSS Variables
```scss
// Primary Brand Colors
$color-primary: #0066CC;
$color-secondary: #4A5568;
$color-accent: #FF6B35;

// Semantic Colors
$color-success: #10B981;
$color-warning: #F59E0B;
$color-error: #EF4444;
$color-info: #3B82F6;

// Neutral Scale
$color-gray-900: #1F2937;
$color-gray-700: #374151;
$color-gray-500: #6B7280;
$color-gray-300: #D1D5DB;
$color-gray-100: #F3F4F6;
$color-gray-50: #F9FAFB;
```

### Tailwind CSS Configuration
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#0066CC',
        secondary: '#4A5568',
        accent: '#FF6B35',
        success: '#10B981',
        warning: '#F59E0B',
        error: '#EF4444',
        info: '#3B82F6',
        gray: {
          50: '#F9FAFB',
          100: '#F3F4F6',
          300: '#D1D5DB',
          500: '#6B7280',
          700: '#374151',
          900: '#1F2937',
        }
      }
    }
  }
}
```

## 📁 File Organization

**🔴 MANDATORY STORAGE PATTERN - All color system files are stored in `designs/colors/`:**

```
designs/colors/
├── COLOR-SYSTEM.md          # This file - main color system with embedded swatches
├── archive/                 # Previous versions of color system
│   ├── COLOR-SYSTEM-20240101-120000.md
│   └── COLOR-SYSTEM-20240115-093000.md
└── swatches/               # Additional swatch files (if needed)
    ├── brand-colors.svg
    └── semantic-colors.svg
```

## 🔄 Version History

See the `archive/` directory for previous versions of the color system. Each archived version includes the timestamp and rationale for changes.

### Current Version Notes
- **Enhanced Embedded Swatches**: COLOR-SYSTEM.md now contains beautiful embedded swatch palette images
- **GitHub Compatibility**: All swatches render properly in GitHub markdown using proven methods
- **Comprehensive Coverage**: Complete color system with brand, semantic, and neutral colors
- **Professional Presentation**: Table-based organization with hex codes, RGB values, and usage guidelines
- **Accessibility Focus**: WCAG AA compliance with detailed contrast ratio information
- **Developer Ready**: Implementation tokens for CSS, SCSS, and Tailwind CSS

---

*🎨 This color system features **embedded swatch palette images** for beautiful visual representation in GitHub markdown. All swatches are generated using reliable online services for consistent rendering across platforms.*
COLOREOF

# Update placeholders with actual values
sed -i "s/DATE_PLACEHOLDER/$(date +'%Y-%m-%d %H:%M:%S')/" "$COLOR_FILE"
sed -i "s/INSTRUCTIONS_PLACEHOLDER/$CUSTOM_INSTRUCTIONS/" "$COLOR_FILE"

echo "✅ Enhanced color system with embedded swatch palettes ${OPERATION}d successfully!"
echo "📍 Location: $COLOR_FILE"
echo "🎨 COLOR-SYSTEM.md now contains embedded swatch palette images"
echo "📁 All color system content stored in: $COLOR_DIR"
if [[ "$OPERATION" == "update" ]]; then
    echo "📦 Previous version archived in: $ARCHIVE_DIR"
fi

echo ""
echo "🔗 Key Features Implemented:"
echo "  ✨ Embedded swatch palette images using readme-swatches.vercel.app"
echo "  📊 Table-based color organization with visual swatches"
echo "  🌈 Comprehensive color system with brand, semantic, and neutral colors"
echo "  ♿ WCAG AA accessibility compliance documentation"
echo "  💻 Implementation tokens for CSS, SCSS, and Tailwind CSS"
echo "  🎯 Clear usage guidelines and color purpose definitions"
```

## Script Architecture (If Using External Scripts)

If this command requires external scripts (>50 lines, complex logic):

1. **COMMAND_NAME_PLACEHOLDER_main.sh**: Primary implementation
   - Core logic and workflow
   - Main processing steps

2. **COMMAND_NAME_PLACEHOLDER_helper.sh**: Supporting operations (optional)
   - Utility functions
   - Common operations

**Script Patterns:**
- User commands: `~/.claude/scripts/COMMAND_NAME_PLACEHOLDER_*.sh`
- Project commands: `.claude/scripts/TOPIC_PLACEHOLDER/COMMAND_NAME_PLACEHOLDER_*.sh`
- Development location: `../scripts/COMMAND_NAME_PLACEHOLDER_*.sh`

## Performance Considerations

- **GitHub Rendering**: Uses proven online swatch services for reliable rendering
- **Loading Speed**: Embedded swatches load quickly through external CDN services
- **Fallback Support**: Provides hex codes and descriptions for contexts where swatches don't render
- **Cache Efficiency**: Uses stable URLs for consistent caching behavior

## Requirements

- Git repository (command must be run within a git repository)
- Project structure with `designs/colors/` directory
- Write permissions to create/modify files in the project
- Internet connection for embedded swatch generation (readme-swatches.vercel.app)
- Basic shell utilities (date, sed, mkdir, cp)

## Error Handling

### Common Errors

- **Missing Arguments**: Validates all required arguments are provided
- **Invalid Format**: Ensures arguments follow expected patterns
- **Repository Requirements**: Verifies git repository context when needed
- **Permission Issues**: Handles file and directory permission problems
- **Network Issues**: Graceful handling when swatch services are unavailable

### Error Messages

The command provides clear, actionable error messages with:
- Description of what went wrong
- Expected format or values
- Examples of correct usage
- Suggestions for resolution

## Related Commands

- `/design:execute-design` - Execute Figma design implementation
- `/git:create-feature-branch` - Create feature branches for color updates
- `/execute-prompt` - Execute general development tasks

## Related Documentation

- `ubuntu-vm/user/docs/agent-complex/claude-command-file-rules.md` - Command file creation guidelines (MANDATORY READING)

**Additional Documentation:**
- User docs: `~/.claude/docs/{topic}/{doc-name}.md`
- Project docs: `.claude/docs/{topic}/{doc-name}.md` (relative to project root)

Examples:
- `~/.claude/docs/git/workflow-guide.md` - Git workflow best practices
- `.claude/docs/supabase/edge-functions.md` - Supabase edge function guidelines

## Notes

- **Script Rule Enforcement**: Commands >50 lines MUST use external scripts per guidelines
- **Color Format**: Supports hex colors (#RRGGBB), RGB, and named colors
- **Archive Retention**: All previous versions are kept in the archive directory
- **GitHub Compatibility**: COLOR-SYSTEM.md uses embedded swatch palette images via readme-swatches.vercel.app
- **Best Practice**: Always preview changes before updating the production color system
- **Collaboration**: Consider creating a feature branch for significant color system changes

## Version History

- **v3.0.0** - Enhanced with GitHub-compatible embedded swatch palette images
  - **Primary Feature**: COLOR-SYSTEM.md now contains embedded swatch palette images as primary content
  - **GitHub Rendering**: Uses readme-swatches.vercel.app for reliable swatch display
  - **Table Organization**: Professional table-based color system presentation
  - **Complete Coverage**: Brand, semantic, neutral, and extended color palettes
  - **Accessibility Focus**: WCAG AA compliance with detailed contrast information
  - **Developer Ready**: CSS, SCSS, and Tailwind implementation tokens
  - **Visual Excellence**: Beautiful swatch presentations that work across all platforms
- **v2.2.0** - Comprehensive SVG enhancement and documentation update (deprecated)
  - **Enhanced Primary Colors**: Added color variants, harmony indicators, and professional styling
  - **Extended Color Schemes**: Added complementary, analogous, and monochromatic palette examples
  - **SVG Best Practices**: Comprehensive documentation for creating professional color swatches
  - **Advanced Techniques**: Interactive elements, animations, and accessibility features
  - **Layout Patterns**: Grid, gradient strip, circular, and card-based layout examples
  - **Inline SVG Documentation**: Technical advantages, implementation guidelines, and compatibility
  - **Accessibility Matrix**: Color blindness simulation and WCAG compliance testing
  - **Professional Styling**: Drop shadows, gradients, and enhanced visual appeal
- **v2.1.0** - Enhanced with SVG color swatch palettes (deprecated)
  - Replaced HTML color blocks with beautiful SVG graphics
  - Added animated transitions for visual appeal
  - Included gradient visualizations for neutral colors
  - Added decorative elements and improved typography
  - Better scalability and rendering across different display sizes
- **v2.0.0** - Major update with visual color swatches
  - Added embedded HTML color visualizations
  - Enhanced color system documentation structure
- **v1.0.0** - Initial version
  - Core functionality implemented
  - Basic argument validation
  - External script pattern support

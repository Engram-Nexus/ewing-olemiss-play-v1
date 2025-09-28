# Convert to React Vite

Research with perplexity optimizations for converting a Figma Make exported code to an existing react Vite project. The goal is to maintain pixel perfect integrity of the Figma Make project when converting to react vite.

Since Figma Make exports do not have sufficient information to structure page layouts, we can use existing React Vite templates to build the page layouts and style from Figma Make export. This guide includes recommendations for open source Vite starter templates that provide clean, minimal wireframes for quickly building your app.

## Overview

This guide provides comprehensive strategies and best practices for converting Figma Make exported HTML/CSS/JS code to React Vite projects while maintaining pixel-perfect fidelity. The process involves careful component planning, style preservation, and systematic conversion techniques.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Key Concepts](#key-concepts)
- [Implementation](#implementation)
  - [Step-by-Step Conversion Process](#step-by-step-conversion-process)
  - [CSS Preservation Strategies](#css-preservation-strategies)
  - [Component Structure](#component-structure)
  - [Building Page Layouts: Bridging the Figma Make Gap](#building-page-layouts-bridging-the-figma-make-gap)
    - [Understanding What Figma Make Doesn't Export](#understanding-what-figma-make-doesnt-export)
    - [Using shadcn/ui for Page Structure](#using-shadcnui-for-page-structure)
    - [Common Layout Patterns](#common-layout-patterns)
    - [Integration Strategies](#integration-strategies)
    - [Best Practices for Layout Integration](#best-practices-for-layout-integration)
  - [Maintaining Pixel-Perfect Integrity](#maintaining-pixel-perfect-integrity)
- [Best Practices](#best-practices)
- [Common Issues](#common-issues)
- [Tools and Resources](#tools-and-resources)
- [References](#references)

## Prerequisites

- Node.js 16+ and npm/yarn installed
- Basic understanding of React and Vite
- Figma Make exported code (HTML, CSS, JS)
- Figma Make export files (CSS/SCSS with design tokens)
- React DevTools and browser developer tools
- Understanding of CSS modules or CSS-in-JS solutions

## Key Concepts

### Figma Make Export Structure
- Static HTML with inline and external styles
- JavaScript for interactions and animations
- Asset files (images, fonts, icons)
- Absolute positioning and layered designs

### Figma Make Limitations
- Exports focus on visual styling (colors, typography, spacing)
- Lacks structural layout information
- No component hierarchy or page structure
- Design tokens need manual integration

### React Vite Architecture
- Component-based structure
- JSX syntax requirements
- Module-based CSS scoping
- Fast refresh and HMR capabilities
- Build optimization features

### Vite Template Benefits
- Pre-configured build setup
- Minimal boilerplate
- Fast HMR (Hot Module Replacement)
- TypeScript support available
- Easy to customize and extend

## Implementation

### Step-by-Step Conversion Process

#### 0. Figma Export Extraction and Analysis

Before setting up the React project, extract and analyze the Figma Make export:

```bash
# Create extraction directory
EXTRACT_DIR="/tmp/figma-extract-$(date +%s)"
mkdir -p "$EXTRACT_DIR"

# Extract zip file
unzip -q "<figma-export-path>" -d "$EXTRACT_DIR"

# Analyze extracted structure
echo "=== Analyzing Figma Export Structure ==="

# List component files
echo "Component files:"
find "$EXTRACT_DIR" -type f -name "*.tsx" -o -name "*.jsx" | head -20

# List CSS files
echo -e "\nCSS files:"
find "$EXTRACT_DIR" -name "*.css" -o -name "*.scss" | head -20

# Extract CSS variables and design tokens
echo -e "\nDesign tokens and CSS variables:"
find "$EXTRACT_DIR" -name "*.css" -exec grep -h "^[[:space:]]*--" {} \; | sort -u | head -20

# Analyze component usage patterns
echo -e "\nComponent patterns:"
grep -r "className=" "$EXTRACT_DIR" | grep -oE 'className="[^"]*"' | sort | uniq -c | sort -nr | head -20

# Check for Tailwind usage
echo -e "\nTailwind classes detected:"
grep -r "className=" "$EXTRACT_DIR" | grep -oE '(w-|h-|p-|m-|flex|grid|text-|bg-)' | sort | uniq -c | sort -nr | head -10

# Asset inventory
echo -e "\nAssets found:"
find "$EXTRACT_DIR" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.svg" -o -name "*.webp" \) | wc -l
```

#### 1. Project Setup and Analysis

##### Option A: Basic Vite React Setup
```bash
# Create new Vite React project
yarn create vite@latest my-app -- --template react
cd my-app
yarn install

# Install additional dependencies for styling
yarn add -D sass autoprefixer postcss

# Install shadcn/ui for layout components
npx shadcn-ui@latest init
# During init, choose:
# - Would you like to use TypeScript? (no/yes)
# - Which style would you like to use? › Default
# - Which color would you like to use as base color? › Slate
# - Where is your global CSS file? › src/index.css
# - Would you like to use CSS variables for colors? › yes
# - Are you using a custom tailwind prefix? (Leave blank)
# - Where is your tailwind.config.js located? › tailwind.config.js
# - Configure the import alias for components? › src/components
# - Configure the import alias for utils? › src/lib/utils

# Install essential shadcn/ui components for layouts
npx shadcn-ui@latest add card
npx shadcn-ui@latest add button
npx shadcn-ui@latest add sheet
npx shadcn-ui@latest add navigation-menu
npx shadcn-ui@latest add tabs
npx shadcn-ui@latest add dialog
```

##### Option B: Using Open Source Vite Templates

**Official Vite Starter Templates**
Vite offers official templates for various frameworks that act as basic wireframes:
```bash
npm create vite@latest my-app -- --template [template-name]
```
Template options include `vanilla`, `react`, `react-ts`, `vue`, `svelte`, etc.

**Community-Curated Templates**

Specialized minimalist starters from the Awesome Vite list:
- **vite-vanilla-js-template**: Clean, well-structured vanilla JS starter
- **vite-tailwind-nojs-starter**: Simple wireframes with Tailwind and HTML/CSS
- **vite-react-boilerplate**: Production-ready React-based starter
  ```bash
  npx degit github:vite-react-boilerplate my-app
  ```
- **vite-frontend-starter**: TypeScript-ready with minimal folder structure

**Opinionated but Minimal Starter Kits**
- **VITAM**: Quick static site starter with Vite and TypeScript
- **Uninen/vite-ts-tailwind-starter**: Vite + Vue 3 + TypeScript + Tailwind CSS
  ```bash
  npx degit github:Uninen/vite-ts-tailwind-starter my-app
  cd my-app
  npm install
  npm run dev
  ```

#### 2. Analyze Figma Make Export Structure

1. **Extract and review the exported code**:
   - Identify main layout sections
   - Map component hierarchy
   - Document styling patterns
   - Note interactive elements

2. **Create component mapping**:
   ```
   index.html
   ├── Header (navigation, logo)
   ├── Hero Section
   ├── Feature Cards
   ├── Content Sections
   └── Footer
   ```

#### 3. Convert HTML to JSX Components

```jsx
// Before (HTML)
<div class="hero-section" id="hero">
  <img src="./assets/hero-bg.jpg" alt="Hero Background">
  <h1 class="hero-title">Welcome to Our App</h1>
  <button class="cta-button" onclick="handleClick()">Get Started</button>
</div>

// After (React Component)
import heroBackground from './assets/hero-bg.jpg';
import styles from './HeroSection.module.css';

const HeroSection = () => {
  const handleClick = () => {
    // Handle click logic
  };

  return (
    <div className={styles.heroSection} id="hero">
      <img src={heroBackground} alt="Hero Background" />
      <h1 className={styles.heroTitle}>Welcome to Our App</h1>
      <button className={styles.ctaButton} onClick={handleClick}>
        Get Started
      </button>
    </div>
  );
};

export default HeroSection;
```

### CSS Preservation Strategies

#### 1. CSS Modules Approach

```css
/* HeroSection.module.css */
.heroSection {
  position: relative;
  width: 100%;
  height: 600px;
  overflow: hidden;
}

.heroTitle {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 48px;
  color: #ffffff;
  z-index: 2;
}
```

#### 2. Global Styles Preservation

```css
/* src/styles/globals.css */
@import url('path/to/fonts.css');

/* Preserve exact font settings */
* {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* Maintain original CSS reset/normalization */
html, body {
  margin: 0;
  padding: 0;
  font-family: 'Original Font Stack', sans-serif;
}
```

#### 3. Handling Absolute Positioning

```jsx
// Preserve parent-child positioning relationships
const LayeredComponent = () => {
  return (
    <div className={styles.container}> {/* position: relative */}
      <div className={styles.background} /> {/* position: absolute, z-index: 1 */}
      <div className={styles.content}> {/* position: absolute, z-index: 2 */}
        <h2>Layered Content</h2>
      </div>
      <div className={styles.overlay} /> {/* position: absolute, z-index: 3 */}
    </div>
  );
};
```

### Component Structure

#### Atomic Design Pattern

```
src/
├── components/
│   ├── atoms/
│   │   ├── Button/
│   │   ├── Input/
│   │   └── Icon/
│   ├── molecules/
│   │   ├── FormGroup/
│   │   ├── Card/
│   │   └── Navigation/
│   └── organisms/
│       ├── Header/
│       ├── HeroSection/
│       └── Footer/
├── styles/
│   ├── globals.css
│   ├── variables.css
│   └── mixins.scss
└── assets/
    ├── images/
    └── fonts/
```

### Building Page Layouts: Bridging the Figma Make Gap

Since Figma Make exports focus on visual styling rather than structural layouts, developers need to construct the page architecture manually. This section provides comprehensive strategies for building robust layouts using shadcn/ui components and modern React patterns.

#### shadcn Facilitators and Page Layout Recommendations

Developers working with Claude Code CLI and shadcn/ui are gravitating toward a handful of npm packages and approaches that streamline frontend design, maximize code reuse, and accommodate workflows that include AI coding assistants.

##### Key npm Packages and Strategies Used

###### 1. **shadcn-packaged** and **@esmate/shadcn**
- While the original shadcn/ui relies on a CLI and code copy-paste system, some contributors have packaged all shadcn/ui components as installable npm modules for convenience.
    - **shadcn-packaged**: Lets you `import { Button } from 'shadcn-packaged/ui/button'`, giving you all shadcn/ui components, hooks, and utils in one place and working seamlessly with Tailwind CSS.
    - **@esmate/shadcn**: Provides a packaged, zero-config version of shadcn/ui with composable components, built-in hooks (like `useIsMobile`, `useZodForm`), bundled utilities, and ready-to-use themes. It also makes class merging and theme customization simple for fast prototyping and scaling.

###### 2. **Supporting Packages Commonly Used with shadcn/ui**
- **clsx, class-variance-authority, tailwind-merge**: For managing conditional class logic, variance, and merging Tailwind class sets—especially important in component-heavy shadcn setups.
- **lucide-react**: For consistent iconography, commonly used in shadcn/ui codebases.
- **react-hook-form & zod**: For form state management and schema validation—these are bundled in some shadcn packaging efforts.
- **tw-animate-css**: For simple animation utilities in Tailwind-based projects.

###### 3. **Frontend-AI/CLI Integration Patterns**
- **CLI scaffolding and artifact generation**: Claude Code CLI can automate much of the setup—spinning up scaffolds that combine shadcn/ui components with popular React or Next.js setups, integrating Tailwind CSS, and preparing configuration for out-of-the-box use by running `npx shadcn@latest add ...` or `npx shadcn-ui@latest init`.
- **Component source in-repo**: The core model of shadcn/ui is that you own and customize the code, which is a perfect fit for AI-driven workflows because your AI assistant (like Claude Code) can read, edit, and extend the source directly.
- **AI-powered frontend development**: Some developers are reporting workflows where the entire UI library scaffold or even multi-framework component libraries (inspired by shadcn) are constructed using Claude Code AI agent, leveraging these base packages for style and structure.

##### How These Facilitate Design

- **Full code ownership** (edit any UI logic/behavior in place) enables LLM tools to enhance, refactor, or adapt components.
- **Ready-to-use shadcn UI packs** as npm modules eliminate manual copy/paste or CLI onboarding for teams who prefer direct import syntax.
- **Integration with Claude Code CLI** streamlines repetitive UI coding tasks—AI can scaffold UIs, add components, and automate config, letting devs focus on business logic while keeping design consistent.

##### Example Stack for Claude Code + shadcn Projects

| Role         | Example Package                             | Use Case                                           |
|--------------|---------------------------------------------|-----------------------------------------------------|
| Components   | shadcn-packaged, @esmate/shadcn             | UI primitives, layouts, patterns                    |
| Styles       | class-variance-authority, clsx, tailwind-merge | Class merging, dynamic styles                       |
| Icons        | lucide-react                                 | Consistent iconography                              |
| Forms/Validation | react-hook-form, zod                    | Forms, input validation in shadcn forms             |
| Animations   | tw-animate-css                              | Animations/Transitions in UI                        |

*Dev teams cite these tools as dramatically speeding up frontend work, especially with AI assistants managing code and project consistency.*

**In summary:**  
Yes, developers working with Claude Code CLI and shadcn/ui frequently turn to npm packages like `shadcn-packaged`, `@esmate/shadcn`, and supporting utility modules (clsx, tailwind-merge, lucide-react, etc.) to make design and implementation fast, consistent, and highly automatable. These work synergistically with AI coding workflows, letting teams focus less on low-level styling and more on product logic and custom features.

#### Understanding What Figma Make Doesn't Export

Figma Make exports typically lack:
- **Page structure**: No grid systems, containers, or layout wrappers
- **Navigation systems**: No routing, menus, or navigation state management
- **Responsive breakpoints**: No media queries or responsive utilities
- **Layout components**: No sidebars, headers, footers as structural elements
- **Page templates**: No pre-built page layouts or scaffolding
- **State management**: No interactive layout states (collapsed sidebars, modals)

#### Using shadcn/ui for Page Structure

shadcn/ui provides composable components that serve as building blocks for layouts. Here's how to leverage them effectively:

##### 1. Basic Layout Wrapper

```jsx
// src/components/layouts/BaseLayout.jsx
import { cn } from "@/lib/utils"

const BaseLayout = ({ children, className }) => {
  return (
    <div className={cn("min-h-screen bg-background", className)}>
      <div className="relative flex min-h-screen flex-col">
        {children}
      </div>
    </div>
  )
}

// Usage with Figma Make styles
const App = () => {
  return (
    <BaseLayout className="figma-app-wrapper">
      {/* Apply Figma Make classes to children */}
      <Header className="figma-header-styles" />
      <Main className="figma-main-content" />
      <Footer className="figma-footer-styles" />
    </BaseLayout>
  )
}
```

##### 2. Dashboard Layout with Sidebar

```jsx
// src/components/layouts/DashboardLayout.jsx
import { Sidebar } from "@/components/ui/sidebar"
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet"
import { Button } from "@/components/ui/button"
import { Menu } from "lucide-react"
import { useState } from "react"

const DashboardLayout = ({ children, sidebarContent }) => {
  const [sidebarOpen, setSidebarOpen] = useState(false)

  return (
    <div className="flex h-screen overflow-hidden">
      {/* Desktop Sidebar */}
      <aside className="hidden lg:flex lg:flex-shrink-0">
        <div className="flex w-64 flex-col">
          <Sidebar className="figma-sidebar-styles">
            {sidebarContent}
          </Sidebar>
        </div>
      </aside>

      {/* Mobile Sidebar */}
      <Sheet open={sidebarOpen} onOpenChange={setSidebarOpen}>
        <SheetTrigger asChild>
          <Button
            variant="ghost"
            size="icon"
            className="lg:hidden absolute left-4 top-4 z-40"
          >
            <Menu className="h-6 w-6" />
          </Button>
        </SheetTrigger>
        <SheetContent side="left" className="w-64 p-0">
          <Sidebar className="figma-sidebar-styles">
            {sidebarContent}
          </Sidebar>
        </SheetContent>
      </Sheet>

      {/* Main Content Area */}
      <div className="flex flex-1 flex-col overflow-hidden">
        <main className="flex-1 overflow-y-auto">
          <div className="container py-6">
            {children}
          </div>
        </main>
      </div>
    </div>
  )
}
```

##### 3. Marketing Page Layout

```jsx
// src/components/layouts/MarketingLayout.jsx
import { NavigationMenu } from "@/components/ui/navigation-menu"
import { Card } from "@/components/ui/card"

const MarketingLayout = ({ children }) => {
  return (
    <div className="flex min-h-screen flex-col">
      {/* Fixed Header */}
      <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
        <div className="container flex h-16 items-center">
          <NavigationMenu className="figma-nav-styles">
            {/* Navigation items styled with Figma Make classes */}
          </NavigationMenu>
        </div>
      </header>

      {/* Hero Section with Figma Styles */}
      <section className="figma-hero-section">
        <div className="container">
          <div className="grid gap-6 lg:grid-cols-2 lg:gap-12">
            {/* Apply Figma Make positioning and styles */}
          </div>
        </div>
      </section>

      {/* Feature Grid using shadcn Cards */}
      <section className="container py-12">
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          <Card className="figma-feature-card">
            {/* Card content with Figma styles */}
          </Card>
        </div>
      </section>

      {/* Scrollable Content */}
      <main className="flex-1">
        {children}
      </main>

      {/* Footer */}
      <footer className="border-t">
        <div className="container py-8">
          {/* Footer content with Figma styles */}
        </div>
      </footer>
    </div>
  )
}
```

#### Common Layout Patterns

##### 1. Split Screen Layout

```jsx
// Combining Figma styles with shadcn structure
const SplitScreenLayout = ({ leftContent, rightContent }) => {
  return (
    <div className="flex h-screen">
      {/* Left Panel with Figma background/styling */}
      <div className="hidden lg:flex lg:w-1/2 figma-left-panel">
        <div className="flex w-full items-center justify-center p-12">
          {leftContent}
        </div>
      </div>
      
      {/* Right Panel with form or content */}
      <div className="flex w-full lg:w-1/2 items-center justify-center">
        <Card className="w-full max-w-md figma-form-card">
          {rightContent}
        </Card>
      </div>
    </div>
  )
}
```

##### 2. Grid-Based Content Layout

```jsx
import { cn } from "@/lib/utils"

const GridLayout = ({ items, columns = 3 }) => {
  const gridCols = {
    1: "grid-cols-1",
    2: "grid-cols-1 md:grid-cols-2",
    3: "grid-cols-1 md:grid-cols-2 lg:grid-cols-3",
    4: "grid-cols-1 md:grid-cols-2 lg:grid-cols-4",
  }

  return (
    <div className={cn("grid gap-6", gridCols[columns])}>
      {items.map((item, index) => (
        <div key={index} className="figma-grid-item">
          {/* Apply Figma Make styles to grid items */}
          {item}
        </div>
      ))}
    </div>
  )
}
```

##### 3. Responsive Container System

```jsx
// Container component that maintains Figma desktop designs on large screens
// while providing responsive behavior
const ResponsiveContainer = ({ children, maxWidth = "7xl" }) => {
  const widths = {
    sm: "max-w-sm",
    md: "max-w-md",
    lg: "max-w-lg",
    xl: "max-w-xl",
    "2xl": "max-w-2xl",
    "3xl": "max-w-3xl",
    "4xl": "max-w-4xl",
    "5xl": "max-w-5xl",
    "6xl": "max-w-6xl",
    "7xl": "max-w-7xl",
    full: "max-w-full",
  }

  return (
    <div className={cn(
      "mx-auto w-full px-4 sm:px-6 lg:px-8",
      widths[maxWidth]
    )}>
      {children}
    </div>
  )
}
```

#### Integration Strategies

##### 1. Layering Figma Styles on shadcn Components

```jsx
// Strategy: Use shadcn for structure, Figma for visual styling
import { Button } from "@/components/ui/button"
import { Dialog, DialogContent, DialogHeader } from "@/components/ui/dialog"

const StyledDialog = ({ open, onOpenChange, children }) => {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="figma-modal-styles">
        <DialogHeader className="figma-modal-header">
          {/* Preserve Figma's exact spacing and typography */}
        </DialogHeader>
        <div className="figma-modal-content">
          {children}
        </div>
      </DialogContent>
    </Dialog>
  )
}
```

##### 2. Creating Hybrid Components

```jsx
// Combine shadcn functionality with Figma appearance
const HybridCard = ({ title, description, image, actions }) => {
  return (
    <Card className="overflow-hidden">
      {/* Figma-styled image container */}
      <div className="figma-card-image-wrapper">
        <img src={image} alt={title} className="figma-card-image" />
      </div>
      
      {/* shadcn CardContent with Figma typography */}
      <CardContent className="figma-card-content">
        <h3 className="figma-card-title">{title}</h3>
        <p className="figma-card-description">{description}</p>
      </CardContent>
      
      {/* shadcn CardFooter with Figma button styles */}
      <CardFooter className="figma-card-footer">
        {actions}
      </CardFooter>
    </Card>
  )
}
```

##### 3. Responsive Breakpoint System

```jsx
// Custom hook for Figma breakpoints
import { useEffect, useState } from "react"

const useFigmaBreakpoints = () => {
  const [breakpoint, setBreakpoint] = useState("desktop")

  useEffect(() => {
    const checkBreakpoint = () => {
      const width = window.innerWidth
      if (width < 640) setBreakpoint("mobile")
      else if (width < 1024) setBreakpoint("tablet")
      else setBreakpoint("desktop")
    }

    checkBreakpoint()
    window.addEventListener("resize", checkBreakpoint)
    return () => window.removeEventListener("resize", checkBreakpoint)
  }, [])

  return breakpoint
}

// Usage in layout component
const AdaptiveLayout = ({ children }) => {
  const breakpoint = useFigmaBreakpoints()

  return (
    <div className={`layout-${breakpoint}`}>
      {breakpoint === "mobile" && <MobileNav />}
      {breakpoint !== "mobile" && <DesktopNav />}
      <main className={`figma-main-${breakpoint}`}>
        {children}
      </main>
    </div>
  )
}
```

#### Best Practices for Layout Integration

1. **Start with Structure**: Build the layout skeleton using shadcn/ui components first
2. **Layer Figma Styles**: Apply Figma Make classes for visual styling after structure is solid
3. **Preserve Specificity**: Use CSS modules or styled-components to prevent style conflicts
4. **Mobile-First Approach**: Design responsive layouts that degrade gracefully
5. **Component Composition**: Build complex layouts from smaller, reusable pieces

#### Integrating Figma Make with Tailwind CSS

Since shadcn/ui uses Tailwind CSS, here's how to integrate Figma Make styles effectively:

##### 1. Combining Class Names

```jsx
import { cn } from "@/lib/utils"

// Merge Tailwind utilities with Figma classes
const Component = ({ className }) => {
  return (
    <div className={cn(
      // Tailwind layout utilities
      "flex items-center justify-center p-4",
      // Figma Make visual styles
      "figma-component-styles",
      // Dynamic classes
      className
    )}>
      Content
    </div>
  )
}
```

##### 2. CSS Variable Integration

```css
/* Extend Tailwind with Figma Make design tokens */
@layer base {
  :root {
    /* Figma Make colors as CSS variables */
    --figma-primary: #007AFF;
    --figma-secondary: #5856D6;
    --figma-background: #F2F2F7;
    
    /* Map to Tailwind variables for shadcn/ui */
    --primary: var(--figma-primary);
    --secondary: var(--figma-secondary);
    --background: var(--figma-background);
  }
}
```

##### 3. Custom Tailwind Extensions

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      // Add Figma Make spacing values
      spacing: {
        'figma-xs': '4px',
        'figma-sm': '8px',
        'figma-md': '16px',
        'figma-lg': '24px',
        'figma-xl': '32px',
      },
      // Add Figma Make typography
      fontFamily: {
        'figma-heading': ['SF Pro Display', 'system-ui'],
        'figma-body': ['SF Pro Text', 'system-ui'],
      },
      // Add Figma Make breakpoints if different
      screens: {
        'figma-mobile': '375px',
        'figma-tablet': '768px',
        'figma-desktop': '1440px',
      }
    }
  }
}
```

##### 4. Style Priority Management

```jsx
// Ensure Figma styles take precedence when needed
const StyledComponent = () => {
  return (
    <>
      {/* Load order matters */}
      <link rel="stylesheet" href="/figma-make-styles.css" />
      
      <div className="relative"> {/* Tailwind utility */}
        <div className="figma-exact-styles"> {/* Figma overrides */}
          {/* Content */}
        </div>
      </div>
    </>
  )
}
```

##### Example: Complete Page Implementation

```jsx
// src/pages/Dashboard.jsx
import { DashboardLayout } from "@/components/layouts/DashboardLayout"
import { Card } from "@/components/ui/card"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import "./dashboard-figma-styles.css" // Figma Make styles

const Dashboard = () => {
  const sidebarContent = (
    <nav className="figma-sidebar-nav">
      {/* Navigation items with Figma styling */}
    </nav>
  )

  return (
    <DashboardLayout sidebarContent={sidebarContent}>
      {/* Page Header with Figma typography */}
      <div className="figma-page-header">
        <h1 className="figma-h1">Dashboard</h1>
        <p className="figma-subtitle">Welcome back!</p>
      </div>

      {/* Content Grid */}
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {/* Stats Cards with Figma styling */}
        <Card className="figma-stat-card">
          {/* Card content */}
        </Card>
      </div>

      {/* Tabs Section */}
      <Tabs defaultValue="overview" className="mt-6">
        <TabsList className="figma-tab-list">
          <TabsTrigger value="overview" className="figma-tab">
            Overview
          </TabsTrigger>
          <TabsTrigger value="analytics" className="figma-tab">
            Analytics
          </TabsTrigger>
        </TabsList>
        <TabsContent value="overview" className="figma-tab-content">
          {/* Tab content with Figma styles */}
        </TabsContent>
      </Tabs>
    </DashboardLayout>
  )
}
```

### Maintaining Pixel-Perfect Integrity

#### 1. Font Rendering Consistency

```css
/* Ensure consistent font rendering */
@font-face {
  font-family: 'CustomFont';
  src: url('./fonts/CustomFont.woff2') format('woff2'),
       url('./fonts/CustomFont.woff') format('woff');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
}

body {
  font-family: 'CustomFont', -apple-system, BlinkMacSystemFont, sans-serif;
  text-rendering: optimizeLegibility;
  -webkit-font-smoothing: antialiased;
}
```

#### 2. Image Optimization Strategy

```jsx
// Image component with quality preservation
import { useState, useEffect } from 'react';

const OptimizedImage = ({ src, alt, className, width, height }) => {
  const [imageSrc, setImageSrc] = useState(src);
  
  return (
    <img
      src={imageSrc}
      alt={alt}
      className={className}
      width={width}
      height={height}
      loading="lazy"
      decoding="async"
    />
  );
};
```

#### 3. Precise Measurements Validation

```jsx
// Development helper component
const PixelPerfectOverlay = ({ originalScreenshot }) => {
  const [opacity, setOpacity] = useState(0.5);
  const [showOverlay, setShowOverlay] = useState(false);
  
  if (!showOverlay || process.env.NODE_ENV === 'production') {
    return null;
  }
  
  return (
    <div
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        backgroundImage: `url(${originalScreenshot})`,
        backgroundSize: 'cover',
        opacity,
        pointerEvents: 'none',
        zIndex: 9999,
      }}
    />
  );
};
```

## Best Practices

### 1. Style Management
- Use CSS Modules for component-scoped styles
- Maintain original CSS specificity and cascade
- Preserve all vendor prefixes and browser-specific styles
- Keep z-index values consistent with original design

### 2. Component Organization
- Match component hierarchy to Figma layers
- Create reusable components for repeated elements
- Maintain semantic HTML structure
- Use proper React patterns (hooks, context for state)

### 3. Asset Handling
- Import images and fonts as modules
- Maintain original file formats unless optimization needed
- Use proper loading strategies (lazy loading for images)
- Preserve SVGs as React components when possible

### 4. Animation Preservation
- Convert CSS animations directly when possible
- Use Framer Motion or React Spring for complex animations
- Maintain timing functions and durations exactly
- Test animations across different devices

### 5. Testing and Validation
- Use visual regression testing tools
- Compare renders side-by-side with original
- Test across multiple browsers and devices
- Validate responsive behavior at all breakpoints

## Common Issues

### Issue: Style Cascade Breaking
**Problem**: Styles not applying correctly after componentization
**Solution**:
```jsx
// Ensure proper CSS module usage
import styles from './Component.module.css';

// Use multiple classes when needed
<div className={`${styles.container} ${styles.active}`}>
```

### Issue: Absolute Positioning Shifts
**Problem**: Elements not positioned correctly after conversion
**Solution**:
```css
/* Maintain positioning context */
.parentContainer {
  position: relative; /* Critical for absolute children */
  width: 100%;
  height: 600px; /* Explicit height if needed */
}
```

### Issue: Font Rendering Differences
**Problem**: Fonts appear different than in Figma
**Solution**:
```css
/* Match Figma's rendering as closely as possible */
body {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  font-feature-settings: 'kern' 1, 'liga' 1;
}
```

### Issue: Z-index Stacking Problems
**Problem**: Layers not stacking correctly
**Solution**:
```jsx
// Create z-index constants
const Z_INDEX = {
  background: 1,
  content: 10,
  modal: 100,
  tooltip: 1000,
};
```

## Vite Template Resources

### Where to Find Templates
- The [Awesome Vite](https://github.com/vitejs/awesome-vite) list is the best maintained collection of starter and wireframe templates
- The official [Vite documentation](https://vite.dev/guide/) recommends this community directory
- All templates are typically MIT-licensed or similar, ready for production use

### Template Selection Criteria
1. **For Figma Make Integration**: Choose templates with:
   - Minimal CSS conflicts
   - Clean component structure
   - Easy-to-override styling
   - Good build optimization

2. **Recommended Templates for Figma Make**:
   - `react-ts` for TypeScript projects
   - `vite-react-boilerplate` for production-ready setup
   - Community Tailwind templates if using utility CSS

## Tools and Resources

### Conversion Tools
1. **Builder.io Visual Copilot**
   - Direct Figma to React conversion
   - Supports Tailwind and Material-UI
   - AI-powered code generation

2. **Builder.io Fusion**
   - Extracts design tokens
   - Creates reusable components
   - Maintains design system consistency

3. **Code Parrot (VS Code Extension)**
   - Figma layer to code conversion
   - Direct import into React projects
   - Customizable output templates

4. **Figma Plugins**
   - Figmagic: Design token extraction
   - Figma to Code: React component export
   - SVGR: SVG to React component conversion

### Development Tools
1. **React DevTools**: Component inspection and debugging
2. **Chrome DevTools**: Pixel-level comparison and measurement
3. **Storybook**: Component isolation and testing
4. **Chromatic**: Visual regression testing

### Optimization Tools
1. **Vite Image Plugin**: Build-time image optimization
2. **PostCSS**: CSS processing and autoprefixing
3. **PurgeCSS**: Remove unused styles
4. **Bundle Analyzer**: Identify optimization opportunities

## References

### Related Documentation
- [Figma Make Documentation](https://www.figma.com/make)
- [React Documentation](https://react.dev)
- [Vite Guide](https://vitejs.dev/guide)
- [Vite New Templates](https://blog.stackblitz.com/posts/vite-new-templates/)
- [Awesome Vite Templates](https://github.com/vitejs/awesome-vite#templates)
- [CSS Modules](https://github.com/css-modules/css-modules)

### Related Commands
- `/design:insert-design-code` - Insert design code into projects
- `/user:dev/commands/create-react-vite` - Create new React Vite projects

### Example Export Types
- CRM dashboard interfaces with data tables and charts
- SaaS application layouts with navigation and forms
- Marketing landing pages with hero sections and CTAs
- E-commerce product galleries and checkout flows

### Additional Resources
- [Converting Figma Designs to React: Step-by-Step Guide](https://suhag.me/blogs/converting-figma-designs-to-react-a-step-by-step-guide)
- [Figma to React AI Conversion](https://www.builder.io/blog/convert-figma-to-react-ai)
- [HTML/CSS to React Component Conversion](https://www.esparkinfo.com/software-development/technologies/reactjs/how-to-convert-html-website-to-reactjs)
# HTML-to-Image Conversion Best Practices

Comprehensive guide to HTML-to-image conversion using npm packages (html-to-image, svg2png) for transforming HTML storyboards to embedded images in design workflows with the enhanced `/design:update-screenflows` command.

## Overview

HTML-to-image conversion enables designers and developers to automatically generate embedded images from HTML storyboards, creating GitHub-compatible visualizations that integrate seamlessly with existing SVG-first workflows. This approach combines the flexibility of HTML/CSS for creating complex layouts with the reliability of embedded images for documentation and collaboration.

## Table of Contents

- [Prerequisites](#prerequisites)
- [npm Package Dependencies](#npm-package-dependencies)
- [Conversion Workflow](#conversion-workflow)
- [HTML Storyboard Best Practices](#html-storyboard-best-practices)
- [Image Output Formats](#image-output-formats)
- [Integration with update-screenflows](#integration-with-update-screenflows)
- [Error Handling and Troubleshooting](#error-handling-and-troubleshooting)
- [Performance Optimization](#performance-optimization)
- [GitHub Compatibility](#github-compatibility)
- [Advanced Techniques](#advanced-techniques)
- [Common Issues](#common-issues)

## Prerequisites

### Required Software
- **Node.js**: Version 14.0 or higher for npm package compatibility
- **npm**: Package manager for installing html-to-image and svg2png packages
- **Modern Browser Support**: Chrome, Firefox, or Safari for DOM rendering

### Project Dependencies
```json
{
  "dependencies": {
    "html-to-image": "^1.11.13",
    "svg2png": "^4.1.1"
  }
}
```

### Verification
```bash
# Check Node.js version
node --version

# Check npm availability
npm --version

# Verify package installation
npm list html-to-image svg2png
```

## npm Package Dependencies

### html-to-image Package
- **Purpose**: Primary package for converting HTML DOM elements to various image formats
- **Version**: 1.11.13 (recommended stable version)
- **Formats**: PNG, JPEG, SVG, WebP
- **Features**: High-quality rendering, CSS styling support, responsive layouts

#### Key Functions
```javascript
const { htmlToImage } = require('html-to-image');

// Convert to PNG with high quality
await htmlToImage.toPng(domElement, { quality: 1.0 });

// Convert to SVG for vector graphics
await htmlToImage.toSvg(domElement);

// Convert to JPEG with compression
await htmlToImage.toJpeg(domElement, { quality: 0.95 });
```

### svg2png Package
- **Purpose**: Specialized SVG to PNG conversion for vector graphics
- **Version**: 4.1.1 (recommended stable version)
- **Features**: High-resolution output, scaling support, transparency handling

#### Key Functions
```javascript
const svg2png = require('svg2png');

// Convert SVG buffer to PNG
const pngBuffer = await svg2png(svgBuffer, { width: 1200, height: 800 });
```

## Conversion Workflow

### Standard Conversion Process

1. **HTML Storyboard Creation**
   - Generate or load HTML storyboard file
   - Ensure responsive CSS styling
   - Validate DOM structure for conversion

2. **DOM Element Preparation**
   - Create JSDOM instance for server-side rendering
   - Apply CSS styles and responsive breakpoints
   - Handle dynamic content and interactions

3. **Image Generation**
   - Execute html-to-image conversion functions
   - Generate multiple formats (PNG, SVG, JPEG)
   - Apply quality settings and optimization

4. **File Output**
   - Save images to wireframes/ directory with relative paths
   - Create descriptive filenames with proper extensions
   - Validate embedded image compliance

### Example Conversion Script

```javascript
const fs = require('fs');
const path = require('path');
const { htmlToImage } = require('html-to-image');
const { JSDOM } = require('jsdom');

async function convertHtmlToImages(htmlFilePath, outputDir) {
    // Read HTML content
    const htmlContent = fs.readFileSync(htmlFilePath, 'utf8');
    
    // Create DOM instance
    const dom = new JSDOM(htmlContent);
    const document = dom.window.document;
    
    // Convert to PNG
    const pngDataUrl = await htmlToImage.toPng(document.body, {
        quality: 1.0,
        width: 1200,
        height: 800
    });
    
    // Save PNG file
    const pngBuffer = Buffer.from(pngDataUrl.split(',')[1], 'base64');
    fs.writeFileSync(path.join(outputDir, 'storyboard.png'), pngBuffer);
    
    // Convert to SVG
    const svgDataUrl = await htmlToImage.toSvg(document.body);
    const svgContent = decodeURIComponent(svgDataUrl.split(',')[1]);
    fs.writeFileSync(path.join(outputDir, 'storyboard.svg'), svgContent);
    
    console.log('✅ Conversion completed successfully');
}
```

## HTML Storyboard Best Practices

### HTML Structure Guidelines

#### Responsive Design
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Storyboard</title>
    <style>
        body {
            font-family: system-ui, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f8f9fa;
            max-width: 1200px;
        }
        
        .storyboard-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .screen-frame {
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="storyboard-container">
        <!-- Screen content here -->
    </div>
</body>
</html>
```

#### CSS Best Practices
- **System Fonts**: Use system-ui for consistent rendering across platforms
- **Relative Units**: Use em, rem, or percentages for scalable layouts
- **Color Consistency**: Define color variables for consistent theming
- **Print-Friendly**: Avoid complex animations or transitions that don't convert well

#### Conversion-Optimized Elements
```css
/* Optimized for conversion */
.conversion-optimized {
    /* Avoid complex gradients */
    background: solid colors;
    
    /* Use web-safe fonts */
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    
    /* Ensure sufficient contrast */
    color: #212529;
    background-color: #ffffff;
    
    /* Avoid transform animations */
    transition: none;
}
```

## Image Output Formats

### PNG Format
- **Best For**: Screenshots, detailed wireframes, complex layouts
- **Advantages**: Lossless compression, transparency support, high quality
- **File Size**: Larger file sizes, excellent for documentation
- **Use Case**: Primary format for detailed screen documentation

```javascript
const pngOptions = {
    quality: 1.0,
    width: 1200,
    height: 800,
    backgroundColor: '#ffffff'
};
```

### SVG Format
- **Best For**: Vector graphics, scalable wireframes, GitHub rendering
- **Advantages**: Scalable, small file sizes, editable
- **Compatibility**: Native GitHub markdown support
- **Use Case**: Primary format for wireframes and icons

```javascript
const svgOptions = {
    width: 1200,
    height: 800,
    style: {
        'font-family': 'system-ui, sans-serif'
    }
};
```

### JPEG Format
- **Best For**: Photographic content, compressed images
- **Advantages**: Smaller file sizes, good for complex images
- **Disadvantages**: Lossy compression, no transparency
- **Use Case**: Secondary format for bandwidth-sensitive scenarios

```javascript
const jpegOptions = {
    quality: 0.95,
    width: 1200,
    height: 800
};
```

## Integration with update-screenflows

### Command Usage
```bash
# Enable HTML-to-image conversion
/design:update-screenflows dashboard-flow "Dashboard wireframes" svg --convert-html

# Project analysis with conversion
/design:update-screenflows mobile-app ./src svg --convert-html

# Custom content with conversion
/design:update-screenflows checkout-flow "E-commerce checkout" svg --convert-html
```

### Generated File Structure
```
designs/screenflows/{project-name}/
├── README.md                          # Project overview
├── storyboard.html                     # Source HTML storyboard
├── wireframes/                         # Primary output directory
│   ├── storyboard-from-html.png        # Converted PNG image
│   ├── storyboard-from-html.svg        # Converted SVG image
│   ├── dashboard-wireframe.svg         # Original SVG wireframes
│   └── screen-01-home.svg             # Individual screen wireframes
├── images/                            # Supporting images
└── convert-html-to-images.js          # Temporary conversion script
```

### Workflow Integration
1. **SVG-First Generation**: Command creates SVG wireframes as primary method
2. **HTML Storyboard Creation**: Generates responsive HTML storyboard if none exists
3. **Conversion Execution**: Runs Node.js script for HTML-to-image conversion
4. **File Organization**: Saves converted images to wireframes/ directory
5. **Validation**: Ensures all images use embedded paths for GitHub compatibility

## Error Handling and Troubleshooting

### Common Installation Issues

#### Node.js Version Compatibility
```bash
# Check Node.js version
node --version

# Update Node.js if needed (using nvm)
nvm install 16
nvm use 16
```

#### Package Installation Failures
```bash
# Clear npm cache
npm cache clean --force

# Reinstall packages
npm install html-to-image@1.11.13 svg2png@4.1.1

# Check for global conflicts
npm list -g
```

### Runtime Errors

#### DOM Rendering Issues
```javascript
// Solution: Ensure proper JSDOM setup
const { JSDOM } = require('jsdom');

const dom = new JSDOM(htmlContent, {
    resources: 'usable',
    runScripts: 'dangerously',
    pretendToBeVisual: true
});

// Wait for DOM to be ready
await new Promise(resolve => {
    if (dom.window.document.readyState === 'complete') {
        resolve();
    } else {
        dom.window.addEventListener('load', resolve);
    }
});
```

#### Memory Issues with Large HTML
```javascript
// Solution: Process in chunks or optimize HTML
const optimizedOptions = {
    pixelRatio: 1,
    quality: 0.8,
    width: 800,  // Reduce resolution if needed
    height: 600
};
```

#### CSS Loading Problems
```javascript
// Solution: Inline CSS or ensure proper resource loading
const htmlWithInlineCSS = htmlContent.replace(
    '<link rel="stylesheet" href="styles.css">',
    `<style>${fs.readFileSync('styles.css', 'utf8')}</style>`
);
```

### Debugging Strategies

#### Enable Verbose Logging
```javascript
console.log('🔄 Starting HTML-to-image conversion...');
console.log('📄 HTML file size:', fs.statSync(htmlFilePath).size);
console.log('🎯 Output directory:', outputDir);

// Add timing information
const startTime = Date.now();
await htmlToImage.toPng(element);
console.log('⏱️ Conversion time:', Date.now() - startTime, 'ms');
```

#### Validate Output
```javascript
// Check if files were created successfully
if (fs.existsSync(outputPath)) {
    const stats = fs.statSync(outputPath);
    console.log('✅ File created:', outputPath, `(${stats.size} bytes)`);
} else {
    console.error('❌ File not created:', outputPath);
}
```

## Performance Optimization

### Conversion Speed
- **Reduce HTML Complexity**: Simplify DOM structure for faster processing
- **Optimize CSS**: Minimize complex selectors and effects
- **Batch Processing**: Convert multiple elements in parallel when possible
- **Cache Results**: Store converted images to avoid re-processing

### Memory Management
```javascript
// Optimize memory usage
const conversionOptions = {
    pixelRatio: 1,           // Reduce for lower memory usage
    quality: 0.9,            // Balance quality vs file size
    cacheBust: false,        // Avoid unnecessary cache invalidation
    skipAutoScale: true      // Manual control over scaling
};
```

### File Size Optimization
```javascript
// PNG optimization
const pngOptions = {
    quality: 0.9,
    backgroundColor: '#ffffff',
    width: 1000,             // Optimal size for GitHub
    height: 600
};

// SVG optimization
const svgOptions = {
    style: {
        'font-family': 'system-ui',
        'font-size': '14px'
    }
};
```

## GitHub Compatibility

### Embedded Image Requirements
- **Relative Paths**: All images must use relative paths (`./wireframes/image.png`)
- **Supported Formats**: PNG, SVG, JPEG, GIF, WebP
- **File Size Limits**: Keep images under 25MB for optimal GitHub performance
- **Repository Storage**: Images are version-controlled with code changes

### Markdown Integration
```markdown
# Dashboard Storyboard

![Dashboard Wireframe](./wireframes/storyboard-from-html.png)

*Converted from HTML storyboard using html-to-image package*

## Individual Screens

![Home Screen](./wireframes/screen-01-home.svg)
![Profile Screen](./wireframes/screen-02-profile.svg)
```

### Validation Compliance
The `/design:update-screenflows` command automatically validates embedded images:
- Detects external URL references (forbidden)
- Ensures relative path usage (required)
- Provides conversion guidance for violations
- Exits with error if hyperlinked images found

## Advanced Techniques

### Custom CSS for Conversion
```css
/* Print-specific styles for conversion */
@media print {
    .screen-frame {
        page-break-inside: avoid;
        break-inside: avoid;
    }
    
    .storyboard-container {
        display: block;
    }
    
    .screen-frame {
        margin-bottom: 20px;
    }
}

/* Conversion-optimized styles */
.conversion-ready {
    /* Ensure text is readable */
    -webkit-font-smoothing: antialiased;
    
    /* Improve border rendering */
    border-style: solid;
    
    /* Optimize background rendering */
    background-clip: padding-box;
}
```

### Dynamic Content Handling
```javascript
// Handle dynamic content before conversion
async function prepareHtmlForConversion(htmlContent) {
    const dom = new JSDOM(htmlContent);
    const document = dom.window.document;
    
    // Replace dynamic content with static equivalents
    const dynamicElements = document.querySelectorAll('[data-dynamic]');
    dynamicElements.forEach(element => {
        element.textContent = element.getAttribute('data-fallback') || 'Sample Content';
    });
    
    // Apply conversion-ready classes
    document.body.classList.add('conversion-ready');
    
    return dom.serialize();
}
```

### Multi-Resolution Output
```javascript
// Generate multiple resolutions
const resolutions = [
    { width: 800, height: 600, suffix: 'small' },
    { width: 1200, height: 800, suffix: 'medium' },
    { width: 1600, height: 1200, suffix: 'large' }
];

for (const resolution of resolutions) {
    const dataUrl = await htmlToImage.toPng(element, {
        width: resolution.width,
        height: resolution.height
    });
    
    const filename = `storyboard-${resolution.suffix}.png`;
    // Save file with resolution suffix
}
```

## Common Issues

### Issue: "Module not found" Error
**Cause**: Missing npm packages or incorrect installation
**Solution**:
```bash
# Reinstall packages
npm install html-to-image@1.11.13
npm install svg2png@4.1.1

# Check installation
npm list html-to-image svg2png
```

### Issue: Blank or Incomplete Images
**Cause**: DOM not fully loaded or CSS not applied
**Solution**:
```javascript
// Wait for all resources to load
await new Promise(resolve => setTimeout(resolve, 1000));

// Ensure fonts are loaded
await document.fonts.ready;

// Then proceed with conversion
const dataUrl = await htmlToImage.toPng(element);
```

### Issue: Memory Limit Exceeded
**Cause**: Large HTML files or high-resolution output
**Solution**:
```javascript
// Reduce image dimensions
const options = {
    width: 800,
    height: 600,
    pixelRatio: 1
};

// Process in smaller chunks
const elements = document.querySelectorAll('.screen-frame');
for (const element of elements) {
    await convertElement(element);
    // Allow garbage collection
    await new Promise(resolve => setTimeout(resolve, 100));
}
```

### Issue: Fonts Not Rendering Correctly
**Cause**: Font loading issues or system font differences
**Solution**:
```css
/* Use web-safe font stack */
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 
                 Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
}

/* Or embed fonts directly */
@font-face {
    font-family: 'CustomFont';
    src: url('data:font/woff2;base64,...');
}
```

### Issue: Hyperlinked Images in Output
**Cause**: External image references in HTML
**Solution**: Use base64 encoded images or local file references
```html
<!-- Avoid external references -->
<img src="https://external.com/image.png" alt="External Image">

<!-- Use base64 or local files -->
<img src="data:image/png;base64,iVBOR..." alt="Embedded Image">
<img src="./local-image.png" alt="Local Image">
```

## Related Documentation

- [Screenflows Storyboarding](./../design/screenflows-storyboarding.md) - HTML-based storyboarding with embedded examples
- [Screenflows Wireframes](./../design/screenflows-wireframes.md) - Best practices for HTML wireframes
- [html-to-image npm package](https://www.npmjs.com/package/html-to-image) - Official package documentation
- [svg2png npm package](https://www.npmjs.com/package/svg2png) - SVG conversion utilities

This comprehensive guide ensures reliable HTML-to-image conversion workflows that integrate seamlessly with the enhanced design-dev agent complex and maintain GitHub compatibility through embedded image best practices.
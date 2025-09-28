# Assets

This directory stores design assets and resources used throughout the Figma Make project.

## Purpose

The assets directory centralizes all design resources needed for implementation:
- Icons and iconography systems
- Images and illustrations
- Fonts and typography files
- Color palettes and design tokens
- Logos and brand assets
- SVG graphics and vector files

## Organization

```
assets/
├── README.md              # This file
├── icons/                 # Icon files and icon systems
│   ├── svg/              # SVG icon files
│   ├── png/              # PNG icon exports
│   └── README.md         # Icon usage guidelines
├── images/                # Images and illustrations
│   ├── hero/             # Hero images
│   ├── backgrounds/      # Background images
│   └── illustrations/    # Custom illustrations
├── fonts/                 # Font files (if custom)
│   └── README.md         # Typography guidelines
└── tokens/                # Design tokens
    ├── colors.json       # Color palette
    ├── spacing.json      # Spacing system
    └── typography.json   # Typography scales
```

## File Formats

### Icons
- **Primary**: SVG for scalability
- **Fallback**: PNG at 1x, 2x, 3x resolutions
- **Naming**: `icon-name-variant.svg` (e.g., `arrow-left-bold.svg`)

### Images
- **Web**: WebP with PNG/JPEG fallbacks
- **Optimization**: Compressed and responsive sizes
- **Naming**: `context-description-size.ext` (e.g., `hero-dashboard-1920w.webp`)

### Design Tokens
- **Format**: JSON for easy integration
- **Structure**: Follows design system conventions
- **Usage**: Import directly into stylesheets or components

## Best Practices

1. **Optimization First**
   - Compress all images before committing
   - Use appropriate formats (SVG for icons, WebP for photos)
   - Generate multiple sizes for responsive images

2. **Consistent Naming**
   - Use kebab-case for all files
   - Include context in filenames
   - Version assets when updating (e.g., `logo-v2.svg`)

3. **Documentation**
   - Document color codes and usage
   - Include attribution for external assets
   - Note licensing information

4. **Version Control**
   - Use Git LFS for large binary files
   - Keep source files when possible
   - Document asset sources in commit messages

## Integration with Figma

### Exporting from Figma
1. Use Figma's export settings for optimal quality
2. Export at multiple resolutions for responsive design
3. Maintain consistent naming between Figma and exports

### Asset Pipeline
1. Export from Figma to appropriate format
2. Optimize using tools like ImageOptim or SVGO
3. Place in correct directory structure
4. Update relevant documentation

## Usage in Code

### Importing Icons
```jsx
import ArrowLeft from '@/designs/assets/icons/svg/arrow-left.svg';
```

### Using Images
```jsx
import heroImage from '@/designs/assets/images/hero/dashboard-hero.webp';
```

### Design Tokens
```javascript
import { colors } from '@/designs/assets/tokens/colors.json';
```

## Maintenance

- Regularly audit for unused assets
- Keep file sizes optimized
- Update documentation when adding new assets
- Use consistent export settings from design tools

---
*Last Updated: 2025-09-28*
# Designs

This directory contains all design-related documentation, prototypes, and screen flows for the Figma Make project.

## Overview

The designs directory is organized to support the full design-to-code workflow, from initial prototypes to detailed screen flows that can be converted into React components.

## Directory Structure

```
designs/
├── README.md              # This file - main navigation
├── assets/                # Design assets and resources
│   └── README.md         # Assets documentation
├── prototypes/            # Figma prototypes and mockups
│   └── README.md         # Prototypes documentation
└── screenflows/           # User flow and navigation diagrams
    └── README.md         # Screen flows documentation
```

## Navigation

### 🎨 [Assets](./assets/README.md)
Store and organize design assets including icons, images, fonts, and other resources.

### 📐 [Prototypes](./prototypes/README.md)
Store and organize Figma prototypes, mockups, and design iterations.

### 🔄 [Screen Flows](./screenflows/README.md)
Document user journeys, navigation patterns, and application flow diagrams.

## Adding New Content

### For Prototypes
1. Export your Figma designs to the `prototypes/` directory
2. Create a subdirectory for each major feature or version
3. Include a README in each subdirectory explaining the designs
4. Use descriptive filenames (e.g., `dashboard-v2-dark-mode.fig`)

### For Screen Flows
1. Use the `/design:update-screenflows` command to generate flow diagrams
2. Each flow gets its own subdirectory in `screenflows/`
3. Include Mermaid diagrams and documentation
4. Link flows back to relevant prototypes

For alternative approaches to screen flow documentation, see:
- [Screenflows Storyboarding](../.claude/docs/design/screenflows-storyboarding.md) - HTML-based storyboarding
- [Screenflows Wireframes](../.claude/docs/design/screenflows-wireframes.md) - HTML wireframing best practices

## Best Practices

1. **Version Control**: Use meaningful commit messages when adding designs
2. **Organization**: Group related designs in subdirectories
3. **Documentation**: Always include README files explaining the context
4. **Naming**: Use kebab-case for directories and files
5. **Updates**: Keep this index updated when adding new sections

## Integration with Figma Make

This directory structure supports the Figma Make workflow:
- Prototypes can be processed with `extract-layout-description`
- Screen flows guide the `insert-design-code` implementation
- Design tokens and assets can be organized here for reference

## Related Commands

- `/design:update-screenflows` - Generate screen flow diagrams
- `/design:extract-layout-description` - Process Figma exports
- `/design:insert-design-code` - Convert designs to React code

---
*Last Updated: 2025-09-28*
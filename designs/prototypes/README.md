# Prototypes

This directory stores Figma prototypes, mockups, and design iterations for the project.

## Purpose

The prototypes directory serves as the central repository for all design files that will be converted into code. It provides:
- Version control for design iterations
- Easy access for developers implementing designs
- Documentation of design decisions
- Archive of design evolution

## Organization

```
prototypes/
├── README.md              # This file
├── feature-name/          # Feature-specific designs
│   ├── README.md         # Feature documentation
│   ├── v1/               # Version 1 designs
│   └── v2/               # Version 2 designs
└── components/            # Reusable component designs
    ├── buttons/
    ├── forms/
    └── navigation/
```

## File Naming Conventions

- Use kebab-case for all files and directories
- Include version numbers: `dashboard-v2.fig`
- Add context modifiers: `dashboard-v2-dark-mode.fig`
- Date exports: `dashboard-v2-2024-01-15.fig`

## Adding New Prototypes

1. Create a feature directory if it doesn't exist
2. Export your Figma file to the appropriate location
3. Add a README explaining:
   - Design goals
   - Key components
   - Interaction patterns
   - Implementation notes

## Example Structure

```
prototypes/
├── user-dashboard/
│   ├── README.md
│   ├── dashboard-v1.fig
│   ├── dashboard-v2.fig
│   └── dashboard-v2-responsive.fig
├── onboarding/
│   ├── README.md
│   ├── welcome-flow.fig
│   └── profile-setup.fig
└── components/
    ├── buttons/
    │   ├── primary-button.fig
    │   └── icon-buttons.fig
    └── forms/
        ├── input-fields.fig
        └── form-validation.fig
```

## Integration with Development

These prototypes are used with:
- `/design:extract-layout-description` - Extract component structure
- `/design:insert-design-code` - Generate React components
- Screen flows for navigation planning

## Best Practices

1. **Keep Files Small**: Export individual features rather than entire apps
2. **Document Changes**: Use git commits to track design evolution
3. **Clean Exports**: Remove unnecessary layers before exporting
4. **Consistent Naming**: Follow the naming conventions strictly
5. **Archive Old Versions**: Keep previous versions for reference

---
*Last Updated: 2025-09-28*
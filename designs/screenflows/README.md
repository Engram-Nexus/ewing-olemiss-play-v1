# Screen Flows

This directory contains user flow diagrams, navigation patterns, and screen relationship documentation.

## Purpose

Screen flows document how users navigate through the application and how different screens connect. They serve as:
- Blueprint for navigation implementation
- Reference for user journey planning
- Documentation for QA testing paths
- Guide for accessibility improvements

## Organization

Screen flows are organized by feature or user journey. Each screen flow created with the `/design:update-screenflows` command will have its own subdirectory here.

## Creating Screen Flows

Use the `/design:update-screenflows` command to generate screen flows. See that command's documentation for detailed usage.

### Alternative Documentation Approaches

In addition to Mermaid-based flow diagrams, consider these comprehensive documentation methods:
- [Screenflows Storyboarding](../../.claude/docs/design/screenflows-storyboarding.md) - Visualize entire applications in a single HTML document
- [Screenflows Wireframes](../../.claude/docs/design/screenflows-wireframes.md) - Create rapid HTML wireframes for quick iteration

## Integration with Prototypes

Screen flows should correspond to prototypes in the `../prototypes/` directory:
- Each prototype should have a matching screen flow
- Flows document the connections between prototype screens
- Use consistent naming between prototypes and flows

---
*Last Updated: 2025-09-28*
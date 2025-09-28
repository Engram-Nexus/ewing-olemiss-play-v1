# Args: `[custom-instructions]`. v2.0.0. Update design philosophy document in designs/PHILOSOPHY.md with core elements, principles, and emotional intention guidance.

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/update-design-philosophy` in bash.

## Summary

Updates the design philosophy document at `designs/PHILOSOPHY.md` for Figma Make projects, capturing core design elements, guiding principles, and emotional intentions. This command enforces strict path requirements and updates the structured philosophy document that serves as the foundation for consistent design decisions throughout the project lifecycle. It can either use custom instructions provided by the user or intelligently extract design philosophy from existing spec project contents.

## Usage

```bash
/design:update-design-philosophy [custom-instructions]
```

## Arguments

- `[custom-instructions]`: Optional custom guidance for the design philosophy (OPTIONAL)
  - If provided: Uses these instructions to guide the philosophy creation
  - If omitted: Extracts design philosophy from existing project specifications
  - Can include specific design values, principles, or aesthetic directions
  - Examples: "Focus on minimalist aesthetics with bold typography", "Emphasize accessibility and inclusive design"

## Examples

```bash
# Update design philosophy from existing project specs
/design:update-design-philosophy

# Update with custom minimalist guidance
/design:update-design-philosophy "Create a minimalist design philosophy emphasizing clean lines, generous whitespace, and monochromatic color schemes"

# Update with accessibility focus
/design:update-design-philosophy "Develop a philosophy centered on inclusive design, WCAG AAA compliance, and universal usability"

# Update with brand-specific direction
/design:update-design-philosophy "Build philosophy around playful, energetic design with vibrant colors and dynamic motion"
```

## What This Command Does

### 1. Analyze Project Context
- Scans for existing design specifications in the project
- Identifies current design patterns and conventions
- Extracts implicit design principles from existing work
- Determines project goals and target audience

### 2. Generate Philosophy Structure
Creates a comprehensive document with the following sections:

#### Core Elements
- **Design Values**: Fundamental beliefs that guide all design decisions
- **Visual Language**: Typography, color, spacing, and layout principles
- **Interaction Patterns**: How users engage with the design
- **Brand Personality**: The character and voice of the design

#### Guiding Principles
- **Hierarchy Principles**: How information is organized and prioritized
- **Consistency Guidelines**: Rules for maintaining coherent design
- **Flexibility Framework**: How to adapt while maintaining integrity
- **Innovation Boundaries**: Where to push limits and where to stay grounded

#### Emotional Intention
- **User Feelings**: Desired emotional responses from users
- **Brand Connection**: How design reinforces brand identity
- **Experience Journey**: Emotional arc through user interactions
- **Accessibility Impact**: Ensuring inclusive emotional experiences

### 3. Update Design Philosophy Document
- **STRICTLY** writes to `designs/PHILOSOPHY.md` (enforced path)
- Creates `designs/` directory if it doesn't exist
- Includes actionable guidelines for designers
- Provides decision-making frameworks
- Offers concrete examples and anti-patterns

### 4. Integrate with Project Workflow
- Links philosophy to existing design systems
- Creates references for component documentation
- Establishes review criteria for design decisions
- Sets up philosophy validation checkpoints

## Philosophy Document Structure

**🚨 CRITICAL: This command ONLY writes to `designs/PHILOSOPHY.md`. No other paths are accepted.**

```markdown
# Design Philosophy - [Project Name]

## Overview
Brief introduction to the design philosophy and its purpose

## Core Values
### Value 1: [Name]
- Definition
- Application
- Examples

### Value 2: [Name]
- Definition
- Application
- Examples

## Visual Principles
### Typography
- Hierarchy system
- Font choices and rationale
- Reading experience goals

### Color Philosophy
- Emotional associations
- Functional applications
- Accessibility considerations

### Spatial Design
- Layout principles
- Whitespace philosophy
- Responsive considerations

## Interaction Design
### User Agency
- Control principles
- Feedback mechanisms
- Error handling philosophy

### Motion & Transitions
- Animation principles
- Performance considerations
- Accessibility accommodations

## Emotional Design
### Intended Feelings
- Primary emotions
- Secondary emotions
- Emotional journey mapping

### Brand Expression
- Personality traits
- Voice and tone
- Visual metaphors

## Implementation Guidelines
### Decision Framework
- How to apply philosophy
- Common scenarios
- Edge case handling

### Anti-Patterns
- What to avoid
- Why to avoid it
- Better alternatives

## Evolution & Adaptation
### Living Document
- Update criteria
- Review schedule
- Feedback integration
```

## Script Integration

This command leverages several scripts for enhanced functionality:

### Philosophy Extractor Script
```bash
# Extract design patterns from existing specs
if [[ -f ".claude/scripts/design/philosophy-extractor.sh" ]]; then
    .claude/scripts/design/philosophy-extractor.sh
fi
```

### Content Generator Script
```bash
# Generate philosophy content based on analysis
if [[ -f ".claude/scripts/design/philosophy-generator.sh" ]]; then
    .claude/scripts/design/philosophy-generator.sh "$CUSTOM_INSTRUCTIONS"
fi
```

## Requirements

- **Project Context**: Works best with existing design specifications
- **Figma Make Setup**: Requires initialized Figma Make project structure
- **Designs Directory**: Command will create `designs/` directory if it doesn't exist
- **Strict Path Enforcement**: **ONLY** writes to `designs/PHILOSOPHY.md` - no exceptions

## Error Handling

### Common Issues and Solutions

1. **No Project Specs Found**
   - Solution: Provide custom instructions or create initial specifications
   - Command will prompt for basic project information

2. **Conflicting Design Patterns**
   - Solution: Philosophy will highlight conflicts for resolution
   - Provides framework for making consistent choices

3. **Missing Context**
   - Solution: Command will ask clarifying questions
   - Can proceed with defaults if needed

4. **Wrong File Path Attempt**
   - Error: Command rejects any attempt to write outside `designs/PHILOSOPHY.md`
   - Solution: Only `designs/PHILOSOPHY.md` is accepted as the target file

## Performance Optimization

### Caching Strategy
- Caches analyzed project patterns for faster regeneration
- Stores extracted principles for reference
- Maintains version history of philosophy evolution

### Parallel Processing
- Analyzes multiple spec files concurrently
- Generates document sections in parallel
- Optimizes for large project repositories

## Integration Points

### Figma Design System
- Links to Figma components and styles
- References design tokens
- Maintains bi-directional updates

### Development Workflow
- Connects to CSS/design token generation
- Influences component API design
- Guides accessibility implementation

## Notes

- **Strict Path Enforcement**: **ALWAYS** writes to `designs/PHILOSOPHY.md` - no other paths accepted
- **Living Document**: Design philosophy should evolve with the project
- **Team Alignment**: Share and review with all stakeholders
- **Practical Application**: Philosophy must be actionable, not just theoretical
- **Cultural Sensitivity**: Consider diverse perspectives in philosophy development
- **Accessibility First**: Every principle should consider inclusive design
- **Version Control**: Track philosophy changes alongside design evolution

## Version History

- **v2.0.0** - Renamed to update-design-philosophy with strict path enforcement
  - Command renamed from `create-design-philosophy` to `update-design-philosophy`
  - **STRICT** path enforcement: only writes to `designs/PHILOSOPHY.md`
  - Enhanced error handling for wrong path attempts
  - Automatic `designs/` directory creation
- **v1.0.0** - Initial implementation
  - Core philosophy generation from specs
  - Custom instruction support
  - Comprehensive document structure
  - Integration with Figma Make workflow
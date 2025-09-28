# Design-Dev Agent Complex Storage Patterns

This document defines the mandatory storage patterns for the design-dev agent complex to ensure consistent, robust, and predictable file organization across all color system workflows.

## Overview

The design-dev agent complex follows strict storage patterns to maintain consistency and enable reliable automation. These patterns are enforced by the meta-command, agent, and individual commands to ensure all generated content is stored in predictable locations.

## Color System Storage Pattern

### Primary Storage Location
**🔴 MANDATORY**: All color system content MUST be stored in the `designs/colors/` directory.

```
designs/colors/
├── COLOR-SYSTEM.md          # Main color system with embedded swatch palette images
├── archive/                 # Previous versions with timestamps
│   ├── COLOR-SYSTEM-20240101-120000.md
│   └── COLOR-SYSTEM-20240115-093000.md
└── swatches/               # Additional swatch files (optional)
    ├── brand-colors.svg
    └── semantic-colors.svg
```

### Key Storage Requirements

1. **Primary Output**: `designs/colors/COLOR-SYSTEM.md`
   - Contains embedded swatch palette images
   - Uses GitHub-compatible rendering methods
   - Professional table-based color organization

2. **Archive Location**: `designs/colors/archive/`
   - Previous versions stored with timestamp format: `COLOR-SYSTEM-YYYYMMDD-HHMMSS.md`
   - Preserves complete evolution of color decisions
   - Automatic archiving before creating new versions

3. **Directory Creation**: 
   - Commands MUST create `designs/colors/` if it doesn't exist
   - Commands MUST create `designs/colors/archive/` if it doesn't exist
   - No assumptions about pre-existing directory structure

## Workflow Implementation

### Meta-Command: run-design-dev
- **Flag**: `--colors`
- **Storage Documentation**: Explicitly documents that content is stored in `designs/colors/`
- **Agent Instructions**: Passes CRITICAL storage requirements to the design-dev agent
- **PR Description**: Includes storage location in pull request descriptions

### Agent: design-dev
- **Storage Principle**: "STORAGE CONSISTENCY: ALWAYS store color system content in designs/colors/ directory - this is non-negotiable"
- **Output Standards**: Specifies mandatory storage at `designs/colors/COLOR-SYSTEM.md`
- **Directory Verification**: Must verify and create directory structure before creating content

### Command: update-color-system
- **Implementation**: Creates directory structure and enforces storage location
- **Archiving Logic**: Moves existing COLOR-SYSTEM.md to archive before creating new version
- **Path Variables**: Uses consistent path variables for storage locations

## Storage Pattern Benefits

1. **Predictability**: Developers and users know exactly where to find color system files
2. **Version Control**: Archive directory preserves complete history of changes
3. **Automation Friendly**: Scripts and commands can reliably find and process files
4. **GitHub Integration**: Consistent paths work well with GitHub's file browsing and linking
5. **Scaling**: Pattern supports additional color-related files (swatches, palettes, etc.)

## Enforcement Mechanisms

### Command Level
- Directory creation logic in all color system commands
- Path validation and error handling
- Consistent variable naming for storage paths

### Agent Level  
- Storage requirements documented in agent instructions
- Critical storage constraints in Key Principles section
- Storage location verification in workflow steps

### Meta-Command Level
- Explicit storage documentation in flag descriptions
- Storage location passed to agents as critical requirements
- Pull request descriptions include storage location information

## Migration and Updates

When enhancing the color system workflow:

1. **Maintain Storage Consistency**: Never change the `designs/colors/` storage location
2. **Preserve Archives**: Always maintain existing archive files
3. **Update All Components**: Ensure meta-command, agent, and commands all reflect changes
4. **Document Changes**: Update this file when storage patterns evolve

## Error Handling

### Missing Directories
- Commands MUST create `designs/colors/` and `designs/colors/archive/` if missing
- No failures due to missing directory structure
- Clear error messages if directory creation fails

### Permission Issues
- Graceful handling of write permission problems
- Clear guidance on resolving permission issues
- Fallback strategies where possible

### Path Conflicts
- Detection of existing files before archiving
- Unique timestamp generation to avoid conflicts
- Clear error messages for path-related issues

## Validation Checklist

When implementing or updating color system workflows, verify:

- [ ] All content stored in `designs/colors/` directory
- [ ] Archive functionality working with timestamp format
- [ ] Directory creation logic present in commands
- [ ] Agent documentation includes storage requirements
- [ ] Meta-command documents storage location
- [ ] Pull request descriptions include storage information
- [ ] Error handling for missing directories
- [ ] Path validation and consistency checks

## Related Documentation

- `run-design-dev.md` - Meta-command with --colors flag storage documentation
- `design-dev.md` - Agent with critical storage pattern requirements
- `update-color-system.md` - Command implementation with directory creation logic
- `ubuntu-vm/user/docs/agent-complex/agent-complex-rules.md` - General agent complex patterns

---

*This document ensures the design-dev agent complex maintains consistent, robust, and predictable storage patterns for all color system content.*
# Args: `<validation-type>` `<scope>`. v1.8.0. Validate deployment readiness by checking all file paths and directory structures

## Summary

Validates deployment readiness by comprehensively checking all file paths, directory structures, and cross-references across the agent complex ecosystem. Ensures all commands, agents, and documentation can be properly deployed and accessed in their target environments. Performs path validation for both development and production deployment scenarios.

## Usage

```bash
/agent-complex:check-paths <validation-type> "<scope>"
```

## Arguments

- `<validation-type>`: Type of path validation to perform (REQUIRED)
  - `deployment` - Validate paths for deployment readiness
  - `development` - Validate paths for development environment
  - `cross-reference` - Validate cross-references between components
  - `migration` - Validate paths for component migration
  - `cleanup` - Identify broken or unused paths
- `<scope>`: Validation scope description (REQUIRED)
  - Brief description of what to validate
  - Quote if contains spaces
  - Examples: "Complete deployment validation", "Development environment check", "Cross-reference audit"

## Examples

```bash
# Complete deployment readiness validation
/agent-complex:check-paths deployment "Complete deployment validation for production readiness"

# Development environment validation
/agent-complex:check-paths development "Validate development environment paths and structure"

# Cross-reference validation
/agent-complex:check-paths cross-reference "Validate all cross-references between components work correctly"

# Migration path validation
/agent-complex:check-paths migration "Validate paths for component migration between environments"

# Cleanup validation
/agent-complex:check-paths cleanup "Identify broken or unused paths for cleanup"
```

## What This Command Does

### Path Validation Framework

This command provides comprehensive path validation to ensure deployment readiness across all environments:

1. **Directory Structure Validation** 📁
   ```bash
   # Validate standard directory structures exist
   validate_directory_structure() {
     echo "📁 Validating directory structures..."
     
     # Agent complex directories
     local dirs_to_check=(
       ".claude/agents"
       ".claude/commands"
       ".claude/docs" 
       "ubuntu-vm/user"
       "ubuntu-vm/project"
     )
     
     for dir in "${dirs_to_check[@]}"; do
       if [ -d "$dir" ]; then
         echo "  ✅ $dir"
       else
         echo "  ❌ Missing: $dir"
       fi
     done
   }
   ```

2. **Topic-Based Path Validation** 🗂️
   ```bash
   # Validate topic-based organization
   validate_topic_structure() {
     echo "🗂️ Validating topic-based organization..."
     
     # Discover all topics
     local topics=($(find ubuntu-vm/ -mindepth 2 -maxdepth 2 -type d | cut -d/ -f3 | sort -u))
     
     for topic in "${topics[@]}"; do
       echo "📂 Topic: $topic"
       
       # Check for standard subdirectories
       for subdir in "agents" "commands" "docs" "scripts"; do
         local path="ubuntu-vm/user/$topic/$subdir"
         if [ -d "$path" ]; then
           echo "  ✅ $path"
         fi
         
         path="ubuntu-vm/project/$topic/$subdir"
         if [ -d "$path" ]; then
           echo "  ✅ $path"
         fi
       done
     done
   }
   ```

3. **File Path Resolution** 🔗
   ```bash
   # Validate file paths resolve correctly
   validate_file_paths() {
     local validation_type="$1"
     echo "🔗 Validating file path resolution..."
     
     # Find all markdown files with references
     local files_with_refs=($(grep -r -l '\.\./\|\.claude/\|ubuntu-vm/' .claude/ ubuntu-vm/ 2>/dev/null | grep '\.md$' || true))
     
     for file in "${files_with_refs[@]}"; do
       echo "📄 Checking: $(basename "$file")"
       
       # Extract file references
       local refs=($(grep -oE '\.\./[^[:space:]]+|\./[^[:space:]]+|\.claude/[^[:space:]]+|ubuntu-vm/[^[:space:]]+' "$file" | grep -E '\.md$|/$' || true))
       
       for ref in "${refs[@]}"; do
         local resolved_path
         if [[ "$ref" == ../* ]]; then
           resolved_path="$(dirname "$file")/$ref"
         elif [[ "$ref" == ./* ]]; then
           resolved_path="$(dirname "$file")/$ref"
         else
           resolved_path="$ref"
         fi
         
         if [ -e "$resolved_path" ]; then
           echo "  ✅ $ref → $resolved_path"
         else
           echo "  ❌ $ref → $resolved_path (not found)"
         fi
       done
     done
   }
   ```

4. **Deployment Path Validation** 🚀
   ```bash
   # Validate paths for deployment scenarios
   validate_deployment_paths() {
     echo "🚀 Validating deployment paths..."
     
     # Check that all referenced paths work in deployed context
     echo "📋 Deployment context validation:"
     
     # User-level deployment paths
     echo "  👤 User-level paths:"
     if [ -d "ubuntu-vm/user" ]; then
       find ubuntu-vm/user -name "*.md" | while read -r file; do
         # Check if file references resolve in deployed context
         local deployed_path="${file#ubuntu-vm/user/}"
         echo "    📄 $file → ~/.claude/$deployed_path"
       done
     fi
     
     # Project-level deployment paths
     echo "  📦 Project-level paths:"
     if [ -d "ubuntu-vm/project" ]; then
       find ubuntu-vm/project -name "*.md" | while read -r file; do
         local deployed_path="${file#ubuntu-vm/project/}"
         echo "    📄 $file → .claude/$deployed_path"
       done
     fi
   }
   ```

5. **Cross-Reference Validation** 🔄
   ```bash
   # Validate cross-references between components
   validate_cross_references() {
     echo "🔄 Validating cross-references..."
     
     # Agent → Command references
     echo "  🤖→⚙️ Agent to Command references:"
     find .claude/agents ubuntu-vm/*/agents -name "*.md" 2>/dev/null | while read -r agent_file; do
       if [ -f "$agent_file" ]; then
         local cmd_refs=($(grep -oE '/[a-z-]+:[a-z-]+' "$agent_file" 2>/dev/null || true))
         for cmd_ref in "${cmd_refs[@]}"; do
           local topic=$(echo "$cmd_ref" | cut -d: -f1 | sed 's|^/||')
           local command=$(echo "$cmd_ref" | cut -d: -f2)
           
           # Check if command exists
           if find .claude/commands ubuntu-vm/*/commands -name "$command.md" -path "*/$topic/*" 2>/dev/null | grep -q .; then
             echo "    ✅ $(basename "$agent_file") → $cmd_ref"
           else
             echo "    ❌ $(basename "$agent_file") → $cmd_ref (command not found)"
           fi
         done
       fi
     done
     
     # Command → Agent references  
     echo "  ⚙️→🤖 Command to Agent references:"
     find .claude/commands ubuntu-vm/*/commands -name "*.md" 2>/dev/null | while read -r cmd_file; do
       if [ -f "$cmd_file" ]; then
         local agent_refs=($(grep -oE '@agent-[a-z-]+:[a-z-]+' "$cmd_file" 2>/dev/null || true))
         for agent_ref in "${agent_refs[@]}"; do
           local topic_agent=$(echo "$agent_ref" | sed 's/@agent-//')
           local topic=$(echo "$topic_agent" | cut -d: -f1)
           local agent=$(echo "$topic_agent" | cut -d: -f2)
           
           # Check if agent exists
           if find .claude/agents ubuntu-vm/*/agents -name "$agent.md" -path "*/$topic/*" 2>/dev/null | grep -q .; then
             echo "    ✅ $(basename "$cmd_file") → $agent_ref"
           else
             echo "    ❌ $(basename "$cmd_file") → $agent_ref (agent not found)"
           fi
         done
       fi
     done
   }
   ```

## Path Types and Validation

### Development Paths

**Source Structure (Development):**
```
.claude/
├── agents/
├── commands/
│   └── {topic}/
└── docs/

ubuntu-vm/
├── user/{topic}/
│   ├── agents/
│   ├── commands/
│   ├── docs/
│   └── scripts/
└── project/{topic}/
    ├── agents/
    ├── commands/
    ├── docs/
    └── scripts/
```

**Validation Patterns:**
- Verify topic directories exist
- Check file organization consistency
- Validate internal references work

### Deployment Paths

**User Deployment Structure:**
```
~/.claude/
├── agents/
├── commands/
│   └── {topic}/
├── docs/
│   └── {topic}/
└── scripts/
    └── {topic}/
```

**Project Deployment Structure:**
```
.claude/
├── agents/
├── commands/
│   └── {topic}/
├── docs/
│   └── {topic}/
└── scripts/
    └── {topic}/
```

**Validation Requirements:**
- All references must work in deployed context
- Relative paths must resolve correctly
- Cross-references between components validated

### Reference Resolution

**File Reference Patterns:**
```bash
# Relative references (development)
../docs/guide.md                    # Relative to current file
./commands/deploy.md                # Current directory reference

# Absolute references (deployment)
.claude/docs/deployment-guide.md    # Project context
~/.claude/docs/user-guide.md       # User context
ubuntu-vm/project/topic/file.md     # Development context
```

**Resolution Strategy:**
1. Try exact path first
2. Try relative to current file directory
3. Try common search paths (.claude/, ubuntu-vm/)
4. Report as broken if not found in any location

## Validation Types

### Deployment Validation

**Focuses on production readiness:**
- All paths work in deployed directory structure
- No development-only path dependencies
- Cross-references resolve in target environment
- Required directories exist or can be created

### Development Validation

**Focuses on development environment:**
- Source file organization correct
- Development tooling paths work
- Local testing environment functional
- Build and deployment scripts accessible

### Cross-Reference Validation

**Focuses on component integration:**
- Agent-to-command references valid
- Command-to-agent delegations work
- Documentation cross-links functional
- Meta-command component references valid

### Migration Validation

**Focuses on component movement:**
- Source and target paths valid
- Migration won't break existing references
- New location accessible to dependents
- Migration path conflicts identified

### Cleanup Validation

**Focuses on path hygiene:**
- Identifies broken references for cleanup
- Finds unused files and directories
- Detects circular reference patterns
- Reports orphaned components

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🔍 CHECK-PATHS v1.8.0"
echo "Comprehensive path validation for deployment readiness"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 2 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:check-paths <validation-type> \"<scope>\""
    echo "  validation-type: deployment|development|cross-reference|migration|cleanup"
    echo "  scope: Description of validation scope"
    exit 1
fi

VALIDATION_TYPE="$1"
SCOPE="$2"

# Validate validation-type
case "$VALIDATION_TYPE" in
  deployment|development|cross-reference|migration|cleanup)
    echo "✅ Validation type: $VALIDATION_TYPE"
    ;;
  *)
    echo "❌ Error: Invalid validation type '$VALIDATION_TYPE'"
    echo "Valid types: deployment, development, cross-reference, migration, cleanup"
    exit 1
    ;;
esac

echo "📝 Validation scope: $SCOPE"
echo ""

# Initialize validation tracking
declare -a PATH_ISSUES=()
declare -a BROKEN_PATHS=()
declare -a RECOMMENDATIONS=()
TOTAL_PATHS=0
BROKEN_COUNT=0

# Create temporary directory for analysis
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo "🔍 Starting path validation..."
echo "────────────────────────────────"

# Validation functions
validate_directory_structure() {
    echo "📁 Directory structure validation:"
    
    local required_dirs=(
        ".claude"
        ".claude/agents"
        ".claude/commands"
        ".claude/docs"
        "ubuntu-vm"
        "ubuntu-vm/user"
        "ubuntu-vm/project"
    )
    
    local dir_issues=0
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "  ✅ $dir"
        else
            echo "  ❌ Missing: $dir"
            ((dir_issues++))
            PATH_ISSUES+=("Missing directory: $dir")
        fi
        ((TOTAL_PATHS++))
    done
    
    return $dir_issues
}

validate_topic_organization() {
    echo "🗂️ Topic organization validation:"
    
    # Discover topics from actual directory structure
    local user_topics=($(find ubuntu-vm/user -mindepth 1 -maxdepth 1 -type d 2>/dev/null | cut -d/ -f3 | sort || true))
    local project_topics=($(find ubuntu-vm/project -mindepth 1 -maxdepth 1 -type d 2>/dev/null | cut -d/ -f3 | sort || true))
    
    echo "  👤 User topics: ${user_topics[*]:-none}"
    echo "  📦 Project topics: ${project_topics[*]:-none}"
    
    local topic_issues=0
    
    # Validate user topic structure
    for topic in "${user_topics[@]}"; do
        local base_path="ubuntu-vm/user/$topic"
        echo "    📂 $topic:"
        
        for subdir in "agents" "commands" "docs" "scripts"; do
            local path="$base_path/$subdir"
            if [ -d "$path" ]; then
                echo "      ✅ $subdir/"
            else
                echo "      ⚠️ Missing: $subdir/"
            fi
            ((TOTAL_PATHS++))
        done
    done
    
    # Validate project topic structure  
    for topic in "${project_topics[@]}"; do
        local base_path="ubuntu-vm/project/$topic"
        echo "    📂 $topic:"
        
        for subdir in "agents" "commands" "docs" "scripts"; do
            local path="$base_path/$subdir"
            if [ -d "$path" ]; then
                echo "      ✅ $subdir/"
            else
                echo "      ⚠️ Missing: $subdir/"
            fi
            ((TOTAL_PATHS++))
        done
    done
    
    return $topic_issues
}

validate_file_accessibility() {
    echo "📄 File accessibility validation:"
    
    # Find all markdown files
    local md_files=($(find .claude/ ubuntu-vm/ -name "*.md" -type f 2>/dev/null | sort))
    local file_issues=0
    
    for file in "${md_files[@]}"; do
        ((TOTAL_PATHS++))
        
        if [ -r "$file" ]; then
            echo "  ✅ $(basename "$file") ($file)"
        else
            echo "  ❌ Unreadable: $file"
            ((file_issues++))
            ((BROKEN_COUNT++))
            PATH_ISSUES+=("Unreadable file: $file")
        fi
    done
    
    echo "  📊 Files checked: ${#md_files[@]}"
    return $file_issues
}

validate_cross_references() {
    echo "🔄 Cross-reference validation:"
    
    # Extract all file references from markdown files
    find .claude/ ubuntu-vm/ -name "*.md" -type f 2>/dev/null | while read -r source_file; do
        if [ -f "$source_file" ]; then
            echo "  📄 Checking references in: $(basename "$source_file")"
            
            # Extract file path references
            local file_refs=($(grep -oE '\.claude/[^[:space:]]+\.md|ubuntu-vm/[^[:space:]]+\.md|\.\./[^[:space:]]+\.md|\./[^[:space:]]+\.md' "$source_file" 2>/dev/null || true))
            
            for ref in "${file_refs[@]}"; do
                ((TOTAL_PATHS++))
                
                # Resolve relative paths
                local resolved_path
                if [[ "$ref" == ../* ]] || [[ "$ref" == ./* ]]; then
                    resolved_path="$(cd "$(dirname "$source_file")" && readlink -f "$ref" 2>/dev/null || echo "$ref")"
                else
                    resolved_path="$ref"
                fi
                
                if [ -f "$resolved_path" ]; then
                    echo "    ✅ $ref"
                else
                    echo "    ❌ $ref (broken reference)"
                    ((BROKEN_COUNT++))
                    BROKEN_PATHS+=("$source_file: $ref")
                fi
            done
        fi
    done
}

validate_deployment_readiness() {
    echo "🚀 Deployment readiness validation:"
    
    # Check for deployment-critical paths
    local critical_paths=(
        ".claude/commands"
        ".claude/agents" 
        ".claude/docs"
        "ubuntu-vm/user"
        "ubuntu-vm/project"
    )
    
    local deployment_issues=0
    
    for path in "${critical_paths[@]}"; do
        ((TOTAL_PATHS++))
        
        if [ -d "$path" ]; then
            # Check if directory has content
            local content_count=$(find "$path" -name "*.md" -type f 2>/dev/null | wc -l)
            echo "  ✅ $path ($content_count files)"
        else
            echo "  ❌ Missing critical path: $path"
            ((deployment_issues++))
            ((BROKEN_COUNT++))
            PATH_ISSUES+=("Missing deployment path: $path")
        fi
    done
    
    # Validate that deployment structure maps correctly
    echo "  🗺️ Deployment mapping validation:"
    
    # User deployments: ubuntu-vm/user/* → ~/.claude/*
    if [ -d "ubuntu-vm/user" ]; then
        find ubuntu-vm/user -name "*.md" -type f | while read -r source; do
            local target_path=$(echo "$source" | sed 's|ubuntu-vm/user/|~/.claude/|')
            echo "    📄 $source → $target_path"
        done
    fi
    
    # Project deployments: ubuntu-vm/project/* → .claude/*
    if [ -d "ubuntu-vm/project" ]; then
        find ubuntu-vm/project -name "*.md" -type f | while read -r source; do
            local target_path=$(echo "$source" | sed 's|ubuntu-vm/project/|.claude/|')
            echo "    📄 $source → $target_path"
        done
    fi
    
    return $deployment_issues
}

validate_migration_safety() {
    echo "🔄 Migration safety validation:"
    
    # Check for potential migration conflicts
    local migration_issues=0
    
    # Validate no naming conflicts between user and project
    echo "  🔍 Checking for naming conflicts:"
    
    if [ -d "ubuntu-vm/user" ] && [ -d "ubuntu-vm/project" ]; then
        # Find files with same relative paths in user and project
        local user_files=($(find ubuntu-vm/user -name "*.md" -type f | sed 's|ubuntu-vm/user/||' | sort))
        local project_files=($(find ubuntu-vm/project -name "*.md" -type f | sed 's|ubuntu-vm/project/||' | sort))
        
        for user_file in "${user_files[@]}"; do
            if [[ " ${project_files[*]} " =~ " ${user_file} " ]]; then
                echo "    ⚠️ Naming conflict: $user_file (exists in both user and project)"
                ((migration_issues++))
                PATH_ISSUES+=("Naming conflict: $user_file")
            fi
        done
    fi
    
    return $migration_issues
}

cleanup_validation() {
    echo "🧹 Cleanup validation:"
    
    # Find broken symlinks
    echo "  🔗 Broken symlinks:"
    local broken_links=($(find .claude/ ubuntu-vm/ -type l ! -exec test -e {} \; -print 2>/dev/null || true))
    
    if [ ${#broken_links[@]} -eq 0 ]; then
        echo "    ✅ No broken symlinks found"
    else
        for link in "${broken_links[@]}"; do
            echo "    ❌ Broken symlink: $link"
            ((BROKEN_COUNT++))
            BROKEN_PATHS+=("Broken symlink: $link")
        done
    fi
    
    # Find empty directories
    echo "  📁 Empty directories:"
    local empty_dirs=($(find .claude/ ubuntu-vm/ -type d -empty 2>/dev/null || true))
    
    if [ ${#empty_dirs[@]} -eq 0 ]; then
        echo "    ✅ No empty directories found"
    else
        for dir in "${empty_dirs[@]}"; do
            echo "    ⚠️ Empty directory: $dir"
            PATH_ISSUES+=("Empty directory: $dir")
        done
    fi
    
    # Find orphaned files (not referenced anywhere)
    echo "  🔍 Orphaned files:"
    find .claude/ ubuntu-vm/ -name "*.md" -type f 2>/dev/null | while read -r file; do
        local basename_file=$(basename "$file")
        local ref_count=$(grep -r -c "$basename_file\|$file" .claude/ ubuntu-vm/ 2>/dev/null | grep -v ":0$" | wc -l || echo "0")
        
        if [ "$ref_count" -eq 1 ]; then  # Only referenced by itself
            echo "    ⚠️ Potentially orphaned: $file"
        fi
    done
}

# Execute validation based on type
echo "🎯 Executing $VALIDATION_TYPE validation..."
echo ""

case "$VALIDATION_TYPE" in
  "deployment")
    validate_directory_structure
    validate_deployment_readiness
    ;;
  "development")
    validate_directory_structure
    validate_topic_organization
    validate_file_accessibility
    ;;
  "cross-reference")
    validate_cross_references
    validate_file_accessibility
    ;;
  "migration")
    validate_migration_safety
    validate_cross_references
    ;;
  "cleanup")
    cleanup_validation
    validate_file_accessibility
    ;;
esac

# Calculate metrics
if [ $TOTAL_PATHS -gt 0 ]; then
    SUCCESS_RATE=$(( (TOTAL_PATHS - BROKEN_COUNT) * 100 / TOTAL_PATHS ))
else
    SUCCESS_RATE=100
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "📊 Path Validation Results"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 Validation Summary:"
echo "  - Type: $VALIDATION_TYPE"
echo "  - Scope: $SCOPE"
echo "  - Total paths checked: $TOTAL_PATHS"
echo ""
echo "📈 Path Health Metrics:"
echo "  - Broken paths: $BROKEN_COUNT"
echo "  - Success rate: $SUCCESS_RATE%"
echo "  - Issues found: ${#PATH_ISSUES[@]}"
echo ""

if [ ${#PATH_ISSUES[@]} -gt 0 ]; then
    echo "❌ Issues found:"
    for issue in "${PATH_ISSUES[@]}"; do
        echo "  - $issue"
    done
    echo ""
fi

if [ ${#BROKEN_PATHS[@]} -gt 0 ]; then
    echo "❌ Broken paths:"
    for broken in "${BROKEN_PATHS[@]}"; do
        echo "  - $broken"
    done
    echo ""
fi

# Generate recommendations
echo "🔧 Recommendations:"
case "$VALIDATION_TYPE" in
  "deployment")
    if [ $BROKEN_COUNT -eq 0 ]; then
        RECOMMENDATIONS+=("All paths validated - ready for deployment")
    else
        RECOMMENDATIONS+=("Fix $BROKEN_COUNT broken paths before deployment")
        RECOMMENDATIONS+=("Verify deployment directory structure")
    fi
    ;;
  "development")
    if [ $BROKEN_COUNT -eq 0 ]; then
        RECOMMENDATIONS+=("Development environment paths validated")
    else
        RECOMMENDATIONS+=("Fix $BROKEN_COUNT path issues in development environment")
        RECOMMENDATIONS+=("Verify topic organization structure")
    fi
    ;;
  "cross-reference")
    if [ $BROKEN_COUNT -eq 0 ]; then
        RECOMMENDATIONS+=("All cross-references validated successfully")
    else
        RECOMMENDATIONS+=("Fix $BROKEN_COUNT broken cross-references")
        RECOMMENDATIONS+=("Review component integration patterns")
    fi
    ;;
  "migration")
    if [ ${#PATH_ISSUES[@]} -eq 0 ]; then
        RECOMMENDATIONS+=("Migration paths validated - safe to proceed")
    else
        RECOMMENDATIONS+=("Resolve ${#PATH_ISSUES[@]} migration conflicts before proceeding")
        RECOMMENDATIONS+=("Review naming conflicts and dependencies")
    fi
    ;;
  "cleanup")
    if [ ${#PATH_ISSUES[@]} -eq 0 ] && [ $BROKEN_COUNT -eq 0 ]; then
        RECOMMENDATIONS+=("No cleanup needed - all paths are healthy")
    else
        RECOMMENDATIONS+=("Clean up ${#PATH_ISSUES[@]} identified issues")
        RECOMMENDATIONS+=("Remove or fix $BROKEN_COUNT broken paths")
    fi
    ;;
esac

for recommendation in "${RECOMMENDATIONS[@]}"; do
    echo "  - $recommendation"
done

echo ""
echo "═══════════════════════════════════════════════════════════════════"
if [ $SUCCESS_RATE -eq 100 ]; then
    echo "✅ EXCELLENT: All paths validated successfully"
    exit 0
elif [ $SUCCESS_RATE -ge 95 ]; then
    echo "✅ GOOD: Path validation passed with minor issues"
    exit 0
elif [ $SUCCESS_RATE -ge 80 ]; then
    echo "⚠️ WARNING: Path validation completed with issues requiring attention"
    exit 1
else
    echo "❌ CRITICAL: Path validation failed - immediate action required"
    exit 1
fi
echo "═══════════════════════════════════════════════════════════════════"
```

## Quality Standards

### Path Validation Requirements

**Critical Paths (Must Exist):**
- Core directory structure (.claude/, ubuntu-vm/)
- Topic organization directories
- Referenced files in documentation
- Command and agent files referenced in workflows

**Warning Paths (Should Exist):**
- Optional subdirectories in topics
- Example files referenced in documentation
- External URLs in documentation
- Development-only file references

### Deployment Readiness Criteria

**Ready for Deployment:**
- All critical paths exist and accessible
- Cross-references resolve correctly
- No broken file references
- Directory structure complete

**Not Ready for Deployment:**
- Missing critical directories
- Broken cross-references
- Inaccessible required files
- Incomplete topic organization

## Error Handling

**Directory Access Errors:**
- Permission denied accessing directories
- Missing parent directories
- Symlink resolution failures

**File Validation Errors:**
- File not found errors
- Permission issues reading files
- Broken symlink detection

**Cross-Reference Errors:**
- Malformed reference patterns
- Circular reference detection
- Reference resolution timeouts

## Version History

- v1.8.0 - Enhanced deployment validation
  - Added migration safety validation
  - Improved cleanup validation with orphan detection
  - Enhanced cross-reference validation patterns
  - Added deployment mapping validation
- v1.7.0 - Cross-reference validation
  - Added agent-to-command reference validation
  - Added command-to-agent reference validation
  - Improved relative path resolution
- v1.6.0 - Topic organization validation
  - Added topic-based directory structure validation
  - Enhanced file accessibility checking
  - Improved error reporting and recommendations
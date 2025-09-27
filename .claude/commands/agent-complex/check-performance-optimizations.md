# Args: `<scope>` `<description>`. v2.0.0. Analyze agent complex components for performance optimization opportunities

## Summary

Analyzes agent complex components for performance optimization opportunities including parallel execution patterns, script migration opportunities, caching strategies, and resource optimization. Provides actionable recommendations for improving execution speed, reducing resource usage, and optimizing workflow efficiency across the agent complex ecosystem.

## Usage

```bash
/agent-complex:check-performance-optimizations <scope> "<description>"
```

## Arguments

- `<scope>`: Analysis scope (REQUIRED)
  - `all` - Complete performance analysis across all components
  - `agents` - Focus on agent performance optimization
  - `commands` - Focus on command performance optimization
  - `workflows` - Focus on workflow and meta-command performance
  - `scripts` - Focus on script performance optimization
  - `parallel` - Focus on parallel execution opportunities
- `<description>`: Specific analysis focus or optimization goal (REQUIRED)
  - Brief description of performance optimization focus
  - Quote if contains spaces
  - Examples: "Complete performance audit", "Parallel execution analysis", "Script optimization review"

## Examples

```bash
# Complete performance analysis
/agent-complex:check-performance-optimizations all "Complete performance audit for optimization opportunities"

# Agent performance optimization
/agent-complex:check-performance-optimizations agents "Optimize agent execution patterns and resource usage"

# Command performance analysis
/agent-complex:check-performance-optimizations commands "Analyze command execution efficiency and bottlenecks"

# Workflow optimization
/agent-complex:check-performance-optimizations workflows "Optimize meta-command and workflow execution patterns"

# Script performance review
/agent-complex:check-performance-optimizations scripts "Optimize script execution and resource utilization"

# Parallel execution analysis
/agent-complex:check-performance-optimizations parallel "Identify parallel execution opportunities for faster processing"
```

## What This Command Does

### Performance Analysis Framework

This command provides comprehensive performance analysis and optimization recommendations:

1. **Parallel Execution Analysis** ⚡
   ```bash
   # Identify parallel execution opportunities
   analyze_parallel_opportunities() {
     echo "⚡ Analyzing parallel execution opportunities..."
     
     # Find commands with sequential operations that could be parallelized
     find .claude/commands ubuntu-vm/*/commands -name "*.md" -type f | while read -r cmd_file; do
       if [ -f "$cmd_file" ]; then
         echo "📄 $(basename "$cmd_file"):"
         
         # Look for sequential patterns
         local sequential_count=$(grep -c "Step [0-9]" "$cmd_file" 2>/dev/null || echo "0")
         local bash_commands=$(grep -c "```bash" "$cmd_file" 2>/dev/null || echo "0")
         local tool_calls=$(grep -c "Task tool:" "$cmd_file" 2>/dev/null || echo "0")
         
         if [ $sequential_count -gt 3 ] && [ $tool_calls -gt 2 ]; then
           echo "  🚀 Parallel opportunity: $sequential_count steps, $tool_calls tool calls"
           echo "  💡 Recommend: Batch independent tool calls for better performance"
         fi
         
         # Check for repeated similar operations
         local git_ops=$(grep -c "git " "$cmd_file" 2>/dev/null || echo "0")
         local file_ops=$(grep -c "find \|ls \|grep " "$cmd_file" 2>/dev/null || echo "0")
         
         if [ $git_ops -gt 3 ]; then
           echo "  🔄 Git optimization: $git_ops git operations found"
           echo "  💡 Recommend: Combine git operations where possible"
         fi
         
         if [ $file_ops -gt 5 ]; then
           echo "  📁 File optimization: $file_ops file operations found"
           echo "  💡 Recommend: Batch file operations or use more efficient patterns"
         fi
       fi
     done
   }
   ```

2. **Script Migration Analysis** 📜
   ```bash
   # Identify commands that should be migrated to scripts
   analyze_script_migration() {
     echo "📜 Analyzing script migration opportunities..."
     
     find .claude/commands ubuntu-vm/*/commands -name "*.md" -type f | while read -r cmd_file; do
       if [ -f "$cmd_file" ]; then
         local filename=$(basename "$cmd_file" .md)
         echo "📄 $(basename "$cmd_file"):"
         
         # Calculate complexity metrics
         local line_count=$(wc -l < "$cmd_file")
         local bash_blocks=$(grep -c "```bash" "$cmd_file" 2>/dev/null || echo "0")
         local conditional_count=$(grep -c "if \|case \|while \|for " "$cmd_file" 2>/dev/null || echo "0")
         local function_count=$(grep -c "^[a-z_]*() {" "$cmd_file" 2>/dev/null || echo "0")
         
         # Migration recommendation logic
         local complexity_score=$((bash_blocks * 2 + conditional_count * 3 + function_count * 4))
         
         if [ $complexity_score -gt 15 ] || [ $line_count -gt 200 ]; then
           echo "  🎯 Script migration candidate:"
           echo "    - Complexity score: $complexity_score"
           echo "    - Line count: $line_count"
           echo "    - Bash blocks: $bash_blocks"
           echo "    - Conditionals: $conditional_count"
           echo "    - Functions: $function_count"
           echo "  💡 Recommend: Convert to executable script for better performance"
         elif [ $complexity_score -gt 8 ]; then
           echo "  ⚠️ Consider script migration: complexity score $complexity_score"
         else
           echo "  ✅ Appropriate as command file: complexity score $complexity_score"
         fi
       fi
     done
   }
   ```

3. **Resource Usage Analysis** 💾
   ```bash
   # Analyze resource usage patterns
   analyze_resource_usage() {
     echo "💾 Analyzing resource usage patterns..."
     
     # File I/O optimization opportunities
     echo "  📁 File I/O analysis:"
     local files_with_heavy_io=($(grep -r -l "find \|ls \|grep \|cat \|head \|tail" .claude/commands ubuntu-vm/*/commands 2>/dev/null | head -10))
     
     for file in "${files_with_heavy_io[@]}"; do
       local io_count=$(grep -c "find \|ls \|grep \|cat \|head \|tail" "$file" 2>/dev/null || echo "0")
       if [ $io_count -gt 10 ]; then
         echo "    🔥 High I/O: $(basename "$file") ($io_count operations)"
         echo "    💡 Recommend: Optimize file operations or cache results"
       fi
     done
     
     # Memory usage analysis
     echo "  🧠 Memory usage analysis:"
     local files_with_arrays=($(grep -r -l "declare -a\|mapfile\|readarray" .claude/commands ubuntu-vm/*/commands 2>/dev/null | head -10))
     
     for file in "${files_with_arrays[@]}"; do
       local array_count=$(grep -c "declare -a\|mapfile\|readarray" "$file" 2>/dev/null || echo "0")
       if [ $array_count -gt 5 ]; then
         echo "    📊 High array usage: $(basename "$file") ($array_count arrays)"
         echo "    💡 Recommend: Consider streaming processing for large datasets"
       fi
     done
   }
   ```

4. **Caching Strategy Analysis** 🗃️
   ```bash
   # Identify caching opportunities
   analyze_caching_opportunities() {
     echo "🗃️ Analyzing caching opportunities..."
     
     # Look for repeated expensive operations
     find .claude/commands ubuntu-vm/*/commands -name "*.md" -type f | while read -r cmd_file; do
       if [ -f "$cmd_file" ]; then
         echo "📄 $(basename "$cmd_file"):"
         
         # Network operations
         local curl_count=$(grep -c "curl \|wget " "$cmd_file" 2>/dev/null || echo "0")
         if [ $curl_count -gt 2 ]; then
           echo "  🌐 Network caching opportunity: $curl_count network calls"
           echo "  💡 Recommend: Cache network responses or batch requests"
         fi
         
         # File system scans
         local find_count=$(grep -c "find " "$cmd_file" 2>/dev/null || echo "0")
         if [ $find_count -gt 3 ]; then
           echo "  🔍 File scan caching opportunity: $find_count find operations"
           echo "  💡 Recommend: Cache file discovery results"
         fi
         
         # Git operations
         local git_count=$(grep -c "git " "$cmd_file" 2>/dev/null || echo "0")
         if [ $git_count -gt 5 ]; then
           echo "  🔄 Git caching opportunity: $git_count git operations"
           echo "  💡 Recommend: Batch git operations or cache git status"
         fi
       fi
     done
   }
   ```

5. **Workflow Optimization Analysis** 🔄
   ```bash
   # Analyze workflow execution patterns
   analyze_workflow_optimization() {
     echo "🔄 Analyzing workflow optimization opportunities..."
     
     # Meta-command analysis
     find .claude/commands ubuntu-vm/*/commands -name "run-*.md" -type f | while read -r meta_file; do
       if [ -f "$meta_file" ]; then
         echo "⚙️ Meta-command: $(basename "$meta_file"):"
         
         # Count workflow steps
         local step_count=$(grep -c "^### Step\|^## Step\|^# Step" "$meta_file" 2>/dev/null || echo "0")
         local tool_count=$(grep -c "Task tool:" "$meta_file" 2>/dev/null || echo "0")
         local bash_count=$(grep -c "```bash" "$meta_file" 2>/dev/null || echo "0")
         
         echo "  📊 Workflow metrics:"
         echo "    - Steps: $step_count"
         echo "    - Tool calls: $tool_count"
         echo "    - Bash blocks: $bash_count"
         
         # Optimization recommendations
         if [ $tool_count -gt 5 ] && [ $step_count -gt 3 ]; then
           echo "  🚀 Optimization opportunities:"
           echo "    - Batch independent tool calls in parallel"
           echo "    - Consider workflow step consolidation"
         fi
         
         if [ $bash_count -gt 10 ]; then
           echo "  📜 Script migration opportunity:"
           echo "    - Consider converting to executable script"
           echo "    - Reduce command file complexity"
         fi
       fi
     done
   }
   ```

## Performance Optimization Categories

### Parallel Execution Opportunities

**Batch Tool Calls:**
```bash
# Instead of sequential tool calls:
Task tool: "agent1: operation 1"
Task tool: "agent2: operation 2" 
Task tool: "agent3: operation 3"

# Recommend parallel execution:
# Multiple tool calls can be batched when operations are independent
```

**Parallel File Operations:**
```bash
# Instead of sequential file processing:
for file in *.md; do
  process_file "$file"
done

# Recommend parallel processing:
find . -name "*.md" -print0 | xargs -0 -P 4 -I {} process_file {}
```

### Script Migration Candidates

**High Complexity Commands:**
- Commands with >15 complexity score
- Files with >200 lines
- Commands with >10 bash blocks
- Commands with >5 functions

**Migration Benefits:**
- Faster execution (no markdown parsing)
- Better error handling
- Improved resource management
- Enhanced debugging capabilities

### Caching Strategy Recommendations

**Network Operation Caching:**
```bash
# Cache expensive network calls
cache_network_response() {
  local url="$1"
  local cache_file="/tmp/cache_$(echo "$url" | md5sum | cut -d' ' -f1)"
  
  if [ -f "$cache_file" ] && [ $(( $(date +%s) - $(stat -c %Y "$cache_file") )) -lt 300 ]; then
    cat "$cache_file"
  else
    curl "$url" | tee "$cache_file"
  fi
}
```

**File System Caching:**
```bash
# Cache file discovery results
cache_file_discovery() {
  local pattern="$1"
  local cache_file="/tmp/file_cache_$(echo "$pattern" | md5sum | cut -d' ' -f1)"
  
  if [ -f "$cache_file" ] && [ $(find . -newer "$cache_file" | wc -l) -eq 0 ]; then
    cat "$cache_file"
  else
    find . -name "$pattern" | tee "$cache_file"
  fi
}
```

### Resource Optimization

**Memory Usage Optimization:**
- Stream processing for large datasets
- Efficient array usage patterns
- Temporary file cleanup
- Variable scope optimization

**CPU Usage Optimization:**
- Reduce redundant operations
- Optimize regex patterns
- Minimize subprocess creation
- Batch similar operations

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "⚡ CHECK-PERFORMANCE-OPTIMIZATIONS v2.0.0"
echo "Comprehensive performance analysis and optimization recommendations"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 2 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:check-performance-optimizations <scope> \"<description>\""
    echo "  scope: all|agents|commands|workflows|scripts|parallel"
    echo "  description: Analysis focus or optimization goal"
    exit 1
fi

SCOPE="$1"
DESCRIPTION="$2"

# Validate scope
case "$SCOPE" in
  all|agents|commands|workflows|scripts|parallel)
    echo "✅ Analysis scope: $SCOPE"
    ;;
  *)
    echo "❌ Error: Invalid scope '$SCOPE'"
    echo "Valid scopes: all, agents, commands, workflows, scripts, parallel"
    exit 1
    ;;
esac

echo "📝 Analysis focus: $DESCRIPTION"
echo ""

# Initialize tracking
declare -a OPTIMIZATION_OPPORTUNITIES=()
declare -a HIGH_PRIORITY_OPTIMIZATIONS=()
declare -a SCRIPT_MIGRATION_CANDIDATES=()
declare -a PARALLEL_OPPORTUNITIES=()
TOTAL_COMPONENTS=0
OPTIMIZATION_SCORE=0

echo "🔍 Discovering components for analysis..."
echo "─────────────────────────────────────────"

# Component discovery based on scope
case "$SCOPE" in
  "all")
    ANALYSIS_FILES=($(find .claude/ ubuntu-vm/ -name "*.md" -type f 2>/dev/null | sort))
    ;;
  "agents")
    ANALYSIS_FILES=($(find .claude/agents ubuntu-vm/*/agents -name "*.md" -type f 2>/dev/null | sort))
    ;;
  "commands") 
    ANALYSIS_FILES=($(find .claude/commands ubuntu-vm/*/commands -name "*.md" -type f 2>/dev/null | grep -v "^run-" | sort))
    ;;
  "workflows")
    ANALYSIS_FILES=($(find .claude/commands ubuntu-vm/*/commands -name "run-*.md" -type f 2>/dev/null | sort))
    ;;
  "scripts")
    ANALYSIS_FILES=($(find .claude/scripts ubuntu-vm/*/scripts -name "*.md" -type f 2>/dev/null | sort))
    ;;
  "parallel")
    ANALYSIS_FILES=($(find .claude/commands ubuntu-vm/*/commands -name "*.md" -type f 2>/dev/null | sort))
    ;;
esac

TOTAL_COMPONENTS=${#ANALYSIS_FILES[@]}

if [ $TOTAL_COMPONENTS -eq 0 ]; then
    echo "❌ No components found for analysis scope: $SCOPE"
    exit 1
fi

echo "📋 Found $TOTAL_COMPONENTS components to analyze"
echo ""

# Performance analysis functions
calculate_complexity_score() {
    local file="$1"
    local score=0
    
    # Basic complexity metrics
    local line_count=$(wc -l < "$file")
    local bash_blocks=$(grep -c "```bash" "$file" 2>/dev/null || echo "0")
    local conditionals=$(grep -c "if \|case \|while \|for " "$file" 2>/dev/null || echo "0")
    local functions=$(grep -c "^[a-z_]*() {" "$file" 2>/dev/null || echo "0")
    local tool_calls=$(grep -c "Task tool:" "$file" 2>/dev/null || echo "0")
    
    # Calculate weighted complexity score
    score=$((
        (line_count / 50) +
        (bash_blocks * 2) +
        (conditionals * 3) +
        (functions * 4) +
        (tool_calls * 2)
    ))
    
    echo $score
}

analyze_parallel_execution() {
    local file="$1"
    local opportunities=0
    
    echo "⚡ Parallel execution analysis for: $(basename "$file")"
    
    # Check for independent tool calls
    local tool_calls=$(grep -n "Task tool:" "$file" 2>/dev/null || true)
    local tool_count=$(echo "$tool_calls" | grep -c "Task tool:" || echo "0")
    
    if [ $tool_count -gt 2 ]; then
        echo "  🎯 $tool_count tool calls found - check for parallel opportunities"
        
        # Look for sequential tool calls that could be batched
        local sequential_tools=0
        echo "$tool_calls" | while IFS=: read -r line_num content; do
            if [ -n "$content" ]; then
                ((sequential_tools++))
                if [ $sequential_tools -gt 1 ]; then
                    echo "  💡 Line $line_num: Consider batching with previous tool call"
                    ((opportunities++))
                fi
            fi
        done
    fi
    
    # Check for independent bash operations
    local bash_ops=$(grep -c "echo \|mkdir \|cp \|mv " "$file" 2>/dev/null || echo "0")
    if [ $bash_ops -gt 5 ]; then
        echo "  🔧 $bash_ops bash operations - check for batching opportunities"
        ((opportunities++))
    fi
    
    return $opportunities
}

analyze_script_migration_candidate() {
    local file="$1"
    local should_migrate=false
    
    echo "📜 Script migration analysis for: $(basename "$file")"
    
    local complexity=$(calculate_complexity_score "$file")
    local line_count=$(wc -l < "$file")
    local bash_blocks=$(grep -c "```bash" "$file" 2>/dev/null || echo "0")
    
    echo "  📊 Metrics:"
    echo "    - Complexity score: $complexity"
    echo "    - Line count: $line_count" 
    echo "    - Bash blocks: $bash_blocks"
    
    # Migration criteria
    if [ $complexity -gt 20 ] || [ $line_count -gt 300 ]; then
        echo "  🎯 HIGH PRIORITY: Strong script migration candidate"
        echo "    - Performance gain: High"
        echo "    - Maintenance benefit: High"
        SCRIPT_MIGRATION_CANDIDATES+=("$(basename "$file"): High priority - complexity $complexity")
        should_migrate=true
    elif [ $complexity -gt 10 ] || [ $line_count -gt 150 ]; then
        echo "  ⚠️ MEDIUM PRIORITY: Consider script migration"
        echo "    - Performance gain: Medium"
        echo "    - Maintenance benefit: Medium"
        SCRIPT_MIGRATION_CANDIDATES+=("$(basename "$file"): Medium priority - complexity $complexity")
    else
        echo "  ✅ Appropriate as command file"
    fi
    
    if [ "$should_migrate" = true ]; then
        return 1
    else
        return 0
    fi
}

analyze_resource_optimization() {
    local file="$1"
    
    echo "💾 Resource optimization analysis for: $(basename "$file")"
    
    # I/O optimization opportunities
    local io_heavy_ops=$(grep -c "find \|ls \|grep \|cat \|head \|tail \|awk \|sed " "$file" 2>/dev/null || echo "0")
    local temp_file_ops=$(grep -c "mktemp\|/tmp/" "$file" 2>/dev/null || echo "0")
    local subprocess_ops=$(grep -c "(\$\|eval \|exec " "$file" 2>/dev/null || echo "0")
    
    if [ $io_heavy_ops -gt 10 ]; then
        echo "  🔥 I/O intensive: $io_heavy_ops operations"
        echo "  💡 Recommend: Optimize file operations, consider caching"
        OPTIMIZATION_OPPORTUNITIES+=("$(basename "$file"): I/O optimization needed")
    fi
    
    if [ $temp_file_ops -gt 3 ]; then
        echo "  📁 Temp file usage: $temp_file_ops operations"
        echo "  💡 Recommend: Optimize temporary file management"
    fi
    
    if [ $subprocess_ops -gt 5 ]; then
        echo "  🔄 Subprocess heavy: $subprocess_ops operations"
        echo "  💡 Recommend: Reduce subprocess creation overhead"
    fi
}

analyze_workflow_efficiency() {
    local file="$1"
    
    echo "🔄 Workflow efficiency analysis for: $(basename "$file")"
    
    # Step organization analysis
    local step_count=$(grep -c "^### Step\|^## Step\|^# Step" "$file" 2>/dev/null || echo "0")
    local validation_count=$(grep -c "validate\|check\|verify" "$file" 2>/dev/null || echo "0")
    local error_handling=$(grep -c "trap \|set -e\|exit 1" "$file" 2>/dev/null || echo "0")
    
    echo "  📊 Workflow metrics:"
    echo "    - Steps: $step_count"
    echo "    - Validations: $validation_count" 
    echo "    - Error handling: $error_handling"
    
    # Efficiency recommendations
    if [ $step_count -gt 5 ] && [ $validation_count -gt 10 ]; then
        echo "  ⚡ Efficiency opportunity: $step_count steps with $validation_count validations"
        echo "  💡 Recommend: Consolidate validation steps"
    fi
    
    if [ $error_handling -lt 3 ] && [ $step_count -gt 3 ]; then
        echo "  ⚠️ Error handling: Only $error_handling error handlers for $step_count steps"
        echo "  💡 Recommend: Improve error handling coverage"
    fi
}

echo "⚡ Executing performance analysis..."
echo "─────────────────────────────────────"

# Process each component based on scope
for analysis_file in "${ANALYSIS_FILES[@]}"; do
    if [ ! -f "$analysis_file" ]; then
        continue
    fi
    
    filename=$(basename "$analysis_file")
    echo "📄 Analyzing: $filename"
    echo "   Path: $analysis_file"
    
    # Calculate base metrics
    complexity=$(calculate_complexity_score "$analysis_file")
    OPTIMIZATION_SCORE=$((OPTIMIZATION_SCORE + complexity))
    
    echo "   Complexity: $complexity"
    
    # Run scope-specific analysis
    case "$SCOPE" in
      "all"|"parallel")
        analyze_parallel_execution "$analysis_file"
        ;;
      "commands"|"workflows")
        if ! analyze_script_migration_candidate "$analysis_file"; then
            # File is high priority for migration
            HIGH_PRIORITY_OPTIMIZATIONS+=("$filename: Script migration recommended")
        fi
        ;;
      "scripts")
        analyze_resource_optimization "$analysis_file"
        ;;
    esac
    
    # Universal optimizations for all scopes
    if [[ "$SCOPE" == "all" ]]; then
        analyze_resource_optimization "$analysis_file"
        analyze_workflow_efficiency "$analysis_file"
    fi
    
    echo ""
done

# Calculate performance metrics
if [ $TOTAL_COMPONENTS -gt 0 ]; then
    AVERAGE_COMPLEXITY=$((OPTIMIZATION_SCORE / TOTAL_COMPONENTS))
else
    AVERAGE_COMPLEXITY=0
fi

HIGH_PRIORITY_COUNT=${#HIGH_PRIORITY_OPTIMIZATIONS[@]}
OPTIMIZATION_COUNT=${#OPTIMIZATION_OPPORTUNITIES[@]}
MIGRATION_COUNT=${#SCRIPT_MIGRATION_CANDIDATES[@]}

echo "═══════════════════════════════════════════════════════════════════"
echo "📊 Performance Analysis Results"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 Analysis Summary:"
echo "  - Scope: $SCOPE"
echo "  - Focus: $DESCRIPTION"
echo "  - Components analyzed: $TOTAL_COMPONENTS"
echo ""
echo "⚡ Performance Metrics:"
echo "  - Average complexity: $AVERAGE_COMPLEXITY"
echo "  - Optimization opportunities: $OPTIMIZATION_COUNT"
echo "  - High priority optimizations: $HIGH_PRIORITY_COUNT"
echo "  - Script migration candidates: $MIGRATION_COUNT"
echo ""

# Display findings
if [ $HIGH_PRIORITY_COUNT -gt 0 ]; then
    echo "🔥 High Priority Optimizations:"
    for optimization in "${HIGH_PRIORITY_OPTIMIZATIONS[@]}"; do
        echo "  - $optimization"
    done
    echo ""
fi

if [ $MIGRATION_COUNT -gt 0 ]; then
    echo "📜 Script Migration Candidates:"
    for candidate in "${SCRIPT_MIGRATION_CANDIDATES[@]}"; do
        echo "  - $candidate"
    done
    echo ""
fi

if [ $OPTIMIZATION_COUNT -gt 0 ]; then
    echo "💡 Optimization Opportunities:"
    for opportunity in "${OPTIMIZATION_OPPORTUNITIES[@]}"; do
        echo "  - $opportunity"
    done
    echo ""
fi

# Generate prioritized recommendations
echo "🔧 Prioritized Recommendations:"

if [ $AVERAGE_COMPLEXITY -gt 25 ]; then
    echo "  🔥 CRITICAL: Average complexity ($AVERAGE_COMPLEXITY) is very high"
    echo "    - Prioritize script migration for complex commands"
    echo "    - Implement parallel execution patterns"
    echo "    - Consider workflow consolidation"
elif [ $AVERAGE_COMPLEXITY -gt 15 ]; then
    echo "  ⚠️ HIGH: Average complexity ($AVERAGE_COMPLEXITY) needs attention"
    echo "    - Review script migration candidates"
    echo "    - Optimize resource-intensive operations"
    echo "    - Implement caching where beneficial"
elif [ $AVERAGE_COMPLEXITY -gt 8 ]; then
    echo "  ✅ MEDIUM: Average complexity ($AVERAGE_COMPLEXITY) is reasonable"
    echo "    - Consider minor optimizations"
    echo "    - Monitor for future complexity growth"
else
    echo "  ✅ LOW: Average complexity ($AVERAGE_COMPLEXITY) is optimal"
    echo "    - Maintain current patterns"
    echo "    - Focus on other quality dimensions"
fi

# Specific recommendations by scope
case "$SCOPE" in
  "parallel")
    if [ ${#PARALLEL_OPPORTUNITIES[@]} -gt 0 ]; then
        echo "  ⚡ Parallel execution recommendations:"
        echo "    - Batch independent tool calls"
        echo "    - Use parallel file processing patterns"
        echo "    - Implement concurrent validation steps"
    fi
    ;;
  "scripts")
    if [ $MIGRATION_COUNT -gt 0 ]; then
        echo "  📜 Script migration recommendations:"
        echo "    - Convert high-complexity commands to scripts"
        echo "    - Implement performance-optimized script versions"
        echo "    - Maintain command interfaces for compatibility"
    fi
    ;;
  "workflows")
    echo "  🔄 Workflow optimization recommendations:"
    echo "    - Consolidate similar validation steps"
    echo "    - Implement early exit patterns for failures"
    echo "    - Use caching for repeated operations"
    ;;
esac

echo ""
echo "═══════════════════════════════════════════════════════════════════"
if [ $AVERAGE_COMPLEXITY -le 10 ] && [ $HIGH_PRIORITY_COUNT -eq 0 ]; then
    echo "✅ EXCELLENT: Performance characteristics are optimal"
    exit 0
elif [ $AVERAGE_COMPLEXITY -le 20 ] && [ $HIGH_PRIORITY_COUNT -le 2 ]; then
    echo "✅ GOOD: Performance is acceptable with minor optimization opportunities"
    exit 0
elif [ $AVERAGE_COMPLEXITY -le 30 ]; then
    echo "⚠️ WARNING: Performance needs attention - optimization recommended"
    exit 1
else
    echo "❌ CRITICAL: Performance issues require immediate optimization"
    exit 1
fi
echo "═══════════════════════════════════════════════════════════════════"
```

## Quality Standards

### Performance Benchmarks

**Complexity Score Ranges:**
- 0-5: Optimal (simple, efficient)
- 6-10: Good (reasonable complexity)
- 11-20: Fair (needs monitoring)
- 21-30: Poor (optimization needed)
- 30+: Critical (immediate action required)

**Optimization Priority Matrix:**
```
High Priority (Immediate):
- Complexity score >20
- >10 tool calls in sequence
- >200 lines with >10 bash blocks

Medium Priority (Plan):
- Complexity score 10-20
- 5-10 tool calls in sequence
- 100-200 lines with 5-10 bash blocks

Low Priority (Monitor):
- Complexity score 5-10
- 2-5 tool calls
- <100 lines with <5 bash blocks
```

### Performance Optimization Goals

**Target Metrics:**
- Average complexity <15 across all components
- <20% of commands as script migration candidates
- >80% of workflows with parallel execution opportunities identified
- <5% high priority optimization issues

## Error Handling

**Analysis Errors:**
- File access permission issues
- Malformed component files
- Missing required sections for analysis

**Calculation Errors:**
- Complexity score calculation failures
- Metric aggregation errors
- Percentage calculation issues

**Recommendation Errors:**
- Invalid optimization suggestions
- Missing priority classifications
- Incomplete analysis results

## Version History

- v2.0.0 - Comprehensive performance analysis framework
  - Added complexity scoring system with weighted metrics
  - Implemented parallel execution opportunity detection
  - Added script migration analysis with priority classification
  - Enhanced resource optimization recommendations
  - Added workflow efficiency analysis
- v1.5.0 - Script migration analysis
  - Added complexity scoring for migration decisions
  - Implemented migration candidate identification
  - Added performance gain estimations
- v1.0.0 - Basic performance checking
  - Initial performance pattern detection
  - Basic optimization recommendations
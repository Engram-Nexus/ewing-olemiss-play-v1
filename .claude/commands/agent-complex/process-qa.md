# Args: `<type>` `<description>`. v2.0.0. Comprehensive QA orchestration with multi-dimensional quality validation

**🚨 COMMAND EXECUTION NOTICE**: This is a Claude command file, not a bash script. Claude will process this file and execute the appropriate operations. DO NOT attempt to run this as `/process-qa` in bash.

## Summary

Orchestrates comprehensive quality assurance across all dimensions of agent complex components. Coordinates deployment readiness validation, performance optimization analysis, documentation quality assessment, and security compliance verification. This is the central QA orchestration point that delegates to specialized check commands for thorough multi-dimensional validation.

## Command Execution

This command directly orchestrates QA validation without managing git workflows. Users should handle branch creation and PR management separately.

## Usage

```bash
/agent-complex:process-qa <type> "<description>"
```

## Arguments

- `<type>`: QA validation type (REQUIRED)
  - `user` - User-level component QA validation
  - `project` - Project-level component QA validation
  - `nexus` - Nexus-level component QA validation
  - `comprehensive` - Complete multi-type QA validation
- `<description>`: Specific QA focus or validation requirements (REQUIRED)
  - Brief description of QA validation requirements
  - Quote if contains spaces
  - Examples: "Quality validation for deployment-orchestrator agent complex", "Complete QA for production readiness"

## Examples

```bash
# User-level component QA
/agent-complex:process-qa user "Quality validation for deployment-orchestrator agent complex"

# Project-level component QA
/agent-complex:process-qa project "QA validation for edge-function-manager complex"

# Nexus-level component QA  
/agent-complex:process-qa nexus "Quality validation for auth-manager complex"

# Comprehensive QA across all types
/agent-complex:process-qa comprehensive "Complete QA validation for production deployment readiness"

# Specific component focus
/agent-complex:process-qa project "Quality validation for design-dev complex color workflow enhancement"
```

## What This Command Does

### QA Orchestration Framework

This command coordinates comprehensive quality assurance through specialized validation commands:

1. **Deployment Readiness Validation** 🚀
   ```bash
   echo "🚀 Deployment Readiness Validation"
   echo "═══════════════════════════════════"
   
   # Validate all paths work in deployed context
   /agent-complex:check-paths deployment "Deployment readiness validation for $TYPE components"
   
   if [ $? -eq 0 ]; then
     echo "✅ Deployment paths validated successfully"
     DEPLOYMENT_READY=true
   else
     echo "❌ Deployment path issues found"
     DEPLOYMENT_READY=false
     QA_ISSUES+=("Deployment path validation failed")
   fi
   ```

2. **Performance Optimization Analysis** ⚡
   ```bash
   echo ""
   echo "⚡ Performance Optimization Analysis"
   echo "═══════════════════════════════════"
   
   # Identify parallel execution and script migration opportunities
   /agent-complex:check-performance-optimizations all "Performance analysis for $TYPE components - identify parallel execution and script migration opportunities"
   
   if [ $? -eq 0 ]; then
     echo "✅ Performance analysis completed successfully"
     PERFORMANCE_OPTIMIZED=true
   else
     echo "⚠️ Performance optimization opportunities identified"
     PERFORMANCE_OPTIMIZED=false
     QA_RECOMMENDATIONS+=("Performance optimization opportunities available")
   fi
   ```

3. **Documentation Quality Assessment** 📚
   ```bash
   echo ""
   echo "📚 Documentation Quality Assessment"
   echo "═══════════════════════════════════"
   
   # Ensure AI optimization and completeness
   /agent-complex:check-documentation all "Documentation quality assessment for $TYPE components - validate AI optimization and completeness"
   
   if [ $? -eq 0 ]; then
     echo "✅ Documentation quality validated successfully"
     DOCUMENTATION_QUALITY=true
   else
     echo "⚠️ Documentation quality issues found"
     DOCUMENTATION_QUALITY=false
     QA_ISSUES+=("Documentation quality needs improvement")
   fi
   ```

4. **Security Compliance Verification** 🔒
   ```bash
   echo ""
   echo "🔒 Security Compliance Verification"
   echo "═══════════════════════════════════"
   
   # Scan for vulnerabilities and security best practices
   /agent-complex:check-security all "Security compliance verification for $TYPE components - scan for vulnerabilities and validate security best practices"
   
   if [ $? -eq 0 ]; then
     echo "✅ Security compliance validated successfully"
     SECURITY_COMPLIANT=true
   else
     echo "❌ Security compliance issues found"
     SECURITY_COMPLIANT=false
     QA_ISSUES+=("Security compliance validation failed")
   fi
   ```

5. **Reference Integrity Validation** 🔗
   ```bash
   echo ""
   echo "🔗 Reference Integrity Validation"
   echo "═══════════════════════════════════"
   
   # Validate all entity references exist
   /agent-complex:check-fictional-refs all "Reference integrity validation for $TYPE components - ensure all references exist"
   
   if [ $? -eq 0 ]; then
     echo "✅ Reference integrity validated successfully"
     REFERENCES_VALID=true
   else
     echo "❌ Reference integrity issues found"
     REFERENCES_VALID=false
     QA_ISSUES+=("Reference integrity validation failed")
   fi
   ```

## QA Validation Dimensions

### Multi-Dimensional Quality Matrix

**Quality Dimensions Validated:**
1. **Deployment Readiness** (🚀) - Critical for production
2. **Performance Optimization** (⚡) - Important for efficiency  
3. **Documentation Quality** (📚) - Essential for AI understanding
4. **Security Compliance** (🔒) - Critical for production safety
5. **Reference Integrity** (🔗) - Essential for functionality

**Quality Gate Requirements:**
```bash
# Quality gate evaluation
evaluate_quality_gate() {
  local critical_passed=0
  local total_critical=3
  
  # Critical dimensions (must pass)
  [ "$DEPLOYMENT_READY" = true ] && ((critical_passed++))
  [ "$SECURITY_COMPLIANT" = true ] && ((critical_passed++)) 
  [ "$REFERENCES_VALID" = true ] && ((critical_passed++))
  
  # Calculate pass rate
  local critical_pass_rate=$((critical_passed * 100 / total_critical))
  
  if [ $critical_pass_rate -eq 100 ]; then
    echo "✅ Quality gate: PASSED (all critical dimensions validated)"
    return 0
  else
    echo "❌ Quality gate: FAILED ($critical_passed/$total_critical critical dimensions passed)"
    return 1
  fi
}
```

### Quality Scoring System

**Dimensional Scoring:**
```bash
# Calculate overall quality score
calculate_quality_score() {
  local score=0
  local max_score=500  # 100 points per dimension
  
  # Deployment readiness (100 points)
  [ "$DEPLOYMENT_READY" = true ] && score=$((score + 100))
  
  # Performance optimization (100 points)
  [ "$PERFORMANCE_OPTIMIZED" = true ] && score=$((score + 100))
  
  # Documentation quality (100 points)
  [ "$DOCUMENTATION_QUALITY" = true ] && score=$((score + 100))
  
  # Security compliance (100 points)
  [ "$SECURITY_COMPLIANT" = true ] && score=$((score + 100))
  
  # Reference integrity (100 points)
  [ "$REFERENCES_VALID" = true ] && score=$((score + 100))
  
  echo $((score * 100 / max_score))  # Convert to percentage
}
```

## QA Reporting

### Comprehensive QA Report

**Standard Report Format:**
```bash
echo "═══════════════════════════════════════════════════════════════════"
echo "📊 Comprehensive QA Report"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 QA Summary:"
echo "  - Type: $TYPE"
echo "  - Focus: $DESCRIPTION"
echo "  - Overall Score: $QUALITY_SCORE/100"
echo ""
echo "📋 Quality Dimensions:"
echo "  🚀 Deployment Readiness: $([ "$DEPLOYMENT_READY" = true ] && echo "✅ PASS" || echo "❌ FAIL")"
echo "  ⚡ Performance Optimization: $([ "$PERFORMANCE_OPTIMIZED" = true ] && echo "✅ PASS" || echo "⚠️ OPPORTUNITIES")"
echo "  📚 Documentation Quality: $([ "$DOCUMENTATION_QUALITY" = true ] && echo "✅ PASS" || echo "❌ FAIL")"
echo "  🔒 Security Compliance: $([ "$SECURITY_COMPLIANT" = true ] && echo "✅ PASS" || echo "❌ FAIL")"
echo "  🔗 Reference Integrity: $([ "$REFERENCES_VALID" = true ] && echo "✅ PASS" || echo "❌ FAIL")"
```

### Actionable Recommendations

**Priority-Based Recommendations:**
```bash
# Generate prioritized action items
generate_qa_recommendations() {
  echo ""
  echo "🔧 QA Recommendations (Priority Order):"
  
  # Critical issues (deployment blockers)
  if [ ${#QA_ISSUES[@]} -gt 0 ]; then
    echo "  🚨 CRITICAL (Fix Before Deployment):"
    for issue in "${QA_ISSUES[@]}"; do
      echo "    - $issue"
    done
  fi
  
  # Important optimizations 
  if [ ${#QA_RECOMMENDATIONS[@]} -gt 0 ]; then
    echo "  ⚡ IMPORTANT (Optimize When Possible):"
    for recommendation in "${QA_RECOMMENDATIONS[@]}"; do
      echo "    - $recommendation"
    done
  fi
  
  # Quality improvements
  if [ "$QUALITY_SCORE" -lt 85 ]; then
    echo "  📈 IMPROVEMENT (Enhance Quality):"
    echo "    - Focus on failed quality dimensions"
    echo "    - Review component architecture patterns"
    echo "    - Consider additional validation steps"
  fi
}
```

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🎯 PROCESS-QA v2.0.0"
echo "Comprehensive QA orchestration with multi-dimensional validation"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 2 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:process-qa <type> \"<description>\""
    echo "  type: user|project|nexus|comprehensive"
    echo "  description: QA validation requirements"
    exit 1
fi

TYPE="$1"
DESCRIPTION="$2"

# Validate type
case "$TYPE" in
  user|project|nexus|comprehensive)
    echo "✅ QA type: $TYPE"
    ;;
  *)
    echo "❌ Error: Invalid type '$TYPE'"
    echo "Valid types: user, project, nexus, comprehensive"
    exit 1
    ;;
esac

echo "📝 QA focus: $DESCRIPTION"
echo ""

# Initialize QA tracking
declare -a QA_ISSUES=()
declare -a QA_RECOMMENDATIONS=()
declare -a QA_RESULTS=()

# Quality dimension flags
DEPLOYMENT_READY=false
PERFORMANCE_OPTIMIZED=false
DOCUMENTATION_QUALITY=false
SECURITY_COMPLIANT=false
REFERENCES_VALID=false

echo "🎯 Starting comprehensive QA orchestration..."
echo "════════════════════════════════════════════"

# QA Validation Step 1: Deployment Readiness
echo ""
echo "1️⃣ Deployment Readiness Validation"
echo "─────────────────────────────────────"
echo "🚀 Validating deployment paths and structure..."

if /agent-complex:check-paths deployment "Deployment readiness validation for $TYPE components"; then
    echo "✅ Deployment readiness: VALIDATED"
    DEPLOYMENT_READY=true
    QA_RESULTS+=("Deployment: ✅ READY")
else
    echo "❌ Deployment readiness: ISSUES FOUND"
    DEPLOYMENT_READY=false
    QA_ISSUES+=("Deployment path validation failed - fix before deployment")
    QA_RESULTS+=("Deployment: ❌ BLOCKED")
fi

# QA Validation Step 2: Performance Optimization
echo ""
echo "2️⃣ Performance Optimization Analysis"
echo "─────────────────────────────────────"
echo "⚡ Analyzing performance optimization opportunities..."

if /agent-complex:check-performance-optimizations all "Performance analysis for $TYPE components - identify optimization opportunities"; then
    echo "✅ Performance analysis: COMPLETED"
    PERFORMANCE_OPTIMIZED=true
    QA_RESULTS+=("Performance: ✅ OPTIMIZED")
else
    echo "⚠️ Performance analysis: OPPORTUNITIES IDENTIFIED"
    PERFORMANCE_OPTIMIZED=false
    QA_RECOMMENDATIONS+=("Performance optimization opportunities available - consider implementing")
    QA_RESULTS+=("Performance: ⚡ OPPORTUNITIES")
fi

# QA Validation Step 3: Documentation Quality
echo ""
echo "3️⃣ Documentation Quality Assessment"
echo "─────────────────────────────────────"
echo "📚 Validating documentation completeness and AI optimization..."

if /agent-complex:check-documentation all "Documentation quality assessment for $TYPE components"; then
    echo "✅ Documentation quality: VALIDATED"
    DOCUMENTATION_QUALITY=true
    QA_RESULTS+=("Documentation: ✅ QUALITY")
else
    echo "❌ Documentation quality: ISSUES FOUND"
    DOCUMENTATION_QUALITY=false
    QA_ISSUES+=("Documentation quality needs improvement - enhance before deployment")
    QA_RESULTS+=("Documentation: ❌ NEEDS_WORK")
fi

# QA Validation Step 4: Security Compliance
echo ""
echo "4️⃣ Security Compliance Verification"
echo "─────────────────────────────────────"
echo "🔒 Scanning for security vulnerabilities and compliance..."

if /agent-complex:check-security all "Security compliance verification for $TYPE components"; then
    echo "✅ Security compliance: VALIDATED"
    SECURITY_COMPLIANT=true
    QA_RESULTS+=("Security: ✅ COMPLIANT")
else
    echo "❌ Security compliance: ISSUES FOUND"
    SECURITY_COMPLIANT=false
    QA_ISSUES+=("Security compliance issues found - critical for production deployment")
    QA_RESULTS+=("Security: ❌ VULNERABLE")
fi

# QA Validation Step 5: Reference Integrity
echo ""
echo "5️⃣ Reference Integrity Validation"
echo "─────────────────────────────────────"
echo "🔗 Validating all entity references exist..."

if /agent-complex:check-fictional-refs all "Reference integrity validation for $TYPE components"; then
    echo "✅ Reference integrity: VALIDATED"
    REFERENCES_VALID=true
    QA_RESULTS+=("References: ✅ VALID")
else
    echo "❌ Reference integrity: ISSUES FOUND"
    REFERENCES_VALID=false
    QA_ISSUES+=("Reference integrity issues found - fix broken references")
    QA_RESULTS+=("References: ❌ BROKEN")
fi

# Calculate overall quality metrics
echo ""
echo "📊 Calculating quality metrics..."

# Quality gate evaluation
CRITICAL_PASSED=0
TOTAL_CRITICAL=3

# Critical dimensions (deployment blockers)
[ "$DEPLOYMENT_READY" = true ] && ((CRITICAL_PASSED++))
[ "$SECURITY_COMPLIANT" = true ] && ((CRITICAL_PASSED++))
[ "$REFERENCES_VALID" = true ] && ((CRITICAL_PASSED++))

CRITICAL_PASS_RATE=$((CRITICAL_PASSED * 100 / TOTAL_CRITICAL))

# Overall quality score (all dimensions)
QUALITY_SCORE=0
[ "$DEPLOYMENT_READY" = true ] && QUALITY_SCORE=$((QUALITY_SCORE + 25))
[ "$PERFORMANCE_OPTIMIZED" = true ] && QUALITY_SCORE=$((QUALITY_SCORE + 15))
[ "$DOCUMENTATION_QUALITY" = true ] && QUALITY_SCORE=$((QUALITY_SCORE + 20))
[ "$SECURITY_COMPLIANT" = true ] && QUALITY_SCORE=$((QUALITY_SCORE + 25))
[ "$REFERENCES_VALID" = true ] && QUALITY_SCORE=$((QUALITY_SCORE + 15))

echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "📊 Comprehensive QA Results"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 QA Summary:"
echo "  - Type: $TYPE"
echo "  - Focus: $DESCRIPTION"
echo "  - Overall Quality Score: $QUALITY_SCORE/100"
echo "  - Critical Pass Rate: $CRITICAL_PASS_RATE% ($CRITICAL_PASSED/$TOTAL_CRITICAL)"
echo ""
echo "📋 Quality Dimensions Results:"
for result in "${QA_RESULTS[@]}"; do
    echo "  $result"
done
echo ""

# Display issues and recommendations
if [ ${#QA_ISSUES[@]} -gt 0 ]; then
    echo "🚨 Critical Issues (Must Fix Before Deployment):"
    for issue in "${QA_ISSUES[@]}"; do
        echo "  - $issue"
    done
    echo ""
fi

if [ ${#QA_RECOMMENDATIONS[@]} -gt 0 ]; then
    echo "💡 Optimization Recommendations (Improve When Possible):"
    for recommendation in "${QA_RECOMMENDATIONS[@]}"; do
        echo "  - $recommendation"
    done
    echo ""
fi

# Quality gate decision
echo "🎯 Quality Gate Decision:"
if [ $CRITICAL_PASS_RATE -eq 100 ]; then
    if [ $QUALITY_SCORE -ge 90 ]; then
        echo "✅ EXCELLENT: Quality gate passed with exceptional scores"
        echo "  - Ready for immediate deployment"
        echo "  - All quality dimensions validated"
    elif [ $QUALITY_SCORE -ge 75 ]; then
        echo "✅ GOOD: Quality gate passed with good scores"
        echo "  - Ready for deployment"
        echo "  - Consider implementing optimization recommendations"
    else
        echo "✅ ACCEPTABLE: Quality gate passed with minimum requirements"
        echo "  - Ready for deployment with monitoring"
        echo "  - Plan optimization improvements"
    fi
    
    GATE_STATUS="PASSED"
else
    echo "❌ FAILED: Quality gate failed - deployment blocked"
    echo "  - Critical issues must be resolved before deployment"
    echo "  - Fix all critical dimension failures"
    echo "  - Re-run QA validation after fixes"
    
    GATE_STATUS="FAILED"
fi

echo ""
echo "📈 Next Steps:"
if [ "$GATE_STATUS" = "PASSED" ]; then
    echo "  1. ✅ Quality validation completed successfully"
    echo "  2. 🚀 Components are ready for deployment"
    if [ ${#QA_RECOMMENDATIONS[@]} -gt 0 ]; then
        echo "  3. 💡 Consider implementing optimization recommendations"
    fi
    echo "  4. 📝 Document QA validation completion"
else
    echo "  1. 🔧 Fix critical issues identified in validation"
    echo "  2. 🔄 Re-run quality validation after fixes"
    echo "  3. ✅ Ensure all critical dimensions pass"
    echo "  4. 🚀 Proceed with deployment after validation passes"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════"
if [ "$GATE_STATUS" = "PASSED" ]; then
    echo "✅ QA ORCHESTRATION COMPLETED SUCCESSFULLY"
    exit 0
else
    echo "❌ QA ORCHESTRATION COMPLETED WITH CRITICAL ISSUES"
    exit 1
fi
echo "═══════════════════════════════════════════════════════════════════"
```

## QA Orchestration Benefits

### Comprehensive Validation

**Multi-Dimensional Analysis:**
- Covers all critical quality aspects
- Coordinates specialized validation commands
- Provides unified quality assessment
- Ensures nothing is overlooked

**Automated Quality Gates:**
- Objective pass/fail criteria
- Consistent quality standards
- Automated decision making
- Clear deployment readiness signals

### Expert Coordination

**Specialized Command Integration:**
- Leverages domain-specific validation expertise
- Coordinates multiple check commands efficiently
- Provides comprehensive coverage through specialization
- Maintains consistency across validation types

**Orchestration Benefits:**
- Single entry point for complete QA
- Standardized quality assessment process
- Consistent reporting format
- Streamlined validation workflow

## Quality Standards

### Critical Quality Dimensions

**Deployment Readiness (Critical):**
- All paths resolve correctly in deployment context
- Directory structure valid for target environment
- Cross-references work in deployed state
- Required dependencies available

**Security Compliance (Critical):**
- No credential exposure vulnerabilities
- No injection vulnerability patterns
- Proper access control implementation
- Secure network communication patterns

**Reference Integrity (Critical):**
- All file references exist and accessible
- All command references valid
- All agent references functional
- All URLs accessible (where applicable)

### Important Quality Dimensions

**Documentation Quality (Important):**
- Complete documentation coverage
- AI-optimized formatting and structure
- Clear usage examples and patterns
- Comprehensive implementation details

**Performance Optimization (Important):**
- Parallel execution opportunities identified
- Script migration candidates evaluated
- Resource usage optimization reviewed
- Workflow efficiency analyzed

## Error Handling

**QA Orchestration Errors:**
- Individual check command failures
- Quality metric calculation errors
- Quality gate evaluation failures

**Validation Coordination Errors:**
- Command delegation issues
- Result aggregation problems
- Report generation failures

**Quality Assessment Errors:**
- Scoring calculation issues
- Recommendation generation failures
- Quality gate decision errors

## Version History

- v2.0.0 - Comprehensive QA orchestration framework
  - Restructured as orchestration command (removed git workflow management)
  - Added multi-dimensional quality validation
  - Implemented quality gate system with critical/important dimensions
  - Added comprehensive scoring and recommendation system
  - Enhanced reporting with actionable next steps
- v1.5.0 - Multi-dimensional QA validation
  - Added performance optimization analysis
  - Added security compliance verification
  - Added reference integrity validation
  - Improved quality scoring system
- v1.0.0 - Basic QA orchestration
  - Initial deployment readiness validation
  - Basic documentation quality checking
  - Simple pass/fail reporting
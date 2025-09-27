# Args: `<scope>` `<description>`. v2.0.0. Comprehensive security vulnerability analysis and compliance validation

## Summary

Performs comprehensive security vulnerability analysis and compliance validation across agent complex components. Scans for security anti-patterns, validates secure coding practices, checks for credential exposure, and ensures compliance with security best practices. Provides prioritized security recommendations with actionable remediation steps.

## Usage

```bash
/agent-complex:check-security <scope> "<description>"
```

## Arguments

- `<scope>`: Security analysis scope (REQUIRED)
  - `all` - Complete security audit across all components
  - `credentials` - Focus on credential and secret management
  - `injection` - Focus on injection vulnerability analysis
  - `permissions` - Focus on permission and access control validation
  - `network` - Focus on network security and API security
  - `compliance` - Focus on security compliance standards
- `<description>`: Specific security focus or compliance requirement (REQUIRED)
  - Brief description of security analysis focus
  - Quote if contains spaces
  - Examples: "Complete security audit", "Credential exposure scan", "Injection vulnerability analysis"

## Examples

```bash
# Complete security audit
/agent-complex:check-security all "Complete security audit for production deployment"

# Credential security analysis
/agent-complex:check-security credentials "Scan for credential exposure and secret management issues"

# Injection vulnerability analysis
/agent-complex:check-security injection "Analyze for SQL injection and command injection vulnerabilities"

# Permission validation
/agent-complex:check-security permissions "Validate access control and permission models"

# Network security analysis
/agent-complex:check-security network "Analyze network security patterns and API security"

# Compliance validation
/agent-complex:check-security compliance "Validate security compliance with industry standards"
```

## What This Command Does

### Security Analysis Framework

This command provides comprehensive security analysis across multiple dimensions:

1. **Credential Security Analysis** 🔐
   ```bash
   # Scan for credential exposure patterns
   analyze_credential_security() {
     echo "🔐 Credential security analysis..."
     
     # Dangerous credential patterns
     local dangerous_patterns=(
       "password"
       "secret"
       "token"
       "api[_-]?key"
       "private[_-]?key"
       "client[_-]?secret"
       "access[_-]?token"
     )
     
     find .claude/ ubuntu-vm/ -name "*.md" -type f | while read -r file; do
       echo "🔍 Scanning: $(basename "$file")"
       
       for pattern in "${dangerous_patterns[@]}"; do
         local matches=$(grep -i -n "$pattern" "$file" 2>/dev/null || true)
         if [ -n "$matches" ]; then
           echo "$matches" | while IFS=: read -r line_num content; do
             # Check if it's in a code block or example (safer)
             if echo "$content" | grep -q '```\|#.*example\|#.*sample'; then
               echo "  ⚠️ Line $line_num: $pattern found in example/code block"
             else
               echo "  🚨 Line $line_num: $pattern found in documentation - review for exposure"
             fi
           done
         fi
       done
     done
   }
   ```

2. **Injection Vulnerability Analysis** 💉
   ```bash
   # Analyze for injection vulnerabilities
   analyze_injection_vulnerabilities() {
     echo "💉 Injection vulnerability analysis..."
     
     # SQL injection patterns
     echo "  🗄️ SQL injection analysis:"
     find .claude/ ubuntu-vm/ -name "*.md" -type f | while read -r file; do
       local sql_patterns=$(grep -n "sql\|query\|database" "$file" 2>/dev/null | grep -v "```" || true)
       if [ -n "$sql_patterns" ]; then
         echo "    📄 $(basename "$file"):"
         
         # Check for unsafe SQL construction
         local unsafe_sql=$(grep -n "\$\|concat\|+.*sql\|sql.*+" "$file" 2>/dev/null || true)
         if [ -n "$unsafe_sql" ]; then
           echo "$unsafe_sql" | while IFS=: read -r line_num content; do
             echo "      🚨 Line $line_num: Potential SQL injection risk"
           done
         else
           echo "      ✅ No obvious SQL injection patterns found"
         fi
       fi
     done
     
     # Command injection patterns
     echo "  💻 Command injection analysis:"
     find .claude/ ubuntu-vm/ -name "*.md" -type f | while read -r file; do
       local cmd_patterns=$(grep -n "exec\|eval\|system\|\$(" "$file" 2>/dev/null | grep -v "```bash" || true)
       if [ -n "$cmd_patterns" ]; then
         echo "    📄 $(basename "$file"):"
         echo "$cmd_patterns" | while IFS=: read -r line_num content; do
           echo "      ⚠️ Line $line_num: Review for command injection risk"
         done
       fi
     done
   }
   ```

3. **Permission and Access Control Analysis** 🔒
   ```bash
   # Analyze permission models and access control
   analyze_permissions() {
     echo "🔒 Permission and access control analysis..."
     
     # Check for privilege escalation patterns
     echo "  ⬆️ Privilege escalation analysis:"
     find .claude/ ubuntu-vm/ -name "*.md" -type f | while read -r file; do
       local privilege_patterns=$(grep -n "sudo\|root\|admin\|privilege" "$file" 2>/dev/null || true)
       if [ -n "$privilege_patterns" ]; then
         echo "    📄 $(basename "$file"):"
         echo "$privilege_patterns" | while IFS=: read -r line_num content; do
           if echo "$content" | grep -q "sudo"; then
             echo "      🚨 Line $line_num: sudo usage found - validate necessity"
           else
             echo "      ⚠️ Line $line_num: privilege-related content - review"
           fi
         done
       fi
     done
     
     # Access control validation
     echo "  🎭 Access control validation:"
     find .claude/ ubuntu-vm/ -name "*.md" -type f | while read -r file; do
       # Check for role-based access patterns
       local access_patterns=$(grep -n "ALLOWED_\|permission\|role\|access" "$file" 2>/dev/null || true)
       if [ -n "$access_patterns" ]; then
         echo "    📄 $(basename "$file"):"
         local access_controls=$(echo "$access_patterns" | wc -l)
         echo "      ✅ $access_controls access control references found"
       fi
     done
   }
   ```

4. **Network Security Analysis** 🌐
   ```bash
   # Analyze network security patterns
   analyze_network_security() {
     echo "🌐 Network security analysis..."
     
     # URL and endpoint security
     echo "  🔗 URL and endpoint security:"
     find .claude/ ubuntu-vm/ -name "*.md" -type f | while read -r file; do
       # Extract URLs and analyze security
       local urls=$(grep -oE 'https?://[^[:space:]]+' "$file" 2>/dev/null || true)
       if [ -n "$urls" ]; then
         echo "    📄 $(basename "$file"):"
         echo "$urls" | while read -r url; do
           if [[ "$url" =~ ^http:// ]]; then
             echo "      🚨 Insecure HTTP: $url"
           elif [[ "$url" =~ localhost\|127\.0\.0\.1 ]]; then
             echo "      ⚠️ Local endpoint: $url (review for production)"
           else
             echo "      ✅ Secure HTTPS: $url"
           fi
         done
       fi
     done
     
     # API security patterns
     echo "  🔌 API security patterns:"
     find .claude/ ubuntu-vm/ -name "*.md" -type f | while read -r file; do
       local api_patterns=$(grep -n "api\|endpoint\|webhook" "$file" 2>/dev/null || true)
       if [ -n "$api_patterns" ]; then
         # Check for authentication patterns
         local auth_found=$(grep -c "auth\|token\|key\|bearer" "$file" 2>/dev/null || echo "0")
         if [ $auth_found -gt 0 ]; then
           echo "    ✅ $(basename "$file"): Authentication patterns found"
         else
           echo "    ⚠️ $(basename "$file"): API usage without obvious authentication"
         fi
       fi
     done
   }
   ```

5. **Compliance Validation** 📋
   ```bash
   # Validate security compliance standards
   analyze_compliance() {
     echo "📋 Security compliance analysis..."
     
     # Data handling compliance
     echo "  📊 Data handling compliance:"
     find .claude/ ubuntu-vm/ -name "*.md" -type f | while read -r file; do
       # Check for data handling patterns
       local data_patterns=$(grep -n "user.*data\|personal.*info\|sensitive\|pii" "$file" 2>/dev/null || true)
       if [ -n "$data_patterns" ]; then
         echo "    📄 $(basename "$file"):"
         
         # Check for data protection measures
         local protection_found=$(grep -c "encrypt\|hash\|sanitize\|validate" "$file" 2>/dev/null || echo "0")
         if [ $protection_found -gt 0 ]; then
           echo "      ✅ Data protection measures found"
         else
           echo "      🚨 Data handling without obvious protection measures"
         fi
       fi
     done
     
     # Error handling compliance
     echo "  🛡️ Error handling compliance:"
     find .claude/ ubuntu-vm/ -name "*.md" -type f | while read -r file; do
       local error_handling=$(grep -c "try\|catch\|trap\|set -e" "$file" 2>/dev/null || echo "0")
       local bash_blocks=$(grep -c "```bash" "$file" 2>/dev/null || echo "0")
       
       if [ $bash_blocks -gt 0 ]; then
         local error_ratio=$((error_handling * 100 / bash_blocks))
         if [ $error_ratio -lt 30 ]; then
           echo "    ⚠️ $(basename "$file"): Low error handling coverage ($error_ratio%)"
         else
           echo "    ✅ $(basename "$file"): Good error handling coverage ($error_ratio%)"
         fi
       fi
     done
   }
   ```

## Security Vulnerability Categories

### Critical Vulnerabilities (Immediate Action)

**Credential Exposure:**
- Hardcoded passwords or API keys
- Secrets in documentation or examples
- Unencrypted credential storage
- Credential logging or debugging output

**Injection Vulnerabilities:**
- SQL injection through string concatenation
- Command injection via unsanitized input
- Path traversal vulnerabilities
- Code injection through eval/exec

**Access Control Bypass:**
- Missing authentication checks
- Privilege escalation opportunities
- Insecure permission models
- Role-based access control gaps

### High Risk Issues (Plan Remediation)

**Network Security:**
- Insecure HTTP endpoints
- Missing TLS/SSL validation
- Unvalidated external API calls
- Insecure webhook implementations

**Data Handling:**
- Unencrypted sensitive data
- Inadequate input validation
- Missing data sanitization
- Insufficient error handling

### Medium Risk Issues (Monitor)

**Configuration Security:**
- Insecure default configurations
- Missing security headers
- Weak permission settings
- Inadequate logging/monitoring

**Code Quality Security:**
- Insufficient error handling
- Missing input validation
- Inadequate boundary checking
- Poor secret management practices

## Security Best Practices Validation

### Secure Coding Standards

**Input Validation Requirements:**
```bash
# Validate all user inputs
validate_input() {
  local input="$1"
  local pattern="$2"
  
  if [[ ! "$input" =~ $pattern ]]; then
    echo "Invalid input format" >&2
    return 1
  fi
}

# Sanitize shell inputs
sanitize_shell_input() {
  local input="$1"
  # Remove dangerous characters
  echo "$input" | sed 's/[;&|`$(){}]//g'
}
```

**Error Handling Standards:**
```bash
# Always use proper error handling
set -euo pipefail

# Trap cleanup functions
cleanup() {
  rm -f "$TEMP_FILE"
}
trap cleanup EXIT

# Validate operations before execution
if ! validate_preconditions; then
  echo "Precondition validation failed" >&2
  exit 1
fi
```

### Secure API Patterns

**Authentication Requirements:**
```bash
# Always validate authentication
if [ -z "$AUTH_TOKEN" ]; then
  echo "Authentication required" >&2
  exit 1
fi

# Use secure API call patterns
curl -H "Authorization: Bearer $AUTH_TOKEN" \
     -H "Content-Type: application/json" \
     --connect-timeout 10 \
     --max-time 30 \
     "$API_ENDPOINT"
```

**Input Sanitization:**
```bash
# Sanitize user inputs for API calls
sanitize_api_input() {
  local input="$1"
  # URL encode and validate
  python3 -c "import urllib.parse; print(urllib.parse.quote('$input'))"
}
```

## Implementation

```bash
#!/bin/bash
set -euo pipefail

echo "═══════════════════════════════════════════════════════════════════"
echo "🔒 CHECK-SECURITY v2.0.0"
echo "Comprehensive security vulnerability analysis and compliance validation"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

# Parse arguments
if [ $# -lt 2 ]; then
    echo "❌ Error: Missing required arguments"
    echo "Usage: /agent-complex:check-security <scope> \"<description>\""
    echo "  scope: all|credentials|injection|permissions|network|compliance"
    echo "  description: Security analysis focus"
    exit 1
fi

SCOPE="$1"
DESCRIPTION="$2"

# Validate scope
case "$SCOPE" in
  all|credentials|injection|permissions|network|compliance)
    echo "✅ Security scope: $SCOPE"
    ;;
  *)
    echo "❌ Error: Invalid scope '$SCOPE'"
    echo "Valid scopes: all, credentials, injection, permissions, network, compliance"
    exit 1
    ;;
esac

echo "📝 Security focus: $DESCRIPTION"
echo ""

# Initialize security tracking
declare -a CRITICAL_ISSUES=()
declare -a HIGH_RISK_ISSUES=()
declare -a MEDIUM_RISK_ISSUES=()
declare -a COMPLIANCE_ISSUES=()
TOTAL_FILES=0
SECURITY_SCORE=100
FILES_WITH_ISSUES=0

echo "🔍 Discovering files for security analysis..."
echo "─────────────────────────────────────────────"

# Discover target files
ANALYSIS_FILES=($(find .claude/ ubuntu-vm/ -name "*.md" -type f 2>/dev/null | sort))
TOTAL_FILES=${#ANALYSIS_FILES[@]}

if [ $TOTAL_FILES -eq 0 ]; then
    echo "❌ No files found for security analysis"
    exit 1
fi

echo "📋 Found $TOTAL_FILES files to analyze"
echo ""

# Security analysis functions
analyze_credential_exposure() {
    local file="$1"
    local issues=0
    
    echo "🔐 Credential exposure analysis:"
    
    # Critical credential patterns
    local critical_patterns=(
        "password\s*=\s*[\"'][^\"']+[\"']"
        "secret\s*=\s*[\"'][^\"']+[\"']"
        "token\s*=\s*[\"'][^\"']+[\"']"
        "api[_-]?key\s*=\s*[\"'][^\"']+[\"']"
    )
    
    for pattern in "${critical_patterns[@]}"; do
        local matches=$(grep -i -n -E "$pattern" "$file" 2>/dev/null || true)
        if [ -n "$matches" ]; then
            echo "  🚨 CRITICAL: Potential credential exposure found"
            echo "$matches" | while IFS=: read -r line_num content; do
                echo "    Line $line_num: $(echo "$content" | sed 's/[=:].*/=[REDACTED]/')"
            done
            ((issues+=5))  # Critical issues heavily weighted
        fi
    done
    
    # Warning patterns (environment variables, etc.)
    local warning_patterns=(
        "\\\$[A-Z_]+.*PASSWORD"
        "\\\$[A-Z_]+.*SECRET"
        "\\\$[A-Z_]+.*TOKEN"
        "\\\$[A-Z_]+.*KEY"
    )
    
    for pattern in "${warning_patterns[@]}"; do
        local matches=$(grep -i -n -E "$pattern" "$file" 2>/dev/null || true)
        if [ -n "$matches" ]; then
            echo "  ⚠️ Environment variable credential usage found"
            echo "$matches" | while IFS=: read -r line_num content; do
                echo "    Line $line_num: Verify secure handling"
            done
            ((issues+=1))
        fi
    done
    
    return $issues
}

analyze_injection_risks() {
    local file="$1"
    local issues=0
    
    echo "💉 Injection vulnerability analysis:"
    
    # SQL injection risks
    echo "  🗄️ SQL injection risks:"
    local sql_concat=$(grep -n "sql.*\$\|concat.*sql\|\$.*sql" "$file" 2>/dev/null || true)
    if [ -n "$sql_concat" ]; then
        echo "    🚨 Potential SQL injection via string concatenation:"
        echo "$sql_concat" | while IFS=: read -r line_num content; do
            echo "      Line $line_num: $(echo "$content" | tr -d '\n')"
        done
        ((issues+=3))
    fi
    
    # Command injection risks  
    echo "  💻 Command injection risks:"
    local cmd_injection=$(grep -n "eval\|exec\|\$(\|system(" "$file" 2>/dev/null | grep -v "```bash" || true)
    if [ -n "$cmd_injection" ]; then
        echo "    🚨 Potential command injection:"
        echo "$cmd_injection" | while IFS=: read -r line_num content; do
            echo "      Line $line_num: $(echo "$content" | tr -d '\n')"
        done
        ((issues+=3))
    fi
    
    # Path traversal risks
    echo "  📁 Path traversal risks:"
    local path_traversal=$(grep -n "\.\./\|\.\.\\\\|%2e%2e" "$file" 2>/dev/null || true)
    if [ -n "$path_traversal" ]; then
        echo "    ⚠️ Path traversal patterns found:"
        echo "$path_traversal" | while IFS=: read -r line_num content; do
            echo "      Line $line_num: Validate path boundaries"
        done
        ((issues+=2))
    fi
    
    return $issues
}

analyze_access_control() {
    local file="$1"
    local issues=0
    
    echo "🔒 Access control analysis:"
    
    # Check for access control implementation
    local auth_patterns=$(grep -c "auth\|login\|permission\|role\|access" "$file" 2>/dev/null || echo "0")
    local operations=$(grep -c "delete\|create\|update\|execute" "$file" 2>/dev/null || echo "0")
    
    if [ $operations -gt 2 ] && [ $auth_patterns -eq 0 ]; then
        echo "  🚨 Operations without access control validation"
        echo "    Operations found: $operations"
        echo "    Access control references: $auth_patterns"
        ((issues+=3))
    else
        echo "  ✅ Access control patterns appear adequate"
    fi
    
    # Check for privilege checks
    local privilege_checks=$(grep -c "ALLOWED_\|has.*permission\|check.*role" "$file" 2>/dev/null || echo "0")
    if [ $operations -gt 1 ] && [ $privilege_checks -eq 0 ]; then
        echo "  ⚠️ Limited privilege validation for operations"
        ((issues+=1))
    fi
    
    return $issues
}

analyze_network_security() {
    local file="$1"
    local issues=0
    
    echo "🌐 Network security analysis:"
    
    # Insecure protocols
    local insecure_urls=$(grep -n "http://" "$file" 2>/dev/null || true)
    if [ -n "$insecure_urls" ]; then
        echo "  🚨 Insecure HTTP protocols found:"
        echo "$insecure_urls" | while IFS=: read -r line_num content; do
            echo "    Line $line_num: Use HTTPS instead"
        done
        ((issues+=2))
    fi
    
    # Curl security analysis
    local curl_usage=$(grep -n "curl " "$file" 2>/dev/null || true)
    if [ -n "$curl_usage" ]; then
        echo "  🔗 Curl usage analysis:"
        echo "$curl_usage" | while IFS=: read -r line_num content; do
            if echo "$content" | grep -q -- "--insecure\|-k"; then
                echo "    🚨 Line $line_num: Insecure curl options found"
                ((issues+=3))
            elif echo "$content" | grep -q -- "--connect-timeout\|--max-time"; then
                echo "    ✅ Line $line_num: Timeout configured"
            else
                echo "    ⚠️ Line $line_num: Consider adding timeouts"
                ((issues+=1))
            fi
        done
    fi
    
    return $issues
}

validate_security_compliance() {
    local file="$1"
    local issues=0
    
    echo "📋 Security compliance validation:"
    
    # Error handling compliance
    local error_handling=$(grep -c "set -e\|trap\|try\|catch" "$file" 2>/dev/null || echo "0")
    local bash_blocks=$(grep -c "```bash" "$file" 2>/dev/null || echo "0")
    
    if [ $bash_blocks -gt 0 ]; then
        local error_ratio=$((error_handling * 100 / bash_blocks))
        if [ $error_ratio -lt 30 ]; then
            echo "  ⚠️ Low error handling coverage: $error_ratio%"
            ((issues+=1))
        else
            echo "  ✅ Good error handling coverage: $error_ratio%"
        fi
    fi
    
    # Input validation compliance
    local validation_patterns=$(grep -c "validate\|sanitize\|check.*input" "$file" 2>/dev/null || echo "0")
    local input_usage=$(grep -c "\$1\|\$2\|\$@\|read " "$file" 2>/dev/null || echo "0")
    
    if [ $input_usage -gt 0 ] && [ $validation_patterns -eq 0 ]; then
        echo "  🚨 Input usage without validation patterns"
        ((issues+=2))
    else
        echo "  ✅ Input validation patterns found"
    fi
    
    return $issues
}

echo "🔒 Executing security analysis..."
echo "────────────────────────────────"

# Process each file based on scope
for analysis_file in "${ANALYSIS_FILES[@]}"; do
    if [ ! -f "$analysis_file" ]; then
        continue
    fi
    
    filename=$(basename "$analysis_file")
    echo "📄 Analyzing: $filename"
    echo "   Path: $analysis_file"
    
    file_issues=0
    
    # Run scope-specific analysis
    case "$SCOPE" in
      "all")
        if ! analyze_credential_exposure "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        if ! analyze_injection_risks "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        if ! analyze_access_control "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        if ! analyze_network_security "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        if ! validate_security_compliance "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        ;;
      "credentials")
        if ! analyze_credential_exposure "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        ;;
      "injection")
        if ! analyze_injection_risks "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        ;;
      "permissions")
        if ! analyze_access_control "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        ;;
      "network")
        if ! analyze_network_security "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        ;;
      "compliance")
        if ! validate_security_compliance "$analysis_file"; then
            file_issues=$((file_issues + $?))
        fi
        ;;
    esac
    
    # Categorize issues by severity
    if [ $file_issues -ge 5 ]; then
        CRITICAL_ISSUES+=("$filename: $file_issues critical security issues")
        SECURITY_SCORE=$((SECURITY_SCORE - 20))
        ((FILES_WITH_ISSUES++))
    elif [ $file_issues -ge 3 ]; then
        HIGH_RISK_ISSUES+=("$filename: $file_issues high risk issues")
        SECURITY_SCORE=$((SECURITY_SCORE - 10))
        ((FILES_WITH_ISSUES++))
    elif [ $file_issues -gt 0 ]; then
        MEDIUM_RISK_ISSUES+=("$filename: $file_issues medium risk issues")
        SECURITY_SCORE=$((SECURITY_SCORE - 5))
        ((FILES_WITH_ISSUES++))
    else
        echo "   ✅ No security issues found"
    fi
    
    echo ""
done

# Ensure security score doesn't go below 0
if [ $SECURITY_SCORE -lt 0 ]; then
    SECURITY_SCORE=0
fi

echo "═══════════════════════════════════════════════════════════════════"
echo "🛡️ Security Analysis Results"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "🎯 Analysis Summary:"
echo "  - Scope: $SCOPE"
echo "  - Focus: $DESCRIPTION"
echo "  - Files analyzed: $TOTAL_FILES"
echo ""
echo "🔒 Security Metrics:"
echo "  - Security score: $SECURITY_SCORE/100"
echo "  - Files with issues: $FILES_WITH_ISSUES"
echo "  - Critical issues: ${#CRITICAL_ISSUES[@]}"
echo "  - High risk issues: ${#HIGH_RISK_ISSUES[@]}"
echo "  - Medium risk issues: ${#MEDIUM_RISK_ISSUES[@]}"
echo ""

# Display security issues by severity
if [ ${#CRITICAL_ISSUES[@]} -gt 0 ]; then
    echo "🚨 CRITICAL Security Issues (Immediate Action Required):"
    for issue in "${CRITICAL_ISSUES[@]}"; do
        echo "  - $issue"
    done
    echo ""
fi

if [ ${#HIGH_RISK_ISSUES[@]} -gt 0 ]; then
    echo "🔥 HIGH RISK Security Issues (Plan Remediation):"
    for issue in "${HIGH_RISK_ISSUES[@]}"; do
        echo "  - $issue"
    done
    echo ""
fi

if [ ${#MEDIUM_RISK_ISSUES[@]} -gt 0 ]; then
    echo "⚠️ MEDIUM RISK Security Issues (Monitor):"
    for issue in "${MEDIUM_RISK_ISSUES[@]}"; do
        echo "  - $issue"
    done
    echo ""
fi

# Generate security recommendations
echo "🔧 Security Recommendations:"

if [ $SECURITY_SCORE -ge 90 ]; then
    echo "  ✅ Excellent security posture - maintain current practices"
    echo "  - Continue regular security reviews"
    echo "  - Monitor for new vulnerability patterns"
elif [ $SECURITY_SCORE -ge 75 ]; then
    echo "  ✅ Good security posture with minor improvements needed"
    echo "  - Address medium risk issues when convenient"
    echo "  - Enhance input validation patterns"
elif [ $SECURITY_SCORE -ge 50 ]; then
    echo "  ⚠️ Security posture needs improvement"
    echo "  - Priority: Address high risk issues"
    echo "  - Implement comprehensive input validation"
    echo "  - Review and enhance error handling"
elif [ $SECURITY_SCORE -ge 25 ]; then
    echo "  🔥 Security posture requires immediate attention"
    echo "  - URGENT: Address all critical issues"
    echo "  - Implement security-first development practices"
    echo "  - Consider security architecture review"
else
    echo "  🚨 CRITICAL security posture - immediate action required"
    echo "  - STOP: Address critical vulnerabilities before deployment"
    echo "  - Implement comprehensive security overhaul"
    echo "  - Consider security expert consultation"
fi

# Scope-specific recommendations
case "$SCOPE" in
  "credentials")
    echo "  🔐 Credential security recommendations:"
    echo "    - Use environment variables for all secrets"
    echo "    - Implement secret rotation policies"
    echo "    - Use secure credential storage systems"
    ;;
  "injection")
    echo "  💉 Injection prevention recommendations:"
    echo "    - Implement parameterized queries for all SQL"
    echo "    - Sanitize all user inputs before processing"
    echo "    - Use allowlist validation instead of blocklist"
    ;;
  "permissions")
    echo "  🔒 Access control recommendations:"
    echo "    - Implement principle of least privilege"
    echo "    - Use role-based access control (RBAC)"
    echo "    - Validate permissions for all operations"
    ;;
  "network")
    echo "  🌐 Network security recommendations:"
    echo "    - Use HTTPS for all external communications"
    echo "    - Implement request timeouts and rate limiting"
    echo "    - Validate all external API integrations"
    ;;
  "compliance")
    echo "  📋 Compliance recommendations:"
    echo "    - Implement comprehensive error handling"
    echo "    - Add input validation for all user inputs"
    echo "    - Document security practices and procedures"
    ;;
esac

echo ""
echo "═══════════════════════════════════════════════════════════════════"
if [ $SECURITY_SCORE -ge 85 ] && [ ${#CRITICAL_ISSUES[@]} -eq 0 ]; then
    echo "✅ EXCELLENT: Security analysis passed - ready for deployment"
    exit 0
elif [ $SECURITY_SCORE -ge 70 ] && [ ${#CRITICAL_ISSUES[@]} -eq 0 ]; then
    echo "✅ GOOD: Security analysis passed with minor recommendations"
    exit 0
elif [ ${#CRITICAL_ISSUES[@]} -eq 0 ]; then
    echo "⚠️ WARNING: Security issues found - address before deployment"
    exit 1
else
    echo "❌ CRITICAL: Critical security issues found - immediate action required"
    exit 1
fi
echo "═══════════════════════════════════════════════════════════════════"
```

## Security Compliance Standards

### Industry Best Practices

**OWASP Compliance:**
- Input validation and sanitization
- Authentication and session management
- Access control and authorization
- Security logging and monitoring

**Secure Development Lifecycle:**
- Security by design principles
- Threat modeling considerations
- Secure coding standards
- Regular security reviews

### Security Testing Requirements

**Static Analysis:**
- Code pattern security scanning
- Credential exposure detection
- Injection vulnerability analysis
- Access control validation

**Dynamic Analysis:**
- Runtime security behavior
- Permission boundary testing
- Error handling validation
- Network security verification

## Error Handling

**Analysis Errors:**
- File access permission issues
- Pattern matching failures
- Security scanning timeouts

**Classification Errors:**
- Risk level assessment failures
- Score calculation errors
- Recommendation generation issues

**Reporting Errors:**
- Issue categorization failures
- Metric aggregation problems
- Report formatting errors

## Version History

- v2.0.0 - Comprehensive security analysis framework
  - Added multi-dimensional security analysis (credentials, injection, permissions, network, compliance)
  - Implemented severity-based issue classification (critical, high, medium risk)
  - Added security scoring system with weighted metrics
  - Enhanced compliance validation with industry standards
  - Added actionable remediation recommendations
- v1.5.0 - Enhanced vulnerability detection
  - Added injection vulnerability analysis
  - Improved credential exposure detection
  - Added network security patterns
- v1.0.0 - Basic security checking
  - Initial credential scanning
  - Basic security pattern detection
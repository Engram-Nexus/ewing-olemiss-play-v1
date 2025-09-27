# Args: `<topic/subtopic:block>` `[base-branch]` `[--description <"description">]`. v1.1.1. Orchestrate complete knowledge update workflow with git branch management, agent coordination, and PR creation.

Input: $ARGUMENTS (format: topic/subtopic:block [base-branch] [--description "description"])

## Usage

```bash
/run-update-knowledge <topic>
/run-update-knowledge <topic> <base-branch>
/run-update-knowledge <topic> <base-branch> --description "description content"
/run-update-knowledge <topic/subtopic> <base-branch>
/run-update-knowledge <topic/subtopic:block> <base-branch> --description "block content"
/run-update-knowledge <topic/subtopic1/subtopic2:block> <base-branch> --description "nested block content"
```

## Arguments

- `<topic/subtopic:block>`: Knowledge topic path with optional subtopics and block
  - **Format**: `topic` creates/updates topic matrix README
  - **Format**: `topic/subtopic` creates/updates subtopic matrix README
  - **Format**: `topic/subtopic:block` creates/updates specific block file in subtopic
  - **Format**: `topic/subtopic1/subtopic2:block` supports infinite nesting
  - **Structure**: Subtopics are folders within topic folders
  - **Blocks**: .md files within topic/subtopic folders
  - **Notation**: Use colon (:) to separate the path from the block name
- `[base-branch]`: Base branch for feature creation (default: "dev")
  - **Optional**: If omitted, defaults to "dev" branch
  - **Feature branch**: Creates isolated feature branch for knowledge changes
  - **CRITICAL**: Must be a valid branch in the repository
- `[--description <"description">]`: Knowledge description or content to add/update
  - **Format**: Must use --description flag followed by quoted text
  - **Optional**: If omitted, will update matrix based on existing blocks
  - **Required**: When creating new blocks or updating specific content
  - **Usage**: `--description "Your knowledge content here"`

## Examples

### Standard Knowledge Updates
```bash
# Topic matrix update only (uses default 'dev' base branch)
/run-update-knowledge authentication

# Subtopic matrix update with specific base branch
/run-update-knowledge authentication/oauth main

# Deep subtopic nesting
/run-update-knowledge security/compliance/gdpr dev

# Block-specific update with single subtopic
/run-update-knowledge authentication/oauth:jwt-implementation main --description "JWT tokens provide stateless authentication with short expiry times"

# Block update with multiple nested subtopics
/run-update-knowledge database/migrations/schema:reversible-changes develop --description "Always use reversible migrations for schema changes"

# Complex nested subtopic with block
/run-update-knowledge security/compliance/gdpr/data-protection:encryption main --description "GDPR requires encryption of personal data at rest and in transit"
```

### YouTube-to-SOP Conversion Examples
```bash
# Convert YouTube tutorial to development SOP
/run-update-knowledge development/setup:claude-guide main --description "Convert this YouTube tutorial https://www.youtube.com/watch?v=abc123 to an SOP for Claude Code setup. Create comprehensive installation and configuration steps."

# Convert deployment video to DevOps SOP with timestamps
/run-update-knowledge devops/deployment:docker-sop dev --description "This YouTube video https://youtu.be/xyz789 shows Docker deployment. Convert to SOP with --timestamps for step references."

# Convert troubleshooting video to support SOP
/run-update-knowledge support/troubleshooting:common-issues main --description "YouTube troubleshooting guide https://www.youtube.com/watch?v=def456 - convert to diagnostic SOP with step-by-step resolution procedures."

# Convert security tutorial with chapter organization
/run-update-knowledge security/compliance:gdpr-procedures dev --description "Convert YouTube GDPR tutorial https://www.youtube.com/watch?v=sec123 to compliance SOP with --chapters organization for audit procedures."
```

## What This Command Does

This meta-command orchestrates the complete knowledge update workflow, managing git operations while delegating knowledge processing to the specialized update-knowledge command.

### 🔐 Pre-flight Validation and Git Setup

1. **Validate working environment** 🚨⚡ MANDATORY PREREQUISITE VALIDATION ⚡🚨
   
   **🔴 CRITICAL VALIDATION CHECKPOINT:**
   ```bash
   # Verify git repository
   if ! git rev-parse --git-dir > /dev/null 2>&1; then
       echo "❌ ERROR: Not in a git repository"
       echo "This command requires a git repository for feature branch workflow"
       exit 1
   fi
   
   # Verify clean working directory
   if [ -n "$(git status --porcelain)" ]; then
       echo "❌ ERROR: Uncommitted changes detected"
       echo "Please commit or stash changes before running knowledge update workflow"
       git status
       exit 1
   fi
   
   # Verify not already on knowledge feature branch
   CURRENT_BRANCH=$(git branch --show-current)
   if [[ "$CURRENT_BRANCH" == knowledge/* ]]; then
       echo "❌ ERROR: Already on a knowledge feature branch ($CURRENT_BRANCH)"
       echo "Please switch to base branch before creating new knowledge workflow"
       exit 1
   fi
   
   # Validate base branch exists
   BASE_BRANCH="${2:-dev}"
   if ! git show-ref --verify --quiet refs/heads/"$BASE_BRANCH"; then
       echo "❌ ERROR: Base branch '$BASE_BRANCH' does not exist"
       echo "Available branches:"
       git branch -a
       exit 1
   fi
   
   echo "✅ Pre-flight validation completed - Environment ready for knowledge workflow"
   ```

2. **Sync base branch** 🚨⚡ BASE BRANCH SYNCHRONIZATION ⚡🚨
   
   **🚀 OPTIMIZED BASE BRANCH SYNC:**
   ```bash
   echo "🔄 Syncing base branch: $BASE_BRANCH"
   
   # Switch to base branch
   git checkout "$BASE_BRANCH"
   if [ $? -ne 0 ]; then
       echo "❌ Failed to checkout base branch: $BASE_BRANCH"
       exit 1
   fi
   
   # Pull latest changes from remote
   git pull origin "$BASE_BRANCH"
   if [ $? -ne 0 ]; then
       echo "❌ Failed to sync with remote: origin/$BASE_BRANCH"
       exit 1
   fi
   
   # Verify clean state after sync
   if [ -n "$(git status --porcelain)" ]; then
       echo "❌ ERROR: Working directory not clean after base branch sync"
       git status
       exit 1
   fi
   
   echo "✅ Base branch synchronized: $BASE_BRANCH"
   ```

3. **Create knowledge feature branch** 🚨⚡ FEATURE BRANCH CREATION ⚡🚨
   
   **🔴 AUTO-GENERATED BRANCH NAMING:**
   ```bash
   # Parse topic/subtopic path for branch naming
   TOPIC_PATH="$1"
   if [[ "$TOPIC_PATH" == *":"* ]]; then
       # Extract path part (everything before colon)
       PATH_PART=$(echo "$TOPIC_PATH" | cut -d':' -f1)
   else
       PATH_PART="$TOPIC_PATH"
   fi
   
   # Generate knowledge feature branch name
   CLEAN_PATH=$(echo "$PATH_PART" | tr '/' '-' | tr '[:upper:]' '[:lower:]')
   FEATURE_BRANCH="knowledge/$CLEAN_PATH"
   
   echo "🌿 Creating knowledge feature branch: $FEATURE_BRANCH"
   git checkout -b "$FEATURE_BRANCH"
   
   if [ $? -ne 0 ]; then
       echo "❌ Failed to create feature branch: $FEATURE_BRANCH"
       exit 1
   fi
   
   echo "✅ Knowledge feature branch created: $FEATURE_BRANCH"
   ```

### 📚 Knowledge Processing with YouTube Integration

4. **Detect and process YouTube-to-SOP requests** 🚨⚡ YOUTUBE-TO-SOP DETECTION ⚡🚨
   
   **🚀 INTELLIGENT YOUTUBE CONTENT DETECTION:**
   ```bash
   # Parse description from flag format
   DESCRIPTION=""
   if [[ "$@" == *"--description"* ]]; then
       # Extract description value after --description flag
       DESCRIPTION=$(echo "$@" | sed -n 's/.*--description \(.*\)/\1/p' | sed 's/^"\(.*\)"$/\1/')
   fi
   
   # Detection patterns for YouTube conversion
   YOUTUBE_PATTERNS=(
       "youtube"
       "video"
       "sop from"
       "convert youtube"
       "youtube.com"
       "youtu.be"
       "transcript"
       "video tutorial"
       "tutorial video"
   )
   
   # Check if description contains YouTube conversion request
   YOUTUBE_DETECTED=false
   for pattern in "${YOUTUBE_PATTERNS[@]}"; do
       if [[ "${DESCRIPTION,,}" == *"$pattern"* ]]; then
           YOUTUBE_DETECTED=true
           echo "📺 YouTube content detected: $pattern"
           break
       fi
   done
   
   # Extract YouTube URL from description if detected
   YOUTUBE_URL=""
   if [ "$YOUTUBE_DETECTED" = true ]; then
       # Extract URLs matching YouTube patterns
       YOUTUBE_URL=$(echo "$DESCRIPTION" | grep -oE 'https?://(www\.)?(youtube\.com/watch\?v=|youtu\.be/)[a-zA-Z0-9_-]+' | head -1)
       
       if [[ -n "$YOUTUBE_URL" ]]; then
           echo "✅ YouTube URL extracted: $YOUTUBE_URL"
       else
           echo "⚠️  YouTube pattern detected but no valid URL found"
           echo "Please provide YouTube URL in description for conversion"
           YOUTUBE_DETECTED=false
       fi
   fi
   
   # Extract optional flags from description
   YOUTUBE_FLAGS=""
   if [[ "$DESCRIPTION" == *"--timestamps"* ]]; then
       YOUTUBE_FLAGS="$YOUTUBE_FLAGS --timestamps"
       echo "📍 Timestamp preservation requested"
   fi
   
   if [[ "$DESCRIPTION" == *"--chapters"* ]]; then
       YOUTUBE_FLAGS="$YOUTUBE_FLAGS --chapters"
       echo "📖 Chapter organization requested"
   fi
   
   echo "YouTube detection result: $YOUTUBE_DETECTED"
   ```

5. **Execute knowledge operations with conditional YouTube processing** 🚨⚡ TASK TOOL COMMAND INVOCATION ⚡🚨
   
   **🚨 CRITICAL: Use Claude's Task tool for knowledge command execution**
   
   **Conditional processing based on YouTube detection:**
   ```bash
   if [ "$YOUTUBE_DETECTED" = true ] && [[ -n "$YOUTUBE_URL" ]]; then
       echo "📺 YOUTUBE-TO-SOP WORKFLOW DETECTED"
       echo "================================"
       echo "📹 Video URL: $YOUTUBE_URL"
       echo "🎯 Target: $1"
       echo "📋 Description: $DESCRIPTION"
       echo ""
       
       echo "⚠️  MANUAL TRANSCRIPT REQUIRED:"
       echo "This workflow requires a video transcript to proceed."
       echo "Please:"
       echo "1. Go to the YouTube video: $YOUTUBE_URL"
       echo "2. Click on the transcript button or use YouTube's transcript feature"
       echo "3. Copy the transcript text"
       echo ""
       read -p "Press Enter when you have the transcript ready..."
       echo ""
       echo "Please paste the transcript (press Ctrl+D when done):"
       TRANSCRIPT=$(cat)
       echo ""
       echo "✅ Transcript received ($(echo "$TRANSCRIPT" | wc -w) words)"
       echo ""
       
       # Pre-process content with convert-youtube-to-sop
       echo "🔄 Converting YouTube content to SOP..."
       echo "🚨 EXECUTE USING TASK TOOL:"
       echo "Task tool: \"/knowledge:convert-youtube-to-sop \"$1\" \"$YOUTUBE_URL\" \"$TRANSCRIPT\" \"$DESCRIPTION\"\""
       echo ""
       read -p "Press Enter when YouTube-to-SOP conversion is complete..."
       echo ""
       echo "✅ YouTube-to-SOP conversion completed"
       echo "🔄 Proceeding with standard knowledge workflow..."
   else
       echo "📚 STANDARD KNOWLEDGE WORKFLOW"
       echo "=============================="
   fi
   
   # Execute standard knowledge processing
   echo "📚 Delegating to knowledge processing command..."
   
   Task tool: "/knowledge:update-knowledge $@"
   
   # The update-knowledge command handles:
   # - Agent orchestration (knowledge:researcher + knowledge:architect)
   # - Knowledge structure creation and updates
   # - Matrix generation and integration
   # - Content validation and formatting
   ```

### 🔄 Git Workflow Completion

6. **Commit knowledge changes** 🚨⚡ CONVENTIONAL COMMIT CREATION ⚡🚨
   
   **🚀 AUTOMATED COMMIT WITH CONVENTIONAL FORMAT:**
   ```bash
   echo "📝 Committing knowledge updates..."
   
   # Verify knowledge changes exist
   if [ -z "$(git status --porcelain .knowledge/)" ]; then
       echo "⚠️  No knowledge changes detected"
       echo "The update-knowledge command may not have made changes"
       git status
   else
       # Stage knowledge directory changes
       git add .knowledge/
       
       # Generate conventional commit message
       TOPIC_PATH="$1"
       STATEMENT="$DESCRIPTION"
       
       # Determine commit type based on YouTube detection
       if [ "$YOUTUBE_DETECTED" = true ] && [[ -n "$YOUTUBE_URL" ]]; then
           # YouTube-to-SOP conversion commit
           VIDEO_ID=$(echo "$YOUTUBE_URL" | grep -oE '[a-zA-Z0-9_-]{11}' | tail -1)
           if [[ "$TOPIC_PATH" == *":"* ]]; then
               COMMIT_MSG="docs(knowledge): add SOP from YouTube video $VIDEO_ID to $(echo "$TOPIC_PATH" | tr ':' ' ') block"
           else
               COMMIT_MSG="docs(knowledge): add SOP from YouTube video $VIDEO_ID to $TOPIC_PATH"
           fi
       else
           # Standard knowledge update commit
           if [[ "$TOPIC_PATH" == *":"* ]]; then
               # Block-specific update
               COMMIT_MSG="docs(knowledge): update $(echo "$TOPIC_PATH" | tr ':' ' ') block"
           else
               # Matrix update
               COMMIT_MSG="docs(knowledge): update $TOPIC_PATH matrix"
           fi
           
           # Add statement context if provided
           if [[ -n "$STATEMENT" ]]; then
               COMMIT_MSG="$COMMIT_MSG - $(echo "$STATEMENT" | cut -c1-50)..."
           fi
       fi
       
       # Create conventional commit
       git commit -m "$COMMIT_MSG"
       
       if [ $? -eq 0 ]; then
           echo "✅ Knowledge changes committed successfully"
       else
           echo "❌ Failed to commit knowledge changes"
           exit 1
       fi
   fi
   ```

7. **Push feature branch to remote** 🚨⚡ REMOTE COLLABORATION SETUP ⚡🚨
   
   **🚀 PUSH TO REMOTE FOR TEAM COLLABORATION:**
   ```bash
   echo "🚀 Pushing feature branch to remote..."
   
   git push -u origin "$FEATURE_BRANCH"
   
   if [ $? -eq 0 ]; then
       echo "✅ Feature branch pushed: $FEATURE_BRANCH"
       echo "🔗 Branch is ready for pull request creation"
   else
       echo "❌ Failed to push feature branch to remote"
       exit 1
   fi
   ```

8. **Create pull request** 🚨⚡ AUTOMATED PR CREATION ⚡🚨
   
   **🚀 PRIMARY METHOD: GitHub CLI (gh):**
   ```bash
   echo "📋 Creating pull request..."
   
   # Check if GitHub CLI is available
   if command -v gh &> /dev/null; then
       # Build PR title based on update type and YouTube detection
       TOPIC_PATH="$1"
       if [ "$YOUTUBE_DETECTED" = true ] && [[ -n "$YOUTUBE_URL" ]]; then
           # YouTube-to-SOP PR title
           if [[ "$TOPIC_PATH" == *":"* ]]; then
               PR_TITLE="docs(knowledge): add YouTube SOP to $(echo "$TOPIC_PATH" | tr ':' ' ') knowledge block"
           else
               PR_TITLE="docs(knowledge): add YouTube SOP to $TOPIC_PATH knowledge area"
           fi
       else
           # Standard knowledge update PR title
           if [[ "$TOPIC_PATH" == *":"* ]]; then
               PR_TITLE="docs(knowledge): update $(echo "$TOPIC_PATH" | tr ':' ' ') knowledge block"
           else
               PR_TITLE="docs(knowledge): update $TOPIC_PATH knowledge matrix"
           fi
       fi
       
       # Create PR with descriptive content (YouTube-aware)
       if [ "$YOUTUBE_DETECTED" = true ] && [[ -n "$YOUTUBE_URL" ]]; then
           # YouTube-to-SOP PR body
           PR_BODY="## YouTube-to-SOP Conversion Overview
   
   **Topic Path**: \`$TOPIC_PATH\`
   **Base Branch**: \`$BASE_BRANCH\`
   **Source Video**: $YOUTUBE_URL
   **Conversion Type**: YouTube Video → Standard Operating Procedure (SOP)
   $(if [[ -n "$YOUTUBE_FLAGS" ]]; then echo "**Processing Flags**: $YOUTUBE_FLAGS"; fi)
   
   ## Changes Made
   - Converted YouTube video content to structured SOP documentation
   - Integrated SOP into \`.knowledge/\` directory structure
   - Updated knowledge matrices to include new SOP block
   - Applied agent orchestration for comprehensive content analysis
   - Generated step-by-step procedures with timestamp references
   
   ## Content Integration
   - **Knowledge Context**: SOP placed within $TOPIC_PATH knowledge domain
   - **Cross-References**: Linked to related knowledge blocks and procedures
   - **Matrix Updates**: Integrated into knowledge navigation system
   - **Format**: Follows established SOP template with metadata and checklists
   
   ## Review Checklist
   - [ ] SOP content accurately reflects video demonstrations
   - [ ] Step-by-step instructions are clear and actionable
   - [ ] Timestamp references work correctly with source video
   - [ ] Prerequisites and requirements are comprehensive
   - [ ] Integration with existing knowledge is appropriate
   - [ ] Matrix structure properly includes new SOP
   - [ ] Cross-references and links work correctly
   - [ ] Formatting follows SOP template standards
   
   ## Generated by YouTube-to-SOP Workflow
   This PR was created by the \`run-update-knowledge\` meta-command with YouTube-to-SOP conversion capabilities, combining video content processing with knowledge architecture optimization.
   
   🤖 Generated with [Claude Code](https://claude.ai/code)
   
   Co-Authored-By: Claude <noreply@anthropic.com>"
       else
           # Standard knowledge update PR body
           PR_BODY="## Knowledge Update Overview
   
   **Topic Path**: \`$TOPIC_PATH\`
   **Base Branch**: \`$BASE_BRANCH\`
   $(if [[ -n "$STATEMENT" ]]; then echo "**Content**: $STATEMENT"; fi)
   
   ## Changes Made
   - Updated knowledge structure in \`.knowledge/\` directory
   - Integrated agent research and architectural guidance
   - Regenerated matrices with enhanced subtopic support
   
   ## Review Checklist
   - [ ] Knowledge content is accurate and well-researched
   - [ ] Matrix structure properly integrates all blocks and subtopics
   - [ ] Subtopic hierarchy is logical and navigable
   - [ ] Agent orchestration provided comprehensive analysis
   - [ ] All cross-references and links work correctly
   
   ## Generated by Knowledge Update Workflow
   This PR was created by the \`run-update-knowledge\` meta-command using dual-agent orchestration for optimal knowledge management.
   
   🤖 Generated with [Claude Code](https://claude.ai/code)
   
   Co-Authored-By: Claude <noreply@anthropic.com>"
       fi
       
       gh pr create \
         --base "$BASE_BRANCH" \
         --head "$FEATURE_BRANCH" \
         --title "$PR_TITLE" \
         --body "$PR_BODY"
       
       if [ $? -eq 0 ]; then
           echo "✅ Pull request created successfully"
           gh pr view --web
       else
           echo "❌ Failed to create pull request using GitHub CLI"
           echo "📌 Manual PR creation required:"
           echo "   Base: $BASE_BRANCH"
           echo "   Head: $FEATURE_BRANCH"
           echo "   Title: $PR_TITLE"
       fi
   else
       echo "⚠️  GitHub CLI not available - manual PR creation required"
       echo "📌 Create PR manually with these details:"
       echo "   Base branch: $BASE_BRANCH"
       echo "   Feature branch: $FEATURE_BRANCH"
       echo "   Topic: $TOPIC_PATH"
   fi
   ```

### 📊 Workflow Summary and Validation

9. **Validate and summarize workflow completion**
   
   ```bash
   echo ""
   echo "🎉 KNOWLEDGE UPDATE WORKFLOW COMPLETED"
   echo "=================================="
   echo "📚 Topic: $TOPIC_PATH"
   echo "🌿 Feature Branch: $FEATURE_BRANCH"
   echo "🎯 Base Branch: $BASE_BRANCH"
   if [[ -n "$DESCRIPTION" ]]; then
       echo "💬 Content: $DESCRIPTION"
   fi
   echo ""
   echo "📋 Next Steps:"
   echo "1. Review the pull request for accuracy"
   echo "2. Request reviews from knowledge domain experts"
   echo "3. Merge after approval to integrate knowledge updates"
   echo ""
   echo "🔍 Validate structure:"
   echo "   tree .knowledge/$(echo "$TOPIC_PATH" | cut -d':' -f1)"
   echo ""
   ```

## Common RUN Commands During Execution

### Git Workflow Operations
- RUN `git status` - Check repository state before and after operations
- RUN `git branch --show-current` - Verify current branch context
- RUN `git log --oneline -5` - Review recent commits
- RUN `git diff --name-only` - See changed files

### Knowledge Structure Validation
- RUN `tree .knowledge/<topic>` - Display knowledge structure
- RUN `find .knowledge/<topic> -name "*.md"` - List all knowledge files
- RUN `grep -r "^#" .knowledge/<topic>/` - Show all headers and structure

### Pull Request Management
- RUN `gh pr list` - List open pull requests
- RUN `gh pr view` - View current PR details
- RUN `gh pr status` - Check PR status and checks

## Requirements

- Git installed and configured with push access to remote repository
- GitHub CLI (gh) recommended for automated PR creation
- Clean working directory (no uncommitted changes)
- Valid base branch exists in repository
- Access to update-knowledge command for processing delegation
- Write permissions to .knowledge/ directory

## Error Handling

- **Not in git repository**: Fails with clear error message
- **Uncommitted changes**: Fails with instruction to clean working directory
- **Already on knowledge branch**: Fails with instruction to switch to base branch
- **Invalid base branch**: Validates branch exists before proceeding
- **Git operation failures**: Provides detailed error messages with recovery steps
- **Knowledge processing failures**: Delegates error handling to update-knowledge command
- **PR creation failures**: Falls back to manual instructions
- **Network/remote failures**: Provides offline workflow continuation guidance

## Notes

- **Workflow orchestration**: This meta-command handles the complete git workflow lifecycle
- **Knowledge delegation**: Actual knowledge processing is delegated to the specialized update-knowledge command
- **Feature branch isolation**: All knowledge changes happen on dedicated feature branches
- **Conventional commits**: Uses standardized commit message format for consistency
- **Team collaboration**: Automatically pushes branches and creates PRs for team review
- **Graceful fallbacks**: Continues workflow even when optional tools (like GitHub CLI) are unavailable
- **Agent coordination**: The delegated update-knowledge command handles agent orchestration
- **Quality assurance**: PR templates include comprehensive review checklists

## Version History

- v1.1.1 - Updated argument format for description
  - Changed `["statement"]` argument to `[--description <"description">]` flag format
  - Updated all usage examples to use --description flag
  - Modified implementation to parse --description flag correctly
  - Ensures agent recognition of description argument
- v1.1.0 - YouTube-to-SOP Integration Enhancement
  - **MAJOR FEATURE**: Added intelligent YouTube content detection and conversion
  - YouTube pattern recognition with URL extraction from descriptions
  - Automatic invocation of convert-youtube-to-sop command when detected
  - Optional flag parsing (--timestamps, --chapters) from descriptions
  - Manual transcript integration workflow with user prompts
  - YouTube-specific commit messages and PR templates
  - Enhanced error handling for YouTube conversion failures
  - SOP integration modes in update-knowledge command
  - Comprehensive documentation for YouTube-to-SOP workflow
- v1.0.0 - Initial release: Complete knowledge update workflow orchestration
  - Git branch management (validation, sync, feature branch creation)
  - Knowledge processing delegation to specialized update-knowledge command
  - Automated commit creation with conventional format
  - Remote push and PR creation with comprehensive templates
  - Error handling and graceful fallbacks for all operations
  - Comprehensive validation and summary reporting
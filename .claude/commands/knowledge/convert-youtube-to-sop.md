---
description: Convert YouTube video transcript to SOP documentation in knowledge base
arguments:
  - name: topic/subtopic:block
    description: Knowledge base path for SOP storage (format: topic, topic/subtopic, or topic/subtopic:block)
    required: true
  - name: youtube-url
    description: The YouTube video URL (youtube.com/watch?v= or youtu.be/)
    required: true
  - name: transcript
    description: The video transcript text (should include timestamps if available)
    required: true
  - name: statement
    description: User guidance for SOP content and context
    required: true
  - name: _preview
    description: "Convert YouTube video transcript to SOP documentation in knowledge base"
version: "2.3.1"
category: "knowledge"
icon: "📺"
---

## Usage

This command converts a YouTube video transcript into a Standard Operating Procedure (SOP) document within the knowledge base structure. It processes the provided transcript into structured documentation and integrates it into the specified knowledge topic/subtopic as a block, keeping SOPs organized within their relevant knowledge domains.

```bash
# Convert a development tutorial video to SOP in development workflows topic
/convert-youtube-to-sop "development/workflows:setup-guide" "https://www.youtube.com/watch?v=xyz123" "Full transcript text here..." "This is a tutorial on setting up Claude Code. Please create a comprehensive setup SOP with clear step-by-step instructions."

# Convert a deployment guide video to SOP in DevOps deployment subtopic  
/convert-youtube-to-sop "devops/deployment:docker-sop" "https://www.youtube.com/watch?v=abc456" "Transcript content..." "This covers Docker deployment. Please create a comprehensive deployment SOP with prerequisites and troubleshooting."

# Convert a troubleshooting video to SOP in support topic
/convert-youtube-to-sop "support:troubleshooting-common-issues" "https://youtu.be/def789" "Video transcript text..." "This shows how to debug common issues. Please create a troubleshooting SOP with clear diagnostic steps."
```

## Arguments

- `<topic/subtopic:block>`: Knowledge base path for SOP storage (REQUIRED - FIRST ARGUMENT)
  - **Format**: `topic` creates SOP in topic root (e.g., `development`)
  - **Format**: `topic/subtopic` creates SOP in subtopic (e.g., `devops/deployment`)
  - **Format**: `topic/subtopic:block` creates named SOP block (e.g., `development/workflows:setup-guide`)
  - **Format**: `topic/subtopic1/subtopic2:block` supports infinite nesting
  - **Path Examples**:
    - `development:claude-setup` → `docs/knowledge/development/claude-setup-sop.md`
    - `devops/deployment:docker-guide` → `docs/knowledge/devops/deployment/docker-guide-sop.md`
    - `support/troubleshooting:common-issues` → `docs/knowledge/support/troubleshooting/common-issues-sop.md`
- `<youtube-url>`: The full YouTube video URL
  - Must be a valid YouTube URL (youtube.com/watch?v= or youtu.be/)
  - Used for metadata and timestamp linking
- `<transcript>`: The full video transcript text
  - Should include timestamps if available
  - Can be copied from YouTube's transcript feature or other sources
- `<statement>`: User guidance for SOP content and context
  - Describes the purpose and scope of the SOP
  - Provides context about the content and intended audience
  - Used by the agent to understand how to structure and format the SOP
  - Should focus on SOP content rather than placement (placement is determined by topic/subtopic path)

## Examples

```bash
# Convert a Claude Code tutorial to development topic with specific block name
/convert-youtube-to-sop "development:claude-code-setup" "https://www.youtube.com/watch?v=dQw4w9WgXcQ" "0:00 Welcome to this tutorial on Claude Code..." "This is a comprehensive Claude Code setup tutorial. Please create a detailed SOP covering installation, configuration, and first-time usage."

# Convert a Docker deployment video to devops/deployment subtopic
/convert-youtube-to-sop "devops/deployment:docker-best-practices" "https://youtu.be/abc123" "In this video, we'll deploy using Docker..." "This covers Docker deployment best practices. Please create an SOP including security considerations, performance optimization, and monitoring setup."

# Convert a troubleshooting guide to support topic
/convert-youtube-to-sop "support:general-troubleshooting" "https://www.youtube.com/watch?v=xyz789" "Today we're fixing common issues..." "This addresses common troubleshooting scenarios. Please create a comprehensive diagnostic SOP with step-by-step resolution procedures."

# Convert a security tutorial to nested subtopic path
/convert-youtube-to-sop "security/compliance/gdpr:data-protection-sop" "https://www.youtube.com/watch?v=sec123" "Security best practices video..." "This covers GDPR compliance procedures. Please create a detailed SOP for data protection protocols and audit requirements."
```

## What This Command Does

1. **Validates inputs**
   - Checks if transcript is provided
   - Verifies YouTube URL format
   - Validates topic/subtopic:block path format
   - Validates statement guidance is provided

2. **Parses knowledge base path**
   - Extracts topic and subtopic(s) from path argument
   - Determines if block name is specified (after colon)
   - Validates path structure and creates directory hierarchy
   - Example: `devops/deployment:docker-guide` → topic: `devops`, subtopic: `deployment`, block: `docker-guide`

3. **Extracts video ID from URL**
   - Parses YouTube URL to get video ID
   - Used for generating filename and references
   - Preserves video link for timestamp references

4. **Processes transcript into SOP**
   - Analyzes transcript for key steps and procedures
   - Identifies tools, platforms, and resources mentioned
   - Extracts actionable instructions and best practices
   - Organizes content into logical sections
   - Preserves timestamps if available for video linking

5. **Generates SOP block document**
   - Creates structured markdown document with SOP suffix
   - Includes metadata (source video, knowledge path, date)
   - Formats steps with clear numbering and timestamp links
   - Adds prerequisites and requirements sections
   - Includes tips, warnings, and best practices
   - Embeds checklist within the document
   - Adds introduction/summary linking to knowledge context

6. **Saves to knowledge base structure**
   - Creates file in `docs/knowledge/{topic}/{subtopic}/{block-name}-sop.md`
   - Ensures directory structure exists
   - Filename format: `{block-name}-sop.md` or `sop-{video-id}.md` if no block specified
   - Example paths:
     - `development:setup` → `docs/knowledge/development/setup-sop.md`
     - `devops/deployment:docker` → `docs/knowledge/devops/deployment/docker-sop.md`

7. **Updates knowledge matrices**
   - Regenerates README.md matrices for affected topic/subtopic
   - Integrates SOP block into knowledge navigation
   - Updates parent topic matrices as needed
   - Maintains consistent knowledge base structure

8. **Adds contextual integration**
   - Links SOP to related knowledge blocks in the same topic/subtopic
   - Adds summary introduction explaining SOP relevance to knowledge domain
   - Creates cross-references to related procedural knowledge
   - Ensures SOP fits cohesively within knowledge architecture

9. **Commits changes**
   - RUN `git add docs/knowledge/` - Stage all knowledge changes
   - RUN `git commit -m "docs(knowledge): add SOP from YouTube video {video-id} to {topic/subtopic}"` - Commit
   - **NOTE**: Changes are committed to the current branch

## File Structure

The command creates/updates files in the knowledge base structure:

### Knowledge Base Organization
```
docs/knowledge/
├── {topic}/                         # Topic directory
│   ├── README.md                    # Topic matrix (updated)
│   ├── {block-name}-sop.md         # SOP block in topic root
│   └── {subtopic}/                  # Subtopic directory
│       ├── README.md                # Subtopic matrix (updated)
│       ├── {block-name}-sop.md     # SOP block in subtopic
│       └── {nested-subtopic}/       # Nested subtopic (unlimited depth)
│           ├── README.md            # Nested matrix (updated)
│           └── {block-name}-sop.md # SOP block in nested subtopic
```

### Example Structure
```
docs/knowledge/
├── development/
│   ├── README.md                    # Updated with setup-sop.md reference
│   ├── setup-sop.md                # From development:setup path
│   └── workflows/
│       ├── README.md                # Updated with ci-cd-sop.md reference
│       └── ci-cd-sop.md             # From development/workflows:ci-cd path
├── devops/
│   ├── README.md                    # Updated with deployment subtopic
│   └── deployment/
│       ├── README.md                # Updated with docker-sop.md reference
│       └── docker-sop.md            # From devops/deployment:docker path
└── support/
    ├── README.md                    # Updated with troubleshooting-sop.md
    └── troubleshooting-sop.md       # From support:troubleshooting path
```

## SOP Document Format

Each generated SOP follows this structure:

```markdown
# SOP: {Title extracted from transcript}

## Knowledge Context

This SOP is part of the **{topic}** knowledge domain{, specifically within the **{subtopic}** area}. It provides procedural guidance derived from practical video demonstration and integrates with the broader knowledge base for {topic description}.

## Metadata
- **Knowledge Path**: {topic/subtopic:block}
- **Source**: {YouTube URL}
- **Video ID**: {Video ID}
- **Created**: {Date}
- **Context**: {User statement guidance}

## Overview
{Brief description of what this SOP covers, extracted from transcript, with connections to knowledge domain}

## Prerequisites
- {Required tools/accounts}
- {Required knowledge - linked to knowledge blocks where available}
- {Required access/permissions}

## Step-by-Step Instructions

### Step 1: {Step Title}
**Timestamp**: [{MM:SS}]({YouTube URL}&t={seconds}s)

{Detailed instructions}

**Key Points**:
- {Important detail}
- {Critical setting}

**Warning**: {Any cautions}

### Step 2: {Next Step}
...

## Tools & Resources
| Tool | Purpose | Link | Knowledge Reference |
|------|---------|------|-------------------|
| {Tool} | {What it's used for} | {URL} | {Link to knowledge block if exists} |

## Common Issues & Solutions
| Issue | Solution | Related Knowledge |
|-------|----------|------------------|
| {Problem} | {How to fix} | {Link to troubleshooting knowledge} |

## Best Practices
- {Best practice 1 - linked to knowledge where relevant}
- {Best practice 2 - linked to knowledge where relevant}

## Quick Reference Checklist
- [ ] {Checklist item 1}
- [ ] {Checklist item 2}
- [ ] {Checklist item 3}

## Related Knowledge
- [📁 {Topic} Knowledge](../) - Parent topic knowledge matrix
{if subtopic:}
- [📁 {Subtopic} Knowledge](./) - Current subtopic knowledge matrix
{endif}
- [🔗 Related SOPs]({links to other SOPs in same topic/subtopic})
- [📖 Associated Procedures]({links to related procedural knowledge})

## Integration Notes
{Summary of how this SOP fits within the knowledge architecture and relates to other blocks}
```

## Knowledge Matrix Integration

SOPs are automatically integrated into the knowledge base matrix system:

### Topic Matrix Updates
When an SOP is added to a topic (e.g., `development:setup-sop`), the topic's `README.md` is updated:

```markdown
# Development Knowledge Matrix

## Blocks
- [📄 setup-sop](setup-sop.md) - SOP for development environment setup
- [📄 other-existing-block](other-existing-block.md)

## Integrated Knowledge
### Setup Sop
[Content of the SOP is integrated into the matrix...]
```

### Subtopic Matrix Updates  
When an SOP is added to a subtopic (e.g., `devops/deployment:docker-sop`), the subtopic's `README.md` is updated:

```markdown
# Deployment Knowledge Matrix

## Blocks
- [📄 docker-sop](docker-sop.md) - SOP for Docker deployment procedures
- [📄 kubernetes-guide](kubernetes-guide.md)

## Integrated Knowledge
[SOPs and other blocks are integrated together...]
```

### Cross-Reference Benefits
- **Discoverability**: SOPs appear in knowledge navigation alongside related concepts
- **Context**: SOPs are linked to theoretical knowledge and other procedural content
- **Maintenance**: Knowledge matrices automatically reflect SOP additions and updates

## Script Integration

The command uses helper scripts for optimization:

```bash
# Parse knowledge base path and validate structure
if [[ -f ".claude/scripts/knowledge/convert-youtube-to-sop_path-parser.sh" ]]; then
    PATH_INFO=$(".claude/scripts/knowledge/convert-youtube-to-sop_path-parser.sh" "$KNOWLEDGE_PATH")
elif [[ -f "../scripts/convert-youtube-to-sop_path-parser.sh" ]]; then
    PATH_INFO=$(../scripts/convert-youtube-to-sop_path-parser.sh "$KNOWLEDGE_PATH")
fi

# URL validation and video ID extraction
if [[ -f ".claude/scripts/knowledge/convert-youtube-to-sop_url-processor.sh" ]]; then
    VIDEO_ID=$(".claude/scripts/knowledge/convert-youtube-to-sop_url-processor.sh" "$YOUTUBE_URL")
elif [[ -f "../scripts/convert-youtube-to-sop_url-processor.sh" ]]; then
    VIDEO_ID=$(../scripts/convert-youtube-to-sop_url-processor.sh "$YOUTUBE_URL")
fi

# Create knowledge directory structure
if [[ -f ".claude/scripts/knowledge/convert-youtube-to-sop_knowledge-structure.sh" ]]; then
    ".claude/scripts/knowledge/convert-youtube-to-sop_knowledge-structure.sh" "$PATH_INFO"
elif [[ -f "../scripts/convert-youtube-to-sop_knowledge-structure.sh" ]]; then
    ../scripts/convert-youtube-to-sop_knowledge-structure.sh "$PATH_INFO"
fi

# Transcript processing and SOP generation with knowledge context
if [[ -f ".claude/scripts/knowledge/convert-youtube-to-sop_sop-generator.sh" ]]; then
    ".claude/scripts/knowledge/convert-youtube-to-sop_sop-generator.sh" "$VIDEO_ID" "$TRANSCRIPT" "$YOUTUBE_URL" "$KNOWLEDGE_PATH" "$STATEMENT"
elif [[ -f "../scripts/convert-youtube-to-sop_sop-generator.sh" ]]; then
    ../scripts/convert-youtube-to-sop_sop-generator.sh "$VIDEO_ID" "$TRANSCRIPT" "$YOUTUBE_URL" "$KNOWLEDGE_PATH" "$STATEMENT"
fi

# Update knowledge matrices
if [[ -f ".claude/scripts/knowledge/convert-youtube-to-sop_matrix-updater.sh" ]]; then
    ".claude/scripts/knowledge/convert-youtube-to-sop_matrix-updater.sh" "$PATH_INFO"
elif [[ -f "../scripts/convert-youtube-to-sop_matrix-updater.sh" ]]; then
    ../scripts/convert-youtube-to-sop_matrix-updater.sh "$PATH_INFO"
fi
```

## Common RUN Commands

### Knowledge Base Validation
- RUN `mkdir -p docs/knowledge/{topic}` - Create topic directory if needed
- RUN `mkdir -p docs/knowledge/{topic}/{subtopic}` - Create subtopic directory if needed
- RUN `test -d docs/knowledge/{topic}` - Check if topic exists
- RUN `find docs/knowledge/{topic} -name "README.md"` - List existing matrices

### Path Parsing and Validation
- RUN `echo "{topic/subtopic:block}" | grep -E "^[a-z0-9-]+(/[a-z0-9-]+)*(:([a-z0-9-]+))?$"` - Validate path format
- RUN `[[ "{path}" == *":"* ]] && echo "Block specified" || echo "Topic/subtopic only"` - Check for block specification

### File Operations
- RUN `touch docs/knowledge/{topic}/{subtopic}/{block-name}-sop.md` - Create SOP file
- RUN `cat docs/knowledge/{topic}/{subtopic}/{block-name}-sop.md` - Read generated SOP
- RUN `ls docs/knowledge/{topic}/{subtopic}/` - List blocks in subtopic
- RUN `find docs/knowledge/{topic} -name "*-sop.md"` - List all SOPs in topic

### Knowledge Matrix Operations
- RUN `cat docs/knowledge/{topic}/README.md` - View topic matrix
- RUN `cat docs/knowledge/{topic}/{subtopic}/README.md` - View subtopic matrix
- RUN `grep -l "{block-name}-sop" docs/knowledge/{topic}/*/README.md` - Find matrix references

### Git Operations
- RUN `git add docs/knowledge/` - Stage all knowledge changes
- RUN `git commit -m "docs(knowledge): add SOP from YouTube video {video-id} to {topic/subtopic}"` - Commit

## Requirements

- Git repository for version control
- Write permissions to `docs/knowledge/` directory
- Transcript text (obtained manually or via tools)
- Valid knowledge base structure (topics and subtopics follow naming conventions)

## Error Handling

- **Invalid YouTube URL**: Displays error and expected format (youtube.com/watch?v= or youtu.be/)
- **Invalid knowledge path**: Validates topic/subtopic:block format and provides examples
- **Empty transcript**: Prompts for transcript content
- **Invalid topic/subtopic names**: Ensures kebab-case naming (lowercase, hyphens only)
- **Knowledge structure errors**: Creates missing directories and validates matrix files
- **File write errors**: Provides clear error message with permissions guidance
- **Git errors**: Shows detailed git status and resolution steps
- **Matrix update failures**: Validates README.md format and provides recovery steps

## Notes

- **Knowledge Base Integration**: SOPs are stored as knowledge blocks within the topic/subtopic structure
- **Matrix Updates**: All relevant README.md matrices are automatically updated with SOP references
- **Naming Conventions**: SOP files use `-sop.md` suffix to distinguish from other knowledge blocks
- **Transcript Quality**: Include timestamps for best results and video linking
- **Manual Review**: Review generated SOPs for accuracy before committing
- **Video ID**: Extracted from URL for metadata and timestamp linking
- **Cross-References**: SOPs automatically link to related knowledge within the same topic/subtopic
- **Statement Focus**: User statement should describe SOP content and context, not placement (determined by path)
- **Branch Operation**: Command works within the current branch - no branch switching occurs
- **Knowledge Architecture**: Follows established `docs/knowledge/` structure with topics, subtopics, and blocks

## Integration Benefits

- **Contextual Discovery**: SOPs appear alongside related theoretical and procedural knowledge
- **Unified Navigation**: Knowledge matrices provide single entry point for all topic-related content
- **Cross-Linking**: Automatic linking between SOPs and related knowledge blocks
- **Maintenance**: Knowledge base automatically reflects SOP additions through matrix regeneration
- **Searchability**: SOPs benefit from knowledge base search and organization patterns

## Changelog

### v2.3.1
- **BREAKING CHANGE**: Moved `<topic/subtopic:block>` argument to first position for better UX
- Updated all examples and documentation to reflect new argument order
- Improved argument clarity with FIRST ARGUMENT designation

### v2.3.0
- **MAJOR**: Added knowledge base integration with `<topic/subtopic:block>` argument
- SOPs now stored in `docs/knowledge/` structure instead of `docs/sops/`
- Automatic knowledge matrix updates for topic and subtopic README.md files
- Enhanced SOP format with knowledge context and cross-references
- Path parsing for infinite subtopic nesting support
- Integration with established knowledge architecture patterns

### v2.2.0
- Removed automatic feature branch creation functionality
- Command now operates within the user's current branch
- Simplified workflow by removing git branch operations
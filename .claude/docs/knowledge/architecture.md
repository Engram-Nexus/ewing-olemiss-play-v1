# Knowledge Architecture Best Practices

Comprehensive guidelines for assembling .knowledge files following the hierarchical topic > subtopic > block structure. This document outlines principles for creating navigable, well-organized knowledge bases that scale effectively.

## Overview

The .knowledge architecture follows a three-tier hierarchical structure designed for maximum navigability and content organization. This system supports infinite nesting and provides clear separation between navigation (READMEs) and content (blocks).

## Table of Contents

- [Core Architecture Principles](#core-architecture-principles)
- [Hierarchical Structure](#hierarchical-structure)
- [Navigation System](#navigation-system)
- [Content Organization](#content-organization)
- [Block Management](#block-management)
- [Visual Presentation](#visual-presentation)
- [Organization Review Process](#organization-review-process)
- [Implementation Guidelines](#implementation-guidelines)
- [Common Patterns](#common-patterns)
- [References](#references)

## Core Architecture Principles

### Three-Tier Hierarchy

The knowledge architecture follows a strict **topic > subtopic > block** structure:

| Level | Purpose | Implementation | Navigation Role |
|-------|---------|----------------|-----------------|
| **Topic** | Top-level category | Directory with README.md | Primary navigation hub |
| **Subtopic** | Specialized subcategory | Nested directory with README.md | Secondary navigation |
| **Block** | Individual knowledge unit | Markdown file with content | Content storage |

### Structural Rules

1. **Topics** are top-level directories under `.knowledge/`
2. **Subtopics** are subdirectories within topics (infinite nesting supported)
3. **Blocks** are `.md` files containing actual knowledge content
4. **READMEs** serve as table of contents and navigation hubs

## Hierarchical Structure

### Directory Layout Example

**Note: This is an example structure only. Subtopics and blocks are dynamically assigned for each knowledge topic based on the specific domain and content needs.**

```
.knowledge/
├── authentication/                    # Topic
│   ├── README.md                     # Topic TOC with subtopic links
│   ├── oauth/                        # Subtopic
│   │   ├── README.md                 # Subtopic TOC with block links
│   │   ├── jwt-implementation.md     # Block
│   │   └── token-refresh.md          # Block
│   ├── saml/                         # Subtopic
│   │   ├── README.md                 # Subtopic TOC
│   │   └── sso-setup.md              # Block
│   └── basic-auth.md                 # Topic-level block
└── database/                         # Topic
    ├── README.md                     # Topic TOC
    ├── migrations/                   # Subtopic
    │   ├── README.md                 # Subtopic TOC
    │   ├── schema/                   # Sub-subtopic
    │   │   ├── README.md             # Sub-subtopic TOC
    │   │   └── reversible-changes.md # Block
    │   └── rollback-strategies.md    # Block
    └── performance.md                # Topic-level block
```

### Path Notation

Use forward slashes (`/`) for path separation and colons (`:`) for block specification:

| Pattern | Description | Example |
|---------|-------------|---------|
| `topic` | Topic-level update | `authentication` |
| `topic/subtopic` | Subtopic update | `authentication/oauth` |
| `topic/subtopic:block` | Block update | `authentication/oauth:jwt-implementation` |
| `topic/sub1/sub2:block` | Nested subtopic block | `database/migrations/schema:reversible-changes` |

## Navigation System

### README File Structure

Every topic and subtopic **MUST** have a `README.md` file following this exact structure:

```markdown
# {Topic/Subtopic Name} Knowledge Matrix

This matrix integrates knowledge from all blocks and subtopics in this {path} section.

## Subtopics

- [📁 oauth](oauth/)
- [📁 saml](saml/)

## Blocks

- [📄 basic-auth](basic-auth.md)
- [📄 password-policies](password-policies.md)

## Overview

Authentication systems provide secure access control through multiple implementation approaches. The primary methods include **basic authentication** for simple credential verification, **OAuth 2.0** for delegated authorization, and **SAML** for enterprise federation scenarios.

Key considerations include:
- **Security levels** varying from basic credential checking to enterprise-grade federation
- **Implementation complexity** ranging from simple HTTP headers to complex token flows
- **User experience** factors like single sign-on capabilities and session management

The **oauth** subtopic covers modern delegation patterns, while **saml** addresses enterprise integration requirements. Core authentication patterns are documented in **basic-auth** and **password-policies** blocks.

[View oauth patterns](oauth/) | [View saml federation](saml/)
```

### Hyperlink Requirements

#### Mandatory Sections

1. **Subtopics Section**: Always present, lists subdirectories with 📁 emoji
2. **Blocks Section**: Always present, lists `.md` files with 📄 emoji  
3. **Overview Section**: High-level integrated summary that highlights key subtopics and blocks with **bold** formatting and cross-links

#### Link Format Standards

| Element | Format | Example |
|---------|--------|---------|
| Subtopic links | `[📁 name](name/)` | `[📁 oauth](oauth/)` |
| Block links | `[📄 name](name.md)` | `[📄 jwt-implementation](jwt-implementation.md)` |
| Cross-references | `[text](../other-topic/)` | `[Authentication](../authentication/)` |

## Content Organization

### Block Conversion Principles

#### When to Convert Blocks to Subtopics

Convert a block to a subtopic when:

| Criteria | Threshold | Action |
|----------|-----------|--------|
| **Content Volume** | >500 lines or >10 distinct concepts | Create subtopic directory |
| **Navigation Complexity** | >5 related subtopics needed | Split into multiple blocks |
| **Logical Grouping** | Related concepts cluster naturally | Group under new subtopic |
| **User Experience** | Difficult to scan/navigate | Reorganize with subtopic structure |

#### Conversion Process

1. **Create Subtopic Directory**: `mkdir topic/new-subtopic`
2. **Split Content**: Divide block into logical sections
3. **Create Block Files**: Each section becomes a new block
4. **Generate README**: Use matrix generation for navigation
5. **Update Parent**: Regenerate parent topic's README
6. **Clean Up**: Remove original block file

### Organizational Balance

#### Navigation Hierarchy

Maintain balanced organization:

| Level | Recommended Range | Max Recommended |
|-------|------------------|----------------|
| **Topics per .knowledge** | 5-15 topics | 20 topics |
| **Subtopics per topic** | 3-8 subtopics | 12 subtopics |
| **Blocks per subtopic** | 2-6 blocks | 10 blocks |
| **Nesting depth** | 2-3 levels | 4 levels |

#### Content Distribution

| Element | Ideal Content Size | Organization Trigger |
|---------|-------------------|---------------------|
| **Block** | 50-300 lines | >500 lines → split to subtopic |
| **Subtopic** | 3-6 blocks | >8 blocks → add sub-subtopics |
| **Topic** | 4-10 subtopics | >12 subtopics → review grouping |

## Block Management

### File Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| **Descriptive blocks** | `kebab-case.md` | `jwt-implementation.md` |
| **Process blocks** | `action-noun.md` | `setup-oauth.md` |
| **Reference blocks** | `noun-reference.md` | `api-reference.md` |
| **Concept blocks** | `concept-name.md` | `security-principles.md` |

### Content Structure

Each block should follow this structure:

```markdown
# Block Title

Brief description of the block's purpose.

## Key Concepts

- Concept 1
- Concept 2

## Implementation

Detailed implementation guidance.

## Related Topics

- [Authentication Overview](../README.md)
- [OAuth Flows](oauth-flows.md)
```

## Visual Presentation

### Table Organization

**Always prioritize organizing lists within blocks using tables** for clean presentation:

#### ❌ Poor Organization (Lists)
```markdown
## Authentication Methods

- Basic authentication with username/password
- OAuth 2.0 with authorization code flow  
- SAML federation with identity providers
- API keys for service-to-service communication
- JWT tokens for stateless authentication
```

#### ✅ Optimal Organization (Tables)
```markdown
## Authentication Methods

| Method | Use Case | Security Level | Implementation Complexity |
|--------|----------|----------------|--------------------------|
| Basic Auth | Simple APIs | Low | Low |
| OAuth 2.0 | User delegation | High | Medium |
| SAML | Enterprise SSO | High | High |
| API Keys | Service-to-service | Medium | Low |
| JWT | Stateless auth | Medium | Medium |
```

### Visual Elements

| Element | Symbol | Usage |
|---------|--------|-------|
| **Subtopics** | 📁 | Directory navigation |
| **Blocks** | 📄 | Content files |
| **External links** | 🔗 | Cross-references |
| **Important notes** | ⚠️ | Critical information |
| **Examples** | 💡 | Code samples |

## Organization Review Process

### Persistent Review Principles

Regularly review knowledge organization with fresh perspective:

#### Review Triggers

| Trigger | Frequency | Focus Areas |
|---------|-----------|-------------|
| **New additions** | After each update | Balance and integration |
| **Monthly review** | Every 30 days | Overall navigation flow |
| **Major updates** | >5 blocks added | Structural reorganization |
| **User feedback** | As received | Usability improvements |

#### Review Checklist

- [ ] **Navigation Flow**: Can users find information intuitively?
- [ ] **Balanced Structure**: Are subtopics evenly distributed?
- [ ] **Content Size**: Are blocks appropriately sized?
- [ ] **Link Accuracy**: Do all hyperlinks work correctly?
- [ ] **Table Usage**: Are lists converted to tables where appropriate?
- [ ] **Recent Additions**: Are new content properly integrated?

### Reorganization Process

When reorganization is needed:

1. **Map Current Structure**: Document existing organization
2. **Identify Issues**: Note navigation problems or imbalances
3. **Design New Structure**: Plan improved organization
4. **Create Migration Plan**: Define step-by-step changes
5. **Execute Changes**: Implement new structure
6. **Update Navigation**: Regenerate all README files
7. **Validate Links**: Ensure all references work
8. **Test Navigation**: Verify improved user experience

## Implementation Guidelines

### Using update-knowledge Command

The primary tool for maintaining knowledge architecture:

| Command Pattern | Purpose | Example |
|----------------|---------|---------|
| `/update-knowledge topic` | Update topic matrix | `/update-knowledge authentication` |
| `/update-knowledge topic/subtopic` | Update subtopic matrix | `/update-knowledge authentication/oauth` |
| `/update-knowledge topic/subtopic:block` | Create/update block | `/update-knowledge authentication/oauth:jwt-implementation` |

### Matrix Generation

Matrices are automatically generated with:

1. **Subtopics section**: Lists subdirectories with navigation links
2. **Blocks section**: Lists content files with direct links  
3. **Overview section**: High-level integrated summary highlighting key concepts, subtopics (bolded), and blocks (bolded) with cross-links
4. **Cross-references**: Links to related topics

### Validation Commands

| Command | Purpose |
|---------|---------|
| `tree .knowledge/topic` | View complete structure |
| `find .knowledge/topic -name "README.md"` | List all matrices |
| `find .knowledge/topic -name "*.md" -not -name "README.md"` | List all blocks |

## Common Patterns

### Topic Organization Patterns

#### Domain-Based Topics
```
.knowledge/
├── authentication/
├── database/
├── security/
└── deployment/
```

#### Feature-Based Topics
```
.knowledge/
├── user-management/
├── payment-processing/
├── notification-system/
└── reporting/
```

#### Layer-Based Topics
```
.knowledge/
├── frontend/
├── backend/
├── infrastructure/
└── monitoring/
```

### Subtopic Patterns

#### By Technology
```
authentication/
├── oauth/
├── saml/
├── ldap/
└── mfa/
```

#### By Process
```
deployment/
├── development/
├── staging/
├── production/
└── rollback/
```

#### By Component
```
backend/
├── api/
├── database/
├── services/
└── middleware/
```

## References

- [update-knowledge Command](../../commands/knowledge/update-knowledge.md) - Primary tool for knowledge management
- [Knowledge Matrix Standards](matrix-standards.md) - Detailed matrix formatting guidelines
- [Content Guidelines](content-guidelines.md) - Block writing and organization principles
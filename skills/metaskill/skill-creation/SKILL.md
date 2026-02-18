---
name: Skill Creation
description: Use when creating new skills, writing skill files, generating SKILL.md files, building capabilities, or authoring skill documentation. Provides structured approach to skill creation including frontmatter, content structure, and testing guidelines.
category: core
version: 1.0.0
author: System
tags:
  - skill-creation
  - skill-authoring
  - skill-writing
  - meta
  - capability-building
  - documentation
allowed-tools:
  - read_file
  - write_file
  - list_directory
  - ask_human
---

# Skill Creation

## Overview
This skill guides the creation of new skills. Use when building new capabilities, documenting workflows, or extending the Agent's knowledge base with domain-specific expertise.

## When to Use
- Creating new skill files
- Writing SKILL.md documents
- Building capabilities
- Documenting workflows as skills
- Converting processes into skills
- Extending expertise

## Skill Creation Process

### Phase 1: Define the Skill

**Answer these questions with the user**:

1. **What problem does this solve?**
   - What task or workflow needs support?
   - What pain point does it address?

2. **When would someone use it?**
   - What triggers this skill?
   - What user phrases would match it?

3. **What's the expected outcome?**
   - What should I accomplish?
   - What deliverable results?

**Use `ask_human`** to clarify these if unclear from the request.

### Phase 2: Plan the Structure

**Determine the skill type**:

- **Workflow Skill**: Multi-step process (debugging, analysis)
- **Template Skill**: Standard format (emails, reports)
- **Checklist Skill**: Quality gates (code review, security)
- **Guideline Skill**: Best practices (communication, documentation)

**Identify required sections**:
- ✅ Always: Overview, When to Use, Core Content, Best Practices
- ✅ If relevant: Examples, Tool Integration, Templates
- ✅ Optional: Common Pitfalls, Remember, Troubleshooting

### Phase 3: Write the Frontmatter

**Required fields**:

```yaml
---
name: [Clear 2-5 word title]
description: [CRITICAL - 20-50 words with user phrases and variations]
category: [core|debugging|communication|data-analysis|development|project-management|security|testing]
version: 1.0.0
author: [Author name]
tags:
  - [keyword1]
  - [keyword2]
  - [keyword3-5 more]
---
```

**Description formula**:
```
Use when [user-phrase-1], [user-phrase-2], [user-phrase-3], or [user-phrase-4]. Provides [what-it-offers] for [outcome/benefit].
```

**Critical description tips**:
- Include 4-6 variations of how users might ask
- Use natural language, not overly technical
- Include common synonyms
- Mention specific scenarios
- State what the skill provides

**Only add `allowed-tools`** if restricting tools (read-only, security-constrained):
```yaml
allowed-tools:
  - read_file
  - list_directory
  - ask_human
```

### Phase 4: Write the Content

**Structure template**:

```markdown
# [Skill Title]

## Overview
[2-3 sentences: what it does, when to use, key benefit]

## When to Use
- [Specific scenario 1]
- [Specific scenario 2]
- [Specific scenario 3]
- [User phrase variant 1]
- [User phrase variant 2]
- [5-10 total triggers]

## [Core Content Section]

### [Subsection 1]
[Instructions, workflows, or templates]

1. **[Step name]**
   - Specific action
   - Details
   - Examples

2. **[Next step]**
   - Actions
   - Details

### [Subsection 2]
[Continue pattern]

## Best Practices

### DO:
- ✅ [Positive practice 1]
- ✅ [Positive practice 2]
- ✅ [Positive practice 3]

### DON'T:
- ❌ [Anti-pattern 1]
- ❌ [Anti-pattern 2]
- ❌ [Anti-pattern 3]

## Integration with Tools

When [doing task], use appropriate tools:
- `tool_name` - [When and how to use]
- `tool_name` - [When and how to use]

## Examples

### Example 1: [Scenario]
**Situation:** [Context]

**Approach:**
1. [Step taken]
2. [Next step]

**Outcome:** [Result]

## Remember

Key principles:
1. [Main takeaway 1]
2. [Main takeaway 2]
3. [Main takeaway 3]
```

### Phase 5: Create the File

**Directory structure**:
```
skills/[category]/[skill-name]/SKILL.md
```

**Steps**:

1. **Determine location**:
   - Project-specific: `skills/`
   - User-wide: `~/otto/skills/`

2. **Create directory**:
   ```bash
   mkdir -p skills/[category]/[skill-name]
   ```

3. **Write file** using `write_file`:
   - Path: `skills/[category]/[skill-name]/SKILL.md`
   - Content: Complete skill markdown

4. **Verify** using `read_file` to confirm creation

## Content Writing Guidelines

### Be Specific and Actionable

❌ **Vague**: "Check the code"
✅ **Specific**: "Use `read_file` to check src/api/auth.py for authentication logic"

### Use Clear Formatting

- **Headers** (##, ###) for sections
- **Numbered lists** for sequential steps
- **Bullet lists** for non-sequential items
- **Bold** for important terms
- **Code blocks** (```) for examples
- **Backticks** (`) for tool names

### Include Concrete Examples

Every skill should have at least one real-world example showing:
- Situation/context
- Approach taken
- Outcome achieved

### Reference Tools Explicitly

When mentioning tools, use backticks:
- `read_file` - Read file contents
- `write_file` - Create/update files
- `list_directory` - List files
- `ask_human` - Get human input
- `send_email` - Send emails
- `convert_markdown_to_docx` - Create Word docs
- `convert_markdown_to_pptx` - Create presentations

## Best Practices

### DO:
- ✅ Write descriptions with 20-50 words including user phrases
- ✅ Include "When to Use" section with 5+ triggers
- ✅ Structure content with clear headers and lists
- ✅ Provide concrete examples
- ✅ Reference tools explicitly with backticks
- ✅ Keep skills focused (one capability = one skill)
- ✅ Use semantic versioning (1.0.0)

### DON'T:
- ❌ Write vague descriptions ("for debugging")
- ❌ Create walls of text without structure
- ❌ Skip the "When to Use" section
- ❌ Give abstract advice without examples
- ❌ Make skills too broad (split instead)
- ❌ Exceed 500 lines (causes attention issues)
- ❌ Use `allowed-tools` without good reason

## Integration with Tools

When creating skills:
- `ask_human` - Clarify skill purpose, triggers, and requirements
- `list_directory` - Check existing skills structure
- `read_file` - Review similar skills as examples
- `write_file` - Create the SKILL.md file

## Skill Creation Checklist

Before considering the skill complete:

- [ ] Frontmatter has all required fields
- [ ] Description is 20-50 words with user phrases
- [ ] "When to Use" has 5+ specific triggers
- [ ] Content is structured with headers and lists
- [ ] Best Practices section included (DO/DON'T)
- [ ] Tool integration guidance provided
- [ ] At least one concrete example included
- [ ] File saved to correct path: `skills/[category]/[skill-name]/SKILL.md`
- [ ] Version set to 1.0.0 for new skills

## Common Categories

Choose the most appropriate:
- `core` - Essential for all tasks
- `debugging` - Troubleshooting and analysis
- `communication` - Writing and messaging
- `data-analysis` - Working with data
- `development` - Software development
- `project-management` - Coordination
- `security` - Security and compliance
- `testing` - Quality assurance

## Remember

Effective skills:
1. **Match semantically** - Description contains user phrases
2. **Guide clearly** - Instructions are specific and actionable
3. **Show examples** - Concrete demonstrations included
4. **Reference tools** - Explicit tool usage guidance
5. **Stay focused** - One capability per skill

The description field is THE MOST CRITICAL part - it determines if the agent will find and use the skill.

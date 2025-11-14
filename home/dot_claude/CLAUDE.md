# CLAUDE.md

## Ask Before Action

Before making code changes or executing a Plan, if there are any ambiguous parts or interpretations in the user's instructions, please confirm with me using `AskUserQuestion`. Always use `AskUserQuestion` when asking the user questions.
Also, before asking the user questions, carefully read and understand the user's instructions before asking.

## Top Priority Rule - Thinking and Action Guidelines

Think in English, communicate with users in Japanese.

## Basic Rules

### Communication

- Language: Respond primarily in Japanese
- Handling unknowns:
  - Answer "I don't know" for things you don't understand
- Citations: Always specify sources when available
- Be an objective dialogue partner: Don't blindly accept the user's opinions. Engage from an objective perspective as a dialogue partner.

### Task Management

- Task division: Divide given instructions into tasks for execution
- Decision making: Present options when the implementation approach is unclear
- Escalation: If the problem cannot be resolved after multiple attempts, always consult the user
- Utilize TODO tools: Make use of TODO tools for task tracking

### Development Tools

When retrieving information about libraries, use `context7 mcp` or `deepwiki mcp`.

- context7: context7 provides up-to-date information about libraries
- deepwiki: deepwiki provides detailed information about libraries

## Development Environment Settings

- Delete unnecessary comments. Use comments to clarify "why" when needed. Do not comment on what is obvious from the code
- Follow DRY, YAGNI principles
- Do not skip test implementation by default, implement tests that mimic expected user behavior

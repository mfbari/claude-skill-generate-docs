<!--
Template for the AGENTS.md written to the project root (Phase 4, Step 4b). Tool-agnostic: plain
relative paths, no Claude-specific `@` imports. Replace {placeholders}. Keep under 120 lines.
-->

# {Project Name}

{One-line description}

## Project Structure
{Same directory map as the CLAUDE.md auto-generated section}

## Commands
{Same commands as the CLAUDE.md section}

## Architecture
{2-3 sentence summary from architecture.md}
Full details: docs/architecture.md

## Key Documentation

| Area | File | Read when... |
|------|------|--------------|
| Architecture | docs/architecture.md | Modifying system structure or adding services |
| API Reference | docs/api-reference.md | Adding or modifying endpoints |
| Database | docs/database-schema.md | Working with models, migrations, schemas |
| Services | docs/services.md | Changing inter-service communication |
| Frontend-Backend | docs/frontend-backend.md | Changing data fetching or auth flow |
| Workflows | docs/workflows-and-triggers.md | Adding jobs, cron, events, webhooks |
| Security | docs/security.md | Modifying auth, permissions, validation |
| Glossary | docs/glossary.md | Encountering domain terms, naming entities |
| Errors | docs/error-catalog.md | Adding error handling or custom errors |
| Conventions | docs/coding-conventions.md | Unsure about patterns or naming |
| Testing | docs/testing-strategy.md | Writing or modifying tests |
| Environment | docs/environment-setup.md | Setting up local dev or troubleshooting |
| DevOps | docs/devops.md | Modifying CI/CD or deployment |
| Tech Stack | docs/tech-stack.md | Evaluating or checking dependencies |

## Conventions
{Top 5 most critical rules extracted from coding-conventions.md}

## Terminology
{Top 10 most important domain terms extracted from glossary.md}

## Constraints
- Verify endpoints and models against docs before creating new ones
- Follow patterns documented in docs/coding-conventions.md
- Use terminology from docs/glossary.md

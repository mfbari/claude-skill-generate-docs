<!--
Template for the auto-generated section appended to a project's CLAUDE.md (Phase 4, Step 4a).
Replace {placeholders}. Keep the whole section under 80 lines. Replace ONLY the region between the
BEGIN/END markers on regeneration; never touch human-written content above it.
-->

<!-- BEGIN AUTO-GENERATED DOCS SECTION — regenerate with generate-docs -->

## Project Structure
{top-level directory → purpose mapping, max 8 lines, e.g.:}
src/api/        → API route handlers and middleware
src/models/     → Database models and schemas
src/services/   → Business logic layer
src/workers/    → Background job processors
src/utils/      → Shared utilities
tests/          → Test suites (unit, integration, e2e)
docs/           → Project documentation (auto-generated)

## Key Commands
{build, test, dev, lint — extracted from package.json / Makefile / etc., max 6 lines}

## Reference Documentation
Read the relevant doc BEFORE making changes in that area.

### Architecture — @docs/architecture.md
**Read when:** Modifying system structure, adding services, changing component boundaries

### API Reference — @docs/api-reference.md
**Read when:** Adding or modifying API endpoints, changing request/response shapes

### Database Schema — @docs/database-schema.md
**Read when:** Adding models, writing migrations, modifying relationships

### Services — @docs/services.md
**Read when:** Adding inter-service calls, modifying service responsibilities

### Frontend-Backend — @docs/frontend-backend.md
**Read when:** Changing data fetching, auth flow, real-time features, API clients

### Workflows & Triggers — @docs/workflows-and-triggers.md
**Read when:** Adding background jobs, cron tasks, event handlers, webhooks

### Security — @docs/security.md
**Read when:** Modifying auth, permissions, validation, CORS, rate limits

### Glossary — @docs/glossary.md
**Read when:** Encountering unfamiliar terms, naming new entities or concepts

### Error Catalog — @docs/error-catalog.md
**Read when:** Adding error handling, creating custom errors, modifying error responses

### Coding Conventions — @docs/coding-conventions.md
**Read when:** Unsure about patterns, naming, file organization, or design patterns

### Testing — @docs/testing-strategy.md
**Read when:** Writing tests, adding test utilities, changing coverage requirements

### Environment Setup — @docs/environment-setup.md
**Read when:** Setting up local dev, configuring secrets, troubleshooting builds

### DevOps — @docs/devops.md
**Read when:** Modifying CI/CD, deployment, infrastructure, monitoring

### Tech Stack — @docs/tech-stack.md
**Read when:** Evaluating dependencies, checking versions, understanding tool choices

## Constraints
- Verify API endpoints and models against docs before creating new ones
- Follow patterns in @docs/coding-conventions.md
- Use terminology from @docs/glossary.md — do not invent synonyms

<!-- END AUTO-GENERATED DOCS SECTION -->

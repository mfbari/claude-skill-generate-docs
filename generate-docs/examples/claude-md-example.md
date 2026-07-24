# Example: CLAUDE.md Auto-Generated Section

This shows what generate-docs appends to your CLAUDE.md. Everything above the
`BEGIN` marker is your existing human-written content — generate-docs never touches it.

---

```markdown
# MyApp                                           ← your content (preserved)

SaaS platform for document automation.             ← your content (preserved)
TypeScript monorepo: Express backend + React       ← your content (preserved)
frontend + Postgres + Redis.                       ← your content (preserved)

## Commands                                        ← your content (preserved)
npm run dev       # Start dev server               ← your content (preserved)
npm run test      # Run all tests                  ← your content (preserved)
npm run build     # Production build               ← your content (preserved)

<!-- BEGIN AUTO-GENERATED DOCS SECTION — regenerate with /generate-docs -->

## Project Structure
src/api/        → API route handlers and middleware
src/models/     → Database models (Prisma)
src/services/   → Business logic layer
src/workers/    → Background job processors (Bull)
src/utils/      → Shared utilities
client/         → React frontend (Vite)
tests/          → Test suites (Jest + Supertest)
docs/           → Project documentation (auto-generated)

## Key Commands
npm run dev           # Dev server with hot reload
npm run test          # Jest test suite
npm run test:e2e      # End-to-end tests
npm run db:migrate    # Run Prisma migrations
npm run lint          # ESLint + Prettier check

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
```

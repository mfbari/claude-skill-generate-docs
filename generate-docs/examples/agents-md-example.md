# Example: AGENTS.md Output

This shows the `AGENTS.md` file that generate-docs creates at the project root for
cross-tool compatibility with Cursor, Copilot, Windsurf, Codex, and others.

---

```markdown
# MyApp

SaaS platform for document automation. TypeScript monorepo.

## Project Structure
src/api/        → API route handlers and middleware
src/models/     → Database models (Prisma)
src/services/   → Business logic layer
src/workers/    → Background job processors (Bull)
src/utils/      → Shared utilities
client/         → React frontend (Vite)
tests/          → Test suites (Jest + Supertest)
docs/           → Project documentation

## Commands
npm run dev           # Dev server with hot reload
npm run test          # Jest test suite
npm run test:e2e      # End-to-end tests
npm run db:migrate    # Run Prisma migrations
npm run lint          # ESLint + Prettier check

## Architecture
Express REST API serving a React SPA. PostgreSQL via Prisma ORM, Redis for
caching and Bull job queues. JWT auth with refresh tokens. Deployed via Docker
on AWS ECS with GitHub Actions CI/CD.
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
- All API responses use `{ success: boolean, data?: T, error?: { code, message } }`
- Use Zod schemas for request validation on every endpoint
- Service layer handles business logic; controllers handle HTTP concerns only
- Use barrel exports (index.ts) for each module directory
- Branch naming: `feat/JIRA-123-description` or `fix/JIRA-456-description`

## Terminology
- **Workspace**: Tenant-level organizational unit (not IDE workspace)
- **Pipeline**: Data processing chain for document ingestion (not CI/CD)
- **Template**: User-defined document layout with variable placeholders
- **Render**: Process of filling a template with data to produce output
- **Artifact**: Generated output file (PDF, DOCX) from a render operation
- **Webhook**: Outbound HTTP notification on pipeline completion
- **Quota**: Per-workspace limit on renders per billing period
- **Token**: JWT access token (short-lived) or refresh token (long-lived)

## Constraints
- Verify endpoints and models against docs before creating new ones
- Follow patterns documented in docs/coding-conventions.md
- Use terminology from docs/glossary.md
```

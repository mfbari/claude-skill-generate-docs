---
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, Task, Skill
argument-hint: "[max-retries] (default: 3)"
description: >
  Generate comprehensive project documentation with multi-agent explore → generate → verify loop.
  Creates/updates CLAUDE.md and AGENTS.md with progressive disclosure references.
  Uses parallel subagents to explore the codebase, generate docs in /docs, and verify quality
  with RALPH-style A-F grading. Iterates until all docs score A or max retries reached.
  Output is SpecKit-compatible. Usage: /generate-docs [max-retries]
---

# Documentation Generator — Orchestrator

You are the **orchestrator agent** for a comprehensive documentation generation pipeline.
Your job is to coordinate five phases — **Bootstrap**, **Explore**, **Generate**, **Verify**,
**Context Update** — in an iterative loop until all documentation meets quality grade **A**
or the maximum number of retries is exhausted.

---

## Configuration

- **Max retries**: `$ARGUMENTS` (if blank or non-numeric, default to `3`)
- **Output directory**: `docs/` at the project root
- **Passing grade**: **A** on every document and every rubric dimension
- **Completion signal**: When ALL documents score A across ALL dimensions, or max retries reached

Parse the first argument as max retries. If `$ARGUMENTS` is empty, use 3.
If it is a number, use that number. Ignore anything else and default to 3.

---

## Phase 0 — BOOTSTRAP (CLAUDE.md Detection)

Before anything else, check for an existing CLAUDE.md:

1. **Check if `CLAUDE.md` exists** at the project root.
2. **If it exists**: Read it. Save a backup to `docs/_claude_md_backup.md`.
   Note its current contents — you will APPEND to it, not overwrite.
3. **If it does NOT exist**: Run the `/init` command to bootstrap a CLAUDE.md.
   Wait for `/init` to complete before proceeding. If `/init` is not available,
   create a minimal CLAUDE.md with the project name and a placeholder structure:
   ```markdown
   # {Project Name}

   {One-line description — inferred from README, package.json, or repo name}

   ## Commands
   <!-- Auto-populated by /generate-docs -->

   ## Project Structure
   <!-- Auto-populated by /generate-docs -->
   ```
4. **Check if `AGENTS.md` exists** at the project root. Note its presence for Phase 4.

---

## Phase 1 — EXPLORE (Parallel Subagents)

Dispatch **8 parallel Explore subagents** to scan the codebase. Each focuses on one domain.
Use the `doc-explorer` agent for all of these. Run them **in parallel** (`run_in_background: true`).

### Subagent 1: Project Overview & Tech Stack
```
Scan the entire repo. Identify:
- Programming languages and their relative usage
- Frameworks and libraries (check package.json, requirements.txt, go.mod, Cargo.toml, Gemfile, pom.xml, build.gradle, etc.)
- Build tools, bundlers, test frameworks, linters, formatters
- Monorepo vs single-repo structure
- Environment/config management (.env, config files, docker-compose, k8s manifests)
- CI/CD pipeline files (.github/workflows, Jenkinsfile, .gitlab-ci.yml, etc.)
- README, CONTRIBUTING, LICENSE presence
- Existing CLAUDE.md, AGENTS.md, .cursorrules, .windsurfrules presence
- Existing docs/ or specs/ directories and their contents

Output a structured summary as markdown.
```

### Subagent 2: Architecture & Service Boundaries
```
Identify the high-level architecture:
- Is this a monolith, microservices, serverless, or hybrid?
- List every distinct service/module/package with its purpose
- Identify entry points (main files, index files, server bootstrap)
- Map directory structure to architectural components
- Identify shared libraries or common packages
- Note any service mesh, API gateway, or message queue configurations
- Identify architecture decision records (ADRs) if any exist

Output a structured summary as markdown with a Mermaid diagram suggestion for the service map.
```

### Subagent 3: API Surface
```
Find ALL API endpoints, routes, and handlers:
- REST endpoints (Express routes, FastAPI paths, Spring controllers, Rails routes, etc.)
- GraphQL schemas and resolvers
- gRPC proto files and service definitions
- WebSocket handlers
- CLI command definitions
- For each: HTTP method, path, handler location, auth requirements if visible
- Look for OpenAPI/Swagger specs, Postman collections
- Document request/response shapes where type definitions exist
- Note rate limiting, pagination, and versioning patterns

Output a structured inventory as markdown.
```

### Subagent 4: Database & Data Layer
```
Find ALL database-related code:
- ORM models, schemas, entities (Prisma, SQLAlchemy, TypeORM, ActiveRecord, etc.)
- Migration files and their chronology
- Database configuration and connection setup
- Seed files and fixtures
- Stored procedures, views, triggers if referenced
- Cache layer (Redis, Memcached configs)
- Message queues (RabbitMQ, Kafka, SQS configs)
- For each model/table: fields, types, relationships, indexes if visible

Output a structured inventory as markdown with a Mermaid ER diagram suggestion.
```

### Subagent 5: Frontend–Backend Communication
```
Map how the frontend communicates with the backend:
- API client setup (axios, fetch wrappers, tRPC, GraphQL clients)
- State management that interfaces with APIs (Redux thunks, React Query, SWR, Vuex actions)
- Authentication flow (token storage, refresh logic, OAuth redirects)
- Real-time communication (WebSocket, SSE, polling patterns)
- File upload/download mechanisms
- Error handling and retry patterns on the client side
- Shared types or contracts between frontend and backend

Output a structured summary as markdown.
```

### Subagent 6: Workflows, Triggers & DevOps
```
Identify operational and workflow patterns:
- Background job processors (Sidekiq, Celery, Bull, etc.)
- Scheduled tasks / cron jobs
- Event-driven triggers (webhooks, pub/sub, event emitters)
- Deployment configuration (Docker, Kubernetes, Terraform, serverless.yml)
- Monitoring and logging setup (Datadog, Sentry, CloudWatch, etc.)
- Feature flags, A/B testing infrastructure
- Environment management (staging, production, dev)
- Infrastructure as code files

Output a structured summary as markdown.
```

### Subagent 7: Domain Terminology & Error Handling
```
Extract domain-specific knowledge:
- Business domain terms used in code (variable names, class names, comments that reveal domain concepts)
- Abbreviations and acronyms used in the codebase (what does each stand for?)
- Domain entities and their relationships (not just DB models — business concepts)
- Custom error types, error codes, and error handling patterns
- Error response formats and structures
- Custom exception classes and where they are thrown
- Logging patterns and log levels used
- Domain-specific enums and constants with business meaning

Output TWO structured sections:
1. A glossary of domain terms with definitions inferred from code context
2. An error catalog with error types, codes, where thrown, and handling patterns
```

### Subagent 8: Testing, Security & Conventions
```
Identify testing, security, and code convention patterns:

TESTING:
- Test framework(s) in use (Jest, pytest, RSpec, JUnit, etc.)
- Test directory structure and naming conventions
- Test types present (unit, integration, e2e, snapshot, contract)
- Test utilities, factories, fixtures, mocks
- Coverage configuration and thresholds
- How to run tests (commands, flags, env requirements)

SECURITY:
- Authentication mechanism (JWT, sessions, OAuth, API keys)
- Authorization model (RBAC, ABAC, middleware guards)
- Input validation patterns and libraries
- CORS configuration
- Rate limiting implementation
- Secret management (.env, vault, AWS secrets)
- Security-related middleware chain

CONVENTIONS:
- Code style patterns (functional vs OOP, naming conventions observed)
- Common design patterns used (repository, service layer, factory, etc.)
- Import/export conventions
- File and directory naming patterns
- Comment/documentation patterns in code (JSDoc, docstrings, etc.)

Output a structured summary covering all three areas.
```

**After all 8 complete**, collect and merge their outputs into a single exploration report.
Save it to `docs/_exploration_report.md` (prefixed with underscore = internal working file).

---

## Phase 2 — GENERATE (Parallel Subagents)

Using the exploration report, dispatch **parallel `doc-generator` subagents** to create the
actual documentation files. Each subagent writes ONE document.

Generate these files in `docs/`:

| File | Content | Diagrams |
|---|---|---|
| `docs/README.md` | Project overview, quick-start, how to run/build/test, tech stack summary, links to all other docs | Optional |
| `docs/architecture.md` | System architecture: service map, component diagram, deployment view, key design decisions | Required |
| `docs/tech-stack.md` | Complete tech stack inventory: languages, frameworks, libraries, tools, versions, purpose | Optional |
| `docs/api-reference.md` | Full API reference: every endpoint, method, path, params, auth, request/response shapes | Required |
| `docs/database-schema.md` | Database schema: tables, fields, types, relationships, indexes, migrations timeline | Required |
| `docs/frontend-backend.md` | Frontend-backend communication: data fetching, auth flow, real-time, shared contracts | Required |
| `docs/services.md` | Service/module inventory: purpose, responsibilities, inter-service dependencies | Required |
| `docs/workflows-and-triggers.md` | Background jobs, cron, event triggers, webhooks, async patterns, queue topology | Required |
| `docs/devops.md` | CI/CD pipelines, deployment process, infrastructure, monitoring, environments | Required |
| `docs/glossary.md` | Domain terms, abbreviations, acronyms, business entities with plain-English definitions | N/A |
| `docs/error-catalog.md` | Error types, codes, HTTP status mappings, where thrown, handling, remediation | Optional |
| `docs/testing-strategy.md` | Test setup, frameworks, patterns, directory structure, commands, coverage, test data | Optional |
| `docs/environment-setup.md` | Local dev setup: prerequisites, install steps, env vars, secrets, gotchas, troubleshooting | Optional |
| `docs/coding-conventions.md` | Code patterns, naming rules, design patterns used, anti-patterns, file organization | Optional |
| `docs/security.md` | Auth model, authorization, validation, secret management, CORS, rate limiting, middleware | Required |

**Instructions for each generator subagent:**

- Write thorough, professional documentation following best practices
- Include **Mermaid diagrams** wherever marked Required; include elsewhere when they add clarity
- Use clear headings, tables, and code examples where appropriate
- Cross-reference other docs in the set (e.g., "See [API Reference](api-reference.md)")
- Do NOT fabricate information — only document what the exploration report found
- If something is ambiguous or unclear from the codebase, note it as "⚠️ Needs clarification"
- Target audience: a new developer joining the project AND AI coding agents that need context
- **Agent-friendly structure**: Use explicit headings, structured tables, and concise summaries
  so that tools like SpecKit, Cursor, Copilot, and Claude Code can extract context efficiently.
  Prefer tables over prose for inventories. Lead each section with a 1-2 sentence summary.

---

## Phase 3 — VERIFY (Verification Subagent)

Dispatch a **`doc-verifier` subagent** to grade every generated document.

The verifier must:
1. Read each doc file in `docs/` (excluding files prefixed with `_`)
2. Cross-reference against the actual codebase (not just the exploration report)
3. Grade each document on these **5 dimensions** using **A–F letter grades**:

| Dimension | What it measures |
|---|---|
| **Completeness** | Does it cover all relevant aspects found in the codebase? |
| **Accuracy** | Is the information factually correct when verified against code? |
| **Clarity** | Is it well-written, well-structured, easy to follow? |
| **Diagrams** | Are Mermaid diagrams present where required, syntactically correct, and useful? |
| **Coverage** | Does it cross-reference related docs and link concepts together? |

4. Produce a **verification report** saved to `docs/_verification_report.md` with:
   - A grade table (document × dimension)
   - An **overall grade** per document (lowest dimension grade = overall)
   - For any grade below A: specific, actionable feedback on what to fix
   - A final **PASS** or **FAIL** verdict

**Diagram grading exception**: For docs where Diagrams column says "Optional" or "N/A",
grade Diagrams as A if diagrams aren't necessary for that doc type, or grade on quality
if diagrams were included voluntarily.

**PASS** = every document scores A on every dimension.
**FAIL** = any document has any dimension below A.

---

## Phase 4 — CONTEXT UPDATE (CLAUDE.md + AGENTS.md)

**Run this phase ONLY after Phase 3 returns PASS or on the final iteration.**

This phase updates the project's AI agent context files using progressive disclosure.

### Step 4a: Update CLAUDE.md

Read the current CLAUDE.md. **Do not overwrite existing human-written content.**
Append or update a clearly marked auto-generated section.

The auto-generated section must:
- Stay **under 80 lines** (leaving room for human content, keeping total under ~200)
- Use **progressive disclosure** with "Read when" triggers
- Reference docs using `@docs/filename.md` syntax for Claude Code's import system
- Never duplicate content from the docs — just point to them

Use this exact format for the auto-generated section:

```markdown

<!-- BEGIN AUTO-GENERATED DOCS SECTION — regenerate with /generate-docs -->

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
```

**Rules for CLAUDE.md update:**
- If `BEGIN AUTO-GENERATED DOCS SECTION` marker exists, replace ONLY that section
- If no marker exists, append the section at the end of the file
- NEVER delete or modify content above the marker — that's human-curated
- Keep the auto-generated section under 80 lines

### Step 4b: Generate/Update AGENTS.md

Create or update `AGENTS.md` at the project root for cross-tool compatibility
(Cursor, Windsurf, Copilot, Codex, Roo Code all read this file).

AGENTS.md should be a **condensed, tool-agnostic version** — same progressive disclosure
pattern but without Claude-specific `@` import syntax. Use plain paths instead.

Keep AGENTS.md under **120 lines**. Structure:

```markdown
# {Project Name}

{One-line description}

## Project Structure
{Same directory map as CLAUDE.md section}

## Commands
{Same commands as CLAUDE.md section}

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
```

---

## Iteration Loop

```
Phase 0: Bootstrap (run once)

iteration = 0
max_retries = parsed from $ARGUMENTS or 3

WHILE iteration < max_retries:
    iteration += 1

    IF iteration == 1:
        Run Phase 1 (Explore)
        Run Phase 2 (Generate ALL docs)
    ELSE:
        Run Phase 2 ONLY for documents that scored below A
        (Re-generate only the failing docs, using the verification feedback)

    Run Phase 3 (Verify)

    IF verdict == PASS:
        Run Phase 4 (Context Update)
        BREAK → success

    IF iteration == max_retries:
        Run Phase 4 (Context Update — even on partial pass)
        BREAK → partial success, report which docs still need work

Print summary
```

---

## Final Output

When the loop completes, print a **summary table** to the console:

```
╔══════════════════════════════════════════════════════════════════════╗
║                   📚 Documentation Generation Report                ║
╠══════════════════════════════════════════════════════════════════════╣
║  Iteration:  {n} / {max_retries}                                    ║
║  Verdict:    {PASS ✅ | FAIL ❌}                                    ║
║  CLAUDE.md:  {Created ✨ | Updated 🔄 | Unchanged ─}               ║
║  AGENTS.md:  {Created ✨ | Updated 🔄 | Unchanged ─}               ║
╠═══════════════════════════╦═════╦═════╦═════╦═════╦═════╦══════════╣
║  Document                 ║ CMP ║ ACC ║ CLR ║ DIA ║ COV ║ Overall  ║
╠═══════════════════════════╬═════╬═════╬═════╬═════╬═════╬══════════╣
║  README.md                ║     ║     ║     ║     ║     ║          ║
║  architecture.md          ║     ║     ║     ║     ║     ║          ║
║  tech-stack.md            ║     ║     ║     ║     ║     ║          ║
║  api-reference.md         ║     ║     ║     ║     ║     ║          ║
║  database-schema.md       ║     ║     ║     ║     ║     ║          ║
║  frontend-backend.md      ║     ║     ║     ║     ║     ║          ║
║  services.md              ║     ║     ║     ║     ║     ║          ║
║  workflows-and-triggers.md║     ║     ║     ║     ║     ║          ║
║  devops.md                ║     ║     ║     ║     ║     ║          ║
║  glossary.md              ║     ║     ║     ║     ║     ║          ║
║  error-catalog.md         ║     ║     ║     ║     ║     ║          ║
║  testing-strategy.md      ║     ║     ║     ║     ║     ║          ║
║  environment-setup.md     ║     ║     ║     ║     ║     ║          ║
║  coding-conventions.md    ║     ║     ║     ║     ║     ║          ║
║  security.md              ║     ║     ║     ║     ║     ║          ║
╚═══════════════════════════╩═════╩═════╩═════╩═════╩═════╩══════════╝

Docs generated:  docs/ (15 files)
Context updated: CLAUDE.md, AGENTS.md
SpecKit-ready:   docs/ structure compatible with /speckit.analyze
```

If FAIL, also list the specific failing dimensions and the verifier's feedback for each.

---

## Critical Rules

1. **Never invent information.** Only document what actually exists in the codebase.
2. **Always use Mermaid diagrams** where the Diagrams column says "Required".
3. **Verify against code, not just the exploration report.** The verifier reads actual source files.
4. **Only re-generate failing docs** on subsequent iterations, not all docs.
5. **Preserve passing docs** across iterations — do not overwrite docs that already scored A.
6. **The exploration report is a working file** — don't delete it.
7. **Be honest about gaps.** Flag uncertainties rather than guessing.
8. **CLAUDE.md must stay under 200 lines total.** Auto-generated section under 80 lines.
   Use progressive disclosure — point to docs, don't duplicate their content.
9. **Never delete human-written CLAUDE.md content.** Only manage the auto-generated section.
10. **AGENTS.md is tool-agnostic.** No Claude-specific syntax. Keep under 120 lines.
11. **Structure for AI agents.** Use explicit headings, tables, and "Read when" triggers
    so SpecKit, Cursor, Copilot, and other tools can extract context efficiently.

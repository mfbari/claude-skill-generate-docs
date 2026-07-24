# Phase 2 — Generation

Turn the exploration report (`docs/_exploration_report.md`) into polished documentation. Each
document serves **two audiences at once**: human developers and AI coding agents. This file is both
the operating manual for the generate phase and the prompt to hand to a per-doc subagent.

## Run modes

- **With parallel subagents**: dispatch **one writer subagent per document** (up to 15), in
  parallel. Give each subagent this file plus the single row it must write. Each writes exactly one
  file to `docs/`.
- **Without subagents**: write the documents yourself, one at a time, following the same guidance.

On **retry iterations, only regenerate documents that scored below A** — preserve passing docs
untouched. See the "Revision mode" section.

## The 15 documents

| File | Content | Diagrams |
|---|---|---|
| `docs/README.md` | Project overview, quick-start, how to run/build/test, tech-stack summary, links to all other docs | Optional |
| `docs/architecture.md` | System architecture: service map, component diagram, deployment view, key design decisions | Required |
| `docs/tech-stack.md` | Complete tech-stack inventory: languages, frameworks, libraries, tools, versions, purpose | Optional |
| `docs/api-reference.md` | Full API reference: every endpoint, method, path, params, auth, request/response shapes | Required |
| `docs/database-schema.md` | Database schema: tables, fields, types, relationships, indexes, migrations timeline | Required |
| `docs/frontend-backend.md` | Frontend–backend communication: data fetching, auth flow, real-time, shared contracts | Required |
| `docs/services.md` | Service/module inventory: purpose, responsibilities, inter-service dependencies | Required |
| `docs/workflows-and-triggers.md` | Background jobs, cron, event triggers, webhooks, async patterns, queue topology | Required |
| `docs/devops.md` | CI/CD pipelines, deployment process, infrastructure, monitoring, environments | Required |
| `docs/glossary.md` | Domain terms, abbreviations, acronyms, business entities with plain-English definitions | N/A |
| `docs/error-catalog.md` | Error types, codes, HTTP status mappings, where thrown, handling, remediation | Optional |
| `docs/testing-strategy.md` | Test setup, frameworks, patterns, directory structure, commands, coverage, test data | Optional |
| `docs/environment-setup.md` | Local dev setup: prerequisites, install steps, env vars, secrets, gotchas, troubleshooting | Optional |
| `docs/coding-conventions.md` | Code patterns, naming rules, design patterns used, anti-patterns, file organization | Optional |
| `docs/security.md` | Auth model, authorization, validation, secret management, CORS, rate limiting, middleware | Required |

"Required" diagrams MUST be present and valid (see `grading-rubric.md` for how diagrams are graded).

## Core principles

1. **Write for a new developer** joining tomorrow: assume they know the tech stack but nothing about
   this specific project.
2. **Structure for AI agents.** These docs are loaded as context by Claude Code, Cursor, Copilot,
   SpecKit, and others. Use structured tables, explicit headings, and concise summaries. Lead every
   section with a 1–2 sentence summary.
3. **Include Mermaid diagrams** wherever they add clarity or are marked Required.
4. **Never fabricate.** Document only what the exploration data and codebase actually show. Mark
   genuinely unclear items with `⚠️ Needs clarification` rather than guessing.
5. **Cross-reference** other docs with relative links like `[API Reference](api-reference.md)`.
6. **Be thorough but scannable.** Prefer tables over prose for inventories; short paragraphs; code
   blocks for examples.

## Structure every doc should have

- **Title** — clear, descriptive h1.
- **"Read this doc when" trigger** near the top, e.g.
  `> **Read this doc when:** Adding API endpoints, modifying routes, or changing auth.`
- **Overview** — 2–4 sentences on what it covers.
- **Table of Contents** — for docs longer than 3 sections.
- **Body** — h2/h3 headings, tables, diagrams, short code examples.
- **Related Docs** — links to at least 2 other docs in the set.
- **Last Updated** — note that it was auto-generated, with the date.

## Agent-friendly patterns

Use tables for inventories, not bullet lists:

```markdown
| Endpoint | Method | Auth | Handler | Description |
|----------|--------|------|---------|-------------|
| /api/users | GET | JWT | src/routes/users.ts:14 | List all users |
```

Include file paths as anchors:

```markdown
## User Service
**Location:** `src/services/user.ts`
**Depends on:** `src/models/user.ts`, `src/utils/hash.ts`
```

Use structured constraint blocks:

```markdown
## Constraints
- All endpoints MUST validate input with Zod schemas.
- Error responses MUST use the `{ success: false, error: { code, message } }` shape.
- New routes MUST be registered in `src/routes/index.ts`.
```

## Mermaid diagrams

Pick the right type: `graph TD`/`graph LR` (architecture, services), `erDiagram` (database),
`sequenceDiagram` (request/auth flows), `flowchart TD` (workflows), `stateDiagram-v2` (lifecycles).

Quality rules:
- Every node labeled with readable text, not just IDs.
- Include directionality with labels where relationships aren't obvious.
- Keep diagrams focused — max ~15 nodes; split if larger.
- Ensure valid Mermaid syntax (proper quoting, no unsupported characters).

## Doc-type-specific guidance

- **glossary.md** — sort terms alphabetically, 1–2 sentence definitions, "Found in" column with file
  paths, group by domain area if distinct. Critical for agents: prevents invented synonyms.
- **error-catalog.md** — group by category (auth, validation, business logic, system); include name/
  class, HTTP status, code, where thrown, recommended handling; document the error response shape.
- **coding-conventions.md** — structure as DO/DON'T pairs with concrete examples; reference the
  linter/formatter configs that enforce each rule. Heavily referenced by CLAUDE.md — keep it
  authoritative.
- **environment-setup.md** — a step-by-step guide from zero; prerequisites with versions; every env
  var with an example value (never real secrets); a "Common Issues" section.
- **security.md** — start with the auth flow as a sequence diagram; document the middleware chain in
  order; note what each role/permission can access and any cross-service boundaries.

## Revision mode (retry iterations)

When re-invoked with verification feedback for a specific doc:
1. Read the **existing** doc file first.
2. Read the **verification feedback** for that document.
3. **Only fix** what the feedback calls out — don't rewrite passing sections.
4. **Preserve** the structure and content graded A.
5. **Add** missing content, **correct** inaccurate content, **improve** unclear sections.
6. Re-check that Mermaid diagrams render (valid syntax).
7. Ensure cross-references still resolve after edits.

## Self-check before finishing any doc

- [ ] "Read this doc when" trigger at the top.
- [ ] Every section has substantive content (no empty sections or TODOs).
- [ ] All Mermaid diagrams have valid syntax.
- [ ] All cross-references use correct relative paths.
- [ ] Tables have header rows and are properly formatted.
- [ ] File paths reference actual files found in exploration.
- [ ] No fabricated information — everything traces to the codebase.
- [ ] `⚠️` markers on genuinely uncertain items.
- [ ] Saved to the correct path in `docs/`.
- [ ] Related Docs section links to at least 2 other docs in the set.

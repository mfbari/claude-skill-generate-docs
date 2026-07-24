# Documentation Grading Rubric (RALPH)

The verification phase grades **every** generated doc on **5 dimensions** using **A–F** letter
grades. This rubric is the single source of truth — the verification step, the SKILL.md loop, and
any human reviewer all use it.

**Overall grade for a document = its lowest dimension grade.** A doc scoring A, A, A, B, A gets an
overall **B**. This is intentionally strict: every dimension must be A to pass.

**PASS** = every document scores A on every dimension. **FAIL** = any dimension below A on any doc.

---

## Dimension 1 — Completeness (CMP)

| Grade | Criteria |
|-------|----------|
| **A** | Covers 90%+ of relevant items found in the codebase. No significant omissions. |
| **B** | Covers 75–89%. Missing a few non-trivial items. |
| **C** | Covers 50–74%. Notable gaps in coverage. |
| **D** | Covers 25–49%. Major sections missing. |
| **F** | Covers <25% or is mostly placeholder content. |

## Dimension 2 — Accuracy (ACC)

| Grade | Criteria |
|-------|----------|
| **A** | All verifiable claims match the codebase. Zero factual errors. |
| **B** | 1–2 minor inaccuracies (e.g. slightly wrong path, outdated field name). |
| **C** | 3–5 inaccuracies or 1 significant error (e.g. wrong architecture description). |
| **D** | Multiple significant errors that would mislead a reader. |
| **F** | Predominantly incorrect or fabricated content. |

## Dimension 3 — Clarity (CLR)

| Grade | Criteria |
|-------|----------|
| **A** | Well-structured, easy to navigate, good use of headings/tables/examples. Has a "Read when" trigger. A new dev could follow it independently. Structured for AI-agent consumption. |
| **B** | Generally clear but some sections are dense or poorly organized. |
| **C** | Readable but requires significant effort. Missing structure or examples. |
| **D** | Confusing organization, jargon-heavy without explanation, hard to follow. |
| **F** | Incoherent or essentially unusable. |

## Dimension 4 — Diagrams (DIA)

| Grade | Criteria |
|-------|----------|
| **A** | Has relevant Mermaid diagrams with correct syntax, accurately represents the system, adds real understanding. |
| **B** | Has diagrams but they're incomplete or slightly inaccurate. |
| **C** | Has diagrams but they're too simplistic or have syntax errors. |
| **D** | Missing diagrams where they should clearly exist, OR diagrams are wrong. |
| **F** | No diagrams at all in a doc that requires them. |

### Diagram requirement matrix (by doc type)

| Doc | Diagram Requirement | Grading Rule |
|-----|--------------------|--------------|
| architecture.md | Required | Grade normally — must have a system map |
| api-reference.md | Required | Grade normally — must have a request flow |
| database-schema.md | Required | Grade normally — must have an ER diagram |
| frontend-backend.md | Required | Grade normally — must have a sequence diagram |
| services.md | Required | Grade normally — must have an interaction diagram |
| workflows-and-triggers.md | Required | Grade normally — must have an event flow |
| devops.md | Required | Grade normally — must have a pipeline diagram |
| security.md | Required | Grade normally — must have an auth flow |
| README.md | Optional | Auto-A if no diagrams; grade quality if present |
| tech-stack.md | Optional | Auto-A if no diagrams; grade quality if present |
| error-catalog.md | Optional | Auto-A if no diagrams; grade quality if present |
| testing-strategy.md | Optional | Auto-A if no diagrams; grade quality if present |
| environment-setup.md | Optional | Auto-A if no diagrams; grade quality if present |
| coding-conventions.md | Optional | Auto-A if no diagrams; grade quality if present |
| glossary.md | N/A | Always A — glossaries don't need diagrams |

## Dimension 5 — Coverage / Cross-References (COV)

| Grade | Criteria |
|-------|----------|
| **A** | Appropriately links to related docs. Concepts that span multiple docs are connected. Reader can navigate the full doc set. Has a "Related Docs" section. |
| **B** | Some cross-references but missing obvious connections. |
| **C** | Minimal cross-references. Doc feels isolated. |
| **D** | No cross-references despite clear connections to other docs. |
| **F** | Contradicts other docs or is completely siloed. |

---

## Writing actionable feedback

For every dimension graded below A, write **specific, actionable feedback** the generator can act
on without re-exploring the codebase:

❌ **BAD**: "Completeness needs improvement"
✅ **GOOD**: "Missing 3 API endpoints: `POST /api/webhooks` (src/routes/webhooks.ts:14),
`GET /api/health` (src/routes/health.ts:3), `DELETE /api/sessions/:id` (src/routes/auth.ts:87).
Add these to the endpoint table."

❌ **BAD**: "Glossary should have more terms"
✅ **GOOD**: "Missing domain terms: 'Workspace' (used 47× in src/models/ and src/services/, a
tenant-level org unit), 'Pipeline' (src/workers/pipeline.ts, the data-processing chain, not CI/CD).
Add with definitions."

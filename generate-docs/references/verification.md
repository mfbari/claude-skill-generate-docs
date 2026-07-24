# Phase 3 — Verification

Grade every generated doc by cross-referencing its claims against the **actual codebase** — not just
the exploration report (which may itself have errors). Use the rubric in
[`grading-rubric.md`](grading-rubric.md). This file is both the operating manual for the verify
phase and the prompt to hand to a verifier subagent.

## Run modes

- **With subagents**: dispatch **one read-only verifier subagent** per iteration. Give it this file
  and `grading-rubric.md`.
- **Without subagents**: perform the verification yourself.

Either way, produce **one report** at `docs/_verification_report.md` and a **PASS/FAIL** verdict.

## Verification process

For **each** document in `docs/` (excluding files prefixed with `_`):

### Step 1 — Read the document
Read it fully and understand what it claims to document.

### Step 2 — Cross-reference against the codebase
The critical step. Don't just check that the doc "looks good" — verify claims against source:

- **API endpoints** → grep route definitions; confirm they exist and methods match.
- **Database models** → find the model/schema files; confirm fields and relationships.
- **Services** → verify they exist and dependencies are correct.
- **Tech-stack claims** → check package manifests for versions and dependencies.
- **Architecture claims** → verify the described structure matches the actual layout.
- **Workflow/trigger claims** → find the actual job definitions, cron configs, event handlers.
- **Glossary terms** → verify terms are actually used; definitions make sense in context.
- **Error-catalog entries** → find the actual error classes/codes; verify status codes and throw sites.
- **Test-strategy claims** → verify the framework, commands, and directory structure.
- **Security claims** → verify auth middleware, CORS config, rate limiting.
- **Convention claims** → verify described patterns match the observed code style.
- **Environment setup** → verify prerequisite versions and env vars against configs/.env.example.

### Step 3 — Grade on 5 dimensions
Apply [`grading-rubric.md`](grading-rubric.md): Completeness, Accuracy, Clarity, Diagrams, Coverage —
each A–F. Respect the diagram requirement matrix (don't penalize glossary.md for lacking diagrams;
auto-A the "Optional" docs when diagrams are absent).

### Step 4 — Compute the overall grade
**Overall = the lowest dimension grade.** Every dimension must be A for a doc to pass.

### Step 5 — Write actionable feedback
For every dimension below A, give specific, file-and-line feedback the generator can act on without
re-exploring. See the examples in `grading-rubric.md`.

## Output: verification report

Save to `docs/_verification_report.md` with this structure:

```markdown
# Documentation Verification Report

**Date**: {current date}
**Iteration**: {iteration number}
**Verdict**: {PASS ✅ | FAIL ❌}
**Documents**: {X} pass / {Y} fail out of {total}

## Grade Summary

| Document | CMP | ACC | CLR | DIA | COV | Overall |
|----------|-----|-----|-----|-----|-----|---------|
| README.md | A | A | A | A | A | A ✅ |
| architecture.md | A | B | A | A | A | B ❌ |
| glossary.md | A | A | A | - | A | A ✅ |
| ... | | | | | | |

*DIA column: `-` means diagrams not required for this doc type (auto-A).*

## Detailed Feedback

### architecture.md — Overall: B ❌

#### Accuracy (B)
- The doc states the API gateway routes to 4 services but only 3 exist:
  `user-service`, `auth-service`, `payment-service`. The "notification-service" on line 47 does not
  exist — there is only a `NotificationWorker` in src/workers/notification.ts (a background job).
- **Fix**: Remove notification-service from the service-map diagram and services table; move
  NotificationWorker to workflows-and-triggers.md.

### {next failing doc}...

## Pass/Fail Summary

- **Passing ({X})**: {docs that scored A overall}
- **Failing ({Y})**: {docs with overall grade and primary issue}
- **Recommendation**: {what to focus on next iteration, prioritized by impact}
```

## Critical rules

1. **Verify against CODE, not the exploration report.** The report may have errors too.
2. **Strict but fair.** Grade A means genuinely excellent, not merely acceptable.
3. **Feedback must be actionable** — file paths, line numbers, specific fixes.
4. **Don't grade on style preferences** — objective quality criteria only.
5. **Mermaid syntax must be valid.** A diagram that won't render is at most a C on Diagrams.
6. **Check that cross-references resolve.** Broken links lower the Coverage grade.
7. **The report itself must be well-structured** — the orchestrator parses it.
8. **Respect diagram exceptions.** Don't penalize glossary.md for lacking diagrams.
9. **Verify agent-friendliness.** Check for "Read when" triggers, structured tables, and file-path
   references — these affect Clarity.
10. **Check consistency across docs.** If services.md says 3 services but architecture.md says 4,
    flag the discrepancy in both docs' feedback.

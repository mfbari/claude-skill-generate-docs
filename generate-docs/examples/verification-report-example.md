# Example: Verification Report

This shows what `docs/_verification_report.md` looks like after the verify phase.

---

```markdown
# Documentation Verification Report

**Date**: 2026-03-31
**Iteration**: 2
**Verdict**: PASS ✅
**Documents**: 15 pass / 0 fail out of 15

## Grade Summary

| Document | CMP | ACC | CLR | DIA | COV | Overall |
|----------|-----|-----|-----|-----|-----|---------|
| README.md | A | A | A | - | A | A ✅ |
| architecture.md | A | A | A | A | A | A ✅ |
| tech-stack.md | A | A | A | - | A | A ✅ |
| api-reference.md | A | A | A | A | A | A ✅ |
| database-schema.md | A | A | A | A | A | A ✅ |
| frontend-backend.md | A | A | A | A | A | A ✅ |
| services.md | A | A | A | A | A | A ✅ |
| workflows-and-triggers.md | A | A | A | A | A | A ✅ |
| devops.md | A | A | A | A | A | A ✅ |
| glossary.md | A | A | A | - | A | A ✅ |
| error-catalog.md | A | A | A | - | A | A ✅ |
| testing-strategy.md | A | A | A | - | A | A ✅ |
| environment-setup.md | A | A | A | - | A | A ✅ |
| coding-conventions.md | A | A | A | - | A | A ✅ |
| security.md | A | A | A | A | A | A ✅ |

*DIA column: `-` means diagrams not required for this doc type (auto-A).*

## Iteration 1 Failures (fixed in iteration 2)

### api-reference.md — Was: B (now A)
Previously missing 3 endpoints that were fixed:
- POST /api/webhooks (src/routes/webhooks.ts:14)
- GET /api/health (src/routes/health.ts:3)
- DELETE /api/sessions/:id (src/routes/auth.ts:87)

### glossary.md — Was: B (now A)
Previously missing key domain terms:
- "Pipeline" was not defined (used 23 times in codebase)
- "Quota" was not defined (used in billing module)
Both added with accurate definitions.

## Pass/Fail Summary

- **Passing (15)**: All documents
- **Failing (0)**: None
- **Recommendation**: Documentation is complete and verified.
```

# 📚 generate-docs — AI-Powered Documentation Generator for Claude Code

> One command. 15 docs. Verified against your actual code. Wired into CLAUDE.md and AGENTS.md.

**generate-docs** is a multi-agent Claude Code slash command that scans your entire codebase and generates a complete documentation suite — architecture diagrams, API references, database schemas, domain glossaries, error catalogs, and more — then verifies every claim against actual source code using a strict grading rubric, and iterates until quality passes.

When it's done, it updates your `CLAUDE.md` with progressive disclosure references and creates an `AGENTS.md` for cross-tool compatibility — so every AI coding agent (Claude Code, Cursor, Copilot, SpecKit, Windsurf, Codex) immediately has the context it needs.

```
/generate-docs        # default: 3 max retries
/generate-docs 5      # complex repos: 5 retries
```

---

## Why This Exists

Most codebases have stale or missing documentation. That's always been a problem for humans, but it's now a **critical problem for AI coding agents**.

AI agents make better decisions when they have structured context — but they can't read your team's collective knowledge. They see files, not intent. They see code, not the decisions behind it. Without documentation, agents hallucinate endpoints, invent database fields, misuse domain terms, and break architectural boundaries they didn't know existed.

**generate-docs** solves this by treating documentation as infrastructure: machine-readable, verified against code, and wired directly into the context files that AI agents load on every session.

---

## The Context Engineering Problem

Recent research in AI-assisted software development reveals a consistent finding: **the quality of an AI agent's output is directly proportional to the quality of context it receives** — not the sophistication of the model or the cleverness of the prompt.

This is the discipline increasingly called **context engineering**: curating exactly what information reaches an agent's context window, and when.

### What the research shows

**Context files work, but only when curated carefully.** A February 2026 ETH Zurich study evaluating AGENTS.md files found nuanced results: LLM-generated context files tended to *decrease* task success rates while increasing inference costs by 20%+. But developer-curated, minimal, specific instructions showed measurable improvements — especially in larger, more complex codebases. The key finding is that auto-generating context files naively is counterproductive. What matters is structured, verified, minimal context.

**Instruction-following degrades with document length.** Anthropic's own research shows that Claude Code's system prompt already uses roughly a third of the ~150–200 instruction budget that frontier models reliably follow. Every unnecessary line in CLAUDE.md dilutes the important ones. The recommendation: keep CLAUDE.md under 200 lines total, use progressive disclosure to load detail on-demand.

**Progressive disclosure outperforms monolithic context.** Instead of stuffing everything into one file, the most effective pattern is a lean root context file (CLAUDE.md / AGENTS.md) that points to detailed docs loaded only when relevant. Claude Code's `@import` syntax, Cursor's glob-scoped rules, and Copilot's `applyTo` frontmatter all enable this pattern.

**Domain glossaries prevent the most common AI mistakes.** AI agents trained on general corpora misinterpret domain-specific terms. A "Workspace" in your codebase might mean a tenant-level org unit, not a VS Code workspace. Teams that include terminology sections in their context files report significantly fewer naming and conceptual errors from agents.

**Verification against code is non-negotiable.** Documentation that claims endpoints or models exist when they don't is worse than no documentation — it actively misleads agents. generate-docs' verify phase cross-references every claim against actual source files, catching fabrication and drift that makes AI agents unreliable.

### How generate-docs applies these findings

| Research Finding | generate-docs Implementation |
|---|---|
| Keep CLAUDE.md under 200 lines | Auto-generated section capped at 80 lines, progressive disclosure to docs/ |
| Don't auto-generate naively | Multi-phase explore → generate → verify with RALPH-style grading loop |
| Progressive disclosure > monolithic | "Read when" triggers + `@docs/filename.md` imports in CLAUDE.md |
| Domain glossaries prevent errors | Dedicated `glossary.md` with terms extracted from actual codebase |
| Verify against code, not just docs | Verifier agent greps actual source files, not the exploration report |
| Structure for machine consumption | Tables over prose, file path anchors, explicit headings, "Read when" triggers |
| Cross-tool compatibility matters | Generates both CLAUDE.md (Claude Code) and AGENTS.md (universal standard) |

---

## How It Works

```
┌───────────────────────────────────────────────────────────────────┐
│                         ORCHESTRATOR                               │
│                       /generate-docs [N]                           │
└──────────────────────────┬────────────────────────────────────────┘
                           │
                  ┌────────▼────────┐
                  │  PHASE 0: BOOT   │  Detect/create CLAUDE.md
                  │  Run /init or    │  Back up existing content
                  │  create minimal  │  Note AGENTS.md presence
                  └────────┬────────┘
                           │
                  ┌────────▼────────┐
                  │  PHASE 1: EXPLORE│  8 parallel read-only agents
                  │                  │
                  │  ┌──┐┌──┐┌──┐  │  1. Tech Stack & Overview
                  │  │E1││E2││E3│  │  2. Architecture & Services
                  │  └──┘└──┘└──┘  │  3. API Surface
                  │  ┌──┐┌──┐┌──┐  │  4. Database & Data Layer
                  │  │E4││E5││E6│  │  5. Frontend-Backend Comms
                  │  └──┘└──┘└──┘  │  6. Workflows & DevOps
                  │  ┌──┐┌──┐      │  7. Domain Terms & Errors
                  │  │E7││E8│      │  8. Testing, Security & Conventions
                  │  └──┘└──┘      │
                  └────────┬────────┘
                           │  → _exploration_report.md
           ┌───────────────▼────────────────┐
    ┌─────►│  PHASE 2: GENERATE              │  15 parallel writer agents
    │      │                                  │  Each writes one doc file
    │      │  ┌──┐┌──┐┌──┐  ...  ┌───┐     │  with Mermaid diagrams
    │      │  │G1││G2││G3│       │G15│     │  and cross-references
    │      │  └──┘└──┘└──┘  ...  └───┘     │
    │      └───────────────┬────────────────┘
    │                      │  → 15 doc files in docs/
    │      ┌───────────────▼────────────────┐
    │      │  PHASE 3: VERIFY                │  1 verification agent
    │      │                                  │  Cross-references docs
    │      │  Grades A-F × 5 dimensions      │  against actual source code
    │      │  per document                    │
    │      └───────────────┬────────────────┘
    │                      │  → _verification_report.md
    │               ┌──────▼──────┐
    │               │  ALL PASS?   │
    │               └──────┬──────┘
    │                 YES  │  NO
    │                  │   └── retries left? ─── YES ──┐
    │                  │                                │
    │                  ▼                 Re-generate     │
    │        ┌─────────────────┐        ONLY failing    │
    │        │  PHASE 4: UPDATE │        docs ───────────┘
    │        │                  │
    │        │  CLAUDE.md       │  Progressive disclosure refs
    │        │  AGENTS.md       │  Cross-tool compatibility
    │        └────────┬────────┘
    │                 ▼
    │               DONE ✅
    └───────────────────────────────────────────────────┘
```

### The Five Phases

**Phase 0 — Bootstrap.** Checks for an existing CLAUDE.md. If found, backs it up. If missing, runs `/init` (or creates a minimal one). Never overwrites human-written content.

**Phase 1 — Explore.** Dispatches 8 parallel read-only subagents, each scanning a different domain: tech stack, architecture, APIs, database, frontend-backend communication, workflows/DevOps, domain terminology/errors, and testing/security/conventions. They use grep, glob, and file reading to produce structured inventories with exact file paths and line numbers.

**Phase 2 — Generate.** Dispatches 15 parallel writer subagents. Each produces one documentation file with Mermaid diagrams, structured tables, cross-references to related docs, and "Read when" triggers for AI agent consumption. On retry iterations, only failing docs are regenerated — passing docs are preserved.

**Phase 3 — Verify.** A dedicated verifier agent reads every generated doc and cross-references its claims against actual source code (not the exploration report). Each doc is graded A–F on 5 dimensions: Completeness, Accuracy, Clarity, Diagrams, and Coverage. Overall grade = lowest dimension (intentionally strict). The verifier produces specific, actionable feedback with file paths and line numbers for anything below A.

**Phase 4 — Context Update.** Appends a progressive disclosure section to CLAUDE.md with `@docs/filename.md` references and "Read when" triggers, capped at 80 lines. Creates AGENTS.md (tool-agnostic version) for Cursor, Copilot, Windsurf, Codex, and other tools. Both files point to docs rather than duplicating content.

---

## Generated Documentation

### Core Architecture Docs (Mermaid diagrams required)

| File | Contents |
|------|----------|
| `architecture.md` | System architecture, service map, component & deployment diagrams, key design decisions |
| `api-reference.md` | Every endpoint: method, path, params, auth requirements, request/response shapes |
| `database-schema.md` | Tables, fields, types, relationships, indexes, ER diagrams, migration timeline |
| `frontend-backend.md` | Data fetching patterns, auth flow sequence diagrams, real-time, shared contracts |
| `services.md` | Service/module map, responsibilities, dependencies, inter-service communication |
| `workflows-and-triggers.md` | Background jobs, cron schedules, event triggers, webhooks, queue topology |
| `devops.md` | CI/CD pipelines, deployment process, infrastructure, monitoring, environments |
| `security.md` | Auth model, authorization boundaries, validation, CORS, rate limiting, middleware chain |

### Context & Convention Docs (critical for AI agents)

| File | Contents |
|------|----------|
| `glossary.md` | Domain terms, abbreviations, business entities with plain-English definitions |
| `error-catalog.md` | Error types, codes, HTTP status mappings, throw locations, handling patterns |
| `coding-conventions.md` | Code patterns, naming rules, design patterns, DO/DON'T pairs with examples |
| `testing-strategy.md` | Test framework setup, commands, directory structure, coverage, test data patterns |
| `environment-setup.md` | Local dev prerequisites, install steps, env vars, secrets, common gotchas |
| `tech-stack.md` | Languages, frameworks, libraries, tools — what each is and why it's used |
| `README.md` | Project overview, quick-start guide, links to all other documentation |

### Auto-Managed Context Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Updated with progressive disclosure references for Claude Code |
| `AGENTS.md` | Tool-agnostic version for Cursor, Copilot, Windsurf, Codex, SpecKit |

---

## Quality Grading

Every document is graded **A–F** on 5 dimensions:

| Dimension | Grade A Criteria |
|-----------|-----------------|
| **Completeness** | Covers 90%+ of relevant items found in the codebase |
| **Accuracy** | All verifiable claims match source code — zero factual errors |
| **Clarity** | Well-structured, scannable, has "Read when" trigger, agent-friendly tables |
| **Diagrams** | Mermaid diagrams present where required, syntactically valid, adds understanding |
| **Coverage** | Cross-references related docs, concepts linked, has Related Docs section |

**Overall grade = lowest dimension grade.** A doc scoring A, A, A, B, A gets an overall B. This is intentionally strict — every dimension must pass.

Docs where diagrams are optional (glossary, conventions, etc.) receive an automatic A on the Diagrams dimension.

The verifier produces **actionable feedback** with file paths and line numbers:

```
❌ BAD:  "Completeness needs improvement"
✅ GOOD: "Missing 3 API endpoints: POST /api/webhooks (src/routes/webhooks.ts:14),
         GET /api/health (src/routes/health.ts:3), DELETE /api/sessions/:id
         (src/routes/auth.ts:87). Add these to the endpoint table."
```

---

## Installation

### Option A — Project-level (recommended)

Version-control it with your repo so the whole team has it:

```bash
# Clone this repo
git clone https://github.com/YOUR_USERNAME/generate-docs.git /tmp/generate-docs

# Copy into your project
mkdir -p .claude/commands .claude/agents
cp /tmp/generate-docs/.claude/commands/generate-docs.md .claude/commands/
cp /tmp/generate-docs/.claude/agents/doc-*.md .claude/agents/

# Clean up
rm -rf /tmp/generate-docs
```

### Option B — Global install

Available across all your projects:

```bash
git clone https://github.com/YOUR_USERNAME/generate-docs.git /tmp/generate-docs

mkdir -p ~/.claude/commands ~/.claude/agents
cp /tmp/generate-docs/.claude/commands/generate-docs.md ~/.claude/commands/
cp /tmp/generate-docs/.claude/agents/doc-*.md ~/.claude/agents/

rm -rf /tmp/generate-docs
```

### Option C — Install script

```bash
git clone https://github.com/YOUR_USERNAME/generate-docs.git /tmp/generate-docs
cd /tmp/generate-docs

./install.sh              # Project-level (current directory)
./install.sh --global     # Global (~/.claude/)
```

---

## Usage

```bash
# In Claude Code, at your project root:

/generate-docs            # Default: 3 retry iterations
/generate-docs 5          # Complex repos: allow 5 iterations
/generate-docs 1          # Quick pass: single iteration, no retry
```

### What happens

1. Creates `docs/` directory with 15 markdown files + Mermaid diagrams
2. Updates `CLAUDE.md` with progressive disclosure references
3. Creates `AGENTS.md` for cross-tool compatibility
4. Prints a summary grade table showing pass/fail per document

### Output structure

```
your-project/
├── CLAUDE.md                          ← updated (human content preserved)
├── AGENTS.md                          ← created/updated
├── docs/
│   ├── README.md                      ← project overview & quick-start
│   ├── architecture.md                ← system architecture + Mermaid diagrams
│   ├── tech-stack.md                  ← languages, frameworks, tools, versions
│   ├── api-reference.md               ← complete API endpoint inventory
│   ├── database-schema.md             ← schema + ER diagrams
│   ├── frontend-backend.md            ← communication patterns + auth flow
│   ├── services.md                    ← service map + interaction diagrams
│   ├── workflows-and-triggers.md      ← jobs, cron, events, webhooks
│   ├── devops.md                      ← CI/CD, deployment, infrastructure
│   ├── glossary.md                    ← domain terminology
│   ├── error-catalog.md               ← error types, codes, handling
│   ├── testing-strategy.md            ← test setup, patterns, commands
│   ├── environment-setup.md           ← local dev setup guide
│   ├── coding-conventions.md          ← code patterns and rules
│   ├── security.md                    ← auth, authz, validation
│   ├── _exploration_report.md         ← internal: raw scan data
│   ├── _verification_report.md        ← internal: quality grades
│   └── _claude_md_backup.md           ← internal: pre-edit CLAUDE.md backup
```

> **Tip:** Add `docs/_*.md` to `.gitignore` to exclude internal working files from version control.

---

## Cross-Tool Compatibility

generate-docs generates documentation that works across the AI coding tool ecosystem:

| Tool | Context File | How generate-docs helps |
|------|-------------|-------------------|
| **Claude Code** | `CLAUDE.md` | Progressive disclosure with `@docs/` imports and "Read when" triggers |
| **Cursor** | `.cursor/rules/` + `AGENTS.md` | AGENTS.md provides structured context; docs are @-importable |
| **GitHub Copilot** | `.github/copilot-instructions.md` + `AGENTS.md` | AGENTS.md gives Copilot project awareness |
| **Windsurf** | `.windsurf/rules/` + `AGENTS.md` | Same AGENTS.md pattern |
| **OpenAI Codex** | `AGENTS.md` | Primary context format for Codex CLI |
| **GitHub SpecKit** | `specs/` + `docs/` | Docs map to SpecKit phases: architecture→plan, glossary→clarify, conventions→constitution |
| **Roo Code** | `.roo/rules/` + `AGENTS.md` | AGENTS.md as default context |

### SpecKit Integration

The `docs/` structure maps directly to SpecKit's spec-driven development workflow:

| generate-docs Output | SpecKit Phase | Context It Provides |
|---|---|---|
| `docs/architecture.md` | `/speckit.plan` | Design context for technical planning |
| `docs/api-reference.md` | `/speckit.specify` | Contract context for feature specification |
| `docs/glossary.md` | `/speckit.clarify` | Domain context for ambiguity resolution |
| `docs/coding-conventions.md` | `/speckit.constitution` | Constraint context for project principles |
| `docs/database-schema.md` | `/speckit.plan` | Data model context for schema decisions |
| `docs/security.md` | `/speckit.plan` | Security context for auth/authz planning |

After running `/generate-docs`, SpecKit's `/speckit.analyze` will find rich, structured context ready for spec-driven development.

---

## Customization

### Changing the passing grade

Edit `.claude/commands/generate-docs.md` and change the passing grade from A to your desired level (e.g., B). Also update the PASS/FAIL logic in the verifier agent.

### Adding new documentation types

1. Add exploration instructions to the relevant Phase 1 subagent in `generate-docs.md`
2. Add a row to the Phase 2 generation table
3. Add verification rules to `doc-verifier.md`
4. Add the "Read when" reference to the Phase 4 CLAUDE.md template

### Changing agent models

Each agent file has a `model:` field in its YAML frontmatter:

| Model | Best for | Cost |
|-------|----------|------|
| `haiku` | Fast exploration, simple docs | Lowest |
| `sonnet` | Balanced quality (default) | Medium |
| `opus` | Maximum thoroughness, complex repos | Highest |

### Adjusting the grading rubric

Edit `.claude/agents/doc-verifier.md` to modify grade thresholds, add dimensions, or change the diagram requirement rules per document type.

---

## Architecture

```
.claude/
├── commands/
│   └── generate-docs.md       ← Orchestrator: coordinates all 5 phases
└── agents/
    ├── doc-explorer.md        ← Read-only codebase scanner (8 instances)
    ├── doc-generator.md       ← Documentation writer (15 instances)
    └── doc-verifier.md        ← Quality auditor (1 instance)
```

**Orchestrator** (`generate-docs.md`) — The slash command itself. Parses arguments, runs the 5-phase loop, dispatches subagents, manages iteration logic, and handles the CLAUDE.md/AGENTS.md update.

**Explorer** (`doc-explorer.md`) — Read-only subagent with access only to read tools (Read, Glob, Grep, find, cat, tree). Dispatched 8 times in parallel, each instance scanning a different domain. Produces structured markdown inventories with exact file paths.

**Generator** (`doc-generator.md`) — Writer subagent with read + write access. Dispatched 15 times in parallel (once per doc). Takes exploration data and produces polished documentation with Mermaid diagrams, tables, and cross-references. Has a revision mode for fixing specific feedback without rewriting passing sections.

**Verifier** (`doc-verifier.md`) — Quality auditor with read-only access. Dispatched once per iteration. Reads every generated doc and cross-references claims against actual source code. Grades on 5 dimensions, produces actionable feedback with file paths and line numbers.

---

## FAQ

**How long does it take?**
Depends on repo size. A medium-sized project (50-100 files) typically completes in 5-15 minutes with 1-2 iterations. Large monorepos may need 15-30 minutes with more retries.

**How much does it cost in tokens?**
Each iteration uses roughly: 8 explorer contexts + 15 generator contexts + 1 verifier context. For a medium project, expect ~500K-1M tokens per iteration. Use `haiku` for explorers to reduce costs.

**Will it overwrite my existing CLAUDE.md?**
No. It backs up your CLAUDE.md, then only manages a clearly marked auto-generated section. Everything above the `<!-- BEGIN AUTO-GENERATED DOCS SECTION -->` marker is preserved untouched.

**What if my repo is backend-only / frontend-only?**
The explorer agents will detect this and the frontend-backend doc will note "no frontend detected" or similar. No fabrication — it only documents what exists.

**Can I run it on a monorepo?**
Yes, but consider using `/generate-docs 5` for more retry iterations. Monorepos have more surface area and the first pass may miss some inter-package relationships.

**Does it work with languages other than JavaScript/TypeScript?**
Yes. The explorer agents search for language-agnostic patterns (route definitions, model definitions, config files) across Python, Go, Rust, Java, Ruby, C#, PHP, and more. Package manifest detection covers all major ecosystems.

---

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Areas where contributions would be especially valuable:
- Language-specific exploration patterns (e.g., better Go module detection)
- New documentation types for specific domains (e.g., ML model documentation)
- Grading rubric refinements based on real-world usage
- Integration examples with other AI coding tools

---

## License

MIT — see [LICENSE](LICENSE) for details.

---

## Acknowledgments

Built on research and ideas from:
- [GitHub Spec Kit](https://github.com/github/spec-kit) — Spec-driven development methodology
- [AGENTS.md](https://agents.md/) — Universal AI agent context standard
- [Ralph Wiggum technique](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) — Iterative AI development loops
- [Anthropic's CLAUDE.md best practices](https://claude.com/blog/using-claude-md-files) — Progressive disclosure and context engineering
- ETH Zurich's research on context file effectiveness
- The broader context engineering community

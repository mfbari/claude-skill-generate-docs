# Bootstrap & Context Files (Phase 0 + Phase 4)

Covers the two phases that touch the project's AI-agent context files: **Phase 0 — Bootstrap**
(run once, before exploration) and **Phase 4 — Context Update** (run after a PASS or on the final
iteration).

---

## Phase 0 — Bootstrap (CLAUDE.md detection)

Before anything else:

1. **Check if `CLAUDE.md` exists** at the project root.
2. **If it exists**: read it and back it up to `docs/_claude_md_backup.md`. Note its contents — you
   will **append to it, not overwrite**.
3. **If it does NOT exist**: bootstrap one. If your harness has an init command (e.g. Claude Code's
   `/init`), run it and wait for completion. Otherwise create a minimal CLAUDE.md:
   ```markdown
   # {Project Name}

   {One-line description — inferred from README, package.json, or repo name}

   ## Commands
   <!-- Auto-populated by generate-docs -->

   ## Project Structure
   <!-- Auto-populated by generate-docs -->
   ```
4. **Check if `AGENTS.md` exists** at the project root. Note its presence for Phase 4.

---

## Phase 4 — Context Update

Run this phase **only after verification returns PASS, or on the final iteration**. It wires the
docs into the project's context files using progressive disclosure.

### Step 4a — Update CLAUDE.md

Read the current CLAUDE.md. **Do not overwrite existing human-written content.** Append or update a
clearly marked auto-generated section, using the template in
[`../assets/claude-md-section.md`](../assets/claude-md-section.md).

The auto-generated section must:
- Stay **under 80 lines** (leaving room for human content; total CLAUDE.md under ~200 lines).
- Use **progressive disclosure** with "Read when" triggers.
- Reference docs with `@docs/filename.md` syntax (Claude Code's import system).
- Never duplicate doc content — just point to the docs.

Rules:
- If the `BEGIN AUTO-GENERATED DOCS SECTION` marker exists, replace **only** that section.
- If no marker exists, append the section at the end of the file.
- **Never** delete or modify content above the marker — that's human-curated.
- Fill the template's Project Structure (≤8 lines) and Key Commands (≤6 lines) from the exploration
  findings (top-level dir → purpose; build/test/dev/lint commands from package.json/Makefile/etc.).

### Step 4b — Generate/Update AGENTS.md

Create or update `AGENTS.md` at the project root for cross-tool compatibility (Cursor, Windsurf,
Copilot, Codex, Roo Code all read it). Use the template in
[`../assets/agents-md.md`](../assets/agents-md.md).

AGENTS.md is a **condensed, tool-agnostic version** — same progressive-disclosure pattern but with
plain relative paths instead of Claude-specific `@` imports. Keep it **under 120 lines**. Fill the
Project Structure and Commands to match the CLAUDE.md section, summarize architecture in 2–3
sentences, list the top ~5 conventions and top ~10 domain terms extracted from the generated docs.

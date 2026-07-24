# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] — 2026-07-24

### Changed
- **Restructured into a portable Agent Skill.** The Claude-Code-specific slash command
  (`.claude/commands/generate-docs.md`) and named subagents (`.claude/agents/doc-*.md`) are replaced
  by a self-contained `generate-docs/` skill folder: `SKILL.md` (orchestrator) + `references/`
  (per-phase methodology) + `assets/` (context-file templates) + `examples/`.
- **Harness-agnostic execution.** `SKILL.md` describes how to run each phase with parallel subagents
  where the harness supports them, or inline where it doesn't — same output either way. No hard
  dependency on Claude Code's Task tool or named agent definitions.
- The old three agent prompts are preserved as reference files: `references/exploration.md`,
  `references/generation.md`, `references/verification.md`.
- The A–F grading rubric is extracted to `references/grading-rubric.md` as the single source of
  truth, shared by the verify phase and any human reviewer.
- Models are now selected by the harness at runtime rather than pinned in agent frontmatter.
- Installer rewritten to place the skill in a skills directory (`.claude/skills/generate-docs/`);
  README, CONTRIBUTING, and examples updated for the skill layout.

### Migration
- Re-run `./install.sh` (or `./install.sh --global`) to install the skill folder. Remove any old
  `.claude/commands/generate-docs.md` and `.claude/agents/doc-*.md` from prior installs.

## [1.0.0] — 2026-03-31

### Added
- Initial release
- Multi-agent orchestrator with 5-phase pipeline (Bootstrap → Explore → Generate → Verify → Context Update)
- 8 parallel explorer subagents covering: tech stack, architecture, APIs, database, frontend-backend, workflows/DevOps, domain terminology/errors, testing/security/conventions
- 15 documentation types generated with Mermaid diagrams
- RALPH-style A–F grading on 5 dimensions (Completeness, Accuracy, Clarity, Diagrams, Coverage)
- Iterative retry loop — regenerates only failing docs until all pass or max retries reached
- CLAUDE.md integration with progressive disclosure and "Read when" triggers
- AGENTS.md generation for cross-tool compatibility (Cursor, Copilot, Windsurf, Codex)
- SpecKit-compatible output structure
- Configurable max retries via argument (`/generate-docs [N]`, default 3)
- Install script for project-level and global installation
- Diagram grading exceptions for doc types that don't need diagrams
- Human-written CLAUDE.md content preservation (auto-generated section only)
- Backup of original CLAUDE.md before modification

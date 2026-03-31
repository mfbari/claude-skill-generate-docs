# Changelog

All notable changes to this project will be documented in this file.

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

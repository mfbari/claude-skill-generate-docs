# Contributing to generate-docs

Thanks for your interest in contributing! This project is a Claude Code skill (slash command + agents) that generates documentation for codebases. Contributions that improve exploration accuracy, doc quality, grading rubrics, or cross-tool compatibility are especially welcome.

## How to Contribute

### Reporting Issues

Open a GitHub issue with:
- What you ran (`/generate-docs` with what arguments)
- What kind of codebase (language, framework, monorepo vs single)
- What went wrong (missing docs, inaccurate content, grading issues)
- The `_verification_report.md` if available

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b improve-explorer-patterns`)
3. Make your changes
4. Test by installing in a project and running `/generate-docs`
5. Submit a pull request with a clear description of what changed and why

### What to Contribute

**High-value contributions:**
- Language-specific exploration patterns (better detection for Go, Rust, Java, C#, etc.)
- New documentation types for specific domains (ML model docs, GraphQL schema docs, etc.)
- Grading rubric refinements based on real-world usage
- Bug fixes where explorer misses files or generator fabricates content
- Verifier improvements that catch more inaccuracies

**Structure:**
- Orchestrator changes go in `.claude/commands/generate-docs.md`
- Agent behavior changes go in `.claude/agents/doc-*.md`
- New agents go in `.claude/agents/` with a descriptive name

### Code Style

These are markdown files, not code, but please:
- Keep agent instructions clear and specific
- Use concrete examples over abstract descriptions
- Include file path patterns when adding exploration rules
- Test against at least one real codebase before submitting

## Testing

There's no automated test suite (these are prompt files). To test your changes:

1. Install the modified files into a test project
2. Run `/generate-docs 1` for a quick single-pass test
3. Check the `_verification_report.md` for quality grades
4. Verify the generated docs against the actual codebase manually
5. Check that `CLAUDE.md` and `AGENTS.md` were updated correctly

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

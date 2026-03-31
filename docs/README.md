# Documentation

## Examples

These show what generate-docs generates when you run `/generate-docs` on a project:

| Example | Description |
|---------|-------------|
| [claude-md-example.md](examples/claude-md-example.md) | The auto-generated section appended to your CLAUDE.md with progressive disclosure references |
| [agents-md-example.md](examples/agents-md-example.md) | The AGENTS.md file created for cross-tool compatibility |
| [verification-report-example.md](examples/verification-report-example.md) | A sample verification report showing A–F grading and actionable feedback |

## How generate-docs uses these patterns

generate-docs generates 15 documentation files in your project's `docs/` directory, then wires them into your context files. The examples above show what the context file integration looks like — the actual `docs/*.md` files are generated fresh from your codebase each time.

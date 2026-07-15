# Contributing

Thanks for helping improve this project. Keep changes small, readable, and easy to review.

## Before you start

1. Create a branch from `master` for your change.
2. Prefer one concern per branch/PR (fix, feature, docs, or chore).
3. Read `AGENTS.md` if you are using an AI coding agent.

## Branch naming

Use short, descriptive branch names, for example:

- `docs/improve-readme`
- `fix/region-edge-case`
- `chore/update-gitignore`

## Commit messages

Write commits that explain **why**, not only what changed.

Good examples:

- `docs: add contribution guidelines`
- `fix: preserve marker names without extensions`
- `chore: normalize line endings and editor defaults`

## Pull requests

Every PR should include:

- A short summary of the change
- Motivation / context
- How you tested it
- Any follow-up work left undone

Use the PR template. Keep diffs focused. Avoid mixing refactors with unrelated behavior changes.

## Code style

- Match existing formatting in nearby files.
- Prefer clear names over cleverness.
- Do not leave temporary debug prints or scratch files in the repo.
- Keep secrets out of git; use `.env.example` if env vars are needed later.

## Docs expectations

If behavior, setup, or contribution process changes, update the relevant docs in the same PR:

- `README.md` for user-facing setup and overview
- `CHANGELOG.md` under `[Unreleased]`
- `CONTRIBUTING.md` / `AGENTS.md` for process changes

## Reporting issues

Use the issue templates when possible. Include:

- What you expected
- What happened
- Steps to reproduce
- Environment details (OS, relevant app versions)

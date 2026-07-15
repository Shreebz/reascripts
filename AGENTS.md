# Agent Guide

Instructions for AI coding agents working in this repository.

## Goals

- Prefer small, reviewable changes.
- Protect existing behavior unless the task explicitly changes it.
- Keep docs and code in sync.

## Do

- Read nearby files before editing.
- Follow existing naming and layout patterns.
- Update `CHANGELOG.md` `[Unreleased]` for user-visible changes.
- Keep commits focused and messages clear.
- Run available checks before finishing.

## Do not

- Commit secrets, credentials, or personal machine paths.
- Add large unrelated refactors to a feature/fix PR.
- Invent dependencies or tooling without a clear need.
- Rewrite working code style “for consistency” unless asked.

## Suggested workflow

1. Inspect current tree and recent git history.
2. Create or switch to a dedicated branch.
3. Make the smallest change that satisfies the request.
4. Update docs when behavior or process changes.
5. Commit, push, and open/update a PR.

## Repo hygiene files

| File | Purpose |
| --- | --- |
| `README.md` | Project overview and getting started |
| `CONTRIBUTING.md` | Human contribution process |
| `AGENTS.md` | AI agent working agreements |
| `CHANGELOG.md` | Release/history notes |
| `SECURITY.md` | Vulnerability reporting |
| `LICENSE` | Usage terms |
| `.editorconfig` | Consistent editor formatting |
| `.gitattributes` | Line-ending and file-type norms |
| `.gitignore` | Keep junk and secrets out of git |

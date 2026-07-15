# Shreebz's ReaScripts

Handy [REAPER](https://www.reaper.fm/) scripts for game-audio workflows.

## Start here

This repo is set up for clean collaboration from day one. If you are setting the project up or contributing, read these first:

1. [CONTRIBUTING.md](CONTRIBUTING.md) — how to branch, commit, and open PRs
2. [AGENTS.md](AGENTS.md) — working agreements for AI coding agents
3. [CHANGELOG.md](CHANGELOG.md) — what changed recently
4. [SECURITY.md](SECURITY.md) — how to report vulnerabilities
5. [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) — community expectations
6. [LICENSE](LICENSE) — usage terms (MIT)

## How to use

1. Install REAPER
2. Install the [SWS Extension](https://www.sws-extension.org/)
3. Install the [ReaPack](https://reapack.com/) extension
4. Import this repository in ReaPack using the link below

### Repository link

```text
https://raw.githubusercontent.com/Shreebz/reascripts/master/index.xml
```

## Project layout

| Path | Role |
| --- | --- |
| `Dev/` | Shared development helpers |
| `Regions/` | Region-related scripts |
| `Rename/` | Rename helpers for regions, markers, and takes |
| `index.xml` | ReaPack index |
| `.github/` | Issue and pull request templates |

## Development hygiene

- Editor defaults live in `.editorconfig`
- Line endings and text/binary handling live in `.gitattributes`
- Local scratch files and secrets are ignored via `.gitignore`
- Keep work in focused feature branches; avoid committing directly to `master`

## Bookmarked repositories

Other repositories worth tracking:

1. [Joep Vanlier](https://github.com/JoepVanlier/JSFX?tab=readme-ov-file)
2. [chokehold](https://github.com/chkhld/jsfx/)
3. [Geraint](https://geraintluff.github.io/jsfx/)

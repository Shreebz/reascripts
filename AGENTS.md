# Shreebz ReaScripts

Game-audio scripts for REAPER, written by Dave Schreiber (Shreebz). Agents edit Lua in this repository. REAPER runs the scripts. People install them with ReaPack.

Requires REAPER, the SWS extension, and ReaPack. The ReaPack import URL is in `README.md`.

## Layout

- `Dev/Shreebz - Lua Dev Library.lua` — shared `shreebz` library. ReaPack metapackage, current version 7.2. The top of the file is a commented script template. The live API is the `shreebz.*` functions below that.
- `Regions/` — region timing actions.
- `Rename/` — marker, region, and take renaming.
- `index.xml` — ReaPack catalog. Each script has a version, author, changelog, and a GitHub raw URL pinned to a commit.

Scripts that need the library load the installed copy, not this file:

`reaper.GetResourcePath()..'/Scripts/shreebz scripts/dev/shreebz - lua utilities.lua'`

## New scripts

Use a topic folder. `Regions/` and `Rename/` are the current ones. Add a folder when the action does not fit.

Start the file with ReaPack header tags:

```lua
-- @description What the action does
-- @version 1.0
-- @author Dave Schreiber - Shreebz
-- @about
--   # Short title
-- @changelog
--   Initial version
```

Put shared helpers on the `shreebz` table in the dev library. Keep one-off logic in the action script.

Wrap project edits in `reaper.Undo_BeginBlock` and `reaper.Undo_EndBlock`. Around bulk edits, call `reaper.PreventUIRefresh(1)` first and `reaper.PreventUIRefresh(-1)` after, then `reaper.UpdateArrange()`.

## Publishing

`index.xml` is generated. Do not edit it by hand.

`reapack-index` 1.2.3 is on PATH. It reads committed script headers and writes the index. Bump `@version` and set `@changelog` before the script commit. A new version is picked up only from a commit newer than the `commit` attribute on `index.xml`.

1. Commit the script.
2. Run `reapack-index --check` to validate headers, including uncommitted files.
3. Run `reapack-index --commit` to scan new commits, rewrite `index.xml`, and commit the index. The default message looks like `index: 1 new version`.
4. Push. ReaPack users install from the raw `index.xml` URL in `README.md`.

In REAPER, ReaPack is installed as `reaper_reapack-arm64.dylib`. After a push, install or update with Extensions > ReaPack > Synchronize packages.

## Scratch

`.gitignore` excludes `wip/`, `*.dev.lua`, and `*bgs*`. Those files are local scratch.

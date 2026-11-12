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

A script is absent from the ReaPack repository until `index.xml` lists it. Leave `index.xml` unchanged unless the task is to publish or version a script. Source URLs stay pinned to a commit.

## Scratch

`.gitignore` excludes `wip/`, `*.dev.lua`, and `*bgs*`. Those files are local scratch.

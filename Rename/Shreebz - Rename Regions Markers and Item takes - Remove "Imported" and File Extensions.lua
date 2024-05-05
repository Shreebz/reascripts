-- @description Remove file extension from markers and regions
-- @version 1.0
-- @author Dave Schreiber
-- @about
--   # File extension remover
--   No comment
-- @changelog
--   Initial commit

local function sanitizeName(str)
    if str then
        -- pattern = "(.-)-imported-%d+%.([^%.]+)$"
        pattern01 = "%-imported.*$"
        pattern02 = "%..*$"
        new_name = str
        -- reaper.ShowConsoleMsg("original_name: "..original_name.."\n")
        new_name = (new_name:gsub(pattern01,""))
        new_name = (new_name:gsub(pattern02,""))
        -- reaper.ShowConsoleMsg("new_name: "..new_name.."\n")
        return new_name
    end
end

local function regionsRename()
    -- Iterate over all the regions in the project and rename
    local numMarkers = reaper.CountProjectMarkers(0) -- This includes both markers and regions
    for i = 0, numMarkers - 1 do
        local num, isrgn, pos, rgnEnd, name, idx, color = reaper.EnumProjectMarkers3(0, i)
        -- if isrgn then
            local name = sanitizeName(name)
            reaper.SetProjectMarkerByIndex(0, i, isrgn, pos, rgnEnd, idx, name, color)
        -- end
    end
end

local function itemsRename()
    -- Iterate over all the items in the project and rename take name
    local items_selected = reaper.CountSelectedMediaItems(0)
    if items_selected > 0 then
        for i = 0, items_selected - 1 do
            local item = reaper.GetSelectedMediaItem(0,i)
            local take = reaper.GetActiveTake(item)
            -- local original_name = reaper.GetTakeName(take)
            local ret1, original_name = reaper.GetSetMediaItemTakeInfo_String(take,"P_NAME","",false)
            local new_name = sanitizeName(original_name)
            reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", new_name, true)
        end
    else
        reaper.MB("No items selected!","Append Metadata", 0)
    end
end

local function main()
    -- regionsRename()
    itemsRename()
end

reaper.PreventUIRefresh(1)
-- Start undo block
reaper.Undo_BeginBlock()
main()
-- End undo block
reaper.Undo_EndBlock("Remove file extensions from region names", -1)
reaper.PreventUIRefresh(-1)
reaper.UpdateArrange()
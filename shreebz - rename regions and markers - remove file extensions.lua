-- @author Dave Schreiber
-- @description Remove file extension from markers and regions
-- @version 1.0

local function removeFileExtension(str)
    return (str:gsub("%..+$", ""))
end

local function main()
    -- Iterate over all the regions in the project and collect indices of regions that need renaming
    local numMarkers = reaper.CountProjectMarkers(0) -- This includes both markers and regions
    local regionsToUpdate = {}
    for i = 0, numMarkers - 1 do
        local num, isrgn, pos, rgnEnd, name, idx, color = reaper.EnumProjectMarkers3(0, i)
        -- if isrgn then
            local name = removeFileExtension(name)
            reaper.SetProjectMarkerByIndex(0, i, isrgn, pos, rgnEnd, idx, name, color)
        -- end
    end
end

-- Start undo block
reaper.Undo_BeginBlock()
main()
-- End undo block
reaper.Undo_EndBlock("Remove file extensions from region names", -1)
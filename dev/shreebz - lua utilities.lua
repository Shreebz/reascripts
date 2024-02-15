-- @description shreebz Lua Utilities
-- @author Dave Schreiber - Shreebz
-- @version 7.1
-- @metapackage
-- @provides
--   [main] .
-- @link https://www.linkedin.com/in/david-schreiber-jr/
-- @about
--   # Lua Utilities
-- @changelog
--   # shreebz.getTrackLaneNames(track)

--[[
local shreebz_LuaUtils = reaper.GetResourcePath()..'/Scripts/shreebz scripts/dev/shreebz - lua utilities.lua'
if reaper.file_exists( shreebz_LuaUtils ) then dofile( shreebz_LuaUtils ); if not shreebz or shreebz.version() < 7.1 then shreebz.msg('This script requires a newer version of shreebz Lua Utilities. Please run:\n\nExtensions > ReaPack > Synchronize Packages',"shreebz Lua Utilities"); return end else reaper.ShowConsoleMsg("This script requires shreebz Lua Utilities! Please install them here:\n\nExtensions > ReaPack > Browse Packages > 'shreebz Lua Utilities'"); return end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~ USER CONFIG - EDIT ME ~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ CONSTANTS ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local SCRIPT_NAME = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local SCRIPT_DIR = ({reaper.get_action_context()})[2]:sub(1,({reaper.get_action_context()})[2]:find("\\[^\\]*$"))


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function main()

end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ UTILITIES ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~ MAIN ~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()
main()
reaper.Undo_EndBlock(SCRIPT_NAME,-1)
reaper.PreventUIRefresh(-1)
reaper.UpdateArrange()


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~ BACKGROUND SCRIPT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ CONSTANTS ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local SCRIPT_NAME = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local SCRIPT_DIR = ({reaper.get_action_context()})[2]:sub(1,({reaper.get_action_context()})[2]:find("\\[^\\]*$"))

local REFRESH_RATE = 0.3
local _, _, SECTION, CMD_ID = reaper.get_action_context()


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function setup()
  local start = reaper.time_precise()
  check_time = start
  
  reaper.SetToggleCommandState( SECTION, CMD_ID, 1 )
  reaper.RefreshToolbar2( SECTION, CMD_ID )
end

function main()
  local now = reaper.time_precise()
  if now - check_time >= REFRESH_RATE then

    -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    -- THIS IS WHERE YOU DO ALL OF THE ACTUAL CODE THINGS, ONCE EVERY REFRESH
    -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    check_time = now
  end

  reaper.defer(main)
end

function exit()
  reaper.UpdateArrange()
  reaper.SetToggleCommandState( SECTION, CMD_ID, 0 )
  reaper.RefreshToolbar2( SECTION, CMD_ID )
  return reaper.defer(function() end)
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ UTILITIES ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~ MAIN ~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

setup()
reaper.atexit(exit)
main()

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~ IMGUI TEMPLATE  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ CONSTANTS ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local SCRIPT_NAME = ({reaper.get_action_context()})[2]:match("([^/\\_]+)%.lua$")
local SCRIPT_DIR = ({reaper.get_action_context()})[2]:sub(1,({reaper.get_action_context()})[2]:find("\\[^\\]*$"))

local WINDOW_SIZE = { width = 300, height = 130 }
local WINDOW_FLAGS = reaper.ImGui_WindowFlags_NoCollapse()


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function init()
  ctx = reaper.ImGui_CreateContext(SCRIPT_NAME, reaper.ImGui_ConfigFlags_DockingEnable())
  reaper.ImGui_SetNextWindowSize(ctx, WINDOW_SIZE.width, WINDOW_SIZE.height)
  
  wgt = {
    
  }
end

function main()
  local rv, open = reaper.ImGui_Begin(ctx, SCRIPT_NAME, true, WINDOW_FLAGS)
  if not rv then return open end
  
  
  
  reaper.ImGui_End(ctx)
  if open then reaper.defer(main) else reaper.ImGui_DestroyContext(ctx) end
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ UTILITIES ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~ MAIN ~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
init()
main()


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

]]--

shreebz = {}

function shreebz.version()
  local file = io.open((reaper.GetResourcePath()..'/Scripts/shreebz scripts/dev/shreebz_Lua Utilities.lua'):gsub('\\','/'),"r")
  local vers_header = "-- @version "
  io.input(file)
  local t = 0
  for line in io.lines() do
    if line:find(vers_header) then
      t = line:gsub(vers_header,"")
      break
    end
  end
  io.close(file)
  return tonumber(t)
end

--[[
-- Check Reaper version
local reaper_version = tonumber(reaper.GetAppVersion():match("%d+%.%d+"))
local something = (reaper_version >= 6.33) and true or false

]]--

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~ DEBUG & MESSAGES ~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Deliver messages and add new line in console
function shreebz.dbg(...)
  local args = {...}
  local str = ""
  for i = 1, #args do
    if type(args[i]) == "table" then
      str = str .. "[" .. table.concat(args[i], ", ") .. "]" .. "\n"
    else
      str = str .. tostring(args[i]) .. "\t"
    end
  end
  reaper.ShowConsoleMsg(str .. "\n")
end

-- Deliver messages using message box
function shreebz.msg(msg, title)
  local title = title or "shreebz Info"
  reaper.MB(tostring(msg), title, 0)
end

-- Rets to bools // returns Boolean
function shreebz.retToBool(ret)
  if ret == 1 then return true else return false end
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~ GET USER INPUT ~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--[[
-- Single field
local ret_input, user_input = reaper.GetUserInputs( script_name, 1, "Input Field", "Placeholder" )
if not ret_input then return end

-- Multiple fields
local ret_input, user_input = reaper.GetUserInputs( script_name, 2,
                          "Input Field 1,Input Field 2" .. ",extrawidth=100",
                          "Placeholder 1,Placeholder 2" )
if not ret_input then return end
local input_1, input_2 = user_input:match("([^,]+),([^,]+)")
]]--


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~ IMGUI ~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function shreebz.ImGui_HelpMarker(desc, wrap_pos)
  wrap_pos = wrap_pos or 18.0
  reaper.ImGui_SameLine(ctx)
  reaper.ImGui_TextDisabled(ctx, '(?)')
  if reaper.ImGui_IsItemHovered(ctx) then
    reaper.ImGui_BeginTooltip(ctx)
    reaper.ImGui_PushTextWrapPos(ctx, reaper.ImGui_GetFontSize(ctx) * wrap_pos)
    reaper.ImGui_Text(ctx, desc)
    reaper.ImGui_PopTextWrapPos(ctx)
    reaper.ImGui_EndTooltip(ctx)
  end
end

function shreebz.ImGui_GetSetting(key, default)
  return reaper.HasExtState("shreebz_imgui", key) and reaper.GetExtState("shreebz_imgui", key) or default
end

function shreebz.ImGui_GetSettingBool(key, default)
  return shreebz.ImGui_GetSetting(key, default and "true" or "false") == "true"
end

function shreebz.ImGui_SetSetting(key, value)
  return reaper.SetExtState("shreebz_imgui", key, value, 0)
end

function shreebz.ImGui_SetSettingBool(key, value)
  return shreebz.ImGui_SetSetting(key, tostring(value))
end

-- Ripped from ReaImGui_Demo demo.HSV
function shreebz.ImGui_HSV(h, s, v, a)
  local r, g, b = reaper.ImGui_ColorConvertHSVtoRGB(h, s, v)
  return reaper.ImGui_ColorConvertDouble4ToU32(r, g, b, a or 1.0)
end

function shreebz.ImGui_Button(label, callback, color_h)
  reaper.ImGui_PushID(ctx, 0)
  reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(),        shreebz.ImGui_HSV(color_h, 0.5, 0.5, 1.0))
  reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonHovered(), shreebz.ImGui_HSV(color_h, 0.7, 0.7, 1.0))
  reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_ButtonActive(),  shreebz.ImGui_HSV(color_h, 0.8, 0.8, 1.0))
  if reaper.ImGui_Button(ctx, label) then
    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()
    callback()
    reaper.Undo_EndBlock(label, -1)
    reaper.PreventUIRefresh(-1)
    reaper.UpdateArrange()
  end
  reaper.ImGui_PopStyleColor(ctx, 3)
  reaper.ImGui_PopID(ctx)
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~ VALUE MANIPULATION ~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Check if an input string starts with another string // returns Boolean
function shreebz.stringStarts(str, start)
   return str:sub(1, #start) == start
end

-- Check if an input string ends with another string // returns Boolean
function shreebz.stringEnds(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

-- Pattern escaping gsub alternative that works with hyphens and other lua stuff // returns String
-- https://stackoverflow.com/a/29379912
function shreebz.stringReplace(str, what, with)
  what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
  with = string.gsub(with, "[%%]", "%%%%") -- escape replacement
  return string.gsub(str, what, with)
end

-- Split a string into multiple return values by a separator
-- local part1, part2, part3 = shreebz.stringSplit("blah|blah|blah", "%|", 3)
function shreebz.stringSplit(str, sep, reps)
  sep = sep and sep or ","
  if not shreebz.stringEnds(str, sep) then str = str .. sep end
  return str:match(("([^" .. sep .. "]*)" .. sep):rep(reps))
end

-- Encapsulates strings in quotes if they contain spaces
function shreebz.encapsulate(str)
  if str:find("%s") then
    str = '"' .. str .. '"'
  end
  return str
end

-- Clamp a value to given range // returns Number
function shreebz.clampValue(input,min,max)
  return math.min(math.max(input,min),max)
end

-- Scale value from range to range
function shreebz.scaleBetween(unscaled_val, min_new_range, max_new_range, min_old_range, max_old_range)
  return (max_new_range - min_new_range) * (unscaled_val - min_old_range) / (max_old_range - min_old_range) + min_new_range
end

-- Round the input value // returns Number
function shreebz.roundValue(input)
  return math.floor(input + 0.5)
end

-- Increment a number formatted as a string // returns Number
function shreebz.incrementNumStr(num)
  return tostring(tonumber(num) + 1)
end

-- Convert An Input String To Title Case // returns String
-- To use this, add the utility function then insert the line below where needed:
--> input_string = input_string:gsub("(%a)([%w_']*)", toTitleCase)
function shreebz.toTitleCase(first, rest)
  return first:upper()..rest:lower()
end

-- remove trailing and leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(programming)
function shreebz.removeLeadTrailWhitespace(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- attempts to remove _01 style enumeration from the end of strings
function shreebz.removeEnumeration(s)
  local pattern = '^(.-)%_%d+'
  return s:find(pattern) and s:match(pattern) or s
end

-- Convert seconds (w decimal) into h:mm:ss:ms
function shreebz.dispTime(time)
  local hours = math.floor((time % 86400)/3600)
  local minutes = math.floor((time % 3600)/60)
  local seconds = math.floor((time % 60))
  local milli = tostring(math.floor(time * 100)):sub(1,2)
  return string.format("%d:%02d:%02d.%02d",hours,minutes,seconds,milli)
end

-- Count number of occurrences of a substring in a string // returns Number
function shreebz.countOccurrences(base, pattern)
    return select(2, string.gsub(base, pattern, ""))
end

--https://github.com/majek/wdl/blob/master/WDL/db2val.h
function shreebz.DB2VAL(x) return math.exp((x)*0.11512925464970228420089957273422) end  

--https://github.com/majek/wdl/blob/master/WDL/db2val.h
function shreebz.VAL2DB(x, reduce)   
  if not x or x < 0.0000000298023223876953125 then return -150.0 end
  local v=math.log(x)*8.6858896380650365530225783783321
  if v<-150.0 then return -150.0 else 
    if reduce then 
      return string.format('%.2f', v)
     else 
      return v 
    end
  end
end

-- Convert a time signature string to a pair of numbers
-- local num, denom = shreebz.TimeSig_FromString("4/4")
function shreebz.TimeSig_FromString(tsig)
  local pos = tsig:find("/")
  if tsig and pos then
    return tonumber(tsig:sub(0,pos-1)), tonumber(tsig:sub(pos+1,-1))
  else
    return nil, nil
  end
end

-- Convert a time signature number pair to a string
-- local tsig = shreebz.TimeSig_ToString(4, 4)
function shreebz.TimeSig_ToString(num,denom)
  if num >= 0 and denom >= 0 then
    return tostring(num) .. "/" .. tostring(denom)
  else
    return ""
  end
end

-- Convert a time signature string to a rather arbitrary number used for sorting 
function shreebz.TimeSig_ToArbitraryNumber(tsig)
  local num, denom = shreebz.TimeSig_FromString(tsig)
  if num and denom then
    return (num + (denom * 10))
  else
    return 0
  end
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~ TABLES ~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Get length/number of entries in a table // returns Number
-- This is relatively unnecessary, as table length can just be acquired with #table
function shreebz.tableLength(table)
  local i = 0
  for _ in pairs(table) do i = i + 1 end
  return i
end

-- Check if a table contains a key // returns Boolean
function shreebz.tableContainsKey(table, key)
    return table[key] ~= nil
end

-- Check if a table contains a value in any one of its keys // returns Number or False
function shreebz.tableContainsVal(table, val)
  for index, value in ipairs(table) do
      if value == val then
          return index
      end
  end
  return false
end

-- Counts num of occurrences of a given value in a table // returns Number
function shreebz.tableCountOccurrences(table, val)
  local occurrences = 0
  for index, value in ipairs(table) do
      if value == val then
          occurrences = occurrences + 1
      end
  end
  return occurrences
end

-- Append new item to end of table
function shreebz.tableAppend(table, item)
  table[#table+1] = item
end

-- Clear all elements of a table
function shreebz.clearTable(t)
  count = #t
  for i=0, count do t[i]=nil end
end

-- CSV to Table
-- http://lua-users.org/wiki/LuaCsv
function shreebz.parseCSVLine (line,sep) 
  local res = {}
  local pos = 1
  sep = sep or ','
  while true do 
    local c = string.sub(line,pos,pos)
    if (c == "") then break end
    if (c == '"') then
      -- quoted value (ignore separator within)
      local txt = ""
      repeat
        local startp,endp = string.find(line,'^%b""',pos)
        txt = txt .. string.sub(line,startp+1,endp-1)
        pos = endp + 1
        c = string.sub(line,pos,pos) 
        if (c == '"') then txt = txt..'"' end 
        -- check first char AFTER quoted string, if it is another
        -- quoted string without separator, then append it
        -- this is the way to "escape" the quote char in a quote. example:
        --   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
      until (c ~= '"')
      table.insert(res,txt)
      assert(c == sep or c == "")
      pos = pos + 1
    else     
      -- no quotes used, just look for the first separator
      local startp,endp = string.find(line,sep,pos)
      if (startp) then 
        table.insert(res,string.sub(line,pos,startp-1))
        pos = endp + 1
      else
        -- no separator found -> use rest of string and terminate
        table.insert(res,string.sub(line,pos))
        break
      end 
    end
  end
  return res
end

-- Useful table statistics functions available at:
-- http://lua-users.org/wiki/SimpleStats

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~ ITEMS ~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--[[
-- Loop through all items
local num_items = reaper.CountMediaItems( 0 )
if num_items > 0 then
  for i=0, num_items - 1 do
    local item =  reaper.GetMediaItem( 0, i )
    local take = reaper.GetActiveTake( item )
    if take ~= nil then 
      
    end
  end
else
  shreebz.msg("Project has no items!")
end

-- Loop through selected items
local num_sel_items = reaper.CountSelectedMediaItems(0)
if num_sel_items > 0 then
  for i=0, num_sel_items - 1 do
    local item = reaper.GetSelectedMediaItem( 0, i )
    local take = reaper.GetActiveTake( item )
    if take ~= nil then 
      
    end
  end
else
  shreebz.msg("No items selected!")
end
]]--

-- Save initially selected items to table
function shreebz.saveSelectedItems(items_table)
  for i = 1, reaper.CountSelectedMediaItems(0) do
    items_table[i] = reaper.GetSelectedMediaItem(0, i-1)
  end
end

-- Restore selected items from table. Requires tableLength() above
function shreebz.restoreSelectedItems(items_table)
  reaper.Main_OnCommand(40289, 0) -- Unselect all media items
  for i = 1, shreebz.tableLength(items_table) do
    reaper.SetMediaItemSelected( items_table[i], true )
  end
end

-- Sorts a table of media items by their position in timeline order
function shreebz.sortItemTableByPos(items_table)
  local sortByPos = function(item1, item2)
    return reaper.GetMediaItemInfo_Value( item1, "D_POSITION" ) < reaper.GetMediaItemInfo_Value( item2, "D_POSITION" )
  end
  table.sort(items_table, sortByPos)
end

-- Set only item selected
function shreebz.setOnlyItemSelected(item)
  reaper.Main_OnCommand(40289,0) -- Unselect all items
  reaper.SetMediaItemSelected(item, true)
end

-- Select only tracks with selected items
function shreebz.selectTracksOfSelectedItems()
  reaper.Main_OnCommand(40297,0) -- Unselect all tracks
  local num_sel_items = reaper.CountSelectedMediaItems(0)
  if num_sel_items > 0 then
    for i=0, num_sel_items - 1 do
      reaper.SetTrackSelected(reaper.GetMediaItemTrack(reaper.GetSelectedMediaItem( 0, i )),true)
    end
  end
end

-- Get starting position of selected items // returns Number (position)
function shreebz.getStartPosSelItems()
  local position = math.huge

  -- Loop through selected items
  local num_sel_items = reaper.CountSelectedMediaItems(0)
  if num_sel_items > 0 then
    for i=0, num_sel_items - 1 do
      local item = reaper.GetSelectedMediaItem( 0, i )
      local item_start_pos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
      if item_start_pos < position then
        position = item_start_pos
      end
    end
  else
    shreebz.dbg("No items selected!")
  end

  return position
end

-- Get ending position of selected items // returns Number (position)
function shreebz.getEndPosSelItems()
  local position = 0.0

  -- Loop through selected items
  local num_sel_items = reaper.CountSelectedMediaItems(0)
  if num_sel_items > 0 then
    for i=0, num_sel_items - 1 do
      local item = reaper.GetSelectedMediaItem( 0, i )
      local item_start_pos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
      local item_end_pos = item_start_pos + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )
      if item_end_pos > position then
        position = item_end_pos
      end
    end
  else
    shreebz.dbg("No items selected!")
  end

  return position
end

-- Get source file name of active take from item input  // returns String
function shreebz.getFilenameTrackActiveTake(item)
  if item ~= nil then
    local tk = reaper.GetActiveTake(item)
    if tk ~= nil then
      local pcm_source = reaper.GetMediaItemTake_Source(tk)
      local filenamebuf = ""
      filenamebuf = reaper.GetMediaSourceFileName(pcm_source, filenamebuf)
      return filenamebuf
    end
  end
  return nil
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ TRACKS ~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--[[
-- Loop through all tracks
local num_tracks =  reaper.CountTracks( 0 )
if num_tracks > 0 then
  for i = 0, num_tracks-1 do
    local track = reaper.GetTrack(0,i)
    -- Process track
  end
else
  shreebz.msg("Project has no tracks!")
end
    
-- Loop through selected tracks
local num_sel_tracks = reaper.CountSelectedTracks( 0 )
if num_sel_tracks > 0 then
  for i = 0, num_sel_tracks-1 do
    local track = reaper.GetSelectedTrack(0,i)
    -- Process track
  end
else
  shreebz.msg("No tracks selected!")
end
]]--

-- Save initially selected tracks to table
function shreebz.saveSelectedTracks (table)
  for i = 1, reaper.CountSelectedTracks(0) do
    table[i] = reaper.GetSelectedTrack(0, i-1)
  end
end

-- Restore selected tracks from table. Requires tableLength() above
function shreebz.restoreSelectedTracks(table)
  reaper.Main_OnCommand(40297, 0) -- Unselect all tracks
  for _, track in pairs(table) do
    reaper.SetTrackSelected( track, true )
  end
end

-- Counts the maximum number of channels on a media item in the given track // returns Number
function shreebz.countTrackItemsMaxChannels(track)
  -- Loop through selected tracks, count max number of channels of an item on this track
  local track_item_max_channels = -1
  
  if reaper.CountTrackMediaItems( track ) > 0 then
  
    -- Loop through media items on track
    for i = 1, reaper.CountTrackMediaItems( track ) do
      
      local item = reaper.GetTrackMediaItem(track, i - 1)
      local take = reaper.GetActiveTake(item)
      
      -- Get active take
      if take ~= nil then
        
        -- Get source media num channels/mode
        local take_pcm = reaper.GetMediaItemTake_Source(take)
        local take_pcm_chan = reaper.GetMediaSourceNumChannels(take_pcm)
        local take_chan_mod = reaper.GetMediaItemTakeInfo_Value(take, "I_CHANMODE")
        local item_chan = -1
  
        -- Set item channel number based on take channel mode
        local item_chan = (take_chan_mod <= 1) and take_pcm_chan or 1
        
        -- Set max track channels
        track_item_max_channels = (item_chan > track_item_max_channels) and item_chan or track_item_max_channels
      end
    end
    
    --reaper.ShowConsoleMsg("MAX ITEM NUM CHANNELS: " .. track_item_max_channels)
    return track_item_max_channels
    
  else
    reaper.MB("No media items found on selected track!","",0)
    return 0
  end
end

-- Gets the shared parent track (or master track) of the selected tracks // returns MediaTrack
function shreebz.getSelectedTracksSharedParent()
  local shared_parent_track = nil
  
  -- Loop through selected tracks
  local num_sel_tracks = reaper.CountSelectedTracks( 0 )
  if num_sel_tracks > 0 then
    local start_time_sel, end_time_sel = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if num_sel_tracks == 1 then
      shared_parent_track = reaper.GetSelectedTrack(0,0)
    else
      for k = 0, num_sel_tracks-1 do
        local track = reaper.GetSelectedTrack(0,k)
        local parent_track = reaper.GetParentTrack(track)
        if not parent_track then parent_track = reaper.GetMasterTrack( 0 ) end
        if k == 0 then 
          shared_parent_track = parent_track
        else
          if reaper.GetTrackGUID(parent_track) ~= reaper.GetTrackGUID(shared_parent_track) then 
            shared_parent_track = reaper.GetMasterTrack( 0 ) 
            break
          end
        end
      end
    end
  end
  
  return shared_parent_track or reaper.GetMasterTrack( 0 )
end

-- Parses full track chunk RPPXML, returning table with lane names; nil if no lanes
function shreebz.getTrackLaneNames(track)
  local ret, track_chunk = reaper.GetTrackStateChunk(track, "",false)
  if not ret then return end
  
  local lane_name_line = ""
  for line in track_chunk:gmatch("[^\r\n]+") do
    if line:sub(1, 8) == "LANENAME" then
      lane_name_line = line
      break
    end
  end
  if lane_name_line == "" then return end
  
  local lane_names = {}
  local quote = false
  local capture = ""
  for i=1, #lane_name_line do
    local c = lane_name_line:sub(i,i)
    if c == '"' then
      quote = not quote
    elseif c == ' ' and not quote then
      if #capture > 0 then
        table.insert(lane_names, capture)
        capture = ""
      end
    else
      capture = capture .. c
    end
  end
  if #capture > 0 then
    table.insert(lane_names, capture)
  end

  -- Remove the first element ("LANENAME")
  table.remove(lane_names, 1)

  return lane_names
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ REGIONS ~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--[[
-- Loop through all regions
local ret, num_markers, num_regions = reaper.CountProjectMarkers( 0 )
local num_total = num_markers + num_regions
if num_regions > 0 then
  local i = 0
  while i < num_total do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3( 0, i )
    if isrgn then
      -- Process region
    end
    i = i + 1
  end
else
  shreebz.msg("Project has no regions!")
end
    
-- Loop through regions in time selection
local ret, num_markers, num_regions = reaper.CountProjectMarkers( 0 )
local num_total = num_markers + num_regions
local start_time_sel, end_time_sel = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
if start_time_sel ~= end_time_sel then
  local i = 0
  while i < num_total do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3( 0, i )
    if isrgn then
      if pos >= start_time_sel and rgnend <= end_time_sel then
        -- Process regions
      end
    end
    i = i + 1
  end
else
  shreebz.msg("You need to make a time selection!")
end

-- Loop through regions at edit cursor
local ret, num_markers, num_regions = reaper.CountProjectMarkers( 0 )
local num_total = num_markers + num_regions
if num_regions > 0 then
  local edit_cur_pos = reaper.GetCursorPosition()
  local i = 0
  while i < num_total do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3( 0, i )
    if isrgn and pos <= edit_cur_pos and rgnend >= edit_cur_pos then
      -- Process regions
    end
    i = i + 1
  end
else
  shreebz.msg("Project has no regions!")
end
  
]]--

-- Get selected regions in Rgn Mrkr Manager using JS_Reaper API, requires getRegionManager
-- https://github.com/ReaTeam/ReaScripts-Templates/blob/master/Regions-and-Markers/X-Raym_Get%20selected%20regions%20in%20region%20and%20marker%20manager.lua
--[[ EXAMPLE USAGE

  local sel_rgn_table = shreebz.getSelectedRegions()
  if sel_rgn_table then 
    local ret, num_markers, num_regions = reaper.CountProjectMarkers( 0 )
    local num_total = num_markers + num_regions
    
    for _, regionidx in pairs(sel_rgn_table) do 
      local i = 0
      while i < num_total do
        local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3( 0, i )
        if isrgn and markrgnindexnumber == regionidx then
          
          -- Do something with the selected regions!
          reaper.SetProjectMarkerByIndex( 0, i, isrgn, pos, rgnend, markrgnindexnumber, name, color )

          break
        end
        i = i + 1
      end
    end
  else
    shreebz.msg("No regions selected!\n\nPlease go to View > Region/Marker Manager to select regions.\n\n\nIf you are on mac... sorry but there is a bug that prevents this script from working. Out of my control :(") 
  end
  
]]--
function shreebz.getRegionManager()
  return reaper.JS_Window_Find(reaper.JS_Localize("Region/Marker Manager","common"), true) or nil
end

function shreebz.getRegionManagerList()
  return reaper.JS_Window_FindEx(shreebz.getRegionManager(), nil, "SysListView32", "") or nil
end

function shreebz.getSelectedRegions()
  local rgn_list = shreebz.getRegionManagerList()

  sel_count, sel_indexes = reaper.JS_ListView_ListAllSelItems(rgn_list)
  if sel_count == 0 then return end 

  names = {}
  i = 0
  for index in string.gmatch(sel_indexes, '[^,]+') do 
    i = i+1
    local sel_item = reaper.JS_ListView_GetItemText(rgn_list, tonumber(index), 1)
    if sel_item:find("R") ~= nil then
      names[i] = tonumber(sel_item:sub(2))
    end
  end
  
  -- Return table of selected regions
  return names
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ MARKERS ~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--[[
-- Loop through all markers
local ret, num_markers, num_regions = reaper.CountProjectMarkers( 0 )
local num_total = num_markers + num_regions
if num_markers > 0 then
  local i = 0
  while i < num_total do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3( 0, i )
    if not isrgn then
      -- Process markers
    end
    i = i + 1
  end
else
  shreebz.msg("Project has no markers!")
end
    
-- Loop through markers in time selection
local ret, num_markers, num_regions = reaper.CountProjectMarkers( 0 )
local num_total = num_markers + num_regions
local start_time_sel, end_time_sel = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
if start_time_sel ~= end_time_sel then
  local i = 0
  while i < num_total do
    local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3( 0, i )
    if not isrgn then
      if pos >= start_time_sel and pos <= end_time_sel then
        -- Process markers
      end
    end
    i = i + 1
  end
else
  shreebz.msg("You need to make a time selection!")
end
]]--

-- Get selected markers in Rgn Mrkr Manager using JS_Reaper API, requires getRegionManager
--[[ EXAMPLE USAGE

  local sel_mkr_table = getSelectedMarkers()
  if sel_mkr_table then 
    for _, mkr_idx in pairs(sel_mkr_table) do 
      shreebz.dbg(mkr_idx)
    end
  else
    shreebz.msg("No markers selected!\n\nPlease go to View > Region/Marker Manager to select regions.") 
  end
  
]]--
function shreebz.getSelectedMarkers()
  local rgn_list = shreebz.getRegionManagerList()

  sel_count, sel_indexes = reaper.JS_ListView_ListAllSelItems(rgn_list)
  if sel_count == 0 then return end 

  names = {}
  i = 0
  for index in string.gmatch(sel_indexes, '[^,]+') do 
    i = i+1
    local sel_item = reaper.JS_ListView_GetItemText(rgn_list, tonumber(index), 1)
    if sel_item:find("M") ~= nil then
      names[i] = tonumber(sel_item:sub(2))
    end
  end
  
  -- Return table of selected regions
  return names
end

function shreebz.getRegionManager()
  local title = reaper.JS_Localize("Region/Marker Manager", "common")
  local arr = reaper.new_array({}, 1024)
  reaper.JS_Window_ArrayFind(title, true, arr)
  local adr = arr.table()
  for j = 1, #adr do
    local hwnd = reaper.JS_Window_HandleFromAddress(adr[j])
    -- verify window by checking if it also has a specific child.
    if reaper.JS_Window_FindChildByID(hwnd, 1056) then -- 1045:ID of clear button
      return hwnd
    end 
  end
end

-- Save current project markers to table of marker indexes // Returns table
function shreebz.saveProjectMarkersTable()
  local ret, num_markers, num_regions = reaper.CountProjectMarkers( 0 )
  local num_total = num_markers + num_regions
  if num_markers > 0 then
    local table = {}
    local i = 0
    while i < num_total do
      local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3( 0, i )
      if not isrgn then
        table[#table+1]=markrgnindexnumber
      end
      i = i + 1
    end
    return table
  else
    return nil
  end
end

-- Save all project markers to table *WITH FULL MARKER ENUM DETAILS*
function shreebz.saveProjectMarkers(table)
  -- Loop through all markers
  local ret, num_markers, num_regions = reaper.CountProjectMarkers( 0 )
  local num_total = num_markers + num_regions
  if num_markers > 0 then
    local i = 0
    while i < num_total do
      local _, isrgn, pos, _, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3( 0, i )
      if not isrgn then
        table[#table+1] = { isrgn, pos, name, markrgnindexnumber, color }
      end
      i = i + 1
    end
  end
end

-- Wrapper for SWS action
function shreebz.deleteAllProjectMarkers()
  reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWSMARKERLIST9"), 0) -- SWS: Delete all markers
end

-- Restore project markers from table saved by shreebz.saveProjectMarkers(table)
function shreebz.restoreProjectMarkers(table)
  for i = 1, shreebz.tableLength(table) do
    mkr = table[i]
    --                 mkr = { isrgn,   pos,            name,   idx,    color }
    reaper.AddProjectMarker2(0, mkr[1], mkr[2], mkr[2], mkr[3], mkr[4], mkr[5])
  end
end

-- Add action marker by command and preview text
function shreebz.addActionMarker(mkr_cmd, mkr_text, mkr_col, pos)
  reaper.AddProjectMarker2(0, false, pos, pos, mkr_cmd, -1, mkr_col)
  reaper.AddProjectMarker2(0, false, pos, pos + 0.01, mkr_text, -1, mkr_col)
end

-- Delete action marker by command and preview text
function shreebz.deleteActionMarker(mkr_cmd, mkr_text)
  local reset = true
  while reset do
    reset = false
    local ret, num_markers, num_regions = reaper.CountProjectMarkers( 0 )
    local num_total = num_markers + num_regions
    if num_markers > 0 then
      local i = 0
      while i < num_total do
        if not reset then
          local retval, isrgn, pos, rgnend, name, markrgnindexnumber, color = reaper.EnumProjectMarkers3( 0, i )
          if not isrgn then
            if name == mkr_text or name == mkr_cmd then
              reaper.DeleteProjectMarkerByIndex(0, i)
              reset = true
            end
          end
        end
        i = i + 1
      end
    end
  end
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~  VIDEO  ~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--[[      DEMO OF VIDEO PROCESSOR TEXT ITEM FUNCTIONS

MediaItem=reaper.GetSelectedMediaItem(0,0)
SuccessfulOrNot, VideoProcessorText=GetTextInVideoProcessor(MediaItem)
reaper.ShowConsoleMsg("Original Text: " .. VideoProcessorText)

SuccessfulOrNot, MsgInCaseOfError=SetTextInVideoProcessor(MediaItem, "Hello Mother")
reaper.ShowConsoleMsg("New Text: " .. tostring(SuccessfulOrNot) .. MsgInCaseOfError)

]]--

function shreebz.SetTextInVideoProcessor(item, text)
  -- sets the videotext in a given item in it's first(!) Video Processor in the FXChain.
  -- the Video Processor must be set to the built-in "Title text overlay"-preset!
  -- multiline-texts are allowed
  
  --   item - a MediaItem object as returned by reaper.GetMediaItem
  --   text - the text, that you want to set. Write \n to include a newline.
  -- The function returns retval, errormessage
  --     retval - true, in case of success; false, in case of an error
  --     errormessage - in case of an error, this message gives you a hint, what went wrong.

  -- Meo Mespotine - mespotine.de
  -- licensed under an MIT-license
  
  if reaper.ValidatePtr2(0, item, "MediaItem*")==false then return false, "No valid MediaItem" end
  if type(text)~="string" then return false, "Must be a string" end
  local _bool, StateChunk=reaper.GetItemStateChunk(item, "", false)
  if StateChunk:match("VIDEO_EFFECT")==nil then return false, "No Video Processor found in this item" end
  local part1, code, part2=StateChunk:match("(.-)(<TAKEFX.-\n>)(\nCODEPARM.*)")
  
  if code:match("// Text overlay")==nil then return false, "Only default preset \"Title text overlay\" supported. Please select accordingly." 
  else 
    local c1,test,c3=code:match("(.-text=\")(.-)(\".*)") 
    text=string.gsub(text, "\n", "\\n")
    code=c1..text..c3
  end
  StateChunk=part1..code..part2
  return reaper.SetItemStateChunk(item, StateChunk, false), "Done"
end

function shreebz.GetTextInVideoProcessor(item)
  -- gets the videotext in a given item in it's first(!) Video Processor in the FXChain.
  -- the Video Processor must be set to the built-in "Title text overlay"-preset!
  -- multiline-texts are allowed


  --   item - a MediaItem object as returned by reaper.GetMediaItem
  -- The function returns retval, errormessage, textinvideoitem
  --     retval - true, in case of success; false, in case of an error
  --     errormessage - in case of an error, this message gives you a hint, what went wrong.
  --     textinvideoitem - the text, that is currently set in videoitem

  -- Meo Mespotine - mespotine.de
  -- licensed under an MIT-license
  
  if reaper.ValidatePtr2(0, item, "MediaItem*")==false then return false, "No valid MediaItem" end
  local _bool, StateChunk=reaper.GetItemStateChunk(item, "", false)
  if StateChunk:match("VIDEO_EFFECT")==nil then return false, "No Video Processor found in this item" end
  local part1, code, part2=StateChunk:match("(.-)(<TAKEFX.-\n>)(\nCODEPARM.*)")
  --reaper.ShowConsoleMsg(code)
  if code:match("// Text overlay")==nil then return false, "Only default preset \"Title text overlay\" supported. Please select accordingly." 
  else 
    local c1,test,c3=code:match("(.-text=\")(.-)(\".*)") 
    test=string.gsub(test, "\\n", "\n")
    return true, test
  end
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~ TIME SEL ~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Save original time/loop selection
function shreebz.saveLoopTimesel()
  init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)
  init_start_loop, init_end_loop = reaper.GetSet_LoopTimeRange(0, 1, 0, 0, 0)
end

-- Restore original time/loop selection
function shreebz.restoreLoopTimesel()
  reaper.GetSet_LoopTimeRange(1, 0, init_start_timesel, init_end_timesel, 0)
  reaper.GetSet_LoopTimeRange(1, 1, init_start_loop, init_end_loop, 0)
end

-- Save original cursor position
function shreebz.saveCursorPos()
  init_cur_pos = reaper.GetCursorPosition()
end

-- Restore original cursor position
function shreebz.restoreCursorPos()
  reaper.SetEditCurPos(init_cur_pos,false,false)
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~ SCRIPT NAME ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Get number from anywhere in a script name // returns Number
function shreebz.extractNumberInScriptName(script_name)
  return tonumber(string.match(script_name, "%d+"))
end

-- Get text field from end of script name, formatted like "shreebz_Blah blah blah-FIELD.lua" // returns String
function shreebz.extractFieldScriptName(script_name)
  return string.sub( script_name, string.find(script_name, "-") + 1, string.len(script_name))
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~ COLORS ~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Convert RGB value to int for Reaper native colors, i.e. region coloring // returns Number
function shreebz.rgb2int ( R, G, B )
  return (R + 256 * G + 65536 * B)|16777216
end

-- Get SWS custom color using a temp track // returns Number (os-dependent color)
-- color_index = 1 - 16 for SWS custom color #
function shreebz.getSWSCustomColor(color_index)
  local init_sel_trks = {}
  shreebz.saveSelectedTracks(init_sel_trks)
  
  -- Insert temp track
  local temp_trk_idx = reaper.CountTracks(0)
  reaper.InsertTrackAtIndex(temp_trk_idx,false)
  local temp_trk = reaper.GetTrack(0, temp_trk_idx)
  reaper.SetOnlyTrackSelected(temp_trk)
  
  -- Set/get SWS color
  reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_TRACKCUSTCOL" .. tostring(color_index)),0) -- SWS: Set selected track(s) to custom color *color_index*
  local cust_color = reaper.GetTrackColor(temp_trk)
  
  -- Delete temp track
  reaper.DeleteTrack(temp_trk)
  
  shreebz.restoreSelectedTracks(init_sel_trks)
  return cust_color
end



-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ FILE MGMT ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Check if a file exists // returns Boolean
function shreebz.fileExists(filename)
   return reaper.file_exists(filename)
end

-- Check if a directory/folder exists. // returns Boolean
function shreebz.directoryExists(folder)
  local fileHandle, strError = io.open(folder .. "\\*.*","r")
  if fileHandle ~= nil then
    io.close(fileHandle)
    return true
  else
    if string.match(strError,"No such file or directory") then
      return false
    else
      return true
    end
  end
end

--[[
-- Loop through the files in a directory
local fil_idx = 0
repeat
   local dir_file = reaper.EnumerateFiles( directory, fil_idx )
   -- Do stuff to the dir_files
   shreebz.dbg(dir_file)
   
   fil_idx = fil_idx + 1
until not reaper.EnumerateFiles( directory, fil_idx )

-- Loop through subdirectories in a directory
local dir_idx = 0
repeat
  local sub_dir = reaper.EnumerateSubdirectories( directory, dir_idx)
  -- Do stuff to the sub_dirs
  shreebz.dbg(sub_dir)
  
  dir_idx = dir_idx + 1
until not  reaper.EnumerateSubdirectories( directory, dir_idx )
]]---

-- Count the number of files in a directory
function shreebz.countFilesDirectory(directory)
  if directoryExists(directory) then
    local file_count = 0
    repeat file_count = file_count + 1 until not reaper.EnumerateFiles( directory, file_count )
    return file_count
  else
    return 0
  end
end

-- Get project directory (folder) // returns String
function shreebz.getProjDir()
  if reaper.GetOS() == "Win32" or reaper.GetOS() == "Win64" then
    separator = "\\"
  else
    separator = "/"
  end
  retval, project_path_name = reaper.EnumProjects(-1, "")
  if project_path_name ~= "" then
    dir = project_path_name:match("(.*" .. separator ..")")
    return dir
  else
    return ""
  end
end

-- Open a webpage or file directory
function shreebz.openDirectoryOrURL(path)
  reaper.CF_ShellExecute(path)
end

-- Get 3 character all caps extension from a file path input // returns String
function shreebz.fileExtension(filename)
  return filename:sub(-3):upper()
end

-- More legit ways to get file info
-- TODO: Confirm that this didn't break other scripts after using .getOS() for separator
function shreebz.getFileName(filename)
  local _, sep = shreebz.getOS()
  return filename:match("^.+" .. sep .. "(.+)$")
end

function shreebz.getFileExtension(filename)
  return filename:match("^.+(%..+)$")
end

-- On Windows, this will return: "C:\"
function shreebz.getRootDirectory(filename)
  local win = string.find(reaper.GetOS(), "Win") ~= nil
  local sep = win and '\\' or '/'
  return filename:sub(1,filename:find(sep))
end

-- Convert file input to table, each line = new entry // returns Table
function shreebz.fileToTable(filename)
  local file = io.open(filename)
  io.input(file)
  local t = {}
  for line in io.lines() do
    table.insert(t, line)
  end
  table.insert(t, "")
  io.close(file)
  return t
end

-- Convert table input to file, each entry = new line
function shreebz.tableToFile(  tbl,filename )
  -- declare local variables
  --// exportstring( string )
  --// returns a "Lua" portable version of the string
  local function exportstring( s )
    return string.format("%q", s)
  end
  
  local charS,charE = "   ","\n"
  local file,err = io.open( filename, "wb" )
  if err then return err end

  -- initiate variables for save procedure
  local tables,lookup = { tbl },{ [tbl] = 1 }
  file:write( "return {"..charE )

  for idx,t in ipairs( tables ) do
     file:write( "-- Table: {"..idx.."}"..charE )
     file:write( "{"..charE )
     local thandled = {}

     for i,v in ipairs( t ) do
        thandled[i] = true
        local stype = type( v )
        -- only handle value
        if stype == "table" then
           if not lookup[v] then
              table.insert( tables, v )
              lookup[v] = #tables
           end
           file:write( charS.."{"..lookup[v].."},"..charE )
        elseif stype == "string" then
           file:write(  charS..exportstring( v )..","..charE )
        elseif stype == "number" then
           file:write(  charS..tostring( v )..","..charE )
        end
     end

     for i,v in pairs( t ) do
        -- escape handled values
        if (not thandled[i]) then
        
           local str = ""
           local stype = type( i )
           -- handle index
           if stype == "table" then
              if not lookup[i] then
                 table.insert( tables,i )
                 lookup[i] = #tables
              end
              str = charS.."[{"..lookup[i].."}]="
           elseif stype == "string" then
              str = charS.."["..exportstring( i ).."]="
           elseif stype == "number" then
              str = charS.."["..tostring( i ).."]="
           end
        
           if str ~= "" then
              stype = type( v )
              -- handle value
              if stype == "table" then
                 if not lookup[v] then
                    table.insert( tables,v )
                    lookup[v] = #tables
                 end
                 file:write( str.."{"..lookup[v].."},"..charE )
              elseif stype == "string" then
                 file:write( str..exportstring( v )..","..charE )
              elseif stype == "number" then
                 file:write( str..tostring( v )..","..charE )
              end
           end
        end
     end
     file:write( "},"..charE )
  end
  file:write( "}" )
  file:close()
end

-- Get web interface info from REAPER.ini // returns Table
function shreebz.getWebInterfaceSettings()
  local ini_file = reaper.get_ini_file()
  local ret, num_webs = reaper.BR_Win32_GetPrivateProfileString( "reaper", "csurf_cnt", "", ini_file )
  local t = {}
  if ret then
    for i = 0, num_webs do
      local ret, web_int = reaper.BR_Win32_GetPrivateProfileString( "reaper", "csurf_" .. i, "", ini_file )
      table.insert(t, web_int)
    end
  end
  return t
end

-- Get localhost port from reaper.ini web interface file line. Works best with getWebInterfaceSettings()// returns String
function shreebz.getPort(line)
  local port = line:sub(line:find(" ")+3,line:find("'")-2)
  return port
end

-- Prompt user to locate folder in system // returns String (or nil if cancelled)
function shreebz.promptForFolder(message)
  local ret, folder = reaper.JS_Dialog_BrowseForFolder( message, "" )
  if ret == 1 then
    -- Folder found
    local win, sep = shreebz.getOS()
    if not shreebz.stringEnds(folder, sep) then folder = folder .. sep end
    return folder
  elseif ret == 0 then
    -- Folder selection cancelled
    return nil
  else 
    -- Folder picking error
    shreebz.msg("Something went wrong... Please try again!","Folder picker error")
    shreebz.promptForFolder(message)
  end
end

-- Gets current platform and separator
-- USE THIS IN YOUR SCRIPTS:
-- local win, sep = shreebz.getOS()
function shreebz.getOS()
  local win = string.find(reaper.GetOS(), "Win") ~= nil
  local sep = win and '\\' or '/'
  return win, sep
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~ RENDERING ~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Render settings are bitwise. For example:
-- if input & shreebz.RENDER_SETTINGS.USE_RENDER_MATRIX == shreebz.RENDER_SETTINGS.USE_RENDER_MATRIX then
shreebz.RENDER_SETTINGS = {
  MASTER_MIX = 0,
  STEMS_MASTER_MIX = 1,
  STEMS_ONLY = 2,
  MULTICHANNEL_TRACKS = 4,
  USE_RENDER_MATRIX = 8,
  MONO_MEDIA_TO_MONO_FILES = 16,
  SELECTED_MEDIA_ITEMS = 32,
  SELECTED_MEDIA_ITEMS_MASTER = 64,
  SELECTED_TRACKS_MASTER = 128,
  STRETCH_MARKERS = 256,
  EMBED_METADATA = 512,
  TAKE_MARKERS = 1024,
  SECOND_PASS_RENDER = 2048
}

-- Render bounds are just regular numbers, no need for bitwise comparison
shreebz.RENDER_BOUNDSFLAG = {
  CUSTOM_TIME_BOUNDS = 0,
  ENTIRE_PROJECT = 1,
  TIME_SELECTION = 2,
  ALL_PROJECT_REGIONS = 3,
  SELECTED_MEDIA_ITEMS = 4,
  SELECTED_PROJECT_REGIONS = 5,
  ALL_PROJECT_MARKERS = 6,
  SELECTED_PROJECT_MARKERS = 7
}

-- Get/Set render settings to/from table
function shreebz.getRenderSettings()
  local t = {}
  t.rendersettings   = reaper.GetSetProjectInfo(0, "RENDER_SETTINGS", -1, false)            -- Master mix, stems, etc
  t.boundsflag       = reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", -1, false)          -- Time selection, project, etc
  t._, t.renderformat    = reaper.GetSetProjectInfo_String(0, 'RENDER_FORMAT', "", false)   -- File format, i.e. "ewav"
  t._, t.renderdirectory = reaper.GetSetProjectInfo_String(0, "RENDER_FILE", "", false)     -- C:\users\aaron\docs\blah
  t._, t.renderfilename  = reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", "", false)  -- $item_$itemnumber_JU20
  return t
end

function shreebz.setRenderSettings(t)
  reaper.GetSetProjectInfo(0, "RENDER_SETTINGS", t.rendersettings, true)
  reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", t.boundsflag, true)
  reaper.GetSetProjectInfo_String(0, 'RENDER_FORMAT', t.renderformat, true)
  reaper.GetSetProjectInfo_String(0, "RENDER_FILE", t.renderdirectory, true)
  reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", t.renderfilename, true)
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~ MEDIA EXPLORER ~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Returns hWnd for media explorer window
function shreebz.getMediaExplorer()
  return reaper.JS_Window_Find(reaper.JS_Localize("Media Explorer","common"), true) or nil
end

-- Returns list view hWnd for media explorer's file list
function shreebz.getMediaExplorerList()
  return reaper.JS_Window_FindEx(shreebz.getMediaExplorer(), nil, "SysListView32", "") or nil
end

-- Count selected items media explorer // returns Number
function shreebz.countSelectedItemsMediaExplorer()
  local hWnd = shreebz.getMediaExplorer()
  if hWnd == nil then msg("Unable to find media explorer. Try going to:\n\nExtensions > ReaPack > Browse Packages\n\nand re-installing the JS_Reascript extension.") return end  

  local file_LV = shreebz.getMediaExplorerList()
  
  sel_count, sel_indexes = reaper.JS_ListView_ListAllSelItems(file_LV)
  return sel_count
end

-- Get selected item details media explorer
function shreebz.getSelectedItemsDetailsMediaExplorer()
  local hWnd = shreebz.getMediaExplorer()
  if hWnd == nil then shreebz.msg("Unable to find media explorer. Try going to:\n\nExtensions > ReaPack > Browse Packages\n\nand re-installing the JS_Reascript extension.","Media Explorer Items") return end  

  local file_LV = shreebz.getMediaExplorerList()
  
  sel_count, sel_indexes = reaper.JS_ListView_ListAllSelItems(file_LV)
  if sel_count == 0 then shreebz.msg("No items selected in media explorer!","Media Explorer Items") return end

  for ndx in string.gmatch(sel_indexes, '[^,]+') do 
    index = tonumber(ndx)
    local fname = reaper.JS_ListView_GetItemText(file_LV, index, 0)
    local size = reaper.JS_ListView_GetItemText(file_LV, index, 1)
    local date = reaper.JS_ListView_GetItemText(file_LV, index, 2)
    local ftype = reaper.JS_ListView_GetItemText(file_LV, index, 3)
    shreebz.dbg(fname .. ', ' .. size .. ', ' .. date .. ', ' .. ftype) 
  end
  
  -- Get selected path  from edit control inside combobox
  local combo = reaper.JS_Window_FindChildByID(hWnd, 1002)
  local edit = reaper.JS_Window_FindChildByID(combo, 1001)
  local path = reaper.JS_Window_GetTitle(edit, "", 255)
  shreebz.dbg(path)

end

-- Filter Media Explorer for files
function shreebz.filterMediaExplorer(search)
  if reaper.APIExists("JS_Window_Find") then
    local IDC_SEARCH = 0x3f7
    local WM_COMMAND = 0x111
    local CBN_EDITCHANGE = 5
    
    local mediaExplorer = reaper.OpenMediaExplorer( "", false )
    local winHWND = shreebz.getMediaExplorer()
    local mediaExpFilter =  reaper.JS_Window_FindChildByID( winHWND, 1015 )
    local filtered = reaper.JS_Window_SetTitle(mediaExpFilter,search)
    reaper.BR_Win32_SendMessage(mediaExplorer, WM_COMMAND, (CBN_EDITCHANGE<<16) | IDC_SEARCH, 0)
  else
    shreebz.msg("This script requires the JS Reascript API. Please install it via ReaPack.\n\nExtensions > ReaPack > Browse Packages > js_ReaScriptAPI: API functions for ReaScripts","Missing JS ReaScript API")  
  end
end


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~ ACTIONS LIST ~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Filter actions list for scripts or search term
function shreebz.filterActionsList(search)
  if reaper.APIExists("JS_Window_Find")then;
    reaper.ShowActionList();
    local winHWND = reaper.JS_Window_Find(reaper.JS_Localize("Actions", "common"),true);
    local filter_Act = reaper.JS_Window_FindChildByID(winHWND,1324);
    reaper.JS_Window_SetTitle(filter_Act,search);
  else
    reaper.MB("This script requires the JS Reascript API. Please install it via ReaPack.\n\nExtensions > ReaPack > Browse Packages > js_ReaScriptAPI: API functions for ReaScripts","Missing JS ReaScript API", 0)  
  end
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~ REAPACK ~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Open ReaPack About page for this script
function shreebz.help()
  if not reaper.ReaPack_GetOwner then
    reaper.MB('This feature requires ReaPack v1.2 or newer.', script_name, 0)
    return
  end
  local owner = reaper.ReaPack_GetOwner(({reaper.get_action_context()})[2])
  if not owner then
    reaper.MB(string.format(
      'This feature is unavailable because "%s" was not installed using ReaPack.',
      script_name), script_name, 0)
    return
  end
  reaper.ReaPack_AboutInstalledPackage(owner)
  reaper.ReaPack_FreeEntry(owner)
end

--[[
-- Check for JS_ReaScript Extension
if reaper.JS_Dialog_BrowseForSaveFile then

else
  shreebz.msg("Please install the JS_ReaScriptAPI REAPER extension, available in ReaPack, under the ReaTeam Extensions repository.\n\nExtensions > ReaPack > Browse Packages\n\nFilter for 'JS_ReascriptAPI'. Right click to install.")
end
]]--

-- Looks for JSFX by name in Effects/shreebz Scripts/JSFX/      \\ Returns boolean
function shreebz.checkForJSFX(jsfx_name)
  if not jsfx_name:find(".jsfx") then jsfx_name = jsfx_name .. ".jsfx" end
  
  if reaper.file_exists( reaper.GetResourcePath() .. "\\Effects\\shreebz Scripts\\JSFX\\" .. jsfx_name ) then
    return true
  else
    return false
  end
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

return shreebz

function copy_item()
  reaper.ClearConsole()
  local track = reaper.GetLastTouchedTrack()
  --local track = reaper.GetTrack(0, 0)
  itemcount = reaper.CountTrackMediaItems(track)
  reaper.ShowConsoleMsg("Items in track: "..itemcount.."\n")
  for i=0, itemcount-1 do
    item = reaper.GetTrackMediaItem(track, i)
    reaper.ShowConsoleMsg("ITEM: #"..i.."\n")
    reaper.SetMediaItemSelected(item, false)
  end
  local last_item = reaper.GetTrackMediaItem(track, itemcount-1)
  reaper.SetMediaItemSelected(last_item, true)
  local pos = reaper.GetMediaItemInfo_Value(last_item, "D_POSITION" )
  local length = reaper.GetMediaItemInfo_Value(last_item, "D_LENGTH" )
  reaper.ShowConsoleMsg("POSITION: "..pos.."\n")
  reaper.ShowConsoleMsg("LENGTH: "..length.."\n")
  reaper.Main_OnCommand(40698, 0)
  reaper.SetEditCurPos2(0, pos + length, 0, 0)
  reaper.Main_OnCommand(40058, 0)
  --reaper.Main_OnCommand(41072, 0) --COPY POOLE
  reaper.UpdateArrange()
end

function create_item()
  local track = reaper.GetLastTouchedTrack()
  local ppos = reaper.GetCursorPosition()
  local item = reaper.CreateNewMIDIItemInProj(track, ppos, ppos + 2)
  local take =  reaper.GetMediaItemTake( item, 0 )
end

function toBits(num,bits)
    -- returns a table of bits, most significant first.
    bits = bits or math.max(1, select(2, math.frexp(num)))
    local t = {} -- will contain the bits        
    for b = bits, 1, -1 do
        t[b] = math.fmod(num, 2)
        num = math.floor((num - t[b]) / 2)
    end
    return table.concat(t)
end

function item_state()
  reaper.ClearConsole()
  local track = reaper.GetLastTouchedTrack()
  local item = reaper.GetTrackMediaItem(track, 0)
  --local ret, chunk = reaper.GetItemStateChunk(item, "")
  local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION" )
  local item_length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH" )
  local tk = reaper.GetActiveTake(item)
  reaper.MIDI_Sort( tk )
  local ret, buf = reaper.MIDI_GetAllEvts(tk)
  local i = 0
  local ppq_pos = 0
  local pos = 1
  while pos < #buf do
    offset, flags, msg, pos = string.unpack("i4Bs4", buf, pos)
    ppq_pos = ppq_pos + offset
    local qn = reaper.MIDI_GetProjQNFromPPQPos(tk, ppq_pos)
    local evt_str = "EVT: "..string.format("%-4s",i)
    local qn_str = "offset: "..string.format("%-7.3f", qn)
    local flags_str = "flags: "..string.format("%-3s", tostring(flags))
    local midi1_str = "msg[1]: "..string.format("%-5s", tostring(msg:byte(1)))
    local midi2_str = "msg[2]: "..string.format("%-5s", tostring(msg:byte(2)))
    local midi3_str = "msg[3]: "..string.format("%-5s", tostring(msg:byte(3)))
    reaper.ShowConsoleMsg(evt_str..qn_str..flags_str..midi1_str..midi2_str..midi3_str.."\n")
    --reaper.ShowConsoleMsg("EVT #"..i..": offset: "..offset.."("..qn.."), flags: "..tostring(flags)..", msg[1]: "..tostring(msg:byte(1))..", msg[2]: "..tostring(msg:byte(2))..", msg[3]: "..tostring(msg:byte(3)).."\n")
    i = i +1
  end
end
--copy_item()
--create_item()
item_state()

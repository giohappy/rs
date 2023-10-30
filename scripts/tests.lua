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

function item_state()
  local track = reaper.GetLastTouchedTrack()
  local item = reaper.GetTrackMediaItem(track, 0)
  local ret, chunk = reaper.GetItemStateChunk(item, "")
  reaper.ClearConsole()
  reaper.ShowConsoleMsg(chunk)
end
--copy_item()
--create_item()
item_state()

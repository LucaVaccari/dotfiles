----------------ICIO POULHOI - Set Color Gradient to Children tracks starting from parent color---------v1.0------
----------------?:^) written by 80icio & poulhoi -----------------------------------------------------------------
---------------- sws extensions needed!!!!------------------------------------------------------------------------
local selchildren = reaper.NamedCommandLookup("_SWS_SELCHILDREN")
local colchildren = reaper.NamedCommandLookup("_SWS_COLCHILDREN")
local itemtotrkcolor = reaper.NamedCommandLookup("_SWS_ITEMTRKCOL")

---Gradient Step ---- positive numbers will gradient to white // negative numbers will gradient to black
local gradientstep = -10 ---- 0 = no gradient 
local coloritem = true -----if true = force to color items/takes with track color

function main()
reaper.Main_OnCommandEx(colchildren, 0, 0)
reaper.Main_OnCommandEx(selchildren, 0, 0)
local trackCount = reaper.CountSelectedTracks(0)
local gradientstep =  math.ceil((gradientstep*10)/(trackCount+1)) ----dependent on track count
 for i = 0, trackCount - 2, 1 do
    local track = reaper.GetSelectedTrack(0, i)
    local nexttrack = reaper.GetSelectedTrack(0, i+1)
    local prevColorNative = reaper.GetTrackColor(track)
    local prevColorR, prevColorG, prevColorB = reaper.ColorFromNative(prevColorNative)
    if prevColorR + gradientstep < 0 then prevColorR = 0 else prevColorR = prevColorR + gradientstep end
    if prevColorG + gradientstep < 0 then prevColorG = 0 else prevColorG = prevColorG + gradientstep end
    if prevColorB + gradientstep < 0 then prevColorB = 0 else prevColorB = prevColorB + gradientstep end
    local newColorR = math.min(prevColorR, 255)
    local newColorG = math.min(prevColorG, 255)
    local newColorB = math.min(prevColorB, 255)
    local newColorNative = reaper.ColorToNative(newColorR, newColorG, newColorB)
    reaper.SetTrackColor(nexttrack, newColorNative)
    
  end
 if coloritem == true then
  reaper.Main_OnCommandEx(40718, 0, 0)
  reaper.Main_OnCommandEx(itemtotrkcolor, 0, 0)
  end
end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)
main()
reaper.Main_OnCommandEx(40769, 0, 0)
reaper.PreventUIRefresh(-1)
reaper.Undo_EndBlock( "folder Color Gradient", 0)

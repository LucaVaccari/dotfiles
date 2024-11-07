-- Start script: Gridbox
local grid_box_cmd_name = '_RS02de4a63cf12c72510b6da7254c3f3df05dba45c'
reaper.Main_OnCommand(reaper.NamedCommandLookup(grid_box_cmd_name), 0)

-- Start script: REAPER Update Utility (check for new versions)
local update_utility_cmd = '_RS852f0872789b997921f7f9d40e6f997553bd5147'
reaper.Main_OnCommand(reaper.NamedCommandLookup(update_utility_cmd), 0)

-- Start script: Lil Chordbox
local chord_box_cmd_name = '_RSff0957acd908ac1a809c8b9aa70a0aa73d2ce162'
reaper.Main_OnCommand(reaper.NamedCommandLookup(chord_box_cmd_name), 0)


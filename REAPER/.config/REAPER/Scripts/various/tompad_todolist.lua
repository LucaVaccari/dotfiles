--[[
 * ReaScript Name: tompad_ToDoList
 * Description: A script to save notes on what to do in a project.
 * Instructions: Run.
 * Author: TompaD
 * Author URI:
 * Repository: tompad_ToDoList
 * Repository URI: https://bitbucket.org/TompaD/tompad_todolist/
 * File URI: https://bitbucket.org/TompaD/tompad_todolist/src/master/tompad_ToDoList.lua
 * Licence: GPL v3
 * Forum Thread:
 * Forum Thread URI:
 * REAPER: 5.0
 * Extensions: None
 * Version: 0.0.1
--]]

-- Script generated by Lokasenna's GUI Builder MASTER!

local lib_path = reaper.GetExtState("Lokasenna_GUI", "lib_path_v2")
if not lib_path or lib_path == "" then
  reaper.MB("Couldn't load the Lokasenna_GUI library. Please run 'Set Lokasenna_GUI v2 library path.lua' in the Lokasenna_GUI folder.", "Whoops!", 0)
  return
end
loadfile(lib_path .. "Core.lua")()

GUI.req("Classes/Class - Label.lua")()
GUI.req("Classes/Class - Listbox.lua")()
GUI.req("Classes/Class - Frame.lua")()
GUI.req("Classes/Class - Button.lua")()
GUI.req("Classes/Class - TextEditor.lua")()
GUI.req("Classes/Class - Textbox.lua")()
GUI.req("Classes/Class - Menubox.lua")()
GUI.req("Classes/Class - Window.lua")()
GUI.req("Modules/Window - GetUserInputs.lua")()
-- If any of the requested libraries weren't found, abort the script.
if missing_lib then return 0 end

--[[
   Save Table to File
   Load Table from File
   v 1.0

   Lua 5.2 compatible

   Only Saves Tables, Numbers and Strings
   Insides Table References are saved
   Does not save Userdata, Metatables, Functions and indices of these
   ----------------------------------------------------
   table.save( table , filename )

   on failure: returns an error msg

   ----------------------------------------------------
   table.load( filename or stringtable )

   Loads a table that has been saved via the table.save function

   on success: returns a previously saved table
   on failure: returns as second argument an error msg
   ----------------------------------------------------

   Licensed under the same terms as Lua itself.
]]--
do
  -- declare local variables
  --// exportstring( string )
  --// returns a "Lua" portable version of the string
  local function exportstring( s )
    return string.format("%q", s)
  end

  --// The Save Function
  function table.save( tbl, filename )
    local charS, charE = "   ", "\n"
    local file, err = io.open( filename, "wb" )
    if err then return err end

    -- initiate variables for save procedure
    local tables, lookup = { tbl }, { [tbl] = 1 }
    file:write( "return {"..charE )

    for idx, t in ipairs( tables ) do
      file:write( "-- Table: {"..idx.."}"..charE )
      file:write( "{"..charE )
      local thandled = {}

      for i, v in ipairs( t ) do
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
          file:write( charS..exportstring( v )..","..charE )
        elseif stype == "number" then
          file:write( charS..tostring( v )..","..charE )
        end
      end

      for i, v in pairs( t ) do
        -- escape handled values
        if (not thandled[i]) then

          local str = ""
          local stype = type( i )
          -- handle index
          if stype == "table" then
            if not lookup[i] then
              table.insert( tables, i )
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
                table.insert( tables, v )
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

  --// The Load Function
  function table.load( sfile )
    local ftables, err = loadfile( sfile )
    if err then return _, err end
    local tables = ftables()
    for idx = 1, #tables do
      local tolinki = {}
      for i, v in pairs( tables[idx] ) do
        if type( v ) == "table" then
          tables[idx][i] = tables[v[1]]
        end
        if type( i ) == "table" and tables[i[1]] then
          table.insert( tolinki, { i, tables[i[1]] } )
        end
      end
      -- link indices
      for _, v in ipairs( tolinki ) do
        tables[idx][v[2]], tables[idx][v[1]] = tables[idx][v[1]], nil
      end
    end
    return tables[1]
  end
  -- close do
end


-- Get the project's path, so we can save the data in the same place
project_path = reaper.GetProjectPath(0) .. "/"

local versionNr = "v1.0"
local tasks = {}
local items = table.load(project_path .. "/" .. "todolist.txt" )
------------------------------------
-------- Window settings -----------
------------------------------------
GUI.name = "ToDoList" .. " " .. versionNr
GUI.x, GUI.y, GUI.w, GUI.h = 0, 0, 536, 272
GUI.anchor, GUI.corner = "screen", "C"

------------------------------------
-------- GUI Elements --------------
------------------------------------

GUI.New("Label1", "Label", {
  z = 11,
  x = 8,
  y = 8,
  caption = "Tasks",
  font = 2,
  color = "txt",
  bg = "wnd_bg",
  shadow = false
})

GUI.New("lst_tasks", "Listbox", {
  z = 11,
  x = 8,
  y = 32,
  w = 256,
  h = 200,
  list = tasks,
  multi = false,
  caption = "",
  font_a = 3,
  font_b = "monospace",
  --font_b = 4,
  color = "txt",
  col_fill = "elm_fill",
  bg = "elm_bg",
  cap_bg = "wnd_bg",
  shadow = true,
  --pad = 4
})

GUI.New("Label2", "Label", {
  z = 11,
  x = 272,
  y = 8,
  caption = "Details",
  font = 2,
  color = "txt",
  bg = "wnd_bg",
  shadow = false
})

GUI.New("frm_details", "Frame", {
  z = 11,
  x = 272,
  y = 32,
  w = 256,
  h = 200,
  shadow = false,
  fill = false,
  color = "elm_frame",
  bg = "wnd_bg",
  round = 0,
  text = "",
  txt_indent = 0,
  txt_pad = 0,
  --pad = 4,
  font = 4,
  col_txt = "txt"
})

GUI.New("btn_new", "Button", {
  z = 11,
  x = 8,
  y = 240,
  w = 60,
  h = 24,
  caption = "New",
  font = 3,
  col_txt = "txt",
  col_fill = "elm_frame"
})

GUI.New("btn_edit", "Button", {
  z = 11,
  x = 72,
  y = 240,
  w = 60,
  h = 24,
  caption = "Edit",
  font = 3,
  col_txt = "txt",
  col_fill = "elm_frame",
})

GUI.New("btn_done", "Button", {
  z = 11,
  x = 136,
  y = 240,
  w = 60,
  h = 24,
  caption = "Done",
  font = 3,
  col_txt = "txt",
  col_fill = "elm_frame"
})

GUI.New("btn_delete", "Button", {
  z = 11,
  x = 200,
  y = 240,
  w = 60,
  h = 24,
  caption = "Delete",
  font = 3,
  col_txt = "txt",
  col_fill = "elm_frame"
})

-------The other "window"---------
----------------------------------
----------------------------------
GUI.New("txtbox_caption_tasks", "Textbox", {
  z = 5,
  x = 8,
  y = 32,
  w = 250,
  h = 20,
  caption = "",
  cap_pos = "left",
  font_a = 3,
  font_b = "monospace",
  color = "txt",
  bg = "wnd_bg",
  shadow = true,
  pad = 4,
  undo_limit = 20,
})

GUI.New("txt_editor_tasks", "TextEditor", {
  z = 5,
  x = 272,
  y = 32,
  w = 256,
  h = 200,
  caption = "",
  font_a = 3,
  font_b = "monospace",
  color = "txt",
  col_fill = "elm_fill",
  cap_bg = "wnd_bg",
  bg = "elm_bg",
  shadow = true,
  pad = 4,
  undo_limit = 20
})

GUI.New("btn_save_new", "Button", {
  z = 5,
  x = 8,
  y = 100,
  w = 60,
  h = 24,
  caption = "Save",
  font = 3,
  col_txt = "txt",
  col_fill = "elm_frame",
})

GUI.New("btn_save_edit", "Button", {
  z = 5,
  x = 8,
  y = 100,
  w = 60,
  h = 24,
  caption = "Save",
  font = 3,
  col_txt = "txt",
  col_fill = "elm_frame",
})

GUI.New("btn_cancel_edit", "Button", {
  z = 5,
  x = 136,
  y = 100,
  w = 60,
  h = 24,
  caption = "Cancel",
  font = 3,
  col_txt = "txt",
  col_fill = "elm_frame",
})

GUI.New("btn_cancel_new", "Button", {
  z = 5,
  x = 136,
  y = 100,
  w = 60,
  h = 24,
  caption = "Cancel",
  font = 3,
  col_txt = "txt",
  col_fill = "elm_frame",
})

------------------------------------
-------- Functions  ----------------
------------------------------------

function shiftEditWindow ()
  if GUI.elms.lst_tasks.z == 11 then

    GUI.elms.lst_tasks.z = 5
    GUI.elms.frm_details.z = 5
    GUI.elms.btn_save_new.z = 5
    GUI.elms.btn_new.z = 5
    GUI.elms.btn_edit.z = 5
    GUI.elms.btn_done.z = 5
    GUI.elms.btn_delete.z = 5

    GUI.elms.txtbox_caption_tasks.z = 11
    GUI.elms.txt_editor_tasks.z = 11
    GUI.elms.btn_save_edit.z = 11
    GUI.elms.btn_cancel_edit.z = 11
    -- Force a redraw of every layer
    GUI.redraw_z[0] = true

  else

    GUI.elms.btn_save_edit.z = 5
    GUI.elms.btn_save_new.z = 5
    GUI.elms.btn_cancel_edit.z = 5
    GUI.elms.txtbox_caption_tasks.z = 5
    GUI.elms.txt_editor_tasks.z = 5

    GUI.elms.lst_tasks.z = 11
    GUI.elms.frm_details.z = 11
    GUI.elms.btn_new.z = 11
    GUI.elms.btn_edit.z = 11
    GUI.elms.btn_done.z = 11
    GUI.elms.btn_delete.z = 11
    -- Force a redraw of every layer
    GUI.redraw_z[0] = true
  end
end

function shiftNewWindow ()
  if GUI.elms.lst_tasks.z == 11 then

    GUI.elms.lst_tasks.z = 5
    GUI.elms.frm_details.z = 5
    GUI.elms.btn_save_edit.z = 5
    GUI.elms.btn_new.z = 5
    GUI.elms.btn_edit.z = 5
    GUI.elms.btn_done.z = 5
    GUI.elms.btn_delete.z = 5

    GUI.elms.txtbox_caption_tasks.z = 11
    GUI.elms.txt_editor_tasks.z = 11
    GUI.elms.btn_save_new.z = 11
    GUI.elms.btn_cancel_new.z = 11
    -- Force a redraw of every layer
    GUI.redraw_z[0] = true

  else

    GUI.elms.btn_save_new.z = 5
    GUI.elms.btn_cancel_new.z = 5
    GUI.elms.txtbox_caption_tasks.z = 5
    GUI.elms.txt_editor_tasks.z = 5

    GUI.elms.lst_tasks.z = 11
    GUI.elms.frm_details.z = 11
    GUI.elms.btn_new.z = 11
    GUI.elms.btn_edit.z = 11
    GUI.elms.btn_done.z = 11
    GUI.elms.btn_delete.z = 11
    -- Force a redraw of every layer
    GUI.redraw_z[0] = true
  end
end

----------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Layer 5 will never be shown or updated
GUI.elms_hide[5] = true

function GUI.elms.lst_tasks:onmouseup()
  GUI.Listbox.onmouseup(self)
  add_text()
end

function GUI.elms.btn_new:onmouseup()
  GUI.Button.onmouseup(self)
  shiftNewWindow()
  emptyTxtFields()
end

function GUI.elms.btn_edit:onmouseup()
  GUI.Button.onmouseup(self)
  shiftEditWindow()
  GUI.Val("txtbox_caption_tasks", items[GUI.Val("lst_tasks")].title)
  GUI.Val("txt_editor_tasks", items[GUI.Val("lst_tasks")].frame)
end

function GUI.elms.btn_done:onmouseup()
  GUI.Button.onmouseup(self)
  items[GUI.Val("lst_tasks")].prio = "d"
  selectedItem = items[GUI.Val("lst_tasks")].id
  sortItems()
  saveToFile()
end

function GUI.elms.btn_delete:onmouseup()
  GUI.Button.onmouseup(self)
  table.remove(tasks, GUI.Val("lst_tasks"))
  table.remove(items, GUI.Val("lst_tasks"))
  fillListBoxwithTasks()
  GUI.Val("lst_tasks", {true})
  selectedItem = items[GUI.Val("lst_tasks")].id
  add_text()
  sortItems()
  saveToFile()
end

function GUI.elms.btn_save_new:onmouseup()
  GUI.Button.onmouseup(self)
  if (GUI.Val("txtbox_caption_tasks") == "") or (GUI.Val("txt_editor_tasks") == "") then
    reaper.ShowMessageBox("Fill in the blanks - you must have text in Tasks and Details", "Fill in the blanks", 0)
  else
    table.insert(items, {["id"] = reaper.genGuid(), ["prio"] = "a", ["title"] = GUI.Val("txtbox_caption_tasks"), ["frame"] = GUI.Val("txt_editor_tasks")})
    GUI.Val("lst_tasks", {(#items)})
    selectedItem = items[#items].id
    sortItems()
    add_text()
    saveToFile()
    emptyTxtFields()
    shiftNewWindow()
  end
end

function GUI.elms.btn_save_edit:onmouseup()
  selectedItem = items[GUI.Val("lst_tasks")].id
  GUI.Button.onmouseup(self)
  if (GUI.Val("txtbox_caption_tasks") == "") or (GUI.Val("txt_editor_tasks") == "") then
    reaper.ShowMessageBox("You must have some text in Tasks and Details", "Fill in the blanks", 0)
  else
    items[GUI.Val("lst_tasks")].title = GUI.Val("txtbox_caption_tasks")
    items[GUI.Val("lst_tasks")].frame = GUI.Val("txt_editor_tasks")
    sortItems()
    add_text()
    saveToFile()
    emptyTxtFields()
    shiftEditWindow()
  end
end

function GUI.elms.btn_cancel_edit:onmouseup()
  GUI.Button.onmouseup(self)
  emptyTxtFields()
  shiftEditWindow()
end

function GUI.elms.btn_cancel_new:onmouseup()
  GUI.Button.onmouseup(self)
  emptyTxtFields()
  shiftNewWindow()
end

function GUI.elms.lst_tasks:onmouser_down()
  selectedItem = items[GUI.Val("lst_tasks")].id
  GUI.elms.lst_tasks:onmouseup()
  self:redraw()
end

function GUI.elms.lst_tasks:onmouser_up()
  gfx.x, gfx.y = gfx.mouse_x, gfx.mouse_y
  menu = gfx.showmenu("#Priority||High|Medium|Low")
  if menu == 2 then
    items[GUI.Val("lst_tasks")].prio = "a"
  elseif menu == 3 then
    items[GUI.Val("lst_tasks")].prio = "b"
  elseif menu == 4 then
    items[GUI.Val("lst_tasks")].prio = "c"
  end
  sortItems()
  saveToFile()
  GUI.Listbox.onmouser_up(self)
  self:redraw()
end

function add_text()
  GUI.Val("frm_details", items[GUI.Val("lst_tasks")].frame)
end

function sortItems ()
  local function tableSortCat (a, b )
    if (a.prio < b.prio) then
      return true
    elseif (a.prio > b.prio) then
      return false
    else
      return a.title < b.title
    end
  end
  table.sort( items, tableSortCat)
  fillListBoxwithTasks()
  selectItemByID(selectedItem)
end

function selectItemByID (args)
  for i = 1, #items do
    if (items[i].id == selectedItem) then
      GUI.Val("lst_tasks", {[i] = true})
    end
  end
end

function fillListBoxwithTasks ()
  for i = 1, #items do
    tasks[i] = convertPrio(items[i].prio) .. items[i].title
  end
  GUI.elms.lst_tasks.list = tasks
end

function convertPrio (prioToConvert)
  if prioToConvert == "a" then
    m = "|H| "
    return m
  elseif prioToConvert == "b" then
    m = "|M| "
    return m
  elseif prioToConvert == "c" then
    m = "|L| "
    return m
  elseif prioToConvert == "d" then
    m = "|X| "
    return m
  end
end

function saveToFile ()
  table.save(items, project_path .. "/" .. "todolist.txt")
end

function emptyTxtFields ()
  GUI.Val("txtbox_caption_tasks", "")
  GUI.elms.txtbox_caption_tasks.focus = true
  GUI.Val("txt_editor_tasks", "")
end

function set_initial_state()
  ------------------------------------
  -------- Load Listbox contents ----------
  ------------------------------------


  if items == nil then
    items = {
      {["id"] = "{109E9200-597D-6B3E-38D6-DB21CA82A1F3}", ["prio"] = "a", ["title"] = "Donate to Lokasenna", ["frame"] = "Dont forget to donate to Lokasenna" },
      {["id"] = "{36E55F9F-9183-7B9E-2D16-BF5EAA091820}", ["prio"] = "b", ["title"] = "Donate to XRayM", ["frame"] = "Dont forget to donate to XRayM" },
      {["id"] = "{B15A4D85-FBC9-11AE-C181-AED8E7C90501}", ["prio"] = "c", ["title"] = "Donate to cfillion", ["frame"] = "Dont forget to donate to cfillion" }
    }
    saveToFile()
  end
  fillListBoxwithTasks ()
  GUI.Val("lst_tasks", {1})
  GUI.Val("frm_details", items[GUI.Val("lst_tasks")].frame)
  selectedItem = items[GUI.Val("lst_tasks")].id
  sortItems()
end

local function force_size()
  gfx.quit()
  gfx.init(GUI.name, GUI.w, GUI.h, GUI.dock, GUI.x, GUI.y)
  -- So .onresize isn't called again on the next loop
  GUI.cur_w, GUI.cur_h = GUI.w, GUI.h
end

GUI.onresize = force_size

--GUI.Msg("Done")
--  GUI.Msg(tostring(GUI.table_list(items)))
--reaper.atexit(saveToFile)
--GUI.Msg("Calling Initial state")
set_initial_state()
--sortItems()

GUI.Init()
GUI.Main()

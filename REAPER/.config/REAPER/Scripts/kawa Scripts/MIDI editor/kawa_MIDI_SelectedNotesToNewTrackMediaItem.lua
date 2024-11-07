--[[ 
* ReaScript Name: kawa_MIDI_SelectedNotesToNewTrackMediaItem. 
* Version: 2017/01/21 
* Author: kawa_ 
* Author URI: http://forum.cockos.com/member.php?u=105939 
* link: https://bitbucket.org/kawaCat/reascript-m2bpack/ 
--]] 
if(package.config:sub(1,1)=="\\")then end local o=40815 local i=40659 function deepcopy(t)local o=type(t)local e if o=='table'then e={}for t,o in next,t,nil do e[deepcopy(t)]=deepcopy(o)end setmetatable(e,deepcopy(getmetatable(t)))else e=t end return e end function createMIDIFunc3(p)local e={}e.allNotes={}e.selectedNotes={}e._editingNotes_Original={}e.editingNotes={}e.editorHwnd=nil e.take=nil e.mediaItem=nil e.mediaTrack=nil e._limitMaxCount=1e3;e._isSafeLimit=true;function e:_showLimitNoteMsg()reaper.ShowMessageBox("over "..tostring(self._limitMaxCount).." clip num .\nstop process","stop.",0)end function e:getMidiNotes()reaper.PreventUIRefresh(2)reaper.MIDIEditor_OnCommand(self.editorHwnd,o)reaper.MIDIEditor_OnCommand(self.editorHwnd,i)reaper.PreventUIRefresh(-1)local n={}local r={}local i,a,c,t,o,d,I,s=reaper.MIDI_GetNote(self.take,0)local e=0 while i do t=reaper.MIDI_GetProjQNFromPPQPos(self.take,t)o=reaper.MIDI_GetProjQNFromPPQPos(self.take,o)local l={selection=a,mute=c,startQn=t,endQn=o,chan=d,pitch=I,vel=s,take=self.take,idx=e,length=o-t}table.insert(n,l)if(a==true)then table.insert(r,l);end e=e+1 i,a,c,t,o,d,I,s=reaper.MIDI_GetNote(self.take,e)if(e>self._limitMaxCount)then n={}r={}self:_showLimitNoteMsg()self._isSafeLimit=false break end end self.m_existMaxNoteIdx=e;return n,r end function e:detectTargetNote()if(self._isSafeLimit==false)then return{}end if(#self.selectedNotes>=1)then self._editingNotes_Original=deepcopy(self.selectedNotes);self.editingNotes=deepcopy(self.selectedNotes);return self.editingNotes else self._editingNotes_Original=deepcopy(self.allNotes);self.editingNotes=deepcopy(self.allNotes);return self.editingNotes end end function e:correctOverWrap()reaper.MIDIEditor_OnCommand(self.editorHwnd,i)end function e:flush(e,t)self:_deleteAllOriginalNote();self:_editingNoteToMediaItem(e);self:correctOverWrap();if(t==true)then reaper.MIDI_Sort(self.take);end end function e:insertNoteFromC(e)e.idx=self.m_existMaxNoteIdx+1;self.m_existMaxNoteIdx=self.m_existMaxNoteIdx+1;table.insert(self.editingNotes,e);return e;end function e:insertNotesFromC(e)for t,e in ipairs(e)do self:insertNoteFromC(e)end return e;end function e:insertMidiNote(a,o,e,t,r,n,l)local e=e local t=t local i=o;local o=r or false;local r=l or false;local n=n or 1;local l=a;local a=self.m_existMaxNoteIdx+1;self.m_existMaxNoteIdx=self.m_existMaxNoteIdx+1;local e={selection=o,mute=r,startQn=e,endQn=t,chan=n,pitch=l,vel=i,take=self.take,idx=a,length=t-e}table.insert(self.editingNotes,e);end function e:deleteNote(t)for e,o in ipairs(self.editingNotes)do if(o.idx==t.idx)then table.remove(self.editingNotes,e)break;end end end function e:deleteNotes(e)if(e==self.editingNotes)then self.editingNotes={};return;end for t,e in ipairs(e)do self:deleteNote(e)end end function e:_init(e)self.editorHwnd=reaper.MIDIEditor_GetActive();self.take=e or reaper.MIDIEditor_GetTake(self.editorHwnd);if(self.take==nil)then return end self.allNotes,self.selectedNotes=self:getMidiNotes()self.mediaItem=reaper.GetMediaItemTake_Item(self.take);self.mediaTrack=reaper.GetMediaItemTrack(self.mediaItem);end function e:_deleteAllOriginalNote(e)local e=e or self._editingNotes_Original;while(#e>0)do local t=#e;reaper.MIDI_DeleteNote(e[t].take,e[t].idx)table.remove(e,#e);end end function e:_insertNoteToMediaItem(e,o)local t=self.take if t==nil then return end local d=e.selection or false;local c=e.mute;local l=reaper.MIDI_GetPPQPosFromProjQN(t,e.startQn)local i=reaper.MIDI_GetPPQPosFromProjQN(t,e.endQn)local r=e.chan;local n=e.pitch;local a=e.vel;local e=0;if(o==true)then local o=.9;local a=reaper.MIDI_GetProjQNFromPPQPos(t,o)local t=reaper.MIDI_GetProjQNFromPPQPos(t,o*2)e=t-a end reaper.MIDI_InsertNote(t,d,c,l,i-e,r,n,a,true)end function e:_editingNoteToMediaItem(t)for o,e in ipairs(self.editingNotes)do self:_insertNoteToMediaItem(e,t)end end e:_init(p)return e end local o=0;if(package.config:sub(1,1)=="\\")then end local n="kawa MIDI SelectedNotes To NewTrack NewMediaItem"local function r(e,r,a)local t=createMIDIFunc3();local l=t:detectTargetNote()if(#t.selectedNotes<1)then return;end reaper.Undo_BeginBlock();local s=e or false;local r=r or false;local i=a or false;local a=t.mediaTrack;local e=t.mediaTrack;if(r==true)then local t=reaper.GetMediaTrackInfo_Value(a,"IP_TRACKNUMBER");e=reaper.InsertTrackAtIndex(t,i);e=reaper.GetTrack(o,t);end local a=t.mediaItem;local o=reaper.GetMediaItemInfo_Value(a,"D_POSITION");local a=reaper.GetMediaItemInfo_Value(a,"D_LENGTH");local a=o+a;local e=reaper.CreateNewMIDIItemInProj(e,o,a,false);local o=reaper.GetMediaItemTake(e,0);local a={};for n,e in ipairs(l)do local c=e.selection or false;local r=e.mute;local n=reaper.MIDI_GetPPQPosFromProjQN(o,e.startQn)local t=reaper.MIDI_GetPPQPosFromProjQN(o,e.endQn)local l=e.chan;local d=e.pitch;local i=e.vel;reaper.MIDI_InsertNote(o,c,r,n,t,l,d,i,false)if(s==true)then table.insert(a,e);end end t:deleteNotes(a);t:flush(true,true)reaper.Undo_EndBlock(n,-1);reaper.UpdateArrange();end local e=true;local t=true;local o=true;r(e,t,o);
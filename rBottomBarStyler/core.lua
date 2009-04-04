  
  --[[----------------------------------------------------------------------------
    Copyright (c) 2009, Erik Raetz
    All rights reserved.
  
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
  
    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of rBottomBarStyler nor the names of its contributors may be used
      to endorse or promote products derived from this software without specific
      prior written permission.
  
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
  ------------------------------------------------------------------------------]]

  ------------------------------------------------------
  -- / VARIABLES / --
  ------------------------------------------------------
  
  local default_scale = 0.6
  local default_art = "d3"  
  local default_bar = "bar2"  
  local default_movable = 1
  local default_locked = 1
  rBottomBarStyler = rBottomBarStyler or {}
  local frame_to_scale
  local bar_to_show
  local frame_to_drag

  ------------------------------------------------------
  -- / SET UP DEFAULT VALUES / --
  ------------------------------------------------------

  local function load_default()
    if(not rBottomBarStyler.scalevalue) then 
      rBottomBarStyler.scalevalue = default_scale 
    end
    if(not rBottomBarStyler.artvalue) then 
      rBottomBarStyler.artvalue = default_art 
    end
    if(not rBottomBarStyler.barvalue) then 
      rBottomBarStyler.barvalue = default_bar 
    end
    if(not rBottomBarStyler.movable) then 
      rBottomBarStyler.movable = default_movable 
    end
    if(not rBottomBarStyler.locked) then 
      rBottomBarStyler.locked = default_locked 
    end
  end
  
  ------------------------------------------------------
  -- / CHAT OUTPUT FUNC / --
  ------------------------------------------------------
  
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end

  ------------------------------------------------------
  -- / SAVE POSXY FUNC / --
  ------------------------------------------------------
  
  local function save_posxy()
    local point, relativeTo, relativePoint, x, y = frame_to_scale:GetPoint()
    rBottomBarStyler.point = point
    rBottomBarStyler.posx = x
    rBottomBarStyler.posy = y
  end  
  
  ------------------------------------------------------
  -- / MOVE ME FUNC / --
  ------------------------------------------------------
  
  local function move_my_frame()
    if frame_to_drag then
      frame_to_drag:Hide()
    end
    if rBottomBarStyler.movable == 1 then
      frame_to_scale:SetMovable(true)
      if rBottomBarStyler.locked == 0 then
        if frame_to_drag then
          frame_to_drag:Show()
        end
        frame_to_scale:EnableMouse(true)
        frame_to_scale:RegisterForDrag("LeftButton","RightButton")
        frame_to_scale:SetScript("OnDragStart", function(self) 
          if IsShiftKeyDown() and IsAltKeyDown() then 
            self:StartMoving() 
          end 
        end)
        frame_to_scale:SetScript("OnDragStop", function(self) 
          if IsShiftKeyDown() and IsAltKeyDown() then 
            self:StopMovingOrSizing()
            save_posxy() 
          end 
        end)
      end
    else
      rBottomBarStyler.point = nil
      rBottomBarStyler.posx = nil
      rBottomBarStyler.posy = nil
      frame_to_scale:ClearAllPoints()
      frame_to_scale:SetPoint("BOTTOM",0,0)
    end  
  end

  ------------------------------------------------------
  -- / CREATE ME A FRAME FUNC / --
  ------------------------------------------------------

  local function create_me_a_frame(fart,fname,fparent,fstrata,fwidth,fheight,fanchor,fxpos,fypos,fscale,fdrag)
    local f = CreateFrame(fart,fname,fparent)
    f:SetFrameStrata(fstrata)
    f:SetWidth(fwidth)
    f:SetHeight(fheight)
    if fname == "rBBS_Holder" then
      if rBottomBarStyler.point and rBottomBarStyler.posx and rBottomBarStyler.posy then
        f:SetPoint(rBottomBarStyler.point,rBottomBarStyler.posx,rBottomBarStyler.posy)
      else
        f:SetPoint(fanchor,fxpos,fypos)
      end
    else
      f:SetPoint(fanchor,fxpos,fypos)
    end
    f:SetScale(fscale)
    if fdrag == true then
      f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
    end
    return f  
  end 
  
  ------------------------------------------------------
  -- / CREATE ME A TEXTURE FUNC / --
  ------------------------------------------------------

  local function create_me_a_texture(fhooked,tstrata,tfile,tspecial)
    local t = fhooked:CreateTexture(nil,tstrata)
    t:SetTexture(tfile)
    if tspecial == "fill" then
      t:SetPoint("BOTTOM",fhooked,"BOTTOM",0,0)
      t:SetWidth(fhooked:GetWidth())
      t:SetHeight(fhooked:GetHeight())
    else
      t:SetAllPoints(fhooked)
    end
    return t
  end 

  ------------------------------------------------------
  -- / ORB HEALTH FUNC / --
  ------------------------------------------------------
  
  local function orbhealth(orb1,orb1_fill)
    orb1:SetScript("OnEvent", function(self, event, arg1, ...)
      if arg1 == "player" then
        local uh, uhm = UnitHealth("player"), UnitHealthMax("player")
        orb1_fill:SetHeight((uh/uhm) * orb1_fill:GetWidth())
        orb1_fill:SetTexCoord(0,1,  math.abs(uh/uhm - 1),1)
      end
    end)
    orb1:RegisterEvent("UNIT_HEALTH")
  end
  
  ------------------------------------------------------
  -- / ORB MANA FUNC / --
  ------------------------------------------------------
  
  local function orbmana(orb2,orb2_fill)
    orb2:SetScript("OnEvent", function(self, event, arg1, ...)
      if arg1 == "player" then
        local um, umm = UnitMana("player"), UnitManaMax("player")
        orb2_fill:SetHeight((um/umm) * orb2_fill:GetWidth())
        orb2_fill:SetTexCoord(0,1,  math.abs(um/umm - 1),1)
      end
    end)
    orb2:RegisterEvent("UNIT_MANA")
    orb2:RegisterEvent("UNIT_RAGE")
    orb2:RegisterEvent("UNIT_ENERGY")
    orb2:RegisterEvent("UNIT_FOCUS")
    orb2:RegisterEvent("UNIT_RUNIC_POWER")
  end
  
  ------------------------------------------------------
  -- / CREATE ORB FUNC / --
  ------------------------------------------------------
  
  local function create_orb(orbtype,orbsize,orbanchorframe,orbpoint,orbposx,orbposy,orbscale,orbfilltex,orbcolr,orbcolg,orbcolb)
    --life orb
    local orb1 = create_me_a_frame("Frame",nil,orbanchorframe,"LOW",orbsize,orbsize,orbpoint,orbposx,orbposy,orbscale)
    local orb1_back = create_me_a_texture(orb1,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb1_fill = create_me_a_texture(orb1,"LOW","Interface\\AddOns\\rBottomBarStyler\\orbtex\\"..orbfilltex,"fill")
    orb1_fill:SetVertexColor(orbcolr,orbcolg,orbcolb)
    local orb1_glossholder = create_me_a_frame("Frame",nil,orb1,"MEDIUM",orbsize,orbsize,"BOTTOM",0,0,1)
    local orb1_gloss = create_me_a_texture(orb1_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
    if orbtype == "life" then
      orbhealth(orb1,orb1_fill)
    else
      orbmana(orb1,orb1_fill)
    end
  end  
  
  ------------------------------------------------------
  -- / SET ME A SCALE / --
  ------------------------------------------------------

  local function set_me_a_scale()
    frame_to_scale:SetScale(rBottomBarStyler.scalevalue)
  end 
  
  ------------------------------------------------------
  -- / SET ME A BAR / --
  ------------------------------------------------------

  local function set_me_a_bar()
    if rBottomBarStyler.artvalue == "roth" then
      bar_to_show:SetTexture("Interface\\AddOns\\rBottomBarStyler\\rothtex\\"..rBottomBarStyler.barvalue)
    else
      am("Does only work for roth layout")
    end
  end 

  ------------------------------------------------------
  -- / CREATE D1 STYLE / --
  ------------------------------------------------------  
  local function create_d1_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",1024,256,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d1tex\\bar")
    --orbs
    create_orb("life",160,holder,"BOTTOM",-290,120,1,"orb_filling4",0.8,0,0)
    create_orb("mana",160,holder,"BOTTOM",285,120,1,"orb_filling4",0,0.3,0.8)
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",-320,35,0.9)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d1tex\\figure_left")
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",320,35,0.9)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d1tex\\figure_right")
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe  
  end

  ------------------------------------------------------
  -- / CREATE D2 STYLE / --
  ------------------------------------------------------  
  local function create_d2_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",100,100,"BOTTOM",0,0,scale,true)
    frame_to_scale = holder        
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",1024,128,"BOTTOM",0,44,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\bar")
    --border
    local border_left = create_me_a_frame("Frame",nil,holder,"LOW",1024,512,"BOTTOMRIGHT",0,0,1)
    local border_left_tex = create_me_a_texture(border_left,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\border_left")
    local border_right = create_me_a_frame("Frame",nil,holder,"LOW",1024,512,"BOTTOMLEFT",0,0,1)
    local border_right_tex = create_me_a_texture(border_right,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\border_right")
    --orbs
    create_orb("life",160,holder,"BOTTOM",-472,55,1,"orb_filling4",0.8,0,0)
    create_orb("mana",160,holder,"BOTTOM",465,55,1,"orb_filling4",0,0.3,0.8)
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",-453,44,1)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\figure_left")
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",453,44,1)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\figure_right")
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe      
  end
  
  ------------------------------------------------------
  -- / CREATE D3 STYLE / --
  ------------------------------------------------------  
  local function create_d3_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",1024,128,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\bar")
    --orbs
    create_orb("life",200,holder,"BOTTOM",-471,-3,1,"orb_filling4",0.8,0,0)
    create_orb("mana",200,holder,"BOTTOM",471,-3,1,"orb_filling4",0,0.3,0.8)
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"HIGH",512,256,"BOTTOM",-455,0,1)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\figure_left")
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"HIGH",512,256,"BOTTOM",455,0,1)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\figure_right")
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe      
  end
  
  ------------------------------------------------------
  -- / CREATE ROTH STYLE / --
  ------------------------------------------------------  
  local function create_roth_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",512,256,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\"..rBottomBarStyler.barvalue)
    bar_to_show = bar_tex    
    --bottom
    local bottom = create_me_a_frame("Frame",nil,holder,"HIGH",500,110,"BOTTOM",0,-10,1)
    local bottom_tex = create_me_a_texture(bottom,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\bottom")    
    --orbs
    create_orb("life",120,holder,"BOTTOM",-250,-8,1,"orb_filling4",0.8,0,0)
    create_orb("mana",120,holder,"BOTTOM",250,-8,1,"orb_filling4",0,0.3,0.8)    
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",-510,0,0.6)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\figure_left")    
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",510,0,0.6)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\figure_right")    
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe      
  end  
  
  ------------------------------------------------------
  -- / LOAD STYLE FUNC / --
  ------------------------------------------------------
  
  local function load_style(style,scale)
    if style == "roth" then
      create_roth_style(scale)
    elseif style == "d1" then
      create_d1_style(scale)
    elseif style == "d2" then
      create_d2_style(scale)
    else
      create_d3_style(scale)
    end
  end

  ------------------------------------------------------
  -- / SLASH FUNC / --
  ------------------------------------------------------
  
  local function SlashCmd(cmd)    
    --setscale
    if (cmd:match"setscale") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if tonumber(c) then
          am("Current scaling is set to: "..c)
          rBottomBarStyler.scalevalue = tonumber(c)
          set_me_a_scale()
        else
          am("No number value.")
        end
      else
        am("No value found.")
      end    
    --getscale  
    elseif (cmd:match"getscale") then
      am("Current scaling is set to: "..rBottomBarStyler.scalevalue)
    --setart
    elseif (cmd:match"setart") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if c == "d1" or c == "d2" or c == "d3" or c == "roth" then
          am("You set the art to: "..c)
          rBottomBarStyler.artvalue = c
          am("You need to reoad the interface to see the changes.")
          am("Type in: \"/console reloadui\".")
        else
          am("Wrong value. (possible values: d1, d2, d3, roth)")
        end
      else
        am("No value found.")
      end
    --setbar
    elseif (cmd:match"setbar") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if c == "bar1" or c == "bar2" or c == "bar3" then
          am("You set the bar to: "..c)
          rBottomBarStyler.barvalue = c
          set_me_a_bar()
        else
          am("Wrong value. (possible values: bar1, bar2, bar3)")
        end
      else
        am("No value found.")
      end      
    --getart
    elseif (cmd:match"getart") then
      am("Current art is set to: "..rBottomBarStyler.artvalue)    
    --getmovable
    elseif (cmd:match"getmovable") then
      am("Movable is set to: "..rBottomBarStyler.movable)    
    --getlocked
    elseif (cmd:match"getlocked") then
      am("Locked is set to: "..rBottomBarStyler.locked)    
    --locked
    elseif (cmd:match"locked") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if tonumber(c) then
          am("Locked is set to: "..c)
          rBottomBarStyler.locked = tonumber(c)
          move_my_frame()
        else
          am("No number value.")
        end
      else
        am("No value found.")
      end    
    --movable
    elseif (cmd:match"movable") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if tonumber(c) then
          am("Movable is set to: "..c)
          rBottomBarStyler.movable = tonumber(c)
          move_my_frame()
        else
          am("No number value.")
        end
      else
        am("No value found.")
      end  
    else
      am("rbbs commands...")
      am("\/rbbs getscale")
      am("\/rbbs getart")
      am("\/rbbs getlocked")
      am("\/rbbs getmovable")
      am("\/rbbs setscale NUMBER")
      am("\/rbbs setart STRING (possible values: d1, d2, d3, roth)")
      am("\/rbbs setbar STRING (possible values: bar1, bar2, bar3 - only affects the roth layout)")
      am("\/rbbs locked NUMBER (value of 1 locks bars, 0 unlocks)")
      am("\/rbbs movable NUMBER (value of 1 makes bars movable if unlocked, value of 0 will reset position)")
    end    
  end
  
  ------------------------------------------------------
  -- / LOAD THE SHIT / --
  ------------------------------------------------------  

  local a = CreateFrame"Frame"
  a:RegisterEvent("VARIABLES_LOADED")
  a:SetScript("OnEvent", function(self)
    self:UnregisterEvent("VARIABLES_LOADED")
    self:SetScript("OnEvent", nil)    
    --default values
    load_default()
    --load the styles
    load_style(rBottomBarStyler.artvalue,rBottomBarStyler.scalevalue)
    move_my_frame()
    --slash commands
    SlashCmdList["whatever"] = SlashCmd;
    SLASH_whatever1 = "/rbbs";
    --am("rbbs loaded...")
  end)
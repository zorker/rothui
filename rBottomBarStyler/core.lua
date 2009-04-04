  
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
  rBottomBarStyler = rBottomBarStyler or {}
  local frame_to_scale
  local bar_to_show


  ------------------------------------------------------
  -- / CHAT OUTPUT FUNC / --
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
  end
  
  ------------------------------------------------------
  -- / CHAT OUTPUT FUNC / --
  ------------------------------------------------------
  
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end

  ------------------------------------------------------
  -- / CREATE ME A FRAME FUNC / --
  ------------------------------------------------------

  local function create_me_a_frame(fart,fname,fparent,fstrata,fwidth,fheight,fanchor,fxpos,fypos,fscale)
    local f = CreateFrame(fart,fname,fparent)
    f:SetFrameStrata(fstrata)
    f:SetWidth(fwidth)
    f:SetHeight(fheight)
    f:SetPoint(fanchor,fxpos,fypos)
    f:SetScale(fscale)
    --f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
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
    --am("c d1")
    --holder
    local holder = create_me_a_frame("Frame","rBBS_holderolder",UIParent,"BACKGROUND",20,20,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",1024,256,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d1tex\\bar")
    
    local orbsize = 160
    --life orb
    local orb1 = create_me_a_frame("Frame",nil,holder,"LOW",orbsize,orbsize,"BOTTOM",-290,120,1)
    local orb1_back = create_me_a_texture(orb1,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb1_fill = create_me_a_texture(orb1,"LOW","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_filling4","fill")
    orb1_fill:SetVertexColor(0.8,0,0)
    local orb1_glossholder = create_me_a_frame("Frame",nil,orb1,"MEDIUM",orbsize,orbsize,"BOTTOM",0,0,1)
    local orb1_gloss = create_me_a_texture(orb1_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
    orb1:SetScript("OnEvent", function(self, event, arg1, ...)
      if arg1 == "player" then
        local uh, uhm = UnitHealth("player"), UnitHealthMax("player")
        orb1_fill:SetHeight((uh/uhm) * orb1_fill:GetWidth())
        orb1_fill:SetTexCoord(0,1,  math.abs(uh/uhm - 1),1)
      end
    end)
    orb1:RegisterEvent("UNIT_HEALTH")

    --mana orb
    local orb2 = create_me_a_frame("Frame",nil,holder,"LOW",orbsize,orbsize,"BOTTOM",285,120,1)
    local orb2_back = create_me_a_texture(orb2,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb2_fill = create_me_a_texture(orb2,"LOW","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_filling4","fill")
    orb2_fill:SetVertexColor(0,0.3,0.8)
    local orb2_glossholder = create_me_a_frame("Frame",nil,orb2,"MEDIUM",orbsize,orbsize,"BOTTOM",0,0,1)
    local orb2_gloss = create_me_a_texture(orb2_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
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
    
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",-320,35,0.9)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d1tex\\figure_left")
    
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",320,35,0.9)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d1tex\\figure_right")
    
  end

  ------------------------------------------------------
  -- / CREATE D2 STYLE / --
  ------------------------------------------------------  
  local function create_d2_style(scale)
    --am("c d2")
    --holder
    local holder = create_me_a_frame("Frame",nil,UIParent,"BACKGROUND",20,20,"BOTTOM",0,-5,scale)
    frame_to_scale = holder        
    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",1024,128,"BOTTOM",0,44,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\bar")

    local border_left = create_me_a_frame("Frame",nil,holder,"LOW",1024,512,"BOTTOMRIGHT",0,0,1)
    local border_left_tex = create_me_a_texture(border_left,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\border_left")

    local border_right = create_me_a_frame("Frame",nil,holder,"LOW",1024,512,"BOTTOMLEFT",0,0,1)
    local border_right_tex = create_me_a_texture(border_right,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\border_right")


    local orbsize = 160
    --life orb
    local orb1 = create_me_a_frame("Frame",nil,holder,"LOW",orbsize,orbsize,"BOTTOM",-472,55,1)
    local orb1_back = create_me_a_texture(orb1,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb1_fill = create_me_a_texture(orb1,"LOW","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_filling4","fill")
    orb1_fill:SetVertexColor(0.8,0,0)
    local orb1_glossholder = create_me_a_frame("Frame",nil,orb1,"MEDIUM",orbsize,orbsize,"BOTTOM",0,0,1)
    local orb1_gloss = create_me_a_texture(orb1_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
    orb1:SetScript("OnEvent", function(self, event, arg1, ...)
      if arg1 == "player" then
        local uh, uhm = UnitHealth("player"), UnitHealthMax("player")
        orb1_fill:SetHeight((uh/uhm) * orb1_fill:GetWidth())
        orb1_fill:SetTexCoord(0,1,  math.abs(uh/uhm - 1),1)
      end
    end)
    orb1:RegisterEvent("UNIT_HEALTH")

    --mana orb
    local orb2 = create_me_a_frame("Frame",nil,holder,"LOW",orbsize,orbsize,"BOTTOM",465,55,1)
    local orb2_back = create_me_a_texture(orb2,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb2_fill = create_me_a_texture(orb2,"LOW","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_filling4","fill")
    orb2_fill:SetVertexColor(0,0.3,0.8)
    local orb2_glossholder = create_me_a_frame("Frame",nil,orb2,"MEDIUM",orbsize,orbsize,"BOTTOM",0,0,1)
    local orb2_gloss = create_me_a_texture(orb2_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
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


    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",-453,44,1)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\figure_left")
    
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",453,44,1)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\figure_right")
    
  end
  
  ------------------------------------------------------
  -- / CREATE D3 STYLE / --
  ------------------------------------------------------  
  local function create_d3_style(scale)
    --am("c d3")
    local holder = create_me_a_frame("Frame",nil,UIParent,"BACKGROUND",20,20,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",1024,128,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\bar")
    
    local orbsize = 200
    --life orb
    local orb1 = create_me_a_frame("Frame",nil,holder,"LOW",orbsize,orbsize,"BOTTOM",-471,-3,1)
    local orb1_back = create_me_a_texture(orb1,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb1_fill = create_me_a_texture(orb1,"LOW","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_filling4","fill")
    orb1_fill:SetVertexColor(0.8,0,0)
    local orb1_glossholder = create_me_a_frame("Frame",nil,orb1,"MEDIUM",orbsize,orbsize,"BOTTOM",0,0,1)
    local orb1_gloss = create_me_a_texture(orb1_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
    orb1:SetScript("OnEvent", function(self, event, arg1, ...)
      if arg1 == "player" then
        local uh, uhm = UnitHealth("player"), UnitHealthMax("player")
        orb1_fill:SetHeight((uh/uhm) * orb1_fill:GetWidth())
        orb1_fill:SetTexCoord(0,1,  math.abs(uh/uhm - 1),1)
      end
    end)
    orb1:RegisterEvent("UNIT_HEALTH")

    --mana orb
    local orb2 = create_me_a_frame("Frame",nil,holder,"LOW",orbsize,orbsize,"BOTTOM",471,-3,1)
    local orb2_back = create_me_a_texture(orb2,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb2_fill = create_me_a_texture(orb2,"LOW","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_filling4","fill")
    orb2_fill:SetVertexColor(0,0.3,0.8)
    local orb2_glossholder = create_me_a_frame("Frame",nil,orb2,"MEDIUM",orbsize,orbsize,"BOTTOM",0,0,1)
    local orb2_gloss = create_me_a_texture(orb2_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
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


    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"HIGH",512,256,"BOTTOM",-455,0,1)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\figure_left")
    
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"HIGH",512,256,"BOTTOM",455,0,1)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\figure_right")
    
  end
  
  ------------------------------------------------------
  -- / CREATE ROTH STYLE / --
  ------------------------------------------------------  
  local function create_roth_style(scale)
    --am("c roth")
    local holder = create_me_a_frame("Frame",nil,UIParent,"BACKGROUND",20,20,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",512,256,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\"..rBottomBarStyler.barvalue)
    bar_to_show = bar_tex

    local bottom = create_me_a_frame("Frame",nil,holder,"HIGH",500,110,"BOTTOM",0,-10,1)
    local bottom_tex = create_me_a_texture(bottom,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\bottom")
    
    local orbsize = 120
    --life orb
    local orb1 = create_me_a_frame("Frame",nil,holder,"LOW",orbsize,orbsize,"BOTTOM",-250,-8,1)
    local orb1_back = create_me_a_texture(orb1,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb1_fill = create_me_a_texture(orb1,"LOW","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_filling4","fill")
    orb1_fill:SetVertexColor(0.8,0,0)
    local orb1_glossholder = create_me_a_frame("Frame",nil,orb1,"MEDIUM",orbsize,orbsize,"BOTTOM",0,0,1)
    local orb1_gloss = create_me_a_texture(orb1_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
    orb1:SetScript("OnEvent", function(self, event, arg1, ...)
      if arg1 == "player" then
        local uh, uhm = UnitHealth("player"), UnitHealthMax("player")
        orb1_fill:SetHeight((uh/uhm) * orb1_fill:GetWidth())
        orb1_fill:SetTexCoord(0,1,  math.abs(uh/uhm - 1),1)
      end
    end)
    orb1:RegisterEvent("UNIT_HEALTH")

    --mana orb
    local orb2 = create_me_a_frame("Frame",nil,holder,"LOW",orbsize,orbsize,"BOTTOM",250,-8,1)
    local orb2_back = create_me_a_texture(orb2,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb2_fill = create_me_a_texture(orb2,"LOW","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_filling4","fill")
    orb2_fill:SetVertexColor(0,0.3,0.8)
    local orb2_glossholder = create_me_a_frame("Frame",nil,orb2,"MEDIUM",orbsize,orbsize,"BOTTOM",0,0,1)
    local orb2_gloss = create_me_a_texture(orb2_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
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
    
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",-510,0,0.6)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\figure_left")
    
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"HIGH",256,256,"BOTTOM",510,0,0.6)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\figure_right")
    
    
  end  
  
  ------------------------------------------------------
  -- / SLASH LOAD STYLE FUNC / --
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
  	      rBottomBarStyler.scalevalue = c
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
  	else
      am("rbbs commands...\n\/rbbs getscale\n\/rbbs setscale NUMBER\n\/rbbs getart\n\/rbbs setart STRING (possible values: d1, d2, d3, roth)\n\/rbbs setbar STRING (possible values: bar1, bar2, bar3 - only affects the roth layout)")
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
    --slash commands
    SlashCmdList["whatever"] = SlashCmd;
    SLASH_whatever1 = "/rbbs";
    --am("rbbs loaded...")
  end)
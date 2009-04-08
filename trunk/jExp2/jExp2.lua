  
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
    * Neither the name of jExp2 nor the names of its contributors may be used
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
  
  local default_scale = 1
  local default_width = 500
  local default_height = 20
  local default_point = "CENTER"
  local default_posx = 0
  local default_posy = 0 
  local default_movable = 1 
  local default_locked = 1
  local default_bflevel = 2
  local default_bfstrata = "BACKGROUND"
  jExp2 = jExp2 or {}
  local xbar, rbar, bbg, frame_to_drag, frame_to_scale, frame_to_activate
  local xpcol = {r = 0.8, g = 0, b = 0}
  local repcol = {r = 1, g = 0.6, b = 0}
  local statusbartex = "Interface\\AddOns\\jExp2\\statusbar.tga"
  
  ------------------------------------------------------
  -- / CHAT OUTPUT FUNC / --
  ------------------------------------------------------
  
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
  
  ------------------------------------------------------
  -- / SET UP DEFAULT VALUES / --
  ------------------------------------------------------

  local function load_default()
    if(not jExp2.scale) then 
      jExp2.scale = default_scale 
    end
    if(not jExp2.width) then 
      jExp2.width = default_width 
    end
    if(not jExp2.height) then 
      jExp2.height = default_height 
    end  
    if(not jExp2.point) then 
      jExp2.point = default_point 
    end
    if(not jExp2.posx) then 
      jExp2.posx = default_posx 
    end
    if(not jExp2.posy) then 
      jExp2.posy = default_posy
    end
    if(not jExp2.movable) then 
      jExp2.movable = default_movable
    end
    if(not jExp2.locked) then 
      jExp2.locked = default_locked
    end
    if(not jExp2.bflevel) then 
      jExp2.bflevel = default_bflevel
    end
    if(not jExp2.bfstrata) then 
      jExp2.bfstrata = default_bfstrata
    end
  end
  
  ------------------------------------------------------
  -- / SET FRAMELEVELS FUNC / --
  ------------------------------------------------------
  
  local function set_framelevels()
    frame_to_scale:SetFrameStrata(jExp2.bfstrata)
    frame_to_scale:SetFrameLevel(jExp2.bflevel-2)
    frame_to_activate:SetFrameStrata(jExp2.bfstrata)
    frame_to_activate:SetFrameLevel(jExp2.bflevel)
    rbar:SetFrameStrata(jExp2.bfstrata)
    rbar:SetFrameLevel(jExp2.bflevel-1)
    xpbar:SetFrameStrata(jExp2.bfstrata)
    xpbar:SetFrameLevel(jExp2.bflevel+1)
  end  
  
  ------------------------------------------------------
  -- / SAVE POSXY FUNC / --
  ------------------------------------------------------
  
  local function save_posxy()
    local point, relativeTo, relativePoint, x, y = frame_to_scale:GetPoint()
    jExp2.point = point
    jExp2.posx = x
    jExp2.posy = y
    jExp2.width = frame_to_scale:GetWidth()
    jExp2.height = frame_to_scale:GetHeight()
  end  
  
  ------------------------------------------------------
  -- / MOVE ME FUNC / --
  ------------------------------------------------------
  
  local function move_my_frame()
    if frame_to_drag then
      frame_to_drag:Hide()
      frame_to_scale:EnableMouse(false)
      frame_to_activate:EnableMouse(true)
    end
    if jExp2.movable == 1 then
      frame_to_scale:SetMovable(true)
      frame_to_scale:SetResizable(true)
      if jExp2.locked == 0 then
        if frame_to_drag then
          frame_to_drag:Show()
        end
        frame_to_activate:EnableMouse(false)
        frame_to_scale:EnableMouse(true)
        frame_to_scale:RegisterForDrag("LeftButton","RightButton")
        frame_to_scale:SetScript("OnDragStart", function(self,a) 
          if IsShiftKeyDown() and IsAltKeyDown() then 
            if a == "LeftButton" then
              self:StartMoving() 
            else
              self:StartSizing() 
            end
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
      jExp2.point = nil
      jExp2.posx = nil
      jExp2.posy = nil
      jExp2.width = nil
      jExp2.height = nil
      frame_to_scale:ClearAllPoints()
      frame_to_scale:SetPoint(default_point,default_posx,default_posy)
      frame_to_scale:SetWidth(default_width)
      frame_to_scale:SetHeight(default_height)
    end  
  end
    
  ------------------------------------------------------
  -- / CREATE ME A FRAME FUNC / --
  ------------------------------------------------------

  local function create_me_a_frame(fart,fname,fparent,fstrata,flevel,fwidth,fheight,fanchor,fxpos,fypos,fscale,fdrag,finherit)
    local f = CreateFrame(fart,fname,fparent,finherit)
    f:SetFrameStrata(fstrata)
    f:SetFrameLevel(flevel)
    f:SetWidth(fwidth)
    f:SetHeight(fheight)
    if fname == "jExp2_Holder" then
      if jExp2.point and jExp2.posx and jExp2.posy then
        f:SetPoint(jExp2.point,jExp2.posx,jExp2.posy)
      else
        f:SetPoint(fanchor,fxpos,fypos)
      end
    else
      f:SetAllPoints(fparent)
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

  local function create_me_a_texture(fhooked,tstrata,tfile,tr,tg,tb,ta)
    local t = fhooked:CreateTexture(nil,tstrata)
    t:SetTexture(tfile)
    t:SetVertexColor(tr,tg,tb,ta)
    t:SetAllPoints(fhooked)
    return t
  end 
  
  ------------------------------------------------------
  -- / CREATE ME A STATUSBAR FUNC / --
  ------------------------------------------------------
  
  local function create_me_a_statusbar(fhooked,scolr,scolg,scolb,scola,sstrata,slevel,sfile)
    local f = CreateFrame("StatusBar", nil, fhooked)
    f:SetStatusBarTexture(sfile)
    f:SetStatusBarColor(scolr,scolg,scolb,scola)
    f:SetFrameStrata(sstrata)
    f:SetFrameLevel(slevel)
    f:SetAllPoints(fhooked)
    f:SetMinMaxValues(0,1)
    f:SetValue(0)
    return f
  end  
  
  ------------------------------------------------------
  -- / JEXP FUNCs / --
  ------------------------------------------------------
  
  --reset
  local function rbar_ReSetValue(rxp, xp, mxp)
  	if rxp then
  		if rxp+xp >= mxp then
  			rbar:SetValue(mxp)
  		else
  			rbar:SetValue(rxp+xp)
  		end
  	else
  		rbar:SetValue(0)
  	end
  end	
  
  --showxp
  local function bf_ShowXP(rxp, xp, mxp)
  	bbg:SetVertexColor(xpcol.r,xpcol.g,xpcol.b, 0.2)
  	xbar:SetStatusBarColor(xpcol.r,xpcol.g,xpcol.b, 0.85)
  	xbar:SetMinMaxValues(0,mxp)
  	xbar:SetValue(xp)
  	rbar:SetMinMaxValues(0,mxp)
  	rbar_ReSetValue(rxp, xp, mxp)
  end
  
  --showrep
  local function bf_ShowRep()
  	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
  	if name then
  		bbg:SetVertexColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, 0.2)
  		xbar:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b, 0.85)
  		xbar:SetMinMaxValues(minrep,maxrep)
  		xbar:SetValue(value)
  		rbar:SetValue(0)
  	else
  		mxp = UnitXPMax("player")
  		xp = UnitXP("player")
  		rxp = GetXPExhaustion()
  		bf_ShowXP(rxp, xp, mxp)
  	end
  end
    
  --onevent
  local function bf_OnEvent(this, event, arg1, arg2, arg3, arg4, ...)
  	mxp = UnitXPMax("player")
  	xp = UnitXP("player")
  	rxp = GetXPExhaustion()
  	
  	if event == "PLAYER_ENTERING_WORLD" then
  		if UnitLevel("player") == MAX_PLAYER_LEVEL then
  			bf_ShowRep()
  		else
  			bf_ShowXP(rxp, xp, mxp)
  		end
  	elseif event == "PLAYER_XP_UPDATE" and arg1 == "player" then
  		xbar:SetValue(xp)
  		rbar_ReSetValue(rxp, xp, mxp)
  	elseif event == "PLAYER_LEVEL_UP" then
  		if UnitLevel("player") == MAX_PLAYER_LEVEL then
  			bf_ShowRep()
  		else
  			bf_ShowXP(rxp, xp, mxp)
  		end
  	elseif event == "MODIFIER_STATE_CHANGED" then
  		if arg1 == "LCTRL" or arg1 == "RCTRL" then
  			if arg2 == 1 then
  				bf_ShowRep()
  			elseif arg2 == 0 and UnitLevel("player") ~= MAX_PLAYER_LEVEL then
  				bf_ShowXP(rxp, xp, mxp)
  			end
  		end
  	elseif event == "UPDATE_FACTION" then
  		if UnitLevel("player") == MAX_PLAYER_LEVEL then
  			bf_ShowRep()
  		end
  	end
  end
  
  --onenter
  local function bf_OnEnter()
  	mxp = UnitXPMax("player")
  	xp = UnitXP("player")
  	rxp = GetXPExhaustion()
  	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
  
  	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
  	GameTooltip:AddLine("jExp")
  	if UnitLevel("player") ~= MAX_PLAYER_LEVEL then
  		GameTooltip:AddDoubleLine(COMBAT_XP_GAIN, xp.."|cffffd100/|r"..mxp.." |cffffd100/|r "..floor((xp/mxp)*1000)/10 .."%",NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
  		if rxp then
  			GameTooltip:AddDoubleLine(TUTORIAL_TITLE26, rxp .." |cffffd100/|r ".. floor((rxp/mxp)*1000)/10 .."%", NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
  		end
  		if name then
  			GameTooltip:AddLine(" ")			
  		end
  	end
  	if name then
  		GameTooltip:AddDoubleLine(FACTION, name, NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
  		GameTooltip:AddDoubleLine(STANDING, getglobal("FACTION_STANDING_LABEL"..standing), NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)
  		GameTooltip:AddDoubleLine(REPUTATION, value-minrep .."|cffffd100/|r"..maxrep-minrep.." |cffffd100/|r "..floor((value-minrep)/(maxrep-minrep)*1000)/10 .."%", NORMAL_FONT_COLOR.r,NORMAL_FONT_COLOR.g,NORMAL_FONT_COLOR.b,1,1,1)
  	end
  		
  	GameTooltip:Show()
  end
  
  --onleave
  local function bf_OnLeave()
  	GameTooltip:Hide()
  end
  
  ------------------------------------------------------
  -- / CREATE THE BAR / --
  ------------------------------------------------------
  
  -- create the bar
  local function create_xpbars()    
    local holder = create_me_a_frame("Frame","jExp2_Holder",UIParent,jExp2.bfstrata,jExp2.bflevel-2,jExp2.width,jExp2.height,jExp2.point,jExp2.posx,jExp2.posy,jExp2.scale)
    frame_to_scale = holder   
    local bf = create_me_a_frame("Frame",nil,holder,jExp2.bfstrata,jExp2.bflevel+1,jExp2.width,jExp2.height,"BOTTOM",0,0,1)    
    frame_to_activate = bf
    local back = create_me_a_texture(bf,"BACKGROUND",statusbartex,xpcol.r,xpcol.g,xpcol.b, 0.2)
    bbg = back
    local repbar = create_me_a_statusbar(bf,repcol.r,repcol.g,repcol.b,0.7,jExp2.bfstrata,jExp2.bflevel-1,statusbartex)
    rbar = repbar
    local xpbar = create_me_a_statusbar(bf,xpcol.r,xpcol.g,xpcol.b,0.85,jExp2.bfstrata,jExp2.bflevel+1,statusbartex)
    xbar = xpbar
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",1,jExp2.width,jExp2.height,"BOTTOM",0,0,jExp2.scale,true)
    frame_to_drag = dragframe     
    
    bf:EnableMouse(true)
    bf:SetScript("OnEvent", bf_OnEvent)
    bf:SetScript("OnEnter", bf_OnEnter)
    bf:SetScript("OnLeave", bf_OnLeave)
    bf:RegisterEvent("PLAYER_XP_UPDATE")
    bf:RegisterEvent("PLAYER_LEVEL_UP")
    bf:RegisterEvent("PLAYER_ENTERING_WORLD")
    bf:RegisterEvent("UPDATE_FACTION")
    bf:RegisterEvent("MODIFIER_STATE_CHANGED")
  end

  ------------------------------------------------------
  -- / SLASH FUNC / --
  ------------------------------------------------------
  
  local function SlashCmd(cmd)    
    --setscale
    --getscale  
    if (cmd:match"getscale") then
      am("Current scaling is set to: "..jExp2.scale)
    --locked
    elseif (cmd:match"locked") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if tonumber(c) then
          am("Locked is set to: "..c)
          jExp2.locked = tonumber(c)
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
          jExp2.movable = tonumber(c)
          move_my_frame()
        else
          am("No number value.")
        end
      else
        am("No value found.")
      end    
    --level
    elseif (cmd:match"level") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if tonumber(c) then
          am("Framelevel is set to: "..c)
          jExp2.bflevel = tonumber(c)
          set_framelevels()
        else
          am("No number value.")
        end
      else
        am("No value found.")
      end  
    --setbar
    elseif (cmd:match"strata") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if c == "BACKGROUND" or c == "LOW" or c == "MEDIUM" or c == "HIGH" then
          am("You set the bar to: "..c)
          jExp2.bfstrata = c
          set_framelevels()
        else
          am("Wrong value. (possible values: BACKGROUND, LOW, MEDIUM, HIGH)")
        end
      else
        am("No value found.")
      end    
    else
      am("jExp commands...")
      am("\/jexp movable NUMBER (Value of 1 allows you to moving the bar at all, 0 will reset the bar!)")
      am("\/jexp locked NUMBER (Value of 1 locks the bar, 0 unlocks it.)")
      am("\/jexp level NUMBER (Sets the FrameLevel of the bar.)")
      am("\/jexp locked NUMBER (Set the FrameStrata of the bar.) Values allowed: BACKGROUND, LOW, MEDIUM, HIGH")
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
    load_default()
    create_xpbars()
    move_my_frame()
    SlashCmdList["jexp"] = SlashCmd;
    SLASH_jexp1 = "/jexp";
  end)
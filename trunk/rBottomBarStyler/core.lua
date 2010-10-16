  
  --[[----------------------------------------------------------------------------
    Copyright (c) 2010, Erik Raetz
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
  
  local default_scale = 0.82
  local default_art = "roth"  
  local default_bar = "bar2"  
  local default_movable = 1
  local default_locked = 1
  local default_healthorb = 0
  local default_manaorb = 3
  local default_automana = 1
  
  local usegalaxy = 1
  
  local default_font = NAMEPLATE_FONT
  rBottomBarStyler = rBottomBarStyler or {}
  local frame_to_scale
  local bar_to_show
  local hglow1, hglow2, mglow1, mglow2, hfill, mfill
  local hgal1,hgal2,hgal3,mgal1,mgal2,mgal3
  local frame_to_drag
  local fog_smoother = 1.3
  local text_display = 1
  local save_dudustance
  
  local player_class_color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
  
  local orbtab = {
    [0] = {r = player_class_color.r*0.8, g = player_class_color.g*0.8,   b = player_class_color.b*0.8, scale = 0.9, z = -12, x = -0.5, y = -0.8, anim = "SPELLS\WhiteRadiationFog.m2"}, -- class color
    [1] = {r = 0.8, g = 0, b = 0, scale = 0.8, z = -12, x = 0.8, y = -1.7, anim = "SPELLS\\RedRadiationFog.m2"}, -- red
    [2] = {r = 0.2, g = 0.8, b = 0, scale = 0.75, z = -12, x = 0, y = -1.1, anim = "SPELLS\\GreenRadiationFog.m2"}, -- green
    [3] = {r = 0, g = 0.35,   b = 0.9, scale = 0.75, z = -12, x = 1.2, y = -1, anim = "SPELLS\\BlueRadiationFog.m2"}, -- blue
    [4] = {r = 0.9, g = 0.7, b = 0.1, scale = 0.75, z = -12, x = -0.3, y = -1.2, anim = "SPELLS\\OrangeRadiationFog.m2"}, -- yellow
    [5] = {r = 0.1, g = 0.8,   b = 0.7, scale = 0.9, z = -12, x = -0.5, y = -0.8, anim = "SPELLS\\WhiteRadiationFog.m2"}, -- runic
  }
  
  local galaxytab = {
    [0] = {r = player_class_color.r, g = player_class_color.g, b = player_class_color.b, }, -- class color
    [1] = {r = 0.90, g = 0.1, b = 0.1, }, -- red
    [2] = {r = 0.25, g = 0.9, b = 0.25, }, -- green
    [3] = {r = 0, g = 0.35,   b = 0.9, }, -- blue
    [4] = {r = 0.9, g = 0.8, b = 0.35, }, -- yellow
    [5] = {r = 0.35, g = 0.9,   b = 0.9, }, -- runic
  }
  
  ------------------------------------------------------
  -- / CHAT OUTPUT FUNC / --
  ------------------------------------------------------
  
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end
  
  ------------------------------------------------------
  -- / SET AUTO MANA / --
  ------------------------------------------------------
  
  local function set_automana()
    if rBottomBarStyler.automana == 1 then
      local st = GetShapeshiftForm()
      local _, pt = UnitClass("player")
      if pt == "WARRIOR" then
        rBottomBarStyler.manaorb = 1
      elseif pt == "DEATHKNIGHT" then
        rBottomBarStyler.manaorb = 5
      elseif pt == "ROGUE" then
        rBottomBarStyler.manaorb = 4
      elseif pt == "DRUID" and st == 3 then
        rBottomBarStyler.manaorb = 4
      elseif pt == "DRUID" and st == 1 then
        rBottomBarStyler.manaorb = 1
      else
        rBottomBarStyler.manaorb = 3
      end
    end
  end

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
    if(not rBottomBarStyler.healthorb) then 
      rBottomBarStyler.healthorb = default_healthorb 
    end
    if(not rBottomBarStyler.manaorb) then 
      rBottomBarStyler.manaorb = default_manaorb 
    end
    if(not rBottomBarStyler.automana) then 
      rBottomBarStyler.automana = default_automana 
    end    
    
    set_automana()
    
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
  -- / SET ME GLOWS / --
  ------------------------------------------------------
  
  local function set_the_hglows()
    hfill:SetVertexColor(orbtab[rBottomBarStyler.healthorb].r,orbtab[rBottomBarStyler.healthorb].g,orbtab[rBottomBarStyler.healthorb].b)
    if usegalaxy == 1 then
      hgal1.t:SetVertexColor(galaxytab[rBottomBarStyler.healthorb].r,galaxytab[rBottomBarStyler.healthorb].g,galaxytab[rBottomBarStyler.healthorb].b)
      hgal2.t:SetVertexColor(galaxytab[rBottomBarStyler.healthorb].r,galaxytab[rBottomBarStyler.healthorb].g,galaxytab[rBottomBarStyler.healthorb].b)
      hgal3.t:SetVertexColor(galaxytab[rBottomBarStyler.healthorb].r,galaxytab[rBottomBarStyler.healthorb].g,galaxytab[rBottomBarStyler.healthorb].b)
    else
      hglow1:SetModel(orbtab[rBottomBarStyler.healthorb].anim)
      hglow1:SetModelScale(orbtab[rBottomBarStyler.healthorb].scale)
      hglow1:SetPosition(orbtab[rBottomBarStyler.healthorb].z, orbtab[rBottomBarStyler.healthorb].x, orbtab[rBottomBarStyler.healthorb].y) 
      hglow2:SetModel(orbtab[rBottomBarStyler.healthorb].anim)
      hglow2:SetModelScale(orbtab[rBottomBarStyler.healthorb].scale)
      hglow2:SetPosition(orbtab[rBottomBarStyler.healthorb].z, orbtab[rBottomBarStyler.healthorb].x, orbtab[rBottomBarStyler.healthorb].y+1) 
    end
  end

  local function set_the_mglows()
    mfill:SetVertexColor(orbtab[rBottomBarStyler.manaorb].r,orbtab[rBottomBarStyler.manaorb].g,orbtab[rBottomBarStyler.manaorb].b)
    if usegalaxy == 1 then
      mgal1.t:SetVertexColor(galaxytab[rBottomBarStyler.manaorb].r,galaxytab[rBottomBarStyler.manaorb].g,galaxytab[rBottomBarStyler.manaorb].b)
      mgal2.t:SetVertexColor(galaxytab[rBottomBarStyler.manaorb].r,galaxytab[rBottomBarStyler.manaorb].g,galaxytab[rBottomBarStyler.manaorb].b)
      mgal3.t:SetVertexColor(galaxytab[rBottomBarStyler.manaorb].r,galaxytab[rBottomBarStyler.manaorb].g,galaxytab[rBottomBarStyler.manaorb].b)
    else
      mglow1:SetModel(orbtab[rBottomBarStyler.manaorb].anim)
      mglow1:SetModelScale(orbtab[rBottomBarStyler.manaorb].scale)
      mglow1:SetPosition(orbtab[rBottomBarStyler.manaorb].z, orbtab[rBottomBarStyler.manaorb].x, orbtab[rBottomBarStyler.manaorb].y) 
      mglow2:SetModel(orbtab[rBottomBarStyler.manaorb].anim)
      mglow2:SetModelScale(orbtab[rBottomBarStyler.manaorb].scale)
      mglow2:SetPosition(orbtab[rBottomBarStyler.manaorb].z, orbtab[rBottomBarStyler.manaorb].x, orbtab[rBottomBarStyler.manaorb].y+1) 
    end
  end

  local function set_the_shapeshift_mglows()
    local st = GetShapeshiftForm()
    if st ~= save_dudustance then
      mfill:SetVertexColor(orbtab[rBottomBarStyler.manaorb].r,orbtab[rBottomBarStyler.manaorb].g,orbtab[rBottomBarStyler.manaorb].b)
      if usegalaxy == 1 then
        mgal1.t:SetVertexColor(galaxytab[rBottomBarStyler.manaorb].r,galaxytab[rBottomBarStyler.manaorb].g,galaxytab[rBottomBarStyler.manaorb].b)
        mgal2.t:SetVertexColor(galaxytab[rBottomBarStyler.manaorb].r,galaxytab[rBottomBarStyler.manaorb].g,galaxytab[rBottomBarStyler.manaorb].b)
        mgal3.t:SetVertexColor(galaxytab[rBottomBarStyler.manaorb].r,galaxytab[rBottomBarStyler.manaorb].g,galaxytab[rBottomBarStyler.manaorb].b)
      else
        mglow1:SetModel(orbtab[rBottomBarStyler.manaorb].anim)
        mglow1:SetModelScale(orbtab[rBottomBarStyler.manaorb].scale)
        mglow1:SetPosition(orbtab[rBottomBarStyler.manaorb].z, orbtab[rBottomBarStyler.manaorb].x, orbtab[rBottomBarStyler.manaorb].y) 
        mglow2:SetModel(orbtab[rBottomBarStyler.manaorb].anim)
        mglow2:SetModelScale(orbtab[rBottomBarStyler.manaorb].scale)
        mglow2:SetPosition(orbtab[rBottomBarStyler.manaorb].z, orbtab[rBottomBarStyler.manaorb].x, orbtab[rBottomBarStyler.manaorb].y+1) 
      end
      save_dudustance = st
    end
  end

  ------------------------------------------------------
  -- / CREATE ME A ORB GLOW FUNC / --
  ------------------------------------------------------

  local function create_me_a_orb_glow(f,useorb,pos)
    local glow = CreateFrame("PlayerModel", nil, f)
    glow:SetFrameStrata("BACKGROUND")
    glow:SetFrameLevel(5)
    glow:SetAllPoints(f)
    glow:SetModel(orbtab[useorb].anim)
    glow:SetModelScale(orbtab[useorb].scale)
    glow:SetPosition(orbtab[useorb].z, orbtab[useorb].x, orbtab[useorb].y+pos) 
    glow:SetAlpha(1/fog_smoother)
    glow:SetScript("OnShow",function() 
      glow:SetModel(orbtab[useorb].anim)
      glow:SetModelScale(orbtab[useorb].scale)
      glow:SetPosition(orbtab[useorb].z, orbtab[useorb].x, orbtab[useorb].y+pos) 
    end)
    return glow
  end
  
  ------------------------------------------------------
  -- / CREATE ME A ORB GALAXY FUNC / --
  ------------------------------------------------------
  local function create_me_a_galaxy(f,x,y,size,alpha,dur,tex,useorb)
    local h = CreateFrame("Frame",nil,f)
    h:SetHeight(size)
    h:SetWidth(size)		  
    h:SetPoint("CENTER",x,y-10)
    h:SetAlpha(alpha)
    h:SetFrameLevel(5)
  
    local t = h:CreateTexture()
    t:SetAllPoints(h)
    t:SetTexture("Interface\\AddOns\\rBottomBarStyler\\orbtex\\"..tex)
    t:SetBlendMode("ADD")
    t:SetVertexColor(galaxytab[useorb].r,galaxytab[useorb].g,galaxytab[useorb].b)
    h.t = t
    
    local ag = h:CreateAnimationGroup()
    h.ag = ag
    
    local a1 = h.ag:CreateAnimation("Rotation")
    a1:SetDegrees(360)
    a1:SetDuration(dur)
    h.ag.a1 = a1
    
    h:SetScript("OnUpdate",function(self,elapsed)
      local t = self.total
      if (not t) then
        self.total = 0
        return
      end
      t = t + elapsed
      if (t<1) then
        self.total = t
        return
      else
        h.ag:Play()
      end
    end)
    
    return h
  
  end

  ------------------------------------------------------
  -- / CREATE ME A FRAME FUNC / --
  ------------------------------------------------------

  local function create_me_a_frame(fart,fname,fparent,fstrata,flevel,fwidth,fheight,fanchor,fxpos,fypos,fscale,fdrag,finherit)
    --  PARENT, BACKGROUND, LOW, MEDIUM, HIGH, DIALOG, FULLSCREEN, FULLSCREEN_DIALOG, TOOLTIP 
    local f = CreateFrame(fart,fname,fparent,finherit)
    f:SetFrameStrata(fstrata)
    f:SetFrameLevel(flevel)
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
    -- BACKGROUND, BORDER, ARTWORK, OVERLAY, HIGHLIGHT
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
  -- / DO FORMAT / --
  ------------------------------------------------------

  local function do_format(v)
    local string = ""
    if v > 1000000 then
      string = (floor((v/1000000)*10)/10).."m"
    elseif v > 1000 then
      string = (floor((v/1000)*10)/10).."k"
    else
      string = v
    end  
    return string
  end

  ------------------------------------------------------
  -- / ORB HEALTH FUNC / --
  ------------------------------------------------------
  
  local function orbhealth(orb1,orb1_fill,glow1,glow2,orbtext1,orbtext2)
    orb1:SetScript("OnEvent", function(self, event, arg1, ...)
      if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or arg1 == "player" then      
        local uh, uhm = UnitHealth("player"), UnitHealthMax("player")
        local perc = floor(uh/uhm*100)
        local nuh = do_format(uh)
        local nuhm = do_format(uhm)
        orbtext1:SetText(perc)
        if text_display == 1 then
          orbtext2:SetText(nuh)
        else
          orbtext2:SetText(nuh.."/"..nuhm)
        end
        orb1_fill:SetHeight((uh/uhm) * orb1_fill:GetWidth())
        orb1_fill:SetTexCoord(0,1,  math.abs(uh/uhm - 1),1)
        
        if usegalaxy == 1 then
          hgal1:SetAlpha(uh / uhm)
          hgal2:SetAlpha(uh / uhm)
          hgal3:SetAlpha(uh / uhm)
        else
          glow1:SetAlpha((uh / uhm)/fog_smoother)
          glow2:SetAlpha((uh / uhm)/fog_smoother)
        end
      end
    end)
    orb1:RegisterEvent("UNIT_HEALTH")
    orb1:RegisterEvent("PLAYER_LOGIN")
    orb1:RegisterEvent("PLAYER_ENTERING_WORLD")
  end
  
  ------------------------------------------------------
  -- / ORB MANA FUNC / --
  ------------------------------------------------------
  
  local function orbmana(orb2,orb2_fill,glow1,glow2,orbtext1,orbtext2)
    orb2:SetScript("OnEvent", function(self, event, arg1, ...)
      if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or arg1 == "player" then      
        local um, umm = UnitMana("player"), UnitManaMax("player")
        local perc = floor(um/umm*100)
        local nuh = do_format(um)
        local nuhm = do_format(umm)
        local _, class = UnitClass("player")
        local shape = GetShapeshiftForm()    
        if text_display == 1 then
          if class == "WARRIOR" or (class == "DRUID" and shape == 3) or (class == "DRUID" and shape == 1) or class == "DEATHKNIGHT" or class == "ROGUE" then
            orbtext1:SetText(nuh)
            orbtext2:SetText(perc)
          else
            orbtext1:SetText(perc)
            orbtext2:SetText(nuh)            
          end
        else
          orbtext1:SetText(perc)
          orbtext2:SetText(nuh.."/"..nuhm)
        end
        orb2_fill:SetHeight((um/umm) * orb2_fill:GetWidth())
        orb2_fill:SetTexCoord(0,1,  math.abs(um/umm - 1),1)
        
        if usegalaxy == 1 then
          mgal1:SetAlpha(um / umm)
          mgal2:SetAlpha(um / umm)
          mgal3:SetAlpha(um / umm)
        else
          glow1:SetAlpha((um / umm)/fog_smoother)
          glow2:SetAlpha((um / umm)/fog_smoother)
        end
      end
    end)
    orb2:RegisterEvent("UNIT_POWER")
    orb2:RegisterEvent("UNIT_MAXPOWER")
    orb2:RegisterEvent("PLAYER_ENTERING_WORLD")
    orb2:RegisterEvent("PLAYER_LOGIN")
  end
  
  ------------------------------------------------------
  -- / SET ME A FONT / --
  ------------------------------------------------------
  
  local function set_me_a_font(f, font, size, style)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(font, size, style)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end
  
  ------------------------------------------------------
  -- / CREATE ORB FUNC / --
  ------------------------------------------------------
  
  local function create_orb(orbtype,orbsize,orbanchorframe,orbpoint,orbposx,orbposy,orbscale,orbfilltex,useorb)
    --create the player frame
    local orbname = "rBBSManaOrb"
    if orbtype == "life" then
      orbname = "rBBSLifeOrb"
    end
    local orb1 = create_me_a_frame("Button",orbname,orbanchorframe,"BACKGROUND",4,orbsize,orbsize,orbpoint,orbposx,orbposy,orbscale,nil,"SecureUnitButtonTemplate")
    orb1:RegisterForClicks("AnyUp")
    orb1:SetAttribute("unit", "player")
    orb1:SetAttribute("*type1", "target")
    local showmenu = function() 
      ToggleDropDownMenu(1, nil, PlayerFrameDropDown, "cursor", 0, 0) 
    end
    orb1.showmenu = showmenu
    orb1.unit = "player"
    orb1:SetAttribute("*type2", "showmenu")
    orb1:SetScript("OnEnter", UnitFrame_OnEnter)
    orb1:SetScript("OnLeave", UnitFrame_OnLeave)
    
    ClickCastFrames = ClickCastFrames or {}
    ClickCastFrames[orb1] = true

    local orb1_back = create_me_a_texture(orb1,"BORDER","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_back2")
    local orb1_fill = create_me_a_texture(orb1,"ARTWORK","Interface\\AddOns\\rBottomBarStyler\\orbtex\\"..orbfilltex,"fill")
    --glows
    local glow1, glow2
    if orbtype == "life" then
      orb1_fill:SetVertexColor(orbtab[useorb].r,orbtab[useorb].g,orbtab[useorb].b)
      hfill = orb1_fill
      if usegalaxy == 1 then
        hgal1 = create_me_a_galaxy(orb1,0,15,110,1,35,"galaxy2",useorb)
        hgal2 = create_me_a_galaxy(orb1,0,-10,150,1,45,"galaxy",useorb)
        hgal3 = create_me_a_galaxy(orb1,-10,-10,130,1,18,"galaxy3",useorb)
      else
        glow1 = create_me_a_orb_glow(orb1,useorb,0)
        glow2 = create_me_a_orb_glow(orb1,useorb,1)
        hglow1 = glow1
        hglow2 = glow2
      end
    else
      orb1_fill:SetVertexColor(orbtab[useorb].r,orbtab[useorb].g,orbtab[useorb].b)
      mfill = orb1_fill
      if usegalaxy == 1 then
        mgal1 = create_me_a_galaxy(orb1,0,10,110,1,40,"galaxy2",useorb)
        mgal2 = create_me_a_galaxy(orb1,-10,-10,150,1,50,"galaxy",useorb)
        mgal3 = create_me_a_galaxy(orb1,10,-10,130,1,20,"galaxy3",useorb)
      else
        glow1 = create_me_a_orb_glow(orb1,useorb,0)
        glow2 = create_me_a_orb_glow(orb1,useorb,1)
        mglow1 = glow1
        mglow2 = glow2
      end
    end
    local orb1_glossholder = create_me_a_frame("Frame",nil,orb1,"BACKGROUND",6,orbsize,orbsize,"BOTTOM",0,0,1)
    local orb1_gloss = create_me_a_texture(orb1_glossholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\orbtex\\orb_gloss")
    local orbtext1 = set_me_a_font(orb1_glossholder, default_font, orbsize/5.5, "THINOUTLINE")
    orbtext1:SetPoint("CENTER", 0, (orbsize/12))
    orbtext1:SetTextColor(1,1,1)
    local orbtext2 = set_me_a_font(orb1_glossholder, default_font, orbsize/9, "THINOUTLINE")
    orbtext2:SetPoint("CENTER", 0, -(orbsize/12))
    orbtext2:SetTextColor(0.6,0.6,0.6)
    if orbtype == "life" then
      orbhealth(orb1,orb1_fill,glow1,glow2,orbtext1,orbtext2)
    else
      orbmana(orb1,orb1_fill,glow1,glow2,orbtext1,orbtext2)
      --druid mana color on stance
      local _, pt = UnitClass("player")
      if pt == "DRUID" then
        orb1_glossholder:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
        orb1_glossholder:RegisterEvent("PLAYER_LOGIN")
        orb1_glossholder:SetScript("OnEvent", function(self,event)
          if event == "UPDATE_SHAPESHIFT_FORM" then
            set_automana()
            set_the_shapeshift_mglows()
          end
        end)
      end
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
    elseif rBottomBarStyler.artvalue == "d3" then
      bar_to_show:SetTexture("Interface\\AddOns\\rBottomBarStyler\\d3tex\\"..rBottomBarStyler.barvalue)
    elseif rBottomBarStyler.artvalue == "d3no" then
      bar_to_show:SetTexture("Interface\\AddOns\\rBottomBarStyler\\d3tex\\"..rBottomBarStyler.barvalue)
    else
      am("Does only work for roth or d3 layout")
    end
  end 

  ------------------------------------------------------
  -- / CREATE D1 STYLE / --
  ------------------------------------------------------  
  local function create_d1_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",1,100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",2,1024,256,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d1tex\\bar")
    --orbs
    create_orb("life",160,holder,"BOTTOM",-290,120,1,"orb_filling8",rBottomBarStyler.healthorb)
    create_orb("mana",160,holder,"BOTTOM",285,120,1,"orb_filling8",rBottomBarStyler.manaorb)
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,256,256,"BOTTOM",-320,35,0.9)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d1tex\\figure_left")
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,256,256,"BOTTOM",320,35,0.9)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d1tex\\figure_right")
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",1,100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe  
  end

  ------------------------------------------------------
  -- / CREATE D2 STYLE / --
  ------------------------------------------------------  
  local function create_d2_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",1,100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder        
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",8,1024,128,"BOTTOM",0,44,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\bar")
    --border
    local border_left = create_me_a_frame("Frame",nil,holder,"BACKGROUND",3,1024,512,"BOTTOMRIGHT",-40,0,1)
    local border_left_tex = create_me_a_texture(border_left,"BORDER","Interface\\AddOns\\rBottomBarStyler\\d2tex\\border_left")
    local border_right = create_me_a_frame("Frame",nil,holder,"BACKGROUND",3,1024,512,"BOTTOMLEFT",40,0,1)
    local border_right_tex = create_me_a_texture(border_right,"BORDER","Interface\\AddOns\\rBottomBarStyler\\d2tex\\border_right")
    --orbs
    create_orb("life",160,holder,"BOTTOM",-472,55,1,"orb_filling8",rBottomBarStyler.healthorb)
    create_orb("mana",160,holder,"BOTTOM",465,55,1,"orb_filling8",rBottomBarStyler.manaorb)
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,256,256,"BOTTOM",-453,44,1)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\figure_left")
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,256,256,"BOTTOM",453,44,1)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d2tex\\figure_right")
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",1,100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe      
  end
  
  ------------------------------------------------------
  -- / CREATE D3 STYLE (ADAPTED) / --
  ------------------------------------------------------  
  local function create_d3_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",1,100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",2,1024,512,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\"..rBottomBarStyler.barvalue)
    bar_to_show = bar_tex   
    --orbs
    create_orb("life",200,holder,"BOTTOM",-525,-6,1,"orb_filling8",rBottomBarStyler.healthorb)
    create_orb("mana",200,holder,"BOTTOM",525,-6,1,"orb_filling8",rBottomBarStyler.manaorb)
    --xp
    local xpholder = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,1178,32,"BOTTOM",0,104,1)
    local xpholder_tex = create_me_a_texture(xpholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\xpbar")
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,512,256,"BOTTOM",-520,0,1)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\figure_left")
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,512,256,"BOTTOM",522,0,1)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\figure_right")
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",1,100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe      
  end
  
  ------------------------------------------------------
  -- / CREATE D3 NO ORB STYLE / --
  ------------------------------------------------------  
  local function create_d3no_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",1,100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    --bgframe
    local bg = create_me_a_frame("Frame",nil,holder,"BACKGROUND",1,1050,115,"BOTTOM",0,0,1)
    local bg_tex = create_me_a_texture(bg,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\bg")
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",2,1024,512,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\"..rBottomBarStyler.barvalue)
    bar_to_show = bar_tex   
    --xp
    local xpholder = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,1178,32,"BOTTOM",0,104,1)
    local xpholder_tex = create_me_a_texture(xpholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\xpbar")
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,512,256,"BOTTOM",-390,0,1)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\figure_left2")
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,512,256,"BOTTOM",380,0,1)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\d3tex\\figure_right2")
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",1,100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe      
  end
  
  ------------------------------------------------------
  -- / CREATE ROTH STYLE / --
  ------------------------------------------------------  
  local function create_roth_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",1,100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",2,512,256,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\"..rBottomBarStyler.barvalue)
    bar_to_show = bar_tex    
    --orbs
    create_orb("life",150,holder,"BOTTOM",-260,-8,1,"orb_filling8",rBottomBarStyler.healthorb)
    create_orb("mana",150,holder,"BOTTOM",260,-8,1,"orb_filling8",rBottomBarStyler.manaorb)    
    --bottom
    local bottom = create_me_a_frame("Frame",nil,holder,"BACKGROUND",9,510,110,"BOTTOM",0,-5,1)
    local bottom_tex = create_me_a_texture(bottom,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\bottom")    
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,512,256,"BOTTOM",-400,0,0.65)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\figure_left")    
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,512,256,"BOTTOM",410,0,0.65)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\rothtex\\figure_right")    
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",1,100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe      
  end  
  
  ------------------------------------------------------
  -- / CREATE AION STYLE / --
  ------------------------------------------------------  
  local function create_aion_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",1,100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",2,512,128,"BOTTOM",0,10,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\aiontex\\bar")
    --orbs
    create_orb("life",125,holder,"BOTTOM",-245,20,1,"orb_filling8",rBottomBarStyler.healthorb)
    create_orb("mana",125,holder,"BOTTOM",245,20,1,"orb_filling8",rBottomBarStyler.manaorb)
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,256,256,"BOTTOM",-250,-40,1)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\aiontex\\figure_left")
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",7,256,256,"BOTTOM",250,-40,1)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\aiontex\\figure_right")
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",1,100,100,"BOTTOM",0,0,scale,true)
    frame_to_drag = dragframe      
  end
  
  ------------------------------------------------------
  -- / CREATE AION2 STYLE provided by Dawn / --
  ------------------------------------------------------  
  local function create_aion2_style(scale)
    --holder
    local holder = create_me_a_frame("Frame","rBBS_Holder",UIParent,"BACKGROUND",1,100,100,"BOTTOM",0,0,scale)
    frame_to_scale = holder    
    --bar texture
    local bar = create_me_a_frame("Frame",nil,holder,"BACKGROUND",1,1440,360,"BOTTOM",0,0,1)
    local bar_tex = create_me_a_texture(bar,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\aion2tex\\bar")
    --xpBG
    local xpholderbg = create_me_a_frame("Frame",nil,holder,"BACKGROUND",1,1024,64,"BOTTOM",0,0,1)
    local xpholderbg_tex = create_me_a_texture(xpholderbg,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\aion2tex\\xpbarBG")
    --xp
    local xpholder = create_me_a_frame("Frame",nil,holder,"BACKGROUND",8,1024,64,"BOTTOM",0,0,1)
    local xpholder_tex = create_me_a_texture(xpholder,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\aion2tex\\xpbar")
    --orbs
    create_orb("life",180,holder,"BOTTOM",-590,100,1,"orb_filling5",rBottomBarStyler.healthorb)
    create_orb("mana",180,holder,"BOTTOM",590,100,1,"orb_filling5",rBottomBarStyler.manaorb)
    --left figure
    local lefty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",10,386,386,"BOTTOM",-585,3,1)
    local lefty_tex = create_me_a_texture(lefty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\aion2tex\\figure_left")
    --right figure
    local righty = create_me_a_frame("Frame",nil,holder,"BACKGROUND",10,386,386,"BOTTOM",585,3,1)
    local righty_tex = create_me_a_texture(righty,"BACKGROUND","Interface\\AddOns\\rBottomBarStyler\\aion2tex\\figure_right")
    --dragframe
    local dragframe = create_me_a_frame("Frame",nil,holder,"TOOLTIP",1,100,100,"BOTTOM",0,0,scale,true)
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
    elseif style == "aion" then
      create_aion_style(scale)
    elseif style == "aion2" then
      create_aion2_style(scale)
    elseif style == "d3no" then
      create_d3no_style(scale)
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
        if c == "d1" or c == "d2" or c == "d3" or c == "d3no" or c == "roth" or c == "aion" or c == "aion2" then
          am("You set the art to: "..c)
          rBottomBarStyler.artvalue = c
          am("You need to reoad the interface to see the changes.")
          am("Type in: \"/console reloadui\".")
        else
          am("Wrong value. (possible values: d1, d2, d3, d3no, roth, aion, aion2)")
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
    --healthorb
    elseif (cmd:match"sethealthorb") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if tonumber(c) and tonumber(c) >= 0 and tonumber(c) < 6 then
          am("Healthorb is set to: "..c)
          rBottomBarStyler.healthorb = tonumber(c)
          set_the_hglows()
        else
          am("No number value.")
        end
      else
        am("No value found.")
      end
    --manaorb
    elseif (cmd:match"setmanaorb") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if tonumber(c) and tonumber(c) > 0 and tonumber(c) < 6  then
          am("Manaorb is set to: "..c)
          if rBottomBarStyler.automana == 1 then
            am("Automana is active. Not possible, deactivate automana first.")
          else
            rBottomBarStyler.manaorb = tonumber(c)
            set_the_mglows()
          end
        else
          am("No number value.")
        end
      else
        am("No value found.")
      end  
    --automana
    elseif (cmd:match"setautomana") then
      local a,b = strfind(cmd, " ");
      if b then
        local c = strsub(cmd, b+1)
        if tonumber(c) then
          am("Automana is set to: "..c)
          rBottomBarStyler.automana = tonumber(c)
          set_automana()
          set_the_mglows()
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
      am("\/rbbs setart STRING (possible values: d1, d2, d3, d3no, roth, aion, aion2)")
      am("\/rbbs setbar STRING (possible values: bar1, bar2, bar3 - only affects the roth, d3 or d3no layout)")
      am("\/rbbs locked NUMBER (value of 1 locks bars, 0 unlocks)")
      am("\/rbbs movable NUMBER (value of 1 makes bars movable if unlocked, value of 0 will reset position)")
 
      am("\/rbbs sethealthorb NUMBER (values 0 (classcolor), 1 (red), 2 (green), 3 (blue), 4 (yellow), 5(runic) to set your healthcolor)")
      am("\/rbbs setmanaorb NUMBER (values 1 (red), 2 (green), 3 (blue), 4 (yellow), 5(runic) to set your manacolor)")
      am("\/rbbs setautomana NUMBER (values 0 or 1, this will override the manaorb setting and automatically detect your manacolor on class/stance)")
      
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
  
  -- // oUF tutorial layout
  -- // zork - 2010
  
  -----------------------------
  -- INIT
  -----------------------------
  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg
  
  --holder for some lib functions
  local lib = CreateFrame("Frame")  
    
  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  --backdrop table
  local backdrop_tab = { 
    bgFile = cfg.backdrop_texture, 
    edgeFile = cfg.backdrop_edge_texture,
    tile = false,
    tileSize = 0, 
    edgeSize = 5, 
    insets = { 
      left = 5, 
      right = 5, 
      top = 5, 
      bottom = 5,
    },
  }
  
  --backdrop func
  lib.gen_backdrop = function(f)
    f:SetBackdrop(backdrop_tab);
    f:SetBackdropColor(0,0,0,0.7)
    f:SetBackdropBorderColor(0,0,0,1)
  end
  
  lib.menu = function(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("(.)", string.upper, 1)
    if(unit == "party" or unit == "partypet") then
      ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
      ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
  end
  
  --moveme func
  lib.moveme = function(f)
    if cfg.allow_frame_movement then
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not cfg.frames_locked then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:StartMoving() end end)
        f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
      end
    else
      f:IsUserPlaced(false)
    end  
  end  
  
  --init func
  lib.init = function(f)
    f:SetAttribute("initial-height", f.height)
    f:SetAttribute("initial-width", f.width)
    f:SetAttribute("initial-scale", f.scale)
    f:SetPoint("CENTER",UIParent,"CENTER",0,0)
    f.menu = lib.menu
    f:RegisterForClicks("AnyUp")
    f:SetAttribute("*type2", "menu")
    f:SetScript("OnEnter", UnitFrame_OnEnter)
    f:SetScript("OnLeave", UnitFrame_OnLeave)
  end  
  
  --fontstring func
  lib.gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end  
  
  --gen healthbar func
  lib.gen_hpbar = function(f)
    --statusbar
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetHeight(f.height)
    s:SetWidth(f.width)
    s:SetPoint("CENTER",0,0)
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.statusbar_texture)
    b:SetAllPoints(s)
    f.Health = s
    f.Health.bg = b
  end
  
  --gen hp strings func
  lib.gen_hpstrings = function(f)
    --health/name text strings
    local name = lib.gen_fontstring(f.Health, cfg.font, 13, "THINOUTLINE")
    name:SetPoint("LEFT", f.Health, "LEFT", 2, 0)
    name:SetJustifyH("LEFT")
    
    local hpval = lib.gen_fontstring(f.Health, cfg.font, 13, "THINOUTLINE")
    hpval:SetPoint("RIGHT", f.Health, "RIGHT", -2, 0)
    --this will make the name go "..." when its to long
    name:SetPoint("RIGHT", hpval, "LEFT", -5, 0)
    
    f:Tag(name, "[name]")
    f:Tag(hpval, "[curhp]/[perhp]%")
  end
  
  --gen healthbar func
  lib.gen_ppbar = function(f)
    --statusbar
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetHeight(f.height/5)
    s:SetWidth(f.width)
    s:SetPoint("TOP",f,"BOTTOM",0,-3)
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.statusbar_texture)
    b:SetAllPoints(s)
    f.Power = s
    f.Power.bg = b
  end
  
  --gen castbar
  lib.gen_castbar = function(f)
  
    local s = CreateFrame("StatusBar", "oUF_SimpleCastbar"..f.mystyle, f)
    s:SetHeight(f.height)
    s:SetWidth(f.width)
    if f.mystyle == "player" then
      lib.moveme(s)
      s:SetPoint("CENTER",UIParent,0,-50)
    elseif f.mystyle == "target" then
      lib.moveme(s)
      s:SetPoint("CENTER",UIParent,0,0)
    else
      s:SetPoint("BOTTOM",f,"TOP",0,5)
    end
    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetStatusBarColor(1,0.8,0,1)
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
    
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.statusbar_texture)
    b:SetAllPoints(s)
    b:SetVertexColor(1*0.3,0.8*0.3,0,0.7)  
    
    local txt = lib.gen_fontstring(s, cfg.font, 13, "THINOUTLINE")
    txt:SetPoint("LEFT", 2, 0)
    txt:SetJustifyH("LEFT")
    --time
    local t = lib.gen_fontstring(s, cfg.font, 13, "THINOUTLINE")
    t:SetPoint("RIGHT", -2, 0)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
    
    --icon
    local i = s:CreateTexture(nil, "ARTWORK")
    i:SetWidth(f.height)
    i:SetHeight(f.height)
    i:SetPoint("RIGHT", s, "LEFT", -5, 0)
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    --helper2 for icon
    local h2 = CreateFrame("Frame", nil, s)
    h2:SetFrameLevel(0)
    h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
    h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h2)
    
    if f.mystyle == "player" then
      --latency only for player unit
      local z = s:CreateTexture(nil,"OVERLAY")
      z:SetTexture(cfg.statusbar_texture)
      z:SetVertexColor(0.6,0,0,0.6)
      z:SetPoint("TOPRIGHT")
      z:SetPoint("BOTTOMRIGHT")
      s.SafeZone = z
    end
    
    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
  end
  
  lib.gen_portrait = function(f)
    local p = CreateFrame("PlayerModel", nil, f)
    p:SetWidth(f.height*3)
    p:SetHeight(f.height*2)
    if f.mystyle == "target" then
      p:SetPoint("TOPLEFT", f, "TOPRIGHT", 5, 0)
    else
      p:SetPoint("TOPRIGHT", f, "TOPLEFT", -5, 0)
    end
    
    --helper
    local h = CreateFrame("Frame", nil, p)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
  
    f.Portrait = p
  end
  
  lib.PostCreateIcon = function(self, button)
    button.cd:SetReverse()
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.icon:SetDrawLayer("BACKGROUND")
    --count
    button.count:ClearAllPoints()
    button.count:SetJustifyH("RIGHT")
    button.count:SetPoint("TOPRIGHT", 2, 2)
    button.count:SetTextColor(0.7,0.7,0.7)
    --helper
    local h = CreateFrame("Frame", nil, button)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h)
  end
  
  lib.createBuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.size = 20
    if f.mystyle == "target" then
      b.num = 40
    elseif f.mystyle == "player" then
      b.num = 10
      b.onlyShowPlayer = true
    else
      b.num = 5
    end
    b.spacing = 5
    b.onlyShowPlayer = false
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f.width)
    b:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 5)
    b.initialAnchor = "BOTTOMLEFT"
    b["growth-x"] = "RIGHT"
    b["growth-y"] = "UP"
    b.PostCreateIcon = lib.PostCreateIcon
    f.Buffs = b
  end

  lib.createDebuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.size = 20
    if f.mystyle == "target" then
      b.num = 40
    elseif f.mystyle == "player" then
      b.num = 10
    else
      b.num = 5
    end
    b.spacing = 5
    b.onlyShowPlayer = false
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f.width)
    b:SetPoint("TOPLEFT", f.Power, "BOTTOMLEFT", 0, -5)
    b.initialAnchor = "TOPLEFT"
    b["growth-x"] = "RIGHT"
    b["growth-y"] = "DOWN"
    b.PostCreateIcon = lib.PostCreateIcon
    f.Debuffs = b
  end


  -- Rune bar function
  lib.addRuneBar = function(self, unit)

  if myclass == "DEATHKNIGHT" and unit == "player" then

    local t
    local bar = CreateFrame("Frame","oUF_D3Orbs_RuneBar",self)
    local NUM_RUNES = 6
    local w = 64*(num_runes+2)
    local h = 64
    bar:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    bar:SetWidth(w)
    bar:SetHeight(h)
    bar:SetScale(runebarscale)
    
    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("LEFT",0,0)
    t:SetTexture("Interface\\AddOns\\rTextures\\combo_left")
    bar.leftedge = t

    t = bar:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetSize(64,64)
    t:SetPoint("RIGHT",0,0)
    t:SetTexture("Interface\\AddOns\\rTextures\\combo_right")
    bar.rightedge = t
    
    bar.back = {}
    bar.filling = {}
    bar.glow = {}
    bar.gloss = {}
    
    for i = 1, NUM_RUNES do
    
      local back = "back"..i
      bar.back[i] = bar:CreateTexture(nil,"BACKGROUND",nil,-8)  
      bar.back[i]:SetSize(64,64)
      bar.back[i]:SetPoint("LEFT",i*64,0)
      bar.back[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_back")

      bar.filling[i] = CreateFrame("StatusBar", nil, bar)
      bar.filling[i]:SetSize(64,64)
      bar.filling[i]:SetPoint("LEFT",i*64,0)
      bar.filling[i]:SetStatusBarTexture("Interface\\AddOns\\rTextures\\combo_fill")
      --bar.filling[i]:SetBlendMode("ADD")
      
      bar.filling_bg[i] = bar.filling[i]:CreateTexture(nil,"BACKGROUND",nil,-7)  
      bar.filling_bg[i]:SetAllPoints(bar.filling[i])
      bar.filling_bg[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_fill")
      bar.filling_bg[i].multiplier = 0.3

      bar.glow[i] = bar.filling[i]:CreateTexture(nil,"BACKGROUND",nil,-6)  
      bar.glow[i]:SetSize(64*1.25,64*1.25)
      bar.glow[i]:SetPoint("CENTER", bar.filling[i], "CENTER", 0, 0)
      bar.glow[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_glow")
      bar.glow[i]:SetBlendMode("BLEND")
      --bar.glow[i]:SetVertexColor(combocolor.r,combocolor.g,combocolor.b,0.4)
      bar.glow[i]:Hide()

      bar.gloss[i] = bar.filling[i]:CreateTexture(nil,"BACKGROUND",nil,-5)  
      bar.gloss[i]:SetSize(64,64)
      bar.gloss[i]:SetPoint("LEFT",i*64,0)
      bar.gloss[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_highlight")
      bar.gloss[i]:SetBlendMode("ADD")

      self.Runes[i] = bar.filling[i]
      self.Runes[i].bg = bar.filling_bg[i]

    end
    
    self.RuneBar = bar
    
  end
end

  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the lib to the namespace for further usage...this is awesome because you can reuse functions in any of your layout files
  ns.lib = lib
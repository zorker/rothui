  
  --get the addon namespace
  local addon, ns = ...  

  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF  
  
  --get the config
  local cfg = ns.cfg  
  
  --object container
  local func = CreateFrame("Frame")
  
  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------
  
  --number format func
  func.numFormat = function(v)
    local string = ""
    if v > 1E6 then
      string = (floor((v/1E6)*10)/10).."m"
    elseif v > 1E3 then
      string = (floor((v/1E3)*10)/10).."k"
    else
      string = v
    end  
    return string
  end
  
  --format time func
  func.GetFormattedTime = function(time)
    local hr, m, s, text
    if time <= 0 then text = ""
    elseif(time < 3600 and time > 60) then
      hr = floor(time / 3600)
      m = floor(mod(time, 3600) / 60 + 1)
      text = format("%dm", m)
    elseif time < 60 then
      m = floor(time / 60)
      s = mod(time, 60)
      text = (m == 0 and format("%ds", s))
    else
      hr = floor(time / 3600 + 1)
      text = format("%dh", hr)
    end
    return text
  end
  
  --backdrop func
  func.createBackdrop = function(f)
    f:SetBackdrop(cfg.backdrop)
    f:SetBackdropColor(0,0,0,0.7)
    f:SetBackdropBorderColor(0,0,0,1)
  end
  
  func.menu = function(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("^%l", string.upper)
    if(cunit == "Vehicle") then  cunit = "Pet" end
    if(unit == "party" or unit == "partypet") then
      ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
      ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
  end
  
  --create castbar func
  func.createCastbar = function(f)
  
    c = CreateFrame("StatusBar", nil, UIParent)
    c:SetWidth(224)
    c:SetHeight(18)
    c:SetStatusBarTexture(f.cfg.castbar.texture)
    c:GetStatusBarTexture():SetHorizTile(true)
    c:SetScale(f.cfg.castbar.scale)
    c:SetPoint(f.cfg.castbar.pos.a1, f.cfg.castbar.pos.af, f.cfg.castbar.pos.a2, f.cfg.castbar.pos.x, f.cfg.castbar.pos.y)
    
    c.bg2 = c:CreateTexture(nil, "BACKGROUND",nil,-8)
    c.bg2:SetTexture("Interface\\AddOns\\rTextures\\d3_targetframe")
    c.bg2:SetWidth(512)
    c.bg2:SetHeight(128)
    c.bg2:SetPoint("CENTER",-3,0)
    
    c.bg = c:CreateTexture(nil, "BACKGROUND",nil,-7)
    c.bg:SetTexture(f.cfg.castbar.texture)
    c.bg:SetAllPoints(c)
    
    if f.cfg.style == "player" and f.cfg.castbar.classcolored then
      if f.cfg.castbar.swapcolors then
        c:SetStatusBarColor(0.17,0.15,0.15,0.97)
        c.bg:SetVertexColor(cfg.playercolor.r, cfg.playercolor.g, cfg.playercolor.b)        
      else
        c:SetStatusBarColor(cfg.playercolor.r, cfg.playercolor.g, cfg.playercolor.b)
        c.bg:SetVertexColor(cfg.playercolor.r*0.2, cfg.playercolor.g*0.2, cfg.playercolor.b*0.2)
      end
    else
      if f.cfg.castbar.swapcolors then
        c:SetStatusBarColor(0.17,0.15,0.15,0.97)
        c.bg:SetVertexColor(f.cfg.castbar.color.r,f.cfg.castbar.color.g,f.cfg.castbar.color.b)
      else
        c:SetStatusBarColor(f.cfg.castbar.color.r,f.cfg.castbar.color.g,f.cfg.castbar.color.b)
        c.bg:SetVertexColor(f.cfg.castbar.color.r*0.2,f.cfg.castbar.color.g*0.2,f.cfg.castbar.color.b*0.2)
      end
    end

    c.Text =  func.createFontString(c, cfg.font, 14, "THINOUTLINE")
    c.Text:SetPoint("LEFT", 3, 0)
    c.Text:SetPoint("RIGHT", -50, 0)
    c.Text:SetJustifyH("LEFT")
    
    c.Time =  func.createFontString(c, cfg.font, 14, "THINOUTLINE")
    c.Time:SetPoint("RIGHT", -2, 0)
    
    --icon
    c.Icon = c:CreateTexture(nil, "BACKGROUND",nil,-7)
    c.Icon:SetWidth(32)
    c.Icon:SetHeight(32)
    c.Icon:SetPoint("LEFT", -77, 0)
    c.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    c.IconBack = c:CreateTexture(nil, "BACKGROUND",nil,-8)
    c.IconBack:SetPoint("TOPLEFT",c.Icon,"TOPLEFT",-5,5)
    c.IconBack:SetPoint("BOTTOMRIGHT",c.Icon,"BOTTOMRIGHT",5,-5)
    c.IconBack:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_glow")
    c.IconBack:SetVertexColor(0, 0, 0, 1)
    
    c.IconOverlay = c:CreateTexture(nil, "BACKGROUND",nil,-6)
    c.IconOverlay:SetTexture("Interface\\AddOns\\rTextures\\gloss2")
    c.IconOverlay:SetVertexColor(0.37,0.3,0.3,1)
    c.IconOverlay:SetPoint("TOPLEFT", c.Icon, "TOPLEFT", -1, 1)
    c.IconOverlay:SetPoint("BOTTOMRIGHT", c.Icon, "BOTTOMRIGHT", 1, -1)  
    
    if f.cfg.style == "target" then
      --generate shield
      local shield = c:CreateTexture(nil, "BACKGROUND",nil,-8)
      shield:SetTexture("Interface\\AddOns\\rTextures\\d3_castshield")
      shield:SetWidth(512)
      shield:SetHeight(128)
      shield:SetPoint("CENTER",-3,0)
      shield:Hide()
      c.Shield = shield
    end
    
    --safezone
    if f.cfg.castbar.latency and f.cfg.style == "player" then
      c.SafeZone = c:CreateTexture(nil,"OVERLAY",nil,-8)
      c.SafeZone:SetTexture(f.cfg.castbar.texture)
      c.SafeZone:SetVertexColor(0.6,0,0,0.4)
      c.SafeZone:SetPoint("TOPRIGHT")
      c.SafeZone:SetPoint("BOTTOMRIGHT")
    end
    
    func.applyDragFunctionalityNoRestrict(c)
    
    f.Castbar = c    
  
  end
  
  --create buffs
  func.createBuffs = function(f)
    f.Buffs = CreateFrame("Frame", nil, f)
    if f.cfg.style == "player" then
      --hide blizzard stuff
      ConsolidatedBuffs:Hide()
      BuffFrame:Hide()
      TemporaryEnchantFrame:Hide()
      
      f.Buffs.size = f.cfg.auras.size
      f.Buffs.num = 40
      f.Buffs.spacing = 10
      f.Buffs:SetHeight((f.Buffs.size+f.Buffs.spacing)*4)
      f.Buffs:SetWidth((f.Buffs.size+f.Buffs.spacing)*10)
      f.Buffs:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -40, 2)
      f.Buffs.initialAnchor = "TOPRIGHT"
      f.Buffs["growth-x"] = "LEFT"
      f.Buffs["growth-y"] = "DOWN"
      f.Buffs.filter = "HELPFUL"
      --f.Buffs.showBuffType = true
      f.Buffs.disableCooldown = true
      f.Buffs.onlyShowPlayer = f.cfg.auras.onlyShowPlayerBuffs

    end
  end
  
  --create debuff func
  func.createDebuffs = function(f)
    f.Debuffs = CreateFrame("Frame", nil, f)
    if f.cfg.style == "player" then
      f.Debuffs.size = f.cfg.auras.size
      f.Debuffs.num = 40
      f.Debuffs.spacing = 10
      f.Debuffs:SetHeight((f.Debuffs.size+f.Debuffs.spacing)*4)
      f.Debuffs:SetWidth((f.Debuffs.size+f.Debuffs.spacing)*10)
      f.Debuffs:SetPoint("TOP", f.Buffs, "BOTTOM", 0, 0)
      f.Debuffs.initialAnchor = "TOPRIGHT"
      f.Debuffs["growth-x"] = "LEFT"
      f.Debuffs["growth-y"] = "DOWN"
      f.Debuffs.filter = "HARMFUL"
      f.Debuffs.showDebuffType = true
      f.Debuffs.disableCooldown = true
      f.Debuffs.onlyShowPlayer = f.cfg.auras.onlyShowPlayerDebuffs
    end
  end
  
  --fontstring func
  func.createFontString = function(f, font, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(font, size, outline)
    fs:SetShadowColor(0,0,0,1)
    return fs
  end 
  
  --allows frames to become movable but frames can be locked or set to default positions
  func.applyDragFunctionality = function(f)
    if not cfg.framesUserplaced then
      f:IsUserPlaced(false)
      return
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not cfg.framesLocked then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
        f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
      end
    end  
  end
  
  --allows frames to become movable in any case
  func.applyDragFunctionalityNoRestrict = function(f)
    f:SetMovable(true)
    f:SetUserPlaced(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton","RightButton")
    f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
  end
  
  --create icon func
  func.createIcon = function(f,layer,size,anchorframe,anchorpoint1,anchorpoint2,posx,posy,sublevel)
    local icon = f:CreateTexture(nil,layer,nil,sublevel)
    icon:SetSize(size,size)
    icon:SetPoint(anchorpoint1,anchorframe,anchorpoint2,posx,posy)
    return icon
  end
  
  ---------------------------------------------
  -- HANDOVER
  ---------------------------------------------
  
  --object container to addon namespace
  ns.func = func
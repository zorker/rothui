  
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
  
  --create debuff func
  func.createDebuffs = function(self)
    local f = CreateFrame("Frame", nil, self)
    f.size = self.cfg.auras.size
    if self.cfg.style == "targettarget" then
      f.num = 8
    else
      f.num = 4
    end
    f:SetHeight((f.size+5)*(f.num/4))
    f:SetWidth((f.size+5)*4)
    f:SetPoint("TOP", self, "BOTTOM", 2.5, 5)
    f.initialAnchor = "TOPLEFT"
    f["growth-x"] = "RIGHT"
    f["growth-y"] = "DOWN"
    f.spacing = 5
    f.showDebuffType = self.cfg.auras.showDebuffType
    f.onlyShowPlayer = self.cfg.auras.onlyShowPlayerDebuffs    
    self.Debuffs = f    
  end
  
  --aura icon func
  func.createAuraIcon = function(icons, button)
    local bw = button:GetWidth()
    --button.cd:SetReverse()
    button.cd:SetPoint("TOPLEFT", 1, -1)
    button.cd:SetPoint("BOTTOMRIGHT", -1, 1)
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    button.count:SetParent(button.cd)
    button.count:ClearAllPoints()
    button.count:SetPoint("TOPRIGHT", 4, 4)
    button.count:SetTextColor(0.9,0.9,0.9)
    --fix fontsize to be based on button size
    button.count:SetFont(cfg.font,bw/1.8,"THINOUTLINE")
    button.overlay:SetTexture("Interface\\AddOns\\rTextures\\gloss2")
    button.overlay:SetTexCoord(0,1,0,1)
    button.overlay:SetPoint("TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", 1, -1)
    button.overlay:SetVertexColor(0.4,0.35,0.35,1)
    button.overlay:Show()
    button.overlay.Hide = function() end    
    local back = button:CreateTexture(nil, "BACKGROUND")
    back:SetPoint("TOPLEFT",button.icon,"TOPLEFT",-0.18*bw,0.18*bw)
    back:SetPoint("BOTTOMRIGHT",button.icon,"BOTTOMRIGHT",0.18*bw,-0.18*bw)
    back:SetTexture("Interface\\AddOns\\rTextures\\simplesquare_glow")
    back:SetVertexColor(0, 0, 0, 1)    
  end
  
  --update health func
  func.updateHealth = function(bar, unit, min, max)
    local self = bar:GetParent()
    local d = floor(min/max*100)
    local color
    local dead
    if UnitIsDeadOrGhost(unit) == 1 or UnitIsConnected(unit) == nil then
      color = {r = 0.4, g = 0.4, b = 0.4}
      dead = 1
    elseif UnitIsPlayer(unit) then
      if RAID_CLASS_COLORS then
        color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
      end
    elseif unit == "pet" and UnitExists("pet") and GetPetHappiness() then
      local happiness = GetPetHappiness()
      color = cfg.happycolors[happiness]
      self.Name:SetText(UnitName(unit))
    else
      color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end


    if color then
      self.Name:SetTextColor(color.r, color.g, color.b,1)
      bar:SetStatusBarColor(0.15,0.15,0.15,1)
      bar.bg:SetVertexColor(0.8,0,0,0.9)
      --bar:SetStatusBarColor(color.r, color.g, color.b,1)
      --bar.bg:SetTexture(1,0,0,0)
    end

    if d <= 25 and min > 1 then
      self.Health.glow:SetVertexColor(1,0,0,1)
    else
      self.Health.glow:SetVertexColor(0,0,0,0.7)
      --self.Health.glow:SetVertexColor(1,0,0,1)
    end

    if dead == 1 then
      bar.bg:SetVertexColor(0,0,0,0)  
    end

  end
  
  --update power func
  func.updatePower = function(bar, unit, min, max)
    local color = cfg.powercolors[select(2, UnitPowerType(unit))]
    if color then
      bar:SetStatusBarColor(color.r, color.g, color.b,1)
      bar.bg:SetVertexColor(color.r, color.g, color.b,0.2)
    end
  end
  
  --check threat
  func.checkThreat = function(self,event,unit)
    if unit then
      if self.unit ~= unit then return end
      local threat = UnitThreatSituation(unit)
	    if(threat and threat > 0) then
		    local r, g, b = GetThreatStatusColor(threat)
        if self.Border then
          self.Border:SetVertexColor(r,g,b)
        end
      else
        if self.Border then
          self.Border:SetVertexColor(0.5,0.4,0.4)
        end
      end
    end
  end
  
  --create portrait func
  func.createPortrait = function(self)
    
    local back = CreateFrame("Frame",nil,self)
    back:SetSize(self.cfg.width,self.cfg.width)
    back:SetPoint("BOTTOM", self, "TOP", 0, -35)
    
    local t = back:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetAllPoints(back)
    t:SetTexture("Interface\\AddOns\\rTextures\\portrait_back")

    if self.cfg.portrait.use3D then
      self.Portrait = CreateFrame("PlayerModel", nil, back)
      self.Portrait:SetPoint("TOPLEFT",back,"TOPLEFT",27,-27)
      self.Portrait:SetPoint("BOTTOMRIGHT",back,"BOTTOMRIGHT",-27,27)
      
      local borderholder = CreateFrame("Frame", nil, self.Portrait)
      borderholder:SetAllPoints(back)
      
      local border = borderholder:CreateTexture(nil,"BACKGROUND",nil,-6)
      border:SetAllPoints(borderholder)
      border:SetTexture("Interface\\AddOns\\rTextures\\portrait_border")
      border:SetVertexColor(0.5,0.4,0.4)
      --border:SetVertexColor(1,0,0,1) --threat test
      self.Border = border
      
    else
      self.Portrait = back:CreateTexture(nil,"BACKGROUND",nil,-7)
      self.Portrait:SetPoint("TOPLEFT",back,"TOPLEFT",27,-27)
      self.Portrait:SetPoint("BOTTOMRIGHT",back,"BOTTOMRIGHT",-27,27)
      self.Portrait:SetTexCoord(0.1,0.9,0.1,0.9)
      
      local border = back:CreateTexture(nil,"BACKGROUND",nil,-6)
      border:SetAllPoints(back)
      border:SetTexture("Interface\\AddOns\\rTextures\\portrait_border")
      border:SetVertexColor(0.5,0.4,0.4)
      self.Border = border
      
    end
    
    self.Name:SetPoint("BOTTOM", self, "TOP", 0, self.cfg.width-53)
  
  end
  
  --create castbar func
  func.createCastbar = function(f)
  
    local cname
    if f.cfg.style == "player" then
      cname = "oUF_DiabloPlayerCastbar"
    elseif f.cfg.style == "target" then
      cname = "oUF_DiabloTargetCastbar"
    elseif f.cfg.style == "focus" then
      cname = "oUF_DiabloFocusCastbar"
    end
    
    c = CreateFrame("StatusBar", cname, UIParent)
    c:SetSize(186.8,20.2)
    c:SetStatusBarTexture(f.cfg.castbar.texture)
    c:SetScale(f.cfg.castbar.scale)
    c:SetPoint(f.cfg.castbar.pos.a1, f.cfg.castbar.pos.af, f.cfg.castbar.pos.a2, f.cfg.castbar.pos.x+10.1, f.cfg.castbar.pos.y)
    c:SetStatusBarColor(0.15,0.15,0.15,1)
    --c:SetStatusBarColor(0,0,0,1)

    c.background = c:CreateTexture(nil,"BACKGROUND",nil,-8)
    c.background:SetTexture("Interface\\AddOns\\rTextures\\castbar")
    c.background:SetPoint("TOP",0,21.9)
    c.background:SetPoint("LEFT",-44.7,0)
    c.background:SetPoint("RIGHT",24.5,0)
    c.background:SetPoint("BOTTOM",0,-22.2)

    c.bg = c:CreateTexture(nil,"BACKGROUND",nil,-6)
    c.bg:SetTexture(f.cfg.castbar.texture)
    c.bg:SetAllPoints(c)
    c.bg:SetVertexColor(0.96,0.7,0,1)

    c.Text =  func.createFontString(c, cfg.font, 11, "THINOUTLINE")
    c.Text:SetPoint("LEFT", 5, 0)
    c.Text:SetJustifyH("LEFT")
    
    c.Time =  func.createFontString(c, cfg.font, 11, "THINOUTLINE")
    c.Time:SetPoint("RIGHT", -2, 0)
    
    c.Text:SetPoint("RIGHT", -50, 0)
    --c.Text:SetPoint("RIGHT", c.Time, "LEFT", -10, 0) --right point of text will anchor left point of time
    
    --icon
    c.Icon = c:CreateTexture(nil, "OVERLAY",nil,-5)
    c.Icon:SetSize(20.2,20.2)
    c.Icon:SetPoint("LEFT", -20.2, 0)
    c.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    c.Spark = c:CreateTexture(nil,"LOW",nil,-7)
    c.Spark:SetBlendMode("ADD")
    c.Spark:SetVertexColor(0.8,0.6,0,1)

    c.glow = c:CreateTexture(nil, "OVERLAY",nil,-4)
    c.glow:SetTexture("Interface\\AddOns\\rTextures\\castbar_glow")
    c.glow:SetAllPoints(c.background)
    c.glow:SetVertexColor(0,0,0,1)
    
    if f.cfg.style == "target" then
      c.Shield = c:CreateTexture(nil,"BACKGROUND",nil,-8)
      c.Shield:SetTexture(0,0,0,0)
    end
    
    func.applyDragFunctionality(c)
    
    f.Castbar = c    
  
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
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
        f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
        f:SetScript("OnEnter", function(s) 
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      end
    end  
  end
  
  --allows frames to become movable in any case
  func.applyDragFunctionalityNoRestrict = function(f)
    f:SetMovable(true)
    f:SetUserPlaced(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    f:SetScript("OnEnter", function(s) 
      GameTooltip:SetOwner(s, "ANCHOR_TOP")
      GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
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
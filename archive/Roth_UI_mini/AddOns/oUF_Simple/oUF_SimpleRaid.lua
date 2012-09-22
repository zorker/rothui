  
  -- config
  
  local size = 40
  local myname, _ = UnitName("player")
  local _, myclass = UnitClass("player")
  local myfont = "FONTS\\FRIZQT__.ttf"  
  
  local myflat = "Interface\\AddOns\\oUF_Simple\\flat"
  local mytexture = "Interface\\AddOns\\oUF_Simple\\statusbar"
  local myborder = "Interface\\AddOns\\oUF_Simple\\border"
  local myglow = "Interface\\AddOns\\oUF_Simple\\square_glow"
  local mysquare = "Interface\\AddOns\\oUF_Simple\\square"
  local mycombo = "Interface\\AddOns\\oUF_Simple\\combo"
  local castcol = { r = 0.7, g = 0.6, b = 0.5, }
  local bdc = { r = castcol.r*0.5, g = castcol.g*0.5, b = castcol.b*0.5, a = 0.93, }
  
  -- shall frames be moved
  -- set this to 0 to reset all frame positions
  local allow_frame_movement = 1
  
  -- set this to 1 after you have moved everything in place
  -- THIS IS IMPORTANT because it will deactivate the mouse clickablity on that frame.
  local lock_all_frames = 0
  
  -- config end
  
  ----------------
  -- VALUE FORMAT
  ---------------- 
  
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
  
  local function check_threat(self,event,unit)
    if unit then
      if self.unit ~= unit then
        return
      end
      local threat = UnitThreatSituation(unit)
  		if threat == 3 then
  		  self.glosst:SetVertexColor(1,0,0)
  		elseif threat == 2 then
  		  self.glosst:SetVertexColor(1,0.6,0)
  		else
  		  self.glosst:SetVertexColor(bdc.r,bdc.g,bdc.b,bdc.a)
  		end
	  end
  end
  
  local function updateHealth(self, event, unit, bar, min, max)
  
    local tmpunitname
    if unit then
      tmpunitname = UnitName(unit)
    end
    
    local c = max - min
    local d = floor(min/max*100)
    
    local newmin = do_format(min)
    local newmax = do_format(max)
    local diff = do_format(max-min)
    
    local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]

    
    if color then
      bar:SetStatusBarColor(color.r*1,color.g*1,color.b*1,1)
      bar.bg:SetVertexColor(color.r*0.15,color.g*0.15,color.b*0.15,1)
    end
    
    if UnitLevel(unit) == 0 then
      self.Name:SetTextColor(0.4,0.4,0.4)
      self.Name:SetText("Oo")    
      bar.bg:SetVertexColor(0,0,0,0.4)
    elseif UnitIsConnected(unit) ~= 1 then
      self.Name:SetTextColor(0.4,0.4,0.4)
      self.Name:SetText("off")    
      bar.bg:SetVertexColor(0,0,0,0.4)
    elseif UnitIsDeadOrGhost(unit) == 1 then
      self.Name:SetTextColor(0.4,0.4,0.4)
      self.Name:SetText("dead")    
      bar.bg:SetVertexColor(0,0,0,0.4)
    elseif d == 100 then
      if color then
        self.Name:SetTextColor(color.r,color.g,color.b)
      end
      self.Name:SetText(tmpunitname)
    elseif min > 1 then
      self.Name:SetTextColor(1,1,1)
      self.Name:SetText("-"..diff)
    else
      self.Name:SetTextColor(0.4,0.4,0.4)
      self.Name:SetText("Oo")    
      bar.bg:SetVertexColor(0,0,0,0.4)
    end
    

    
  end
  
  local stylefunc = function(self, unit)
  
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
  
    self:SetAttribute('initial-height', size)
	  self:SetAttribute('initial-width', size)

    self.DebuffHighlight = self:CreateTexture(nil, "BACKGROUND")
    self.DebuffHighlight:SetPoint("TOPLEFT",self,"TOPLEFT",-6,6)
    self.DebuffHighlight:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",6,-6)
    self.DebuffHighlight:SetTexture(myglow)
    self.DebuffHighlight:SetVertexColor(bdc.r,bdc.g,bdc.b,bdc.a)
    self.DebuffHighlightAlpha = 1
    self.DebuffHighlightFilter = true
  
    self.Health = CreateFrame("StatusBar",nil,self)
    self.Health:SetFrameStrata("LOW")
    self.Health:SetPoint("TOPLEFT",self,"TOPLEFT",0,0)
    self.Health:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",0,0)
    self.Health:SetStatusBarTexture(mytexture)
    --self.Health:SetOrientation("VERTICAL") 
  
    self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
    self.Health.bg:SetAllPoints(self.Health)
    self.Health.bg:SetTexture(mytexture)
  
    self.Name = self.Health:CreateFontString(nil, "OVERLAY")
    --self.Name:SetPoint("CENTER", 0, 0)
    self.Name:SetPoint("LEFT", 4, 0)
    self.Name:SetPoint("RIGHT", -4, 0)
    self.Name:SetFont(NAMEPLATE_FONT,11,"THINOUTLINE")
    self.Name:SetShadowColor(0,0,0,0)
    self.Name:SetTextColor(1, 1, 1)
    
    self.glosst = self:CreateTexture(nil, "ARTWORK")
    self.glosst:SetAllPoints(self)
    self.glosst:SetTexture(mysquare)
    self.glosst:SetVertexColor(bdc.r,bdc.g,bdc.b,bdc.a)
    
    self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', check_threat)
  
    local ricon = self.Health:CreateTexture(nil, "OVERLAY")
    ricon:SetHeight(10)
    ricon:SetWidth(10)
    ricon:SetPoint("BOTTOM", self.Name, "TOP", 0, -1)
    ricon:SetTexture"Interface\\TargetingFrame\\UI-RaidTargetingIcons"
    self.RaidIcon = ricon
      
    if (not unit) then
      self.Range = true
      self.outsideRangeAlpha = 0.4
      self.inRangeAlpha = 1
    end
  
    self.PostUpdateHealth = updateHealth
  
    return self
  end
  
  local actstyle = "d3orbraid"
 
  oUF:RegisterStyle(actstyle, stylefunc)
  oUF:SetActiveStyle(actstyle)
  
  local function make_me_movable(f)
    if allow_frame_movement == 0 then
      f:IsUserPlaced(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if lock_all_frames == 0 then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:StartMoving() end end)
        f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
      end
    end  
  end
  
  local oUF_D3Orbs_RaidDragFrame = CreateFrame("Frame","oUF_D3Orbs_RaidDragFrame",UIParent)
  oUF_D3Orbs_RaidDragFrame:SetWidth(60)
  oUF_D3Orbs_RaidDragFrame:SetHeight(60)
  if lock_all_frames == 0 then
    --oUF_D3Orbs_RaidDragFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
  end
  oUF_D3Orbs_RaidDragFrame:SetPoint("TOPLEFT",20,-20)
  make_me_movable(oUF_D3Orbs_RaidDragFrame)
  
  local raid = {}
  for i = 1, 8 do
    table.insert(raid, oUF:Spawn("header", "oUF_Raid"..i))
    if i == 1 then
      raid[i]:SetPoint("TOPLEFT", "oUF_D3Orbs_RaidDragFrame", "TOPLEFT", 10, -10)
    else
      raid[i]:SetPoint("TOPLEFT", raid[i-1], "TOPRIGHT", 5, 0)    
    end
    raid[i]:SetManyAttributes("showRaid", true, "yOffset", -5, "groupFilter", i)
    raid[i]:Show()
  end

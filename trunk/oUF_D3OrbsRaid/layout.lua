
  local mytexture = "Interface\\AddOns\\rTextures\\statusbar"
  
  local stylefunc = function(self, unit)
  
    self:SetHeight(20)
    self:SetWidth(70)
    self:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",     edgeFile = "",     tile = true, tileSize = 16, edgeSize = 16,     insets = { left = 0, right = 0, top = 0, bottom = 0 }});
    self:SetBackdropColor(0,0,0,1)
  
  
    self.Health = CreateFrame("StatusBar",nil,self)
    self.Health:SetPoint("BOTTOMLEFT",1,1)
    self.Health:SetHeight(4)
    self.Health:SetWidth(self:GetWidth()-2)
    self.Health:SetStatusBarTexture(mytexture)
    self.Health:SetStatusBarColor(0,1,0,1)
  
    self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
    self.Health.bg:SetAllPoints(self.Health)
    self.Health.bg:SetTexture(mytexture)
    self.Health.bg:SetVertexColor(1,0,0)
  
    self.Name = self.Health:CreateFontString(nil, "OVERLAY")
    self.Name:SetPoint("BOTTOM", self.Health, "TOP", 0, 2)
    self.Name:SetFont(NAMEPLATE_FONT,12,"THINOUTLINE")
    self.Name:SetShadowColor(0,0,0,0)
    self.Name:SetTextColor(1, 1, 1)
  
    local leader = self.Health:CreateTexture(nil, "OVERLAY")
    leader:SetHeight(16)
    leader:SetWidth(16)
    leader:SetPoint("CENTER", self.Health, "CENTER", 0, 10)
    leader:SetTexture"Interface\\GroupFrame\\UI-Group-LeaderIcon"
    self.Leader = leader
  
    local ricon = self.Health:CreateTexture(nil, "OVERLAY")
    ricon:SetHeight(16)
    ricon:SetWidth(16)
    ricon:SetPoint("LEFT", self.Health, "LEFT", -5, 10)
    ricon:SetTexture"Interface\\TargetingFrame\\UI-RaidTargetingIcons"
    self.RaidIcon = ricon
      
    self.Range = true 
    self.inRangeAlpha = 1.0
    self.outsideRangeAlpha = 0.3
  
    return self
  end
  
  local actstyle = "d3orbraid"
 
  oUF:RegisterStyle(actstyle, stylefunc)
  oUF:SetActiveStyle(actstyle)
  
  
  local raid = {}
  for i = 1, 8 do
    table.insert(raid, oUF:Spawn("header", "oUF_Raid"..i))
    if i == 1 then
      raid[i]:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20, -20)
    --elseif i == 6 then
    --  raid[i]:SetPoint("LEFT", UIParent, "LEFT", 30, -20)
    else
      raid[i]:SetPoint("TOPLEFT", raid[i-1], "TOPRIGHT", 5, 0)    
    end
    raid[i]:SetManyAttributes("showRaid", true, "yOffset", -2, "groupFilter", i)
    raid[i]:Show()
  end


  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = ns.cfg
  local lib = ns.lib

  local tinsert = tinsert

  ---------------------------------------------
  -- variables
  ---------------------------------------------

  local scrollFrameSettings = {
    {
      defaultRotation = 0-80,
      point = "TOPRIGHT",
    },
    {
      defaultRotation = 270,
      point = "BOTTOMRIGHT",
    },
    {
      defaultRotation = 180,
      point = "BOTTOMLEFT",
    },
    {
      defaultRotation = 90,
      point = "TOPLEFT",
    },
  }

  ---------------------------------------------
  -- functions
  ---------------------------------------------

  local function CreateRingSegment(self, parent)
    --scrollframe
    local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", parent)
    scrollFrame:SetSize(128,128)
    --scrollchild
    local scrollChild = CreateFrame("Frame", "$parentScrollChild", scrollFrame)
    scrollChild:SetSize(128,128)
    --scrollChild:SetBackdrop(cfg.backdrop)
    scrollFrame:SetScrollChild(scrollChild)
    --ring castbar texture
    local castbar = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-8)
    castbar:SetTexture("Interface\\AddOns\\oUF_Donut\\media\\ring_quarter")
    castbar:SetSize(sqrt(2)*256*self.cfg.castbar.scale,sqrt(2)*256*self.cfg.castbar.scale)
    castbar:SetPoint("CENTER",self,"CENTER",0,0)
    castbar:SetVertexColor(1,1,0)
    local castbarSpark = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-6)
    castbarSpark:SetTexture("Interface\\AddOns\\oUF_Donut\\media\\ring_spark")
    castbarSpark:SetSize(sqrt(2)*256*self.cfg.castbar.scale,sqrt(2)*256*self.cfg.castbar.scale)
    castbarSpark:SetPoint("CENTER",self,"CENTER",0,0)
    castbarSpark:SetVertexColor(1,1,0)
    castbarSpark:SetBlendMode("ADD")
    --ring powerbar texture
    local powerbar = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-5)
    powerbar:SetTexture("Interface\\AddOns\\oUF_Donut\\media\\ring_quarter")
    powerbar:SetSize(sqrt(2)*256*self.cfg.powerbar.scale,sqrt(2)*256*self.cfg.powerbar.scale)
    powerbar:SetPoint("CENTER",self,"CENTER",0,0)
    powerbar:SetVertexColor(0,0.8,1)
    --ring healthbar texture
    local healthbar = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-2)
    healthbar:SetTexture("Interface\\AddOns\\oUF_Donut\\media\\ring_quarter")
    healthbar:SetSize(sqrt(2)*256*self.cfg.healthbar.scale,sqrt(2)*256*self.cfg.healthbar.scale)
    healthbar:SetPoint("CENTER",self,"CENTER",0,0)
    healthbar:SetVertexColor(1,0,0)
    --references
    scrollFrame.child = scrollChild
    scrollFrame.castbar = castbar
    scrollFrame.castbarSpark = castbarSpark
    scrollFrame.powerbar = powerbar
    scrollFrame.healthbar = healthbar
    return scrollFrame
  end

  local function CreateUnitTemplate(self)
    self:SetSize(256,256)
    self:SetScale(self.cfg.scale or 1)
    --self:SetBackdrop(cfg.backdrop)
    self:RegisterForClicks("AnyDown")
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    --create the framestack
    local back = CreateFrame("Frame", "$parentBackground", self)
    back:SetAllPoints(self)
    self.back = back
    local lastParent = back

    local t = back:CreateTexture(nil, "BACKGROUND", nil, -8)
    t:SetTexture(1,1,1)
    t:SetVertexColor(0.1,0.1,0.1)
    t:SetAllPoints(self)

    --scroll frames
    self.scrollFrames = {}
    for i=1, 4 do
      local scrollFrame = CreateRingSegment(self,lastParent)
      scrollFrame:SetPoint(scrollFrameSettings[i].point,self)
      scrollFrame.defaultRotation = scrollFrameSettings[i].defaultRotation
      scrollFrame.castbar:SetRotation(math.rad(scrollFrame.defaultRotation))
      scrollFrame.castbarSpark:SetRotation(math.rad(scrollFrame.defaultRotation))
      scrollFrame.powerbar:SetRotation(math.rad(scrollFrame.defaultRotation))
      scrollFrame.healthbar:SetRotation(math.rad(scrollFrame.defaultRotation))
      tinsert(self.scrollFrames, scrollFrame)
      lastParent = scrollFrame
    end

    --highlight
    local highlight = CreateFrame("Frame", nil, lastParent)
    highlight:SetAllPoints(self)
    self.highlight = highlight
    lastParent = highlight

    --local t = highlight:CreateTexture(nil, "BACKGROUND", nil, -8)
    --t:SetTexture(1,1,1)
    --t:SetVertexColor(0,1,1)
    --t:SetAllPoints()

    --border
    local border = CreateFrame("Frame", nil, lastParent)
    border:SetAllPoints(self)
    self.border = border
    lastParent = border

    --local t = border:CreateTexture(nil, "BACKGROUND", nil, -8)
    --t:SetTexture(1,1,1)
    --t:SetVertexColor(1,0,1)
    --t:SetAllPoints()

    --fake health
    local health = CreateFrame("StatusBar", nil, self)
    health:SetScript("OnValueChanged", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Health OnValueChanged")
      print(self:GetMinMaxValues())
      print(...)
    end)
    self.Health = health

    --fake power
    local power = CreateFrame("StatusBar", nil, self)
    power:SetScript("OnValueChanged", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Power OnValueChanged")
      print(self:GetMinMaxValues())
      print(...)
    end)
    self.Power = power

    --fake castbar
    local castbar = CreateFrame("StatusBar", nil, self)
    castbar:SetScript("OnValueChanged", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Castbar OnValueChanged")
      print(self:GetMinMaxValues())
      print(...)
    end)
    castbar:HookScript("OnShow", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Castbar OnShow")
      print(self:GetMinMaxValues())
      print(...)
    end)
    castbar:HookScript("OnHide", function(self, ...)
      local parent = self:GetParent()
      print(parent.cfg.style.. " Castbar OnHide")
      print(...)
    end)
    self.Castbar = castbar

  end

  --player frame
  local function CreatePlayer(self)
    self.cfg = cfg.units.player
    self.cfg.style = "player"
    CreateUnitTemplate(self)
    self:SetPoint("CENTER",-256,0)
  end

  --target frame
  local function CreateTarget(self)
    self.cfg = cfg.units.target
    self.cfg.style = "target"
    CreateUnitTemplate(self)
    self:SetPoint("CENTER",256,0)
  end

  ---------------------------------------------
  -- spawn
  ---------------------------------------------

  --spawn player
  if cfg.units.player.enable then
    oUF:RegisterStyle("donut:player", CreatePlayer)
    oUF:SetActiveStyle("donut:player")
    oUF:Spawn("player", addon.."PlayerFrame")
  end

  --spawn target
  if cfg.units.target.enable then
    oUF:RegisterStyle("donut:target", CreateTarget)
    oUF:SetActiveStyle("donut:target")
    oUF:Spawn("target", addon.."TargetFrame")
  end
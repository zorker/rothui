
  ---------------------------------------------
  --  oUF_Diablo - panel
  ---------------------------------------------

  -- The config panel

  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  --object container
  local panel = CreateFrame("Frame",addon.."ConfigPanel",UIParent,"ButtonFrameTemplate")
  panel:Hide()
  ns.panel = panel

  local db = ns.db

  ---------------------------------------------
  --PANEL SETUP
  ---------------------------------------------

  --setup panel
  do
    --size/point
    panel:SetSize(600,500)
    panel:SetPoint("CENTER")
    --title
    panel.title = _G[addon.."ConfigPanelTitleText"]
    panel.title:SetText(addon.." - Orb config panel")
    --icon
    local icon = panel:CreateTexture("$parentIcon", "OVERLAY", nil, -8)
    icon:SetSize(60,60)
    icon:SetPoint("TOPLEFT",-5,7)
    --icon:SetTexture("Interface\\FriendsFrame\\Battlenet-Portrait")
    SetPortraitTexture(icon, "player")
    icon:SetTexCoord(0,1,0,1)
    panel.icon = icon
    --mouse/drag stuff
    panel:EnableMouse(true)
    panel:SetClampedToScreen(true)
    panel:SetMovable(true)
    panel:SetUserPlaced(true)
  end

  ---------------------------------------------
  --TEMPLATE ELEMENT FUNCTIONS
  ---------------------------------------------

  --basic slider function
  local createBasicSlider = function(name, parent, title)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    local editbox = CreateFrame("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
    slider:SetMinMaxValues(0, 1)
    slider:SetValue(0)
    slider:SetValueStep(0.001)
    slider.text = _G[name.."Text"]
    slider.text:SetText(title)
    editbox:SetSize(50,30)
    editbox:ClearAllPoints()
    editbox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
    editbox:SetText(slider:GetValue())
    editbox:SetAutoFocus(false)
    slider:SetScript("OnValueChanged", function(self,value)
      self.editbox:SetText(ns.func.round(value))
    end)
    editbox:SetScript("OnEnterPressed", function(self)
      local val = self:GetText()
      if tonumber(val) then
         self:GetParent():SetValue(val)
         self:ClearFocus()
      end
    end)
    slider.editbox = editbox
    return slider
  end

  ---------------------------------------------
  --PANEL ELEMENT FUNCTIONS
  ---------------------------------------------

  --create element health orb animation alpha
  local createSliderHealthOrbAnimationAlpha = function(parent)
    local slider = createBasicSlider(addon.."PanelHealthOrbAnimationAlpha", parent, "Animation Alpha")
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.saveHealthOrbAnimationAlpha(value)
      --update orb view
      panel.updateHealthOrbAnimationAlpha()
    end)
    return slider
  end

  --create element power orb animation alpha
  local createSliderPowerOrbAnimationAlpha = function(parent)
    local slider = createBasicSlider(addon.."PanelPowerOrbAnimationAlpha", parent, "Animation Alpha")
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbAnimationAlpha(value)
      --update orb view
      panel.updatePowerOrbAnimationAlpha()
    end)
    return slider
  end

  --create panel drag frame
  local createPanelDragFrame = function()
    local frame = CreateFrame("Frame", "$parentDragFrame", panel)
    frame:SetHeight(22)
    frame:SetPoint("TOPLEFT",60,0)
    frame:SetPoint("TOPRIGHT",-30,0)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
      if InCombatLockdown() then return end
      self:GetParent():StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
      if InCombatLockdown() then return end
      self:GetParent():StopMovingOrSizing()
    end)
    frame:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Drag me!", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return frame
  end

  --create panel scroll frame
  local createPanelScrollFrame = function()
    local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT",10,-65)
    scrollFrame:SetPoint("BOTTOMRIGHT",-37,30)
    --add scrollbar background textures
    local t = scrollFrame:CreateTexture(nil,"BACKGROUND",nil,-6)
    t:SetPoint("TOP",scrollFrame)
    t:SetPoint("RIGHT",scrollFrame,25.5,0)
    t:SetPoint("BOTTOM",scrollFrame)
    t:SetWidth(26)
    t:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
    t:SetTexCoord(0,0.45,0.1640625,1)
    t:SetAlpha(0.5)
    local t2 = scrollFrame:CreateTexture(nil,"BACKGROUND",nil,-8)
    t2:SetTexture(1,1,1)
    t2:SetVertexColor(0,0,0,0.3)
    t2:SetAllPoints(t)
    --create panel scroll child
    local scrollChild = CreateFrame("Frame",nil,ScrollFrame)
    scrollChild:SetWidth(scrollFrame:GetWidth())
    scrollChild:SetHeight(1000)
    scrollFrame:SetScrollChild(scrollChild)
    scrollFrame.scrollChild = scrollChild
    return scrollFrame
  end

  ---------------------------------------------
  --SPAWN PANEL ELEMENTS
  ---------------------------------------------

  --panel drag frame
  panel.dragFrame = createPanelDragFrame()
  --the scroll frame
  panel.scrollFrame = createPanelScrollFrame()

  --create all panel elements
  panel.elementHealthOrbAnimationAlpha = createSliderHealthOrbAnimationAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbAnimationAlpha = createSliderPowerOrbAnimationAlpha(panel.scrollFrame.scrollChild)

  --positioon all panel elements
  panel.elementHealthOrbAnimationAlpha:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild, "TOPLEFT", 20, -25)
  panel.elementPowerOrbAnimationAlpha:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild, "TOPLEFT", 300, -25)

  ---------------------------------------------
  --UPDATE ORB ELEMENT VALUES
  ---------------------------------------------

  --update health orb animation alpha
  panel.updateHealthOrbAnimationAlpha = function()
    ns.HealthOrb.model:SetAlpha(panel.loadHealthOrbAnimationAlpha())
  end

  --update power orb animation alpha
  panel.updatePowerOrbAnimationAlpha = function()
    ns.PowerOrb.model:SetAlpha(panel.loadPowerOrbAnimationAlpha())
  end

  --update health orb animation enable
  panel.updateHealthOrbAnimationEnable = function()
    if panel.loadHealthOrbAnimationEnable() then
      ns.HealthOrb.model:Show()
    else
      ns.HealthOrb.model:Hide()
    end
  end

  --update power orb animation enable
  panel.updatePowerOrbAnimationEnable = function()
    if panel.loadPowerOrbAnimationEnable() then
      ns.PowerOrb.model:Show()
    else
      ns.PowerOrb.model:Hide()
    end
  end

  ---------------------------------------------
  --UPDATE PANEL ELEMENT VALUES
  ---------------------------------------------

  --update element health orb animation alpha
  panel.updateElementHealthOrbAnimationAlpha = function()
    panel.elementHealthOrbAnimationAlpha:SetValue(panel.loadHealthOrbAnimationAlpha())
  end

  --update element power orb animation alpha
  panel.updateElementPowerOrbAnimationAlpha = function()
    panel.elementPowerOrbAnimationAlpha:SetValue(panel.loadPowerOrbAnimationAlpha())
  end

  ---------------------------------------------
  --SAVE DATA TO DATABASE
  ---------------------------------------------

  --save health orb animation alpha
  panel.saveHealthOrbAnimationAlpha = function(value)
    db.char["HEALTH"].animation.alpha = value
  end

  --save power orb animation alpha
  panel.savePowerOrbAnimationAlpha = function(value)
    db.char["POWER"].animation.alpha = value
  end

  ---------------------------------------------
  --LOAD DATA FROM DATABASE
  ---------------------------------------------

  --load health orb animation alpha
  panel.loadHealthOrbAnimationAlpha = function()
    return db.char["HEALTH"].animation.alpha
  end

  --load power orb animation alpha
  panel.loadPowerOrbAnimationAlpha = function()
    return db.char["POWER"].animation.alpha
  end

  --load health orb animation enable
  panel.loadHealthOrbAnimationEnable = function()
    return db.char["HEALTH"].animation.enable
  end

  --load power orb animation enable
  panel.loadPowerOrbAnimationEnable = function()
    return db.char["POWER"].animation.enable
  end

  ---------------------------------------------
  --UPDATE PANEL VIEW
  ---------------------------------------------

  panel.updatePanelView = function()

    if InCombatLockdown() then return end

    --update all panel elements

    --update element health orb animation alpha
    panel.updateElementHealthOrbAnimationAlpha()
    --update element power orb animation alpha
    panel.updateElementPowerOrbAnimationAlpha()

  end

  ---------------------------------------------
  --UPDATE ORB VIEW
  ---------------------------------------------

  panel.updateOrbView = function()

    if InCombatLockdown() then return end

    --update all orb elements

    --update health orb animation alpha
    panel.updateHealthOrbAnimationAlpha()
    --update power orb animation alpha
    panel.updatePowerOrbAnimationAlpha()

    --update health orb animation enable
    panel.updateHealthOrbAnimationEnable()
    --update power orb animation enable
    panel.updatePowerOrbAnimationEnable()

    --update panel view
    panel.updatePanelView()

  end
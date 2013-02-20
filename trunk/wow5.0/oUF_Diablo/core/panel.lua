
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

  --basic slider func
  local createBasicSlider = function(parent, name, title)
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

  --basic checkbutton func
  local createBasicCheckButton = function(parent, name, title)
    local button = CreateFrame("CheckButton", name, parent, "OptionsCheckButtonTemplate")
    button.text = _G[name.."Text"]
    button.text:SetText(title)
    return button
  end

  local createBasicFontString = function(parent, name, layer, template, text)
    local fs = parent:CreateFontString(name,layer,template)
    fs:SetText(text)
    return fs
  end

  ---------------------------------------------
  --PANEL ELEMENT FUNCTIONS
  ---------------------------------------------

  --create element health orb model alpha
  local createSliderHealthOrbModelAlpha = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbModelAlpha", "Alpha")
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.saveHealthOrbModelAlpha(value)
      --update orb view
      panel.updateHealthOrbModelAlpha()
    end)
    return slider
  end

  --create element power orb model alpha
  local createSliderPowerOrbModelAlpha = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelAlpha", "Alpha")
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbModelAlpha(value)
      --update orb view
      panel.updatePowerOrbModelAlpha()
    end)
    return slider
  end

  --create element health orb model enable
  local createCheckButtonHealthOrbModelEnable = function(parent)
    local button = createBasicCheckButton(parent, addon.."PanelHealthOrbModelEnable", "Enable")
    button:HookScript("OnClick", function(self,value)
      --save value
      panel.saveHealthOrbModelEnable(self:GetChecked())
      --update orb view
      panel.updateHealthOrbModelEnable()
    end)
    return button
  end

  --create element power orb model enable
  local createCheckButtonPowerOrbModelEnable = function(parent)
    local button = createBasicCheckButton(parent, addon.."PanelPowerOrbModelEnable", "Enable")
    button:HookScript("OnClick", function(self,value)
      --save value
      panel.savePowerOrbModelEnable(self:GetChecked())
      --update orb view
      panel.updatePowerOrbModelEnable()
    end)
    return button
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
  panel.elementHealthOrbModelAlpha = createSliderHealthOrbModelAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelAlpha = createSliderPowerOrbModelAlpha(panel.scrollFrame.scrollChild)
  panel.elementHealthOrbModelEnable = createCheckButtonHealthOrbModelEnable(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelEnable = createCheckButtonPowerOrbModelEnable(panel.scrollFrame.scrollChild)
  panel.elementHealthModelHeader = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Model Settings")
  panel.elementPowerModelHeader = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Model Settings")

  --positioon all panel elements
  panel.elementHealthOrbModelAlpha:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild, "TOPLEFT", 20, -25)
  panel.elementPowerOrbModelAlpha:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild, "TOPLEFT", 300, -25)
  panel.elementHealthOrbModelEnable:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild, "TOPLEFT", 20, -80)
  panel.elementPowerOrbModelEnable:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild, "TOPLEFT", 300, -80)
  panel.elementHealthModelHeader:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild, "TOPLEFT", 20, -160)

  ---------------------------------------------
  --UPDATE ORB ELEMENT VALUES
  ---------------------------------------------

  --update health orb model alpha
  panel.updateHealthOrbModelAlpha = function()
    ns.HealthOrb.model:SetAlpha(panel.loadHealthOrbModelAlpha())
  end

  --update power orb model alpha
  panel.updatePowerOrbModelAlpha = function()
    ns.PowerOrb.model:SetAlpha(panel.loadPowerOrbModelAlpha())
  end

  --update health orb model enable
  panel.updateHealthOrbModelEnable = function()
    if panel.loadHealthOrbModelEnable() then
      ns.HealthOrb.model:Show()
    else
      ns.HealthOrb.model:Hide()
    end
  end

  --update power orb model enable
  panel.updatePowerOrbModelEnable = function()
    if panel.loadPowerOrbModelEnable() then
      ns.PowerOrb.model:Show()
    else
      ns.PowerOrb.model:Hide()
    end
  end

  ---------------------------------------------
  --UPDATE PANEL ELEMENT VALUES
  ---------------------------------------------

  --update element health orb model alpha
  panel.updateElementHealthOrbModelAlpha = function()
    panel.elementHealthOrbModelAlpha:SetValue(panel.loadHealthOrbModelAlpha())
  end

  --update element power orb model alpha
  panel.updateElementPowerOrbModelAlpha = function()
    panel.elementPowerOrbModelAlpha:SetValue(panel.loadPowerOrbModelAlpha())
  end

  --update element health orb model enable
  panel.updateElementHealthOrbModelEnable = function()
    panel.elementHealthOrbModelEnable:SetChecked(panel.loadHealthOrbModelEnable())
  end

  --update element power orb model enable
  panel.updateElementPowerOrbModelEnable = function()
    panel.elementPowerOrbModelEnable:SetChecked(panel.loadPowerOrbModelEnable())
  end

  ---------------------------------------------
  --SAVE DATA TO DATABASE
  ---------------------------------------------

  --save health orb model alpha
  panel.saveHealthOrbModelAlpha = function(value)
    db.char["HEALTH"].model.alpha = value
  end

  --save power orb model alpha
  panel.savePowerOrbModelAlpha = function(value)
    db.char["POWER"].model.alpha = value
  end

  --save health orb model enable
  panel.saveHealthOrbModelEnable = function(value)
    db.char["HEALTH"].model.enable = value
  end

  --save power orb model enable
  panel.savePowerOrbModelEnable = function(value)
    db.char["POWER"].model.enable = value
  end

  ---------------------------------------------
  --LOAD DATA FROM DATABASE
  ---------------------------------------------

  --load health orb model alpha
  panel.loadHealthOrbModelAlpha = function()
    return db.char["HEALTH"].model.alpha
  end

  --load power orb model alpha
  panel.loadPowerOrbModelAlpha = function()
    return db.char["POWER"].model.alpha
  end

  --load health orb model enable
  panel.loadHealthOrbModelEnable = function()
    return db.char["HEALTH"].model.enable
  end

  --load power orb model enable
  panel.loadPowerOrbModelEnable = function()
    return db.char["POWER"].model.enable
  end

  ---------------------------------------------
  --UPDATE PANEL VIEW
  ---------------------------------------------

  panel.updatePanelView = function()

    if InCombatLockdown() then return end

    --update all panel elements

    --update element health orb model alpha
    panel.updateElementHealthOrbModelAlpha()
    --update element power orb model alpha
    panel.updateElementPowerOrbModelAlpha()
    --update element health orb model enable
    panel.updateElementHealthOrbModelEnable()
    --update element power orb model enable
    panel.updateElementPowerOrbModelEnable()

  end

  ---------------------------------------------
  --UPDATE ORB VIEW
  ---------------------------------------------

  panel.updateOrbView = function()

    if InCombatLockdown() then return end

    --update all orb elements

    --update health orb model alpha
    panel.updateHealthOrbModelAlpha()
    --update power orb model alpha
    panel.updatePowerOrbModelAlpha()

    --update health orb model enable
    panel.updateHealthOrbModelEnable()
    --update power orb model enable
    panel.updatePowerOrbModelEnable()

    --update panel view
    panel.updatePanelView()

  end
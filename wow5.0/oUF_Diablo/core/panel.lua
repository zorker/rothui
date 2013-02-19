
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

  local unpack = unpack

  ---------------------------------------------
  --FUNCTIONS
  ---------------------------------------------

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
  --CREATE PANEL ELEMENTS
  ---------------------------------------------

   local createSliderHealthOrbAnimationAlpha = function(parent)
    local slider = createBasicSlider(addon.."PanelHealthOrbAnimationAlpha", parent, "Animation Alpha")
    slider:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, -25)
    slider:HookScript("OnValueChanged", function(self,value)
      panel.saveHealthOrbAnimationAlpha(value)
    end)
    return slider
  end

   local createSliderPowerOrbAnimationAlpha = function(parent)
    local slider = createBasicSlider(addon.."PanelPowerOrbAnimationAlpha", parent, "Animation Alpha")
    slider:SetPoint("TOPLEFT", parent, "TOPLEFT", 300, -25)
    slider:HookScript("OnValueChanged", function(self,value)
      panel.savePowerOrbAnimationAlpha(value)
    end)
    return slider
  end

  --panel dragFrame
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

  local createPanelScrollFrame = function()

    --create a scrollframe inside
    local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT",10,-65)
    scrollFrame:SetPoint("BOTTOMRIGHT",-37,30)

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

    local scrollChild = CreateFrame("Frame",nil,ScrollFrame)
    scrollChild:SetWidth(scrollFrame:GetWidth())
    scrollChild:SetHeight(1000)

    scrollFrame:SetScrollChild(scrollChild)

    scrollFrame.scrollChild = scrollChild
    return scrollFrame

  end



  ---------------------------------------------
  --CREATE PANEL
  ---------------------------------------------

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

  --make sure you cannot click through the frame
  panel:EnableMouse(true)
  --make sure you cannot move the panel out of the screen
  panel:SetClampedToScreen(true)
  --make the panel draggable
  panel:SetMovable(true)
  panel:SetUserPlaced(true)

  --panel drag frame
  panel.dragFrame = createPanelDragFrame()
  --the scroll frame
  panel.scrollFrame = createPanelScrollFrame()

  --put elements on the scrollframe
  panel.sliderHealthOrbAnimationAlpha = createSliderHealthOrbAnimationAlpha(panel.scrollFrame.scrollChild)
  panel.sliderPowerOrbAnimationAlpha = createSliderPowerOrbAnimationAlpha(panel.scrollFrame.scrollChild)


  ---------------------------------------------
  --SAVE
  ---------------------------------------------

  panel.saveHealthOrbAnimationAlpha = function(value)
    ns.HealthOrb.model:SetAlpha(value)
    db.char["HEALTH"].animation.alpha = value
  end

  panel.savePowerOrbAnimationAlpha = function(value)
    ns.PowerOrb.model:SetAlpha(value)
    db.char["POWER"].animation.alpha = value
  end

  ---------------------------------------------
  --LOAD
  ---------------------------------------------

  panel.loadHealthOrbAnimationAlpha = function()
    return db.char["HEALTH"].animation.alpha
  end

  panel.loadPowerOrbAnimationAlpha = function()
    return db.char["POWER"].animation.alpha
  end

  ---------------------------------------------
  --UPDATE PANEL VIEW
  ---------------------------------------------

  panel.updatePanelView = function()
    --update all panels
    panel.sliderHealthOrbAnimationAlpha:SetValue(panel.loadHealthOrbAnimationAlpha())
    panel.sliderPowerOrbAnimationAlpha:SetValue(panel.loadPowerOrbAnimationAlpha())
  end

  ---------------------------------------------
  --UPDATE ORB VIEW
  ---------------------------------------------

  panel.updateOrbView = function()

    --apply all config values to the orbs
    print("updateOrbView")

    local healthOrb = ns.HealthOrb
    local powerOrb = ns.PowerOrb
    local healthOrbCfg = db.char["HEALTH"]
    local powerOrbCfg = db.char["POWER"]

    if healthOrbCfg.animation.enable then
      healthOrb.model:Show()
    else
      healthOrb.model:Hide()
    end

    if powerOrbCfg.animation.enable then
      powerOrb.model:Show()
    else
      powerOrb.model:Hide()
    end

    healthOrb.model:SetAlpha(panel.loadHealthOrbAnimationAlpha())
    powerOrb.model:SetAlpha(panel.loadPowerOrbAnimationAlpha())

    --update panel view
    panel.updatePanelView()

  end
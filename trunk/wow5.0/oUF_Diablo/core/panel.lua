
  ---------------------------------------------
  --  oUF_Diablo - panel
  ---------------------------------------------

  -- The config panel

  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  local db = ns.db

  local unpack = unpack
  local CF = CreateFrame

  --object container
  local panel = CF("Frame",addon.."ConfigPanel",UIParent,"ButtonFrameTemplate")
  panel:Hide()
  ns.panel = panel

  ---------------------------------------------
  --PANEL SETUP FUNCTIONS
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
    icon:SetTexture("Interface\\FriendsFrame\\Battlenet-Portrait")
    --SetPortraitTexture(icon, "player")
    icon:SetTexCoord(0,1,0,1)
    panel.icon = icon
    --mouse/drag stuff
    panel:EnableMouse(true)
    panel:SetClampedToScreen(true)
    panel:SetMovable(true)
    panel:SetUserPlaced(true)
  end

  --create panel drag frame
  local createPanelDragFrame = function()
    local frame = CF("Frame", "$parentDragFrame", panel)
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
    local scrollFrame = CF("ScrollFrame", "$parentScrollFrame", panel, "UIPanelScrollFrameTemplate")
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
    local scrollChild = CF("Frame",nil,ScrollFrame)
    scrollChild:SetWidth(scrollFrame:GetWidth())
    scrollChild:SetHeight(1000)
    --left background behind health orb settings
    local t = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-4)
    t:SetTexture(1,1,1)
    t:SetVertexColor(1,0,0,0.2)
    t:SetPoint("TOPLEFT")
    t:SetPoint("BOTTOMLEFT")
    t:SetWidth(scrollFrame:GetWidth()/2-2)
    scrollChild.leftTexture = t
    --right background behind power settings
    local t = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-4)
    t:SetTexture(1,1,1)
    t:SetVertexColor(0,0.4,0.9,0.2)
    t:SetPoint("TOPRIGHT")
    t:SetPoint("BOTTOMRIGHT")
    t:SetWidth(scrollFrame:GetWidth()/2-2)
    scrollChild.rightTexture = t
    --set scrollchild
    scrollFrame:SetScrollChild(scrollChild)
    scrollFrame.scrollChild = scrollChild
    return scrollFrame
  end
  --panel drag frame
  panel.dragFrame = createPanelDragFrame()
  --the scroll frame
  panel.scrollFrame = createPanelScrollFrame()

  ---------------------------------------------
  --CREATE UI PANEL ELEMENT FUNCTIONS
  ---------------------------------------------

  --basic fontstring func
  local createBasicFontString = function(parent, name, layer, template, text)
    local fs = parent:CreateFontString(name,layer,template)
    fs:SetText(text)
    return fs
  end

  local createHeadlineBackground = function(parent,headline)
    local t = parent:CreateTexture(nil,"BACKGROUND",nil,-2)
    t:SetTexture(1,1,1)
    --t:SetVertexColor(0,0,0,0.4)
    t:SetVertexColor(255,255,255,0.02)
    t:SetPoint("TOP",headline,0,5)
    t:SetPoint("LEFT")
    t:SetPoint("RIGHT")
    t:SetPoint("BOTTOM",headline,0,-5)
    t:SetBlendMode("ADD")
  end

  local backdrop = {
    bgFile = "",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }

  --basic slider func
  local createBasicSlider = function(parent, name, title)
    local slider = CF("Slider", name, parent, "OptionsSliderTemplate")
    local editbox = CF("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
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
    local button = CF("CheckButton", name, parent, "OptionsCheckButtonTemplate")
    button.text = _G[name.."Text"]
    button.text:SetText(title)
    return button
  end

  --basic color picker func
  local createBasicColorPicker = function(parent, name, width, height)
    local picker = CF("Button", name, parent)
    picker:SetSize(width, height)
    picker:SetBackdrop(backdrop)
    picker:SetBackdropBorderColor(0.5,0.5,0.5)
    --texture
    local color = picker:CreateTexture(nil,"BACKGROUND",nil,-7)
    --color:SetAllPoints(picker)
    color:SetPoint("TOPLEFT",4,-4)
    color:SetPoint("BOTTOMRIGHT",-4,4)
    color:SetTexture(1,1,1)
    picker.color = color
    picker.text = createBasicFontString(picker,nil,nil,"GameFontNormal","Pick a Color")
    picker.text:SetPoint("LEFT", picker, "RIGHT", 5, 0)
    picker.disabled = false
    --add a Disable() function to the colorpicker element
    function picker:Disable()
      self.disabled = true
      self:SetAlpha(0.4)
    end
    --add a Enable() function to the colorpicker element
    function picker:Enable()
      self.disabled = false
      self:SetAlpha(1)
    end
    --picker.show
    picker.show = function(r,g,b,a,callback)
      ColorPickerFrame:SetParent(panel)
      ColorPickerFrame:SetColorRGB(r,g,b)
      ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
      ColorPickerFrame.previousValues = {r,g,b,a}
      ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = callback, callback, callback
      ColorPickerFrame:Hide() -- Need to run the OnShow handler.
      ColorPickerFrame:Show()
    end
    picker.callback = function(color)
      if picker.disabled then return end
      local r,g,b
      if color then r,g,b = unpack(color) else r,g,b = ColorPickerFrame:GetColorRGB() end
      picker.color:SetVertexColor(r,g,b)
      picker.click(r,g,b)
    end
    picker:SetScript("OnClick", function(self)
      if self.disabled then return end
      local r,g,b = self.color:GetVertexColor()
      self.show(r,g,b,nil,self.callback)
    end)
    return picker
  end

  --basic dropdown menu func
  local createBasicDropDownMenu = function(parent, name, text, dataFunc, width)
    local dropdownMenu = CF("Frame", name, parent, "UIDropDownMenuTemplate")
    UIDropDownMenu_SetText(dropdownMenu, text)
    UIDropDownMenu_SetWidth(dropdownMenu, width)
    dropdownMenu.init = function(self)
      local info = UIDropDownMenu_CreateInfo()
      local infos = dataFunc() or {}
      --print(UIDropDownMenu_GetSelectedValue(self))
      infos[0] = { key = text, isTitle = true, notCheckable = true, notClickable = true }
      for i=0, #infos do
      --for i=1, #infos do
        wipe(info)
        info.text = infos[i].key
        info.value = infos[i].value or ""
        info.isTitle = infos[i].isTitle or false
        info.notClickable = infos[i].notClickable or false
        info.notCheckable = infos[i].notCheckable or false
        info.func = self.click
        UIDropDownMenu_AddButton(info)
      end
    end
    UIDropDownMenu_Initialize(dropdownMenu, dropdownMenu.init)
    return dropdownMenu
  end

  --basic dropdown menu with a button
  local createBasicDropDownMenuWithButton = function(parent, name, text, dataFunc, width, buttonText)
    local dropdownMenu = createBasicDropDownMenu(parent, name, text, dataFunc, width)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
    end
    local button = CF("Button", name.."Submit", parent, "UIPanelButtonTemplate")
    button:SetPoint("LEFT", dropdownMenu, "RIGHT", -13, 2.5)
    button.text = _G[button:GetName().."Text"]
    button.text:SetText(buttonText)
    button:SetWidth(button.text:GetStringWidth()+30)
    button:SetHeight(27)
    dropdownMenu.button = button
    return dropdownMenu
  end

  ---------------------------------------------
  --CREATE PANEL ELEMENT FUNCTIONS
  ---------------------------------------------

  --create element health orb load preset
  local createDropdownHealthOrbLoadPreset = function(parent)
    local dropdownMenu = createBasicDropDownMenuWithButton(parent, addon.."PanelHealthOrbLoadPreset", "Pick a template", db.getListTemplate, 160, "Load")
    dropdownMenu.button:HookScript("OnClick", function()
      local value = UIDropDownMenu_GetSelectedValue(dropdownMenu)
      if not value then return end
      print(UIDropDownMenu_GetSelectedValue(dropdownMenu))
    end)
    return dropdownMenu
  end

  --create element power orb load preset
  local createDropdownPowerOrbLoadPreset = function(parent)
    local dropdownMenu = createBasicDropDownMenuWithButton(parent, addon.."PanelPowerOrbLoadPreset", "Pick a template", db.getListTemplate, 160, "Load")
    dropdownMenu.button:HookScript("OnClick", function()
      local value = UIDropDownMenu_GetSelectedValue(dropdownMenu)
      if not value then return end
      print(UIDropDownMenu_GetSelectedValue(dropdownMenu))
    end)
    return dropdownMenu
  end

  --create element health orb filling texture
  local createDropdownHealthOrbFillingTexture = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelHealthOrbFillingTexture", "Pick a texture", db.getListFillingTexture, 160)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      --save value
      panel.saveHealthOrbFillingTexture(self.value)
      --update orb view
      panel.updateHealthOrbFillingTexture()
    end
    return dropdownMenu
  end

  --create element power orb filling texture
  local createDropdownPowerOrbFillingTexture = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelPowerOrbFillingTexture", "Pick a texture", db.getListFillingTexture, 160)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      --save value
      panel.savePowerOrbFillingTexture(self.value)
      --update orb view
      panel.updatePowerOrbFillingTexture()
    end
    return dropdownMenu
  end

  --create element health orb color auto
  local createCheckButtonHealthOrbFillingColorAuto = function(parent)
    local button = createBasicCheckButton(parent, addon.."PanelHealthOrbFillingColorAuto", "Force class color?")
    button:HookScript("OnClick", function(self,value)
      --save value
      panel.saveHealthOrbFillingColorAuto(self:GetChecked())
      --update orb view
      panel.updateHealthOrbFillingColorAuto()
      --normally we do not need to update the panel view but this enable/disable button has side effects on other panels, thus we need to run a panel update
      panel.updateElementHealthOrbFillingColorAuto()
    end)
    return button
  end

  --create element power orb color auto
  local createCheckButtonPowerOrbFillingColorAuto = function(parent)
    local button = createBasicCheckButton(parent, addon.."PanelPowerOrbFillingColorAuto", "Force powertype color?")
    button:HookScript("OnClick", function(self,value)
      --save value
      panel.savePowerOrbFillingColorAuto(self:GetChecked())
      --update orb view
      panel.updatePowerOrbFillingColorAuto()
      --normally we do not need to update the panel view but this enable/disable button has side effects on other panels, thus we need to run a panel update
      panel.updateElementPowerOrbFillingColorAuto()
    end)
    return button
  end

  --create element health orb filling color
  local createPickerHealthOrbFillingColor = function(parent)
    local picker = createBasicColorPicker(parent, addon.."PanelHealthOrbFillingColor", 100, 25)
    picker.click = function(r,g,b)
      --save value
      panel.saveHealthOrbFillingColor(r,g,b)
      --update orb view
      panel.updateHealthOrbFillingColor()
    end
    return picker
  end

  --create element power orb filling color
  local createPickerPowerOrbFillingColor = function(parent)
    local picker = createBasicColorPicker(parent, addon.."PanelPowerOrbFillingColor", 100, 25)
    picker.click = function(r,g,b)
      --save value
      panel.savePowerOrbFillingColor(r,g,b)
      --update orb view
      panel.updatePowerOrbFillingColor()
    end
    return picker
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

  --create element health orb model animation
  local createDropdownHealthOrbModelAnimation = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelHealthOrbFillingTexture", "Pick an animation", db.getListModel, 160)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      --save value
      panel.saveHealthOrbModelAnimation(self.value)
      --update orb view
      panel.updateHealthOrbModelAnimation()
    end
    return dropdownMenu
  end

  --create element power orb model animation
  local createDropdownPowerOrbModelAnimation = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelPowerOrbFillingTexture", "Pick an animation", db.getListModel, 160)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      --save value
      panel.savePowerOrbModelAnimation(self.value)
      --update orb view
      panel.updatePowerOrbModelAnimation()
    end
    return dropdownMenu
  end

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

  ---------------------------------------------
  --SPAWN PANEL ELEMENTS
  ---------------------------------------------

  --create master headline
  panel.elementHealthMasterHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalHuge","Health Orb Settings")
  panel.elementHealthMasterHeadline:SetTextColor(1,0,0)
  panel.elementPowerMasterHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalHuge","Power Orb Settings")
  panel.elementPowerMasterHeadline:SetTextColor(0,0.4,1)
  --create load preset headline
  panel.elementHealthLoadPresetHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Load preset")
  panel.elementPowerLoadPresetHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Load preset")
  --create load preset dropdown
  panel.elementHealthOrbLoadPreset = createDropdownHealthOrbLoadPreset(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbLoadPreset = createDropdownPowerOrbLoadPreset(panel.scrollFrame.scrollChild)
  --create filling headline
  panel.elementHealthFillingHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Filling")
  panel.elementPowerFillingHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Filling")
  --create filling texture dropdowns
  panel.elementHealthOrbFillingTexture = createDropdownHealthOrbFillingTexture(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbFillingTexture = createDropdownPowerOrbFillingTexture(panel.scrollFrame.scrollChild)
  --create filling color auto checkbutton
  panel.elementHealthOrbFillingColorAuto = createCheckButtonHealthOrbFillingColorAuto(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbFillingColorAuto = createCheckButtonPowerOrbFillingColorAuto(panel.scrollFrame.scrollChild)
  --create filling color picker
  panel.elementHealthOrbFillingColor = createPickerHealthOrbFillingColor(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbFillingColor = createPickerPowerOrbFillingColor(panel.scrollFrame.scrollChild)
  --create model headline
  panel.elementHealthModelHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Model")
  panel.elementPowerModelHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Model")
  --create model enable checkbutton
  panel.elementHealthOrbModelEnable = createCheckButtonHealthOrbModelEnable(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelEnable = createCheckButtonPowerOrbModelEnable(panel.scrollFrame.scrollChild)
  --create model animation dropdown
  panel.elementHealthOrbModelAnimation = createDropdownHealthOrbModelAnimation(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelAnimation = createDropdownPowerOrbModelAnimation(panel.scrollFrame.scrollChild)
  --create model alpha slider
  panel.elementHealthOrbModelAlpha = createSliderHealthOrbModelAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelAlpha = createSliderPowerOrbModelAlpha(panel.scrollFrame.scrollChild)

  ---------------------------------------------
  --POSITION PANEL ELEMENTS
  ---------------------------------------------

  --position master headline
  panel.elementHealthMasterHeadline:SetPoint("TOP", panel.scrollFrame.scrollChild.leftTexture, 0, -10)
  panel.elementPowerMasterHeadline:SetPoint("TOP", panel.scrollFrame.scrollChild.rightTexture, 0, -10)
  --position load preset headline
  panel.elementHealthLoadPresetHeadline:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild.leftTexture, 20, -55)
  panel.elementPowerLoadPresetHeadline:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild.rightTexture, 20, -55)
  --position load preset dropdown
  panel.elementHealthOrbLoadPreset:SetPoint("TOPLEFT", panel.elementHealthLoadPresetHeadline, "BOTTOMLEFT", -20, -10)
  panel.elementPowerOrbLoadPreset:SetPoint("TOPLEFT", panel.elementPowerLoadPresetHeadline, "BOTTOMLEFT", -20, -10)
  --position filling headline
  panel.elementHealthFillingHeadline:SetPoint("TOPLEFT", panel.elementHealthLoadPresetHeadline, "BOTTOMLEFT", 0, -50)
  panel.elementPowerFillingHeadline:SetPoint("TOPLEFT", panel.elementPowerLoadPresetHeadline, "BOTTOMLEFT", 0, -50)
  --position filling texture dropdown
  panel.elementHealthOrbFillingTexture:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", -20, -10)
  panel.elementPowerOrbFillingTexture:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", -20, -10)
  --position filling color auto checkbutton
  panel.elementHealthOrbFillingColorAuto:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", -4, -45)
  panel.elementPowerOrbFillingColorAuto:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", -4, -45)
  --position filling color picker
  panel.elementHealthOrbFillingColor:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", -3, -75)
  panel.elementPowerOrbFillingColor:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", -3, -75)
  --position model headline
  panel.elementHealthModelHeadline:SetPoint("TOPLEFT", panel.elementHealthFillingHeadline, "BOTTOMLEFT", 0, -115)
  panel.elementPowerModelHeadline:SetPoint("TOPLEFT", panel.elementPowerFillingHeadline, "BOTTOMLEFT", 0, -115)
  --position model enable checkbutton
  panel.elementHealthOrbModelEnable:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", -4, -10)
  panel.elementPowerOrbModelEnable:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", -4, -10)
  --position model animation dropdown
  panel.elementHealthOrbModelAnimation:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", -20, -45)
  panel.elementPowerOrbModelAnimation:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", -20, -45)
  --position model alpha slider
  panel.elementHealthOrbModelAlpha:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -100)
  panel.elementPowerOrbModelAlpha:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -100)

  ---------------------------------------------
  --CREATE HEADLINE BACKGROUNDS
  ---------------------------------------------

  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthMasterHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthLoadPresetHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthFillingHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthModelHeadline)

  ---------------------------------------------
  --UPDATE ORB ELEMENT VALUES
  ---------------------------------------------

  --update health orb filling texture
  panel.updateHealthOrbFillingTexture = function()
    ns.HealthOrb.fill:SetStatusBarTexture(panel.loadHealthOrbFillingTexture())
  end

  --update power orb filling texture
  panel.updatePowerOrbFillingTexture = function()
    ns.PowerOrb.fill:SetStatusBarTexture(panel.loadPowerOrbFillingTexture())
  end

  --update health orb filling color auto
  panel.updateHealthOrbFillingColorAuto = function()
    if panel.loadHealthOrbFillingColorAuto() then
      ns.HealthOrb.fill.colorClass = true
      ns.HealthOrb.fill.colorHealth = true
    else
      ns.HealthOrb.fill.colorClass = false
      ns.HealthOrb.fill.colorHealth = false
      local color = panel.loadHealthOrbFillingColor()
      ns.HealthOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    end
    ns.HealthOrb.fill:ForceUpdate()
  end

  --update power orb filling color auto
  panel.updatePowerOrbFillingColorAuto = function()
    if panel.loadPowerOrbFillingColorAuto() then
      ns.PowerOrb.fill.colorPower = true
    else
      ns.PowerOrb.fill.colorPower = false
      local color = panel.loadPowerOrbFillingColor()
      ns.PowerOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    end
    ns.PowerOrb.fill:ForceUpdate()
  end

  --update health orb filling color
  panel.updateHealthOrbFillingColor = function()
    local color = panel.loadHealthOrbFillingColor()
    ns.HealthOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    ns.HealthOrb.fill:ForceUpdate()
  end

  --update power orb filling color
  panel.updatePowerOrbFillingColor = function()
    local color = panel.loadPowerOrbFillingColor()
    ns.PowerOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    ns.PowerOrb.fill:ForceUpdate()
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

  --update health orb model animation
  panel.updateHealthOrbModelAnimation = function()
    ns.HealthOrb.model:Update() --update the full model with all values, displayId is not enough
  end

  --update power orb model animation
  panel.updatePowerOrbModelAnimation = function()
    ns.PowerOrb.model:Update() --update the full model with all values, displayId is not enough
  end

  --update health orb model alpha
  panel.updateHealthOrbModelAlpha = function()
    ns.HealthOrb.model:SetAlpha(panel.loadHealthOrbModelAlpha())
  end

  --update power orb model alpha
  panel.updatePowerOrbModelAlpha = function()
    ns.PowerOrb.model:SetAlpha(panel.loadPowerOrbModelAlpha())
  end

  ---------------------------------------------
  --UPDATE PANEL ELEMENT VALUES
  ---------------------------------------------

  --update element health orb texture filling
  panel.updateElementHealthOrbTextureFilling = function()
    UIDropDownMenu_SetSelectedValue(panel.elementHealthOrbFillingTexture, panel.loadHealthOrbFillingTexture())
  end

  --update element power orb texture filling
  panel.updateElementPowerOrbTextureFilling = function()
    UIDropDownMenu_SetSelectedValue(panel.elementPowerOrbFillingTexture, panel.loadPowerOrbFillingTexture())
  end

  --update element health orb filling color auto
  panel.updateElementHealthOrbFillingColorAuto = function()
    local value = panel.loadHealthOrbFillingColorAuto()
    panel.elementHealthOrbFillingColorAuto:SetChecked(value)
    --depending on color auto option we want to enable/disable the texture color picker
    if value then
      panel.elementHealthOrbFillingColor:Disable()
    else
      panel.elementHealthOrbFillingColor:Enable()
    end
  end

  --update element power orb filling color auto
  panel.updateElementPowerOrbFillingColorAuto = function()
    local value = panel.loadPowerOrbFillingColorAuto()
    panel.elementPowerOrbFillingColorAuto:SetChecked(value)
    --depending on color auto option we want to enable/disable the texture color picker
    if value then
      panel.elementPowerOrbFillingColor:Disable()
    else
      panel.elementPowerOrbFillingColor:Enable()
    end
  end

  --update element health orb texture color
  panel.updateElementHealthOrbTextureColor = function()
    local color = panel.loadHealthOrbFillingColor()
    panel.elementHealthOrbFillingColor.color:SetVertexColor(color.r,color.g,color.b)
  end

  --update element power orb texture color
  panel.updateElementPowerOrbTextureColor = function()
    local color = panel.loadPowerOrbFillingColor()
    panel.elementPowerOrbFillingColor.color:SetVertexColor(color.r,color.g,color.b)
  end

  --update element health orb model enable
  panel.updateElementHealthOrbModelEnable = function()
    panel.elementHealthOrbModelEnable:SetChecked(panel.loadHealthOrbModelEnable())
  end

  --update element power orb model enable
  panel.updateElementPowerOrbModelEnable = function()
    panel.elementPowerOrbModelEnable:SetChecked(panel.loadPowerOrbModelEnable())
  end

  --update element health orb model animation
  panel.updateElementHealthOrbModelAnimation = function()
    UIDropDownMenu_SetSelectedValue(panel.elementHealthOrbModelAnimation, panel.loadHealthOrbModelAnimation())
  end

  --update element power orb model animation
  panel.updateElementPowerOrbModelAnimation = function()
    UIDropDownMenu_SetSelectedValue(panel.elementPowerOrbModelAnimation, panel.loadPowerOrbModelAnimation())
  end

  --update element health orb model alpha
  panel.updateElementHealthOrbModelAlpha = function()
    panel.elementHealthOrbModelAlpha:SetValue(panel.loadHealthOrbModelAlpha())
  end

  --update element power orb model alpha
  panel.updateElementPowerOrbModelAlpha = function()
    panel.elementPowerOrbModelAlpha:SetValue(panel.loadPowerOrbModelAlpha())
  end

  ---------------------------------------------
  --SAVE DATA TO DATABASE
  ---------------------------------------------

  --save health orb filling texture
  panel.saveHealthOrbFillingTexture = function(value)
    db.char["HEALTH"].filling.texture = value
  end

  --save power orb filling texture
  panel.savePowerOrbFillingTexture = function(value)
    db.char["POWER"].filling.texture = value
  end

  --save health orb filling color auto
  panel.saveHealthOrbFillingColorAuto = function(value)
    db.char["HEALTH"].filling.colorAuto = value
  end

  --save power orb filling color auto
  panel.savePowerOrbFillingColorAuto = function(value)
    db.char["POWER"].filling.colorAuto = value
  end

  --save health orb filling color
  panel.saveHealthOrbFillingColor = function(r,g,b)
    db.char["HEALTH"].filling.color.r = r
    db.char["HEALTH"].filling.color.g = g
    db.char["HEALTH"].filling.color.b = b
  end

  --save power orb filling color
  panel.savePowerOrbFillingColor = function(r,g,b)
    db.char["POWER"].filling.color.r = r
    db.char["POWER"].filling.color.g = g
    db.char["POWER"].filling.color.b = b
  end

  --save health orb model enable
  panel.saveHealthOrbModelEnable = function(value)
    db.char["HEALTH"].model.enable = value
  end

  --save power orb model enable
  panel.savePowerOrbModelEnable = function(value)
    db.char["POWER"].model.enable = value
  end

  --save health orb model animation
  panel.saveHealthOrbModelAnimation = function(value)
    db.char["HEALTH"].model.displayInfo = value
  end

  --save power orb model animation
  panel.savePowerOrbModelAnimation = function(value)
    db.char["POWER"].model.displayInfo = value
  end

  --save health orb model alpha
  panel.saveHealthOrbModelAlpha = function(value)
    db.char["HEALTH"].model.alpha = value
  end

  --save power orb model alpha
  panel.savePowerOrbModelAlpha = function(value)
    db.char["POWER"].model.alpha = value
  end

  ---------------------------------------------
  --LOAD DATA FROM DATABASE
  ---------------------------------------------

  --load health orb filling texture
  panel.loadHealthOrbFillingTexture = function()
    return db.char["HEALTH"].filling.texture
  end

  --load power orb filling texture
  panel.loadPowerOrbFillingTexture = function()
    return db.char["POWER"].filling.texture
  end

  --load health orb filling color auto
  panel.loadHealthOrbFillingColorAuto = function()
    return db.char["HEALTH"].filling.colorAuto
  end

  --load power orb filling color auto
  panel.loadPowerOrbFillingColorAuto = function()
    return db.char["POWER"].filling.colorAuto
  end

  --load health orb filling color
  panel.loadHealthOrbFillingColor = function()
    return db.char["HEALTH"].filling.color
  end

  --load power orb filling color
  panel.loadPowerOrbFillingColor = function()
    return db.char["POWER"].filling.color
  end

  --load health orb model enable
  panel.loadHealthOrbModelEnable = function()
    return db.char["HEALTH"].model.enable
  end

  --load power orb model enable
  panel.loadPowerOrbModelEnable = function()
    return db.char["POWER"].model.enable
  end

  --load health orb model animation
  panel.loadHealthOrbModelAnimation = function()
    return db.char["HEALTH"].model.displayInfo
  end

  --load power orb model animation
  panel.loadPowerOrbModelAnimation = function()
    return db.char["POWER"].model.displayInfo
  end

  --load health orb model alpha
  panel.loadHealthOrbModelAlpha = function()
    return db.char["HEALTH"].model.alpha
  end

  --load power orb model alpha
  panel.loadPowerOrbModelAlpha = function()
    return db.char["POWER"].model.alpha
  end

  ---------------------------------------------
  --UPDATE PANEL VIEW
  ---------------------------------------------

  panel.updatePanelView = function()

    if InCombatLockdown() then return end

    --update element health orb texture filling
    panel.updateElementHealthOrbTextureFilling()
    --update element power orb texture filling
    panel.updateElementPowerOrbTextureFilling()
    --update element health orb filling color auto
    panel.updateElementHealthOrbFillingColorAuto()
    --update element power orb filling color auto
    panel.updateElementPowerOrbFillingColorAuto()
    --update element health orb texture color
    panel.updateElementHealthOrbTextureColor()
    --update element power orb texture color
    panel.updateElementPowerOrbTextureColor()
    --update element health orb model enable
    panel.updateElementHealthOrbModelEnable()
    --update element power orb model enable
    panel.updateElementPowerOrbModelEnable()
    --update element health orb model animation
    panel.updateElementHealthOrbModelAnimation()
    --update element power orb model animation
    panel.updateElementPowerOrbModelAnimation()
    --update element health orb model alpha
    panel.updateElementHealthOrbModelAlpha()
    --update element power orb model alpha
    panel.updateElementPowerOrbModelAlpha()

  end

  ---------------------------------------------
  --UPDATE ORB VIEW
  ---------------------------------------------

  panel.updateOrbView = function()

    if InCombatLockdown() then return end

    --update health orb filling texture
    panel.updateHealthOrbFillingTexture()
    --update power orb filling texture
    panel.updatePowerOrbFillingTexture()
    --update health orb filling color auto
    panel.updateHealthOrbFillingColorAuto()
    --update power orb filling color auto
    panel.updatePowerOrbFillingColorAuto()
    --update health orb filling color
    panel.updateHealthOrbFillingColor()
    --update power orb filling color
    panel.updatePowerOrbFillingColor()
    --update health orb model enable
    panel.updateHealthOrbModelEnable()
    --update power orb model enable
    panel.updatePowerOrbModelEnable()
    --update health orb model animation
    panel.updateHealthOrbModelAnimation()
    --update power orb model animation
    panel.updatePowerOrbModelAnimation()
    --update health orb model alpha
    panel.updateHealthOrbModelAlpha()
    --update power orb model alpha
    panel.updatePowerOrbModelAlpha()

    --update panel view
    panel.updatePanelView()

  end
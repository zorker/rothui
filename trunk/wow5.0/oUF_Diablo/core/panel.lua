
  ---------------------------------------------
  --  oUF_Diablo - panel
  ---------------------------------------------

  -- The config panel

  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  local db = ns.db

  local unpack = unpack
  local gsub = gsub
  local strmatch = strmatch
  local strlen = strlen
  local CF = CreateFrame
  local CPF = ColorPickerFrame
  local theEnd  = function() end

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
    panel:SetSize(600,600)
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
    --set scrollchild height
    scrollChild:SetHeight(610)
    --left background behind health orb settings
    local t = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-4)
    t:SetTexture(1,1,1)
    t:SetVertexColor(1,0,0,0.1)
    t:SetPoint("TOPLEFT")
    t:SetPoint("BOTTOMLEFT")
    t:SetWidth(scrollFrame:GetWidth()/2-2)
    scrollChild.leftTexture = t
    --right background behind power settings
    local t = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-4)
    t:SetTexture(1,1,1)
    t:SetVertexColor(0,0.4,1,0.1)
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

  --basic button func
  local createBasicButton = function(parent, name, text)
    local button = CF("Button", name.."Button", parent, "UIPanelButtonTemplate")
    button.text = _G[button:GetName().."Text"]
    button.text:SetText(text)
    button:SetWidth(button.text:GetStringWidth()+20)
    button:SetHeight(button.text:GetStringHeight()+12)
    return button
  end

  --basic slider func
  local createBasicSlider = function(parent, name, title, minVal, maxVal, valStep)
    local slider = CF("Slider", name, parent, "OptionsSliderTemplate")
    local editbox = CF("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
    slider:SetMinMaxValues(minVal, maxVal)
    --slider:SetValue(0)
    slider:SetValueStep(valStep)
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
    editbox:SetScript("OnTextChanged", function(self)
      local val = self:GetText()
      if tonumber(val) then
         self:GetParent():SetValue(val)
      end
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
    button.text:SetTextColor(1,1,1)
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
    picker.text:SetTextColor(1,1,1)
    picker.text:SetPoint("LEFT", picker, "RIGHT", 5, 0)
    picker.disabled = false
    --add a Disable() function to the colorpicker element
    function picker:Disable()
      self.disabled = true
      self.color:SetAlpha(0)
      self.text:SetTextColor(0.5,0.5,0.5)
    end
    --add a Enable() function to the colorpicker element
    function picker:Enable()
      self.disabled = false
      self.color:SetAlpha(1)
      self.text:SetTextColor(1,1,1)
    end
    --picker.show
    picker.show = function(r,g,b,a,callback)
      CPF:SetParent(panel)
      CPF:SetColorRGB(r,g,b)
      CPF.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a
      CPF.previousValues = {r,g,b,a}
      CPF.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = callback, callback, callback
      CPF:Hide() -- Need to run the OnShow handler.
      CPF:Show()
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
      --the colorpicker does not reset the callback function properly, so let's do it for him
      CPF.func, CPF.opacityFunc, CPF.cancelFunc = theEnd, theEnd, theEnd
      local r,g,b = self.color:GetVertexColor()
      self.show(r,g,b,nil,self.callback)
    end)
    return picker
  end

  --basic dropdown menu func
  local createBasicDropDownMenu = function(parent, name, text, dataFunc, width, menu, notCheckable)
    local dropdownMenu = CF("Frame", name, parent, "UIDropDownMenuTemplate")
    UIDropDownMenu_SetText(dropdownMenu, text)
    if width then UIDropDownMenu_SetWidth(dropdownMenu, width) end
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
        info.notCheckable = infos[i].notCheckable or notCheckable or false
        info.func = self.click
        UIDropDownMenu_AddButton(info)
      end
    end
    if menu then
      UIDropDownMenu_Initialize(dropdownMenu, dropdownMenu.init, "MENU")
    else
      UIDropDownMenu_Initialize(dropdownMenu, dropdownMenu.init)
    end
    return dropdownMenu
  end

  --basic dropdown menu with a button
  local createBasicDropDownMenuWithButton = function(parent, name, text, dataFunc, width, buttonText)
    local dropdownMenu = createBasicDropDownMenu(parent, name, text, dataFunc, width)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
    end
    local button = createBasicButton(parent, name.."Submit", buttonText)
    button:SetPoint("LEFT", dropdownMenu, "RIGHT", -17, 0)
    dropdownMenu.button = button
    return dropdownMenu
  end

  ---------------------------------------------
  --CREATE PANEL ELEMENT FUNCTIONS
  ---------------------------------------------

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
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelHealthOrbModelAnimation", "Pick an animation", db.getListModel, 160)
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
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelPowerOrbModelAnimation", "Pick an animation", db.getListModel, 160)
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
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbModelAlpha", "Alpha", 0, 1, 0.001)
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
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelAlpha", "Alpha", 0, 1, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbModelAlpha(value)
      --update orb view
      panel.updatePowerOrbModelAlpha()
    end)
    return slider
  end

  --create element health orb model scale
  local createSliderHealthOrbModelScale = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbModelScale", "Scale", 0.001, 6, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.saveHealthOrbModelScale(value)
      --update orb view
      panel.updateHealthOrbModelScale()
    end)
    return slider
  end

  --create element power orb model scale
  local createSliderPowerOrbModelScale = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelScale", "Scale", 0.001, 6, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbModelScale(value)
      --update orb view
      panel.updatePowerOrbModelScale()
    end)
    return slider
  end

  --create element health orb model pos x
  local createSliderHealthOrbModelPosX = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbModelPosX", "X-Axis", -5, 5, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      --panel.saveHealthOrbModelPosX(value)
      --update orb view
      --panel.updateHealthOrbModelPosX()
    end)
    return slider
  end

  --create element power orb model pos x
  local createSliderPowerOrbModelPosX = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelPosX", "X-Axis", -5, 5, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      --panel.savePowerOrbModelPosX(value)
      --update orb view
      --panel.updatePowerOrbModelPosX()
    end)
    return slider
  end

  --create element health orb model pos y
  local createSliderHealthOrbModelPosY = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbModelPosY", "Y-Axis", -5, 5, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      --panel.saveHealthOrbModelPosY(value)
      --update orb view
      --panel.updateHealthOrbModelPosY()
    end)
    return slider
  end

  --create element power orb model pos y
  local createSliderPowerOrbModelPosY = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelPosY", "Y-Axis", -5, 5, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      --panel.savePowerOrbModelPosY(value)
      --update orb view
      --panel.updatePowerOrbModelPosY()
    end)
    return slider
  end

  --create element health orb model rotation
  local createSliderHealthOrbModelRotation = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbModelRotation", "Rotation", -4, 4, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      --panel.saveHealthOrbModelRotation(value)
      --update orb view
      --panel.updateHealthOrbModelRotation()
    end)
    return slider
  end

  --create element power orb model rotation
  local createSliderPowerOrbModelRotation = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelRotation", "Rotation", -4, 4, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      --panel.savePowerOrbModelRotation(value)
      --update orb view
      --panel.updatePowerOrbModelRotation()
    end)
    return slider
  end

  ---------------------------------------------
  --CREATE BOTTOM PANEL ELEMENT FUNCTIONS
  ---------------------------------------------

  --createBottomButtonHealthOrbSave
  local createBottomButtonHealthOrbSave = function(parent)
    --the save button needs a popup with an editbox
    StaticPopupDialogs["OUF_DIABLO_HEALTHORB_SAVE"] = {
      text = "Enter a name for your template:",
      button1 = ACCEPT,
      button2 = CANCEL,
      hasEditBox = 1,
      maxLetters = 24,
      OnAccept = function(self)
        local text = self.editBox:GetText()
        text = text:gsub(" ", "")
        if strmatch(text,"%W") then
          print("|c00FF0000ERROR: Template could not be saved. Non-alphanumerical values found!")
        elseif strlen(text) == 0 then
          print("|c00FF0000ERROR: Template name is empty!")
        else
          db.saveTemplate(text,"HEALTH")
        end
      end,
      EditBoxOnEnterPressed = function(self)
        local text = self:GetParent().editBox:GetText()
        text = text:gsub(" ", "")
        if strmatch(text,"%W") then
          print("|c00FF0000ERROR: Template could not be saved. Non-alphanumerical values found!")
        elseif strlen(text) == 0 then
          print("|c00FF0000ERROR: Template name is empty!")
        else
          db.saveTemplate(text,"HEALTH")
          self:GetParent():Hide()
        end
      end,
      OnShow = function(self)
        self.editBox:SetFocus()
        panel:SetAlpha(0.2)
      end,
      OnHide = function(self)
        ChatEdit_FocusActiveWindow()
        self.editBox:SetText("")
        panel:SetAlpha(1)
      end,
      timeout = 0,
      exclusive = 1,
      whileDead = 1,
      hideOnEscape = 1,
      preferredIndex = 3,
    }
    local button = createBasicButton(parent, addon.."PanelBottomHealthOrbSave", "Save")
    button:HookScript("OnClick", function()
      StaticPopup_Show("OUF_DIABLO_HEALTHORB_SAVE")
    end)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to save the current health orb settings as a template.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  --createBottomButtonHealthOrbLoad
  local createBottomButtonHealthOrbLoad = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelHealthOrbLoadTemplate", "Pick a template", db.getListTemplate, nil, "MENU", true)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      db.loadTemplate(self.value,"HEALTH")
    end
    local button = createBasicButton(parent, addon.."PanelBottomHealthOrbLoad", "Load")
    button:HookScript("OnClick", function()
      ToggleDropDownMenu(1, nil, dropdownMenu, "cursor", 0, 0)
    end)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to load a template into your health orb.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  --createBottomButtonHealthOrbReset
  local createBottomButtonHealthOrbReset = function(parent)
    local button = createBasicButton(parent, addon.."PanelBottomHealthOrbReset", "Reset")
    button:HookScript("OnClick", function()
      db.loadCharacterDataDefaults("HEALTH")
    end)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to reset the healthorb to default.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  --createBottomButtonPowerOrbSave
  local createBottomButtonPowerOrbSave = function(parent)
    --the save button needs a popup with an editbox
    StaticPopupDialogs["OUF_DIABLO_POWERORB_SAVE"] = {
      text = "Enter a name for your template:",
      button1 = ACCEPT,
      button2 = CANCEL,
      hasEditBox = 1,
      maxLetters = 24,
      OnAccept = function(self)
        local text = self.editBox:GetText()
        text = text:gsub(" ", "")
        if strmatch(text,"%W") then
          print("|c00FF0000ERROR: Template could not be saved. Non-alphanumerical values found!")
        elseif strlen(text) == 0 then
          print("|c00FF0000ERROR: Template name is empty!")
        else
          db.saveTemplate(text,"POWER")
        end
      end,
      EditBoxOnEnterPressed = function(self)
        local text = self:GetParent().editBox:GetText()
        text = text:gsub(" ", "")
        if strmatch(text,"%W") then
          print("|c00FF0000ERROR: Template could not be saved. Non-alphanumerical values found!")
        elseif strlen(text) == 0 then
          print("|c00FF0000ERROR: Template name is empty!")
        else
          db.saveTemplate(text,"POWER")
          self:GetParent():Hide()
        end
      end,
      OnShow = function(self)
        self.editBox:SetFocus()
        panel:SetAlpha(0.2)
      end,
      OnHide = function(self)
        ChatEdit_FocusActiveWindow()
        self.editBox:SetText("")
        panel:SetAlpha(1)
      end,
      timeout = 0,
      exclusive = 1,
      whileDead = 1,
      hideOnEscape = 1,
      preferredIndex = 3,
    }
    local button = createBasicButton(parent, addon.."PanelBottomPowerOrbSave", "Save")
    button:HookScript("OnClick", function()
      StaticPopup_Show("OUF_DIABLO_POWERORB_SAVE")
    end)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to save the current power orb settings as a template.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  --createBottomButtonPowerOrbLoad
  local createBottomButtonPowerOrbLoad = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelPowerOrbLoadTemplate", "Pick a template", db.getListTemplate, nil, "MENU", true)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      db.loadTemplate(self.value,"POWER")
    end
    local button = createBasicButton(parent, addon.."PanelBottomPowerOrbLoad", "Load")
    button:HookScript("OnClick", function()
      ToggleDropDownMenu(1, nil, dropdownMenu, "cursor", 0, 0)
    end)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to load a template into your power orb.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  --createBottomButtonPowerOrbReset
  local createBottomButtonPowerOrbReset = function(parent)
    local button = createBasicButton(parent, addon.."PanelBottomPowerOrbReset", "Reset")
    button:HookScript("OnClick", function()
      db.loadCharacterDataDefaults("POWER")
    end)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to reset the powerorb to default.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  --createBottomButtonTemplateDelete
  local createBottomButtonTemplateDelete = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelBottomDeleteTemplate", "Pick a template", db.getListTemplate, nil, "MENU", true)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      db.deleteTemplate(self.value)
    end
    local button = createBasicButton(parent, addon.."PanelBottomTemplateDelete", "Delete")
    button:HookScript("OnClick", function()
      ToggleDropDownMenu(1, nil, dropdownMenu, "cursor", 0, 0)
    end)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to delete a template from the database.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  --[[
  --create element health orb load preset
  local createDropdownHealthOrbLoadPreset = function(parent)
    local dropdownMenu = createBasicDropDownMenuWithButton(parent, addon.."PanelHealthOrbLoadPreset", "Choose", db.getListTemplate, 70, "Load")
    dropdownMenu.button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to load a template into your health orb.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    dropdownMenu.button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    dropdownMenu.button:HookScript("OnClick", function()
      local value = UIDropDownMenu_GetSelectedValue(dropdownMenu)
      if not value then return end
      db.loadTemplate(value,"HEALTH")
      print(value)
    end)
    return dropdownMenu
  end

  --create element power orb load preset
  local createDropdownPowerOrbLoadPreset = function(parent)
    local dropdownMenu = createBasicDropDownMenuWithButton(parent, addon.."PanelPowerOrbLoadPreset", "Choose", db.getListTemplate, 70, "Load")
    dropdownMenu.button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to load a template into your power orb.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    dropdownMenu.button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    dropdownMenu.button:HookScript("OnClick", function()
      local value = UIDropDownMenu_GetSelectedValue(dropdownMenu)
      if not value then return end
      db.loadTemplate(value,"POWER")
      print(value)
    end)
    return dropdownMenu
  end
  ]]--

  ---------------------------------------------
  --SPAWN PANEL ELEMENTS
  ---------------------------------------------

  --create master headline
  panel.elementHealthMasterHeadline = createBasicFontString(panel,nil,nil,"GameFontNormalLarge","Health Orb Settings")
  panel.elementHealthMasterHeadline:SetTextColor(1,0,0)
  panel.elementPowerMasterHeadline = createBasicFontString(panel,nil,nil,"GameFontNormalLarge","Power Orb Settings")
  panel.elementPowerMasterHeadline:SetTextColor(0,0.5,1)
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
  --create model scale slider
  panel.elementHealthOrbModelScale = createSliderHealthOrbModelScale(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelScale = createSliderPowerOrbModelScale(panel.scrollFrame.scrollChild)
  --create model pos x slider
  panel.elementHealthOrbModelPosX = createSliderHealthOrbModelPosX(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelPosX = createSliderPowerOrbModelPosX(panel.scrollFrame.scrollChild)
  --create model pos y slider
  panel.elementHealthOrbModelPosY = createSliderHealthOrbModelPosY(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelPosY = createSliderPowerOrbModelPosY(panel.scrollFrame.scrollChild)
  --create model rotation slider
  panel.elementHealthOrbModelRotation = createSliderHealthOrbModelRotation(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelRotation = createSliderPowerOrbModelRotation(panel.scrollFrame.scrollChild)

  ---------------------------------------------
  --CREATE BOTTOM PANEL BUTTONS
  ---------------------------------------------

  --createBottomButtonHealthOrbSave
  panel.bottomElementHealthOrbSave = createBottomButtonHealthOrbSave(panel)
  --createBottomButtonHealthOrbLoad
  panel.bottomElementHealthOrbLoad = createBottomButtonHealthOrbLoad(panel)
  --createBottomButtonHealthOrbReset
  panel.bottomElementHealthOrbReset = createBottomButtonHealthOrbReset(panel)
  --createBottomButtonPowerOrbSave
  panel.bottomElementPowerOrbSave = createBottomButtonPowerOrbSave(panel)
  --createBottomButtonPowerOrbLoad
  panel.bottomElementPowerOrbLoad = createBottomButtonPowerOrbLoad(panel)
  --createBottomButtonPowerOrbReset
  panel.bottomElementPowerOrbReset = createBottomButtonPowerOrbReset(panel)
  --createBottomButtonTemplateDelete
  panel.bottomElementTemplateDelete = createBottomButtonTemplateDelete(panel)

  ---------------------------------------------
  --POSITION PANEL ELEMENTS
  ---------------------------------------------

  --position master headline
  panel.elementHealthMasterHeadline:SetPoint("BOTTOM", panel.scrollFrame, "TOP", (-panel.scrollFrame:GetWidth()/2-2)/2, 14)
  panel.elementPowerMasterHeadline:SetPoint("BOTTOM", panel.scrollFrame, "TOP", (panel.scrollFrame:GetWidth()/2-2)/2, 14)
  --position filling headline
  panel.elementHealthFillingHeadline:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild.leftTexture, 20, -10)
  panel.elementPowerFillingHeadline:SetPoint("TOPLEFT", panel.scrollFrame.scrollChild.rightTexture, 20, -10)
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
  --position model animation dropdown
  panel.elementHealthOrbModelAnimation:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", -20, -10)
  panel.elementPowerOrbModelAnimation:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", -20, -10)
  --position model enable checkbutton
  panel.elementHealthOrbModelEnable:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", -4, -45)
  panel.elementPowerOrbModelEnable:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", -4, -45)
  --position model alpha slider
  panel.elementHealthOrbModelAlpha:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -80)
  panel.elementPowerOrbModelAlpha:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -80)
  --position model scale slider
  panel.elementHealthOrbModelScale:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -110)
  panel.elementPowerOrbModelScale:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -110)
  --position model pos x slider
  panel.elementHealthOrbModelPosX:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -140)
  panel.elementPowerOrbModelPosX:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -140)
  --position model pos y slider
  panel.elementHealthOrbModelPosY:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -170)
  panel.elementPowerOrbModelPosY:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -170)
  --position model rotation slider
  panel.elementHealthOrbModelRotation:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -200)
  panel.elementPowerOrbModelRotation:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -200)

  ---------------------------------------------
  --POSITION BOTTOM PANEL BUTTONS
  ---------------------------------------------

  --health orb save/load
  panel.bottomElementHealthOrbSave:SetPoint("BOTTOMLEFT",2,4)
  panel.bottomElementHealthOrbLoad:SetPoint("LEFT", panel.bottomElementHealthOrbSave, "RIGHT", -2, 0)
  --panel.elementHealthOrbLoadPreset:SetPoint("LEFT", panel.bottomElementHealthOrbSave, "RIGHT", -17, 0)

  --power orb save/load
  panel.bottomElementPowerOrbSave:SetPoint("BOTTOMLEFT",285,4)
  panel.bottomElementPowerOrbLoad:SetPoint("LEFT", panel.bottomElementPowerOrbSave, "RIGHT", -2, 0)
  --panel.elementPowerOrbLoadPreset:SetPoint("LEFT", panel.bottomElementPowerOrbSave, "RIGHT", -17, 0)

  --position the reset buttons
  panel.bottomElementHealthOrbReset:SetPoint("LEFT", panel.elementHealthMasterHeadline, "RIGHT", 10, 0)
  panel.bottomElementPowerOrbReset:SetPoint("LEFT", panel.elementPowerMasterHeadline, "RIGHT", 10, 0)

  --position the delete button
  panel.bottomElementTemplateDelete:SetPoint("BOTTOMRIGHT",-5,4)

  ---------------------------------------------
  --CREATE HEADLINE BACKGROUNDS
  ---------------------------------------------

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
      local color = ns.cfg.playercolor or { r = 1, g = 0, b = 1, }
      ns.HealthOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    else
      ns.HealthOrb.fill.colorClass = false
      ns.HealthOrb.fill.colorHealth = false
      local color = panel.loadHealthOrbFillingColor()
      ns.HealthOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    end
  end

  --update power orb filling color auto
  panel.updatePowerOrbFillingColorAuto = function()
    if panel.loadPowerOrbFillingColorAuto() then
      ns.PowerOrb.fill.colorPower = true
      local color = ns.cfg.powercolors[select(2, UnitPowerType("player"))] or { r = 1, g = 0, b = 1, }
      ns.PowerOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    else
      ns.PowerOrb.fill.colorPower = false
      local color = panel.loadPowerOrbFillingColor()
      ns.PowerOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    end
  end

  --update health orb filling color
  panel.updateHealthOrbFillingColor = function()
    local color = panel.loadHealthOrbFillingColor()
    ns.HealthOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
  end

  --update power orb filling color
  panel.updatePowerOrbFillingColor = function()
    local color = panel.loadPowerOrbFillingColor()
    ns.PowerOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
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

  --update health orb model scale
  panel.updateHealthOrbModelScale = function()
    ns.HealthOrb.model:SetCamDistanceScale(panel.loadHealthOrbModelScale())
  end

  --update power orb model scale
  panel.updatePowerOrbModelScale = function()
    ns.PowerOrb.model:SetCamDistanceScale(panel.loadPowerOrbModelScale())
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

  --update element health orb model scale
  panel.updateElementHealthOrbModelScale = function()
    panel.elementHealthOrbModelScale:SetValue(panel.loadHealthOrbModelScale())
  end

  --update element power orb model scale
  panel.updateElementPowerOrbModelScale = function()
    panel.elementPowerOrbModelScale:SetValue(panel.loadPowerOrbModelScale())
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

  --save health orb model scale
  panel.saveHealthOrbModelScale = function(value)
    db.char["HEALTH"].model.camDistanceScale = value
  end

  --save power orb model scale
  panel.savePowerOrbModelScale = function(value)
    db.char["POWER"].model.camDistanceScale = value
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

  --load health orb model scale
  panel.loadHealthOrbModelScale = function()
    return db.char["HEALTH"].model.camDistanceScale
  end

  --load power orb model scale
  panel.loadPowerOrbModelScale = function()
    return db.char["POWER"].model.camDistanceScale
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
    --update element health orb model scale
    panel.updateElementHealthOrbModelScale()
    --update element power orb model scale
    panel.updateElementPowerOrbModelScale()
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
    --update health orb filling color
    panel.updateHealthOrbFillingColor()
    --update power orb filling color
    panel.updatePowerOrbFillingColor()
    --important -- since auto coloring rewrites the color it has to be called after filling color
    --update health orb filling color auto
    panel.updateHealthOrbFillingColorAuto()
    --update power orb filling color auto
    panel.updatePowerOrbFillingColorAuto()
    --update health orb model enable
    panel.updateHealthOrbModelEnable()
    --update power orb model enable
    panel.updatePowerOrbModelEnable()
    --update health orb model animation
    panel.updateHealthOrbModelAnimation()
    --update power orb model animation
    panel.updatePowerOrbModelAnimation()
    --update health orb model scale
    panel.updateHealthOrbModelScale()
    --update power orb model scale
    panel.updatePowerOrbModelScale()
    --update health orb model alpha
    panel.updateHealthOrbModelAlpha()
    --update power orb model alpha
    panel.updatePowerOrbModelAlpha()

    --update panel view
    panel.updatePanelView()

  end

  ---------------------------------------------
  --FIX THE ORB DISPLAY ON NON-FULLY-FILLED ORBS
  ---------------------------------------------

  --I want to use the orbs as a preview medium while in the config
  --some orbs are empty (rage)
  --empty orbs display nothing so we make sure all orbs are filled on config loadup
  --forceUpdate on close makes sure they reset properly

  function panel:Enable()
    --register some stuff
    self.eventHelper:RegisterUnitEvent("UNIT_HEALTH", "player")
    self.eventHelper:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "player")
    self.eventHelper:RegisterUnitEvent("UNIT_POWER", "player")
    self.eventHelper:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
    self.eventHelper:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player")
    self.eventHelper:SetScript("OnEvent", function(self) self:SetOrbsToMax() end)
    self.eventHelper:SetOrbsToMax()
  end

  function panel:Disable()
    self.eventHelper:UnregisterEvent("UNIT_HEALTH")
    self.eventHelper:UnregisterEvent("UNIT_HEALTH_FREQUENT")
    self.eventHelper:UnregisterEvent("UNIT_POWER")
    self.eventHelper:UnregisterEvent("UNIT_POWER_FREQUENT")
    self.eventHelper:UnregisterEvent("UNIT_DISPLAYPOWER")
    self.eventHelper:SetScript("OnEvent", nil)
    self.eventHelper:SetOrbsToDefault()
    --reset the focus to the last active chatwindow
    ChatEdit_FocusActiveWindow() --nice function ;)
  end

  do
    local eventHelper = CreateFrame("Frame")
    function eventHelper:SetOrbsToMax()
      local hbar, pbar = ns.HealthOrb.fill, ns.PowerOrb.fill
      local hmin, hmax = hbar:GetMinMaxValues()
      local pmin, pmax = pbar:GetMinMaxValues()
      hbar:SetValue(hmax)
      pbar:SetValue(pmax)
    end
    function eventHelper:SetOrbsToDefault()
      local hbar, pbar = ns.HealthOrb.fill, ns.PowerOrb.fill
      hbar:ForceUpdate()
      pbar:ForceUpdate()
    end
    panel.eventHelper = eventHelper
    panel:HookScript("OnShow", function(self) self:Enable() end)
    panel:HookScript("OnHide", function(self) self:Disable() end)
  end
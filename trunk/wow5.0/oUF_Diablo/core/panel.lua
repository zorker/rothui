
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
  local tinsert = tinsert
  local wipe = wipe
  local floor = floor
  local strmatch = strmatch
  local strlen = strlen
  local CF = CreateFrame
  local CPF = ColorPickerFrame
  local theEnd  = function() end

  --object container
  local panel = CF("Frame",addon.."ConfigPanel",UIParent,"ButtonFrameTemplate")
  panel:SetFrameStrata("HIGH")
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
    scrollChild:SetHeight(930)
    --left background behind health orb settings
    local t = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-4)
    t:SetTexture(1,1,1)
    t:SetVertexColor(1,0,0)
    t:SetAlpha(0.1)
    t:SetPoint("TOPLEFT")
    t:SetPoint("BOTTOMLEFT")
    t:SetWidth(scrollFrame:GetWidth()/2-2)
    scrollChild.leftTexture = t
    --right background behind power settings
    local t = scrollChild:CreateTexture(nil,"BACKGROUND",nil,-4)
    t:SetTexture(1,1,1)
    t:SetVertexColor(0,0,1)
    t:SetAlpha(0.1)
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
    t:SetVertexColor(255,255,255,0.05)
    t:SetPoint("TOP",headline,0,4)
    t:SetPoint("LEFT",headline,-20,0)
    t:SetWidth(275)
    t:SetPoint("BOTTOM",headline,0,-4)
    t:SetBlendMode("ADD")
  end

  local createTooltipButton = function(parent,pointParent,text)
    local button = CF("Button", nil, parent)
    button:SetAllPoints(pointParent)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine(text, 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
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
  local createBasicButton = function(parent, name, text,adjustWidth, adjustHeight)
    local button = CF("Button", name.."Button", parent, "UIPanelButtonTemplate")
    button.text = _G[button:GetName().."Text"]
    button.text:SetText(text)
    button:SetWidth(button.text:GetStringWidth()+(adjustWidth or 20))
    button:SetHeight(button.text:GetStringHeight()+(adjustHeight or 12))
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
    slider.textLow = _G[name.."Low"]
    slider.textHigh = _G[name.."High"]
    slider.textLow:SetText(floor(minVal))
    slider.textHigh:SetText(floor(maxVal))
    slider.textLow:SetTextColor(0.4,0.4,0.4)
    slider.textHigh:SetTextColor(0.4,0.4,0.4)
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
  local createBasicColorPicker = function(parent, name, title, width, height)
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
    picker.text = createBasicFontString(picker,nil,nil,"GameFontNormal",title)
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
  local createBasicDropDownMenu = function(parent, name, title, dataFunc, width, displayMode, dynamicList, headline)
    local dropdownMenu = CF("Frame", name, parent, "UIDropDownMenuTemplate")

    if headline then
      dropdownMenu.headline = createBasicFontString(dropdownMenu,nil,nil,"GameFontNormal",headline)
      --dropdownMenu.headline:SetTextColor(1,1,1)
      dropdownMenu.headline:SetPoint("BOTTOMLEFT", dropdownMenu, "TOPLEFT", 20, 5)
    end

    UIDropDownMenu_SetText(dropdownMenu, title)
    if width then UIDropDownMenu_SetWidth(dropdownMenu, width) end
    dropdownMenu.init = function(self, level)
      self.info = self.info or {}
      self.infos = self.infos or {}
      wipe(self.infos)
      if dynamicList then
        self.data = dataFunc() --load data on init
      else
        self.data = self.data or dataFunc() --static list
      end
      --level 1
      if level == 1 then
        tinsert(self.infos, { text = title, isTitle = true, notCheckable = true, notClickable = true, })
        tinsert(self.infos, { text = "|cFF666666~~~~~~~~~~~~~~~|r", notCheckable = true, notClickable = true, })
        if #self.data == 0 then
          tinsert(self.infos, { text = "|cFFFF0000No data found|r", notCheckable = true, notClickable = true, })
        end
        for index, data in pairs(self.data) do
          tinsert(self.infos, {
            text              = data.key,
            value             = data.value,
            func              = self.click,
            isTitle           = data.isTitle or false,
            hasArrow          = data.hasArrow or false,
            notClickable      = data.notClickable or false,
            notCheckable      = data.notCheckable or false,
            keepShownOnClick  = data.keepShownOnClick or false,
          })
          if data.hasArrow then
            self.infos[#self.infos].func = nil --remove the function call on multilevel menu
          end
        end
        tinsert(self.infos, { text = "|cFF666666~~~~~~~~~~~~~~~|r", notCheckable = true, notClickable = true, })
        tinsert(self.infos, { text = "|cFF3399FFClose menu|r", notCheckable = true, func = function() CloseDropDownMenus() end, })
      end
      --level 2
      if level == 2 then
        for index, data in pairs(self.data) do
          if UIDROPDOWNMENU_MENU_VALUE == data.value then
            for index2, data2 in pairs(data.menuList) do
              tinsert(self.infos, {
                text              = data2.key,
                value             = data2.value,
                func              = self.click,
                isTitle           = data2.isTitle or false,
                hasArrow          = data2.hasArrow or false,
                notClickable      = data2.notClickable or false,
                notCheckable      = data2.notCheckable or false,
                keepShownOnClick  = data2.keepShownOnClick or false,
              })
            end
            break
          end
        end
      end
      --create buttons
      for i=1, #self.infos do
        wipe(self.info)
        self.info.text = self.infos[i].text
        self.info.value = self.infos[i].value or nil
        self.info.isTitle = self.infos[i].isTitle or false
        self.info.hasArrow = self.infos[i].hasArrow or false
        self.info.keepShownOnClick = self.infos[i].keepShownOnClick or false
        self.info.notClickable = self.infos[i].notClickable or false
        self.info.notCheckable = self.infos[i].notCheckable or false
        self.info.func = self.infos[i].func or nil
        UIDropDownMenu_AddButton(self.info, level)
      end
    end
    UIDropDownMenu_Initialize(dropdownMenu, dropdownMenu.init, displayMode)
    return dropdownMenu
  end

  ---------------------------------------------
  --CREATE PANEL ELEMENT FUNCTIONS
  ---------------------------------------------

  --create element health orb filling texture
  local createDropdownHealthOrbFillingTexture = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelHealthOrbFillingTexture", "Choose texture", db.getListFillingTexture, 196)
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
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelPowerOrbFillingTexture", "Choose texture", db.getListFillingTexture, 196)
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
    local button = createBasicCheckButton(parent, addon.."PanelHealthOrbFillingColorAuto", "Automatic coloring (class/power)?")
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
    local button = createBasicCheckButton(parent, addon.."PanelPowerOrbFillingColorAuto", "Automatic coloring (class/power)?")
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
    local picker = createBasicColorPicker(parent, addon.."PanelHealthOrbFillingColor", "Filling texture color", 75, 25)
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
    local picker = createBasicColorPicker(parent, addon.."PanelPowerOrbFillingColor", "Filling texture color", 75, 25)
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
      --update the panel view, other panels need to be shown / hidden
      panel.updateElementHealthOrbModelEnable()
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
      --update the panel view, other panels need to be shown / hidden
      panel.updateElementPowerOrbModelEnable()
    end)
    return button
  end

  --create element health orb model animation
  local createDropdownHealthOrbModelAnimation = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelHealthOrbModelAnimation", "Choose animation", db.getListModel, 196)
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
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelPowerOrbModelAnimation", "Choose animation", db.getListModel, 196)
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
      panel.saveHealthOrbModelPosX(value)
      --update orb view
      panel.updateHealthOrbModelPosX()
    end)
    return slider
  end

  --create element power orb model pos x
  local createSliderPowerOrbModelPosX = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelPosX", "X-Axis", -5, 5, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbModelPosX(value)
      --update orb view
      panel.updatePowerOrbModelPosX()
    end)
    return slider
  end

  --create element health orb model pos y
  local createSliderHealthOrbModelPosY = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbModelPosY", "Y-Axis", -5, 5, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.saveHealthOrbModelPosY(value)
      --update orb view
      panel.updateHealthOrbModelPosY()
    end)
    return slider
  end

  --create element power orb model pos y
  local createSliderPowerOrbModelPosY = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelPosY", "Y-Axis", -5, 5, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbModelPosY(value)
      --update orb view
      panel.updatePowerOrbModelPosY()
    end)
    return slider
  end

  --create element health orb model rotation
  local createSliderHealthOrbModelRotation = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbModelRotation", "Rotation", -4, 4, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.saveHealthOrbModelRotation(value)
      --update orb view
      panel.updateHealthOrbModelRotation()
    end)
    return slider
  end

  --create element power orb model rotation
  local createSliderPowerOrbModelRotation = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelRotation", "Rotation", -4, 4, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbModelRotation(value)
      --update orb view
      panel.updatePowerOrbModelRotation()
    end)
    return slider
  end

  --create element health orb model zoom
  local createSliderHealthOrbModelZoom = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbModelZoom", "Portrait-Zoom", 0, 1, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.saveHealthOrbModelZoom(value)
      --update orb view
      panel.updateHealthOrbModelZoom()
    end)
    return slider
  end

  --create element power orb model zoom
  local createSliderPowerOrbModelZoom = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbModelZoom", "Portrait-Zoom", 0, 1, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbModelZoom(value)
      --update orb view
      panel.updatePowerOrbModelZoom()
    end)
    return slider
  end

  --create element health orb highlight alpha
  local createSliderHealthOrbHighlightAlpha = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbHighlightAlpha", "Alpha", 0, 1, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.saveHealthOrbHighlightAlpha(value)
      --update orb view
      panel.updateHealthOrbHighlightAlpha()
    end)
    return slider
  end

  --create element power orb highlight alpha
  local createSliderPowerOrbHighlightAlpha = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbHighlightAlpha", "Alpha", 0, 1, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbHighlightAlpha(value)
      --update orb view
      panel.updatePowerOrbHighlightAlpha()
    end)
    return slider
  end

  --create element health orb spark alpha
  local createSliderHealthOrbSparkAlpha = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbSparkAlpha", "Alpha", 0, 1, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.saveHealthOrbSparkAlpha(value)
      --update orb view
      panel.updateHealthOrbSparkAlpha()
    end)
    return slider
  end

  --create element power orb spark alpha
  local createSliderPowerOrbSparkAlpha = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbSparkAlpha", "Alpha", 0, 1, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbSparkAlpha(value)
      --update orb view
      panel.updatePowerOrbSparkAlpha()
    end)
    return slider
  end

  --create element health orb value hide empty
  local createCheckButtonHealthOrbValueHideEmpty = function(parent)
    local button = createBasicCheckButton(parent, addon.."PanelHealthOrbValueHideEmpty", "Hide on empty*")
    button:HookScript("OnClick", function(self,value)
      --save value
      panel.saveHealthOrbValueHideEmpty(self:GetChecked())
    end)
    return button
  end

  --create element power orb value hide empty
  local createCheckButtonPowerOrbValueHideEmpty = function(parent)
    local button = createBasicCheckButton(parent, addon.."PanelPowerOrbValueHideEmpty", "Hide on empty*")
    button:HookScript("OnClick", function(self,value)
      --save value
      panel.savePowerOrbValueHideEmpty(self:GetChecked())
    end)
    return button
  end


  --create element health orb value hide full
  local createCheckButtonHealthOrbValueHideFull = function(parent)
    local button = createBasicCheckButton(parent, addon.."PanelHealthOrbValueHideFull", "Hide on full*")
    button:HookScript("OnClick", function(self,value)
      --save value
      panel.saveHealthOrbValueHideFull(self:GetChecked())
    end)
    return button
  end

  --create element power orb value hide full
  local createCheckButtonPowerOrbValueHideFull = function(parent)
    local button = createBasicCheckButton(parent, addon.."PanelPowerOrbValueHideFull", "Hide on full*")
    button:HookScript("OnClick", function(self,value)
      --save value
      panel.savePowerOrbValueHideFull(self:GetChecked())
    end)
    return button
  end

  --create element health orb value alpha
  local createSliderHealthOrbValueAlpha = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelHealthOrbValueAlpha", "Alpha", 0, 1, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.saveHealthOrbValueAlpha(value)
      --update orb view
      panel.updateHealthOrbValueAlpha()
    end)
    return slider
  end

  --create element power orb value alpha
  local createSliderPowerOrbValueAlpha = function(parent)
    local slider = createBasicSlider(parent, addon.."PanelPowerOrbValueAlpha", "Alpha", 0, 1, 0.001)
    slider:HookScript("OnValueChanged", function(self,value)
      --save value
      panel.savePowerOrbValueAlpha(value)
      --update orb view
      panel.updatePowerOrbValueAlpha()
    end)
    return slider
  end

  --create element health orb value top color
  local createPickerHealthOrbValueTopColor = function(parent)
    local picker = createBasicColorPicker(parent, addon.."PanelHealthOrbValueTopColor", "Text color", 75, 25)
    picker.click = function(r,g,b)
      --save value
      panel.saveHealthOrbValueTopColor(r,g,b)
      --update orb view
      panel.updateHealthOrbValueTopColor()
    end
    return picker
  end

  --create element power orb value top color
  local createPickerPowerOrbValueTopColor = function(parent)
    local picker = createBasicColorPicker(parent, addon.."PanelPowerOrbValueTopColor", "Text color", 75, 25)
    picker.click = function(r,g,b)
      --save value
      panel.savePowerOrbValueTopColor(r,g,b)
      --update orb view
      panel.updatePowerOrbValueTopColor()
    end
    return picker
  end

  --create element health orb value bottom color
  local createPickerHealthOrbValueBottomColor = function(parent)
    local picker = createBasicColorPicker(parent, addon.."PanelHealthOrbValueBottomColor", "Text color", 75, 25)
    picker.click = function(r,g,b)
      --save value
      panel.saveHealthOrbValueBottomColor(r,g,b)
      --update orb view
      panel.updateHealthOrbValueBottomColor()
    end
    return picker
  end

  --create element power orb value bottom color
  local createPickerPowerOrbValueBottomColor = function(parent)
    local picker = createBasicColorPicker(parent, addon.."PanelPowerOrbValueBottomColor", "Text color", 75, 25)
    picker.click = function(r,g,b)
      --save value
      panel.savePowerOrbValueBottomColor(r,g,b)
      --update orb view
      panel.updatePowerOrbValueBottomColor()
    end
    return picker
  end

  --create element health orb value top tag
  local createDropdownHealthOrbValueTopTag = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelHealthOrbValueTopTag", "Choose top health tag", db.getListTag, 196)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      --save value
      panel.saveHealthOrbValueTopTag(self.value)
      --update orb view
      panel.updateHealthOrbValueTopTag()
    end
    return dropdownMenu
  end

  --create element power orb value top tag
  local createDropdownPowerOrbValueTopTag = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelPowerOrbValueTopTag", "Choose top power tag", db.getListTag, 196)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      --save value
      panel.savePowerOrbValueTopTag(self.value)
      --update orb view
      panel.updatePowerOrbValueTopTag()
    end
    return dropdownMenu
  end

  --create element health orb value bottom tag
  local createDropdownHealthOrbValueBottomTag = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelHealthOrbValueBottomTag", "Choose bottom health tag", db.getListTag, 196)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      --save value
      panel.saveHealthOrbValueBottomTag(self.value)
      --update orb view
      panel.updateHealthOrbValueBottomTag()
    end
    return dropdownMenu
  end

  --create element power orb value bottom tag
  local createDropdownPowerOrbValueBottomTag = function(parent)
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelPowerOrbValueBottomTag", "Choose bottom power tag", db.getListTag, 196)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      --save value
      panel.savePowerOrbValueBottomTag(self.value)
      --update orb view
      panel.updatePowerOrbValueBottomTag()
    end
    return dropdownMenu
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
    local button = createBasicButton(parent, addon.."PanelBottomHealthOrbSave", "Save as template", 30, 20)
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
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelHealthOrbLoadTemplate", "Choose template", db.getListTemplate, nil, nil, true)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      db.loadTemplate(self.value,"HEALTH")
    end
    local button = createBasicButton(parent, addon.."PanelBottomHealthOrbLoad", "Load template", 30, 20)
    button:HookScript("OnClick", function()
      ToggleDropDownMenu(1, nil, dropdownMenu, "cursor", 5, -5)
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
    local button = createBasicButton(parent, addon.."PanelBottomPowerOrbSave", "Save as template", 30, 20)
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
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelPowerOrbLoadTemplate", "Choose template", db.getListTemplate, nil, nil, true)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      db.loadTemplate(self.value,"POWER")
    end
    local button = createBasicButton(parent, addon.."PanelBottomPowerOrbLoad", "Load template", 30, 20)
    button:HookScript("OnClick", function()
      ToggleDropDownMenu(1, nil, dropdownMenu, "cursor", 5, -5)
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
    local dropdownMenu = createBasicDropDownMenu(parent, addon.."PanelBottomDeleteTemplate", "Choose template", db.getListTemplate, nil, nil, true)
    dropdownMenu.click = function(self)
      UIDropDownMenu_SetSelectedValue(dropdownMenu, self.value)
      db.deleteTemplate(self.value)
    end
    local button = createBasicButton(parent, addon.."PanelBottomTemplateDelete", "Delete")
    button:HookScript("OnClick", function()
      ToggleDropDownMenu(1, nil, dropdownMenu, "cursor", 5, -5)
    end)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to delete a template from the database.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  --createBottomButtonTemplateReload
  local createBottomButtonTemplateReload = function(parent)
    local button = createBasicButton(parent, addon.."PanelBottomTemplateReload", "Reload UI")
    button:HookScript("OnClick", function()
      db.char.reload = true
      ReloadUI()
    end)
    button:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine("Click here to reload the user interface.", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    return button
  end

  ---------------------------------------------
  --SPAWN PANEL ELEMENTS
  ---------------------------------------------

  --create master headline
  panel.elementHealthMasterHeadline = createBasicFontString(panel,nil,nil,"GameFontNormalLarge","Health Orb Settings")
  panel.elementPowerMasterHeadline = createBasicFontString(panel,nil,nil,"GameFontNormalLarge","Power Orb Settings")
  --create filling headline
  panel.elementHealthFillingHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Filling Texture")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementHealthFillingHeadline,"The following options allow you to edit the filling orb texture and color.")
  panel.elementPowerFillingHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Filling Texture")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementPowerFillingHeadline,"The following options allow you to edit the filling orb texture and color.")
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
  panel.elementHealthModelHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Model Animation")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementHealthModelHeadline,"The following options allow you to edit the animation model settings.")
  panel.elementPowerModelHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Model Animation")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementPowerModelHeadline,"The following options allow you to edit the animation model settings.")
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
  --create model zoom slider
  panel.elementHealthOrbModelZoom = createSliderHealthOrbModelZoom(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbModelZoom = createSliderPowerOrbModelZoom(panel.scrollFrame.scrollChild)
  --create highlight headline
  panel.elementHealthHighlightHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Highlight Texture")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementHealthHighlightHeadline,"The following option allows you to adjust the opacity of the highlight texture.")
  panel.elementPowerHighlightHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Highlight Texture")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementPowerHighlightHeadline,"The following option allows you to adjust the opacity of the highlight texture.")
  --create highlight alpha slider
  panel.elementHealthOrbHighlightAlpha = createSliderHealthOrbHighlightAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbHighlightAlpha = createSliderPowerOrbHighlightAlpha(panel.scrollFrame.scrollChild)
  --create spark headline
  panel.elementHealthSparkHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Spark Texture")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementHealthSparkHeadline,"The following option allows you to adjust the opacity of the spark texture.\n|cFFFFFFFFThe texture helps blending the filling texture.")
  panel.elementPowerSparkHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Spark Texture")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementPowerSparkHeadline,"The following option allows you to adjust the opacity of the spark texture.\n|cFFFFFFFFThe texture helps blending the filling texture.")
  --create spark alpha slider
  panel.elementHealthOrbSparkAlpha = createSliderHealthOrbSparkAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbSparkAlpha = createSliderPowerOrbSparkAlpha(panel.scrollFrame.scrollChild)
  --create value headline
  panel.elementHealthOrbValueHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Orb Value Visibility")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementHealthOrbValueHeadline, "The following options allow you adjust the orb values.\n|cFFFFFFFF*Some changes will only become visible on config panel close otherwise it would be impossible to set up the orb values.")
  panel.elementPowerOrbValueHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Orb Value Visibility")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementPowerOrbValueHeadline, "The following options allow you adjust the orb values.\n|cFFFFFFFF*Some changes will only become visible on config panel close otherwise it would be impossible to set up the orb values.")
  --create element value hide empty checkbutton
  panel.elementHealthOrbValueHideEmpty = createCheckButtonHealthOrbValueHideEmpty(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueHideEmpty = createCheckButtonPowerOrbValueHideEmpty(panel.scrollFrame.scrollChild)
  --create element value hide full checkbutton
  panel.elementHealthOrbValueHideFull = createCheckButtonHealthOrbValueHideFull(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueHideFull = createCheckButtonPowerOrbValueHideFull(panel.scrollFrame.scrollChild)
  --create element value alpha slider
  panel.elementHealthOrbValueAlpha = createSliderHealthOrbValueAlpha(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueAlpha = createSliderPowerOrbValueAlpha(panel.scrollFrame.scrollChild)
  --create value top headline
  panel.elementHealthOrbValueTopHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Top Orb Value Tag/Color")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementHealthOrbValueTopHeadline, "The following options allow you adjust color and tag of the top orb value.")
  panel.elementPowerOrbValueTopHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Top Orb Value Tag/Color")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementPowerOrbValueTopHeadline, "The following options allow you adjust color and tag of the top orb value.")
  --create element value top tag dropdown
  panel.elementHealthOrbValueTopTag = createDropdownHealthOrbValueTopTag(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueTopTag = createDropdownPowerOrbValueTopTag(panel.scrollFrame.scrollChild)
  --create element value top color picker
  panel.elementHealthOrbValueTopColor = createPickerHealthOrbValueTopColor(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueTopColor = createPickerPowerOrbValueTopColor(panel.scrollFrame.scrollChild)
  --create value top headline
  panel.elementHealthOrbValueBottomHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Bottom Orb Value Tag/Color")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementHealthOrbValueBottomHeadline, "The following options allow you adjust color and tag of the bottom orb value.")
  panel.elementPowerOrbValueBottomHeadline = createBasicFontString(panel.scrollFrame.scrollChild,nil,nil,"GameFontNormalLarge","Bottom Orb Value Tag/Color")
  createTooltipButton(panel.scrollFrame.scrollChild,panel.elementPowerOrbValueBottomHeadline, "The following options allow you adjust color and tag of the bottom orb value.")
  --create element value bottom tag dropdown
  panel.elementHealthOrbValueBottomTag = createDropdownHealthOrbValueBottomTag(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueBottomTag = createDropdownPowerOrbValueBottomTag(panel.scrollFrame.scrollChild)
  --create element value bottom color picker
  panel.elementHealthOrbValueBottomColor = createPickerHealthOrbValueBottomColor(panel.scrollFrame.scrollChild)
  panel.elementPowerOrbValueBottomColor = createPickerPowerOrbValueBottomColor(panel.scrollFrame.scrollChild)

  ---------------------------------------------
  --SPAWN HEADLINE BACKGROUNDS
  ---------------------------------------------

  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthFillingHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthModelHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementPowerFillingHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementPowerModelHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthHighlightHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementPowerHighlightHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthSparkHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementPowerSparkHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthOrbValueHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementPowerOrbValueHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthOrbValueTopHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementPowerOrbValueTopHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementHealthOrbValueBottomHeadline)
  createHeadlineBackground(panel.scrollFrame.scrollChild,panel.elementPowerOrbValueBottomHeadline)

  ---------------------------------------------
  --SPAWN BOTTOM PANEL BUTTONS
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
  --createBottomButtonTemplateReload
  panel.bottomElementTemplateReload = createBottomButtonTemplateReload(panel)

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
  --position model enable checkbutton
  panel.elementHealthOrbModelEnable:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", -4, -10)
  panel.elementPowerOrbModelEnable:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", -4, -10)
  --position model animation dropdown
  panel.elementHealthOrbModelAnimation:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", -20, -36)
  panel.elementPowerOrbModelAnimation:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", -20, -36)
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
  --position model zoom slider
  panel.elementHealthOrbModelZoom:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -230)
  panel.elementPowerOrbModelZoom:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -230)
  --position highlight headline
  panel.elementHealthHighlightHeadline:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -270)
  panel.elementPowerHighlightHeadline:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -270)
  --position highlight alpha slider
  panel.elementHealthOrbHighlightAlpha:SetPoint("TOPLEFT", panel.elementHealthHighlightHeadline, "BOTTOMLEFT", 0, -20)
  panel.elementPowerOrbHighlightAlpha:SetPoint("TOPLEFT", panel.elementPowerHighlightHeadline, "BOTTOMLEFT", 0, -20)
  --position spark headline
  panel.elementHealthSparkHeadline:SetPoint("TOPLEFT", panel.elementHealthHighlightHeadline, "BOTTOMLEFT", 0, -60)
  panel.elementPowerSparkHeadline:SetPoint("TOPLEFT", panel.elementPowerHighlightHeadline, "BOTTOMLEFT", 0, -60)
  --position spark alpha slider
  panel.elementHealthOrbSparkAlpha:SetPoint("TOPLEFT", panel.elementHealthSparkHeadline, "BOTTOMLEFT", 0, -20)
  panel.elementPowerOrbSparkAlpha:SetPoint("TOPLEFT", panel.elementPowerSparkHeadline, "BOTTOMLEFT", 0, -20)
  --position value headline
  panel.elementHealthOrbValueHeadline:SetPoint("TOPLEFT", panel.elementHealthSparkHeadline, "BOTTOMLEFT", 0, -60)
  panel.elementPowerOrbValueHeadline:SetPoint("TOPLEFT", panel.elementPowerSparkHeadline, "BOTTOMLEFT", 0, -60)
  --position element value hide empty checkbutton
  panel.elementHealthOrbValueHideEmpty:SetPoint("TOPLEFT", panel.elementHealthOrbValueHeadline, "BOTTOMLEFT", -4, -10)
  panel.elementPowerOrbValueHideEmpty:SetPoint("TOPLEFT", panel.elementPowerOrbValueHeadline, "BOTTOMLEFT", -4, -10)
  --position element value hide full checkbutton
  panel.elementHealthOrbValueHideFull:SetPoint("TOPLEFT", panel.elementHealthOrbValueHeadline, "BOTTOMLEFT", -4, -35)
  panel.elementPowerOrbValueHideFull:SetPoint("TOPLEFT", panel.elementPowerOrbValueHeadline, "BOTTOMLEFT", -4, -35)
  --position element value alpha slider
  panel.elementHealthOrbValueAlpha:SetPoint("TOPLEFT", panel.elementHealthOrbValueHeadline, "BOTTOMLEFT", 0, -73)
  panel.elementPowerOrbValueAlpha:SetPoint("TOPLEFT", panel.elementPowerOrbValueHeadline, "BOTTOMLEFT", 0, -73)
  --position element value top headline
  panel.elementHealthOrbValueTopHeadline:SetPoint("TOPLEFT", panel.elementHealthOrbValueHeadline, "BOTTOMLEFT", 0, -110)
  panel.elementPowerOrbValueTopHeadline:SetPoint("TOPLEFT", panel.elementPowerOrbValueHeadline, "BOTTOMLEFT", 0, -110)
  --position element value top tag dropdown
  panel.elementHealthOrbValueTopTag:SetPoint("TOPLEFT", panel.elementHealthOrbValueTopHeadline, "BOTTOMLEFT", -20, -10)
  panel.elementPowerOrbValueTopTag:SetPoint("TOPLEFT", panel.elementPowerOrbValueTopHeadline, "BOTTOMLEFT", -20, -10)
  --position element value top color picker
  panel.elementHealthOrbValueTopColor:SetPoint("TOPLEFT", panel.elementHealthOrbValueTopHeadline, "BOTTOMLEFT", -4, -45)
  panel.elementPowerOrbValueTopColor:SetPoint("TOPLEFT", panel.elementPowerOrbValueTopHeadline, "BOTTOMLEFT", -4, -45)
  --position element value bottom headline
  panel.elementHealthOrbValueBottomHeadline:SetPoint("TOPLEFT", panel.elementHealthOrbValueTopHeadline, "BOTTOMLEFT", 0, -85)
  panel.elementPowerOrbValueBottomHeadline:SetPoint("TOPLEFT", panel.elementPowerOrbValueTopHeadline, "BOTTOMLEFT", 0, -85)
  --position element value bottom tag dropdown
  panel.elementHealthOrbValueBottomTag:SetPoint("TOPLEFT", panel.elementHealthOrbValueBottomHeadline, "BOTTOMLEFT", -20, -10)
  panel.elementPowerOrbValueBottomTag:SetPoint("TOPLEFT", panel.elementPowerOrbValueBottomHeadline, "BOTTOMLEFT", -20, -10)
  --position element value bottom color picker
  panel.elementHealthOrbValueBottomColor:SetPoint("TOPLEFT", panel.elementHealthOrbValueBottomHeadline, "BOTTOMLEFT", -4, -45)
  panel.elementPowerOrbValueBottomColor:SetPoint("TOPLEFT", panel.elementPowerOrbValueBottomHeadline, "BOTTOMLEFT", -4, -45)

  ---------------------------------------------
  --POSITION BOTTOM PANEL BUTTONS
  ---------------------------------------------

  --health orb save/load
  panel.bottomElementHealthOrbSave:SetPoint("BOTTOMLEFT",35,10)
  panel.bottomElementHealthOrbLoad:SetPoint("LEFT", panel.bottomElementHealthOrbSave, "RIGHT", 0, 0)
  panel.bottomElementHealthOrbSave:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)
  panel.bottomElementHealthOrbLoad:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)
  --power orb save/load
  panel.bottomElementPowerOrbSave:SetPoint("BOTTOMLEFT",315,10)
  panel.bottomElementPowerOrbLoad:SetPoint("LEFT", panel.bottomElementPowerOrbSave, "RIGHT", 0, 0)
  panel.bottomElementPowerOrbSave:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)
  panel.bottomElementPowerOrbLoad:SetFrameLevel(panel.scrollFrame.scrollChild:GetFrameLevel()+2)
  --position the reset buttons
  panel.bottomElementHealthOrbReset:SetPoint("LEFT", panel.elementHealthMasterHeadline, "RIGHT", 10, 0)
  panel.bottomElementPowerOrbReset:SetPoint("LEFT", panel.elementPowerMasterHeadline, "RIGHT", 10, 0)
  --position the delete button
  panel.bottomElementTemplateDelete:SetPoint("BOTTOM",-12,-18)
  --position the reload ui button
  panel.bottomElementTemplateReload:SetPoint("BOTTOMRIGHT",-12,-18)

  ---------------------------------------------
  --UPDATE ORB ELEMENTS
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
      --ns.HealthOrb.fill:ForceUpdate()
      panel.scrollFrame.scrollChild.leftTexture:SetVertexColor(color.r,color.g,color.b)
      panel.elementHealthMasterHeadline:SetTextColor(color.r,color.g,color.b)
    else
      ns.HealthOrb.fill.colorClass = false
      ns.HealthOrb.fill.colorHealth = false
      local color = panel.loadHealthOrbFillingColor()
      ns.HealthOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
      panel.scrollFrame.scrollChild.leftTexture:SetVertexColor(color.r,color.g,color.b)
      panel.elementHealthMasterHeadline:SetTextColor(color.r,color.g,color.b)
    end
  end

  --update power orb filling color auto
  panel.updatePowerOrbFillingColorAuto = function()
    if panel.loadPowerOrbFillingColorAuto() then
      ns.PowerOrb.fill.colorPower = true
      local color = ns.cfg.powercolors[select(2, UnitPowerType("player"))] or { r = 1, g = 0, b = 1, }
      ns.PowerOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
      --ns.PowerOrb.fill:ForceUpdate()
      panel.scrollFrame.scrollChild.rightTexture:SetVertexColor(color.r,color.g,color.b)
      panel.elementPowerMasterHeadline:SetTextColor(color.r,color.g,color.b)
    else
      ns.PowerOrb.fill.colorPower = false
      local color = panel.loadPowerOrbFillingColor()
      ns.PowerOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
      panel.scrollFrame.scrollChild.rightTexture:SetVertexColor(color.r,color.g,color.b)
      panel.elementPowerMasterHeadline:SetTextColor(color.r,color.g,color.b)
    end
  end

  --update health orb filling color
  panel.updateHealthOrbFillingColor = function()
    local color = panel.loadHealthOrbFillingColor()
    ns.HealthOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    panel.scrollFrame.scrollChild.leftTexture:SetVertexColor(color.r,color.g,color.b)
    panel.elementHealthMasterHeadline:SetTextColor(color.r,color.g,color.b)
  end

  --update power orb filling color
  panel.updatePowerOrbFillingColor = function()
    local color = panel.loadPowerOrbFillingColor()
    ns.PowerOrb.fill:SetStatusBarColor(color.r,color.g,color.b)
    panel.scrollFrame.scrollChild.rightTexture:SetVertexColor(color.r,color.g,color.b)
    panel.elementPowerMasterHeadline:SetTextColor(color.r,color.g,color.b)
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

  --update health orb model scale
  panel.updateHealthOrbModelScale = function()
    ns.HealthOrb.model:SetCamDistanceScale(panel.loadHealthOrbModelScale())
  end

  --update power orb model scale
  panel.updatePowerOrbModelScale = function()
    ns.PowerOrb.model:SetCamDistanceScale(panel.loadPowerOrbModelScale())
  end

  --update health orb model pos x
  panel.updateHealthOrbModelPosX = function()
    local x, y = panel.loadHealthOrbModelPosX(), panel.loadHealthOrbModelPosY()
    ns.HealthOrb.model:SetPosition(0,x,y)
  end

  --update power orb model pos x
  panel.updatePowerOrbModelPosX = function()
    local x, y = panel.loadPowerOrbModelPosX(), panel.loadPowerOrbModelPosY()
    ns.PowerOrb.model:SetPosition(0,x,y)
  end

  --update health orb model pos y
  panel.updateHealthOrbModelPosY = function()
    local x, y = panel.loadHealthOrbModelPosX(), panel.loadHealthOrbModelPosY()
    ns.HealthOrb.model:SetPosition(0,x,y)
  end

  --update power orb model pos y
  panel.updatePowerOrbModelPosY = function()
    local x, y = panel.loadPowerOrbModelPosX(), panel.loadPowerOrbModelPosY()
    ns.PowerOrb.model:SetPosition(0,x,y)
  end

  --update health orb model rotation
  panel.updateHealthOrbModelRotation = function()
    ns.HealthOrb.model:SetRotation(panel.loadHealthOrbModelRotation())
  end

  --update power orb model rotation
  panel.updatePowerOrbModelRotation = function()
    ns.PowerOrb.model:SetRotation(panel.loadPowerOrbModelRotation())
  end

  --update health orb model zoom
  panel.updateHealthOrbModelZoom = function()
    ns.HealthOrb.model:SetPortraitZoom(panel.loadHealthOrbModelZoom())
  end

  --update power orb model zoom
  panel.updatePowerOrbModelZoom = function()
    ns.PowerOrb.model:SetPortraitZoom(panel.loadPowerOrbModelZoom())
  end

  --update health orb highlight alpha
  panel.updateHealthOrbHighlightAlpha = function()
    ns.HealthOrb.highlight:SetAlpha(panel.loadHealthOrbHighlightAlpha())
  end

  --update power orb highlight alpha
  panel.updatePowerOrbHighlightAlpha = function()
    ns.PowerOrb.highlight:SetAlpha(panel.loadPowerOrbHighlightAlpha())
  end

  --update health orb spark alpha
  panel.updateHealthOrbSparkAlpha = function()
    ns.HealthOrb.spark:SetAlpha(panel.loadHealthOrbSparkAlpha())
  end

  --update power orb spark alpha
  panel.updatePowerOrbSparkAlpha = function()
    ns.PowerOrb.spark:SetAlpha(panel.loadPowerOrbSparkAlpha())
  end

  --update health orb value alpha
  panel.updateHealthOrbValueAlpha = function()
    ns.HealthOrb.values:SetAlpha(panel.loadHealthOrbValueAlpha())
  end

  --update power orb value alpha
  panel.updatePowerOrbValueAlpha = function()
    ns.PowerOrb.values:SetAlpha(panel.loadPowerOrbValueAlpha())
  end

  --update health orb value top color
  panel.updateHealthOrbValueTopColor = function()
    local color = panel.loadHealthOrbValueTopColor()
    ns.HealthOrb.values.top:SetTextColor(color.r,color.g,color.b)
  end

  --update power orb value top color
  panel.updatePowerOrbValueTopColor = function()
    local color = panel.loadPowerOrbValueTopColor()
    ns.PowerOrb.values.top:SetTextColor(color.r,color.g,color.b)
  end

  --update health orb value bottom color
  panel.updateHealthOrbValueBottomColor = function()
    local color = panel.loadHealthOrbValueBottomColor()
    ns.HealthOrb.values.bottom:SetTextColor(color.r,color.g,color.b)
  end

  --update power orb value bottom color
  panel.updatePowerOrbValueBottomColor = function()
    local color = panel.loadPowerOrbValueBottomColor()
    ns.PowerOrb.values.bottom:SetTextColor(color.r,color.g,color.b)
  end

  --update health orb value top tag
  panel.updateHealthOrbValueTopTag = function()
    ns.HealthOrb.values.top:SetText(oUF.Tags.Methods["diablo:HealthOrbTop"](ns.unit.player.unit))
  end

  --update power orb value top tag
  panel.updatePowerOrbValueTopTag = function()
    ns.PowerOrb.values.top:SetText(oUF.Tags.Methods["diablo:PowerOrbTop"](ns.unit.player.unit))
  end

  --update health orb value bottom Tag
  panel.updateHealthOrbValueBottomTag = function()
    ns.HealthOrb.values.bottom:SetText(oUF.Tags.Methods["diablo:HealthOrbBottom"](ns.unit.player.unit))
  end

  --update power orb value bottom tag
  panel.updatePowerOrbValueBottomTag = function()
    ns.PowerOrb.values.bottom:SetText(oUF.Tags.Methods["diablo:PowerOrbBottom"](ns.unit.player.unit))
  end

  ---------------------------------------------
  --UPDATE PANEL ELEMENTS
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
    local value = panel.loadHealthOrbModelEnable()
    panel.elementHealthOrbModelEnable:SetChecked(value)
    if value then
      panel.elementHealthOrbModelAnimation:Show()
      panel.elementHealthOrbModelAlpha:Show()
      panel.elementHealthOrbModelScale:Show()
      panel.elementHealthOrbModelPosX:Show()
      panel.elementHealthOrbModelPosY:Show()
      panel.elementHealthOrbModelRotation:Show()
      panel.elementHealthOrbModelZoom:Show()
      panel.elementHealthHighlightHeadline:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -270)
    else
      panel.elementHealthOrbModelAnimation:Hide()
      panel.elementHealthOrbModelAlpha:Hide()
      panel.elementHealthOrbModelScale:Hide()
      panel.elementHealthOrbModelPosX:Hide()
      panel.elementHealthOrbModelPosY:Hide()
      panel.elementHealthOrbModelRotation:Hide()
      panel.elementHealthOrbModelZoom:Hide()
      panel.elementHealthHighlightHeadline:SetPoint("TOPLEFT", panel.elementHealthModelHeadline, "BOTTOMLEFT", 0, -50)
    end
  end

  --update element power orb model enable
  panel.updateElementPowerOrbModelEnable = function()
    local value = panel.loadPowerOrbModelEnable()
    panel.elementPowerOrbModelEnable:SetChecked(value)
    if value then
      panel.elementPowerOrbModelAnimation:Show()
      panel.elementPowerOrbModelAlpha:Show()
      panel.elementPowerOrbModelScale:Show()
      panel.elementPowerOrbModelPosX:Show()
      panel.elementPowerOrbModelPosY:Show()
      panel.elementPowerOrbModelRotation:Show()
      panel.elementPowerOrbModelZoom:Show()
      panel.elementPowerHighlightHeadline:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -270)
    else
      panel.elementPowerOrbModelAnimation:Hide()
      panel.elementPowerOrbModelAlpha:Hide()
      panel.elementPowerOrbModelScale:Hide()
      panel.elementPowerOrbModelPosX:Hide()
      panel.elementPowerOrbModelPosY:Hide()
      panel.elementPowerOrbModelRotation:Hide()
      panel.elementPowerOrbModelZoom:Hide()
      panel.elementPowerHighlightHeadline:SetPoint("TOPLEFT", panel.elementPowerModelHeadline, "BOTTOMLEFT", 0, -50)
    end
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

  --update element health orb model scale
  panel.updateElementHealthOrbModelScale = function()
    panel.elementHealthOrbModelScale:SetValue(panel.loadHealthOrbModelScale())
  end

  --update element power orb model scale
  panel.updateElementPowerOrbModelScale = function()
    panel.elementPowerOrbModelScale:SetValue(panel.loadPowerOrbModelScale())
  end

  --update element health orb model pos x
  panel.updateElementHealthOrbModelPosX = function()
    panel.elementHealthOrbModelPosX:SetValue(panel.loadHealthOrbModelPosX())
  end

  --update element power orb model pos x
  panel.updateElementPowerOrbModelPosX = function()
    panel.elementPowerOrbModelPosX:SetValue(panel.loadPowerOrbModelPosX())
  end

  --update element health orb model pos y
  panel.updateElementHealthOrbModelPosY = function()
    panel.elementHealthOrbModelPosY:SetValue(panel.loadHealthOrbModelPosY())
  end

  --update element power orb model pos y
  panel.updateElementPowerOrbModelPosY = function()
    panel.elementPowerOrbModelPosY:SetValue(panel.loadPowerOrbModelPosY())
  end

  --update element health orb model rotation
  panel.updateElementHealthOrbModelRotation = function()
    panel.elementHealthOrbModelRotation:SetValue(panel.loadHealthOrbModelRotation())
  end

  --update element power orb model rotation
  panel.updateElementPowerOrbModelRotation = function()
    panel.elementPowerOrbModelRotation:SetValue(panel.loadPowerOrbModelRotation())
  end

  --update element health orb model zoom
  panel.updateElementHealthOrbModelZoom = function()
    panel.elementHealthOrbModelZoom:SetValue(panel.loadHealthOrbModelZoom())
  end

  --update element power orb model zoom
  panel.updateElementPowerOrbModelZoom = function()
    panel.elementPowerOrbModelZoom:SetValue(panel.loadPowerOrbModelZoom())
  end

  --update element health orb highlight alpha
  panel.updateElementHealthOrbHighlightAlpha = function()
    panel.elementHealthOrbHighlightAlpha:SetValue(panel.loadHealthOrbHighlightAlpha())
  end

  --update element power orb highlight alpha
  panel.updateElementPowerOrbHighlightAlpha = function()
    panel.elementPowerOrbHighlightAlpha:SetValue(panel.loadPowerOrbHighlightAlpha())
  end

  --update element health orb spark alpha
  panel.updateElementHealthOrbSparkAlpha = function()
    panel.elementHealthOrbSparkAlpha:SetValue(panel.loadHealthOrbSparkAlpha())
  end

  --update element power orb spark alpha
  panel.updateElementPowerOrbSparkAlpha = function()
    panel.elementPowerOrbSparkAlpha:SetValue(panel.loadPowerOrbSparkAlpha())
  end

  --update element health orb value hideOnEmpty
  panel.updateElementHealthOrbValueHideEmpty = function()
    panel.elementHealthOrbValueHideEmpty:SetChecked(panel.loadHealthOrbValueHideEmpty())
  end

  --update element power orb value hideOnEmpty
  panel.updateElementPowerOrbValueHideEmpty = function()
    panel.elementPowerOrbValueHideEmpty:SetChecked(panel.loadPowerOrbValueHideEmpty())
  end

  --update element health orb value hideOnFull
  panel.updateElementHealthOrbValueHideFull = function()
    panel.elementHealthOrbValueHideFull:SetChecked(panel.loadHealthOrbValueHideFull())
  end

  --update element power orb value hideOnFull
  panel.updateElementPowerOrbValueHideFull = function()
    panel.elementPowerOrbValueHideFull:SetChecked(panel.loadPowerOrbValueHideFull())
  end

  --update element health orb value alpha
  panel.updateElementHealthOrbValueAlpha = function()
    panel.elementHealthOrbValueAlpha:SetValue(panel.loadHealthOrbValueAlpha())
  end

  --update element power orb value alpha
  panel.updateElementPowerOrbValueAlpha = function()
    panel.elementPowerOrbValueAlpha:SetValue(panel.loadPowerOrbValueAlpha())
  end

  --update element health orb value top color
  panel.updateElementHealthOrbValueTopColor = function()
    local color = panel.loadHealthOrbValueTopColor()
    panel.elementHealthOrbValueTopColor.color:SetVertexColor(color.r,color.g,color.b)
  end

  --update element power orb value top color
  panel.updateElementPowerOrbValueTopColor = function()
    local color = panel.loadPowerOrbValueTopColor()
    panel.elementPowerOrbValueTopColor.color:SetVertexColor(color.r,color.g,color.b)
  end

  --update element health orb value bottom color
  panel.updateElementHealthOrbValueBottomColor = function()
    local color = panel.loadHealthOrbValueBottomColor()
    panel.elementHealthOrbValueBottomColor.color:SetVertexColor(color.r,color.g,color.b)
  end

  --update element power orb value bottom color
  panel.updateElementPowerOrbValueBottomColor = function()
    local color = panel.loadPowerOrbValueBottomColor()
    panel.elementPowerOrbValueBottomColor.color:SetVertexColor(color.r,color.g,color.b)
  end

  --update element health orb value top tag
  panel.updateElementHealthOrbValueTopTag = function()
    UIDropDownMenu_SetSelectedValue(panel.elementHealthOrbValueTopTag, panel.loadHealthOrbValueTopTag())
  end

  --update element power orb value top tag
  panel.updateElementPowerOrbValueTopTag = function()
    UIDropDownMenu_SetSelectedValue(panel.elementPowerOrbValueTopTag, panel.loadPowerOrbValueTopTag())
  end

  --update element health orb value bottom tag
  panel.updateElementHealthOrbValueBottomTag = function()
    UIDropDownMenu_SetSelectedValue(panel.elementHealthOrbValueBottomTag, panel.loadHealthOrbValueBottomTag())
  end

  --update element power orb value bottom tag
  panel.updateElementPowerOrbValueBottomTag = function()
    UIDropDownMenu_SetSelectedValue(panel.elementPowerOrbValueBottomTag, panel.loadPowerOrbValueBottomTag())
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

  --save health orb model scale
  panel.saveHealthOrbModelScale = function(value)
    db.char["HEALTH"].model.camDistanceScale = value
  end

  --save power orb model scale
  panel.savePowerOrbModelScale = function(value)
    db.char["POWER"].model.camDistanceScale = value
  end

  --save health orb model pos x
  panel.saveHealthOrbModelPosX = function(value)
    db.char["HEALTH"].model.pos_x = value
  end

  --save power orb model pos x
  panel.savePowerOrbModelPosX = function(value)
    db.char["POWER"].model.pos_x = value
  end

  --save health orb model pos y
  panel.saveHealthOrbModelPosY = function(value)
    db.char["HEALTH"].model.pos_y = value
  end

  --save power orb model pos y
  panel.savePowerOrbModelPosY = function(value)
    db.char["POWER"].model.pos_y = value
  end

  --save health orb model rotation
  panel.saveHealthOrbModelRotation = function(value)
    db.char["HEALTH"].model.rotation = value
  end

  --save power orb model rotation
  panel.savePowerOrbModelRotation = function(value)
    db.char["POWER"].model.rotation = value
  end

  --save health orb model zoom
  panel.saveHealthOrbModelZoom = function(value)
    db.char["HEALTH"].model.portraitZoom = value
  end

  --save power orb model zoom
  panel.savePowerOrbModelZoom = function(value)
    db.char["POWER"].model.portraitZoom = value
  end

  --save health orb highlight alpha
  panel.saveHealthOrbHighlightAlpha = function(value)
    db.char["HEALTH"].highlight.alpha = value
  end

  --save power orb highlight alpha
  panel.savePowerOrbHighlightAlpha = function(value)
    db.char["POWER"].highlight.alpha = value
  end

  --save health orb spark alpha
  panel.saveHealthOrbSparkAlpha = function(value)
    db.char["HEALTH"].spark.alpha = value
  end

  --save power orb spark alpha
  panel.savePowerOrbSparkAlpha = function(value)
    db.char["POWER"].spark.alpha = value
  end

  --save health orb value hideOnEmpty
  panel.saveHealthOrbValueHideEmpty = function(value)
    db.char["HEALTH"].value.hideOnEmpty = value
  end

  --save power orb value hideOnEmpty
  panel.savePowerOrbValueHideEmpty = function(value)
    db.char["POWER"].value.hideOnEmpty = value
  end

  --save health orb value hideOnFull
  panel.saveHealthOrbValueHideFull = function(value)
    db.char["HEALTH"].value.hideOnFull = value
  end

  --save power orb value hideOnFull
  panel.savePowerOrbValueHideFull = function(value)
    db.char["POWER"].value.hideOnFull = value
  end

  --save health orb value alpha
  panel.saveHealthOrbValueAlpha = function(value)
    db.char["HEALTH"].value.alpha = value
  end

  --save power orb value alpha
  panel.savePowerOrbValueAlpha = function(value)
    db.char["POWER"].value.alpha = value
  end

  --save health orb value top color
  panel.saveHealthOrbValueTopColor = function(r,g,b)
    db.char["HEALTH"].value.top.color.r = r
    db.char["HEALTH"].value.top.color.g = g
    db.char["HEALTH"].value.top.color.b = b
  end

  --save power orb value top color
  panel.savePowerOrbValueTopColor = function(r,g,b)
    db.char["POWER"].value.top.color.r = r
    db.char["POWER"].value.top.color.g = g
    db.char["POWER"].value.top.color.b = b
  end

  --save health orb value bottom color
  panel.saveHealthOrbValueBottomColor = function(r,g,b)
    db.char["HEALTH"].value.bottom.color.r = r
    db.char["HEALTH"].value.bottom.color.g = g
    db.char["HEALTH"].value.bottom.color.b = b
  end

  --save power orb value bottom color
  panel.savePowerOrbValueBottomColor = function(r,g,b)
    db.char["POWER"].value.bottom.color.r = r
    db.char["POWER"].value.bottom.color.g = g
    db.char["POWER"].value.bottom.color.b = b
  end

  --save health orb value top tag
  panel.saveHealthOrbValueTopTag = function(value)
    db.char["HEALTH"].value.top.tag = value
  end

  --save power orb value top tag
  panel.savePowerOrbValueTopTag = function(value)
    db.char["POWER"].value.top.tag = value
  end

  --save health orb value bottom tag
  panel.saveHealthOrbValueBottomTag = function(value)
    db.char["HEALTH"].value.bottom.tag = value
  end

  --save power orb value bottom tag
  panel.savePowerOrbValueBottomTag = function(value)
    db.char["POWER"].value.bottom.tag = value
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

  --load health orb model scale
  panel.loadHealthOrbModelScale = function()
    return db.char["HEALTH"].model.camDistanceScale
  end

  --load power orb model scale
  panel.loadPowerOrbModelScale = function()
    return db.char["POWER"].model.camDistanceScale
  end

  --load health orb model pos x
  panel.loadHealthOrbModelPosX = function()
    return db.char["HEALTH"].model.pos_x
  end

  --load power orb model pos x
  panel.loadPowerOrbModelPosX = function()
    return db.char["POWER"].model.pos_x
  end

  --load health orb model pos y
  panel.loadHealthOrbModelPosY = function()
    return db.char["HEALTH"].model.pos_y
  end

  --load power orb model pos y
  panel.loadPowerOrbModelPosY = function()
    return db.char["POWER"].model.pos_y
  end

  --load health orb model rotation
  panel.loadHealthOrbModelRotation = function()
    return db.char["HEALTH"].model.rotation
  end

  --load power orb model rotation
  panel.loadPowerOrbModelRotation = function()
    return db.char["POWER"].model.rotation
  end

  --load health orb model zoom
  panel.loadHealthOrbModelZoom = function()
    return db.char["HEALTH"].model.portraitZoom
  end

  --load power orb model zoom
  panel.loadPowerOrbModelZoom = function()
    return db.char["POWER"].model.portraitZoom
  end

  --load health orb highlight alpha
  panel.loadHealthOrbHighlightAlpha = function()
    return db.char["HEALTH"].highlight.alpha
  end

  --load power orb highlight alpha
  panel.loadPowerOrbHighlightAlpha = function()
    return db.char["POWER"].highlight.alpha
  end

  --load health orb spark alpha
  panel.loadHealthOrbSparkAlpha = function()
    return db.char["HEALTH"].spark.alpha
  end

  --load power orb spark alpha
  panel.loadPowerOrbSparkAlpha = function()
    return db.char["POWER"].spark.alpha
  end

  --load health orb value hideOnEmpty
  panel.loadHealthOrbValueHideEmpty = function()
    return db.char["HEALTH"].value.hideOnEmpty
  end

  --load power orb value hideOnEmpty
  panel.loadPowerOrbValueHideEmpty = function()
    return db.char["POWER"].value.hideOnEmpty
  end

  --load health orb value hideOnFull
  panel.loadHealthOrbValueHideFull = function()
    return db.char["HEALTH"].value.hideOnFull
  end

  --load power orb value hideOnFull
  panel.loadPowerOrbValueHideFull = function()
    return db.char["POWER"].value.hideOnFull
  end

  --load health orb value alpha
  panel.loadHealthOrbValueAlpha = function()
    return db.char["HEALTH"].value.alpha
  end

  --load power orb value alpha
  panel.loadPowerOrbValueAlpha = function()
    return db.char["POWER"].value.alpha
  end

  --load health orb value top color
  panel.loadHealthOrbValueTopColor = function()
    return db.char["HEALTH"].value.top.color
  end

  --load power orb value top color
  panel.loadPowerOrbValueTopColor = function()
    return db.char["POWER"].value.top.color
  end

  --load health orb value bottom color
  panel.loadHealthOrbValueBottomColor = function()
    return db.char["HEALTH"].value.bottom.color
  end

  --load power orb value bottom color
  panel.loadPowerOrbValueBottomColor = function()
    return db.char["POWER"].value.bottom.color
  end

  --load health orb value top tag
  panel.loadHealthOrbValueTopTag = function()
    return db.char["HEALTH"].value.top.tag
  end

  --load power orb value top tag
  panel.loadPowerOrbValueTopTag = function()
    return db.char["POWER"].value.top.tag
  end

  --load health orb value bottom tag
  panel.loadHealthOrbValueBottomTag = function()
    return db.char["HEALTH"].value.bottom.tag
  end

  --load power orb value bottom tag
  panel.loadPowerOrbValueBottomTag = function()
    return db.char["POWER"].value.bottom.tag
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
    --update element health orb model scale
    panel.updateElementHealthOrbModelScale()
    --update element power orb model scale
    panel.updateElementPowerOrbModelScale()
    --update element health orb model pos x
    panel.updateElementHealthOrbModelPosX()
    --update element power orb model pos x
    panel.updateElementPowerOrbModelPosX()
    --update element health orb model pos y
    panel.updateElementHealthOrbModelPosY()
    --update element power orb model pos y
    panel.updateElementPowerOrbModelPosY()
    --update element health orb model rotation
    panel.updateElementHealthOrbModelRotation()
    --update element power orb model rotation
    panel.updateElementPowerOrbModelRotation()
    --update element health orb model zoom
    panel.updateElementHealthOrbModelZoom()
    --update element power orb model zoom
    panel.updateElementPowerOrbModelZoom()
    --update element health orb highlight alpha
    panel.updateElementHealthOrbHighlightAlpha()
    --update element power orb highlight alpha
    panel.updateElementPowerOrbHighlightAlpha()
    --update element health orb spark alpha
    panel.updateElementHealthOrbSparkAlpha()
    --update element power orb spark alpha
    panel.updateElementPowerOrbSparkAlpha()
    --update element health orb value hideOnEmpty
    panel.updateElementHealthOrbValueHideEmpty()
    --update element power orb value hideOnEmpty
    panel.updateElementPowerOrbValueHideEmpty()
    --update element health orb value hideOnFull
    panel.updateElementHealthOrbValueHideFull()
    --update element power orb value hideOnFull
    panel.updateElementPowerOrbValueHideFull()
    --update element health orb value alpha
    panel.updateElementHealthOrbValueAlpha()
    --update element power orb value alpha
    panel.updateElementPowerOrbValueAlpha()
    --update element health orb value top color
    panel.updateElementHealthOrbValueTopColor()
    --update element power orb value top color
    panel.updateElementPowerOrbValueTopColor()
    --update element health orb value bottom color
    panel.updateElementHealthOrbValueBottomColor()
    --update element power orb value bottom color
    panel.updateElementPowerOrbValueBottomColor()
    --update element health orb value top tag
    panel.updateElementHealthOrbValueTopTag()
    --update element power orb value top tag
    panel.updateElementPowerOrbValueTopTag()
    --update element health orb value bottom tag
    panel.updateElementHealthOrbValueBottomTag()
    --update element power orb value bottom tag
    panel.updateElementPowerOrbValueBottomTag()

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
    --important! since auto coloring rewrites the color it has to be called after filling color
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
    --update health orb model alpha
    panel.updateHealthOrbModelAlpha()
    --update power orb model alpha
    panel.updatePowerOrbModelAlpha()
    --update health orb model scale
    panel.updateHealthOrbModelScale()
    --update power orb model scale
    panel.updatePowerOrbModelScale()
    --update health orb model pos x
    panel.updateHealthOrbModelPosX()
    --update power orb model pos x
    panel.updatePowerOrbModelPosX()
    --update health orb model pos y
    panel.updateHealthOrbModelPosY()
    --update power orb model pos y
    panel.updatePowerOrbModelPosY()
    --update health orb model rotation
    panel.updateHealthOrbModelRotation()
    --update power orb model rotation
    panel.updatePowerOrbModelRotation()
    --update health orb model zoom
    panel.updateHealthOrbModelZoom()
    --update power orb model zoom
    panel.updatePowerOrbModelZoom()
    --update health orb highlight alpha
    panel.updateHealthOrbHighlightAlpha()
    --update power orb highlight alpha
    panel.updatePowerOrbHighlightAlpha()
    --update health orb spark alpha
    panel.updateHealthOrbSparkAlpha()
    --update power orb spark alpha
    panel.updatePowerOrbSparkAlpha()
    --update health orb value alpha
    panel.updateHealthOrbValueAlpha()
    --update power orb value alpha
    panel.updatePowerOrbValueAlpha()
    --update health orb value top color
    panel.updateHealthOrbValueTopColor()
    --update power orb value top color
    panel.updatePowerOrbValueTopColor()
    --update health orb value bottom color
    panel.updateHealthOrbValueBottomColor()
    --update power orb value bottom color
    panel.updatePowerOrbValueBottomColor()
    --update health orb value top tag
    panel.updateHealthOrbValueTopTag()
    --update power orb value top tag
    panel.updatePowerOrbValueTopTag()
    --update health orb value bottom Tag
    panel.updateHealthOrbValueBottomTag()
    --update power orb value bottom tag
    panel.updatePowerOrbValueBottomTag()

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
    ChatEdit_FocusActiveWindow() --nice function
  end

  do
    local eventHelper = CF("Frame")
    function eventHelper:SetOrbsToMax()
      local hbar, pbar = ns.HealthOrb.fill, ns.PowerOrb.fill
      local hval, pval = ns.HealthOrb.values, ns.PowerOrb.values
      local hmin, hmax = hbar:GetMinMaxValues()
      local pmin, pmax = pbar:GetMinMaxValues()
      hbar:SetValue(hmax)
      pbar:SetValue(pmax)
      hval:Show()
      pval:Show()
    end
    function eventHelper:SetOrbsToDefault()
      local hbar, pbar = ns.HealthOrb.fill, ns.PowerOrb.fill
      local hval, pval = ns.HealthOrb.values, ns.PowerOrb.values
      hbar:ForceUpdate()
      pbar:ForceUpdate()
    end
    panel.eventHelper = eventHelper
    panel:HookScript("OnShow", function(self) self:Enable() end)
    panel:HookScript("OnHide", function(self) self:Disable() end)
  end
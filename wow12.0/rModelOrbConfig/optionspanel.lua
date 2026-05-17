local A, L = ...

local panel = CreateFrame("Frame", L.name.."OptionsPanel")
L.optionsPanel = panel

-- PanelOK
local function PanelOK()
  print(L.name, "PanelOK")
end
panel.okay = PanelOK

-- PanelCancel
local function PanelCancel()
  print(L.name, "PanelCancel")
end
panel.cancel = PanelCancel

-- PanelOnDefault
local function PanelOnDefault()
  print(L.name, "PanelOnDefault")
end
panel.OnDefault = PanelOnDefault

-- OnRefresh
local function OnRefresh()
  
end
panel.OnRefresh = OnRefresh

-- RegisterOptionsPanel
local function RegisterOptionsPanel()

  panel.name = L.name
  panel.sortedModels = {}

  -- register with settings
  local canvasCategory, layout = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
  local finalCategory = Settings.RegisterAddOnCategory(canvasCategory)
  panel.settingsCategory = finalCategory

  local title = L.F.CreateFontString(panel, "ARTWORK", "GameFontNormalLarge", L.name.." Settings")
  title:SetPoint("TOPLEFT", 16, -16)

  --orb
  local orb = CreateFrame("Frame", nil, panel, "rModelOrbTemplate")
  L.previewOrb = orb

  orb:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
  orb:LoadModelDataByID(2030216)
  orb.FillingStatusBar:SetValue(1)
  orb:EnableMouse(true)

  for id, data in pairs(orb:GetAllModelData()) do
    data.id = id
    table.insert(panel.sortedModels, data)
  end

  table.sort(panel.sortedModels, function(a, b)
    return a.name:lower() < b.name:lower()
  end)

  orb:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
      L.canvas:Open()
    else
      return
    end
  end)

  orb:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_CURSOR", 0, 5)
    GameTooltip:AddLine("Click to show all available models.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  orb:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  --value slider
  local valueSlider = L.F.CreateSlider(panel, 256, 0, 1, orb, -16, "Value")
  valueSlider:SetScript("OnValueChanged", function(self, value) 
    orb.FillingStatusBar:SetValue(value) 
  end)

  valueSlider:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
    GameTooltip:AddLine("Move the slider to test how the orb will fill.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  valueSlider:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  --model alpha slider
  local modelAlphaSlider = L.F.CreateSlider(panel, 256, 0, 1, valueSlider, -16, "Model Opacity")
  modelAlphaSlider:SetScript("OnValueChanged", function(self, value) 
    orb.ClipFrame:SetAlpha(value)
    valueSlider:SetValue(1)
  end)

  modelAlphaSlider:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
    GameTooltip:AddLine("Move the slider to change the model opacity.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  modelAlphaSlider:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  --split texture alpha slider
  local splitTexAlphaSlider = L.F.CreateSlider(panel, 256, 0, 1, modelAlphaSlider, -16, "Split Texture Opacity")
  splitTexAlphaSlider:SetScript("OnValueChanged", function(self, value) 
    local r,g,b = orb.OverlayFrame.SparkTexture:GetVertexColor()
    orb.OverlayFrame.SparkTexture:SetVertexColor(r,g,b,value)
    valueSlider:SetValue(0.5)
  end)

  splitTexAlphaSlider:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
    GameTooltip:AddLine("Move the slider to change the split texture opacity.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  splitTexAlphaSlider:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  local orbFillingTextures = {
    "orb_filling1",
    "orb_filling2",
    "orb_filling3",
    "orb_filling4",
    "orb_filling5",
    "orb_filling6",
    "orb_filling7",
    "orb_filling8",
    "orb_filling9",
    "orb_filling10",
    "orb_filling11",
    "orb_filling12",
    "orb_filling13",
    "orb_filling14",
    "orb_filling15",
    "orb_filling16",
    "orb_filling17",
    "orb_filling18",
    "orb_filling19",
    "orb_filling20",
    "orb_filling21",
  }

  local orbFillingDropDownDefault = orbFillingTextures[15]

  local orbFillingDropDown = CreateFrame("DropdownButton", nil, panel, "WowStyle1DropdownTemplate")
  orbFillingDropDown:SetPoint("TOPLEFT", splitTexAlphaSlider, "BOTTOMLEFT", 0, -10)
  orbFillingDropDown:SetSize(256, 30)
  orbFillingDropDown:SetDefaultText(orbFillingDropDownDefault)
  orbFillingDropDown:SetupMenu(function(dropdown, rootDescription)
    rootDescription:CreateTitle("Pick a filling texture:")
    for _, value in ipairs(orbFillingTextures) do
      rootDescription:CreateButton(value, function()
        orbFillingDropDownDefault = value
        orbFillingDropDown:SetDefaultText(value)              
        orb.FillingStatusBar:SetStatusBarTexture(L.mediaFolder..value)              
      end)
    end
  end)


  --filling statusbar color
  local fillingColorSelectButton = L.F.CreateButton(panel, "Filling and Split Texture Color")
  fillingColorSelectButton:SetPoint("TOPLEFT", orbFillingDropDown, "BOTTOMLEFT", 0, -10)
  fillingColorSelectButton:SetScript("OnClick", function()
      local r, g, b = orb.FillingStatusBar:GetStatusBarColor()
      local info = {
        swatchFunc = function()
          local nr, ng, nb = ColorPickerFrame:GetColorRGB()
          orb.FillingStatusBar:SetStatusBarColor(nr, ng, nb)
          orb.OverlayFrame.SparkTexture:SetVertexColor(nr, ng, nb)
        end,
        cancelFunc = function(prev)
          orb.FillingStatusBar:SetStatusBarColor(prev.r, prev.g, prev.b)
          orb.OverlayFrame.SparkTexture:SetVertexColor(prev.r, prev.g, prev.b)
        end,
        r = r, g = g, b = b,
        hasOpacity = false,
      }
      ColorPickerFrame:SetupColorPickerAndShow(info)
  end)

  fillingColorSelectButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0)
    GameTooltip:AddLine("Click to select a color for the filling and split texture.", 1, 1, 1, 1, 1, 1)
    GameTooltip:Show()
  end)
  fillingColorSelectButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)


end
L.F.RegisterOptionsPanel = RegisterOptionsPanel

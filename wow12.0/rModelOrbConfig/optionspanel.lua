local A, L = ...

local panel = CreateFrame("Frame", L.name.."OptionsPanel")
L.optionsPanel = panel

-- PanelOK
local function PanelOK()
  print(L.name, 'PanelOK')
end
panel.okay = PanelOK

-- PanelCancel
local function PanelCancel()
  print(L.name, 'PanelCancel')
end
panel.cancel = PanelCancel

-- PanelOnDefault
local function PanelOnDefault()
  print(L.name, 'PanelOnDefault')
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

  local orb = CreateFrame("Frame", nil, panel, "rModelOrbTemplate")
  L.previewOrb = orb

  orb:SetPoint("TOPLEFT", title, "TOPLEFT", 0, -32)
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


end
L.F.RegisterOptionsPanel = RegisterOptionsPanel

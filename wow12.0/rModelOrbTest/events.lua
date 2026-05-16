local A, L = ...

local function MakeSlider(text, minV, maxV, parent, relativeTo, yOff)
    local slider = CreateFrame("Slider", nil, parent, "UISliderTemplate")
    slider:SetSize(200, 20)
    slider:SetPoint("TOP", relativeTo, "BOTTOM", 0, yOff)
    slider:SetMinMaxValues(minV, maxV)
    slider:SetValue(1)
    slider:SetObeyStepOnDrag(false)
    slider.text = slider:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    slider.text:SetPoint("BOTTOM", slider, "TOP", 0, 2)
    slider.text:SetText(text)
    return slider
end



local function OnPlayerLogin(...)

  local orb = CreateFrame("Frame", "rModelOrbTest", UIParent, "rModelOrbTemplate")
  orb:SetPoint("CENTER")
  --orb:SetScale(1)

  orb:LoadModelDataByID(394985)
  orb.FillingStatusBar:SetValue(1)
  
  --make slider
  local valueSlider = MakeSlider("Value", 0, 1, UIParent, orb, -30)
  valueSlider:SetScript("OnValueChanged", function(self,value) 
    orb.FillingStatusBar:SetValue(value) 
  end)

  local allModelData = orb:GetAllModelData()

  -- scroll frame
  local scrollFrame = CreateFrame("scrollFrame", nil, UIParent, "UIPanelscrollFrameTemplate")
  scrollFrame:SetPoint("LEFT", orb, "RIGHT", 50, 0)
  scrollFrame:SetSize(200,500)

  -- scroll frame child
  local scrollFrameChild = CreateFrame("Frame", nil, scrollFrame)
  scrollFrameChild:SetSize(scrollFrame:GetWidth(), 1)
  scrollFrame:SetScrollChild(scrollFrameChild)


  local listButtons = {}
  local count = 0
  for modelID, data in pairs(allModelData) do
    count = count + 1
    local btn = listButtons[count] or CreateFrame("Button", nil, scrollFrameChild, "UIPanelButtonTemplate")
    btn:SetSize(scrollFrame:GetWidth() - 10, 24)
    btn:SetPoint("TOPLEFT", 5, -((count-1) * 26))
    btn:SetText(data["name"] or modelID)
    btn:SetScript("OnClick", function() orb:LoadModelDataByID(modelID) end)
    btn:Show()
    listButtons[count] = btn
  end
  scrollFrameChild:SetHeight(count * 26)

  --/run rModelOrbTest:LoadModelDataByID(5144424)
  --/run rModelOrbTest:SetScale(0.5)
  --/run rModelOrbTest:LoadModelDataByID(394985)
  --/run rModelOrbTest.FillingStatusBar:SetValue(0.5)

end

local function OnVariablesLoaded(...)
  L.F.LoadDatabase()
end

L.eventFrame:RegisterEvent("PLAYER_LOGIN")
L.eventFrame:SetScript("OnEvent", function(_, event, ...)
  if event == "PLAYER_LOGIN" then
    OnPlayerLogin(...)
  end
end)

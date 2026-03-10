local A, L = ...

local button = nil
local spinner = nil
local counter = 0
local modelList = nil
local lastID = nil
local buildList = false
local modelFrame = nil

local function BuildModelList(newID)
  if not buildList then return end
  --local i = newID
  --try 20 models each 10ms
  for i = newID, newID+20, 1 do
    if i == 74632 then --skip bad memory access
      i = i + 1
    end
    if i == 136225 then --skip bad memory access
      i = i + 1
    end
    if i == 143081 then --skip bad memory access
      i = i + 1
    end
    lastID = i
    modelFrame:ClearModel()
    modelFrame:SetDisplayInfo(lastID)
    local modelFileID = modelFrame:GetModelFileID()
    if modelFileID and not modelList[modelFileID] then
      modelList[modelFileID] = lastID
      counter = counter + 1
    end
    button:SetText("Models found: "..counter.." last-id: "..lastID)
  end
  --recursive call after 10ms
  C_Timer.After(0.01, function()
    BuildModelList(lastID + 1)
  end)
end

local function ButtonOnClick()
  if spinner:IsShown() then
    buildList = false
    L.DB.G["MODEL_LIST"] = modelList
    L.DB.G["LAST_DISPLAY_ID"] = lastID
    print(L.name, 'searched up until id: [', lastID, '] and found this many new models: [', counter, ']')
    if spinner.Anim then spinner.Anim:Stop() end
    spinner:Hide()
  else
    spinner:Show()
    buildList = true
    counter = 0
    modelList = L.DB.G["MODEL_LIST"]
    lastID = L.DB.G["LAST_DISPLAY_ID"]
    BuildModelList(lastID)
    if spinner.Anim then spinner.Anim:Play() end
  end
end

local function CreateBuildDBButton()

  --modelFrame
  modelFrame = CreateFrame("PlayerModel")

  --button
  button = CreateFrame("Button", L.name.."Button", UIParent, "UIPanelButtonTemplate")
  button:SetSize(250, 30)
  button:SetPoint("CENTER", UIParent, "CENTER")
  button:SetText("Build rModelDB")
  button:Hide()

  --spinner
  spinner = CreateFrame("Frame", nil, button, "LoadingSpinnerTemplate")
  spinner:SetPoint("BOTTOM", button, "TOP", 0, 10)
  spinner:SetScale(2)
  spinner:Hide()

  --button onclick
  button:SetScript("OnClick", ButtonOnClick)

end

L.F.CreateBuildDBButton = CreateBuildDBButton

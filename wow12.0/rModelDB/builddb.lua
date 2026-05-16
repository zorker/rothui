local A, L = ...

local button = nil
local spinner = nil
local counter = 0
local modelList = nil
local lastID = nil
local buildList = false
local modelFrame = nil
local numModelsEachFrame = 20

local function TestModel(id)
  if id == 74632 or id == 136225 or id == 143081 then --skip bad memory access
    return
  end
  modelFrame:ClearModel()
  modelFrame:SetDisplayInfo(id)
  local modelFileID = modelFrame:GetModelFileID()
  if modelFileID and not modelList[modelFileID] then
    modelList[modelFileID] = id
    lastID = id
    counter = counter + 1
  end
  button:SetText("Models found: "..counter.." last-id: "..id)
end

local function BuildModelList(id)
  if not buildList then return end
  local latestID = id
  for i = id, id+numModelsEachFrame, 1 do
    TestModel(i)
    latestID = i
  end
  --recursive call after 10ms
  C_Timer.After(0.01, function()
    BuildModelList(latestID + 1)
  end)
end

local function ButtonOnClick()
  if spinner:IsShown() then
    buildList = false
    L.DB.G["MODEL_LIST"] = modelList
    L.DB.G["LAST_DISPLAY_ID"] = lastID
    print(L.name, 'found models up until id: [', lastID, '], count: [', counter, ']')
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

  --spinner
  spinner = CreateFrame("Frame", nil, button, "LoadingSpinnerTemplate")
  spinner:SetPoint("BOTTOM", button, "TOP", 0, 10)
  spinner:SetScale(2)
  spinner:Hide()

  --button onclick
  button:SetScript("OnClick", ButtonOnClick)

end

L.F.CreateBuildDBButton = CreateBuildDBButton

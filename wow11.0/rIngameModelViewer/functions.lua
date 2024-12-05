-- rIngameModelViewer - functions
-- zork 2024
-----------------------------
-- Variables
-----------------------------
local A, L = ...

local GT, UIP, CPF = GameTooltip, UIParent, ColorPickerFrame

-- save the default color picker frame strata for later
L.defaultColorPickerFrameStrata = CPF:GetFrameStrata()

-----------------------------
-- Functions
-----------------------------

local function GetTableLength(t)
  local l = 0
  for k in pairs(t) do
    l = l + 1
  end
  return l
end

local function SortByTableIndexDesc(a, b)
  return a > b
end

function L.F:PlaySound(sound)
  -- do sth
  PlaySound(sound)
end

function L.F:SetDisplayInfoModelList()
  -- build premade model list sorted by dispayInfo ID desc
  L.DB.displayInfoModelList = {}
  for k, v in pairs(L.DB.GLOB["MODEL_LIST"]) do
    table.insert(L.DB.displayInfoModelList, v)
  end
  table.sort(L.DB.displayInfoModelList, SortByTableIndexDesc)
  print(L.name, 'length of displayIndexList table:', table.getn(L.DB.displayInfoModelList))
  -- set last index id after sort
  L.DB.GLOB["LAST_DISPLAY_ID"] = L.DB.displayInfoModelList[1] or 1
  print(L.name, 'last found displayInfoID:', L.DB.GLOB["LAST_DISPLAY_ID"])
end

function L.F:BuildModelList(loopCounter)
  if loopCounter > 10 then
    print(L.name, 'loop-counter exceeded. stopping script.')
    L.murloc:ResetModelToMurloc()
    L.F:SetDisplayInfoModelList()
    return
  end
  local ml = L.DB.GLOB["MODEL_LIST"]
  local last_id = L.DB.GLOB["LAST_DISPLAY_ID"]
  local steps = 2000
  local new_id = (last_id + steps)
  local counter = 0
  for i = last_id, new_id, 1 do
    if i == 74632 then
      print(L.name, 'skip displayInfoID (causes memory-leak)', i)
    else
      L.murloc:ClearModel()
      L.murloc:SetDisplayInfo(i)
      local fileID = L.murloc:GetModelFileID()
      if fileID and not ml[fileID] then
        ml[fileID] = i
        counter = counter + 1
      end
    end
  end
  print(L.name, 'searched from id: [', last_id, '] - [', new_id, '], found this many new models: [', counter, ']')
  print(L.name, 'model-list has now a size of:', GetTableLength(ml))
  if counter == 0 then
    print(L.name, 'no new entry for model list found. stopping script.')
    L.murloc:ResetModelToMurloc()
    L.F:SetDisplayInfoModelList()
    return
  end
  L.DB.GLOB["MODEL_LIST"] = ml
  L.DB.GLOB["LAST_DISPLAY_ID"] = new_id
  C_Timer.After(5, function()
    L.F:BuildModelList(loopCounter + 1)
  end)
end

function L.F:RoundNumber(n)
  return math.floor((n) * 10) / 10
end

-- create button func
function L.F:CreateButton(parent, name, text, adjustWidth, adjustHeight)
  local b = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
  b.text = _G[b:GetName() .. "Text"]
  b.text:SetText(text)
  b:SetWidth(b.text:GetStringWidth() + (adjustWidth or 20))
  b:SetHeight(b.text:GetStringHeight() + (adjustHeight or 12))
  return b
end

-- create color picker button func
function L.F:CreateColorPickerButton(parent, name)
  -- color picker button frame
  local b = CreateFrame("Button", name, parent)
  b:SetSize(75, 25)
  -- color picker background
  b.bg = b:CreateTexture(nil, "BACKGROUND", nil, -7)
  b.bg:SetPoint("TOPLEFT", 4, -4)
  b.bg:SetPoint("BOTTOMRIGHT", -4, 4)
  b.bg:SetColorTexture(1, 1, 1)
  b.bg:SetVertexColor(unpack(L.DB.GLOB["COLOR"]))
  -- color picker Callback func
  function b:Callback(color)
    if not color then
      color = {CPF:GetColorRGB()}
    end
    -- to bad no self reference is available
    b.bg:SetVertexColor(unpack(color))
    -- call the object specific UpdateColor func
    b:UpdateColor(unpack(color))
  end
  -- color picker OnClick func
  b:SetScript("OnClick", function(self)
    CPF:SetFrameStrata("FULLSCREEN_DIALOG") -- make sure the CPF lives ontop of the canvas
    local info = {}
    info.r, info.g, info.b = self.bg:GetVertexColor()
    local a = nil
    info.opacity = a
    info.hasOpacity = (a ~= nil)
    info.swatchFunc = self.Callback
    info.cancelFunc = self.Callback
    CPF:SetupColorPickerAndShow(info)
  end)
  return b
end

function L.F:CreateEditBox(parent, name, title, value)
  local e = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
  e:SetSize(80, 30)
  e:SetAutoFocus(false)
  e:SetText(value)
  e:SetJustifyH("CENTER")
  if title then
    e.title = e:CreateFontString(nil, "BACKGROUND")
    e.title:SetPoint("BOTTOM", e, "TOP", 0, 0)
    e.title:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    e.title:SetText(title)
    e.title:SetAlpha(0.5)
  end
  return e
end

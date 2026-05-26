local A, L = ...

---------------------------------------------------------------------
-- vars
---------------------------------------------------------------------

local ROW_HEIGHT = 22

---------------------------------------------------------------------
-- L.templateManager
---------------------------------------------------------------------

local frame = CreateFrame("Frame", nil, UIParent, "ButtonFrameTemplate")
L.templateManager = frame

frame:SetSize(260, 260)
frame:SetClampedToScreen(true)
frame:Hide()

ButtonFrameTemplate_HidePortrait(frame)

frame.title = frame.NineSlice:CreateFontString(nil, "OVERLAY", "GameFontNormal")
frame.title:SetPoint("TOP", 0, -5)
frame.title:SetText("Template Manager")

---------------------------------------------------------------------
-- IsPresetTemplate(name)
---------------------------------------------------------------------

local function IsPresetTemplate(name)
  if type(name) ~= "string" or name == "" then
    return false
  end
  return string.sub(name, 1, 1) == "_"
end

---------------------------------------------------------------------
-- CreateRow(row, data)
---------------------------------------------------------------------

local function CreateRow(row, data)

  row:SetHeight(ROW_HEIGHT)

  if not row.nameButton then

    -- create delete button
    row.deleteButton = CreateFrame("Button", nil, row)
    row.deleteButton:SetSize(16, 16)
    row.deleteButton:SetPoint("RIGHT", row, "RIGHT", -5, 0)
    row.deleteButton:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
    row.deleteButton:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Highlight")

    -- create name buttonm
    row.nameButton = CreateFrame("Button", nil, row)
    row.nameButton:SetPoint("LEFT", row, "LEFT", 5, 0)
    row.nameButton:SetPoint("RIGHT", row.deleteButton, "LEFT", -5, 0)
    row.nameButton:SetHeight(ROW_HEIGHT)

    row.nameButton:SetScript("OnEnter", function()
      row.nameText:SetTextColor(1, 1, 1)
    end)
    row.nameButton:SetScript("OnLeave", function()
      row.nameText:SetTextColor(GameFontNormal:GetTextColor())
    end)

    -- create name text
    row.nameText = row.nameButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.nameText:SetAllPoints(row.nameButton)
    row.nameText:SetJustifyH("LEFT")

  end

  if IsPresetTemplate(data.name) then
    row.deleteButton:SetAlpha(0.2)
  else
    row.deleteButton:SetAlpha(1)
  end

  row.nameText:SetText(data.name)

  row.deleteButton:SetScript("OnClick", function()
    if not L.DB.userTemplates[data.name] then return end
    row.deleteTarget = data.name
    StaticPopup_Show("RMOC_TEMPLATEMANAGER_CONFIRM_DELETE", data.name, nil, row)
  end)

  row.nameButton:SetScript("OnClick", function()
    local template = L.DB.presetTemplates[data.name] or L.DB.userTemplates[data.name] or nil
    if not template then return end
    L.S.modelIDSetting:SetValue(template.modelID)
    L.S.splitAlphaSetting:SetValue(template.splitAlpha)
    L.S.modelAlphaSetting:SetValue(template.modelAlpha)
    L.S.fillTextureSetting:SetValue(template.fillTexture)
    L.S.fillColorSetting:SetValue(template.fillColor)
    --other
    L.S.fillValueSetting:SetValue(1)
    L.S.showDebuffGlowSetting:SetValue(false)
    L.S.showLowHealthSetting:SetValue(false)
  end)

end

---------------------------------------------------------------------
-- scrollContainer
---------------------------------------------------------------------

local scrollContainer = CreateFrame("Frame", nil, frame)
scrollContainer:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -75)
scrollContainer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -35, 40)

local scrollBox = CreateFrame("Frame", nil, scrollContainer, "WowScrollBoxList")
scrollBox:SetAllPoints(scrollContainer)

local scrollBar = CreateFrame("EventFrame", nil, frame, "MinimalScrollBar")
scrollBar:SetPoint("TOPLEFT", scrollContainer, "TOPRIGHT", 6, 0)
scrollBar:SetPoint("BOTTOMLEFT", scrollContainer, "BOTTOMRIGHT", 6, 0)

local scrollView = CreateScrollBoxListLinearView()
scrollView:SetElementExtent(ROW_HEIGHT)
scrollView:SetPadding(2, 2, 2, 2, 2)

local scrollDataProvider = CreateDataProvider()
scrollView:SetElementInitializer("Frame", CreateRow)
scrollView:SetDataProvider(scrollDataProvider)
ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, scrollView)

---------------------------------------------------------------------
-- UpdateTemplateList()
---------------------------------------------------------------------

local function UpdateTemplateList()
  scrollDataProvider:Flush()
  local sortedNames = {}
  for name in pairs(L.DB.presetTemplates) do
    table.insert(sortedNames, name)
  end
  for name in pairs(L.DB.userTemplates) do
    table.insert(sortedNames, name)
  end
  table.sort(sortedNames)
  for _, name in ipairs(sortedNames) do
    scrollDataProvider:Insert({ name = name })
  end
end
L.F.UpdateTemplateList = UpdateTemplateList

---------------------------------------------------------------------
-- templateNameEditBox + templateNameSaveButton
---------------------------------------------------------------------

local templateNameEditBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
templateNameEditBox:SetHeight(20)
templateNameEditBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -32)
templateNameEditBox:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -75, -32)
templateNameEditBox:SetAutoFocus(false)

templateNameEditBox:SetScript("OnEscapePressed", function(self)
  self:SetText("")
  self:ClearFocus()
end)

local templateNameSaveButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
templateNameSaveButton:SetSize(60, 22)
templateNameSaveButton:SetPoint("LEFT", templateNameEditBox, "RIGHT", 5, 0)
templateNameSaveButton:SetText("Save")
templateNameSaveButton:SetScript("OnClick", function()
  local name = strtrim(templateNameEditBox:GetText())
  if name == "" or IsPresetTemplate(name) or L.DB.userTemplates[name] then
     print(L.name, "Cannot save template under this name. Maybe already in use or prohibited preset name.")
    return
  end
  L.DB.userTemplates[name] = {
    modelID      = L.S.modelIDSetting:GetValue(),
    modelAlpha   = L.S.modelAlphaSetting:GetValue(),
    splitAlpha   = L.S.splitAlphaSetting:GetValue(),
    fillTexture  = L.S.fillTextureSetting:GetValue(),
    fillColor    = L.S.fillColorSetting:GetValue(),
  }
  print(L.name, "Saved template '" .. name .. "'")
  templateNameEditBox:SetText("")
  templateNameEditBox:ClearFocus()
  L.F.UpdateTemplateList()
end)

---------------------------------------------------------------------
-- StaticPopupDialogs
---------------------------------------------------------------------

StaticPopupDialogs["RMOC_TEMPLATEMANAGER_CONFIRM_DELETE"] = {
  text = "Are you sure you want to delete the template '%s'?",
  button1 = YES,
  button2 = NO,
  OnAccept = function(self, row)
    if not row or not row.deleteTarget then return end
    print(L.name, "Deleted template '" .. row.deleteTarget .. "'")
    L.DB.userTemplates[row.deleteTarget] = nil
    L.F.UpdateTemplateList()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

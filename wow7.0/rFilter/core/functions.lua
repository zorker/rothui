
-- rFilter: core/functions
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

--functions container
L.F = {}

-----------------------------
-- Functions
-----------------------------

--NumberFormat
local function NumberFormat(v)
  if v > 1E10 then
    return (floor(v/1E9)).."b"
  elseif v > 1E9 then
    return (floor((v/1E9)*10)/10).."b"
  elseif v > 1E7 then
    return (floor(v/1E6)).."m"
  elseif v > 1E6 then
    return (floor((v/1E6)*10)/10).."m"
  elseif v > 1E4 then
    return (floor(v/1E3)).."k"
  elseif v > 1E3 then
    return (floor((v/1E3)*10)/10).."k"
  else
    return v
  end
end
L.F.NumberFormat = NumberFormat

local function CreateButton(type,buttonName,spellid,unit,size,point,visibility,alpha,desaturate,playerOnly)
  local spellName, spellRank, spellIcon = GetSpellInfo(spellid)
  if not spellName then print(A,"error",buttonName,"Spell not found",spellid) return end
  local button = CreateFrame("CHECKBUTTON", A..buttonName..spellid, UIParent, "ActionButtonTemplate, SecureHandlerStateTemplate")
  button.settings = {
    type = type,
    spellid = spellid,
    index = spellid, --raidbuffs use index
    unit = unit,
    size = size,
    alphaOff = alpha[1],
    alphaOn = alpha[2],
    desaturate = desaturate,
    playerOnly = playerOnly,
    spellName = spellName,
    spellRank = spellRank,
    spellIcon = spellIcon,
  }
  button.icon:SetTexture(spellIcon)
  button:EnableMouse(false)
  button:SetSize(size,size)
  button:SetPoint(unpack(point))
  if visibility then
    RegisterStateDriver(button, "visibility", visibility)
  end
  --style button
  rButtonTemplate:StyleActionButton(button,L.C.actionButtonConfig)
  --drag/resize frame
  rLib:CreateDragResizeFrame(button, L.dragFrames, -2, true)
  return button
end
L.F.CreateButton = CreateButton

local function ResetButton(button)
  button:SetAlpha(button.settings.alphaOff)
  button.Border:Hide()
end

local function UpdateAura(button,filter)
  local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal,
    spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod,
    value1, value2, value3 = UnitAura(button.settings.unit, button.settings.spellName, button.settings.spellRank, filter)
  if not name then
    ResetButton(button)
    return
  end
  button:SetAlpha(button.settings.alphaOn)
  if caster == "player" then
    button.Border:SetVertexColor(0.2,0.6,0.8,1)
    button.Border:Show()
  else
    button.Border:Hide()
  end
end

local function UpdateBuff(button)
  UpdateAura(button,"HELPFUL")
end
L.F.UpdateBuff = UpdateBuff
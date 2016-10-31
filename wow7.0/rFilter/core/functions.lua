
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

local floor,mod,format = floor,mod,format

local function GetFormatedTime(time)
  if time <= 0 then
    return nil
  elseif time < 2 then
    return floor(time*10)/10
  elseif time < 60 then
    return format("%ds", mod(time, 60))
  elseif time < 3600 then
    return format("%dm", floor(mod(time, 3600) / 60 + 1))
  else
    return format("%dh", floor(time / 3600 + 1))
  end
end

local function SetDuration(button,duration)
  if duration <= 0 or duration > 10 then
    button.duration:SetText(GetFormatedTime(duration))
    button.duration:SetTextColor(1, 1, 1)
  elseif duration < 2 then
    button.duration:SetText(GetFormatedTime(duration))
    button.duration:SetTextColor(1, 0.4, 0)
  else
    button.duration:SetText(GetFormatedTime(duration))
    button.duration:SetTextColor(1, 0.8, 0)
  end
end

local function SetCount(button,count)
  if count and count > 1 then
    button.count:SetText(count)
  else
    button.count:SetText("")
  end
end

--NumberFormat
local function NumberFormat(v)
  if not v then return nil end
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

--UpdateFont
local function UpdateFont(button,fontString,fontCfg,buttonSize)
  local fontFamily,fontSize,fontOutline = unpack(fontCfg)
  fontSize = buttonSize*fontSize/button.settings.size
  fontString:SetFont(fontFamily,fontSize,fontOutline)
end

--OnSizeChanged
local function OnSizeChanged(button, width, height)
  local size = math.max(width,button.settings.size)
  button:SetSize(size,size)
  UpdateFont(button,button.duration,L.C.actionButtonConfig.name.font,size)
  UpdateFont(button,button.count,L.C.actionButtonConfig.count.font,size)
  UpdateFont(button,button.extravalue,L.C.actionButtonConfig.hotkey.font,size)
end

--CreateButton
local function CreateButton(type,buttonName,spellid,unit,size,point,visibility,alpha,desaturate,caster)
  local spellName, spellRank, spellIcon = GetSpellInfo(spellid)
  if not spellName then print(A,"error",buttonName,"Spell not found",spellid) return end
  local button = CreateFrame("CHECKBUTTON", A..buttonName..spellid, UIParent, "ActionButtonTemplate, SecureHandlerStateTemplate")
  button.settings = {
    type = type,
    spellid = spellid,
    unit = unit,
    size = size,
    alphaOff = alpha[1],
    alphaOn = alpha[2],
    desaturate = desaturate,
    caster = caster,
    spellName = spellName,
    spellRank = spellRank,
    spellIcon = spellIcon,
  }
  buttonName = button:GetName()
  button.icon:SetTexture(spellIcon)
  button.border = button.Border
  button.border:Show()
  button.duration = _G[buttonName.."Name"]
  button.extravalue = _G[buttonName.."HotKey"]
  button.count = _G[buttonName.."Count"]
  button:EnableMouse(false)
  button:SetSize(size,size)
  button:SetPoint(unpack(point))
  if visibility then
    button.frameVisibility = visibility
    RegisterStateDriver(button, "visibility", visibility)
  end
  --style button
  rButtonTemplate:StyleActionButton(button,L.C.actionButtonConfig)
  --drag/resize frame
  rLib:CreateDragResizeFrame(button, L.dragFrames, -2, true)
  --onsizechanged
  button:SetScript("OnSizeChanged", OnSizeChanged)
  return button
end
L.F.CreateButton = CreateButton

--ResetButton
local function ResetButton(button)
  if button.state == 1 then return end
  button:SetAlpha(button.settings.alphaOff)
  button.duration:SetText("")
  button.extravalue:SetText("")
  button.count:SetText("")
  if button.settings.desaturate then
    button.icon:SetDesaturated(1)
  end
  button.border:SetVertexColor(0.2,0.6,0.8,0)
  button.state = 1
end

--PreviewButton
local function PreviewButton(button)
  if button.state == -1 then return end
  button:SetAlpha(1)
  button.duration:SetText("30m")
  if button.settings.type == "buff" or button.settings.type == "debuff" then
    button.extravalue:SetText("146k")
    button.count:SetText("3")
  end
  if button.settings.desaturate then
    button.icon:SetDesaturated(nil)
  end
  button.border:SetVertexColor(0.2,0.6,0.8,0)
  button.state = -1
end

--EnableButton
local function EnableButton(button)
  if button.state == 2 then return end
  button:SetAlpha(button.settings.alphaOn)
  if button.settings.desaturate then
    button.icon:SetDesaturated(nil)
  end
  button.state = 2
end

--UpdateAura
local function UpdateAura(button, filter)
  if button.dragFrame:IsShown() then
    PreviewButton(button)
    return
  end
  if button.settings.unit and not UnitExists(button.settings.unit) then
    ResetButton(button)
    return
  end
  local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal,
    spellid, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod,
    value1, value2, value3 = UnitAura(button.settings.unit, button.settings.spellName, button.settings.spellRank, filter)
  if not name or (button.settings.caster and caster ~= button.settings.caster) then
    ResetButton(button)
    return
  end
  SetDuration(button,expires-GetTime())
  SetCount(button,count)
  button.extravalue:SetText(NumberFormat(value1 or value2 or value3))
  if button.settings.caster and caster == "player" then
    button.border:SetVertexColor(0.2,0.6,0.8,1)
  else
    button.border:SetVertexColor(0.2,0.6,0.8,0)
  end
  EnableButton(button)
end

--UpdateBuff
local function UpdateBuff(button)
  UpdateAura(button,"HELPFUL")
end
L.F.UpdateBuff = UpdateBuff

--UpdateDebuff
local function UpdateDebuff(button)
  UpdateAura(button,"HARMFUL")
end
L.F.UpdateDebuff = UpdateDebuff

--UpdateCooldown
local function UpdateCooldown(button)
  if button.dragFrame:IsShown() then
    PreviewButton(button)
    return
  end
  local start, cooldown, enable = GetSpellCooldown(button.settings.spellid)
  local duration = start+cooldown-GetTime()
  if duration > 0 and cooldown > 2 then
    ResetButton(button)
    SetDuration(button,duration)
  else
    local isUsable, notEnoughMana = IsUsableSpell(button.settings.spellName)
    if not isUsable or notEnoughMana then
      ResetButton(button)
      return
    end
    button.duration:SetText("RDY")
    button.duration:SetTextColor(0, 0.8, 0)
    EnableButton(button)
  end
end
L.F.UpdateCooldown = UpdateCooldown
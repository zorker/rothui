
-- rButtonAura: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local tick = 0.1

local GetTime, UnitAura, math = GetTime, UnitAura, math
local numAuras = 0
local auras = {}
local numCharges = 0
local charges = {}
local spec = nil
local form = 0

-----------------------------
-- rButtonAura Global
-----------------------------

rButtonAura = {}
rButtonAura.addonName = A

-----------------------------
-- Functions
-----------------------------

--AddAura
function rButtonAura:AddCharge(charge)
  table.insert(charges,charge)
end

--AddAura
function rButtonAura:AddAura(aura)
  table.insert(auras,aura)
end

--SetTick
function rButtonAura:SetTick(t)
  tick = t
end

--ShowCharge
local function ShowCharge(charge)
  if charge.bar then
    charge.bar:Show()
  end
end

--HideCharge
local function HideCharge(charge)
  if charge.bar then
    charge.bar:Hide()
  end
end

--ShowAura
local function ShowAura(aura)
  if aura.bar then
    aura.bar:Show()
  end
  if aura.border then
    aura.border:Show()
  end
end

--HideAura
local function HideAura(aura)
  if aura.bar then
    aura.bar:Hide()
  end
  if aura.border then
    aura.border:Hide()
  end
end

--UpdateAura
local function UpdateAura(aura)
  local name, icon, count, debuffType, duration, expires, caster = AuraUtil.FindAuraByName(aura.spellName, aura.unit, aura.filter)
  if name and (not aura.caster or caster == aura.caster) then
    if aura.bar then
      local perc = (duration+GetTime()-expires)/duration
      local w = aura.bar.maxwidth-perc*aura.bar.maxwidth
      aura.bar:SetWidth(w)
    end
    ShowAura(aura)
  else
    HideAura(aura)
  end
end

--UpdateCharge
local function UpdateCharge(charge)
  local curcharge, maxcharge, cdstart, cdduration = GetSpellCharges(charge.spellid)
  if curcharge == maxcharge then HideCharge(charge) return end
  if charge.bar then
    local perc = ((GetTime()-cdstart+cdduration)/cdduration)-1
    local w = charge.bar.maxwidth-perc*charge.bar.maxwidth
    charge.bar:SetWidth(w)
  end
  ShowCharge(charge)
end

--UpdateAuras
local function UpdateAuras()
  for i, aura in next, auras do
    if aura.enabled then
      UpdateAura(aura)
    end
  end
end

--UpdateCharges
local function UpdateCharges()
  for i, charge in next, charges do
    if charge.enabled then
      UpdateCharge(charge)
    end
  end
end

--Tick
local function Tick()
  UpdateAuras()
  UpdateCharges()
  C_Timer.After(tick, Tick)
end

local function UpdateSpells()
  spec = GetSpecialization()
  form = GetShapeshiftForm()
  --auras
  for i, aura in next, auras do
    if aura.requireSpell and not IsPlayerSpell(aura.requireSpell) then
      HideAura(aura)
      aura.enabled = false
    elseif aura.spec and aura.form and (aura.spec ~= spec or aura.form ~= form) then
      HideAura(aura)
      aura.enabled = false
    elseif aura.spec and aura.spec ~= spec then
      HideAura(aura)
      aura.enabled = false
    elseif aura.form and aura.form ~= form then
      HideAura(aura)
      aura.enabled = false
    else
      aura.enabled = true
    end
  end
  --charges
  for i, charge in next, charges do
    if charge.requireSpell and not IsPlayerSpell(charge.requireSpell) then
      HideCharge(charge)
      charge.enabled = false
    elseif charge.spec and charge.form and (charge.spec ~= spec or charge.form ~= form) then
      HideCharge(charge)
      charge.enabled = false
    elseif charge.spec and charge.spec ~= spec then
      HideCharge(charge)
      charge.enabled = false
    elseif charge.form and charge.form ~= form then
      HideCharge(charge)
      charge.enabled = false
    else
      charge.enabled = true
    end
  end
end

--Login
local function Login()
  numAuras = #auras
  numCharges = #charges
  if numAuras == 0 and numCharges == 0 then return end
  local error = false
  --auras
  for i, aura in next, auras do
    if type(aura.button) == "string" then aura.button = _G[aura.button] end
    local border = _G[aura.button:GetName().."Border"]
    if not border then
      print(A,aura.spellid,"border not found")
      error = true
      break
    else
      aura.border = border
    end
    local spellName = GetSpellInfo(aura.spellid)
    if not spellName then
      print(A,aura.spellid,"spell id not found")
      error = true
      break
    else
      aura.spellName = spellName
    end
    if aura.useBar then
      local a, b = aura.border:GetDrawLayer()
      aura.bar = aura.border:GetParent():CreateTexture(nil,a,nil,b+1)
      aura.bar:SetColorTexture(unpack(aura.barColor))
      aura.bar:SetBlendMode(aura.barBlendMode or "ADD")
      aura.bar:SetPoint(unpack(aura.barPoint))
      aura.bar:SetSize(0,aura.barHeight)
      aura.bar:Hide()
      aura.bar.maxwidth = aura.border:GetParent():GetWidth()
    end
    if aura.useBorder then
      aura.border:SetVertexColor(unpack(aura.borderColor))
    end
    aura.enabled = false
  end
  --charges
  for i, charge in next, charges do
    if type(charge.button) == "string" then charge.button = _G[charge.button] end
    local border = _G[charge.button:GetName().."Border"]
    if not border then
      print(A,charge.spellid,"border not found")
      error = true
      break
    else
      charge.border = border
    end
    local spellName = GetSpellInfo(charge.spellid)
    if not spellName then
      print(A,charge.spellid,"spell id not found")
      error = true
      break
    else
      charge.spellName = spellName
    end
    if charge.useBar then
      local a, b = charge.border:GetDrawLayer()
      charge.bar = charge.border:GetParent():CreateTexture(nil,a,nil,b+2)
      charge.bar:SetColorTexture(unpack(charge.barColor))
      charge.bar:SetBlendMode(charge.barBlendMode or "ADD")
      charge.bar:SetPoint(unpack(charge.barPoint))
      charge.bar:SetSize(0,charge.barHeight)
      charge.bar:Hide()
      charge.bar.maxwidth = charge.border:GetParent():GetWidth()
    end
    charge.enabled = false
  end
  --init
  if not error then
    --RegisterCallback SPELLS_CHANGE
    rLib:RegisterCallback("SPELLS_CHANGED", UpdateSpells)
    UpdateSpells()
    Tick()
  end
end

--RegisterCallback PLAYER_LOGIN
rLib:RegisterCallback("PLAYER_LOGIN", Login)



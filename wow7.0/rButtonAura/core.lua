
-- rButtonAura: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local tick = 0.1

local GetTime, UnitAura, mabs = GetTime, UnitAura, math.abs
local numAuras = 0
local auras = {}

-----------------------------
-- Aura config
-----------------------------

local aura = {
  border          = _G["ActionButton3Border"],
  unit            = "target",
  caster          = "player",
  spellId         = 243016,
  filter          = "HARMFUL|PLAYER",
  useBorder       = true,
  borderColor     = {0,1,1},
}
table.insert(auras,aura)

local aura = {
  border          = _G["ActionButton8Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 132404,
  filter          = "HELPFUL|PLAYER",
  useBar          = true,
  barColor        = {0,1,0,0.8},
  useBorder       = false,
  borderColor     = {0,1,0,0.5},
}
table.insert(auras,aura)

local aura = {
  border          = _G["ActionButton9Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 190456,
  filter          = "HELPFUL|PLAYER",
  useBar          = true,
  barColor        = {0,1,0,0.8},
  useBorder       = false,
  borderColor     = {0,1,0},
}
table.insert(auras,aura)

local aura = {
  border          = _G["MultiBarBottomLeftButton1Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 12975,
  filter          = "HELPFUL|PLAYER",
  useBorder       = true,
  borderColor     = {0,1,0},
}
table.insert(auras,aura)

local aura = {
  border          = _G["MultiBarBottomLeftButton2Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 871,
  filter          = "HELPFUL|PLAYER",
  useBorder       = true,
  borderColor     = {0,1,0},
}
table.insert(auras,aura)

local aura = {
  border          = _G["MultiBarBottomLeftButton3Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 125565,
  filter          = "HELPFUL|PLAYER",
  useBorder       = true,
  borderColor     = {0,1,0},
}
table.insert(auras,aura)

-----------------------------
-- Functions
-----------------------------

--UpdateAura
local function UpdateAura(aura)
  local name, rank, icon, _, _, duration, expires, caster, _, _, spellid = UnitAura(aura.unit, aura.spellName, aura.spellRank, aura.filter)
  if name and caster == aura.caster then
    if aura.useBar then
      local perc = (duration+GetTime()-expires)/duration
      local w = aura.bar.maxwidth-perc*aura.bar.maxwidth
      aura.bar:SetWidth(w)
      aura.bar:Show()
    end
    if aura.useBorder then
      aura.border:Show()
    end
  else
    if aura.useBar then
      aura.bar:Hide()
    end
    if aura.useBorder then
      aura.border:Hide()
    end
  end
end

--Update
local function Update()
  for i, aura in next, auras do
    UpdateAura(aura)
  end
  C_Timer.After(tick, Update)
end

--Login
local function Login()
  print(A,"Login")
  numAuras = #auras
  if numAuras == 0 then return end
  local error = false
  for i, aura in next, auras do
    if not aura.border then
      print(A,aura.spellId,"border not found")
      error = true
      break
    end
    aura.spellName, aura.spellRank = GetSpellInfo(aura.spellId)
    if not aura.spellName then
      print(A,aura.spellId,"spell id not found")
      error = true
      break
    end
    if aura.useBar then
      local la, li = aura.border:GetDrawLayer()
      aura.bar = aura.border:GetParent():CreateTexture(nil,la,nil,li)
      aura.bar:SetColorTexture(unpack(aura.barColor))
      aura.bar:SetBlendMode("ADD")
      aura.bar:SetPoint("TOPLEFT")
      aura.bar:SetSize(0,aura.border:GetParent():GetHeight()/10)
      aura.bar:Hide()
      aura.bar.maxwidth = aura.border:GetParent():GetWidth()
    end
    if aura.useBorder then
      aura.border:SetVertexColor(unpack(aura.borderColor))
    end
  end
  if not error then
    Update()
  end
end

--RegisterCallback PLAYER_LOGIN
--rLib:RegisterCallback("PLAYER_LOGIN", Login)


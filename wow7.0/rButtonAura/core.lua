
-- rButtonAura: core
-- zork, 2018

-----------------------------
-- Variables
-----------------------------

local A, L = ...

local tick = 0.1

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
  filter          = "HARMFUL",
  color           = {0,1,1}
}
table.insert(auras,aura)

local aura = {
  border          = _G["ActionButton8Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 132404,
  filter          = "HELPFUL",
  color           = {0,1,0}
}
table.insert(auras,aura)

local aura = {
  border          = _G["ActionButton9Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 190456,
  filter          = "HELPFUL",
  color           = {0,1,0}
}
table.insert(auras,aura)

local aura = {
  border          = _G["MultiBarBottomLeftButton1Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 12975,
  filter          = "HELPFUL",
  color           = {0,1,0}
}
table.insert(auras,aura)

local aura = {
  border          = _G["MultiBarBottomLeftButton2Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 871,
  filter          = "HELPFUL",
  color           = {0,1,0}
}
table.insert(auras,aura)

local aura = {
  border          = _G["MultiBarBottomLeftButton3Border"],
  unit            = "player",
  caster          = "player",
  spellId         = 125565,
  filter          = "HELPFUL",
  color           = {0,1,0}
}
table.insert(auras,aura)

-----------------------------
-- Functions
-----------------------------

--UpdateAura
local function UpdateAura(aura)
  local name, rank, icon, _, _, _, _, caster, _, _, spellid = UnitAura(aura.unit, aura.spellName, aura.spellRank, aura.filter)
  if name and caster == aura.caster then
    aura.border:Show()
  else
    aura.border:Hide()
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
  numAuras = #auras
  if numAuras == 0 then return end
  local error = false
  for i, aura in next, auras do
    aura.spellName, aura.spellRank = GetSpellInfo(aura.spellId)
    if not aura.spellName then
      print(A,aura.spellId,"spell id not found")
      error = true
      break
    end
    aura.border:SetVertexColor(unpack(aura.color))
  end
  if not error then
    Update()
  end
end

--RegisterCallback PLAYER_LOGIN
rLib:RegisterCallback("PLAYER_LOGIN", Login)


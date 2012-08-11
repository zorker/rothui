
--get the addon namespace
local addon, ns = ...
--config
local cfg = ns.cfg
--Pulsar
local Pulsar = CreateFrame("Frame", "Pulsar", UIParent)
Pulsar.unit = {}
Pulsar.db = {}
Pulsar.db.sys = ns.sys
Pulsar:Hide()
ns.Pulsar = Pulsar

-----------------------------
-- FUNCTIONS
-----------------------------

--SetPosition
function Pulsar:SetPosition(f,pos)
  if not f then return end
  f:ClearAllPoints()
  --setpoint
  if pos then
    if pos.af and pos.a2 then
      f:SetPoint(pos.a1 or "CENTER", pos.af, pos.a2, pos.x or 0, pos.y or 0)
    elseif pos.af then
      f:SetPoint(pos.a1 or "CENTER", pos.af, pos.x or 0, pos.y or 0)
    --elseif pos.a2 then
      --f:SetPoint(pos.a1 or "CENTER", pos.a2, pos.x or 0, pos.y or 0)
    else
      f:SetPoint(pos.a1 or "CENTER", pos.x or 0, pos.y or 0)
      print(f:GetName())
      print(pos.x)
    end
  else
    f:SetPoint("CENTER",UIParent,"CENTER",0,0)
  end
end

--create the orb textures/frames
function Pulsar:CreateOrb(parent,name)
  local f = CreateFrame("StatusBar", name, parent)
  f:SetMinMaxValues(0,1)
  f:SetSize(parent.cfg.size,parent.cfg.size)
  f:SetPoint("CENTER")
  --background
  local t = f:CreateTexture(nil, "BACKGROUND", nil, -6)
  t:SetTexture("Interface\\AddOns\\Pulsar\\media\\orb_back")
  t:SetAllPoints(f)
  f.bg = t
  --filling
  local t = f:CreateTexture(nil, "BACKGROUND", nil, -4)
  t:SetTexture("Interface\\AddOns\\Pulsar\\media\\filling\\orb_filling1")
  t:SetPoint("BOTTOMLEFT",0,0)
  t:SetPoint("BOTTOMRIGHT",0,0)
  t:SetHeight(parent.cfg.size)
  f.filling = t
  --animation frame
  local h = CreateFrame("PlayerModel", nil, f)
  h:SetAllPoints(f)
  f.anim = h
  --galaxies
  f.galaxy = {}
  local t = f.anim:CreateTexture(nil, "BACKGROUND", nil, -4)
  --t:SetTexture(0,1,0,0.1)
  t:SetAllPoints(f)
  table.insert(f.galaxy,t)
  local t = f.anim:CreateTexture(nil, "BACKGROUND", nil, -4)
  --t:SetTexture(0,1,0,0.1)
  t:SetAllPoints(f)
  table.insert(f.galaxy,t)
  local t = f.anim:CreateTexture(nil, "BACKGROUND", nil, -4)
  --t:SetTexture(0,1,0,0.1)
  t:SetAllPoints(f)
  table.insert(f.galaxy,t)
  --overlay frame
  local h = CreateFrame("Frame", nil, f.anim)
  h:SetAllPoints(f)
  f.overlay = h
  --highlight texture
  local t = f.overlay:CreateTexture(nil, "BACKGROUND", nil, -6) -- framestrata/level is _NOT_ reliable. frame stacking is.
  t:SetTexture("Interface\\AddOns\\Pulsar\\media\\orb_gloss")
  t:SetAllPoints(f)
  f.highlight = t
  return f
end

--CreateHealthOrb
function Pulsar:CreateHealthOrb(parent)
  local unit = parent.unit
  local cfg = parent.cfg
  local name = addon..unit:sub(1,1):upper()..unit:sub(2).."HealthOrb"
  local f = self:CreateOrb(parent,name)
  f.type = "health"
  f.unit = unit
  --update health func
  local updateHealth = function(self, event, unit, ...)
    if unit and unit ~= self.unit then return end
    local uh, uhm, p, d = UnitHealth(self.unit) or 0, UnitHealthMax(self.unit), 0, 0
    if uhm and uhm > 0 then
      p = floor(uh/uhm*100)
      d = uh/uhm
      self:SetValue(d)
      --print(self:GetValue())
    end
    self.filling:SetHeight(d*self.filling:GetWidth())
    self.filling:SetTexCoord(0,1, math.abs(d-1),1)
  end
  --register events
  f:RegisterEvent("UNIT_HEALTH")
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  --event
  f:SetScript("OnEvent", updateHealth)
  return f
end

--CreatePowerOrb
function Pulsar:CreatePowerOrb(parent)
  local unit = parent.unit
  local cfg = parent.cfg
  local name = addon..unit:sub(1,1):upper()..unit:sub(2).."PowerOrb"
  local f = self:CreateOrb(parent,name)
  f.type = "power"
  f.unit = unit
  --update power func
  local updatePower = function(self, event, unit, ...)
    if unit and unit ~= self.unit then return end
    local up, upm, p, d = UnitPower(self.unit) or 0, UnitPowerMax(self.unit), 0, 0
    if upm and upm > 0 then
      p = floor(up/upm*100)
      d = up/upm
      self:SetValue(d)
      --print(self:GetValue())
    end
    self.filling:SetHeight(d*self.filling:GetWidth())
    self.filling:SetTexCoord(0,1, math.abs(d-1),1)
  end
  --register events
  f:RegisterEvent("UNIT_POWER")
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  --event
  f:SetScript("OnEvent", updatePower)
  return f
end

--CreateUnitFrame
function Pulsar:CreateUnitFrame(unit,cfg)
  local name = addon..unit:sub(1,1):upper()..unit:sub(2).."Frame"
  local f = CreateFrame("Button", name, UIParent, "SecureUnitButtonTemplate")
  f.unit = unit
  f.cfg = cfg
  f:SetScale(cfg.scale)
  f:SetSize(cfg.size,cfg.size)
  self:SetPosition(f,cfg.pos)
  f.health = self:CreateHealthOrb(f)
  f.power = self:CreatePowerOrb(f)
  return f
end

--LoadDefaultsChar
function Pulsar:LoadDefaultsChar()
  PULSAR_DB_CHAR = {
    init = true,
  }
  print("loading db defaults char")
end

--LoadDefaultsGlob
function Pulsar:LoadDefaultsGlob()
  PULSAR_DB_GLOB = {
    init = true,
  }
  print("loading db defaults glob")
end

--ResetDBChar
function Pulsar:ResetDBChar()
  self:LoadDefaultsChar()
  self.db.char = PULSAR_DB_CHAR
end

--ResetDBGlob
function Pulsar:ResetDBGlob()
  self:LoadDefaultsGlob()
  self.db.glob = PULSAR_DB_GLOB
end

--player login
function Pulsar:PLAYER_LOGIN()
  print("login")
  --get db from savedvariables per account
  if not PULSAR_DB_GLOB then
    self:LoadDefaultsGlob()
  end
  self.db.glob = PULSAR_DB_GLOB
  --get db from savedvariables per character
  if not PULSAR_DB_CHAR then
    self:LoadDefaultsChar()
  end
  self.db.char = PULSAR_DB_CHAR

  --create player frame
  self.unit.player = self:CreateUnitFrame("player",cfg.unit.player)

  --adjust the power orb position
  self:SetPosition(self.unit.player.power,cfg.unit.player.power.pos)

  --color stuff for testing
  self.unit.player.health.filling:SetVertexColor(1,0,0)
  self.unit.player.power.filling:SetVertexColor(0,0.6,1)

end

--event handler
function Pulsar:OnEvent(event, ...)
  local action = self[event]
  if action then
    action(self, event, ...)
  end
end

--init
function Pulsar:Init()
  self:SetScript("OnEvent", self.OnEvent)
  self:RegisterEvent("PLAYER_LOGIN")
end


-----------------------------
-- INIT
-----------------------------

Pulsar:Init()
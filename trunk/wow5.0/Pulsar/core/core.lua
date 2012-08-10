
--get the addon namespace
local addon, ns = ...
--config
local cfg = ns.cfg
--Pulsar
local Pulsar = CreateFrame("Frame", "Pulsar", UIParent)
Pulsar.units = {}
Pulsar.db = {}
Pulsar:Hide()
ns.Pulsar = Pulsar

-----------------------------
-- FUNCTIONS
-----------------------------

--SetPoint
function Pulsar:SetPoint(parent,point)
  if not parent then return end
  parent:ClearAllPoints()
  --setpoint
  if point then
    if point.af and point.a2 then
      parent:SetPoint(point.a1 or "CENTER", point.af, point.a2, point.x or 0, point.y or 0)
    elseif point.af then
      parent:SetPoint(point.a1 or "CENTER", point.af, point.x or 0, point.y or 0)
    --elseif point.a2 then
      --parent:SetPoint(point.a1 or "CENTER", point.a2, point.x or 0, point.y or 0)
    else
      parent:SetPoint(point.a1 or "CENTER", point.x or 0, point.y or 0)
    end
  else
    parent:SetPoint("CENTER",UIParent,"CENTER",0,0)
  end
end

--createHealthOrb
function Pulsar:CreateHealthOrb(parent)
  local unit = parent.unit
  local cfg = parent.cfg
  local name = addon..unit:sub(1,1):upper()..unit:sub(2).."HealthOrb"
  local f = CreateFrame("StatusBar", name, parent)
  f:SetMinMaxValues(0,1)
  f.orbtype = "health"
  f.unit = unit
  f:SetAllPoints(parent)
  --background
  local t = f:CreateTexture(nil, "BACKGROUND", nil, -6)
  t:SetTexture("Interface\\AddOns\\Pulsar\\media\\orb_back")
  t:SetAllPoints(f)
  f.bg = t
  --filling
  local t = f:CreateTexture(nil, "BACKGROUND", nil, -4)
  t:SetTexture("Interface\\AddOns\\Pulsar\\media\\filling\\orb_filling1")
  t:SetVertexColor(1,0,0)
  t:SetPoint("BOTTOMLEFT",0,0)
  t:SetPoint("BOTTOMRIGHT",0,0)
  t:SetHeight(cfg.size)
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

--CreateUnitFrame
function Pulsar:CreateUnitFrame(unit,cfg)
  local name = addon..unit:sub(1,1):upper()..unit:sub(2).."Frame"
  local f = CreateFrame("Button", name, UIParent, "SecureUnitButtonTemplate")
  f.unit = unit
  f.cfg = cfg
  f:SetScale(cfg.scale)
  f:SetSize(cfg.size,cfg.size)
  self:SetPoint(f,cfg.point)
  f.health = self:CreateHealthOrb(f)
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
  --create player frame
  self.units.player = self:CreateUnitFrame("player",cfg.unit.player)
end



-----------------------------
-- INIT
-----------------------------

Pulsar:Init()
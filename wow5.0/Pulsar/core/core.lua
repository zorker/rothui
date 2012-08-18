
--get the addon namespace
local addon, ns = ...
--Pulsar
local Pulsar = CreateFrame("Frame", "Pulsar")
Pulsar.unit = {}
Pulsar.db = {}
Pulsar.db.default_char = ns.default_char --save the default values in the db, thus we can reset any setting to the default value
Pulsar.db.default_glob = ns.default_glob --save the default values in the db, thus we can reset any setting to the default value
Pulsar:Hide()
ns.Pulsar = Pulsar

-----------------------------
-- FUNCTIONS
-----------------------------

--applyPosition
function Pulsar:applyPosition(f,pos)
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
    end
  else
    f:SetPoint("CENTER",UIParent,"CENTER",0,0)
  end
end

--create the orb textures/frames
function Pulsar:CreateOrb(parent,name)
  local f = CreateFrame("StatusBar", name, parent)
  f:SetMinMaxValues(0,1)
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
  local name = addon..unit:sub(1,1):upper()..unit:sub(2).."HealthOrb"
  local f = Pulsar:CreateOrb(parent,name)
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
  f.forceUpdate = function() updateHealth(f,nil,unit) end
  f.applySize = function(size)
    parent:SetSize(size,size) --the health orb needs to be the same size as the player frame (it is positioned at the center of the unitButton)
    f:SetSize(size,size)
    --force an update to make sure the filling texture is set up correct
    f.forceUpdate()
  end
  f.applyColor = function(color)
    f.filling:SetVertexColor(unpack(color))
  end
  f.applyPosition = function(pos)
    Pulsar:applyPosition(parent, pos) --position the parent element, not the health orb (the orb is positioned center)
  end
  --register events
  f:RegisterEvent("UNIT_HEALTH")
  --event
  f:SetScript("OnEvent", updateHealth)
  return f
end

--CreatePowerOrb
function Pulsar:CreatePowerOrb(parent)
  local unit = parent.unit
  local name = addon..unit:sub(1,1):upper()..unit:sub(2).."PowerOrb"
  local f = Pulsar:CreateOrb(parent,name)
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
  --frame functions
  f.forceUpdate = function() updatePower(f,nil,unit) end
  f.applySize = function(size)
    f:SetSize(size,size)
    --force an update to make sure the filling texture is set up correct
    f.forceUpdate()
  end
  f.applyColor = function(color)
    f.filling:SetVertexColor(unpack(color))
  end
  f.applyPosition = function(pos)
    Pulsar:applyPosition(f, pos) --position the parent element, not the health orb (the orb is positioned center)
  end
  --register events
  f:RegisterEvent("UNIT_POWER")
  --event
  f:SetScript("OnEvent", updatePower)
  return f
end

--CreateUnitFrame
function Pulsar:CreateUnitFrame(unit)
  local name = addon..unit:sub(1,1):upper()..unit:sub(2).."Frame"
  local f = CreateFrame("Button", name, UIParent, "SecureUnitButtonTemplate")
  f.unit = unit
  f.applyScale = function(scale)
    f:SetScale(scale)
  end
  f.health = Pulsar:CreateHealthOrb(f)
  f.power = Pulsar:CreatePowerOrb(f)
  return f
end

--LoadDefaultsChar
function Pulsar:LoadDefaultsChar()
  PULSAR_DB_CHAR = self.db.default_char --load the config file into the db for the character
  print("loading db defaults char")
end

--LoadDefaultsGlob
function Pulsar:LoadDefaultsGlob()
  PULSAR_DB_GLOB = self.db.default_glob
  print("loading db defaults glob")
end

--ResetDBChar
function Pulsar:ResetDBChar()
  Pulsar:LoadDefaultsChar()
  self.db.char = PULSAR_DB_CHAR
end

--ResetDBGlob
function Pulsar:ResetDBGlob()
  Pulsar:LoadDefaultsGlob()
  self.db.glob = PULSAR_DB_GLOB
end

--CreateUnitFrames
function Pulsar:CreateUnitFrames()
  --create player frame
  self.unit.player = Pulsar:CreateUnitFrame("player")
  --apply db settings to player
  self.unit.player.applyScale(self.db.char.unit.player.scale)
  --apply db settings to player health
  self.unit.player.health.filling:SetHeight(self.db.char.unit.player.health.size) --fix filling texture display on first loadup
  self.unit.player.health.applyPosition(self.db.char.unit.player.health.pos)
  self.unit.player.health.applySize(self.db.char.unit.player.health.size)
  self.unit.player.health.applyColor(self.db.char.unit.player.health.color)
  --apply db settings to player power
  self.unit.player.power.filling:SetHeight(self.db.char.unit.player.power.size) --fix filling texture display on first loadup
  self.unit.player.power.applyPosition(self.db.char.unit.player.power.pos)
  self.unit.player.power.applySize(self.db.char.unit.player.power.size)
  self.unit.player.power.applyColor(self.db.char.unit.player.power.color)
end

--LoadGuiConfig
function Pulsar:LoadGuiConfig()
  --config loads when the interfaceoptionsframe is shown
  local f = CreateFrame("Frame", nil, InterfaceOptionsFrame)
  f:SetScript("OnShow", function(self)
    if not IsAddOnLoaded("PulsarConfig") then
      LoadAddOn("PulsarConfig")
      self:SetScript("OnShow",nil)
    end
  end)
  --config loads when slash command is used
  SLASH_PULSARCONFIG1, SLASH_PULSARCONFIG2 = '/pulsar', '/pulsarconfig'
  function SlashCmdList.PULSARCONFIG(msg, editbox)
    if not IsAddOnLoaded("PulsarConfig") then
      LoadAddOn("PulsarConfig")
    end
    InterfaceOptionsFrame_OpenToCategory("PulsarHealthOrb")
  end
end

--LoadDatabase
function Pulsar:LoadDatabase()
  --get db from savedvariables per account
  if not PULSAR_DB_GLOB then
    Pulsar:LoadDefaultsGlob()
  end
  self.db.glob = PULSAR_DB_GLOB
  --get db from savedvariables per character
  if not PULSAR_DB_CHAR then
    Pulsar:LoadDefaultsChar()
  end
  self.db.char = PULSAR_DB_CHAR
  --DEBUG - hard reset of config values
  --Pulsar:ResetDBChar()
  --Pulsar:ResetDBGlob()
end

--player login
function Pulsar:PLAYER_LOGIN()
  --load the database
  Pulsar:LoadDatabase()
  --gui config loader
  Pulsar:LoadGuiConfig()
  --load the unitframes
  Pulsar:CreateUnitFrames()
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
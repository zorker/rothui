
-- // Pulsar
-- // zork - 2012

--get the addon namespace
local addon, ns = ...
--Pulsar
local Pulsar = CreateFrame("Frame", "Pulsar")
Pulsar.unit = {}
Pulsar.db = {}
Pulsar.default_char = ns.default_char --save the default values in the db, thus we can reset any setting to the default value
Pulsar.default_glob = ns.default_glob --save the default values in the db, thus we can reset any setting to the default value
Pulsar:Hide()
ns.Pulsar = Pulsar

local _G = _G

-----------------------------
-- DEBUG
-----------------------------

local resetConfigOnLoadup = true

-----------------------------
-- FUNCTIONS
-----------------------------

--ApplyPosition
function Pulsar:ApplyPosition(f,pos)
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

--GetUnitForm
function Pulsar:GetUnitForm(unit)
  local form = {}
  --form id
  form.id = GetShapeshiftForm() or 0
  if UnitHasVehicleUI(unit) then
  --if UnitInVehicle(unit) then
    form.id = -1
  end
  --form name
  if form.id == -1 then
    form.name = "Vehicle"
  elseif form.id == 0 then
    form.name = "Humanoid"
  else
    form.name = select(2, GetShapeshiftFormInfo(form.id))
  end
  --form color
  if UnitHasVehicleUI(unit) then
    form.color = {0,1,0}
  else
    local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    if color and color.r then
      form.color = {color.r,color.g,color.b}
    else
      form.color = {1,0,0}
    end
  end
  --print("form.id")
  --print(form.id)
  --print("form.name")
  --print(form.name)
  --print("form.color")
  --print(unpack(form.color))
  return form
end

function Pulsar:GetUnitPowertype(unit)
  local powertype = {}
  local id, str, altR, altG, altB = UnitPowerType(unit)
  powertype.id = id or -1
  powertype.name = _G[str] or str
  local color = PowerBarColor[str]
  if (color) then
    powertype.color = {color.r, color.g, color.b}
  else
    if (not altR) then
      -- couldn't find a power token entry...default to indexing by power type or just mana if we don't have that either
      color = PowerBarColor[powertype.id] or PowerBarColor["MANA"]
      powertype.color = {color.r, color.g, color.b}
    else
      powertype.color = {altR, altG, altB}
    end
  end
  --print("powertype.id")
  --print(powertype.id)
  --print("powertype.name")
  --print(powertype.name)
  --print("powertype.color")
  --print(unpack(powertype.color))
  return powertype
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
  local name = addon..parent.unit:sub(1,1):upper()..parent.unit:sub(2).."HealthOrb"
  local f = Pulsar:CreateOrb(parent,name)
  f.type = "health"
  --update health func
  local updateHealth = function(self, event, unit, ...)
    if unit and unit ~= parent.unit then return end
    local uh, uhm, p, d = UnitHealth(unit) or 0, UnitHealthMax(unit), 0, 0
    if uhm and uhm > 0 then
      p = floor(uh/uhm*100)
      d = uh/uhm
      self:SetValue(d)
    end
    self.filling:SetHeight(d*self.filling:GetWidth())
    self.filling:SetTexCoord(0,1, math.abs(d-1),1)
  end
  f.forceUpdate = function()
    updateHealth(f,nil,parent.unit)
  end
  f.applySize = function(size)
    parent:SetSize(size,size) --the health orb needs to be the same size as the player frame (it is positioned at the center of the unitButton)
    f:SetSize(size,size)
    --force an update to make sure the filling texture is set up correct
    f.forceUpdate()
  end
  f.applyColor = function(color)
    if not color then return end
    f.filling:SetVertexColor(unpack(color))
  end
  f.applyPosition = function(pos)
    Pulsar:ApplyPosition(parent, pos) --position the parent element, not the health orb (the orb is positioned center)
  end
  --register events
  f:RegisterEvent("UNIT_HEALTH")
  --event
  f:SetScript("OnEvent", function(...)
    local self, event = ...
    if event == "UNIT_HEALTH" then
      updateHealth(...)
    end
  end)
  return f
end

--CreatePowerOrb
function Pulsar:CreatePowerOrb(parent)
  local name = addon..parent.unit:sub(1,1):upper()..parent.unit:sub(2).."PowerOrb"
  local f = Pulsar:CreateOrb(parent,name)
  f.type = "power"
  --update power func
  local updatePower = function(self, event, unit, ...)
    if unit and unit ~= parent.unit then return end
    local up, upm, p, d = UnitPower(unit) or 0, UnitPowerMax(unit), 0, 0
    if upm and upm > 0 then
      p = floor(up/upm*100)
      d = up/upm
      self:SetValue(d)
    end
    self.filling:SetHeight(d*self.filling:GetWidth())
    self.filling:SetTexCoord(0,1, math.abs(d-1),1)
  end
  --frame functions
  f.forceUpdate = function()
    updatePower(f,nil,parent.unit)
  end
  f.applySize = function(size)
    f:SetSize(size,size)
    --force an update to make sure the filling texture is set up correct
    f.forceUpdate()
  end
  f.applyColor = function(color)
    f.filling:SetVertexColor(unpack(color))
  end
  f.applyPosition = function(pos)
    Pulsar:ApplyPosition(f, pos) --position the parent element, not the health orb (the orb is positioned center)
  end
  --register events
  f:RegisterEvent("UNIT_POWER")
  --event
  f:SetScript("OnEvent", function(...)
    local self, event = ...
    if event == "UNIT_POWER" then
      updatePower(...)
    end
  end)
  return f
end

--create the dropdown menu
local dropdown = CreateFrame("Frame", "PulsarUnitMenu", UIParent, "UIDropDownMenuTemplate")
--dropdown menu func
local dropdownFunc = function(self)
  local unit = self:GetParent().unit
  if not unit then
    return
  end
  local menu
  local name
  local id = nil
  if UnitIsUnit(unit, "player") then
    menu = "SELF"
  elseif UnitIsUnit(unit, "vehicle") then
    -- NOTE: vehicle check must come before pet check for accuracy's sake because
    -- a vehicle may also be considered your pet
    menu = "VEHICLE"
  elseif UnitIsUnit(unit, "pet") then
    menu = "PET"
  elseif (UnitIsPlayer(unit)) then
    id = UnitInRaid(unit)
    if id then
      menu = "RAID_PLAYER"
      name = GetRaidRosterInfo(id)
    elseif UnitInParty(unit) then
      menu = "PARTY"
    else
      menu = "PLAYER"
    end
  else
    menu = "TARGET"
    name = RAID_TARGET_ICON
  end
  if menu then
    UnitPopup_ShowMenu(self, menu, unit, name, id)
  end
end
--initialise the dropdown menu
UIDropDownMenu_Initialize(dropdown, dropdownFunc, "MENU")
--remove focus from menu list
for k,v in pairs(UnitPopupMenus) do
  for x,y in pairs(UnitPopupMenus[k]) do
    if y == "SET_FOCUS" then
      table.remove(UnitPopupMenus[k],x)
    elseif y == "CLEAR_FOCUS" then
      table.remove(UnitPopupMenus[k],x)
    end
  end
end

--CreateUnitFrame
function Pulsar:CreatePlayerFrame()
  local unit = "player"
  local name = addon.."PlayerFrame"
  local f = CreateFrame("Button", name, UIParent, "SecureUnitButtonTemplate")
  f.unit = "player"
  f.origUnit = "player" --keep that for vehicle switching
  f:SetAttribute("unit", "player")
  f:SetAttribute("toggleForVehicle", true)
  f.menu = function(self)
    dropdown:SetParent(self)
    ToggleDropDownMenu(1, nil, dropdown, name, 0, 0)
  end
  f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  f:SetAttribute("*type1", "target")
  f:SetAttribute("*type2", "menu")
  f:SetScript("OnEnter", UnitFrame_OnEnter)
  f:SetScript("OnLeave", UnitFrame_OnLeave)
  f.applyScale = function(scale)
    f:SetScale(scale)
  end
  f.health = Pulsar:CreateHealthOrb(f)
  f.power = Pulsar:CreatePowerOrb(f)
  --update the health animation
  f.updateHealthAnimation = function(...)
    self, event, unit = ...
    if unit and unit ~= "player" then return end
    if (UnitHasVehicleUI("player")) then
      if (not f.inVehicle ) then
        f.inVehicle = true
        f.unit = "vehicle"
      end
    else
      if (f.inVehicle) then
        f.inVehicle = false
        f.unit = "player"
      end
    end
    --update the health display
    f.health.forceUpdate()
    --check the current form the player is in
    local currentForm = Pulsar:GetUnitForm("player")
    if not currentForm.name then
      print("|c00ff0000no name found for form id "..currentForm.id.."|r")
    else
      if not f.currentForm or (f.currentForm and f.currentForm.id ~= currentForm.id) then
        f.currentForm = currentForm
        print("updating form to: "..f.currentForm.name.." id: "..f.currentForm.id)
        f.health.applyColor(f.currentForm.color)
      end
    end

  end
  --update the power animation
  f.updatePowerAnimation = function(...)
    self, event, unit = ...
    if unit and unit ~= "player" then return end
    --update the power display
    f.power.forceUpdate()
    --check the powertype the player unitframe currently has
    local powertype = Pulsar:GetUnitPowertype(f.unit)
    if not powertype.name then
      print("|c00ff0000no name found for power id "..powertype.id.."|r")
    else
      if not f.powertype or (f.powertype and f.powertype.id ~= powertype.id) then
        f.powertype = powertype
        print("updating power to: "..f.powertype.name.." id: "..f.powertype.id)
        f.power.applyColor(f.powertype.color)
      end
    end
  end
  --register events
  f:RegisterEvent("PLAYER_ENTERING_WORLD")
  f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
  f:RegisterEvent("UNIT_ENTERED_VEHICLE")
  f:RegisterEvent("UNIT_EXITED_VEHICLE")
  f:RegisterEvent("UNIT_DISPLAYPOWER")
  f:RegisterEvent("PET_BATTLE_OPENING_START")
  f:RegisterEvent("PET_BATTLE_CLOSE")
  --event
  f:SetScript("OnEvent", function(...)
    local self, event, arg1 = ...
    --print(event)
    if event == "PET_BATTLE_OPENING_START" then
      f:Hide()
      return
    elseif event == "PET_BATTLE_CLOSE" then
      f:Show()
      return
    else
      f.updateHealthAnimation(...)
      f.updatePowerAnimation(...)
    end
  end)
  return f
end

--LoadDefaultsChar
function Pulsar:LoadDefaultsChar()
  PULSAR_DB_CHAR = self.default_char --load the config file into the db for the character
  print("loading db defaults char")
end

--LoadDefaultsGlob
function Pulsar:LoadDefaultsGlob()
  PULSAR_DB_GLOB = self.default_glob
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
  self.unit.player = Pulsar:CreatePlayerFrame()
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
  if resetConfigOnLoadup then
    --DEBUG - hard reset of config values
    Pulsar:ResetDBChar()
    Pulsar:ResetDBGlob()
  end
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
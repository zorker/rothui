
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
  local getFormId = function()
    --the form id
    local formId = GetShapeshiftForm() or 0
    if UnitInVehicle(unit) then
      formId = -1
    end
    --the form name
    local formName
    if fromId == -1 then
      formName = "Vehicle"
    elseif formId == 0 then
      formName = "Humanoid"
    else
      formName = select(2, GetShapeshiftFormInfo(formId))
    end
    --form color
    local formColor
    if UnitInVehicle(unit) then
      formColor = {0,1,0}
    else
      local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
      formColor = {color.r,color.g,color.b} or {1,0,0}
    end
    --print(formId)
    --print(formName)
    --print(unpack(formColor))
    return formId
  end
  f.formId = getFormId()
  print("form: "..f.formId)
  f.updateAnimation = function(...)
    self, event, arg1 = ...
    if (event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE") and arg1 ~= unit then return end
    if (UnitHasVehicleUI(f.unit)) then
      if (not f.inVehicle ) then
        f.inVehicle = true
        local prefix, id, suffix = string.match(f.unit, "([^%d]+)([%d]*)(.*)")
        f.displayedUnit = prefix.."pet"..id..suffix
        print(f.displayedUnit)
      end
    else
      if (f.inVehicle) then
        f.inVehicle = false
        f.displayedUnit = f.unit
        print(f.displayedUnit)
      end
    end

    --[[
      if ( UnitHasVehicleUI(frame.unit) ) then
        if ( not frame.inVehicle ) then
          frame.inVehicle = true
          local prefix, id, suffix = string.match(frame.unit, "([^%d]+)([%d]*)(.*)")
          frame.displayedUnit = prefix.."pet"..id..suffix
          frame:SetAttribute("unit", frame.displayedUnit)
          CompactUnitFrame_UpdateUnitEvents(frame)
        end
      else
        if ( frame.inVehicle ) then
          frame.inVehicle = false
          frame.displayedUnit = frame.unit
          frame:SetAttribute("unit", frame.displayedUnit)
          CompactUnitFrame_UpdateUnitEvents(frame)
        end
      end
    ]]
    local formId = getFormId()
    if f.formId ~= formId then
      f.formId = formId
      print("updating form id to: "..f.formId)
    end
  end
  --register events
  f:RegisterEvent("UNIT_HEALTH")
  f:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
  f:RegisterEvent("UNIT_ENTERED_VEHICLE")
  f:RegisterEvent("UNIT_EXITED_VEHICLE")
  --event
  f:SetScript("OnEvent", function(...)
    local self, event = ...
    if event == "UNIT_HEALTH" then
      updateHealth(...)
    elseif event == "UPDATE_SHAPESHIFT_FORM" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
      f.updateAnimation(...)
    end
  end)
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
  local getPowerId = function()
    local powerId, powerString, altR, altG, altB = UnitPowerType(unit)
    local powerName = _G[powerString] or powerString
    local powerColor
    local color = PowerBarColor[powerString]
    if (color) then
      powerColor = {color.r, color.g, color.b}
    else
      if (not altR) then
        -- couldn't find a power token entry...default to indexing by power type or just mana if we don't have that either
        color = PowerBarColor[powerId] or PowerBarColor["MANA"]
        powerColor = {color.r, color.g, color.b}
      else
        powerColor = {altR, altG, altB}
      end
    end
    --print(powerId)
    --print(powerName)
    --print(unpack(powerColor))
    return powerId or 0
  end
  f.powerId = getPowerId()
  print("power: "..f.powerId)
  f.updateAnimation = function(...)
    self, event, arg1 = ...
    if (event == "UNIT_DISPLAYPOWER") and arg1 ~= unit then return end
    local powerId = getPowerId()
    if f.powerId ~= powerId then
      f.powerId = powerId
      print("updating power id to: "..f.powerId)
    end
  end
  --register events
  f:RegisterEvent("UNIT_POWER")
  f:RegisterEvent("UNIT_DISPLAYPOWER")
  --event
  f:SetScript("OnEvent", function(...)
    local self, event = ...
    if event == "UNIT_POWER" then
      updatePower(...)
    elseif event == "UNIT_DISPLAYPOWER" then
      f.updateAnimation(...)
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
function Pulsar:CreateUnitFrame(unit)
  local name = addon..unit:sub(1,1):upper()..unit:sub(2).."Frame"
  local f = CreateFrame("Button", name, UIParent, "SecureUnitButtonTemplate")
  f.unit = unit
  f:SetAttribute("unit", unit)
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
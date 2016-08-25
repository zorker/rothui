

-- rError: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Config
-----------------------------

local cfg = {
  redirectErrorsToCombatText = true,
}

-----------------------------
-- Blacklist
-----------------------------

local blacklist = {
  ["ERR_ABILITY_COOLDOWN"] = true,           -- Ability is not ready yet. (Ability)
  ["ERR_ITEM_COOLDOWN"] = true,
  ["ERR_BADATTACKPOS"] = true,
  ["ERR_OUT_OF_ENERGY"] = true,              -- Not enough energy. (Err)
  ["ERR_OUT_OF_RANGE"] = true,
  ["ERR_OUT_OF_RAGE"] = true,                -- Not enough rage.
  ["ERR_OUT_OF_FOCUS"] = true,                -- Not enough focus
  ["ERR_NO_ATTACK_TARGET"] = true,           -- There is nothing to attack.
  ["SPELL_FAILED_MOVING"] = true,
  ["SPELL_FAILED_AFFECTING_COMBAT"] = true,
  ["ERR_NOT_IN_COMBAT"] = true,
  ["SPELL_FAILED_UNIT_NOT_INFRONT"] = true,
  ["ERR_BADATTACKFACING"] = true,
  ["SPELL_FAILED_TOO_CLOSE"] = true,
  ["ERR_INVALID_ATTACK_TARGET"] = true,      -- You cannot attack that target.
  ["ERR_SPELL_COOLDOWN"] = true,             -- Spell is not ready yet. (Spell)
  ["SPELL_FAILED_NO_COMBO_POINTS"] = true,   -- That ability requires combo points.
  ["SPELL_FAILED_TARGETS_DEAD"] = true,      -- Your target is dead.
  ["SPELL_FAILED_SPELL_IN_PROGRESS"] = true, -- Another action is in progress. (Spell)
  ["SPELL_FAILED_TARGET_AURASTATE"] = true,  -- You can't do that yet. (TargetAura)
  ["SPELL_FAILED_CASTER_AURASTATE"] = true,  -- You can't do that yet. (CasterAura)
  ["SPELL_FAILED_NO_ENDURANCE"] = true,      -- Not enough endurance
  ["SPELL_FAILED_BAD_TARGETS"] = true,       -- Invalid target
  ["SPELL_FAILED_NOT_MOUNTED"] = true,       -- You are mounted
  ["SPELL_FAILED_NOT_ON_TAXI"] = true,       -- You are in flight
}

-----------------------------
-- Functions
-----------------------------

local function OnUIErrorMessage(self, event, messageType, message)
  local errorName, soundKitID, voiceID = GetGameMessageInfo(messageType)
  --print(errorName, message, messageType)
  if blacklist[errorName] then return end
  if CombatText_AddMessage and cfg.redirectErrorsToCombatText then
    CombatText_AddMessage(message, COMBAT_TEXT_SCROLL_FUNCTION, 1, 0, 0, "sticky", nil)
  else
    UIErrorsFrame:AddMessage(message, 1, .1, .1)
  end
end

-----------------------------
-- Init
-----------------------------

--disable default error message
UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")

--event handler
local eventHandler = CreateFrame("Frame")
eventHandler:SetScript("OnEvent", OnUIErrorMessage)
eventHandler:RegisterEvent("UI_ERROR_MESSAGE")
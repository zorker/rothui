local A, L = ...

---------------------------------------------------------------------
-- LoadModuleSpellAlert()
---------------------------------------------------------------------

local function LoadModuleSpellAlert()

  ---------------------------------------------------------------------
  -- PlaySpellAlertSound(unit)
  ---------------------------------------------------------------------

  local function PlaySpellAlertSound(unit)
    if unit ~= "focus" then return end
    PlaySoundFile(1129273) --high bell
  end

  ---------------------------------------------------------------------
  -- RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
  ---------------------------------------------------------------------

  L.eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
  L.eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
  L.eventFrame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_START")
  L.eventFrame:HookScript("OnEvent", function(_, event, ...)
    if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" or event ==  "UNIT_SPELLCAST_EMPOWER_START" then
      PlaySpellAlertSound(...)
    end
  end)

end

L.F.LoadModuleSpellAlert = LoadModuleSpellAlert
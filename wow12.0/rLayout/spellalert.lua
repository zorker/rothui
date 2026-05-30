local A, L = ...

--PlaySpellAlertSound
local function PlaySpellAlertSound(unit)
  if unit ~= "focus" then return end
  PlaySoundFile(1129273) --high bell
end

L.F.PlaySpellAlertSound = PlaySpellAlertSound
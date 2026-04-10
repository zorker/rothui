local A, L = ...

local strfind, FocusFrameSpellBar = strfind, FocusFrameSpellBar

--PlaySpellAlertSound
local function PlaySpellAlertSound(unit, spellID, isChanneled)
  --PlaySoundFile(7466102) --riff
  --PlaySoundFile(7466945) --bell
  PlaySoundFile(1129273) --high bell
end

L.F.PlaySpellAlertSound = PlaySpellAlertSound
local A, L = ...

--PlaySpellAlertSound
local function PlaySpellAlertSound(unit, spellID, isChanneled)
  local spellName, notInterruptible, _;
  if isChanneled then
    spellName, _, _, _, _, _, notInterruptible = UnitChannelInfo(unit);
  else
    spellName, _, _, _, _, _, _, notInterruptible = UnitCastingInfo(unit);
  end
  local isInterruptible = (notInterruptible == false);
  if isInterruptible then
    PlaySoundFile(7466102)
  end
end

L.F.PlaySpellAlertSound = PlaySpellAlertSound
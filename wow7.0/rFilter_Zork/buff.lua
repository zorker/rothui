
-- rFilter_Zork: buff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Buff Config
-----------------------------

if L.C.playerName == "Zörk" then
  local button = rFilter:CreateBuff(132404,"player",36,{"CENTER"},"[spec:3,combat]show;hide",{0.2,1},true,nil) --SB
  if button then
    button.extravalue:Hide()
    table.insert(L.buffs,button)
  end
  local button = rFilter:CreateBuff(190456,"player",36,{"CENTER"},"[spec:3]show;hide",{0,1},true,nil) --IP
  if button then table.insert(L.buffs,button) end
  local button = rFilter:CreateBuff(184362,"player",36,{"CENTER"},"[spec:2,combat]show;hide",{0.2,1},true,nil) --enrage
  if button then table.insert(L.buffs,button) end
  local sephuzButton = rFilter:CreateBuff(208052,"player",36,{"CENTER"},"[combat]show;hide",{0.2,1},true,nil) --enrage
  --add 30sec alert for the ring proc
  if sephuzButton then
    sephuzButton.extravalue:Hide()
    table.insert(L.buffs,sephuzButton)
    local function Alert()
      RaidNotice_AddMessage(RaidWarningFrame, "|T"..sephuzButton.settings.spellIcon..":20:20:0:0|t Sephuz Ring Ready!", ChatTypeInfo["RAID_WARNING"])
      print("|T"..sephuzButton.settings.spellIcon..":14:14:0:0|t Sephuz Ring Ready!")
      PlaySoundFile("Sound\\Interface\\RaidWarning.ogg")
    end
    local function OnAlpha(button)
      if button.state == 2 then
        C_Timer.After(30, Alert)
      end
    end
    hooksecurefunc(sephuzButton,"SetAlpha",OnAlpha)
  end
end


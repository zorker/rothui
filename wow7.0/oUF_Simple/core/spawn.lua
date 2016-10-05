
-- oUF_Simple: core/spawn
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF

-----------------------------
-- Register Styles
-----------------------------

--spawn player
if L.F.CreatePlayerStyle then
  oUF:RegisterStyle(L.C.units.player.styleName, L.F.CreatePlayerStyle)
  oUF:SetActiveStyle(L.C.units.player.styleName)
  oUF:Spawn("player", L.C.units.player.frameName)
end

--spawn target
if L.F.CreateTargetStyle then
  oUF:RegisterStyle(L.C.units.target.styleName, L.F.CreateTargetStyle)
  oUF:SetActiveStyle(L.C.units.target.styleName)
  oUF:Spawn("target", L.C.units.target.frameName)
end

--spawn targettarget
if L.F.CreateTargetTargetStyle then
  oUF:RegisterStyle(L.C.units.targettarget.styleName, L.F.CreateTargetTargetStyle)
  oUF:SetActiveStyle(L.C.units.targettarget.styleName)
  oUF:Spawn("targettarget", L.C.units.targettarget.frameName)
end

--spawn pet
if L.F.CreatePetStyle then
  oUF:RegisterStyle(L.C.units.pet.styleName, L.F.CreatePetStyle)
  oUF:SetActiveStyle(L.C.units.pet.styleName)
  oUF:Spawn("pet", L.C.units.pet.frameName)
end

--spawn focus
if L.F.CreateFocusStyle then
  oUF:RegisterStyle(L.C.units.focus.styleName, L.F.CreateFocusStyle)
  oUF:SetActiveStyle(L.C.units.focus.styleName)
  oUF:Spawn("focus", L.C.units.focus.frameName)
end

--spawn party
if L.F.CreatePartyStyle then
  oUF:RegisterStyle(L.C.units.party.styleName, L.F.CreatePartyStyle)
  oUF:SetActiveStyle(L.C.units.party.styleName)
  oUF:SpawnHeader(
    L.C.units.party.frameName,
    L.C.units.party.setup.template,
    L.C.units.party.setup.visibility,
    "showPlayer", L.C.units.party.setup.showPlayer,
    "showSolo",   L.C.units.party.setup.showSolo,
    "showParty",  L.C.units.party.setup.showParty,
    "showRaid",   L.C.units.party.setup.showRaid,
    "point",      L.C.units.party.setup.point,
    "xOffset",    L.C.units.party.setup.xOffset,
    "yOffset",    L.C.units.party.setup.yOffset,
    "oUF-initialConfigFunction", ([[
      self:SetWidth(%d)
      self:SetHeight(%d)
      self:SetScale(%f)
    ]]):format(L.C.units.party.size[1], L.C.units.party.size[2], L.C.units.party.scale)
  ):SetPoint(unpack(L.C.units.party.point))
end

--spawn nameplates
if L.F.CreateNamePlateStyle then
  oUF:RegisterStyle(L.C.units.nameplates.styleName,L.F.CreateNamePlateStyle)
  oUF:SpawnNamePlates(L.C.units.nameplates.styleName, L.C.units.nameplates.framePrefix)
end
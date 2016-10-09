
-- oUF_Simple: core/spawn
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...
local oUF = L.oUF

-----------------------------
-- Register Style and Spawn Units
-----------------------------

--spawn player
if L.F.CreatePlayerStyle then
  oUF:RegisterStyle(A.."Player", L.F.CreatePlayerStyle)
  oUF:SetActiveStyle(A.."Player")
  oUF:Spawn("player", A.."Player")
end

--spawn target
if L.F.CreateTargetStyle then
  oUF:RegisterStyle(A.."Target", L.F.CreateTargetStyle)
  oUF:SetActiveStyle(A.."Target")
  oUF:Spawn("target", A.."Target")
end

--spawn targettarget
if L.F.CreateTargetTargetStyle then
  oUF:RegisterStyle(A.."TargetTarget", L.F.CreateTargetTargetStyle)
  oUF:SetActiveStyle(A.."TargetTarget")
  oUF:Spawn("targettarget", A.."TargetTarget")
end

--spawn pet
if L.F.CreatePetStyle then
  oUF:RegisterStyle(A.."Pet", L.F.CreatePetStyle)
  oUF:SetActiveStyle(A.."Pet")
  oUF:Spawn("pet", A.."Pet")
end

--spawn focus
if L.F.CreateFocusStyle then
  oUF:RegisterStyle(A.."Focus", L.F.CreateFocusStyle)
  oUF:SetActiveStyle(A.."Focus")
  oUF:Spawn("focus", A.."Focus")
end

--spawn party
if L.F.CreatePartyStyle then
  oUF:RegisterStyle(A.."Party", L.F.CreatePartyStyle)
  oUF:SetActiveStyle(A.."Party")
  oUF:SpawnHeader(
    A.."PartyHeader",
    L.C.party.setup.template,
    L.C.party.setup.visibility,
    "showPlayer", L.C.party.setup.showPlayer,
    "showSolo",   L.C.party.setup.showSolo,
    "showParty",  L.C.party.setup.showParty,
    "showRaid",   L.C.party.setup.showRaid,
    "point",      L.C.party.setup.point,
    "xOffset",    L.C.party.setup.xOffset,
    "yOffset",    L.C.party.setup.yOffset,
    "oUF-initialConfigFunction", ([[
      self:SetWidth(%d)
      self:SetHeight(%d)
      self:SetScale(%f)
    ]]):format(L.C.party.size[1], L.C.party.size[2], L.C.party.scale)
  ):SetPoint(unpack(L.C.party.point))
end

--spawn boss frames
if L.F.CreateBossStyle then
  oUF:RegisterStyle(A.."Boss", L.F.CreateBossStyle)
  oUF:SetActiveStyle(A.."Boss")
  local boss = {}
  for i = 1, MAX_BOSS_FRAMES do
    boss[i] = oUF:Spawn("boss"..i, A.."Boss"..i)
    if (i == 1) then
      boss[i]:SetPoint(unpack(L.C.boss.point))
    else
      boss[i]:SetPoint(L.C.boss.setup.point, boss[i-1], L.C.boss.setup.relativePoint, L.C.boss.setup.xOffset, L.C.boss.setup.yOffset)
    end
  end
end

--spawn nameplates
if L.F.CreateNamePlateStyle then
  oUF:RegisterStyle(A.."Nameplate",L.F.CreateNamePlateStyle)
  oUF:SpawnNamePlates(A.."Nameplate", A, L.C.NamePlateCallback or L.F.NamePlateCallback)
end
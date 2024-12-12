-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

L.orbTemplates = {}

L.mediaFolder = "Interface\\AddOns\\rOrbTemplate\\media\\"

local function AddTemplateToList(templateName)
  table.insert(L.orbTemplates, templateName)
end

local function SortByTableIndexAsc(a, b)
  return a < b
end

AddTemplateToList("magenta-matrix")
AddTemplateToList("deep-purple-starly")
AddTemplateToList("art-chtun-eye")
AddTemplateToList("magenta-swirly")
AddTemplateToList("art-azeroth")
AddTemplateToList("deep-purple-magic")
AddTemplateToList("sandy-blitz")
AddTemplateToList("blue-aqua-swirly")
AddTemplateToList("golden-marble")
AddTemplateToList("art-wierd-eye")
AddTemplateToList("pink-portal")
AddTemplateToList("green-portal")
AddTemplateToList("blue-portal")
AddTemplateToList("red-portal")
AddTemplateToList("purple-portal")
AddTemplateToList("red-slob")
AddTemplateToList("green-buzz")
AddTemplateToList("purple-buzz")
AddTemplateToList("blue-buzz")
AddTemplateToList("white-cloud")
AddTemplateToList("blue-magic-swirly")
AddTemplateToList("green-beam")
AddTemplateToList("white-heal")
AddTemplateToList("red-heal")
AddTemplateToList("white-pearl")
AddTemplateToList("white-swirly")
AddTemplateToList("purple-warlock-portal")
AddTemplateToList("purple-hole")
AddTemplateToList("blue-swirly")
AddTemplateToList("sand-storm")
AddTemplateToList("art-el-machina")
AddTemplateToList("red-blue-knot")
AddTemplateToList("blue-ring-disco")
AddTemplateToList("art-dwarf-machina")
AddTemplateToList("purple-storm")
AddTemplateToList("white-boulder")
AddTemplateToList("white-snowstorm")
AddTemplateToList("fire-dot")
AddTemplateToList("purple-discoball")
AddTemplateToList("white-tornado")
AddTemplateToList("white-snowglobe")
AddTemplateToList("white-zebra")
AddTemplateToList("white-spark")
AddTemplateToList("blue-aqua-spark")
AddTemplateToList("purple-growup")
AddTemplateToList("blue-aqua-sink")
AddTemplateToList("pink-portal-swirl")
AddTemplateToList("purple-earth")
AddTemplateToList("golden-earth")
AddTemplateToList("green-earth")
AddTemplateToList("pink-earth")
AddTemplateToList("golden-tornado")
AddTemplateToList("blue-electric")
AddTemplateToList("blue-splash")
AddTemplateToList("art-elvish-object")
AddTemplateToList("blue-magic-tornado")

--501 ones are ones which behave wierd when scaling is applied

--AddTemplateToList("501-red-planet")
--AddTemplateToList("501-blue-planet")
--AddTemplateToList("501-purple-wobbler")
--AddTemplateToList("501-red-wobbler")
--AddTemplateToList("501-red-orange-wobbler")
--AddTemplateToList("501-snow-flake")


table.sort(L.orbTemplates, SortByTableIndexAsc)
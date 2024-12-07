-------------------------------------------------
-- Variables
-------------------------------------------------

local A, L = ...

--print(A, 'orb.lua file init')

-------------------------------------------------
-- Function
-------------------------------------------------

local function CreateOrb()
  print("CreateOrb")
  local orb = CreateFrame("Frame", "rOrbPlayerHealth", UIParent, "OrbTemplate")
  local healthBar = orb.FillingStatusBar
  local clip = orb.ClipFrame
  local modelContainer = clip.ModelContainer
  local model = modelContainer.ModelFrame
  model.__parent = modelContainer

  orb:SetPoint("CENTER",-300,0)
  --orb:SetScale(.75)

  model.orbSettings = {}
  model.orbSettings.panValueX = 80
  model.orbSettings.panValueY = 80
  model.orbSettings.panValueZ = 80
  model.orbSettings.camDistanceScale = 0.5
  model:SetDisplayInfo(113764)

  healthBar:SetValue(.75)
end

-------------------------------------------------
-- Load
-------------------------------------------------

rLib:RegisterCallback("PLAYER_LOGIN", CreateOrb)
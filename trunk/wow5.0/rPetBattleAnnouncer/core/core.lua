
  ---------------------------------------------
  -- CONFIG
  ---------------------------------------------

  local cfg = {}

  cfg.scale = 1

  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------

local qualityColorRGB = {
  [1] = {130/255,130/255,130/255}, --gray, poor
  [2] = {255/255,255/255,255/255}, --white, common
  [3] = {0/255,153/255,0/255}, --green, uncommon
  [4] = {0/255,153/255,255/255}, --blue, rare
  [5] = {204/255,51/255,204/255}, --purple, epic
  [6] = {255/255,102/255,0/255}, --orange, legendary
}

local qualityText = {
  [1] = "Poor", --gray, poor
  [2] = "Common", --white, common
  [3] = "Uncommon", --green, uncommon
  [4] = "Rare", --blue, rare
  [5] = "Epic", --purple, epic
  [6] = "Legend", --orange, legendary
}

local unpack = unpack

--calc hex color from rgb
local function RGBPercToHex(color)
  local r,g,b = unpack(color)
  r = r <= 1 and r >= 0 and r or 0
  g = g <= 1 and g >= 0 and g or 0
  b = b <= 1 and b >= 0 and b or 0
  return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

--number format func
local numFormat = function(v)
  if v > 1E10 then
    return (floor(v/1E9)).."b"
  elseif v > 1E9 then
    return (floor((v/1E9)*10)/10).."b"
  elseif v > 1E7 then
    return (floor(v/1E6)).."m"
  elseif v > 1E6 then
    return (floor((v/1E6)*10)/10).."m"
  elseif v > 1E4 then
    return (floor(v/1E3)).."k"
  elseif v > 1E3 then
    return (floor((v/1E3)*10)/10).."k"
  else
    return v
  end
end

--the canvas frame
local canvas = CreateFrame("Frame", "rPBA_CanvasFrame", UIParent)
canvas:SetFrameStrata("FULLSCREEN")
canvas:SetAllPoints(UIParent)
canvas:SetAlpha(0)
local t = canvas:CreateTexture(nil, "BACKGROUND",nil,-8)
t:SetAllPoints(canvas)
t:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\canvasBg")
canvas.bg = t
canvas:EnableMouse(true)

local ag1, ag2, a1, a2

--fade in anim
ag1 = canvas:CreateAnimationGroup()
a1 = ag1:CreateAnimation("Alpha")
a1:SetDuration(0.8)
a1:SetSmoothing("IN")
a1:SetChange(1)
canvas.ag1 = ag1
canvas.ag1.a1 = a1

--fade out anim
ag2 = canvas:CreateAnimationGroup()
a2 = ag2:CreateAnimation("Alpha")
a2:SetDuration(0.8)
a2:SetSmoothing("OUT")
a2:SetChange(-1)
canvas.ag2 = ag2
canvas.ag2.a2 = a2

canvas.ag1:SetScript("OnFinished", function(ag)
  canvas:SetAlpha(1)
end)

canvas.ag2:SetScript("OnFinished", function(ag)
  canvas:SetAlpha(0)
  canvas:Hide()
end)

canvas:Hide()

-- making frame scaling possible
local scaler = CreateFrame("Frame",nil,canvas)
scaler:SetSize(40,40)
scaler:SetPoint("CENTER",0,0)
scaler:SetScale(cfg.scale)

-- vs frame
local vs = CreateFrame("Frame",nil,scaler)
vs:SetSize(512,512)
vs:SetPoint("CENTER",0,0)
canvas.vs = vs
local t = vs:CreateTexture(nil, "BACKGROUND",nil,-8)
t:SetSize(512,512)
t:SetPoint("CENTER")
t:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\vs")
canvas.vs.bg = t

local fight = CreateFrame("FRAME",nil,scaler)
fight:SetSize(512*0.8,256*0.8)
fight:SetPoint("TOP",vs,"BOTTOM",0,60)
canvas.fight = fight
local t = fight:CreateTexture(nil, "BACKGROUND",nil,-6)
t:SetAllPoints(fight)
t:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\fight")
canvas.fight.bg = t

fight:EnableMouse(true)
fight:SetScript("OnMouseDown", function(...)
  --PlaySoundFile("Sound\\Creature\\BabyMurloc\\BabyMurlocB.wav")
  PlaySoundFile("Sound\\Creature\\BabyMurloc\\BabyMurlocA.wav")
  canvas.ag2:Play()
end)
fight:SetScript("OnEnter", function(...)
  PlaySound("igCreatureAggroSelect")
end)
fight:SetScript("OnLeave", function(...)
  PlaySound("INTERFACESOUND_LOSTTARGETUNIT")
end)

local exit = CreateFrame("Button",nil,scaler,"SecureActionButtonTemplate")
exit:SetSize(512*0.5,256*0.5)
exit:SetPoint("BOTTOM",vs,"TOP",0,-0)
canvas.exit = exit
local t = exit:CreateTexture(nil, "BACKGROUND",nil,-6)
t:SetAllPoints(exit)
t:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\exit")
canvas.exit.bg = t
exit:SetAttribute("type","macro")
exit:SetAttribute("macrotext","/run C_PetBattles.ForfeitGame()")
exit:EnableMouse(true)
exit:HookScript("OnMouseDown", function(...)
  PlaySoundFile("Sound\\Creature\\BabyMurloc\\BabyMurlocB.wav")
  canvas.ag2:Play()
end)
exit:SetScript("OnEnter", function(...)
  PlaySound("igCreatureAggroSelect")
end)
exit:SetScript("OnLeave", function(...)
  PlaySound("INTERFACESOUND_LOSTTARGETUNIT")
end)


local function loadModel(model,displayId)
  model:SetCamDistanceScale(1)
  model:SetPortraitZoom(0.95)
  model:SetPosition(0,0,0)
  model:ClearModel()
  model:SetModel("interface\\buttons\\talktomequestionmark.m2") --in case setdisplayinfo fails
  model:SetDisplayInfo(displayId)
  local test = model:GetModel()
  model.id = displayId
end

local function createPortraitFrame(name,type)
  local f = CreateFrame("Frame",name,scaler)
  f:SetSize(256,256)
  f:EnableMouse(true)
  f:SetScript("OnEnter", function(self)
    if not self.ownerId or not self.petIndex then return end
    if type == "player" then
      PetBattleUnitTooltip_Attach(PetBattlePrimaryUnitTooltip, "LEFT", self, "RIGHT", 0, 0)
    else
      PetBattleUnitTooltip_Attach(PetBattlePrimaryUnitTooltip, "RIGHT", self, "LEFT", 0, 0)
    end
    PetBattleUnitTooltip_UpdateForUnit(PetBattlePrimaryUnitTooltip, self.ownerId, self.petIndex)
    PetBattlePrimaryUnitTooltip:Show()
  end)
  f:SetScript("OnLeave", function(self)
    if(PetBattlePrimaryUnitTooltip:GetParent() == self) then
      PetBattlePrimaryUnitTooltip:Hide()
    end
  end)

  local helper = CreateFrame("Frame",nil,f)
  helper:SetPoint("CENTER")
  helper:SetSize(256,256)
  helper:SetScale(1.1) --help rescaling the textures but keep everything centered
  --background
  local bg = helper:CreateTexture(nil, "BACKGROUND",nil,-8)
  bg:SetSize(256,256)
  bg:SetPoint("CENTER")
  bg:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\raid_back")
  --modell
  local model = CreateFrame("PlayerModel",nil,helper)
  model:SetSize(142,142)
  model:SetPoint("CENTER")

  --gloss
  local gloss = CreateFrame("Frame",nil,model)
  gloss:SetSize(256,256)
  gloss:SetPoint("CENTER")
  --portrait border texture
  local border = gloss:CreateTexture(nil, "BACKGROUND",nil,-8)
  border:SetSize(256,256)
  border:SetPoint("CENTER")
  border:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\raid_border")
  --level bg texture
  local levelBg = gloss:CreateTexture(nil, "BACKGROUND",nil,-7)
  levelBg:SetSize(90,90)
  levelBg:SetPoint("BOTTOMLEFT",18,18)
  levelBg:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\combo_orb_bg")
  --level border texture
  local levelBorder = gloss:CreateTexture(nil, "BACKGROUND",nil,-6)
  levelBorder:SetAllPoints(levelBg)
  levelBorder:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\combo_orb_border")

  --pet power frame
  local petPowerFrame = CreateFrame("Frame",nil,gloss)
  petPowerFrame:SetSize(40,40)
  local powericon = petPowerFrame:CreateTexture(nil, "BACKGROUND",nil,-6)
  powericon:SetSize(30,30)
  powericon:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\sword")
  if type == "player" then
    petPowerFrame:SetPoint("LEFT", -10, 0)
    powericon:SetPoint("RIGHT")
  else
    petPowerFrame:SetPoint("RIGHT", 10, 0)
    powericon:SetPoint("LEFT")
  end
  --power fontstring
  local power = petPowerFrame:CreateFontString(nil, "BACKGROUND")
  power:SetFont("Interface\\AddOns\\rPetBattleAnnouncer\\media\\pokemon.ttf", 40, "THICKOUTLINE")
  if type == "player" then
    power:SetPoint("RIGHT", -40, -5)
    power:SetJustifyH("RIGHT")
  else
    power:SetPoint("LEFT", 40, -5)
    power:SetJustifyH("LEFT")
  end
  power:SetTextColor(1,0.3,0)

  --pet health frame
  local petHealthFrame = CreateFrame("Frame",nil,gloss)
  petHealthFrame:SetSize(40,40)
  local healthicon = petHealthFrame:CreateTexture(nil, "BACKGROUND",nil,-6)
  healthicon:SetSize(30,30)
  healthicon:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\heart")
  if type == "player" then
    petHealthFrame:SetPoint("LEFT", -10, 55)
    healthicon:SetPoint("RIGHT")
  else
    petHealthFrame:SetPoint("RIGHT", 10, 55)
    healthicon:SetPoint("LEFT")
  end
  --health fontstring
  local health = petHealthFrame:CreateFontString(nil, "BACKGROUND")
  health:SetFont("Interface\\AddOns\\rPetBattleAnnouncer\\media\\pokemon.ttf", 40, "THICKOUTLINE")
  if type == "player" then
    health:SetPoint("RIGHT", -40, -5)
    health:SetJustifyH("RIGHT")
  else
    health:SetPoint("LEFT", 40, -5)
    health:SetJustifyH("LEFT")
  end
  health:SetTextColor(0,0.7,0)

  --pet speed frame
  local petSpeedFrame = CreateFrame("Frame",nil,gloss)
  petSpeedFrame:SetSize(40,40)
  local speedicon = petSpeedFrame:CreateTexture(nil, "BACKGROUND",nil,-6)
  speedicon:SetSize(30,30)
  speedicon:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\speed")
  if type == "player" then
    petSpeedFrame:SetPoint("LEFT", -10, -55)
    speedicon:SetPoint("RIGHT")
  else
    petSpeedFrame:SetPoint("RIGHT", 10, -55)
    speedicon:SetPoint("LEFT")
  end
  --speed fontstring
  local speed = petSpeedFrame:CreateFontString(nil, "BACKGROUND")
  speed:SetFont("Interface\\AddOns\\rPetBattleAnnouncer\\media\\pokemon.ttf", 40, "THICKOUTLINE")
  if type == "player" then
    speed:SetPoint("RIGHT", -40, -5)
    speed:SetJustifyH("RIGHT")
  else
    speed:SetPoint("LEFT", 40, -5)
    speed:SetJustifyH("LEFT")
  end
  speed:SetTextColor(1,1,0)

  --pettype textures
  --local pettypeBg = gloss:CreateTexture(nil, "BACKGROUND",nil,-7)
  --pettypeBg:SetSize(90,90)
  --pettypeBg:SetPoint("BOTTOMRIGHT",-18,18)
  --pettypeBg:SetTexture("Interface\\AddOns\\rPetBattleAnnouncer\\media\\combo_orb_bg")
  local pettypeIcon = gloss:CreateTexture(nil, "BACKGROUND",nil,-6)
  pettypeIcon:SetSize(40,40)
  pettypeIcon:SetPoint("TOPLEFT",60,-60)
  pettypeIcon:SetTexture("Interface\\PetBattles\\PetIcon-Mechanical")
  pettypeIcon:SetDesaturated(true)
  pettypeIcon:SetAlpha(0.3)
  pettypeIcon:SetTexCoord(0.79687500,0.49218750,0.50390625,0.65625000)

  --level fontstring
  local level = gloss:CreateFontString(nil, "BACKGROUND")
  level:SetFont("Interface\\AddOns\\rPetBattleAnnouncer\\media\\pokemon.ttf", 20, "THICKOUTLINE")
  level:SetPoint("CENTER", levelBg, "CENTER", 2, -5)
  level:SetJustifyH("CENTER")
  --name fontstring
  local name = gloss:CreateFontString(nil, "BACKGROUND")
  name:SetFont("Interface\\AddOns\\rPetBattleAnnouncer\\media\\pokemon.ttf", 20, "THICKOUTLINE")
  name:SetPoint("TOP", 0, 0)
  name:SetPoint("LEFT", -40, 0)
  name:SetPoint("RIGHT", 40, 0)
  name:SetJustifyH("CENTER")

  local class = gloss:CreateFontString(nil, "BACKGROUND")
  class:SetFont("Interface\\AddOns\\rPetBattleAnnouncer\\media\\pokemon.ttf", 19, "THICKOUTLINE")
  class:SetPoint("TOP", name, "BOTTOM", 0, -5)
  class:SetPoint("LEFT", -40, 0)
  class:SetPoint("RIGHT", 40, 0)
  class:SetJustifyH("CENTER")
  class:SetText("Poor")

  local empty = gloss:CreateFontString(nil, "BACKGROUND")
  empty:SetFont("Interface\\AddOns\\rPetBattleAnnouncer\\media\\pokemon.ttf", 20, "THICKOUTLINE")
  empty:SetPoint("CENTER")
  empty:SetText("Empty\nslot")
  empty:SetAlpha(0.2)

  f.model = model
  f.gloss = gloss
  f.border = border
  f.name = name
  f.class = class
  f.empty = empty
  f.levelBg = levelBg
  f.levelBorder = levelBorder
  f.level = level
  f.health = health
  f.healthicon = healthicon
  f.power = power
  f.powericon = powericon
  f.speed = speed
  f.speedicon = speedicon
  f.typeicon = pettypeIcon
  f.bg = bg
  return f
end

--player pet frame 1
local ppf1 = createPortraitFrame("rPBA_PlayerPetFrame1","player")
ppf1:SetPoint("RIGHT",vs,"LEFT",-10,0)

--player pet frame 2
local ppf2 = createPortraitFrame("rPBA_PlayerPetFrame2","player")
ppf2:SetPoint("BOTTOM",ppf1,"TOP",0,10)

--player pet frame 3
local ppf3 = createPortraitFrame("rPBA_PlayerPetFrame3","player")
ppf3:SetPoint("TOP",ppf1,"BOTTOM",0,-10)

--enemy pet frame 1
local epf1 = createPortraitFrame("rPBA_EnemyPetFrame1","enemy")
epf1:SetPoint("LEFT",vs,"RIGHT",10,0)

--enemy pet frame 2
local epf2 = createPortraitFrame("rPBA_EnemyPetFrame2","enemy")
epf2:SetPoint("BOTTOM",epf1,"TOP",0,10)

--enemy pet frame 3
local epf3 = createPortraitFrame("rPBA_EnemyPetFrame3","enemy")
epf3:SetPoint("TOP",epf1,"BOTTOM",0,-10)

local function hidePetPortraitFrames()
  ppf1:Hide()
  ppf2:Hide()
  ppf3:Hide()
  epf1:Hide()
  epf2:Hide()
  epf3:Hide()
end

local data = {
  name = nil,
  species = nil,
  petTypeId = nil,
  petTypeSuffix = nil,
  petTypeName = nil,
  petTypeTexture = nil,
  quality = nil,
  colorRGB = nil,
  colorHEX = nil,
  displayId = nil,
  health = nil,
  power = nil,
  speed = nil,
  icon = nil,
  level = nil,
}

local function fillData(ownerId, i)
  local name, species = C_PetBattles.GetName(ownerId, i)
  data["name"]        = name
  data["species"]     = species
  data["petTypeId"]   = C_PetBattles.GetPetType(ownerId, i)
  data["petTypeSuffix"] = PET_TYPE_SUFFIX[data["petTypeId"]]
  data["petTypeName"] = _G["BATTLE_PET_NAME_"..data["petTypeId"]]
  data["petTypeTexture"] = "Interface\\PetBattles\\PetIcon-"..data["petTypeSuffix"]
  data["quality"]     = C_PetBattles.GetBreedQuality(ownerId, i)
  data["colorRGB"]    = qualityColorRGB[data["quality"]]
  data["colorHEX"]    = RGBPercToHex(data["colorRGB"])
  data["displayId"]   = C_PetBattles.GetDisplayID(ownerId, i)
  data["health"]      = C_PetBattles.GetHealth(ownerId, i)
  data["power"]       = C_PetBattles.GetPower(ownerId, i)
  data["speed"]       = C_PetBattles.GetSpeed(ownerId, i)
  data["icon"]        = C_PetBattles.GetIcon(ownerId, i)
  data["level"]       = C_PetBattles.GetLevel(ownerId, i)
end

local function loadEmptyPetPortraitFrame(frame)
    frame.bg:SetVertexColor(0.6,0.6,0.6)
    frame.border:SetVertexColor(0.6,0.6,0.6)
    frame.name:SetText("")
    frame.class:SetText("")
    frame.health:SetText("")
    frame.power:SetText("")
    frame.speed:SetText("")
    frame.empty:Show()
    frame.healthicon:Hide()
    frame.powericon:Hide()
    frame.speedicon:Hide()
    frame.level:SetText("")
    frame.typeicon:SetTexture("")
    frame.levelBorder:SetVertexColor(0.6,0.6,0.6)
    frame.levelBg:SetVertexColor(0.6,0.6,0.6)
    frame.model:ClearModel()
    frame.ownerId = nil
    frame.petIndex = nil
end

local function loadEmptyPetPortraitFrames()
  loadEmptyPetPortraitFrame(ppf1)
  loadEmptyPetPortraitFrame(ppf2)
  loadEmptyPetPortraitFrame(ppf3)
  loadEmptyPetPortraitFrame(epf1)
  loadEmptyPetPortraitFrame(epf2)
  loadEmptyPetPortraitFrame(epf3)
end

local function getPetData(prefix,ownerId)
  local max = C_PetBattles.GetNumPets(ownerId)
  for i = 1, max do
    --fill the data table
    fillData(ownerId, i)
    --apply data to the portrait frame
    local frame = _G[prefix..i]
    frame.ownerId = ownerId
    frame.petIndex = i
    frame.bg:SetVertexColor(unpack(data["colorRGB"]))
    frame.border:SetVertexColor(unpack(data["colorRGB"]))
    --frame.name:SetText(data["name"].."\n|cffffffff"..data["petTypeName"]..","..qualityText[data["quality"]].."|r")
    --frame.name:SetText(data["name"].."\n|cffffffff("..qualityText[data["quality"]]..")|r")
    frame.name:SetText(data["name"])
    frame.class:SetText(data["petTypeName"]..", |cff"..RGBPercToHex(data["colorRGB"])..qualityText[data["quality"]].."|r")
    frame.name:SetTextColor(unpack(data["colorRGB"]))
    --frame.health:SetText(numFormat(data["health"] or 0).."\n|cff99cc99Life|r")
    frame.typeicon:SetTexture(data["petTypeTexture"])
    frame.typeicon:SetDesaturated(true)
    frame.health:SetText(numFormat(data["health"] or 0))
    frame.power:SetText(numFormat(data["power"] or 0))
    frame.speed:SetText(numFormat(data["speed"] or 0))
    frame.empty:Hide()
    frame.healthicon:Show()
    frame.powericon:Show()
    frame.speedicon:Show()
    frame.level:SetText("|cffffcc00"..data["level"].."|r")
    frame.levelBorder:SetVertexColor(unpack(data["colorRGB"]))
    frame.levelBg:SetVertexColor(unpack(data["colorRGB"]))
    frame.model:Show()
    loadModel(frame.model,data["displayId"])
    frame:Show()
  end
end

local function initPetBattle()
  canvas:Show()
  PlaySoundFile("Interface\\AddOns\\rPetBattleAnnouncer\\media\\CAPlogo.mp3")
  canvas.ag1:Play()
  --hidePetPortraitFrames() --hide all frames in case the new fight has fewer pets
  loadEmptyPetPortraitFrames() --hide all frames in case the new fight has fewer pets
  getPetData("rPBA_PlayerPetFrame",1)
  getPetData("rPBA_EnemyPetFrame",2)
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", initPetBattle)
frame:RegisterEvent("PET_BATTLE_OPENING_START")
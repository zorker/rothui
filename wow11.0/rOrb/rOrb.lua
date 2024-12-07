-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

local orbList = {}

local mediaFolder = "Interface\\AddOns\\rOrb\\media\\"

table.insert(orbList, {
  statusBarTexture = mediaFolder.."orb_filling16",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.8, 0, .8, 1},
  glowColor = {0, 1, 0, 0}, --for low hp or debuffs etc
  modelOpacity = 1,
  point = {"CENTER", -300, 0},
  scale = .8,
  displayInfoID = 113764,
  panAdjustY = 145,
  camScale = 1.2,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
})

table.insert(orbList, {
  statusBarTexture = mediaFolder.."orb_filling16",
  statusBarColor = {.6, 0.3, 0, 1},
  sparkColor = {.6, .3, 0, 1},
  glowColor = {0, 1, 0, 0}, --for low hp or debuffs etc
  modelOpacity = 1,
  point = {"CENTER", 300, 0},
  scale = .8,
  displayInfoID = 94285,
  panAdjustY = 150,
  camScale = 1.2,
  posAdjustX = 0,
  posAdjustY = 0,
  posAdjustZ = 0
})

table.insert(orbList, {
  statusBarTexture = mediaFolder.."orb_filling19",
  statusBarColor = {.6, 0, .6, 1},
  sparkColor = {.8, 0, .8, 1},
  glowColor = {0, 1, 0, 0}, --for low hp or debuffs etc
  modelOpacity = 1,
  point = {"CENTER", 0, 0},
  scale = .8,
  displayInfoID = 88991,
  panAdjustY = 19,
  camScale = 0.055,
  posAdjustX = 0.1,
  posAdjustY = 0,
  posAdjustZ = -0.1
})

--cool displainfo list for the factory

--113764
--94285
--88991
--65947
--83176
--82009
--81399
--81327
--81077
--80318
--76935
--75294
--75298
--74840
--69879
--66808
--66092
--66202
--64697
--64562
--60225
--58948
--56632
--48109
--48254
--47882
--44652
--42938
--39581
--39316
--34404
--33853
--32368
--29286
--29074
--28460
--27393
--18877
--100018
--93977
--91994
--38699
--120816
--118264
--109622
--108191
--108172
--107088
--106201
--101968
--101672
--101272
--100007
--98573
--97296
--95410
--95935
--92626
--92612
--92613
--92614
--90499
--89106
--84936
--70769
--57012
--56959
--55752
--48106

-------------------------------------------------
-- Function
-------------------------------------------------

local function OnDragStart(self, button)
  self:StartMoving()
end

local function OnDragStop(self)
  self:StopMovingOrSizing()
end

local function EnableDrag(self)
  self:RegisterForDrag("LeftButton")
  self:SetScript("OnDragStart", OnDragStart)
  self:SetScript("OnDragStop", OnDragStop)
  self:EnableMouse(true)
  self:SetClampedToScreen(true)
  self:SetMovable(true)
end

local function CreateSliderWithEditbox(orb, name, minValue, maxValue, curValue)
  local slider = CreateFrame("Slider", name .. "Slider", orb, "OptionsSliderTemplate")
  local editbox = CreateFrame("EditBox", "$parentEditBox", slider, "InputBoxTemplate")
  slider.__orb = orb
  slider:SetMinMaxValues(minValue, maxValue)
  slider:SetValue(curValue)
  slider:SetValueStep(1)
  slider.text = _G[slider:GetName() .. "Text"]
  editbox:SetSize(30, 30)
  editbox:ClearAllPoints()
  editbox:SetPoint("LEFT", slider, "RIGHT", 15, 0)
  editbox:SetText(slider:GetValue())
  editbox:SetAutoFocus(false)
  editbox.slider = slider
  slider.editbox = editbox
  return slider
end

local function CreateOrb(cfg)

  local orb = CreateFrame("Frame", "rOrbPlayerHealth", UIParent, "OrbTemplate")
  local healthBar = orb.FillingStatusBar
  local model = orb.ModelFrame
  local spark = orb.OverlayFrame.SparkTexture
  local glow = orb.OverlayFrame.GlowTexture

  healthBar:SetStatusBarTexture(cfg.statusBarTexture)
  healthBar:SetStatusBarColor(unpack(cfg.statusBarColor))
  spark:SetVertexColor(unpack(cfg.sparkColor))
  glow:SetVertexColor(unpack(cfg.glowColor))
  model:SetAlpha(cfg.modelOpacity)
  orb:SetPoint(unpack(cfg.point))
  orb:SetScale(cfg.scale)

  -- displayInfoID, panAdjustY, camScale, posAdjustX, posAdjustY, posAdjustZ
  model:CreateOrbModel(cfg.displayInfoID, cfg.panAdjustY, cfg.camScale, cfg.posAdjustX, cfg.posAdjustY, cfg.posAdjustZ)

  EnableDrag(orb)

  local healthSlider = CreateSliderWithEditbox(orb, "OrbHealthValue", 0, 100, 100)
  healthSlider:ClearAllPoints()
  healthSlider:SetPoint("TOP", orb, "BOTTOM", 0, -30)
  healthSlider.text:SetText("Health")
  healthSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value + 0.5)
    self.editbox:SetText(value)
    self.__orb.FillingStatusBar:SetValue(value / 100)
  end)
  healthSlider.editbox:SetScript("OnEnterPressed", function(self)
    self:GetParent():SetValue(self:GetText())
    self:ClearFocus()
  end)

end

--OrbFactory
local function OrbFactory()
  for i, cfg in ipairs(orbList) do
    CreateOrb(cfg)
  end
end

-------------------------------------------------
-- Load
-------------------------------------------------

rLib:RegisterCallback("PLAYER_LOGIN", OrbFactory)

-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

-------------------------------------------------
-- CreateOrb
-------------------------------------------------

local function CreateOrbByPresetTemplateName()

  local orb = CreateFrame("Frame", "rOrbTemplateViewer", UIParent, "OrbTemplate")
  orb:SetPoint("CENTER", -200, 100)
  orb:SetScale(0.8)

  orb:SetOrbTemplate("art-azeroth")

  orb:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" then
      return
    end
    if not L.canvas.isCanvas then
      L.canvas:Init()
    end
    L.canvas:Enable()
  end)

  L.F:EnableDrag(orb)

  orb:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GameTooltip:AddLine(self:GetName(), 1, 0.5, 0, 1, 1, 1)
    GameTooltip:AddLine("Left click to open the orb canvas and show all orb models.", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:AddLine("Orb-Template: " .. self.templateName)
    GameTooltip:AddLine("Drag me around with right mouse.")
    GameTooltip:Show()
  end)
  orb:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  return orb

end

local function CreateOrbByOwnConfig()
  --showing how to manually set up a config to spawn any model in the orb
  --Z = Y-axis in UI
  --Y = X-axis in UI
  --X = 3D-axis
  local myOrbTemplateConfig = {
    statusBarTexture = "Interface\\AddOns\\rOrbTemplate\\media\\orb_filling16",
    statusBarColor = {1, 1, 1, 1},
    sparkColor = {0.8, 1, 0.9, 1},
    --glowColor = {0, 1, 0, 1},
    --lowHealthColor = {1, 0, 0, 1},
    modelOpacity = 1,
    displayInfoID = 44652,
    camScale = 1,
    --posAdjustX = 0,
    posAdjustY = -0.03,
    --posAdjustZ = 0,
    --panAdjustX = 0,
    --panAdjustY = 0,
    --panAdjustZ = 0,
  }

  local orb = CreateFrame("Frame", "rOrbTemplateViewer2", UIParent, "OrbTemplate")
  orb:SetPoint("LEFT", rOrbTemplateViewer, "RIGHT", 100, 0)
  orb:SetScale(0.7)
  orb.FillingStatusBar:SetValue(0.75)

  orb:SetOrbTemplate("myOwnTemplateName", myOrbTemplateConfig)

  orb:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 5)
    GameTooltip:AddLine(self:GetName(), 1, 0.5, 0, 1, 1, 1)
    GameTooltip:AddLine("This orb was created not by using a preset template name but by using a config table.")
    GameTooltip:AddLine("If you know the model DisplayInfoID and the pos/pan vector-data you can load any model in the orb.")
    GameTooltip:Show()
  end)
  orb:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  return orb

end

-------------------------------------------------
-- Load
-------------------------------------------------

local orb = CreateOrbByPresetTemplateName()
local orb2 = CreateOrbByOwnConfig()

local function ResetOrbModel()
  orb.ModelFrame:ResetOrbModel()
  orb2.ModelFrame:ResetOrbModel()
end

rLib:RegisterCallback("PLAYER_LOGIN", ResetOrbModel)

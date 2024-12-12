-------------------------------------------------
-- Variables
-------------------------------------------------
local A, L = ...

-------------------------------------------------
-- CreateOrb
-------------------------------------------------

local function CreateOrb(templateName)

  local orb = CreateFrame("Frame", "rOrbPlayerHealth", UIParent, "OrbTemplate")
  orb:SetOrbTemplate(templateName)
  orb:SetPoint("CENTER", 0, 100)
  orb:SetScale(1)

  L.F:EnableDrag(orb)

  local canvasButton = L.F:CreateButton(orb, A .. "CanvasOpenButton", "Open Canvas")
  canvasButton:SetPoint("TOP", orb, "BOTTOM", 0, -30)
  canvasButton:SetScript("OnClick", function(self)
    if not L.canvas.isCanvas then
      L.canvas:Init()
    end
    L.canvas:Enable()
  end)
  canvasButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 0, 5)
    GameTooltip:AddLine("Open canvas to view all orb templates.")
    GameTooltip:Show()
  end)
  canvasButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
  end)

  return orb

end

-------------------------------------------------
-- Load
-------------------------------------------------

local orb = CreateOrb(L.orbTemplates[1])

local function ResetOrbModel()
  orb.ModelFrame:ResetOrbModel()
end

rLib:RegisterCallback("PLAYER_LOGIN", ResetOrbModel)

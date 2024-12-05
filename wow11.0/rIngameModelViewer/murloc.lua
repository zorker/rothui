-- rIngameModelViewer - murloc
-- zork 2024
-----------------------------
-- Variables
-----------------------------
local A, L = ...

local GT = GameTooltip
local iconDisplayInfoID = 21723 -- murloc costume

L.murloc = CreateFrame("PlayerModel", L.name .. "MurlocButton", UIParent)

-------------------------------------
-- Functions
-------------------------------------

-- murloc OnMouseDown func
L.murloc:SetScript("OnMouseDown", function(self, button)
  if button == "RightButton" then
    return
  end
  if button == "Button5" then
    L.F:BuildModelList(1)
    return
  end
  -- on first call create the canvas
  if not L.canvas.isCanvas then
    L.canvas:Init()
  end
  if button == "Button4" then
    L.C.canvasMode = 'displayIds'
  else
    L.C.canvasMode = 'displayIndexList'
  end
  L.F:PlaySound(L.C.sound.swap)
  L.canvas:Enable()
end)

-- murloc OnDragStart func
L.murloc:SetScript("OnDragStart", function(self)
  if IsShiftKeyDown() then
    self:StartSizing()
  else
    self:StartMoving()
  end
end)

-- murloc OnSizeChanged func
L.murloc:SetScript("OnSizeChanged", function(self, w, h)
  w = math.min(math.max(w, 20), 400)
  self:SetSize(w, w) -- height = width
end)

-- murloc OnDragStop func
L.murloc:SetScript("OnDragStop", function(self)
  self:StopMovingOrSizing()
end)

-- murloc OnEnter func
L.murloc:SetScript("OnEnter", function(self)
  --L.F:PlaySound(L.C.sound.select)
  GT:SetOwner(self, "ANCHOR_TOP", 0, 5)
  GT:AddLine(L.name, 0, 1, 0.5, 1, 1, 1)
  GT:AddLine("To show any tooltip on the following canvas hold down |cff00ffffALT|r while hovering over models. Left-click to open the canvas.", 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("|cff00ffffLeft-Click|r", "open canvas showing data from built model database", 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("|cff00ffffMouse4|r", "open canvas without a filtered list", 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("|cff00ffffMouse5|r", "build model database", 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("|cff00ffffRight-Click|r", "drag to move", 1, 1, 1, 1, 1, 1)
  GT:AddDoubleLine("|cff00ffffRight-Click|r + |cff00ffffSHIFT|r", "drag to resize", 1, 1, 1, 1, 1, 1)
  GT:Show()
end)

-- murloc OnLeave func
L.murloc:SetScript("OnLeave", function(self)
  --L.F:PlaySound(L.C.sound.swap)
  GT:Hide()
end)

function L.murloc:ResetModelToMurloc()
  self:ClearModel()
  self:SetCamDistanceScale(1)
  self:SetRotation(0)
  self:SetDisplayInfo(iconDisplayInfoID)
end

function L.murloc:Init()
  self:SetSize(200, 200)
  self:SetPoint("CENTER", 0, 0)
  self:SetMovable(true)
  self:SetResizable(true)
  self:SetUserPlaced(true)
  self:EnableMouse(true)
  self:SetClampedToScreen(true)
  self:RegisterForDrag("RightButton")
  self:ResetModelToMurloc()
end

L.murloc:Init()

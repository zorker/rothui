
-- rLib: dragframe
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Functions
-----------------------------

local function OnDragStart(self, button)
  if IsAltKeyDown() and IsShiftKeyDown() then
    if button == "LeftButton" then
      self:GetParent():StartMoving()
    end
    if button == "RightButton" then
      self:GetParent():StartSizing()
    end
  end
end

local function OnDragStop(self)
  self:GetParent():StopMovingOrSizing()
end

local function OnEnter(self)
  GameTooltip:SetOwner(self, "ANCHOR_TOP")
  GameTooltip:AddLine(self:GetParent():GetName(), 0, 1, 0.5, 1, 1, 1)
  GameTooltip:AddLine("Hold ALT+SHIFT+LeftButton to drag!", 1, 1, 1, 1, 1, 1)
  if self:GetParent().__resizable then
    GameTooltip:AddLine("Hold ALT+SHIFT+RightButton to resize!", 1, 1, 1, 1, 1, 1)
  end
  GameTooltip:Show()
end

local function OnLeave(self)
  GameTooltip:Hide()
end

local function OnShow(self)
  local frame = self:GetParent()
  if frame.fader then
    L:StartFadeIn(frame)
  end
end

local function OnHide(self)
  local frame = self:GetParent()
  if frame.fader then
    L:StartFadeOut(frame)
  end
end

--rLib:CreateDragFrame
function rLib:CreateDragFrame(frame, frames, inset, clamp)
  if not frame or not frames then return end
  --save the default position for later
  frame.defaultPoint = L:GetPoint(frame)
  table.insert(frames,frame) --add frame object to the list
  --anchor a dragable frame on frame
  local df = CreateFrame("Frame",nil,frame)
  df:SetAllPoints(frame)
  df:SetFrameStrata("HIGH")
  df:SetHitRectInsets(inset or 0, inset or 0, inset or 0, inset or 0)
  df:EnableMouse(true)
  df:RegisterForDrag("LeftButton")
  df:SetScript("OnDragStart", OnDragStart)
  df:SetScript("OnDragStop", OnDragStop)
  df:SetScript("OnEnter", OnEnter)
  df:SetScript("OnLeave", OnLeave)
  df:SetScript("OnShow", OnShow)
  df:SetScript("OnHide", OnHide)
  df:Hide()
  --overlay texture
  local t = df:CreateTexture(nil,"OVERLAY",nil,6)
  t:SetAllPoints(df)
  t:SetColorTexture(1,1,1)
  t:SetVertexColor(0,1,0)
  t:SetAlpha(0.3)
  df.texture = t
  --frame stuff
  frame.dragFrame = df
  frame:SetClampedToScreen(clamp or false)
  frame:SetMovable(true)
  frame:SetUserPlaced(true)
end

--rLib:CreateDragResizeFrame
function rLib:CreateDragResizeFrame(frame, frames, inset, clamp)
  if not frame or not frames then return end
  rLib:CreateDragFrame(frame, frames, inset, clamp)
  frame.defaultSize = L:GetSize(frame)
  frame:SetResizable(true)
  frame.__resizable = true
  frame.dragFrame:RegisterForDrag("LeftButton","RightButton")
end
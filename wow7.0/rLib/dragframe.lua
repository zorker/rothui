
  -- rLib: dragframe
  -- zork, 2016

  -----------------------------
  -- Local Variables
  -----------------------------
  
  local A, L = ...  
  
  -----------------------------
  -- Global Functions
  -----------------------------

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
    df:SetHitRectInsets(inset or 0,inset or 0,inset or 0,inset or 0)
    df:EnableMouse(true)
    df:RegisterForDrag("LeftButton")
    df:SetScript("OnDragStart", function(frame) if IsAltKeyDown() and IsShiftKeyDown() then frame:GetParent():StartMoving() end end)
    df:SetScript("OnDragStop", function(frame) frame:GetParent():StopMovingOrSizing() end)
    df:SetScript("OnEnter", function(frame)
      GameTooltip:SetOwner(frame, "ANCHOR_TOP")
      GameTooltip:AddLine(frame:GetParent():GetName(), 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    df:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    df:Hide()
    --overlay texture
    local t = df:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(df)
    t:SetTexture(1,1,1)
    t:SetVertexColor(0,1,1)
    t:SetAlpha(0.3)
    df.texture = t
    --frame stuff
    frame.dragFrame = df
    frame:SetClampedToScreen(clamp or false)
    frame:SetMovable(true)
    frame:SetUserPlaced(true)
  end
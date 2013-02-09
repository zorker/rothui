
  -- // rTestPanel - Drag
  -- // zork - 2013

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...

  --variables
  local UIP = UIParent
  local CF = CreateFrame
  local _G = _G

  --get the config
  local cfg = ns.cfg

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --checks
  if not ns.mainFrame then return end

  local createDragFrame = function()

    if cfg.debug then
      print("createDragFrame")
    end

    local frame = CF("Frame", "$parentDragFrame", ns.mainFrame)
    frame:SetHeight(22)
    frame:SetPoint("TOPLEFT",60,0)
    frame:SetPoint("TOPRIGHT",-30,0)

    if cfg.debug then
      local texture = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
      texture:SetAllPoints()
      texture:SetTexture(1,1,1)
      texture:SetVertexColor(0,1,0,0.6) --bugfix
    end

    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
      if InCombatLockdown() then return end
      self:GetParent():StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
      if InCombatLockdown() then return end
      self:GetParent():StopMovingOrSizing()
      if cfg.debug then
        print(self:GetParent():GetPoint())
      end
    end)
    frame:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine(addon, 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("Drag me!", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

    return frame

  end

  --call
  if cfg.mainFrame.draggable then
    ns.mainFrame.dragFrame = createDragFrame()
  end
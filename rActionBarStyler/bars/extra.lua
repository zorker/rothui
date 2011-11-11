
  --get the addon namespace
  local addon, ns = ...

  --get the config values
  local cfg = ns.cfg
  local barcfg = cfg.bars.extrabar

  if not barcfg.disable then

    local num = 1

    local bar = CreateFrame("Frame","rABS_ExtraActionBar",UIParent,"SecureHandlerStateTemplate")
    bar:SetWidth(barcfg.buttonsize*num+barcfg.buttonspacing*(num-1))
    bar:SetHeight(barcfg.buttonsize)
    bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
    bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)

    if barcfg.testmode then
      bar:SetBackdrop(cfg.backdrop)
      bar:SetBackdropColor(1,0.8,1,0.6)
    end
    bar:SetScale(barcfg.barscale)

    cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)

    for i=1, num do
      local button = _G["ExtraActionButton"..i]
      if not button then return end
      button:SetSize(barcfg.buttonsize, barcfg.buttonsize)
      button:ClearAllPoints()
      if i == 1 then
        button:SetPoint("BOTTOMLEFT", bar, 0,0)
      else
        local previous = _G["ExtraActionButton"..i-1]
        button:SetPoint("LEFT", previous, "RIGHT", barcfg.buttonspacing, 0)
      end
    end

    bar:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
    bar:SetScript("OnEvent", function(self, event, ...)
      if (event == "UPDATE_EXTRA_ACTIONBAR") then
        if (HasExtraActionBar()) then
          self:Show()
        elseif(self:IsShown()) then
          self:Hide()
        end
      end
    end)

  end --disable
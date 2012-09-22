
  --get the addon namespace
  local addon, ns = ...

  --get the config values
  local cfg = ns.cfg
  local barcfg = cfg.bars.vehicleexit

  local bar = CreateFrame("Frame","rABS_VehicleExit",UIParent, "SecureHandlerStateTemplate")
  bar:SetHeight(barcfg.buttonsize)
  bar:SetWidth(barcfg.buttonsize)
  bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
  bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)

  if barcfg.testmode then
    bar:SetBackdrop(cfg.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(barcfg.barscale)

  cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)

  local veb = CreateFrame("BUTTON", nil, bar, "SecureHandlerClickTemplate");
  veb:SetAllPoints(bar)
  veb:RegisterForClicks("AnyUp")
  veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
  veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
  veb:SetScript("OnClick", function(self) VehicleExit() end)
  RegisterStateDriver(veb, "visibility", "[target=vehicle,exists] show;hide")
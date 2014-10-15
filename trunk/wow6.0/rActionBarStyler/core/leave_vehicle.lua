
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg
  --get some values from the namespace
  local cfg = gcfg.bars.leave_vehicle
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  if not cfg.enable then return end

  local num = 1
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_LeaveVehicle", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth(num*cfg.buttons.size + (num-1)*cfg.buttons.margin + 2*cfg.padding)
  frame:SetHeight(cfg.buttons.size + 2*cfg.padding)
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --the button
  local button = CreateFrame("BUTTON", "rABS_LeaveVehicleButton", frame, "SecureHandlerClickTemplate, SecureHandlerStateTemplate");
  table.insert(buttonList, button) --add the button object to the list
  button:SetSize(cfg.buttons.size, cfg.buttons.size)
  button:SetPoint("BOTTOMLEFT", frame, cfg.padding, cfg.padding)
  button:RegisterForClicks("AnyUp")
  button:SetScript("OnClick", VehicleExit)

  button:SetNormalTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
  button:SetPushedTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
  button:SetHighlightTexture("INTERFACE\\PLAYERACTIONBARALT\\NATURAL")
  local nt = button:GetNormalTexture()
  local pu = button:GetPushedTexture()
  local hi = button:GetHighlightTexture()
  nt:SetTexCoord(0.0859375,0.1679688,0.359375,0.4414063)
  pu:SetTexCoord(0.001953125,0.08398438,0.359375,0.4414063)
  hi:SetTexCoord(0.6152344,0.6972656,0.359375,0.4414063)
  hi:SetBlendMode("ADD")

  --the button will spawn if a vehicle exists, but no vehicle ui is in place (the vehicle ui has its own exit button)
  RegisterStateDriver(button, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar][@vehicle,exists] show; hide")
  --frame is visibile when no vehicle ui is visible
  RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end
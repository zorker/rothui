
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg
  --get some values from the namespace
  local cfg = gcfg.bars.overridebar
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  if not cfg.enable then return end

  local num = 6 --NUM_ACTIONBAR_BUTTONS --there seems to be no MAX_OVERRIDE_NUM or the like
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_OverrideBar", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth(num*cfg.buttons.size + (num-1)*cfg.buttons.margin + 2*cfg.padding)
  frame:SetHeight(cfg.buttons.size + 2*cfg.padding)
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --move the buttons into position and reparent them
  OverrideActionBar:SetParent(frame)
  OverrideActionBar:EnableMouse(false)
  OverrideActionBar:SetScript("OnShow", nil) --remove the onshow script

  local leaveButtonPlaced = false
  OverrideActionBar.LeaveButton:Hide()

  for i=1, num do
    local button =  _G["OverrideActionBarButton"..i]
    if not button and not leaveButtonPlaced then
      button = OverrideActionBar.LeaveButton --the magic 7th button
      leaveButtonPlaced = true
    end
    if not button then
      break
    end
    table.insert(buttonList, button) --add the button object to the list
    button:SetSize(cfg.buttons.size, cfg.buttons.size)
    button:ClearAllPoints()
    if i == 1 then
      button:SetPoint("BOTTOMLEFT", frame, cfg.padding, cfg.padding)
    else
      local previous = _G["OverrideActionBarButton"..i-1]
      button:SetPoint("LEFT", previous, "RIGHT", cfg.buttons.margin, 0)
    end
  end

  --show/hide the frame on a given state driver
  RegisterStateDriver(frame, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
  RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end

  --create the combat fader
  if cfg.combat.enable then
    rCombatFrameFader(frame, cfg.combat.fadeIn, cfg.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end
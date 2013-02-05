
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg
  --get some values from the namespace
  local cfg = gcfg.bars.bar4
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  if not cfg.enable then return end

  local num = NUM_ACTIONBAR_BUTTONS
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_MultiBarRight", UIParent, "SecureHandlerStateTemplate")
  if cfg.combineBar4AndBar5 then
    frame:SetWidth(2*cfg.buttons.size + (2-1)*cfg.buttons.margin + 2*cfg.padding)
  else
    frame:SetWidth(cfg.buttons.size + 2*cfg.padding)
  end
  frame:SetHeight(num*cfg.buttons.size + (num-1)*cfg.buttons.margin + 2*cfg.padding)
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --move the buttons into position and reparent them
  MultiBarRight:SetParent(frame)
  MultiBarRight:EnableMouse(false)
  if cfg.combineBar4AndBar5 then
    MultiBarLeft:SetParent(frame)
    MultiBarLeft:EnableMouse(false)
  end

  for i=1, num do
    local button = _G["MultiBarRightButton"..i]
    table.insert(buttonList, button) --add the button object to the list
    button:SetSize(cfg.buttons.size, cfg.buttons.size)
    button:ClearAllPoints()
    if i == 1 then
      button:SetPoint("TOPRIGHT", frame, -cfg.padding, -cfg.padding)
    else
      local previous = _G["MultiBarRightButton"..i-1]
      button:SetPoint("TOP", previous, "BOTTOM", 0, -cfg.buttons.margin)
    end
  end

  if cfg.combineBar4AndBar5 then
    for i=1, num do
      local button = _G["MultiBarLeftButton"..i]
      table.insert(buttonList, button) --add the button object to the list
      button:SetSize(cfg.buttons.size, cfg.buttons.size)
      button:ClearAllPoints()
      if i == 1 then
        button:SetPoint("TOPRIGHT", frame, -(cfg.padding+cfg.buttons.margin+cfg.buttons.size), -cfg.padding)
      else
        local previous = _G["MultiBarLeftButton"..i-1]
        button:SetPoint("TOP", previous, "BOTTOM", 0, -cfg.buttons.margin)
      end
    end
  end

  --show/hide the frame on a given state driver
  RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
    frame.mouseover = cfg.mouseover
  end

  --create the combat fader
  if cfg.combat.enable then
    rCombatFrameFader(frame, cfg.combat.fadeIn, cfg.combat.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end
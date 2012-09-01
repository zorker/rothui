
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg
  --get some values from the namespace
  local cfg = gcfg.bars.extrabar
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  if not cfg.enable then return end

  local num = 1
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_ExtraBar", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth(num*cfg.buttons.size + (num-1)*cfg.buttons.margin + 2*cfg.padding)
  frame:SetHeight(cfg.buttons.size + 2*cfg.padding)
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --move the buttons into position and reparent them
  ExtraActionBarFrame:SetParent(frame)
  ExtraActionBarFrame:EnableMouse(false)
  ExtraActionBarFrame:ClearAllPoints()
  ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
  ExtraActionBarFrame.ignoreFramePositionManager = true

  --the extra button
  local button = ExtraActionButton1
  table.insert(buttonList, button) --add the button object to the list
  button:SetSize(cfg.buttons.size,cfg.buttons.size)

  --show/hide the frame on a given state driver
  RegisterStateDriver(frame, "visibility", "[petbattle][overridebar][vehicleui] hide; show")

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end

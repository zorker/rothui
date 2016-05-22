
  -- rActionBar: micromenu
  -- zork, 2016

  -----------------------------
  -- Config
  -----------------------------

  local cfg = {}
  cfg.scale     = 1
  cfg.padding   = 10
  cfg.width     = CharacterMicroButton:GetWidth()
  cfg.height    = CharacterMicroButton:GetHeight()/1.5
  cfg.pos       = { a1 = "TOP", a2 = "TOP", af = UIParent, x = 0, y = 25 }
  
  -----------------------------
  -- Local Variables
  -----------------------------
  
  local A, L = ...  

  --button list
  local buttonList = {}
  for idx, buttonName in next, MICRO_BUTTONS do
    local button = _G[buttonName]
    if button then
      table.insert(buttonList, button)
    end
  end
  --num_buttons
  local num_buttons = # buttonList
  
  -----------------------------
  -- Init
  -----------------------------

  --create new parent frame
  local frame = CreateFrame("Frame", "rABS_MicroMenu", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth(cfg.width)
  frame:SetHeight(cfg.height)
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --reparent all buttons
  for idx, button in next, buttonList do
    button:SetParent(frame)
  end
  
  --repoint the first button
  CharacterMicroButton:ClearAllPoints();
  CharacterMicroButton:SetPoint("CENTER")

  --disable reanchoring of the micro menu by the petbattle ui
  PetBattleFrame.BottomFrame.MicroButtonFrame:SetScript("OnShow", nil) --remove the onshow script
  --show/hide the frame on a given state driver
  RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")
  --create drag frame and drag functionality
  rLib:CreateDragFrame(frame, L.dragFrames, -2 , true) --frame, dragFrameList, inset, clamp

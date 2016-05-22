
  -- rActionBar: bags
  -- zork, 2016
  
  -----------------------------
  -- Config
  -----------------------------

  local cfg = {}
  cfg.scale     = 1
  cfg.padding   = 15
  cfg.width     = MainMenuBarBackpackButton:GetWidth()
  cfg.height    = MainMenuBarBackpackButton:GetHeight()
  cfg.pos       = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = "UIParent", x = -0, y = 0 }
  
  -----------------------------
  -- Local Variables
  -----------------------------
  
  local A, L = ...  
 
  --button list
  local buttonList = {
    MainMenuBarBackpackButton,
    CharacterBag0Slot,
    CharacterBag1Slot,
    CharacterBag2Slot,
    CharacterBag3Slot,
  }
  --num_buttons
  local num_buttons = # buttonList

  -----------------------------
  -- Init
  -----------------------------
  
  --create new parent frame
  local frame = CreateFrame("Frame", "rABS_BagFrame", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth(cfg.width)
  frame:SetHeight(cfg.height)
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --reparent all buttons
  for idx, button in next, buttonList do
    button:SetParent(frame)
  end
  
  --repoint the first button
  MainMenuBarBackpackButton:ClearAllPoints();
  MainMenuBarBackpackButton:SetPoint("CENTER")

  --show/hide the frame on a given state driver
  RegisterStateDriver(frame, "visibility", "[petbattle] hide; show")
  --create drag frame and drag functionality
  rLib:CreateDragFrame(frame, L.dragFrames, -2 , true) --frame, dragFrameList, inset, clamp


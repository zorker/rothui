
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg
  --get some values from the namespace
  local cfg = gcfg.bars.micromenu
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  if not cfg.enable then return end

  --mircro menu
  local mircoButtons = {
    CharacterMicroButton,
    SpellbookMicroButton,
    TalentMicroButton,
    AchievementMicroButton,
    QuestLogMicroButton,
    GuildMicroButton,
    PVPMicroButton,
    LFDMicroButton,
    CompanionsMicroButton,
    EJMicroButton,
    MainMenuMicroButton,
    HelpMicroButton,
  }

  local NUM_MICROBUTTONS = # mircoButtons
  local buttonWidth = CharacterMicroButton:GetWidth()
  local buttonHeight = CharacterMicroButton:GetHeight()
  local gap = -3
  local padding = cfg.padding

  --make a frame that fits the size of all microbuttons
  local frame = CreateFrame("Frame", "rABS_MicroMenu", UIParent, "SecureHandlerStateTemplate")
  frame:SetWidth(NUM_MICROBUTTONS*buttonWidth + (NUM_MICROBUTTONS-1)*gap + 2*padding)
  frame:SetHeight(buttonHeight+2*padding)
  frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  frame:SetScale(cfg.scale)

  --move the buttons into position and reparent them
  for _, button in pairs(mircoButtons) do
    button:SetParent(frame)
  end
  CharacterMicroButton:ClearAllPoints();
  CharacterMicroButton:SetPoint("LEFT", padding, 0)

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -10 , false) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    rButtonBarFader(frame, mircoButtons, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end

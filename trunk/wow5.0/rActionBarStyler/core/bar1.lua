
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local gcfg = ns.cfg
  --get some values from the namespace
  local cfg = gcfg.bars.bar1
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  if not cfg.enable then return end

  local num = NUM_ACTIONBAR_BUTTONS
  local buttonList = {}

  --create the frame to hold the buttons
  local frame = CreateFrame("Frame", "rABS_MainMenuBar", UIParent, "SecureHandlerStateTemplate")

  if cfg.uselayout2x6 then
    frame:SetWidth(cfg.buttons.size*num/2 + (num/2-1)*cfg.buttons.margin + 2*cfg.padding)
    frame:SetHeight(cfg.buttons.size*num/6 + (num/6-1)*cfg.buttons.margin + 2*cfg.padding)
  else
    frame:SetWidth(num*cfg.buttons.size + (num-1)*cfg.buttons.margin + 2*cfg.padding)
    frame:SetHeight(cfg.buttons.size + 2*cfg.padding)
  end
  if cfg.uselayout2x6 then
    frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x-((cfg.buttons.size*num/2+cfg.buttons.margin*num/2)/2),cfg.pos.y)
  else
    frame:SetPoint(cfg.pos.a1,cfg.pos.af,cfg.pos.a2,cfg.pos.x,cfg.pos.y)
  end
  frame:SetScale(cfg.scale)

  for i=1, num do
    local button = _G["ActionButton"..i]
    table.insert(buttonList, button) --add the button object to the list
    button:SetSize(cfg.buttons.size, cfg.buttons.size)
    button:ClearAllPoints()
    button:SetParent(self)
    if i == 1 then
      button:SetPoint("BOTTOMLEFT", self, cfg.padding, cfg.padding)
    else
      local previous = _G["ActionButton"..i-1]
      if cfg.uselayout2x6 and i == (num/2+1) then
        previous = _G["ActionButton1"]
        button:SetPoint("BOTTOM", previous, "TOP", 0, cfg.buttons.margin)
      else
        button:SetPoint("LEFT", previous, "RIGHT", cfg.buttons.margin, 0)
      end
    end
  end

  --create drag frame and drag functionality
  if cfg.userplaced.enable then
    rCreateDragFrame(frame, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  --create the mouseover functionality
  if cfg.mouseover.enable then
    rButtonBarFader(frame, buttonList, cfg.mouseover.fadeIn, cfg.mouseover.fadeOut) --frame, buttonList, fadeIn, fadeOut
  end

  -----------------------------
  -- ACTIONBUTTON SETFRAMEREF
  -----------------------------

  --generate a frame reference for all actionbuttons
  local Page = {
    ["DRUID"]     = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
    ["WARRIOR"]   = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
    ["MONK"]      = "[bonusbar:1] 7;",
    ["PRIEST"]    = "[bonusbar:1] 7;",
    ["ROGUE"]     = "[bonusbar:1] 7; [form:3] 10;",
    ["WARLOCK"]   = "[form:2] 7;",
    ["DEFAULT"]   = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
  }

  local function GetBar()
    local condition = Page["DEFAULT"]
    local class = cfg.playerclass
    local page = Page[class]
    if page then
      condition = condition.." "..page
    end
    condition = condition.." 1"
    return condition
  end

  frame:RegisterEvent("PLAYER_LOGIN")
  --frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  --frame:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
  --frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
  --frame:RegisterEvent("BAG_UPDATE")
  --frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
      for id = 1, NUM_ACTIONBAR_BUTTONS do
        local name = "ActionButton"..id
        self:SetFrameRef(name, _G[name])
      end
      self:Execute(([[
        buttons = table.new()
        for id = 1, %s do
          buttons[id] = self:GetFrameRef("ActionButton"..id)
        end
      ]]):format(NUM_ACTIONBAR_BUTTONS))
      self:SetAttribute('_onstate-page', ([[
        if not newstate then return end
        newstate = tonumber(newstate)
        for id = 1, %s do
          buttons[id]:SetAttribute("actionpage", newstate)
        end
      ]]):format(NUM_ACTIONBAR_BUTTONS))
      RegisterStateDriver(self, "page", GetBar())
    else
       MainMenuBar_OnEvent(self, event, ...)
    end
  end)


  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = ns.cfg

  --new fadein func
  FCF_FadeInChatFrame = function(self)
    self.hasBeenFaded = true
  end

  --new fadeout func
  FCF_FadeOutChatFrame = function(self)
    self.hasBeenFaded = false
  end

  FCFTab_UpdateColors = function(self, selected)
    if (selected) then
      self:SetAlpha(cfg.selectedTabAlpha)
      self:GetFontString():SetTextColor(unpack(cfg.selectedTabColor))
      self.leftSelectedTexture:Show()
      self.middleSelectedTexture:Show()
      self.rightSelectedTexture:Show()
    else
      self:GetFontString():SetTextColor(unpack(cfg.notSelectedTabColor))
      self:SetAlpha(cfg.notSelectedTabAlpha)
      self.leftSelectedTexture:Hide()
      self.middleSelectedTexture:Hide()
      self.rightSelectedTexture:Hide()
    end
  end


  --add more chat font sizes
  for i = 1, 23 do
    CHAT_FONT_HEIGHTS[i] = i+7
  end

  --hide the menu button
  ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
  ChatFrameMenuButton:Hide()

  --hide the friend micro button
  FriendsMicroButton:HookScript("OnShow", FriendsMicroButton.Hide)
  FriendsMicroButton:Hide()

  --don't cut the toastframe
  BNToastFrame:SetClampedToScreen(true)
  BNToastFrame:SetClampRectInsets(-15,15,15,-15)

  ChatFontNormal:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
  ChatFontNormal:SetShadowOffset(1,-1)
  ChatFontNormal:SetShadowColor(0,0,0,0.6)

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function skinChat(self)
    if not self or (self and self.skinApplied) then return end

    local name = self:GetName()

    --chat frame resizing
    self:SetClampRectInsets(0, 0, 0, 0)
    self:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
    self:SetMinResize(100, 50)

    --chat fading
    --self:SetFading(false)

    --set font, outline and shadow for chat text
    self:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    self:SetShadowOffset(1,-1)
    self:SetShadowColor(0,0,0,0.6)

    --fix the buttonframe
    local frame = _G[name.."ButtonFrame"]
    frame:Hide()
    frame:HookScript("OnShow", frame.Hide)

    --editbox skinning
    _G[name.."EditBoxLeft"]:Hide()
    _G[name.."EditBoxMid"]:Hide()
    _G[name.."EditBoxRight"]:Hide()
    local eb = _G[name.."EditBox"]
    eb:SetAltArrowKeyMode(false)
    eb:ClearAllPoints()
    eb:SetPoint("BOTTOM",self,"TOP",0,22)
    eb:SetPoint("LEFT",self,-5,0)
    eb:SetPoint("RIGHT",self,10,0)

    --found this nice function, may need it sometime
    --ChatEdit_FocusActiveWindow --set focus on current active chatwindow editbox (nice lol)

    --chat tab skinning
    local tab = _G[name.."Tab"]
    local tabFs = tab:GetFontString()
    tabFs:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE")
    tabFs:SetShadowOffset(1,-1)
    tabFs:SetShadowColor(0,0,0,0.6)
    tabFs:SetTextColor(unpack(cfg.selectedTabColor))
    if cfg.hideChatTabBackgrounds then
      _G[name.."TabLeft"]:SetTexture(nil)
      _G[name.."TabMiddle"]:SetTexture(nil)
      _G[name.."TabRight"]:SetTexture(nil)
      _G[name.."TabSelectedLeft"]:SetTexture(nil)
      _G[name.."TabSelectedMiddle"]:SetTexture(nil)
      _G[name.."TabSelectedRight"]:SetTexture(nil)
      --_G[name.."TabGlow"]:SetTexture(nil) --do not hide this texture, it will glow when a whisper hits a hidden chat
      --_G[name.."TabHighlightLeft"]:SetTexture(nil)
      --_G[name.."TabHighlightMiddle"]:SetTexture(nil)
      --_G[name.."TabHighlightRight"]:SetTexture(nil)
    end
    tab:SetAlpha(cfg.selectedTabAlpha)

    self.skinApplied = true
  end

  -----------------------------
  -- CALL
  -----------------------------

  --chat skinning
  for i = 1, NUM_CHAT_WINDOWS do
    skinChat(_G["ChatFrame"..i])
  end

  --skin temporary chats
  hooksecurefunc("FCF_OpenTemporaryWindow", function()
    for _, chatFrameName in pairs(CHAT_FRAMES) do
      local frame = _G[chatFrameName]
      if (frame.isTemporary) then
        skinChat(frame)
      end
    end
  end)

  --combat log custom hider
  local function fixStuffOnLogin()
    for i = 1, NUM_CHAT_WINDOWS do
      local name = "ChatFrame"..i
      local tab = _G[name.."Tab"]
      tab:SetAlpha(cfg.selectedTabAlpha)
    end
    CombatLogQuickButtonFrame_Custom:HookScript("OnShow", CombatLogQuickButtonFrame_Custom.Hide)
    CombatLogQuickButtonFrame_Custom:Hide()
    CombatLogQuickButtonFrame_Custom:SetHeight(0)
  end

  local a = CreateFrame("Frame")
  a:RegisterEvent("PLAYER_LOGIN")
  a:SetScript("OnEvent", fixStuffOnLogin)
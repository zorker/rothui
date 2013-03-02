
  -- // rTestPanel - Mainframe
  -- // zork - 2013

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...

  --variables
  local UIP = UIParent
  local CF = CreateFrame
  local _G = _G
  local unpack = unpack
  local wipe = wipe
  local tinsert = tinsert

  --get the config
  local cfg = ns.cfg

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --checks
  if # cfg.mainFrame.tabs <= 0 then
    print(addon.." error: No MainFrameTabs where found!")
    return
  end

  local createMainFrame = function()

    if cfg.debug then
      print("createMainFrame")
    end

    --init the panel
    local panel = CF("Frame", addon, UIP, "ButtonFrameTemplate")

    --settings
    panel.numTabs = # cfg.mainFrame.tabs
    panel.selectedTab = 1
    panel.name = panel:GetName()
    --list for all the subframe headers
    panel.subFrameHeader = {}
    --list for all the subframes
    panel.subFrames = {}

    if cfg.debug then
      print("Found "..panel.numTabs.." tabs to spawn for "..panel:GetName())
    end

    --size/point/strata
    panel:SetFrameStrata(cfg.mainFrame.frameStrata)
    panel:SetWidth(cfg.mainFrame.width)
    panel:SetHeight(cfg.mainFrame.height)
    panel:SetPoint(unpack(cfg.mainFrame.position))

    --the panel titel (can be used later by subframes to change the title)
    panel.title = _G[addon.."TitleText"]
    panel.title:SetText(addon)

    --icon
    local icon = panel:CreateTexture("$parentIcon", "OVERLAY", nil, -8)
    icon:SetSize(60,60)
    icon:SetPoint("TOPLEFT",-5,7)
    --icon:SetTexture(1,1,1)
    icon:SetTexture("Interface\\FriendsFrame\\Battlenet-Portrait")
    --SetPortraitTexture(icon, "player")
    icon:SetTexCoord(0,1,0,1)
    --local ag = icon:CreateAnimationGroup()
    --local anim = ag:CreateAnimation("Rotation")
    --anim:SetDegrees(360)
    --anim:SetDuration(60)
    --ag:Play()
    --ag:SetLooping("REPEAT")

    panel.icon = icon

    local updateView = function()
      if cfg.debug then
        print("Updating view. Current selected mainFrameTab is: "..panel.selectedTab)
      end

      local header = panel.subFrameHeader[panel.selectedTab]
      local subFrame = _G[panel.name.."Tab"..panel.selectedTab.."SubFrame"..header.selectedTab]

      --updating the bottom tabs
      PanelTemplates_UpdateTabs(panel) --changing textures on tabs

      --updating header tabs
      PanelTemplates_UpdateTabs(header) --changing textures on tabs

      --hide all headers
      for i = 1, # panel.subFrameHeader do
        --print("hiding "..panel.subFrameHeader[i].name)
        panel.subFrameHeader[i]:Hide()
      end

      --hide all subframes
      for i = 1, # panel.subFrames do
        panel.subFrames[i]:Hide()
      end

      --show active header/subframe
      header:Show()
      subFrame:Show()

    end
    panel.updateView = updateView
    panel:HookScript("OnShow",updateView)

    --make sure the mainFrame keeps min/max sizes
    local checkSize = function(self)
      local minw = cfg.mainFrame.minWidth or 200
      local maxw = cfg.mainFrame.maxWidth or 1024
      local minh = cfg.mainFrame.minHeight or 200
      local maxh = cfg.mainFrame.maxHeight or 768-100
      local w,h = self:GetSize()
      if w < minw then
        self:SetWidth(minw)
      elseif w > maxw then
        self:SetWidth(maxw)
      end
      if h < minh then
        self:SetHeight(minh)
      elseif h > maxh then
        self:SetHeight(maxh)
      end
      if cfg.debug then
        print(self:GetSize())
      end
    end
    panel:SetScript("OnSizeChanged", checkSize)

    --make sure you cannot click through the frame
    panel:EnableMouse(true)

    --make sure you cannot move the panel out of the screen
    panel:SetClampedToScreen(true)

    --make sure the frame is movable if dragging is enabled
    if cfg.mainFrame.draggable then
      panel:SetMovable(true)
    end

    --make sure the frame is resizable if resizing is enabled
    if cfg.mainFrame.resizable then
      panel:SetResizable(true)
    end

    --activate userplaced to save the position and size data in the layout-local.txt
    if cfg.mainFrame.draggable or cfg.mainFrame.resizable then
      panel:SetUserPlaced(true)
    end

    panel:Hide()

    --show frame on load?
    if cfg.mainFrame.showOnLoad then
      panel:RegisterEvent("PLAYER_LOGIN")
      panel:SetScript("OnEvent", function(self,event)
        if cfg.debug then
          print(self:GetName().." event: "..event)
        end
        if event == "PLAYER_LOGIN" and not InCombatLockdown() then
          self:Show()
        end
      end)
    end

    return panel

  end

  --make the mainFrame available in the namespace
  ns.mainFrame = createMainFrame()

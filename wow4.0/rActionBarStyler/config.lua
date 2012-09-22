
  -- // rActionBarStyler
  -- // zork - 2010

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...

  --generate a holder for the config data
  local cfg = CreateFrame("Frame")

  -----------------------------
  -- CONFIG
  -----------------------------

  --notice on locking
  --keep bars locked, you now have a slash command to lock/unlock your bars ingame
  --use "/rabs" to see the command list

  cfg.bars = {
    bar1 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      uselayout2x6    = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 22 },
      testmode        = false,
    },
    bar2 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      uselayout2x6    = false,
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 53 },
      testmode        = false,
    },
    bar3 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      uselayout2x6    = false,
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 92 },
      testmode        = false,
    },
    bar4 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      showonmouseover = true,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -10, y = 0 },
      testmode        = false,
    },
    bar5 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      showonmouseover = true,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -46, y = 0 },
      testmode        = false,
    },
    extrabar = {
      buttonsize      = 36,
      buttonspacing   = 5,
      barscale        = 0.82,
      userplaced      = true,
      locked          = true,
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -210, y = 135 },
      testmode        = false,
      disable         = false,
    },
    stancebar = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 140 },
      testmode        = false,
      disable         = false,
    },
    petbar = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 180 },
      testmode        = false,
      disable         = false,
    },
    micromenu = {
      barscale        = 0.82,
      showonmouseover = true,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "TOP", a2 = "TOP", af = "UIParent", x = 0, y = -5 },
      testmode        = false,
      disable         = false,
    },
    bags = {
      barscale        = 0.82,
      showonmouseover = true,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = "UIParent", x = -10, y = 10 },
      testmode        = false,
      disable         = false,
    },
    totembar = {
      barscale        = 0.82,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 140 },
      testmode        = false,
      disable         = false,
    },
    vehicleexit = {
      buttonsize      = 36,
      barscale        = 0.82,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = true, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 210, y = 135 },
      testmode        = false,
    },
  }

  -----------------------------
  -- CONFIG END
  -----------------------------

  local playername, _ = UnitName("player")
  local _, playerclass = UnitClass("player")

  cfg.playername = playername
  cfg.playerclass = playerclass


  -----------------------------------
  -- SPECIAL CHARACTER CONDITIONS
  -----------------------------------
  if playername == "Rothar" or playername == "Wolowizard" or playername == "Loral" then
    cfg.bars.bar1.uselayout2x6    = true
    cfg.bars.bar2.uselayout2x6    = true
    cfg.bars.stancebar.disable    = true
  end

  --font
  cfg.font = "FONTS\\FRIZQT__.ttf"

  --how many pixels around a bar reserved for dragging?
  cfg.barinset = 0

  --backdrop settings
  cfg.backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "",
    tile = false,
    tileSize = 0,
    edgeSize = 0,
    insets = {
      left = -cfg.barinset,
      right = -cfg.barinset,
      top = -cfg.barinset,
      bottom = -cfg.barinset,
    },
  }

  --allows frames to become movable but frames can be locked or set to default positions
  cfg.applyDragFunctionality = function(f,userplaced,locked)
    local getPoint = function(self)
      local pos = {}
      pos.a1, pos.af, pos.a2, pos.x, pos.y = self:GetPoint()
      if pos.af and pos.af:GetName() then pos.af = pos.af:GetName() end
      return pos
    end
    f.defaultPosition = getPoint(f)
    --new form of dragframe
    local df = CreateFrame("Frame",nil,f)
    df:SetAllPoints(f)
    df:SetFrameStrata("HIGH")
    df:SetHitRectInsets(-cfg.barinset,-cfg.barinset,-cfg.barinset,-cfg.barinset)
    df:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:GetParent():StartMoving() end end)
    df:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
    local t = df:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(df)
    t:SetTexture(0,1,0)
    t:SetAlpha(0.2)
    df.texture = t
    f.dragframe = df
    f.dragframe:Hide()
    f:SetClampedToScreen(true)
    if not userplaced then
      f:SetMovable(false)
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not locked then
        f.dragframe:Show()
        f.dragframe:EnableMouse(true)
        f.dragframe:RegisterForDrag("LeftButton")
        f.dragframe:SetScript("OnEnter", function(s)
          GameTooltip:SetOwner(s, "ANCHOR_TOP")
          GameTooltip:AddLine(s:GetParent():GetName(), 0, 1, 0.5, 1, 1, 1)
          GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
          GameTooltip:Show()
        end)
        f.dragframe:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
      end
    end
  end

  -----------------------------
  -- HANDOVER
  -----------------------------

  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg

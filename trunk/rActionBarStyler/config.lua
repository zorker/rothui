  
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
  
  cfg.bars = {
    bar1 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      uselayout2x6    = true,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = false, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 22 }, 
      testmode        = false,
    },
    bar2 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      uselayout2x6    = true,
      showonmouseover = false,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = false, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 53 }, 
      testmode        = false,
    },
    bar3 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      uselayout2x6    = false,
      showonmouseover = false,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = false, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 92 }, 
      testmode        = false,
    },
    bar4 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      showonmouseover = true,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = false, --frame locked
      pos             = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -10, y = 0 }, 
      testmode        = false,
    },
    bar5 = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      showonmouseover = true,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = false, --frame locked
      pos             = { a1 = "RIGHT", a2 = "RIGHT", af = "UIParent", x = -46, y = 0 }, 
      testmode        = false,
    },
    stancebar = {
      buttonsize      = 26,
      buttonspacing   = 5,
      barscale        = 0.82,
      showonmouseover = false,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = false, --frame locked
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
      locked          = false, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 140 }, 
      testmode        = false,
      disable         = false,
    },
    micromenu = {
      barscale        = 0.82,
      showonmouseover = true,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = false, --frame locked
      pos             = { a1 = "TOP", a2 = "TOP", af = "UIParent", x = 0, y = -5 }, 
      testmode        = false,
      disable         = false,
    },
    bags = {
      barscale        = 0.82,
      showonmouseover = true,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = false, --frame locked
      pos             = { a1 = "BOTTOMRIGHT", a2 = "BOTTOMRIGHT", af = "UIParent", x = -10, y = 10 }, 
      testmode        = false,
      disable         = false,
    },
    totembar = {
      barscale        = 0.82,
      userplaced      = true, --want to place the bar somewhere else?
      locked          = false, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -1, y = 140 }, 
      testmode        = false,
      disable         = false,
    },
    vehicleexit = {
      buttonsize      = 36,
      barscale        = 0.82,
      userplaced      = false, --want to place the bar somewhere else?
      locked          = false, --frame locked
      pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 170, y = 130 }, 
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
  if playername == "Rothar" then
    cfg.bars.stancebar.disable = true
  end  

  --font
  cfg.font = "FONTS\\FRIZQT__.ttf"
  
  --how many pixels around a bar reserved for dragging?
  cfg.barinset = 10

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
    if not userplaced then
      f:IsUserPlaced(false)
      return
    else
      f:SetMovable(true)
      f:SetUserPlaced(true)
      if not locked then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton","RightButton")
        f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
        f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
      end
    end  
  end
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg

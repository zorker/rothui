
  ---------------------------------------------
  -- oUF_Donut
  -- zork, 2013
  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = {}
  ns.cfg = cfg

  ----------------------------------------
  -- config
  ----------------------------------------

  --    ring segment layout
  --     ____ ____
  --    /    |    \
  --    |  4 | 1  |
  --     ----+----
  --    |  3 | 2  |
  --    \____|____/
  --

  cfg.units = {
    --PLAYER
    player = {
      enable = true,
      scale = 0.5,
      --castring
      castring = {
        radius = 0.9,     -- range 0-1
        textures = {
          bg    = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          fill  = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          spark = "Interface\\AddOns\\oUF_Donut\\media\\ring_spark",
        },
        colors = {
          bg        = { r=0, g=0, b=0, a=0.8, },
          fill      = { r=1, g=0.7, b=0, a=1, },
          shielded  = { r=0.5, g=0.5, b=0.5, a=1, },
          latency   = { r=1, g=0, b=0, a=0.8, },
          colorShielded = true,
        },
        numSegmentsUsed = 4,  -- how many sements are affected? (see ring layout)
        startSegment  = 4,    -- in which segment should the ring begin it's journey? (see ring layout)
        fillDirection = 0,    -- how should the ring fill up? 1 = clock-wise, 0 = counter-clock-wise
      },
      --powerring
      powerring = {
        radius = 0.7,
        textures = {
          bg    = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          fill  = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          spark = "Interface\\AddOns\\oUF_Donut\\media\\ring_spark",
        },
        colors = {
          bg    = { r=0, g=0, b=0, a=0.8, },
          fill  = { r=0, g=0.7, b=1, a=1, },
          colorClass        = false,
          colorPower        = true,
        },
        numSegmentsUsed = 4,  -- how many sements are affected? (see ring layout)
        startSegment  = 4,    -- in which segment should the ring begin it's journey? (see ring layout)
        fillDirection = 0,    -- how should the ring fill up? 1 = clock-wise, 0 = counter-clock-wise
      },
      --healthring
      healthring = {
        radius = 0.5,
        textures = {
          bg    = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          fill  = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          spark = "Interface\\AddOns\\oUF_Donut\\media\\ring_spark",
        },
        colors = {
          bg    = { r=0, g=0, b=0, a=0.8, },
          fill  = { r=0, g=1, b=0, a=1, },
          colorTapping      = true,
          colorDisconnected = true,
          colorThreat       = true,
          colorClass        = true,
          colorReaction     = true,
          colorHealth       = true,
        },
        numSegmentsUsed = 4,  -- how many sements are affected? (see ring layout)
        startSegment  = 4,    -- in which segment should the ring begin it's journey? (see ring layout)
        fillDirection = 0,    -- how should the ring fill up? 1 = clock-wise, 0 = counter-clock-wise
      },
    },

    --TARGET
    target = {
      enable = true,
      scale = 1,
      --castring
      castring = {
        radius = 0.9,     -- range 0-1
        textures = {
          bg    = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          fill  = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          spark = "Interface\\AddOns\\oUF_Donut\\media\\ring_spark",
        },
        colors = {
          bg        = { r=0, g=0, b=0, a=0.8, },
          fill      = { r=1, g=0.7, b=0, a=1, },
          shielded  = { r=0.5, g=0.5, b=0.5, a=1, },
          colorShielded = true,
        },
        numSegmentsUsed = 4,  -- how many sements are affected? (see ring layout)
        startSegment  = 4,    -- in which segment should the ring begin it's journey? (see ring layout)
        fillDirection = 0,    -- how should the ring fill up? 1 = clock-wise, 0 = counter-clock-wise
      },
      --powerring
      powerring = {
        radius = 0.7,
        textures = {
          bg    = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          fill  = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          spark = "Interface\\AddOns\\oUF_Donut\\media\\ring_spark",
        },
        colors = {
          bg    = { r=0, g=0, b=0, a=0.8, },
          fill  = { r=0, g=0.7, b=1, a=1, },
          colorClass        = false,
          colorPower        = true,
        },
        numSegmentsUsed = 4,  -- how many sements are affected? (see ring layout)
        startSegment  = 4,    -- in which segment should the ring begin it's journey? (see ring layout)
        fillDirection = 0,    -- how should the ring fill up? 1 = clock-wise, 0 = counter-clock-wise
      },
      --healthring
      healthring = {
        radius = 0.5,
        textures = {
          bg    = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          fill  = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
          spark = "Interface\\AddOns\\oUF_Donut\\media\\ring_spark",
        },
        colors = {
          bg    = { r=0, g=0, b=0, a=0.8, },
          fill  = { r=0, g=1, b=0, a=1, },
          colorTapping      = true,
          colorDisconnected = true,
          colorThreat       = true,
          colorClass        = true,
          colorReaction     = true,
          colorHealth       = true,
        },
        numSegmentsUsed = 4,  -- how many sements are affected? (see ring layout)
        startSegment  = 4,    -- in which segment should the ring begin it's journey? (see ring layout)
        fillDirection = 0,    -- how should the ring fill up? 1 = clock-wise, 0 = counter-clock-wise
      },
    },
  }

  ----------------------------------------
  -- other
  ----------------------------------------

  --font
  cfg.font = STANDARD_TEXT_FONT
  cfg.numberFont = "Interface\\AddOns\\UI-Tooltip-Background"

  --player data
  cfg.playerName  = UnitName("player")
  cfg.playerClass = select(2,UnitClass("player"))
  cfg.playerColor = RAID_CLASS_COLORS[cfg.playerclass]

  --backdrop
  cfg.backdrop = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }

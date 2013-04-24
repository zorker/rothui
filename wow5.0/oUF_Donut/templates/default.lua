
  ---------------------------------------------
  -- oUF_Donut
  -- default template

  -- it should be possible to apply a preset template to any ring
  -- template functions help registering templates

  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  --get the template lib
  local tmp = ns.tmp

  ----------------------------------------
  -- setup
  ----------------------------------------

  --    ring segment layout
  --     ____ ____
  --    /    |    \
  --    |  4 | 1  |
  --     ----+----
  --    |  3 | 2  |
  --    \____|____/
  --

  -- a get function is needed otherwise when using the template multiple times changes to the template would affect all units using the template

  tmp:RegisterTemplateByName("default", {
    --castring
    castring = {
      enable = true,
      radius = 0.9,     -- range 0-1
      textures = {
        bg    = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
        fill  = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
        spark = "Interface\\AddOns\\oUF_Donut\\media\\ring_spark",
      },
      colors = {
        bg        = { r=0, g=0, b=0, a=0.4, },
        fill      = { r=1, g=0.7, b=0, a=1, },
        spark     = { r=1, g=0.7, b=0, a=1, },
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
      enable = true,
      radius = 0.7,
      textures = {
        bg    = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
        fill  = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
        spark = "Interface\\AddOns\\oUF_Donut\\media\\ring_spark",
      },
      colors = {
        bg    = { r=0, g=0, b=0, a=1, },
        fill  = { r=0, g=0.7, b=1, a=1, },
        spark  = { r=0, g=0.7, b=1, a=1, },
        colorClass        = false,
        colorPower        = true,
      },
      numSegmentsUsed = 4,  -- how many sements are affected? (see ring layout)
      startSegment  = 4,    -- in which segment should the ring begin it's journey? (see ring layout)
      fillDirection = 0,    -- how should the ring fill up? 1 = clock-wise, 0 = counter-clock-wise
    },
    --healthring
    healthring = {
      enable = true,
      radius = 0.5,
      textures = {
        bg    = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
        fill  = "Interface\\AddOns\\oUF_Donut\\media\\ring_quarter",
        spark = "Interface\\AddOns\\oUF_Donut\\media\\ring_spark",
      },
      colors = {
        bg    = { r=0, g=0, b=0, a=1, },
        fill  = { r=0, g=0.8, b=0, a=1, },
        spark  = { r=0, g=1, b=0, a=1, },
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
  })

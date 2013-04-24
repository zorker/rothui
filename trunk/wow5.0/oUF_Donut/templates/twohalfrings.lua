
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

  tmp:RegisterTemplateByName("twohalfrings", {
    --castring
    castring = {
      enable = false,
    },
    --powerring
    powerring = {
      enable = true,
      radius = 0.9,
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
      numSegmentsUsed = 2,  -- how many sements are affected? (see ring layout)
      startSegment  = 2,    -- in which segment should the ring begin it's journey? (see ring layout)
      fillDirection = 0,    -- how should the ring fill up? 1 = clock-wise, 0 = counter-clock-wise
    },
    --healthring
    healthring = {
      enable = true,
      radius = 0.9,
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
      numSegmentsUsed = 2,  -- how many sements are affected? (see ring layout)
      startSegment  = 3,    -- in which segment should the ring begin it's journey? (see ring layout)
      fillDirection = 1,    -- how should the ring fill up? 1 = clock-wise, 0 = counter-clock-wise
    },
  })


  ---------------------------------------------
  --  oUF_Diablo - orbconfig
  ---------------------------------------------

  -- The following config allows setting up the orb animations
  -- This config is focus mainly on animations, textures, and colors, nothing else

  -- you can set up the animation for each class here

  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = ns.cfg

  --object container
  local orbcfg = {}
  ns.orbcfg = orbcfg

  ---------------------------------------------
  --WARRIOR
  ---------------------------------------------

  orbcfg["WARRIOR"] = {
    --health
    ["HEALTH"] = {
      --filling
      filling = {
        texture     = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15",
        color       = { r = 253/255, g = 58/255, b = 12/255, },
        colorClass  = false,  --important will override the color (obviously)
      },
      --animation
      animation = {
        enable  = true,
        id      = 23,
        alpha   = 1,
      },
      --galaxies
      galaxies = {},
      --spark
      spark = {
        alpha = 0.9,
        blendMode = "ADD",
      },
      --highlight
      highlight = {
        alpha = 1,
      },
    },--health end
    --power
    ["POWER"] = {
      --filling
      filling = {
        texture     = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15",
        color       = { r = 1, g = 0, b = 0, },
        colorPower  = false,  --important will override the color (obviously)
      },
      --animation
      animation = {
        enable  = true,
        id      = 20,
        alpha   = 1,
      },
      --galaxies
      galaxies  = {},
      --spark
      spark = {
        alpha = 0.9,
        blendMode = "ADD",
      },
      --highlight
      highlight = {
        alpha = 1,
      },
    },--power end
  } --warrior end


  ---------------------------------------------
  --HUNTER
  ---------------------------------------------

  orbcfg["HUNTER"] = {
    --health
    ["HEALTH"] = {
      --filling
      filling = {
        texture     = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15",
        color       = { r = 1, g = 0, b = 0, },
        colorClass  = false,  --important will override the color (obviously)
      },
      --animation
      animation = {
        enable  = false,
        id      = 19,
        alpha   = 1,
      },
      --galaxies
      galaxies = {},
      --spark
      spark = {
        alpha = 0.9,
        blendMode = "ADD",
      },
      --highlight
      highlight = {
        alpha = 0.8,
      },
    },--health end
    --power
    ["POWER"] = {
      --filling
      filling = {
        texture     = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15",
        color       = { r = 0, g = 0, b = 1, },
        colorPower  = false,  --important will override the color (obviously)
      },
      --animation
      animation = {
        enable  = false,
        id      = 19,
        alpha   = 1,
      },
      --galaxies
      galaxies  = {},
      --spark
      spark = {
        alpha = 0.9,
        blendMode = "ADD",
      },
      --highlight
      highlight = {
        alpha = 0.8,
      },
    },--power end
  } --hunter end

  ---------------------------------------------
  --DEFAULT
  ---------------------------------------------

  orbcfg["DEFAULT"] = {
    --health
    ["HEALTH"] = {
      --filling
      filling = {
        texture     = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15",
        color       = { r = 1, g = 0, b = 0, },
        colorClass  = true,  --important will override the color (obviously)
      },
      --animation
      animation = {
        enable  = true,
        id      = 19,
        alpha   = 1,
      },
      --galaxies
      galaxies = {},
      --spark
      spark = {
        alpha = 0.9,
        blendMode = "ADD",
      },
      --highlight
      highlight = {
        alpha = 1,
      },
    },--health end
    --power
    ["POWER"] = {
      --filling
      filling = {
        texture     = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15",
        color       = { r = 0, g = 0, b = 1, },
        colorPower  = true,  --important will override the color (obviously)
      },
      --animation
      animation = {
        enable  = true,
        id      = 19,
        alpha   = 1,
      },
      --galaxies
      galaxies  = {},
      --spark
      spark = {
        alpha = 0.9,
        blendMode = "ADD",
      },
      --highlight
      highlight = {
        alpha = 1,
      },
    },--power end
  } --default end


  ---------------------------------------------
  --ANIMATIONS
  ---------------------------------------------

  -- animation ID list
  -- 0  red fog           1  purple fog           2  green fog            3  yellow fog         4  turquoise fog
  -- 5  red portal        6  blue rune portal     7  red ghost            8  purple ghost       9  water planet
  -- 10 swirling cloud    11 white fog            12 red glowing eye      13 sandy swirl        14 green fire
  -- 15 purple swirl      16 white tornado        17 blue swirly          18 orange fog         19 pearl
  -- 20 red magnet        21 blue portal          22 purple portal        23 dwarf artifact     24 burning blob
  -- 25 fire              26 rolling purple       27 magic swirl          28 poison bubbles     29 cthun eye
  -- 30 soulshard purple  31 the planet           32 red chocolate

  --orb animation table
  cfg.animations = {
    [0]  = {displayInfo = 17010, camDistanceScale = 1.10, x =  0.00, y = -0.60, rotation =  0.00, },  -- red fog
    [1]  = {displayInfo = 17054, camDistanceScale = 1.10, x =  0.00, y = -0.60, rotation =  0.00, },  -- purple fog
    [2]  = {displayInfo = 17055, camDistanceScale = 1.10, x =  0.00, y = -0.60, rotation =  0.00, },  -- green fog
    [3]  = {displayInfo = 17286, camDistanceScale = 1.10, x =  0.00, y = -0.60, rotation =  0.00, },  -- yellow fog
    [4]  = {displayInfo = 18075, camDistanceScale = 1.10, x =  0.00, y = -0.60, rotation =  0.00, },  -- turquoise fog
    [5]  = {displayInfo = 23422, camDistanceScale = 2.80, x =  0.00, y =  0.10, rotation =  0.00, },  -- red portal
    [6]  = {displayInfo = 27393, camDistanceScale = 3.00, x =  0.00, y =  1.00, rotation =  0.00, },  -- blue rune portal
    [7]  = {displayInfo = 20894, camDistanceScale = 6.00, x = -0.30, y =  0.40, rotation =  0.00, },  -- red ghost
    [8]  = {displayInfo = 15438, camDistanceScale = 6.00, x = -0.30, y =  0.40, rotation =  0.00, },  -- purple ghost
    [9]  = {displayInfo = 20782, camDistanceScale = 1.20, x = -0.22, y =  0.18, rotation =  0.00, },  -- water planet
    [10] = {displayInfo = 23310, camDistanceScale = 3.50, x =  0.00, y =  3.00, rotation =  0.00, },  -- swirling cloud
    [11] = {displayInfo = 23343, camDistanceScale = 1.60, x = -0.20, y =  0.00, rotation =  0.00, },  -- white fog
    [12] = {displayInfo = 24813, camDistanceScale = 2.40, x =  0.00, y = -0.30, rotation =  0.00, },  -- red glowing eye
    [13] = {displayInfo = 25392, camDistanceScale = 2.60, x =  0.00, y = -0.50, rotation =  0.00, },  -- sandy swirl
    [14] = {displayInfo = 27625, camDistanceScale = 0.80, x =  0.00, y =  0.00, rotation =  0.00, },  -- green fire
    [15] = {displayInfo = 28460, camDistanceScale = 0.56, x = -0.40, y =  0.00, rotation =  0.00, },  -- purple swirl
    [16] = {displayInfo = 29286, camDistanceScale = 0.60, x = -0.60, y = -0.20, rotation =  0.00, },  -- white tornado
    [17] = {displayInfo = 29561, camDistanceScale = 2.50, x =  0.00, y =  0.00, rotation = -3.90, },  -- blue swirly
    [18] = {displayInfo = 30660, camDistanceScale = 0.12, x = -0.04, y = -0.08, rotation =  0.00, },  -- orange fog
    [19] = {displayInfo = 32368, camDistanceScale = 1.15, x =  0.00, y =  0.40, rotation =  0.00, },  -- pearl
    [20] = {displayInfo = 33853, camDistanceScale = 0.83, x =  0.00, y = -0.05, rotation =  0.00, },  -- red magnet
    [21] = {displayInfo = 34319, camDistanceScale = 1.55, x =  0.00, y =  0.80, rotation =  0.00, },  -- blue portal
    [22] = {displayInfo = 34645, camDistanceScale = 1.70, x =  0.00, y =  0.80, rotation =  0.00, },  -- purple portal
    [23] = {displayInfo = 38699, camDistanceScale = 0.28, x =  0.00, y =  0.00, rotation =  0.00, },  -- dwarf floarting artifact (red glow)
    [24] = {displayInfo = 38548, camDistanceScale = 0.80, x = -0.10, y = -0.10, rotation =  0.00, },  -- burning blob from hell
    [25] = {displayInfo = 38327, camDistanceScale = 3.35, x = -0.30, y = -7.00, rotation = -9.40, },  -- fire
    [26] = {displayInfo = 39108, camDistanceScale = 0.80, x =  0.00, y =  0.00, rotation =  0.00, },  -- top down rotation purple (warlock color)
    [27] = {displayInfo = 39581, camDistanceScale = 3.50, x =  0.00, y =  2.00, rotation =  0.00, },  -- magic swirl
    [28] = {displayInfo = 37939, camDistanceScale = 1.00, x =  0.00, y =  2.00, rotation =  0.00, },  -- poison bubbles
    [29] = {displayInfo = 37867, camDistanceScale = 0.75, x =  0.00, y =  0.80, rotation =  0.00, },  -- cthun eye
    [30] = {displayInfo = 45414, camDistanceScale = 0.25, x =  0.00, y = -0.22, rotation =  0.00, },  -- soulshard purple portal
    [31] = {displayInfo = 44652, camDistanceScale = 0.65, x =  0.05, y =  0.01, rotation =  0.00, },  -- the planet
    [32] = {displayInfo = 47882, camDistanceScale = 0.65, x = -0.02, y = -0.96, rotation =  0.00, },  -- red chocolate
  }
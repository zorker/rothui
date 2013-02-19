
  ---------------------------------------------
  --  oUF_Diablo - db
  ---------------------------------------------

  -- Database (DB)

  ---------------------------------------------

  --get the addon namespace
  local addon, ns = ...

  --object container
  local db = CreateFrame("Frame")
  ns.db = db
  db.default = {}
  db.list = {}

  --load the character settings
  db:SetScript("OnEvent", function(self, event)
    return self[event](self)
  end)
  db:RegisterEvent("VARIABLES_LOADED")
  function db:VARIABLES_LOADED()
    self.char = OUF_DIABLO_DB_CHAR
    if not self.char then self.loadDefaults() end
    --self.loadDefaults()
    print(addon..": database loaded")
    self:UnregisterEvent("VARIABLES_LOADED")
  end

  db.loadDefaults = function()
    print(addon..": database defaults loaded")
    OUF_DIABLO_DB_CHAR = db.default.orb
    db.char = OUF_DIABLO_DB_CHAR
    --print(self.char)
  end

  ---------------------------------------------
  --DEFAULT
  ---------------------------------------------

  db.default.orb = {
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
        enable            = true,
        displayInfo       = 32368,
        camDistanceScale  = 1.15,
        pos_x             = 0,
        pos_y             = 0.4,
        rotation          = 0,
        portraitZoom      = 1,
        alpha             = 1,
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
        alpha = 0.3,
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
        enable            = true,
        displayInfo       = 32368,
        camDistanceScale  = 1.15,
        pos_x             = 0,
        pos_y             = 0.4,
        rotation          = 0,
        portraitZoom      = 1,
        alpha             = 1,
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
        alpha = 0.3,
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
  db.list.model = {
    { value = 17010, key = "red fog", },
    { value = 17054, key = "purple fog", },
    { value = 17055, key = "green fog", },
    { value = 17286, key = "yellow fog", },
    { value = 18075, key = "turquoise fog", },
    { value = 23422, key = "red portal", },
    { value = 27393, key = "blue rune portal", },
    { value = 20894, key = "red ghost", },
    { value = 15438, key = "purple ghost", },
    { value = 20782, key = "water planet", },
    { value = 23310, key = "swirling cloud", },
    { value = 23343, key = "white fog", },
    { value = 24813, key = "red eye", },
    { value = 25392, key = "sahara", },
    { value = 27625, key = "green fire", },
    { value = 28460, key = "purple swirly", },
    { value = 29286, key = "white tornado", },
    { value = 29561, key = "blue swirly", },
    { value = 30660, key = "orange fog", },
    { value = 32368, key = "pearl", },
    { value = 33853, key = "red magnet", },
    { value = 34319, key = "blue portal", },
    { value = 34645, key = "purple portal", },
    { value = 38699, key = "dwarf artifact", },
    { value = 38548, key = "burning blob", },
    { value = 38327, key = "fire", },
    { value = 39108, key = "purple circus", },
    { value = 39581, key = "magic swirly", },
    { value = 37939, key = "poison", },
    { value = 37867, key = "cthun", },
    { value = 45414, key = "soulshard", },
    { value = 44652, key = "the planet", },
    { value = 47882, key = "red chocolate", },
  }

  ---------------------------------------------
  --FILLING TEXTURES
  ---------------------------------------------

  db.list.filling_texture = {
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling1",  key = "moon", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling2",  key = "earth", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling3",  key = "mars", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling4",  key = "galaxy", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling5",  key = "jupiter", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling6",  key = "fraktal circle", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling7",  key = "sun", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling8",  key = "icecream", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling9",  key = "marble", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling10", key = "gradient", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling11", key = "bubbles", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling12", key = "woodpepples", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling13", key = "golf", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling14", key = "diablo mars", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15", key = "diablo3", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling16", key = "fubble", },
  }
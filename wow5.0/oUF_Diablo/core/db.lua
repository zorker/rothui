
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

  local wipe    = wipe
  local tinsert = tinsert
  local tremove = tremove
  local strlower = strlower

  ---------------------------------------------
  --DEFAULTS
  ---------------------------------------------

  --default orb setup
  function db:GetOrbDefaults()
    return {
      --health
      ["HEALTH"] = {
        --filling
        filling = {
          texture     = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15",
          color       = { r = 1, g = 0, b = 0, },
          colorAuto   = false, --automatic coloring based on class/powertype
        },
        --model
        model = {
          enable            = false,
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
        },
        --highlight
        highlight = {
          alpha = 0.3,
        },
        --value
        value = {
          alphaOnMouseOver = 1,
          alphaOnMouseOut = 1,
          hideOnEmpty = true,
          hideOnFull = false,
          top = {
            color = { r = 1, g = 1, b = 1, },
            tag = "[diablo:healthorbtop]",
          },
          bottom = {
            color = { r = 0.8, g = 0.8, b = 0.8, },
            tag = "[diablo:healthorbbottom]",
          },
        },
      },--health end
      --power
      ["POWER"] = {
        --filling
        filling = {
          texture     = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15",
          color       = { r = 0, g = 0, b = 1, },
          colorAuto   = false, --automatic coloring based on class/powertype
        },
        --model
        model = {
          enable            = false,
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
        },
        --highlight
        highlight = {
          alpha = 0.3,
        },
        --value
        value = {
          alphaOnMouseOver = 1,
          alphaOnMouseOut = 1,
          hideOnEmpty = true,
          hideOnFull = false,
          top = {
            color = { r = 1, g = 1, b = 1, },
            tag = "[diablo:powerorbtop]",
          },
          bottom = {
            color = { r = 0.8, g = 0.8, b = 0.8, },
            tag = "[diablo:powerorbbottom]",
          },
        },
      },--power end
    } --default end
  end

  --load the default config on loadup so the rest can initialize, the view will get updated later once the saved variables are fetched
  db.char = db:GetOrbDefaults()

  --default template
  function db:GetTemplateDefaults()
    return {
      ["pearl"] = {
        --filling
        filling = {
          texture     = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15",
          color       = { r = 0.8, g = 0.8, b = 1, },
          colorAuto   = false, --automatic coloring based on class/powertype
        },
        --model
        model = {
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
        },
        --highlight
        highlight = {
          alpha = 0.3,
        },
      },
    }
  end

  function db:GetTemplateListDefaults()
    return {
      { value = "pearl", key = "pearl", notCheckable = true, keepShownOnClick = false, },
    }
  end

  ---------------------------------------------
  --LOAD SAVED VARIABLES
  ---------------------------------------------

  --db script on variables loaded
  db:SetScript("OnEvent", function(self, event)
    --load global data
    self.loadGlobalData()
    --load character data
    if not OUF_DIABLO_DB_CHAR then
      self.loadCharacterDataDefaults()
    else
      self.loadCharacterData()
    end
    self:UnregisterEvent("VARIABLES_LOADED")
  end)
  db:RegisterEvent("VARIABLES_LOADED")

  ---------------------------------------------
  --DB RESET
  ---------------------------------------------

  --full database reset
  db.dropDatabase = function(noReload)
    OUF_DIABLO_DB_CHAR = db:GetOrbDefaults()
    OUF_DIABLO_DB_GLOB = db:GetTemplateDefaults()
    OUF_DIABLO_DB_GLOB.TEMPLATE_LIST = db:GetTemplateListDefaults()
    if noReload then return end
    ReloadUI()
  end

  ---------------------------------------------
  --CHARACTER DATA
  ---------------------------------------------

  --load character data defaults
  db.loadCharacterDataDefaults = function(type)
    local data = db:GetOrbDefaults()
    if type then
      if type == "HEALTH" then
        OUF_DIABLO_DB_CHAR[type] = data[type]
        print(addon..": health orb reseted to default")
      elseif type == "POWER" then
        OUF_DIABLO_DB_CHAR[type] = data[type]
        print(addon..": power orb reseted to default")
      end
    else
      OUF_DIABLO_DB_CHAR = data
      print(addon..": character data reset to default")
    end
    db.char = OUF_DIABLO_DB_CHAR
    --update the orb view
    ns.panel.updateOrbView()
  end

  --load character data
  db.loadCharacterData = function()
    db.char = OUF_DIABLO_DB_CHAR
    --update the orb view
    ns.panel.updateOrbView()
  end

  ---------------------------------------------
  --GLOBAL DATA
  ---------------------------------------------

  --load global data defaults
  db.loadGlobalDataDefaults = function()
    print(addon..": global data defaults loaded")
    OUF_DIABLO_DB_GLOB = db:GetTemplateDefaults()
    OUF_DIABLO_DB_GLOB.TEMPLATE_LIST = db:GetTemplateListDefaults()
    db.glob = OUF_DIABLO_DB_GLOB
    db.list.template = OUF_DIABLO_DB_GLOB.TEMPLATE_LIST
  end

  --load global data
  db.loadGlobalData = function()
    OUF_DIABLO_DB_GLOB = OUF_DIABLO_DB_GLOB or db:GetTemplateDefaults()
    OUF_DIABLO_DB_GLOB.TEMPLATE_LIST = OUF_DIABLO_DB_GLOB.TEMPLATE_LIST or db:GetTemplateListDefaults()
    db.glob = OUF_DIABLO_DB_GLOB
    db.list.template = OUF_DIABLO_DB_GLOB.TEMPLATE_LIST
  end

  ---------------------------------------------
  --TEMPLATES
  ---------------------------------------------

  function db:CopyTable(source, target)
    for key, value in pairs(source) do
      if type(value) == "table" then
        target[key] = {}
        self:CopyTable(value, target[key])
      else
        target[key] = value
      end
    end
  end

  --load template func
  --name: template name
  --type: orb type
  db.loadTemplate = function(name,type)
    if not OUF_DIABLO_DB_GLOB or not name then return end
    if not OUF_DIABLO_DB_GLOB[name] then
      print(addon..": template |c003399FF"..name.."|r not found")
      return
    end
    db:CopyTable(OUF_DIABLO_DB_GLOB[name],OUF_DIABLO_DB_CHAR[type])
    print(addon..": template |c003399FF"..name.."|r loaded into "..strlower(type).." orb")
    --update the orb view
    ns.panel.updateOrbView()
  end

  --save template func
  --name: template name
  --type: orb type
  db.saveTemplate = function(name,type)
    if not OUF_DIABLO_DB_GLOB or not name then return end
    --adding template
    if not OUF_DIABLO_DB_GLOB[name] then
      --create default entry first
      local data = db:GetOrbDefaults()
      OUF_DIABLO_DB_GLOB[name] = data["HEALTH"]
    end
    db:CopyTable(db.char[type],OUF_DIABLO_DB_GLOB[name])
    --adding the template name to the key-value pair list
    local nameFound = false
    for i,v in ipairs(OUF_DIABLO_DB_GLOB.TEMPLATE_LIST) do
      if v.key == name then
        nameFound = true
        break
      end
    end
    if not nameFound then
      tinsert(OUF_DIABLO_DB_GLOB.TEMPLATE_LIST, { key = name, value = name, notCheckable = true, keepShownOnClick = false, })
    end
    print(addon..": "..strlower(type).." orb data saved as template |c003399FF"..name.."|r")
    --update the panel view
    ns.panel.updatePanelView()
  end

  --delete template func
  --name: template name
  db.deleteTemplate = function(name)
    if not OUF_DIABLO_DB_GLOB or not name then return end
    if not OUF_DIABLO_DB_GLOB[name] then
      print(addon..": template |c003399FF"..name.."|r not found")
      return
    end
    --setting the template to nil
    OUF_DIABLO_DB_GLOB[name] = nil
    print(addon..": template |c003399FF"..name.."|r deleted")
    --removing the template name from the key-value pair list
    local indexFound
    for i,v in ipairs(OUF_DIABLO_DB_GLOB.TEMPLATE_LIST) do
      if v.key == name then
        indexFound = i
        break
      end
    end
    if indexFound then
      tremove(OUF_DIABLO_DB_GLOB.TEMPLATE_LIST, indexFound)
    end
    --update the panel view
    ns.panel.updatePanelView()
  end

  ---------------------------------------------
  --LIST / MODELS
  ---------------------------------------------

  --mode list for dropdown
  db.list.model = {
    {
      key = "orbtacular",
      value = "orbtacular",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 48109, key = "purble flash orb", },
        { value = 48106, key = "blue flash orb", },
        { value = 32368, key = "pearl", },
        { value = 44652, key = "the planet", },
        { value = 47882, key = "red chocolate", },
        { value = 33853, key = "red magnet", },
        { value = 34404, key = "white magnet", },
        { value = 38699, key = "dwarf artifact", },
        { value = 20782, key = "water planet", },
        { value = 25392, key = "sahara", },
        { value = 37867, key = "cthun", },
        { value = 39108, key = "purple circus", },
        { value = 16111, key = "spore", },
        { value = 22707, key = "snow ball", },
        { value = 29308, key = "death ball", },
        { value = 25889, key = "sphere", },
        { value = 28741, key = "titan orb", },
        { value = 42486, key = "force sphere", },
        { value = 45414, key = "soulshard", },
      },
    },
    {
      key = "fog",
      value = "fog",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 17010, key = "red fog", },
        { value = 17054, key = "purple fog", },
        { value = 17055, key = "green fog", },
        { value = 17286, key = "yellow fog", },
        { value = 18075, key = "turquoise fog", },
        { value = 23343, key = "white fog", },
      },
    },
    {
      key = "portal",
      value = "portal",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 23422, key = "red portal", },
        { value = 34319, key = "blue portal", },
        { value = 34645, key = "purple portal", },
        { value = 29074, key = "warlock portal", },
        { value = 40645, key = "soul harvest", },
      },
    },
    {
      key = "swirly",
      value = "swirly",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 27393, key = "blue rune swirly", },
        { value = 28460, key = "purple swirly", },
        { value = 29561, key = "blue swirly", },
        { value = 29286, key = "white swirly", },
        { value = 39581, key = "magic swirly", },
        { value = 23310, key = "swirly cloud", },
      },
    },
    {
      key = "fire",
      value = "fire",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 27625, key = "green fire", },
        { value = 38327, key = "fire", },
        { value = 28639, key = "green vapor", },
      },
    },
    {
      key = "elemental",
      value = "elemental",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 17065, key = "purple naaru", },
        { value = 17871, key = "white naaru", },
        { value = 1070,  key = "fire elemental", },
        { value = 14252, key = "purple elemental", },
        { value = 19003, key = "white elemental", },
        { value = 15406, key = "light-green elemental", },
        { value = 17045, key = "red elemental", },
        { value = 9449,  key = "green elemental", },
        { value = 4629,  key = "shadow elemental", },
        { value = 22731, key = "glow elemental", },
        { value = 16635, key = "void walker", },
        { value = 16170, key = "green ghost", },
        { value = 24905, key = "fire guard", },
        { value = 31450, key = "flaming bone guard", },
        { value = 34942, key = "bound fire elemental", },
        { value = 36345, key = "bound water elemental", },
      },
    },
    {
      key = "crystal",
      value = "crystal",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 17856, key = "blue crystal", },
        { value = 20900, key = "green crystal", },
        { value = 22506, key = "purple crystal", },
        { value = 26419, key = "health crystal", },
        { value = 26418, key = "power crystal", },
      },
    },
    {
      key = "aquarium",
      value = "aquarium",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 4878,  key = "fish", },
        { value = 7449,  key = "deviat", },
      },
    },
    {
      key = "unique",
      value = "unique",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 10992, key = "diablo", },
        { value = 38803, key = "murcablo", },
        { value = 5233,  key = "blue angel", },
        { value = 6888,  key = "alarm-o-bot", },
        { value = 11986, key = "molten giant", },
        { value = 38594, key = "magma giant", },
        { value = 28641, key = "algalon", },
        { value = 31094, key = "spectral bear", },
        { value = 28890, key = "mimiron head", },
        { value = 32913, key = "therazane", },
        { value = 38150, key = "fire kitten", },
        { value = 38187, key = "orange fire helldog", },
        { value = 38189, key = "blue fire helldog", },
        { value = 39354, key = "deathwing lava claw", },
        { value = 40924, key = "cranegod", },
        { value = 38548, key = "burning blob", },
        { value = 1824,  key = "blue wisp", },
      },
    },
    {
      key = "sparkling",
      value = "sparkling",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 26753, key = "spark", },
        { value = 27617, key = "yellow spark", },
        { value = 46920, key = "purple splash", },
        { value = 48210, key = "yellow plasma", },
        { value = 29612, key = "strobo", },
        { value = 41110, key = "strobo2", },
        { value = 44465, key = "strobo3", },
        { value = 30792, key = "hammer of wrath", },
      },
    },
    {
      key = "spirit",
      value = "spirit",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 2421,  key = "killrock eye", },
        { value = 46174, key = "darkmoon eye", },
        { value = 21485, key = "blue soul", },
        { value = 30150, key = "red soul", },
        { value = 39740, key = "red spirit", },
        { value = 39738, key = "blue spirit", },
        { value = 28089, key = "ghost skull", },
      },
    },
    {
      key = "environment",
      value = "environment",
      hasArrow = true,
      notCheckable = true,
      menuList = {
        { value = 35741, key = "fire flower", },
        { value = 36405, key = "oasis flower", },
        { value = 42785, key = "icethorn flower", },
        { value = 39014, key = "purple mushroom", },
        { value = 36901, key = "purple lantern", },
        { value = 36902, key = "turquoise lantern", },
        { value = 31905, key = "purple egg", },
        { value = 34010, key = "orange egg", },
        { value = 26506, key = "bubble torch", },
        { value = 41853, key = "onyx statue", },
      },
    },
  }
  db.getListModel = function() return db.list.model end

  ---------------------------------------------
  --LIST / FILLING TEXTURES
  ---------------------------------------------

  --filling texture list for dropdown
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
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling14", key = "darkstar", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling15", key = "diablo3", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling16", key = "fubble", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling17", key = "silver", },
    { value = "Interface\\AddOns\\oUF_Diablo\\media\\orb_filling18", key = "exile", },
  }
  db.getListFillingTexture = function() return db.list.filling_texture end

  ---------------------------------------------
  --LIST / TEMPLATEs
  ---------------------------------------------

  db.list.template = {} --reference for later
  db.getListTemplate = function() return db.list.template end
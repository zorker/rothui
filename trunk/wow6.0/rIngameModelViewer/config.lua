
  -------------------------------------
  -- ADDON TABLES
  -------------------------------------

  local an, at = ...

  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- local variables
  local G, L, C = at.G, at.L, at.C

  -------------------------------------
  -- CONFIG
  -------------------------------------

  C.sound = {}
  C.sound.select =  "igcreatureaggroselect"
  C.sound.swap    = "interfacesound_losttargetunit"
  C.sound.click   = "igmainmenuoption"
  C.sound.clack   = "igmainmenulogout"

  C.modelBackgroundColor = {1,1,1}

  C.defaultmodel = "interface\\buttons\\talktomequestionmark.m2"

  C.backdrop = {
    bgFile = "",
    edgeFile = "interface\\tooltips\\ui-tooltip-border",
    tile = false,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }


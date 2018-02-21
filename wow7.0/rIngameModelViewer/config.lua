
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
  C.sound.select =  SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
  C.sound.swap    = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
  C.sound.click   = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
  C.sound.clack   = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON

  C.backdrop = {
    bgFile = "",
    edgeFile = "interface\\tooltips\\ui-tooltip-border",
    tile = false,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }


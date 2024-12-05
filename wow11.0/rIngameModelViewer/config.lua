-- rIngameModelViewer - config
-- zork 2024
-----------------------------
-- Variables
-----------------------------
local A, L = ...

L.C.sound = {}
L.C.sound.select = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
L.C.sound.swap = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
L.C.sound.click = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
L.C.sound.clack = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON

L.C.backdrop = {
  bgFile = "",
  edgeFile = "edgeFile",
  tile = false,
  tileEdge = false,
  tileSize = 16,
  edgeSize = 16,
  insets = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4
  }
}

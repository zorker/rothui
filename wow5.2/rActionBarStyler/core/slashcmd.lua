
  -----------------------------
  -- INIT
  -----------------------------

  --addon namespace
  local addon, ns = ...

  --variables
  local dragFrameList = {}
  local color         = "0000FF00"
  local shortcut      = "rabs"

  --make variables available in the namespace
  ns.dragFrameList    = dragFrameList
  ns.addonColor       = color
  ns.addonShortcut    = shortcut

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  SlashCmdList[shortcut] = rCreateSlashCmdFunction(addon, shortcut, dragFrameList, color)
  SLASH_rabs1 = "/"..shortcut; --the value in the between SLASH_ and NUMBER has to match the value of shortcut

  print("|c"..color..addon.." loaded.|r")
  print("|c"..color.."\/"..shortcut.."|r to display the command list")
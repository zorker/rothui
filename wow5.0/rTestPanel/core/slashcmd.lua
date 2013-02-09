
  -- // rTestPanel - Slashcmd
  -- // zork - 2013

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...

  local redColor = "00FF0000"
  local highlightColor = "003399FF"

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --checks
  if not ns.mainFrame then return end

  local slashCmdFunction = function(cmd)
    if not IsAddOnLoaded(addon) then
      print("|c"..redColor..addon.." is not loaded.|r")
      return
    end
    if InCombatLockdown() then
      print("|c"..redColor..addon.." cannot be toggled in combat.|r")
      return
    end
    if ns.mainFrame:IsShown() then
      ns.mainFrame:Hide()
      print("Hiding mainFrame of "..addon..".")
    else
      ns.mainFrame:Show()
      print("Showing mainFrame of "..addon..".")
    end
  end

  SlashCmdList[addon] = slashCmdFunction

  --important this line has to be hardcoded, make sure to fill in the correct addon name "SLASH_"..NAMEOFYOURADDON.."1"
  SLASH_rTestPanel1 = "/"..ns.cfg.slashCommand

  print("|c"..highlightColor..addon.."|r has loaded.")
  print("Use \/|c"..highlightColor..ns.cfg.slashCommand.."|r to toggle the panel.")


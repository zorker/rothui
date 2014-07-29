
  -- rIngameModelViewer
  -- zork 2014

  -------------------------------------
  -- ADDON TABLES
  -------------------------------------

  local an, at = ...

  at.G = {} --global (if any)
  at.L = {} --local
  at.C = {} --config
  at.M = {} --models

  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- local variables
  local G, L, C, M = at.G, at.L, at.C, at.M

  -- version stuff
  L.name          = an
  L.version       = GetAddOnMetadata(L.name, "Version")
  L.versionNumber = tonumber(L.version)
  L.locale        = GetLocale()

  local math = math

  -------------------------------------
  -- CONFIG
  -------------------------------------

  C.thumbSize = 200
  C.page = 1
  C.num = 0
  C.rows = 0
  C.cols = 0

  C.sound = {}
  C.sound.swap    = "INTERFACESOUND_LOSTTARGETUNIT"
  C.sound.select  = "igMainMenuOption"
  C.sound.close   = "igMainMenuLogout";

  -------------------------------------
  -- FUNCTIONS
  -------------------------------------

  --round number func
  function L:RoundNumber(n)
    return math.floor((n)*10)/10
  end

  --calc page for displayid func
  function L:CalcPageForDisplayID(displayid)
    return math.ceil(displayid/C.num)
  end

  --calc first displayid of page func
  function L:CalcFirstDisplayIdOfPage()
    return ((C.page*C.num)+1)-C.num
  end

  --init func
  function L:Init ()

    L.canvas = CreateFrame("Frame",nil,UIParent)


    local b = rIMV_createHolderFrame()
    rIMV_createTheatreFrame(b)
    rIMV_createIcon(b)
    rIMV_createMenu(b)
    b:Hide()
    b.theatre:Hide()
  end

  -------------------------------------
  -- CALL
  -------------------------------------

  --init
  L:Init()
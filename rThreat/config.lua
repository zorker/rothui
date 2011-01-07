
  -- // rFilter3
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  -----------------------------
  -- CONFIG
  -----------------------------  

  cfg.title {
    height    = 16,
    font      = "Fonts\\FRIZQT__.ttf",
    fontsize  = 14,
    outline   = "THINOUTLINE",
  }

  cfg.statusbars {
    count     = 6, --how many statusbars should be created?
    width     = 200,
    height    = 16,
    font      = "Fonts\\FRIZQT__.ttf",
    fontsize  = 12,
    outline   = "THINOUTLINE",
    texture   = "sdasdad",
    gap       = 1, --gap between bars
  }

  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --object container to addon namespace
  ns.cfg = cfg
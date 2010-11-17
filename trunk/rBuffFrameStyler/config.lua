
  -- // rBuffFrameStyler
  -- // zork - 2010

  -----------------------------
  -- INIT
  -----------------------------
  
  --get the addon namespace
  local addon, ns = ...
  
  --generate a holder for the config data
  local cfg = CreateFrame("Frame")
  
  -----------------------------
  -- CONFIG
  -----------------------------
  
  cfg.buffframe = {
    scale           = 1,
    pos             = { a1 = "CENTER", af = "UIParent", a2 = "CENTER", x = 0, y = 100 }, 
    userplaced      = true, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rbuff
    rowSpacing      = 10,
    colSpacing      = 10,
    buffsPerRow     = 10,
  }

  cfg.tempenchant = {
    scale           = 1,
    pos             = { a1 = "CENTER", af = "UIParent", a2 = "CENTER", x = 0, y = 0 }, 
    userplaced      = true, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rbuff
  }  
  
  cfg.textures = {
    normal            = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss",
    outer_shadow      = "Interface\\AddOns\\rActionButtonStyler\\media\\outer_shadow",
  }
  
  cfg.background = {
    showshadow        = true,   --show an outer shadow?
    shadowcolor       = { r = 0, g = 0, b = 0, a = 0.9},
    inset             = 5, 
  }
  
  cfg.color = {
    normal            = { r = 0.37, g = 0.3, b = 0.3, },
    classcolored      = false,
  }
  
  cfg.duration = {
    fontsize        = 12,
    pos             = { a1 = "BOTTOM", x = 0, y = 0 }, 
  }
  
  cfg.count = {
    fontsize        = 12,
    pos             = { a1 = "TOPRIGHT", x = 0, y = 0 }, 
  }
  
  cfg.font = "Fonts\\FRIZQT__.TTF"

  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg

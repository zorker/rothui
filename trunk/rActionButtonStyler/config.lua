  
  -- // rActionButtonStyler
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
  
  cfg.textures = {
    normal            = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss",
    flash             = "Interface\\AddOns\\rActionButtonStyler\\media\\flash",
    hover             = "Interface\\AddOns\\rActionButtonStyler\\media\\hover",
    pushed            = "Interface\\AddOns\\rActionButtonStyler\\media\\pushed",
    checked           = "Interface\\AddOns\\rActionButtonStyler\\media\\checked",
    equipped          = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss_grey",
  }
  
  cfg.color = {
    normal            = { r = 0.37, g = 0.3, b = 0.3, },
    equipped          = { r = 0.1, g = 0.5, b = 0.1, },
    classcolored      = false,    
  }
  
  cfg.hotkeys = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "TOPRIGHT", x = 0, y = 0 }, 
    pos2             = { a1 = "TOPLEFT", x = 0, y = 0 }, --important! two points are needed to make the hotkeyname be inside of the button
  }
  
  cfg.macroname = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "BOTTOMLEFT", x = 0, y = 0 }, 
    pos2             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, --important! two points are needed to make the macroname be inside of the button
  }
  
  cfg.itemcount = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, 
  }
  
  cfg.cooldown = {
    spacing         = 0,
  }
  
  cfg.font = "Fonts\\FRIZQT__.TTF"

  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg

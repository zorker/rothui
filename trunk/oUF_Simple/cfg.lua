  
  -- // oUF tutorial layout
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
  
  --config variables
  cfg.showplayer = true
  cfg.showtarget = true
  cfg.showtot = true
  cfg.showpet = true
  cfg.showfocus = true
  cfg.allow_frame_movement = true
  cfg.frames_locked = false 
  
  cfg.statusbar_texture = "Interface\\AddOns\\oUF_Simple\\media\\statusbar512x64"
  cfg.backdrop_texture = "Interface\\AddOns\\oUF_Simple\\media\\backdrop"
  cfg.backdrop_edge_texture = "Interface\\AddOns\\oUF_Simple\\media\\backdrop_edge"
  cfg.font = "FONTS\\FRIZQT__.ttf"   
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg

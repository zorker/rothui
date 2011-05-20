  
  -- // oUF_Simple2, an oUF tutorial layout
  -- // zork - 2011
  
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
  
  cfg.useRaidLayoutInParty  = true
  
  --config variables
  cfg.player = {
    show            = true,
    width           = 270,
    height          = 25,
  }
  
  cfg.target = {
    show            = true,
    width           = 270,
    height          = 25,
  }

  cfg.tot = {
    show            = true,
    width           = 150,
    height          = 25,
    hptag           = "[simple:hpperc]",
  }
  
  cfg.pet = {
    show            = true,
    width           = 180,
    height          = 25,
  }
  
  cfg.focus = {
    show            = true,
    width           = 180,
    height          = 25,
  }

  cfg.party = {
    show            = true,
    width           = 180,
    height          = 25,
  }  
  
  cfg.raid = {
    show            = true,
    width           = 100,
    height          = 30,
    hptag           = "[simple:hpraid]",
  }

  cfg.partypet = {
    show            = true,
    --party and raid pets spawned with the raid style
  }

  
  cfg.statusbar_texture = "Interface\\AddOns\\oUF_Simple2\\media\\statusbar"
  cfg.backdrop_texture = "Interface\\AddOns\\oUF_Simple2\\media\\backdrop"
  cfg.backdrop_edge_texture = "Interface\\AddOns\\oUF_Simple2\\media\\backdrop_edge"
  cfg.font = "FONTS\\FRIZQT__.ttf"   
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg


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

  --config variables
  cfg.showplayer = true
  cfg.showtarget = true
  cfg.showtot = true
  cfg.showpet = true
  cfg.showfocus = true
  cfg.showparty = true
  cfg.showraid = true

  cfg.hideportraits = true

  cfg.statusbar_texture = "Interface\\AddOns\\oUF_Simple3\\media\\statusbar2"
  cfg.backdrop_texture = "Interface\\AddOns\\oUF_Simple3\\media\\backdrop"
  cfg.backdrop_edge_texture = "Interface\\AddOns\\oUF_Simple3\\media\\backdrop_edge"
  cfg.debuff_highlight_texture = "Interface\\AddOns\\oUF_Simple3\\media\\debuff_highlight"
  cfg.font = "Interface\\AddOns\\oUF_Simple3\\media\\ExpresswayRg.ttf"

  -----------------------------
  -- HANDOVER
  -----------------------------

  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg

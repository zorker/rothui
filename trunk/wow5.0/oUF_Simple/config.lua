
  -- // oUF_Simple2, an oUF tutorial layout
  -- // zork - 2011

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  --generate a holder for the config data
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  -----------------------------
  -- CONFIG
  -----------------------------

  --config variables
  cfg.showplayer = true
  cfg.showtarget = true
  cfg.showtot = true
  cfg.showpet = true
  cfg.showfocus = true

  cfg.hideportraits = false
  cfg.unitscale = 0.82

  cfg.statusbar_texture = "Interface\\AddOns\\oUF_Simple\\media\\statusbar2"
  cfg.backdrop_texture = "Interface\\AddOns\\oUF_Simple\\media\\backdrop"
  cfg.backdrop_edge_texture = "Interface\\AddOns\\oUF_Simple\\media\\backdrop_edge"
  cfg.debuff_highlight_texture = "Interface\\AddOns\\oUF_Simple\\media\\debuff_highlight"
  cfg.font = "Interface\\AddOns\\oUF_Simple\\media\\ExpresswayRg.ttf"

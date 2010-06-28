
local backdrop_bg_tex = "Interface\\AddOns\\myAddon\\backdrop"
local backdrop_edge_tex = "Interface\\AddOns\\myAddon\\backdrop_edge"

local backdrop_tab = { 
  bgFile = backdrop_bg_tex, 
  edgeFile = backdrop_edge_tex, 
  tile = true,
  tileSize = 16, 
  edgeSize = 16, 
  insets = { 
    left = 0, 
    right = 0, 
    top = 0, 
    bottom = 0,
  },
}

local function do_me_a_backdrop(f)
  f:SetBackdrop(backdrop_tab);
  f:SetBackdropColor(0,0,0,0.5)
  f:SetBackdropBorderColor(0,0,0,1)
end
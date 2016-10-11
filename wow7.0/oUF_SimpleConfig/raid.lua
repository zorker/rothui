
-- oUF_SimpleConfig: raid
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Raid Config
-----------------------------

L.C.raid = {
  enabled = true,
  size = {130*L.C.uiscale,26*L.C.uiscale},
  points = { --list of 8 points, one for each raid group
    {"TOPLEFT",20,-20},
    {"LEFT", "oUF_SimpleRaidHeader1", "RIGHT" 20, 0},
    {"LEFT", "oUF_SimpleRaidHeader2", "RIGHT" 20, 0},
    {"LEFT", "oUF_SimpleRaidHeader3", "RIGHT" 20, 0},
    {"TOP", "oUF_SimpleRaidHeader1", "BOTTOM" 0, 20},
    {"LEFT", "oUF_SimpleRaidHeader5", "RIGHT" 20, 0},
    {"LEFT", "oUF_SimpleRaidHeader6", "RIGHT" 20, 0},
    {"LEFT", "oUF_SimpleRaidHeader7", "RIGHT" 20, 0},
  },
  scale = 1,
  --healthbar
  healthbar = {
    --health and absorb bar cannot be disabled, they match the size of the frame
    colorDisconnected = true,
    colorClass = true,
    colorReaction = true,
    colorHealth = true,
    colorThreat = true,
    name = {
      enabled = true,
      points = {
        {"LEFT",2*L.C.uiscale,0*L.C.uiscale},
        {"RIGHT",-2*L.C.uiscale,0*L.C.uiscale},
      },
      size = 16*L.C.uiscale,
      align = "CENTER",
      tag = "[name]",
    },
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18*L.C.uiscale,18*L.C.uiscale},
    point = {"CENTER","LEFT",0,0},
  },
  setup = {
    template = nil,
    visibility = "custom [group:raid] show; hide",
    showPlayer = false,
    showSolo = false,
    showParty = false,
    showRaid = true,
    point = "BOTTOM",
    xOffset = 0*L.C.uiscale,
    yOffset = 5*L.C.uiscale,
  },
}
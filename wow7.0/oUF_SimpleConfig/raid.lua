
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
  size = {110*L.C.globalscale,26*L.C.globalscale},
  points = { --list of 8 points, one for each raid group
    {"TOPLEFT",20*L.C.globalscale,-20*L.C.globalscale},
    {"TOP", "oUF_SimpleRaidHeader1", "BOTTOM", 0*L.C.globalscale, -10*L.C.globalscale},
    {"TOP", "oUF_SimpleRaidHeader2", "BOTTOM", 0*L.C.globalscale, -10*L.C.globalscale},
    {"TOP", "oUF_SimpleRaidHeader3", "BOTTOM", 0*L.C.globalscale, -10*L.C.globalscale},
    {"LEFT", "oUF_SimpleRaidHeader1", "RIGHT", 10*L.C.globalscale, 0*L.C.globalscale},
    {"TOP", "oUF_SimpleRaidHeader5", "BOTTOM", 0*L.C.globalscale, -10*L.C.globalscale},
    {"TOP", "oUF_SimpleRaidHeader6", "BOTTOM", 0*L.C.globalscale, -10*L.C.globalscale},
    {"TOP", "oUF_SimpleRaidHeader7", "BOTTOM", 0*L.C.globalscale, -10*L.C.globalscale},
  },
  scale = 1,--1*L.C.globalscale,
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
        {"LEFT",2*L.C.globalscale,0*L.C.globalscale},
        {"RIGHT",-2*L.C.globalscale,0*L.C.globalscale},
      },
      size = 16*L.C.globalscale,
      align = "CENTER",
      tag = "[name]",
    },
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18*L.C.globalscale,18*L.C.globalscale},
    point = {"CENTER","LEFT",0*L.C.globalscale,0*L.C.globalscale},
  },
  setup = {
    template = nil,
    visibility = "custom [group:raid] show; hide",
    showPlayer = false,
    showSolo = false,
    showParty = false,
    showRaid = true,
    point = "TOP",
    xOffset = 0*L.C.globalscale,
    yOffset = -5*L.C.globalscale,
  },
}
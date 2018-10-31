
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
  size = {110,26},
  points = { --list of 8 points, one for each raid group
    {"TOPLEFT",20,-20},
    {"TOP", "oUF_SimpleRaidHeader1", "BOTTOM", 0, -10},
    {"TOP", "oUF_SimpleRaidHeader2", "BOTTOM", 0, -10},
    {"TOP", "oUF_SimpleRaidHeader3", "BOTTOM", 0, -10},
    {"TOPLEFT", "oUF_SimpleRaidHeader1", "TOPRIGHT", 10, 0},
    {"TOP", "oUF_SimpleRaidHeader5", "BOTTOM", 0, -10},
    {"TOP", "oUF_SimpleRaidHeader6", "BOTTOM", 0, -10},
    {"TOP", "oUF_SimpleRaidHeader7", "BOTTOM", 0, -10},
  },
  scale = 1*L.C.globalscale,
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
        {"LEFT",2,0},
        {"RIGHT",-2,0},
      },
      size = 15,
      align = "CENTER",
      tag = "[name][oUF_Simple:role]",
    },
    debuffHighlight = true,
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18,18},
    point = {"CENTER","TOP",0,4},
  },
  --readycheck
  readycheck = {
    enabled = true,
    size = {26,26},
    point = {"CENTER","CENTER",0,0},
  },
  --resurrect
  resurrect = {
    enabled = true,
    size = {26,26},
    point = {"CENTER","CENTER",0,0},
  },
  setup = {
    template = nil,
    visibility = "custom [group:raid] show; hide",
    showPlayer = false,
    showSolo = false,
    showParty = false,
    showRaid = true,
    point = "TOP",
    xOffset = 0,
    yOffset = -5,
  },
  range = {
    insideAlpha = 1,
    outsideAlpha = .5,
  },
}
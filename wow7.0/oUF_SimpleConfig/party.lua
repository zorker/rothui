
-- oUF_SimpleConfig: party
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Party Config
-----------------------------

L.C.party = {
  enabled = true,
  size = {180*L.C.globalscale,26*L.C.globalscale},
  point = {"TOPLEFT",20*L.C.globalscale,-20*L.C.globalscale},
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
        {"TOPLEFT",2*L.C.globalscale,10*L.C.globalscale},
        {"TOPRIGHT",-2*L.C.globalscale,10*L.C.globalscale},
      },
      size = 17*L.C.globalscale,
      tag = "[name] [leader]",
    },
    health = {
      enabled = true,
      point = {"RIGHT",-2*L.C.globalscale,0*L.C.globalscale},
      size = 16*L.C.globalscale,
      tag = "[oUF_Simple:health]",
    },
  },
  --powerbar
  powerbar = {
    enabled = true,
    size = {180*L.C.globalscale,5*L.C.globalscale},
    point = {"TOP","BOTTOM",0*L.C.globalscale,-4*L.C.globalscale}, --if no relativeTo is given the frame base will be the relativeTo reference
    colorPower = true,
  },
  --raidmark
  raidmark = {
    enabled = true,
    size = {18*L.C.globalscale,18*L.C.globalscale},
    point = {"CENTER","LEFT",0*L.C.globalscale,0*L.C.globalscale},
  },
  --debuffs
  debuffs = {
    enabled = true,
    point = {"LEFT","RIGHT",5*L.C.globalscale,0*L.C.globalscale},
    num = 5,
    cols = 5,
    size = 26*L.C.globalscale,
    spacing = 5*L.C.globalscale,
    initialAnchor = "TOPLEFT",
    growthX = "RIGHT",
    growthY = "DOWN",
    disableCooldown = true,
  },
  setup = {
    template = nil,
    visibility = "custom [group:party,nogroup:raid] show; hide",
    showPlayer = true,
    showSolo = false,
    showParty = true,
    showRaid = false,
    point = "TOP",
    xOffset = 0*L.C.globalscale,
    yOffset = -14*L.C.globalscale,
  },
}

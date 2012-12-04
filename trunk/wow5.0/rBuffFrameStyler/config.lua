
  -- // rBuffFrameStyler
  -- // zork - 2012

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  -----------------------------
  -- CONFIG
  -----------------------------

  --adjust the oneletter abbrev?
  cfg.adjustOneletterAbbrev = true

  --buff frame settings
  cfg.buffFrame = {
    pos             = { a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0 },
    gap             = 10, --gap between buff and debuff frame (in case they both reference each other)
    userplaced      = true, --want to place the bar somewhere else?
    rowSpacing      = 10,
    colSpacing      = 7,
    buttonsPerRow   = 10,
    button = {
      size              = 32,
    },
    icon = {
      padding           = -2,
    },
    border = {
      texture           = "Interface\\AddOns\\rBuffFrameStyler\\media\\gloss",
      color             = { r = 0.4, g = 0.35, b = 0.35, },
      classcolored      = false,
    },
    background = {
      show              = true,   --show backdrop
      edgeFile          = "Interface\\AddOns\\rBuffFrameStyler\\media\\outer_shadow",
      color             = { r = 0, g = 0, b = 0, a = 0.9},
      classcolored      = false,
      inset             = 6,
      padding           = 4,
    },
    duration = {
      font              = STANDARD_TEXT_FONT,
      size              = 13,
      pos               = { a1 = "BOTTOM", x = 0, y = 0 },
    },
    count = {
      font              = STANDARD_TEXT_FONT,
      size              = 12,
      pos               = { a1 = "TOPRIGHT", x = 0, y = 0 },
    },
  }

  --debuff frame settings
  cfg.debuffFrame = {
    pos             = { a1 = "TOPRIGHT", af = "rBFS_BuffDragFrame", a2 = "BOTTOMRIGHT", x = 0, y = 1 },
    userplaced      = true, --want to place the bar somewhere else?
    rowSpacing      = 10,
    colSpacing      = 7,
    buttonsPerRow   = 10,
    button = {
      size              = 32,
    },
    icon = {
      padding           = -2,
    },
    border = {
      texture           = "Interface\\AddOns\\rBuffFrameStyler\\media\\gloss",
    },
    background = {
      show              = true,   --show backdrop
      edgeFile          = "Interface\\AddOns\\rBuffFrameStyler\\media\\outer_shadow",
      color             = { r = 0, g = 0, b = 0, a = 0.9},
      classcolored      = false,
      inset             = 6,
      padding           = 4,
    },
    duration = {
      font              = STANDARD_TEXT_FONT,
      size              = 13,
      pos               = { a1 = "BOTTOM", x = 0, y = 0 },
    },
    count = {
      font              = STANDARD_TEXT_FONT,
      size              = 12,
      pos               = { a1 = "TOPRIGHT", x = 0, y = 0 },
    },
  }


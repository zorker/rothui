
  -- // DiscoKugel
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  -----------------------------
  -- CONFIG
  ----------------------------- 

  cfg.textureList = {
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling1",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling2",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling3",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling4",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling5",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling6",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling7",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling8",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling9",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling10",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling11",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling12",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling13",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling14",
    "Interface\\AddOns\\DiscoKugel\\media\\orb_filling15",
  }
  
  cfg.displayIdList = {
    15438,
    15444,
    17010,
    17054,
    17055,
    17286,
    18075,
    18402,
    20030,
    20594,
    20782,
    20894,
    22460,
    22814,
    23310,
    23343,
    23422,
    24614,
    24813,
    24939,
    25392,
    26320,
    26322,
    26503,
    26534,
    27037,
    27393,
    27625,
    27653,
    28450,
    28460,
    28639,
    28783,
    28951,
    29133,
    29270,
    29286,
    29561,
    29612,
    29885,
    29886,
    30150,
    30615,
    30660,
    30903,
    30998,
    31496,
    32368,
    32477,
    32754,
    33853,
    34044,
    34319,
    34404,
    34641,
    34645,
    35058,
    35063,
    35094,
    37867,
    37939,
    38262,
    38327,
    38548,
    38699,
    38966,
    39010,
    39108,
    39174,
    39381,
    39423,
    39431,
    39434,
    39437,
    39528,
    39581,
    39997,
    40026,
    40113,
    40224,
    40645,
    41039,
    41110,
    42125,
    42449,
    42486,
    42938,
    43094,
    44652,
    44652,
    44808,
    45282,
    45414,
  }

  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --object container to addon namespace
  ns.cfg = cfg
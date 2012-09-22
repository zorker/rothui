
  -- // DiscoKugel
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  -----------------------------
  -- CONFIG
  ----------------------------- 
  
  -- 17010	creature	cloud	cloudswampgas.m2 --red
  -- 17054	creature	cloud	cloudswampgas.m2 --purple
  -- 17055	creature	cloud	cloudswampgas.m2 --green
  -- 17286	creature	cloud	cloudswampgas.m2 --yellow/orange
  -- 17522	creature	cloud	cloudswampgas.m2 --red
  -- 18075	creature	cloud	cloudswampgas.m2 --turquise
  -- 19988	creature	cloud	cloudswampgas.m2 --purple
  -- 20262	creature	cloud	cloudswampgas.m2 --red
  -- 20372	creature	cloud	cloudswampgas.m2 --purple
  -- 20373	creature	cloud	cloudswampgas.m2 --turquise
  -- 20382	creature	cloud	cloudswampgas.m2 --red
  -- 20383	creature	cloud	cloudswampgas.m2 --purple
  -- 20597	creature	cloud	cloudswampgas.m2 --purple
  -- 22460	creature	cloud	cloudswampgas_shadowmoon_white.m2
  -- 22726	creature	cloud	cloudswampgas_shadowmoon_white.m2
  -- 23244	creature	cloud	cloudswampgas_shadowmoon_white.m2
  -- 28065	creature	cloud	cloudswampgas_shadowmoon_white.m2
  -- 30062	creature	cloud	cloudswampgas_shadowmoon_white.m2
  -- 35416	creature	cloud	cloudswampgas_shadowmoon_white.m2 
  -- 18402  blue warpstorm
  --20594  red whisp
  --27037 yellow star/spark
  --30903 fire
  
  cfg.orbList = {
    [1] = {
      color = {r=1,g=0,b=0,},
      displayid = 17010,
    },
    [2] = {
      color = {r=0.8,g=0,b=0.8,},
      displayid = 17054,
    },
    [3] = {
      color = {r=0,g=0.4,b=0,},
      displayid = 17055,
    },
    [4] = {
      color = {r=1,g=0.8,b=0,},
      displayid = 17286,
    },
    [5] = {
      color = {r=0,g=0.8,b=1,},
      displayid = 18075,
    },
    [6] = {
      color = {r=0.8,g=0.8,b=0.8,},
      displayid = 22460,
    },
    [7] = {
      color = {r=1,g=0,b=0,},
      displayid = 22460,
    },
    [8] = {
      color = {r=1,g=0,b=0,},
      displayid = 20594,
    },
    [9] = {
      color = {r=0,g=0.3,b=1,},
      displayid = 18402,
    },
    [10] = {
      color = {r=1,g=1,b=0.5,},
      displayid = 27037,
    },
    [11] = {
      color = {r=1,g=0.3,b=0,},
      displayid = 30903,
    },
    [12] = {
      color = {r=0.4,g=0,b=0,},
      displayid = 23422,
    },
    [13] = {
      color = {r=0,g=0.4,b=1,},
      displayid = 27393,
    },
    [14] = {
      color = {r=0.4,g=0,b=0,},
      displayid = 20894,
    },
    [15] = {
      color = {r=0.4,g=0,b=1,},
      displayid = 15438,
    },
    [16] = {
      color = {r=0,g=0.7,b=1,},
      displayid = 20782,
    },
    [17] = {
      color = {r=1,g=0.4,b=0,},
      displayid = 22814,
    },
    [18] = {
      color = {r=0.3,g=0.3,b=0.3,},
      displayid = 23310,
    },
    [19] = {
      color = {r=0.6,g=0.6,b=0.6,},
      displayid = 23343,
    },
    [20] = {
      color = {r=0.4,g=0,b=0,},
      displayid = 24813,
    },
    [21] = {
      color = {r=0.4,g=0.6,b=0,},
      displayid = 25392,
    },
    [22] = {
      color = {r=0,g=0.6,b=1,},
      displayid = 26320,
    },
    [23] = {
      color = {r=0.4,g=0.6,b=0,},
      displayid = 27625,
    },
    [24] = {
      color = {r=0.5,g=0,b=1,},
      displayid = 28460,
    },
    [25] = {
      color = {r=0,g=0.4,b=0,},
      displayid = 28450,
    },
    [26] = {
      color = {r=0.4,g=0.6,b=0,},
      displayid = 29133,
    },
    [27] = {
      color = {r=1,g=1,b=1,},
      displayid = 29286,
    },
    [28] = {
      color = {r=0,g=0.6,b=0.9,},
      displayid = 29561,
    },
    [29] = {
      color = {r=1,g=0.5,b=0,},
      displayid = 30660,
    },
    [30] = {
      color = {r=1,g=0.2,b=0,},
      displayid = 30998,
    },
    [31] = {
      color = {r=1,g=1,b=1,},
      displayid = 32368,
    },
    [32] = {
      color = {r=1,g=0,b=0,},
      displayid = 33853,
    },
    [33] = {
      color = {r=0,g=0,b=0.4,},
      displayid = 34319,
    },
    [34] = {
      color = {r=0,g=1,b=1,},
      displayid = 34404,
    },
    [35] = {
      color = {r=0.3,g=0,b=0.3,},
      displayid = 34645,
    },
    [36] = {
      color = {r=0.8,g=0.2,b=0,},
      displayid = 35058,
    },
  }

  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --object container to addon namespace
  ns.cfg = cfg
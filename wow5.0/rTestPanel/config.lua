
  -- // rTestPanel - Config
  -- // zork - 2013

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...

  --initialize the config data table
  local cfg = {}

  --make the config available in the namespace for later usage
  ns.cfg = cfg

  -----------------------------
  -- CONFIG
  -----------------------------

  --slash command to toogle the frame via /rtp
  cfg.slashCommand = "rtp"

  --enable debugging functions
  cfg.debug = false

  --mainframe config data
  cfg.mainFrame = {
    --size
    width         = 1024-200,   --frame width
    minWidth      = 400,        --minimum frame width
    maxWidth      = 1024,       --maximum frame width
    height        = 768-200,    --frame height
    minHeight     = 300,        --minimum frame height
    maxHeight     = 768-100,    --maximum frame height
    --pos
    position      = {"CENTER",0,0}, --frame position
    --strata
    frameStrata   = "HIGH",         --frame strata
    --util
    draggable     = true, --should the frame be dragable (title region)
    resizable     = true, --should the frame be resizable (top right corner)
    showOnLoad    = true, --show the frame on loadup

    --bottom tabs
    tabs = {

      --tab1
      {

        tabTitle = "Mod",

        --!!! important notice !!!

        --each tab has at least one subframe
        --if a tab has more than one subframe another tab navigation is needed
        --that navigation will be spawned inside the subframe at the top

        subFrames = {
          --tab1 subframe1
          {
            frameTitle  = "ModelsA",     --when this frame is shown the mainframe title will change to this value
            tabTitle    = "ModOverview",   --the top tab navigation will show this text
          },
          --tab1 subframe2
          {
            frameTitle  = "ModelsB",
            tabTitle    = "ModFavorites",
          },
          --tab1 subframe3
          {
            frameTitle  = "ModelsC",
            tabTitle    = "ModTags",
          },
          --tab1 subframe4
          {
            frameTitle  = "ModelsD",
            tabTitle    = "ModMonster",
          },
        }, --subframes
      },

      --tab2
      {
        tabTitle = "Tex",
        subFrames = {
          --tab2 subframe1
          {
            frameTitle  = "TexturesA",
            tabTitle    = "TexOverview",
          },
        }, --subframes
      },

    }, --tabs

  }

-- // Pulsar
-- // zork - 2012

--get the addon namespace
local addon, ns = ...

--object container
local cfg = CreateFrame("Frame")
ns.cfg = cfg

-----------------------------
-- CONFIG
-----------------------------

cfg.unit = {
  player = {
    scale = 0.82,
    size = 150,
    pos = { a1="BOTTOM", af=UIParent, x=-260, y=-10, },
    power = {
      pos = { a1="BOTTOM", af=UIParent, x=260, y=-10, },
    }
  },
}
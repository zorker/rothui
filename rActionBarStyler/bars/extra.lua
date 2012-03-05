--get the addon namespace
local addon, ns = ...
--get the config values
local cfg = ns.cfg
local barcfg = cfg.bars.extrabar
if barcfg and not barcfg.disable then

  --holder frame
  local bar = CreateFrame("Frame","rABS_ExtraActionBar",UIParent,"SecureHandlerStateTemplate")
  bar:SetSize(barcfg.buttonsize,barcfg.buttonsize)
  bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
  bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
  bar:SetScale(barcfg.barscale)
  cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)

  --the frame
  local f = ExtraActionBarFrame
  f:SetParent(bar)
  f:ClearAllPoints()
  f:SetPoint("CENTER", 0, 0)
  f:EnableMouse(false)
  f.ignoreFramePositionManager = true

  --the button
  local b = ExtraActionButton1
  b:SetSize(barcfg.buttonsize,barcfg.buttonsize)
  bar.button = b

end --disable

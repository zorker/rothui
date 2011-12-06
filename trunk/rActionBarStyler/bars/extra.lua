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
  f.ignoreFramePositionManager = true

  --the button
  local b = ExtraActionButton1
  b:SetSize(barcfg.buttonsize,barcfg.buttonsize)
  bar.button = b

  --style texture
  local s = b.style
  s:SetTexture(nil)
  local disableTexture = function(style, texture)
    if not texture then return end
    if string.sub(texture,1,9) == "Interface" then
      style:SetTexture(nil) --bzzzzzzzz
    end
  end
  hooksecurefunc(s, "SetTexture", disableTexture)

  --register the event, make sure the damn button shows up
  bar:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
  bar:RegisterEvent("PLAYER_REGEN_ENABLED")
  bar:SetScript("OnEvent", function(self, event, ...)
    if (HasExtraActionBar()) then
      self:Show()
      self.button:Show()
    else
      self:Hide()
    end
  end)

end --disable

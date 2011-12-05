--get the addon namespace
local addon, ns = ...
--get the config values
local cfg = ns.cfg
local barcfg = cfg.bars.extrabar
if barcfg and not barcfg.disable then
  local bar = CreateFrame("Frame","rABS_ExtraActionBar",UIParent,"SecureHandlerStateTemplate")
  bar:SetSize(barcfg.buttonsize,barcfg.buttonsize)
  bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
  bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)
  bar:SetScale(barcfg.barscale)
  cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)
  local disableTexture = function(style, texture)
    if string.sub(texture,1,9) == "Interface" then
      style:SetTexture(nil) --bzzzzzzzz
    end
  end
  local b = ExtraActionButton1
  b:SetParent(bar)
  b:SetSize(barcfg.buttonsize,barcfg.buttonsize)
  b:ClearAllPoints()
  b:SetPoint("CENTER",0,0)
  b:Show()
  local s = b.style
  s:SetTexture(nil)
  hooksecurefunc(s, "SetTexture", disableTexture)
  bar:RegisterEvent("UPDATE_EXTRA_ACTIONBAR")
  bar:SetScript("OnEvent", function(self, event, ...)
    if (event == "UPDATE_EXTRA_ACTIONBAR") then
      if (HasExtraActionBar()) then
        b:Show()
      elseif(self:IsShown()) then
        b:Hide()
      end
    end
  end)
end --disable

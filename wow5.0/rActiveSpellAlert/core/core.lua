
  --get the addon namespace
  local addon, ns = ...

  -----------------------------
  -- VARIABLES
  -----------------------------

  local rASA = ns.rASA
  local SAOF = SpellActivationOverlayFrame
  local dragFrameList = ns.dragFrameList

  local floor = floor
  local min = min
  local max = max

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local UpdateSize = function(self)
    if InCombatLockdown() then return end
    self.curWidth = min(max(floor(self:GetWidth()),150),350)
    --self.curHeight = floor(self:GetHeight())
    local scale = self.curWidth/self.origWidth
    self:SetSize(self.curWidth,self.curWidth)
    self:SetScale(scale)
  end

  --SAOF adjustments
  SAOF:SetScript("OnSizeChanged", UpdateSize)
  SAOF.origWidth = floor(SAOF:GetWidth())
  SAOF.origHeight = floor(SAOF:GetHeight())

  --add the drag resize frame
  rCreateDragResizeFrame(SAOF, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp

  --check aura func
  local function CheckAura(data)
    local auraFound = false
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellid, canApplyAura, isBossDebuff, casterIsPlayer, value1, value2, value3 = UnitAura(data.unit, data.spellName, data.spellRank, data.auraFilter)
    if name and (not data.caster or (data.caster and caster == data.caster)) then
      auraFound = true
    end
    if auraFound and not data.isOverlayShown then
      SpellActivationOverlay_ShowOverlay(SAOF, data.spellid, data.texture, data.anchor, data.scale, data.color.r*255, data.color.g*255, data.color.b*255, data.vFLip, data.hFLip)
      data.isOverlayShown = true
    elseif not auraFound and data.isOverlayShown then
      SpellActivationOverlay_HideOverlays(SAOF, data.spellid)
      data.isOverlayShown = false
    end
  end

  --check all auras func
  local function CheckAllAuras(self,event,unit)
    for index, data in ipairs(rASA.auraList) do
      if unit == data.unit then
        CheckAura(data)
      end
    end
  end

  local function DebugAllAuras()
    for index, data in ipairs(rASA.auraList) do
      SpellActivationOverlay_ShowOverlay(SAOF, data.spellid, data.texture, data.anchor, data.scale, data.color.r*255, data.color.g*255, data.color.b*255, data.vFLip, data.hFLip)
    end
  end

  local function OnEvent(self, event, unit)
    if rASA.debug and event == "PLAYER_LOGIN" then
      DebugAllAuras()
    end
    if event == "UNIT_AURA" then
      CheckAllAuras(self,event,unit)
    end
  end
  -----------------------------
  -- INIT
  -----------------------------

  rASA:RegisterEvent("PLAYER_LOGIN")
  if not rASA.debug then
    rASA:RegisterEvent("UNIT_AURA")
  end
  rASA:SetScript("OnEvent", OnEvent)
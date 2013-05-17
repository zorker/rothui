
  --get the addon namespace
  local addon, ns = ...

  -----------------------------
  -- VARIABLES
  -----------------------------

  local rASA = ns.rASA
  local SAOF = SpellActivationOverlayFrame

  -----------------------------
  -- FUNCTIONS
  -----------------------------

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
        checkAura(data)
      end
    end
  end

  -----------------------------
  -- INIT
  -----------------------------

  rASA:RegisterEvent("UNIT_AURA")
  rASA:SetScript("OnEvent", CheckAllAuras)

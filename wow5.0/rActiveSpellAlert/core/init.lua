
  --get the addon namespace
  local addon, ns = ...

  -----------------------------
  -- VARIABLES
  -----------------------------

  local rASA = CreateFrame("Frame")
  ns.rASA = rASA
  rASA.auraList = {}

  local tinsert = tinsert

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --add aura func
  function rASA:AddAura(data,type)
    if not GetSpellInfo(data.spellid) then
      print(addon..": No spell info found for spellid: "..data.spellid)
      return
    end
    data.auraFilter = "HELPFUL"
    if type == "debuff" then
      data.auraFilter = "HARMFUL"
    end
    data.isOverlayShown = false
    data.spellName, data.spellRank, data.spellIcon = GetSpellInfo(data.spellid)
    if data.useSpellIconAsTexture then
      data.texture = data.spellIcon
    end
    tinsert(self.auraList,data)
  end

  --add buff func
  function rASA:AddBuff(data)
    rASA:AddAura(data,"buff")
  end

  --add debuff func
  function rASA:AddDebuff(data)
    rASA:AddAura(data,"debuff")
  end

  --get the addon namespace
  local addon, ns = ...

  --object container
  local unit = CreateFrame("Frame")
  unit:Hide()

  ---------------------------------------------
  -- UNITS
  ---------------------------------------------

  --just in case needed

  ---------------------------------------------
  -- HANDOVER
  ---------------------------------------------

  --object container to addon namespace
  ns.unit = unit

  unit:RegisterEvent("PET_BATTLE_OPENING_START")
  unit:RegisterEvent("PET_BATTLE_CLOSE")
  --event
  unit:SetScript("OnEvent", function(...)
    local self, event, arg1 = ...
    if event == "PET_BATTLE_OPENING_START" then
      for _, v in pairs(oUF_Diablo_Units) do
        local f = _G[v]
        if f then f:SetParent(unit) end
      end
    elseif event == "PET_BATTLE_CLOSE" then
      for _, v in pairs(oUF_Diablo_Units) do
        local f = _G[v]
        if f then f:SetParent(UIParent) end
      end
    end
  end)
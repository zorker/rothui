
  --frames to disable titan panel moving for
  local titanPanelDisable = {
    "PlayerFrame",
    "TargetFrame",
    "PartyMemberFrame1",
    "TicketStatusFrame",
    "TemporaryEnchantFrame",
    "ConsolidatedBuffs",
    "BuffFrame",
    "MinimapCluster",
    "WorldStateAlwaysUpFrame",
    "MainMenuBar",
    "MultiBarRight",
    "VehicleMenuBar",
    "BonusActionBarFrame",
  }

  --init
  local init = function(self)
    if IsAddOnLoaded("Titan") then
      for index, value in pairs(titanPanelDisable) do
        TitanUtils_AddonAdjust(value, true)
      end
    end
  end

  --register call
  local a = CreateFrame("Frame")
  a:SetScript("OnEvent", init)
  a:RegisterEvent("PLAYER_LOGIN")

  -- // Pulsar GUI config
  -- // zork - 2012

  --get the addon namespace
  local addon, ns = ...

  local PulsarConfig = PulsarConfig or CreateFrame("Frame", "PulsarConfig", UIParent)
  PulsarConfig:Hide()


  local function initPanel()
    local mainpanel = CreateFrame("FRAME")
    mainpanel.name = "Pulsar"
    InterfaceOptions_AddCategory(mainpanel)
    print(addon.." loaded")
    return mainpanel
  end

  PulsarConfig.mainpanel = initPanel()

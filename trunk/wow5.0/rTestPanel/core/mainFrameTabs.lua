
  -- // rTestPanel - MainframeTabs
  -- // zork - 2013

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...

  --variables
  local UIP = UIParent
  local CF = CreateFrame
  local _G = _G
  local unpack = unpack
  local wipe = wipe
  local tinsert = tinsert

  --get the config
  local cfg = ns.cfg

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --checks
  if not ns.mainFrame then return end

  if # cfg.mainFrame.tabs <= 0 then
    print(addon.." error: No MainFrameTabs where found!")
    return
  end

  local createMainFrameTabs = function(index)

    --create tab
    local tab = CF("Button", "$parentTab"..index, ns.mainFrame, "CharacterFrameTabButtonTemplate")

    if cfg.debug then
      print(tab:GetName())
    end

    --set tab id
    tab.id = index

    --position tabs
    if index == 1 then
      tab:SetPoint("BOTTOMLEFT",5,-30)
    else
      tab:SetPoint("LEFT", "$parentTab"..index-1, "RIGHT", -15, 0)
    end

    --hook the onclick event
    tab:HookScript("OnClick", function(self)
      if cfg.debug then
        print("click on MainFrameTab id: "..self.id)
      end

      --activate the new tab
      PanelTemplates_SetTab(ns.mainFrame, self.id) --setting selectedTab on panel

      --update the mainFrame view
      ns.mainFrame.updateView()

    end)

    --set the tab text
    tab:SetText(cfg.mainFrame.tabs[index].tabTitle)

  end

  --call
  for i = 1, ns.mainFrame.numTabs do
    createMainFrameTabs(i)
  end

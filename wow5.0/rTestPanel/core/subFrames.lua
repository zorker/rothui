
  -- // rTestPanel - Subframes
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

  --list for all the subframe headers
  ns.mainFrame.subFrameHeader = {}
  --list for all the subframes
  ns.mainFrame.subFrames = {}

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --checks
  if not ns.mainFrame then return end

  if # cfg.mainFrame.tabs <= 0 then
    print(addon.." error: No MainFrameTabs where found!")
    return
  end

  if # cfg.mainFrame.tabs[1].subFrames <= 0 then
    print(addon.." error: No SubFrames where found!")
    return
  end

  --create subframe header func (will hold the header tabs)
  local createSubFrameHeader = function(tabIndex)

    local frame = CF("Frame", "$parentTab"..tabIndex.."Header", ns.mainFrame, nil)
    frame.name = frame:GetName()

    if cfg.debug then
      print("creating frame: "..frame:GetName())
    end

    --make the header available to the mainframe
    tinsert(ns.mainFrame.subFrameHeader, frame)

    --settings
    frame.numTabs = # cfg.mainFrame.tabs[tabIndex].subFrames
    frame.selectedTab = 1

    frame:SetPoint("TOPLEFT",60,-30)
    frame:SetPoint("TOPRIGHT",-10,-30)
    frame:SetHeight(30)

    if cfg.debug then
      local texture = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
      texture:SetAllPoints()
      texture:SetTexture(1,1,1)
      texture:SetVertexColor(1,1,0,0.4) --bugfix
    end

    frame:HookScript("OnShow", function(self)
      if cfg.debug then
        print("Showing header: "..self.name)
      end
    end)

    frame:Hide()

    return frame

  end


  local createSubFrameTabs = function(header,index,data)

    --create tab
    local tab = CF("Button", "$parentTab"..index, header, "TabButtonTemplate")

    if cfg.debug then
      print("creating tab: "..tab:GetName())
    end

    --set tab id
    tab.id = index

    --position tabs
    if index == 1 then
      tab:SetPoint("BOTTOMLEFT",0,0)
    else
      tab:SetPoint("LEFT", "$parentTab"..index-1, "RIGHT", 0, 0)
    end

    --hook the onclick event
    tab:HookScript("OnClick", function(self)
      if cfg.debug then
        print("click on "..tab:GetName().." id: "..self.id)
      end

      --activate the new tab
      PanelTemplates_SetTab(header, self.id) --setting selectedTab on panel

      --update the mainFrame view
      ns.mainFrame.updateView()

    end)

    --set the tab text
    tab:SetText(data.tabTitle)

    --make the button fit
    PanelTemplates_TabResize(tab, 0)

  end


  local createSubFrames = function(tabIndex, subFrameIndex,data)

    local frame = CF("Frame", "$parentTab"..tabIndex.."SubFrame"..subFrameIndex, ns.mainFrame, nil)

    frame.name = frame:GetName()

    --make the subframe available to the mainframe
    tinsert(ns.mainFrame.subFrames, frame)

    if cfg.debug then
      print(frame:GetName())
    end

    frame:SetPoint("TOPLEFT",10,-65)
    frame:SetPoint("BOTTOMRIGHT",-10,30)

    if cfg.debug then
      local texture = frame:CreateTexture(nil, "BACKGROUND", nil, -8)
      texture:SetAllPoints()
      texture:SetTexture(1,1,1)
      texture:SetVertexColor(1,1,0,0.4) --bugfix
    end

    frame:Hide()

    frame:HookScript("OnShow", function(self)
      if cfg.debug then
        print("Showing subFrame: "..self.name)
      end
      ns.mainFrame.title:SetText(data.frameTitle)
    end)

    --local subFrameCfg = cfg.mainFrame.tabs[tabIndex].subFrames[subFrameIndex]

  end

  --call
  for i = 1, ns.mainFrame.numTabs do
    local numSubFrames = # cfg.mainFrame.tabs[i].subFrames

    local header = createSubFrameHeader(i)

    for k = 1, numSubFrames do
      createSubFrameTabs(header,k,cfg.mainFrame.tabs[i].subFrames[k])
      createSubFrames(i,k,cfg.mainFrame.tabs[i].subFrames[k])
    end
  end

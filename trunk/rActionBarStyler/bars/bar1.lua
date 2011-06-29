
  -- MAJOR props to tukz for the RegisterStateDriver settings for actionbar1/bonusactionbar

  --get the addon namespace
  local addon, ns = ...

  --get the config values
  local cfg = ns.cfg
  local barcfg = cfg.bars.bar1

  local bar = CreateFrame("Frame","rABS_MainMenuBar",UIParent, "SecureHandlerStateTemplate")
  if barcfg.uselayout2x6 then
    bar:SetWidth(barcfg.buttonsize*6+barcfg.buttonspacing*5)
    bar:SetHeight(barcfg.buttonsize*2+barcfg.buttonspacing)
  else
    bar:SetWidth(barcfg.buttonsize*12+barcfg.buttonspacing*11)
    bar:SetHeight(barcfg.buttonsize)
  end
  if barcfg.uselayout2x6 then
    bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x-((barcfg.buttonsize*6+barcfg.buttonspacing*6)/2),barcfg.pos.y)
  else
    bar:SetPoint(barcfg.pos.a1,barcfg.pos.af,barcfg.pos.a2,barcfg.pos.x,barcfg.pos.y)
  end
  bar:SetHitRectInsets(-cfg.barinset, -cfg.barinset, -cfg.barinset, -cfg.barinset)

  if barcfg.testmode then
    bar:SetBackdrop(cfg.backdrop)
    bar:SetBackdropColor(1,0.8,1,0.6)
  end
  bar:SetScale(barcfg.barscale)

  cfg.applyDragFunctionality(bar,barcfg.userplaced,barcfg.locked)

  local Page = {
    ["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
    ["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
    ["PRIEST"] = "[bonusbar:1] 7;",
    ["ROGUE"] = "[bonusbar:1] 7; [form:3] 7;",
    ["WARLOCK"] = "[form:2] 7;",
    ["DEFAULT"] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
  }

  local function GetBar()
    local condition = Page["DEFAULT"]
    local class = cfg.playerclass
    local page = Page[class]
    if page then
      condition = condition.." "..page
    end
    condition = condition.." 1"
    return condition
  end

  bar:RegisterEvent("PLAYER_LOGIN")
  bar:RegisterEvent("PLAYER_ENTERING_WORLD")
  bar:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
  bar:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
  bar:RegisterEvent("BAG_UPDATE")
  bar:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
      local button, buttons
      for i = 1, NUM_ACTIONBAR_BUTTONS do
        button = _G["ActionButton"..i]
        self:SetFrameRef("ActionButton"..i, button)
      end

      self:Execute([[
        buttons = table.new()
        for i = 1, 12 do
          table.insert(buttons, self:GetFrameRef("ActionButton"..i))
        end
      ]])

      self:SetAttribute("_onstate-page", [[
        for i, button in ipairs(buttons) do
          button:SetAttribute("actionpage", tonumber(newstate))
        end
      ]])

      RegisterStateDriver(self, "page", GetBar())
    elseif event == "PLAYER_ENTERING_WORLD" then
      local button
      for i = 1, 12 do
        button = _G["ActionButton"..i]
        button:SetSize(barcfg.buttonsize, barcfg.buttonsize)
        button:ClearAllPoints()
        button:SetParent(self)
        if i == 1 then
          button:SetPoint("BOTTOMLEFT", bar, 0,0)
        else
          local previous = _G["ActionButton"..i-1]
          if barcfg.uselayout2x6 and i == 7 then
            previous = _G["ActionButton1"]
            button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, barcfg.buttonspacing)
          else
            button:SetPoint("LEFT", previous, "RIGHT", barcfg.buttonspacing, 0)
          end
        end
      end
    else
       MainMenuBar_OnEvent(self, event, ...)
    end
  end)
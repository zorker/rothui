
  -- // rFilter3
  -- // zork - 2010
  
  --get the addon namespace
  local addon, ns = ...  
  
  --get the config
  local cfg = ns.cfg  

  -----------------------------
  -- CONSTANTS
  -----------------------------
  
  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local threatTable = {}
  local checktime = 0

  --compare values func
  local compare = function(a, b)
  	return a.scaledPercent > b.scaledPercent
  end

  --update threatbar func
  local function updateThreatBars()
    
    if checktime < gettime() then
      return
    end
    
    threatTable = {} --empty table
    
    for 1,2 do
      --run through units and gather threat
      local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation("player", "target")    
    
      local values = {
        UnitID        = "player",
        UnitName      = UnitName("player"),
        isTanking     = isTanking,
        status        = status,
        scaledPercent = scaledPercent,
        rawPercent    = rawPercent,
        threatValue   = threatValue,        
      }

      table.insert(threatTable,values)
    }
    
    --sort data
    table.sort(threatTable, compare)
    
    --print statusbars
    for i=0,cfg.statusbars.count-1 do
      --get values out of table
      if(value) && (value>0) then
        statusbars[i].name:SetText(threatTable[i].UnitName)
        statusbars[i].value:SetText(threatTable[i].scaledPercent)
        statusbars[i]:SetValue(threatTable[i].scaledPercent)
        statusbars[i]:Show()
      else
        --hide statusbars that are unused
        statusbars[i]:Hide()
      end
    end
  
  end

  --create check status func
  local function checkStatus(self)
    --check for combat and target
    
    --if everyhting is ok
    updateThreatBars(self)  
  end


  --create threat bars func
  local function createThreatBars()

    local f = CreateFrame("Frame","rThreatContainer",UIParent)
    
    f:SetSize(cfg.statusbar.width,cfg.title.height)
    f:SetPoint("CENTER",0,0)
    
    local title = f:CreateFontString(nil, "BACKGROUND")
    title:SetFont(cfg.title.font, cfg.title.fontsize, "THINOUTLINE")
    title:SetPoint("CENTER", 0, 0)
    title:SetText("rThreat 0.1")
    
    --f:SetHeight(title:GetStringHeight()) --experimental
    --f:SetWidth(title:GetStringWidth()) --experimental
    
    --create the statusbar objects
    
    statusbars = {}
    
    for i=0,cfg.statusbars.count-1 do
      statusbars[i] = CreateFrame("StatusBar", nil, UIParent)
      statusbars[i]:SetMinMaxValues(0,100)
      if(i=0) then
        statusbars[i]:SetPoint("TOP",f,"BOTTOM",0,cfg.statusbar.gap)
      else
        statusbars[i]:SetPoint("TOP",statusbars[i-1],"BOTTOM",0,cfg.statusbar.gap)
      end
      
      --create texture 
      
      --create name fontstring
      local name = xxx
      statusbars[i].name = name
      
      --create value fontstring
      local value = xxx
      statusbars[i].value = value
      
    end
    
    f.bars = statusbars

    f:SetScript("OnEvent", checkStatus)
    f:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
  
  
  end

  -----------------------------
  -- CALL
  -----------------------------

  local a = CreateFrame("Frame")

  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      createThreatBars()
    end
  end)  

  a:RegisterEvent("PLAYER_LOGIN")
  
  

  -- // rThreat
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

  --apply drag functionality func
  local function applyDragFunctionality(f)
    f:SetScript("OnDragStart", function(s) if IsAltKeyDown() and IsShiftKeyDown() then s:StartMoving() end end)
    f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:SetUserPlaced(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnEnter", function(s) 
      GameTooltip:SetOwner(s, "ANCHOR_TOP")
      GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)    
  end
  
  local function getColor(unit)
    local color = { r=1, g=0, b=1 }
    if UnitIsPlayer(unit) then
      local _, class = UnitClass(unit)
      color = rRAID_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
      return color
    else
      local reaction = UnitReaction(unit, "player")
      if reaction then
        color = FACTION_BAR_COLORS[reaction]
        return color
      end
    end
    return color
  end
  
  local numFormat = function(v)
    local string = ""
    if v > 1E9 then
      string = (floor((v/1E9)*10)/10).."b"
    elseif v > 1E6 then
      string = (floor((v/1E6)*10)/10).."m"
    elseif v > 1E3 then
      string = (floor((v/1E3)*10)/10).."k"
    else
      string = floor(v)
    end  
    return string
  end
  
  local threatTable = {}
  local i
  
  --compare values func
  local compare = function(a, b)
  	return a.scaledPercent > b.scaledPercent
  end
  
  --update threatbars
  local function updateThreatBars(self)
  
    threatTable = {} --empty table

    local typ = 0 --0 = player only, 1 = raid, 2 = party, 3 = pet
    if GetNumRaidMembers() > 0 then 
      typ = 1 
      
      for i=1,GetNumRaidMembers() do
        
        --check for raid members
        unit = "raid"..i
        if(UnitExists(unit)) then
          local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")      
          local values = {
            UnitID        = unit,
            UnitName      = UnitName(unit) or "Not found",
            UnitClass     = UnitClass(unit),
            isTanking     = isTanking or 0,
            status        = status or 0,
            scaledPercent = scaledPercent or 0,
            rawPercent    = rawPercent or 0,
            threatValue   = threatValue or 0,        
          }  
          table.insert(threatTable,values)         
        end      
        
        --check for raid pets
        unit = "raidpet"..i
        if(UnitExists(unit)) then
          local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")      
          local values = {
            UnitID        = unit,
            UnitName      = UnitName(unit) or "Not found",
            UnitClass     = UnitClass(unit),
            isTanking     = isTanking or 0,
            status        = status or 0,
            scaledPercent = scaledPercent or 0,
            rawPercent    = rawPercent or 0,
            threatValue   = threatValue or 0,        
          }  
          table.insert(threatTable,values)         
        end
        
      end
      
      
    elseif GetNumPartyMembers() > 0 then 
      typ = 2
      
      local unit
      
      --check player
      unit = "player"      
      local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")    
      local values = {
        UnitID        = unit,
        UnitName      = UnitName(unit) or "Not found",
        UnitClass     = UnitClass(unit),
        isTanking     = isTanking or 0,
        status        = status or 0,
        scaledPercent = scaledPercent or 0,
        rawPercent    = rawPercent or 0,
        threatValue   = threatValue or 0,        
      }
      table.insert(threatTable,values)
      
      --check player pet
      if not UnitInVehicle("player") and UnitExists("pet") then
        unit = "pet"        
        local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")      
        local values = {
          UnitID        = unit,
          UnitName      = UnitName(unit) or "Not found",
          UnitClass     = UnitClass(unit),
          isTanking     = isTanking or 0,
          status        = status or 0,
          scaledPercent = scaledPercent or 0,
          rawPercent    = rawPercent or 0,
          threatValue   = threatValue or 0,        
        }  
        table.insert(threatTable,values)        
      end
      
      for i=1,GetNumPartyMembers() do
        
        --check for party members
        unit = "party"..i
        if(UnitExists(unit)) then
          local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")      
          local values = {
            UnitID        = unit,
            UnitName      = UnitName(unit) or "Not found",
            UnitClass     = UnitClass(unit),
            isTanking     = isTanking or 0,
            status        = status or 0,
            scaledPercent = scaledPercent or 0,
            rawPercent    = rawPercent or 0,
            threatValue   = threatValue or 0,        
          }  
          table.insert(threatTable,values)         
        end      
        
        --check for partypets
        unit = "partypet"..i
        if(UnitExists(unit)) then
          local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")      
          local values = {
            UnitID        = unit,
            UnitName      = UnitName(unit) or "Not found",
            UnitClass     = UnitClass(unit),
            isTanking     = isTanking or 0,
            status        = status or 0,
            scaledPercent = scaledPercent or 0,
            rawPercent    = rawPercent or 0,
            threatValue   = threatValue or 0,        
          }  
          table.insert(threatTable,values)         
        end  
      
      end
      
    elseif not UnitInVehicle("player") and UnitExists("pet") then 
      typ = 3 
      
      for i=1,2 do
        --run through units and gather threat
        local unit
        if i == 1 then
          unit = "player"
        else
          unit = "pet"       
        end        
        
        local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")    
      
        local values = {
          UnitID        = unit,
          UnitName      = UnitName(unit) or "Not found",
          UnitClass     = UnitClass(unit),
          isTanking     = isTanking or 0,
          status        = status or 0,
          scaledPercent = scaledPercent or 0,
          rawPercent    = rawPercent or 0,
          threatValue   = threatValue or 0,        
        }
  
        table.insert(threatTable,values)
      end
    else
      --player only
      local unit = "player"
      
      local isTanking, status, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(unit, "target")    
    
      local values = {
        UnitID        = unit,
        UnitName      = UnitName(unit) or "Not found",
        UnitClass     = UnitClass(unit),
        isTanking     = isTanking or 0,
        status        = status or 0,
        scaledPercent = scaledPercent or 0,
        rawPercent    = rawPercent or 0,
        threatValue   = threatValue or 0,        
      }

      table.insert(threatTable,values)
      
    end
    
    --sort the threat table
    table.sort(threatTable, compare)
    
    --print statusbars
    for i=0,cfg.statusbars.count-1 do
      --get values out of table
      local entry = threatTable[i+1]
      local bar = self.barcontainer.content.bars[i]
      if(entry) then
        bar.name.value = entry.UnitName
        bar.name:SetText(bar.name.value)
        bar.val:SetText(numFormat(entry.threatValue))
        bar.perc:SetText(floor(entry.scaledPercent).."%")
        bar:SetValue(entry.scaledPercent)
        local color = getColor(entry.UnitID)
        bar:SetStatusBarColor(color.r, color.g, color.b, cfg.statusbars.texture.alpha.foreground)
        bar.bg:SetVertexColor(color.r*cfg.statusbars.texture.multiplier, color.g*cfg.statusbars.texture.multiplier, color.b*cfg.statusbars.texture.multiplier, cfg.statusbars.texture.alpha.background)
      else
        bar.name:SetText("")
        bar.perc:SetText("")
        bar.val:SetText("")
        bar:SetValue(0)
        bar:SetStatusBarColor(1,1,1,0)
        bar.bg:SetVertexColor(cfg.statusbars.inactive.color.r, cfg.statusbars.inactive.color.g, cfg.statusbars.inactive.color.b, cfg.statusbars.inactive.color.a)
      end
    end
  
  end
  
  
  local oldtime = 0

  --check status func
  local function checkStatus(self,event,...)
    local unit = "target"
    --if UnitExists(unit) and UnitIsEnemy("player", unit) and not UnitIsPlayer(unit) then
    if UnitExists(unit) and not UnitIsDeadOrGhost(unit) and InCombatLockdown() then
      self:Show()    
      local currenttime = GetTime()
      if currenttime-oldtime > cfg.timespan then
        --print("Getting new data")
        updateThreatBars(self)
        oldtime = currenttime
      --else
        --print("keeping table")
      end
    
    else
      oldtime = 0
      if cfg.hide then
        self:Hide()
      end
    end
  
  end


  --create threat bars func
  local function initThreatBars()

    -- | H O L D E R | --

    --first create a holder frame to gather all the objects (make that dragable later)
    local holder = CreateFrame("Frame","rThreatDragFrame",UIParent)
    holder:SetSize(cfg.title.width,cfg.title.height) --the holder should be dragable thus we make it match the size of the title
    applyDragFunctionality(holder)
    holder:SetPoint("CENTER",0,0) --default position until first movement
    holder:SetFrameStrata("BACKGROUND")
    holder:SetFrameLevel(1)
    
    -- | T I T L E | --
    
    --title container
    local title = CreateFrame("Frame",nil,holder)
    title:SetAllPoints(holder)
    
    --shadow stuff    
    if cfg.shadow.show then
      local backdrop = { 
        bgFile = cfg.shadow.bgFile, 
        edgeFile = cfg.shadow.edgeFile,
        tile = cfg.shadow.tile,
        tileSize = cfg.shadow.tileSize, 
        edgeSize = cfg.shadow.edgeSize, 
        insets = { 
          left = cfg.shadow.inset, 
          right = cfg.shadow.inset, 
          top = cfg.shadow.inset, 
          bottom = cfg.shadow.inset,
        },
      }
      
      local shadow = CreateFrame("Frame",nil,title)
      shadow:SetPoint("TOPLEFT",title,"TOPLEFT",-cfg.shadow.inset,cfg.shadow.inset)
      shadow:SetPoint("BOTTOMRIGHT",title,"BOTTOMRIGHT",cfg.shadow.inset,-cfg.shadow.inset)      
      shadow:SetBackdrop(backdrop)
      shadow:SetBackdropColor(cfg.shadow.bgColor.r, cfg.shadow.bgColor.g, cfg.shadow.bgColor.b, cfg.shadow.bgColor.a)
      shadow:SetBackdropBorderColor(cfg.shadow.edgeColor.r, cfg.shadow.edgeColor.g, cfg.shadow.edgeColor.b, cfg.shadow.edgeColor.a) 
      
      title.shadow = shadow
      
    end    
    
    --frame to hold the namestring
    local content = CreateFrame("Frame",nil,title)
    content:SetAllPoints(title) 
    
    local name = content:CreateFontString(nil, "BACKGROUND")
    name:SetFont(cfg.title.font.font, cfg.title.font.size, "THINOUTLINE")
    name:SetPoint("CENTER", 0, 0)
    name:SetText("rThreat 0.1")    
    name:SetVertexColor(cfg.title.font.color.r, cfg.title.font.color.g, cfg.title.font.color.b, cfg.title.font.color.a)

    local bg = content:CreateTexture(nil, "BACKGROUND",nil,-8)
    bg:SetTexture(cfg.title.bg.texture)
    bg:SetAllPoints(content)
    bg:SetVertexColor(cfg.title.bg.color.r, cfg.title.bg.color.g, cfg.title.bg.color.b, cfg.title.bg.color.a)

    content.name = name
    content.bg = bg
    
    title.content = content

    --border stuff
    if cfg.border.show then
      local backdrop = { 
        bgFile = cfg.border.bgFile, 
        edgeFile = cfg.border.edgeFile,
        tile = cfg.border.tile,
        tileSize = cfg.border.tileSize, 
        edgeSize = cfg.border.edgeSize, 
        insets = { 
          left = cfg.border.inset, 
          right = cfg.border.inset, 
          top = cfg.border.inset, 
          bottom = cfg.border.inset,
        },
      }
      
      local border = CreateFrame("Frame",nil,title)
      border:SetFrameStrata("LOW")
      border:SetPoint("TOPLEFT",title,"TOPLEFT",-cfg.border.inset,cfg.border.inset)
      border:SetPoint("BOTTOMRIGHT",title,"BOTTOMRIGHT",cfg.border.inset,-cfg.border.inset)       
      border:SetBackdrop(backdrop)
      border:SetBackdropColor(cfg.border.bgColor.r, cfg.border.bgColor.g, cfg.border.bgColor.b, cfg.border.bgColor.a)
      border:SetBackdropBorderColor(cfg.border.edgeColor.r, cfg.border.edgeColor.g, cfg.border.edgeColor.b, cfg.border.edgeColor.a)
      
      title.border = border          
    end
    
    -- | B A R S | --
    
    --minimum of two rows
    if not cfg.statusbars.count or cfg.statusbars.count < 2 then
      cfg.statusbars.count = 2
    end    
    
    --bar container
    local barcontainer = CreateFrame("Frame",nil,holder)
    barcontainer:SetPoint("TOP",title,"BOTTOM",0,-cfg.title.gap)
    barcontainer:SetSize(cfg.statusbars.width,cfg.statusbars.height*cfg.statusbars.count+cfg.statusbars.gap*cfg.statusbars.count-cfg.statusbars.gap) 
    
    --shadow stuff    
    if cfg.shadow.show then
      local backdrop = { 
        bgFile = cfg.shadow.bgFile, 
        edgeFile = cfg.shadow.edgeFile,
        tile = cfg.shadow.tile,
        tileSize = cfg.shadow.tileSize, 
        edgeSize = cfg.shadow.edgeSize, 
        insets = { 
          left = cfg.shadow.inset, 
          right = cfg.shadow.inset, 
          top = cfg.shadow.inset, 
          bottom = cfg.shadow.inset,
        },
      }
      
      local shadow = CreateFrame("Frame",nil,barcontainer)
      shadow:SetPoint("TOPLEFT",barcontainer,"TOPLEFT",-cfg.shadow.inset,cfg.shadow.inset)
      shadow:SetPoint("BOTTOMRIGHT",barcontainer,"BOTTOMRIGHT",cfg.shadow.inset,-cfg.shadow.inset)      
      shadow:SetBackdrop(backdrop)
      shadow:SetBackdropColor(cfg.shadow.bgColor.r, cfg.shadow.bgColor.g, cfg.shadow.bgColor.b, cfg.shadow.bgColor.a)
      shadow:SetBackdropBorderColor(cfg.shadow.edgeColor.r, cfg.shadow.edgeColor.g, cfg.shadow.edgeColor.b, cfg.shadow.edgeColor.a) 
      
      barcontainer.shadow = shadow
      
    end  
    
    --frame to hold the namestring
    local barframe = CreateFrame("Frame",nil,barcontainer)
    barframe:SetAllPoints(barcontainer) 
    
    local bg = barframe:CreateTexture(nil, "BACKGROUND",nil,-8)
    bg:SetTexture(cfg.statusbars.bg.texture)
    bg:SetAllPoints(barframe)
    bg:SetVertexColor(cfg.statusbars.bg.color.r, cfg.statusbars.bg.color.g, cfg.statusbars.bg.color.b, cfg.statusbars.bg.color.a)

    barframe.bg = bg
    
    --statusbars
    
    local bars = {}
    
    for i=0,cfg.statusbars.count-1 do
      bars[i] = CreateFrame("StatusBar", nil, barcontainer)
      bars[i]:SetSize(cfg.statusbars.width,cfg.statusbars.height) 
      bars[i]:SetMinMaxValues(0,100)
      if(i==0) then
        bars[i]:SetPoint("TOP",barframe,"TOP",0,0)
      else
        bars[i]:SetPoint("TOP",bars[i-1],"BOTTOM",0,-cfg.statusbars.gap)
      end      
      bars[i]:SetStatusBarTexture(cfg.statusbars.texture.texture)      
      bars[i].value = 0;
      bars[i]:SetValue(bars[i].value);

      local bg = bars[i]:CreateTexture(nil, "BACKGROUND",nil,-6)
      bg:SetTexture(cfg.statusbars.texture.texture)
      bg:SetAllPoints(bars[i])
      bg:SetVertexColor(cfg.statusbars.inactive.color.r, cfg.statusbars.inactive.color.g, cfg.statusbars.inactive.color.b, cfg.statusbars.inactive.color.a)
      
      local name = bars[i]:CreateFontString(nil, "LOW")
      name:SetFont(cfg.statusbars.font.font, cfg.statusbars.font.size, "THINOUTLINE")
      name:SetPoint("LEFT", bars[i], 2, 0)
      --name:SetPoint("RIGHT", bars[i], 100, 0)
      name.value = ""
      name:SetJustifyH("LEFT")
      name:SetText(name.value)    
      
      local perc = bars[i]:CreateFontString(nil, "LOW")
      perc:SetFont(cfg.statusbars.font.font, cfg.statusbars.font.size, "THINOUTLINE")
      perc:SetPoint("RIGHT", bars[i], -2, 0)
      perc.value = bars[i].value.."%"
      perc:SetJustifyH("RIGHT")
      perc:SetText("")    
      
      local val = bars[i]:CreateFontString(nil, "LOW")
      val:SetFont(cfg.statusbars.font.font, cfg.statusbars.font.size, "THINOUTLINE")
      val:SetPoint("RIGHT", bars[i], -40, 0)
      val.value = bars[i].value..".3m"
      val:SetJustifyH("RIGHT")
      val:SetText("")    
      
      name:SetPoint("RIGHT", val, "LEFT", -10, 0) --right point of name is left point of value
      
      bars[i].bg = bg
      bars[i].name = name
      bars[i].perc = perc
      bars[i].val = val
      
    end
    
    barframe.bars = bars
    
    barcontainer.content = barframe

    --border stuff
    if cfg.border.show then
      local backdrop = { 
        bgFile = cfg.border.bgFile, 
        edgeFile = cfg.border.edgeFile,
        tile = cfg.border.tile,
        tileSize = cfg.border.tileSize, 
        edgeSize = cfg.border.edgeSize, 
        insets = { 
          left = cfg.border.inset, 
          right = cfg.border.inset, 
          top = cfg.border.inset, 
          bottom = cfg.border.inset,
        },
      }
      
      local border = CreateFrame("Frame",nil,barcontainer)
      border:SetFrameStrata("LOW")
      border:SetPoint("TOPLEFT",barcontainer,"TOPLEFT",-cfg.border.inset,cfg.border.inset)
      border:SetPoint("BOTTOMRIGHT",barcontainer,"BOTTOMRIGHT",cfg.border.inset,-cfg.border.inset)       
      border:SetBackdrop(backdrop)
      border:SetBackdropColor(cfg.border.bgColor.r, cfg.border.bgColor.g, cfg.border.bgColor.b, cfg.border.bgColor.a)
      border:SetBackdropBorderColor(cfg.border.edgeColor.r, cfg.border.edgeColor.g, cfg.border.edgeColor.b, cfg.border.edgeColor.a)
      
      barcontainer.border = border          
    end
    
    holder.title = title
    holder.barcontainer = barcontainer

    holder:SetScript("OnEvent", checkStatus)
    
    --holder:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
    holder:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
    holder:RegisterEvent("PLAYER_TARGET_CHANGED")
    holder:RegisterEvent("PLAYER_ENTERING_WORLD")
    holder:RegisterEvent("PLAYER_REGEN_DISABLED")
    holder:RegisterEvent("PLAYER_REGEN_ENABLED")
    
    holder:SetScale(cfg.scale)
    
    if cfg.hide then
      holder:Hide()
    end
  
  end

  -----------------------------
  -- CALL
  -----------------------------

  local a = CreateFrame("Frame")

  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      initThreatBars()
    end
  end)  

  a:RegisterEvent("PLAYER_LOGIN")
  
  
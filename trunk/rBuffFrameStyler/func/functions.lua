  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg

  local _G = _G

  local BuffFrame = _G["BuffFrame"]
  local BUFF_ACTUAL_DISPLAY = _G["BUFF_ACTUAL_DISPLAY"]
  local TemporaryEnchantFrame = _G["TemporaryEnchantFrame"]
  
  local moveTempEnchantFrame = function()
    --move temp enchant frame
    TemporaryEnchantFrame:SetPoint(a,b,c,xxxxxxxxxxxxx)  
  end
  
  --disable consolidated buffs
  SetCVar('consolidateBuffs', 0)
  local ConsolidatedBuffs = _G["ConsolidatedBuffs"]
  if ConsolidatedBuffs then
    ConsolidatedBuffs:UnregisterAllEvents()
    ConsolidatedBuffs:HookScript("OnShow", function(s) 
      s:Hide() 
      moveTempEnchantFrame()
    end)
    ConsolidatedBuffs:HookScript("OnHide", function(s) 
      moveTempEnchantFrame()
    end)
    ConsolidatedBuffs:Hide()
  end  
  
  local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
  
  if cfg.color.classcolored then
    cfg.color.normal = classcolor
  end
  
  --backdrop settings
  local bgfile, edgefile = "", ""  
  if cfg.background.showshadow then edgefile = cfg.textures.outer_shadow end  
  if cfg.background.useflatbackground and cfg.background.showbg then bgfile = cfg.textures.buttonbackflat end
  
  --backdrop
  local backdrop = { 
    bgFile = bgfile, 
    edgeFile = edgefile,
    tile = false,
    tileSize = 32, 
    edgeSize = cfg.background.inset, 
    insets = { 
      left = cfg.background.inset, 
      right = cfg.background.inset, 
      top = cfg.background.inset, 
      bottom = cfg.background.inset,
    },
  }
  
  local function applyBackground(bu)
    --shadows+background
    if cfg.background.showbg or cfg.background.showshadow then
      bu.bg = CreateFrame("Frame", nil, bu)
      bu.bg:SetAllPoints(bu)
      bu.bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -4, 4)
      bu.bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 4, -4)
      bu.bg:SetFrameLevel(bu:GetFrameLevel()-1)
      
      if cfg.background.classcolored then
        cfg.background.backgroundcolor = classcolor
        cfg.background.shadowcolor = classcolor
      end
      
      if cfg.background.showbg and not cfg.background.useflatbackground then 
        local t = bu.bg:CreateTexture(nil,"BACKGROUND",-8)
        t:SetTexture(cfg.textures.buttonback)
        t:SetAllPoints(bu)
        t:SetVertexColor(cfg.background.backgroundcolor.r,cfg.background.backgroundcolor.g,cfg.background.backgroundcolor.b,cfg.background.backgroundcolor.a)
      end  
      
      bu.bg:SetBackdrop(backdrop)
      if cfg.background.useflatbackground then
        bu.bg:SetBackdropColor(cfg.background.backgroundcolor.r,cfg.background.backgroundcolor.g,cfg.background.backgroundcolor.b,cfg.background.backgroundcolor.a)
      end
      if cfg.background.showshadow then
        bu.bg:SetBackdropBorderColor(cfg.background.shadowcolor.r,cfg.background.shadowcolor.g,cfg.background.shadowcolor.b,cfg.background.shadowcolor.a)
      end
    end
  end
  
  local function styleButton(b)
    
    --b.border:SetTexCoord(0,1,0,1)
    --.border:SetTexture(media/gloss)
    --apply background
    
  end
  
  --update anchors
  local function rBFS_BF_UpdateAllBuffAnchors(self)
  
    print("numEnchants: "..BuffFrame.numEnchants)
    
    print("BUFF_ACTUAL_DISPLAY: "..BUFF_ACTUAL_DISPLAY)
    
    --loop
      --if not b.styled then
        --styleButton(b)
      --end
    --end loop

  end
  
  --update debuff anchors
  local function rBFS_DB_UpdateAnchors(self)
    --dodat
    
    --loop
      --if not b.styled then
        --styleButton(b)
      --end
    --end loop
    
  end
  
  ---------------------------------------
  -- CALLS // HOOKS
  ---------------------------------------
  
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors",    rBFS_BF_UpdateAllBuffAnchors)
  hooksecurefunc("DebuffButton_UpdateAnchors",        rBFS_DB_UpdateAnchors)
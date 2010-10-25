
  -- // rSetBackdrop
  -- // zork - 2010

  --get the addon namespace
  local addon, ns = ...  
  --get the config
  local cfg = ns.cfg
  
  local list = cfg.frameList
  
  -----------------------------
  -- FUNCTIONS
  ----------------------------- 
  
  --allows frames to become movable but frames can be locked or set to default positions
  local applyDragFunctionality = function(f)
    if not cfg.framesUserplaced then
      f:IsUserPlaced(false)
      return
    else
      f:SetMovable(true)
      f:SetResizable(true)
      f:SetUserPlaced(true)
      if not cfg.framesLocked then
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function(s) 
          if IsShiftKeyDown() then s:StartMoving() end
          if IsAltKeyDown() then s:StartSizing() end 
        end)
        f:SetScript("OnDragStop", function(s) 
          if s:GetWidth() < 20 then
            s:SetWidth(20)
          end
          if s:GetHeight() < 20 then
            s:SetHeight(20)
          end
          if s.t then
            --make it a square
            s:SetHeight(s:GetWidth())
          end
          s:StopMovingOrSizing() 
        end)
      end
    end  
  end
  
  local createIcon = function(l,i)
    
    local _, _, icon_texture = GetSpellInfo(6673)    
    local framename = "rSBDT_Icon"..i
    
    local f = CreateFrame("FRAME",framename,UIParent)
    f:SetFrameLevel(1)
    f:SetSize(l.size,l.size)
    f:SetPoint(l.pos.a1,l.pos.af,l.pos.a2,l.pos.x,l.pos.y)
    
    local backdrop = { 
      bgFile = l.bgFile, 
      edgeFile = l.edgeFile,
      tile = l.tile,
      tileSize = l.tileSize, 
      edgeSize = l.edgeSize, 
      insets = { 
        left = l.inset, 
        right = l.inset, 
        top = l.inset, 
        bottom = l.inset,
      },
    }
    
    f:SetBackdrop(backdrop)
    f:SetBackdropColor(l.bgColor.r, l.bgColor.g, l.bgColor.b, l.bgColor.a)
    f:SetBackdropBorderColor(l.edgeColor.r, l.edgeColor.g, l.edgeColor.b, l.edgeColor.a)
    
    if l.useicontexture then
      local t = f:CreateTexture(nil, "LOW",nil,-8)
      if l.iconpadding then
        t:SetPoint("TOPLEFT",f,"TOPLEFT",l.iconpadding,-l.iconpadding)
        t:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-l.iconpadding,l.iconpadding)
      else
        t:SetPoint("TOPLEFT",f,"TOPLEFT",l.inset,-l.inset)
        t:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-l.inset,l.inset)
      end
      t:SetTexture(icon_texture)
      t:SetTexCoord(0.1,0.9,0.1,0.9)
      f.t = t
    end
    
    if l.innerglow and l.showinnerglow then
      
      local s = CreateFrame("FRAME",nil,f)
      s:SetFrameLevel(2)
      s:SetPoint("TOPLEFT",f,"TOPLEFT",l.innerglow.padding,-l.innerglow.padding)
      s:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-l.innerglow.padding,l.innerglow.padding)
      
      backdrop_innerglow = { 
        bgFile = l.innerglow.bgFile, 
        edgeFile = l.innerglow.edgeFile,
        tile = l.innerglow.tile,
        tileSize = l.innerglow.tileSize, 
        edgeSize = l.innerglow.edgeSize, 
        insets = { 
          left = l.innerglow.inset, 
          right = l.innerglow.inset, 
          top = l.innerglow.inset, 
          bottom = l.innerglow.inset,
        },
      }
      
      s:SetBackdrop(backdrop_innerglow)
      s:SetBackdropColor(l.innerglow.bgColor.r, l.innerglow.bgColor.g, l.innerglow.bgColor.b, l.innerglow.bgColor.a)
      s:SetBackdropBorderColor(l.innerglow.edgeColor.r, l.innerglow.edgeColor.g, l.innerglow.edgeColor.b, l.innerglow.edgeColor.a)
      
      f.g = s
      
    end
    
    if l.subframe and l.showsubframe then
      
      local s = CreateFrame("FRAME",nil,f)
      s:SetFrameLevel(3)
      s:SetPoint("TOPLEFT",f,"TOPLEFT",l.subframe.padding,-l.subframe.padding)
      s:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-l.subframe.padding,l.subframe.padding)
      
      backdrop_subframe = { 
        bgFile = l.subframe.bgFile, 
        edgeFile = l.subframe.edgeFile,
        tile = l.subframe.tile,
        tileSize = l.subframe.tileSize, 
        edgeSize = l.subframe.edgeSize, 
        insets = { 
          left = l.subframe.inset, 
          right = l.subframe.inset, 
          top = l.subframe.inset, 
          bottom = l.subframe.inset,
        },
      }
      
      s:SetBackdrop(backdrop_subframe)
      s:SetBackdropColor(l.subframe.bgColor.r, l.subframe.bgColor.g, l.subframe.bgColor.b, l.subframe.bgColor.a)
      s:SetBackdropBorderColor(l.subframe.edgeColor.r, l.subframe.edgeColor.g, l.subframe.edgeColor.b, l.subframe.edgeColor.a)
      
      f.s = s
      
    end
    
    applyDragFunctionality(f)
    
    l.frame = f
  
  end

  
  
  -----------------------------
  -- CALL
  ----------------------------- 

  for i,_ in ipairs(list) do 
    local l = list[i]
    if not l.frame then 
      createIcon(l,i)
    end
  end

  

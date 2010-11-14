  
  --get the addon namespace
  local addon, ns = ...
  
  --get the config values
  local cfg = ns.cfg

  local _G = _G

  local nomoreplay = function() end
  
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

  local function ntSetVertexColorFunc(nt, r, g, b, a)
    --do stuff
    if nt then
      local self = nt:GetParent()
      --print(self:GetName()..": r"..r.."g"..g.."b"..b)--debug
      local action = self.action
      if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
        nt:SetVertexColor(cfg.color.equipped.r,cfg.color.equipped.g,cfg.color.equipped.b,1)
      elseif r==0.5 and g==0.5 and b==1 then
        --blizzard oom color
        nt:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b,1)
      elseif r==1 and g==1 and b==1 then
        nt:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b,1)
      end        
    end 
  end
  
  --initial style func
  local function rActionButtonStyler_AB_style(self)
  
    if not self.rABS_Styled and self:GetParent() and  self:GetParent():GetName() ~= "MultiCastActionBarFrame" and self:GetParent():GetName() ~= "MultiCastActionPage1" and self:GetParent():GetName() ~= "MultiCastActionPage2" and self:GetParent():GetName() ~= "MultiCastActionPage3" then
      
      local action = self.action
      local name = self:GetName()
      local bu  = _G[name]
      local ic  = _G[name.."Icon"]
      local co  = _G[name.."Count"]
      local bo  = _G[name.."Border"]
      local ho  = _G[name.."HotKey"]
      local cd  = _G[name.."Cooldown"]
      local na  = _G[name.."Name"]
      local fl  = _G[name.."Flash"]
      local nt  = _G[name.."NormalTexture"]
      
      --hide the border (plain ugly, sry blizz)
      bo:Hide()
      bo.Show = nomoreplay
      
      if cfg.hotkeys.show then
        ho:SetFont(cfg.font, cfg.hotkeys.fontsize, "OUTLINE")
        ho:ClearAllPoints()
        ho:SetPoint(cfg.hotkeys.pos1.a1,bu,cfg.hotkeys.pos1.x,cfg.hotkeys.pos1.y)
        ho:SetPoint(cfg.hotkeys.pos2.a1,bu,cfg.hotkeys.pos2.x,cfg.hotkeys.pos2.y)
      else
        ho:Hide()
        ho.Show = nomoreplay
      end
      
      if cfg.macroname.show then
        na:SetFont(cfg.font, cfg.macroname.fontsize, "OUTLINE")
        na:ClearAllPoints()
        na:SetPoint(cfg.macroname.pos1.a1,bu,cfg.macroname.pos1.x,cfg.macroname.pos1.y)
        na:SetPoint(cfg.macroname.pos2.a1,bu,cfg.macroname.pos2.x,cfg.macroname.pos2.y)
      else
        na:Hide()
      end

      if cfg.itemcount.show then
        co:SetFont(cfg.font, cfg.itemcount.fontsize, "OUTLINE")
        co:ClearAllPoints()
        co:SetPoint(cfg.itemcount.pos1.a1,bu,cfg.itemcount.pos1.x,cfg.itemcount.pos1.y)        
      else
        co:Hide()
      end
    
      --applying the textures
      fl:SetTexture(cfg.textures.flash)
      bu:SetHighlightTexture(cfg.textures.hover)
      bu:SetPushedTexture(cfg.textures.pushed)
      bu:SetCheckedTexture(cfg.textures.checked)
      bu:SetNormalTexture(cfg.textures.normal)
    
      --cut the default border of the icons and make them shiny
      ic:SetTexCoord(0.1,0.9,0.1,0.9)
      ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
      ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
  
      --adjust the cooldown frame
      cd:SetPoint("TOPLEFT", bu, "TOPLEFT", cfg.cooldown.spacing, -cfg.cooldown.spacing)
      cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -cfg.cooldown.spacing, cfg.cooldown.spacing)
    
      --apply the normaltexture
      if ( IsEquippedAction(action) ) then
        bu:SetNormalTexture(cfg.textures.equipped)
        nt:SetVertexColor(cfg.color.equipped.r,cfg.color.equipped.g,cfg.color.equipped.b,1)
      else
        bu:SetNormalTexture(cfg.textures.normal)
        nt:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b,1)
      end  
      
      --make the normaltexture match the buttonsize
      nt:SetAllPoints(bu)
      
      --disable resetting of textures
      fl.SetTexture = nomoreplay
      bu.SetHighlightTexture = nomoreplay
      bu.SetPushedTexture = nomoreplay
      bu.SetCheckedTexture = nomoreplay
      bu.SetNormalTexture = nomoreplay
      
      --hook to prevent Blizzard from reseting our colors
      hooksecurefunc(nt, "SetVertexColor", ntSetVertexColorFunc)
      
      --shadows+background
      if not bu.bg then applyBackground(bu) end
      
      self.rABS_Styled = true
          
    end  
  end
  
  --style pet buttons
  local function rActionButtonStyler_AB_stylepet()
    
    for i=1, NUM_PET_ACTION_SLOTS do
      local name = "PetActionButton"..i
      local bu  = _G[name]
      local ic  = _G[name.."Icon"]
      local fl  = _G[name.."Flash"]
      local nt  = _G[name.."NormalTexture2"]
  
      nt:SetAllPoints(bu)
      
      --applying color
      nt:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b,1)
      
      --setting the textures
      fl:SetTexture(cfg.textures.flash)
      bu:SetHighlightTexture(cfg.textures.hover)
      bu:SetPushedTexture(cfg.textures.pushed)
      bu:SetCheckedTexture(cfg.textures.checked)
      bu:SetNormalTexture(cfg.textures.normal)
    
      --cut the default border of the icons and make them shiny
      ic:SetTexCoord(0.1,0.9,0.1,0.9)
      ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
      ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
      
      --shadows+background
      if not bu.bg then applyBackground(bu) end
      
    end  
  end
  
  --style shapeshift buttons
  local function rActionButtonStyler_AB_styleshapeshift()    
    for i=1, NUM_SHAPESHIFT_SLOTS do
      local name = "ShapeshiftButton"..i
      local bu  = _G[name]
      local ic  = _G[name.."Icon"]
      local fl  = _G[name.."Flash"]
      local nt  = _G[name.."NormalTexture"]
  
      nt:SetAllPoints(bu)
      
      --applying color
      nt:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b,1)
      
      --setting the textures
      fl:SetTexture(cfg.textures.flash)
      bu:SetHighlightTexture(cfg.textures.hover)
      bu:SetPushedTexture(cfg.textures.pushed)
      bu:SetCheckedTexture(cfg.textures.checked)
      bu:SetNormalTexture(cfg.textures.normal)
    
      --cut the default border of the icons and make them shiny
      ic:SetTexCoord(0.1,0.9,0.1,0.9)
      ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
      ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
      
      --shadows+background
      if not bu.bg then applyBackground(bu) end
      
    end    
  end
  
  ---------------------------------------
  -- CALLS // HOOKS
  ---------------------------------------
  
  hooksecurefunc("ActionButton_Update",         rActionButtonStyler_AB_style)
  hooksecurefunc("ShapeshiftBar_Update",        rActionButtonStyler_AB_styleshapeshift)
  hooksecurefunc("ShapeshiftBar_UpdateState",   rActionButtonStyler_AB_styleshapeshift)
  hooksecurefunc("PetActionBar_Update",         rActionButtonStyler_AB_stylepet)
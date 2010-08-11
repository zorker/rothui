  
  --rActionButtonStyler - roth 2009

  local _G = _G
  
  ---------------------------------------
  -- CONFIG 
  ---------------------------------------
  
  --TEXTURES
  --default border texture  
  local rb2_normal_texture    = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss"
  --texture when a button flashs --> button becomes ready
  local rb2_flash_texture     = "Interface\\AddOns\\rActionButtonStyler\\media\\flash"
  --hover textures
  local rb2_hover_texture     = "Interface\\AddOns\\rActionButtonStyler\\media\\hover"    
  --texture if you push that button
  local rb2_pushed_texture    = "Interface\\AddOns\\rActionButtonStyler\\media\\pushed"
  --texture that is active when the button is in active state (next melee swing attacks mostly)
  local rb2_checked_texture   = "Interface\\AddOns\\rActionButtonStyler\\media\\checked" 
  --texture used for equipped items, this can differ since you may want to apply a different vertexcolor
  local rb2_equipped_texture  = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss_grey"

  --FONT
  --the font you want to use for your button texts
  local button_font = "Fonts\\FRIZQT__.TTF"
  
  --hide the hotkey? 0/1
  local hide_hotkey = 1
  
  --cooldownspacer, how much inset should the cooldown frame have
  local cooldownspacer = 0
    
  --COLORS
  --color you want to appy to the standard texture (red, green, blue in RGB)
  local color = { r = 0.37, g = 0.3, b = 0.3, }
  --want class color? just comment in this:
  --local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

  --color for equipped border texture (red, green, blue in RGB)
  local color_equipped = { r = 0.1, g = 0.5, b = 0.1, }


  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------

  local nomoreplay = function() end
   
  local function am(text)
    DEFAULT_CHAT_FRAME:AddMessage(text)
  end


  local function ntSetVertexColorFunc(nt, r, g, b, a)
    --do stuff
    if nt then
      local self = nt:GetParent()
      local action = self.action
      if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
        nt:SetVertexColor(color_equipped.r,color_equipped.g,color_equipped.b,1)
      elseif r==0.5 and g==0.5 and b==1 then
        --blizzard oom color
        nt:SetVertexColor(color.r,color.g,color.b,1)
      elseif r==1 and g==1 and b==1 then
        nt:SetVertexColor(color.r,color.g,color.b,1)
      end        
    end 
  end
  
  --initial style func
  local function rActionButtonStyler_AB_style(self)
  
    if not self.rabsstyle then
    
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
      
      nt:SetHeight(bu:GetHeight())
      nt:SetWidth(bu:GetWidth())
      nt:SetPoint("Center", 0, 0)
      
      bo:Hide()
      bo.Show = nomoreplay
      
      ho:SetFont(button_font, 18, "OUTLINE")
      co:SetFont(button_font, 18, "OUTLINE")
      na:SetFont(button_font, 12, "OUTLINE")
      if hide_hotkey == 1 then
        ho:Hide()
        ho.Show = nomoreplay
      end
      
      --hidename
      na:Hide()
    
      fl:SetTexture(rb2_flash_texture)
      bu:SetHighlightTexture(rb2_hover_texture)
      bu:SetPushedTexture(rb2_pushed_texture)
      bu:SetCheckedTexture(rb2_checked_texture)
      bu:SetNormalTexture(rb2_normal_texture)
    
      ic:SetTexCoord(0.1,0.9,0.1,0.9)
      ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
      ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
  
      cd:SetPoint("TOPLEFT", bu, "TOPLEFT", cooldownspacer, -cooldownspacer)
      cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -cooldownspacer, cooldownspacer)
    
      if ( IsEquippedAction(action) ) then
        bu:SetNormalTexture(rb2_equipped_texture)
        nt:SetVertexColor(color_equipped.r,color_equipped.g,color_equipped.b,1)
      else
        bu:SetNormalTexture(rb2_normal_texture)
        nt:SetVertexColor(color.r,color.g,color.b,1)
      end  
      
      --disable stuff
      nt.SetHeight = nomoreplay
      nt.SetWidth = nomoreplay
      fl.SetTexture = nomoreplay
      bu.SetHighlightTexture = nomoreplay
      bu.SetPushedTexture = nomoreplay
      bu.SetCheckedTexture = nomoreplay
      bu.SetNormalTexture = nomoreplay
      hooksecurefunc(nt, "SetVertexColor", ntSetVertexColorFunc)
      
      self.rabsstyle = true
    
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
  
      nt:SetHeight(bu:GetHeight())
      nt:SetWidth(bu:GetWidth())
      nt:SetPoint("Center", 0, 0)
      
      nt:SetVertexColor(color.r,color.g,color.b,1)
      
      fl:SetTexture(rb2_flash_texture)
      bu:SetHighlightTexture(rb2_hover_texture)
      bu:SetPushedTexture(rb2_pushed_texture)
      bu:SetCheckedTexture(rb2_checked_texture)
      bu:SetNormalTexture(rb2_normal_texture)
    
      ic:SetTexCoord(0.1,0.9,0.1,0.9)
      ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
      ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
      
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
  
      nt:ClearAllPoints()
      nt:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
      nt:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
      
      nt:SetVertexColor(color.r,color.g,color.b,1)
      
      fl:SetTexture(rb2_flash_texture)
      bu:SetHighlightTexture(rb2_hover_texture)
      bu:SetPushedTexture(rb2_pushed_texture)
      bu:SetCheckedTexture(rb2_checked_texture)
      bu:SetNormalTexture(rb2_normal_texture)
    
      ic:SetTexCoord(0.1,0.9,0.1,0.9)
      ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
      ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)  
    end    
  end
  
  ---------------------------------------
  -- CALLS // HOOKS
  ---------------------------------------
  
  hooksecurefunc("ActionButton_Update",   rActionButtonStyler_AB_style)
  hooksecurefunc("ShapeshiftBar_Update",   rActionButtonStyler_AB_styleshapeshift)
  hooksecurefunc("ShapeshiftBar_UpdateState",   rActionButtonStyler_AB_styleshapeshift)
  hooksecurefunc("PetActionBar_Update",   rActionButtonStyler_AB_stylepet)

local rb2_normal_texture    = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss";
local rb2_flash_texture     = "Interface\\AddOns\\rActionButtonStyler\\media\\flash";
local rb2_hover_texture     = "Interface\\AddOns\\rActionButtonStyler\\media\\hover";    
local rb2_pushed_texture    = "Interface\\AddOns\\rActionButtonStyler\\media\\pushed";
local rb2_checked_texture   = "Interface\\AddOns\\rActionButtonStyler\\media\\checked"; 
local rb2_equipped_texture  = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss_grey";

RANGE_INDICATOR = "";

function rActionButtonStyler_AB_style(self)

  local action = self.action;
  local name = self:GetName();
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
  
  ho:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
  co:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
  na:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")

  fl:SetTexture(rb2_flash_texture)
  bu:SetHighlightTexture(rb2_hover_texture)
  bu:SetPushedTexture(rb2_pushed_texture)
  bu:SetCheckedTexture(rb2_checked_texture)
  bu:SetNormalTexture(rb2_normal_texture)

  ic:SetTexCoord(0.1,0.9,0.1,0.9)
  ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
  ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)

  if ( IsEquippedAction(action) ) then
    bu:SetNormalTexture(rb2_equipped_texture);
    nt:SetVertexColor(0,0.5,0,1);
  else
    bu:SetNormalTexture(rb2_normal_texture);
    nt:SetVertexColor(1,1,1,1);
  end  

end

function rActionButtonStyler_AB_styleshapeshift()
  
  for i=1, NUM_SHAPESHIFT_SLOTS do
    local name = "ShapeshiftButton"..i;
    local bu  = _G[name]
    local ic  = _G[name.."Icon"]
    local fl  = _G[name.."Flash"]
    local nt  = _G[name.."NormalTexture"]

    nt:SetHeight(bu:GetHeight())
    nt:SetWidth(bu:GetWidth())
    nt:SetPoint("Center", 0, 0)
    
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

function rActionButtonStyler_AB_stylepet()
  
  for i=1, NUM_PET_ACTION_SLOTS do
    local name = "PetActionButton"..i;
    local bu  = _G[name]
    local ic  = _G[name.."Icon"]
    local fl  = _G[name.."Flash"]
    local nt  = _G[name.."NormalTexture2"]

    nt:SetHeight(bu:GetHeight())
    nt:SetWidth(bu:GetWidth())
    nt:SetPoint("Center", 0, 0)
    
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


function rActionButtonStyler_AB_fixgrid(button)
  local name = button:GetName();
  local action = button.action;
  local nt  = _G[name.."NormalTexture"]
  if ( IsEquippedAction(action) ) then
    nt:SetVertexColor(0,0.5,0,1);
  else
    nt:SetVertexColor(1,1,1,1);
  end  
end

function rActionButtonStyler_AB_equipped(self)

  local action = self.action;
  local name = self:GetName();
  local nt  = _G[name.."NormalTexture"]

  if ( IsEquippedAction(action) ) then
    nt:SetVertexColor(0,0.5,0,1);
  else
    nt:SetVertexColor(1,1,1,1);
  end  


end

hooksecurefunc("ActionButton_OnLoad",  rActionButtonStyler_AB_style);
hooksecurefunc("ActionButton_Update",   rActionButtonStyler_AB_style);
hooksecurefunc("ActionButton_ShowGrid", rActionButtonStyler_AB_fixgrid);
hooksecurefunc("ActionButton_OnUpdate", rActionButtonStyler_AB_equipped);

hooksecurefunc("ShapeshiftBar_OnLoad",   rActionButtonStyler_AB_styleshapeshift);
hooksecurefunc("ShapeshiftBar_Update",   rActionButtonStyler_AB_styleshapeshift);
hooksecurefunc("ShapeshiftBar_UpdateState",   rActionButtonStyler_AB_styleshapeshift);

hooksecurefunc("PetActionBar_Update",   rActionButtonStyler_AB_stylepet);
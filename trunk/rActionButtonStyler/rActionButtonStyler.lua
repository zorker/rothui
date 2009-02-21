
local rb2_normal_texture    = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss";
local rb2_flash_texture     = "Interface\\AddOns\\rActionButtonStyler\\media\\flash";
local rb2_hover_texture     = "Interface\\AddOns\\rActionButtonStyler\\media\\hover";    
local rb2_pushed_texture    = "Interface\\AddOns\\rActionButtonStyler\\media\\pushed";
local rb2_checked_texture   = "Interface\\AddOns\\rActionButtonStyler\\media\\checked"; 
local rb2_equipped_texture  = "Interface\\AddOns\\rActionButtonStyler\\media\\gloss_grey";

RANGE_INDICATOR = "";

--local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
--local color_rn = color.r*0.5
--local color_gn = color.g*0.5
--local color_bn = color.b*0.5

local color_rn = 0.37
local color_gn = 0.3
local color_bn = 0.3

local color_re = 0
local color_ge = 0.5
local color_be = 0

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
  co:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
  na:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
  ho:Hide()
  na:Hide()

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
    nt:SetVertexColor(color_re,color_ge,color_be,1);
  else
    bu:SetNormalTexture(rb2_normal_texture);
    nt:SetVertexColor(color_rn,color_gn,color_bn,1);
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
    
    nt:SetVertexColor(color_rn,color_gn,color_bn,1);
    
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
    nt:SetVertexColor(color_re,color_ge,color_be,1);
  else
    nt:SetVertexColor(color_rn,color_gn,color_bn,1);
  end  
end


function rActionButtonStyler_AB_styleshapeshift()
  
  for i=1, NUM_SHAPESHIFT_SLOTS do
    local name = "ShapeshiftButton"..i;
    local bu  = _G[name]
    local ic  = _G[name.."Icon"]
    local fl  = _G[name.."Flash"]
    local nt  = _G[name.."NormalTexture"]

    nt:ClearAllPoints()
    nt:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
    nt:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
    
    nt:SetVertexColor(color_rn,color_gn,color_bn,1);
    
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


hooksecurefunc("ActionButton_Update",   rActionButtonStyler_AB_style);
hooksecurefunc("ActionButton_ShowGrid", rActionButtonStyler_AB_fixgrid);
hooksecurefunc("ActionButton_OnUpdate", rActionButtonStyler_AB_fixgrid);

hooksecurefunc("ShapeshiftBar_OnLoad",   rActionButtonStyler_AB_styleshapeshift);
hooksecurefunc("ShapeshiftBar_Update",   rActionButtonStyler_AB_styleshapeshift);
hooksecurefunc("ShapeshiftBar_UpdateState",   rActionButtonStyler_AB_styleshapeshift);

hooksecurefunc("PetActionBar_Update",   rActionButtonStyler_AB_stylepet);


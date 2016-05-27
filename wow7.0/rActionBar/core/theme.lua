
-- rActionBar: core/theme
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Init
-----------------------------

--print("core","theme")

local function ResetNormalTexture(self, texture)
  if texture and texture ~= self.__normalTextureFile then
    self:SetNormalTexture(self.__normalTextureFile)
  end
end

local function ApplyPoints(self, points)
  if points then
    self:ClearAllPoints()
    for i, point in next, points do
      self:SetPoint(unpack(point))
    end
  else
    self:SetAllPoints()
  end
end

local function ApplyBackground(button,cfg)
  if not cfg.backdrop then return end
  local bg = CreateFrame("Frame", nil, button)
  ApplyPoints(bg, cfg.backdropPoints)
  bg:SetFrameLevel(button:GetFrameLevel()-1)
  bg:SetBackdrop(cfg.backdrop)
  if cfg.backdropColor then
    bg:SetBackdropColor(unpack(cfg.backdropColor))
  end
  if cfg.backdropBorderColor then
    bg:SetBackdropBorderColor(unpack(cfg.backdropBorderColor))
  end
end

local function StyleActionButton(button, cfg)
  if not button then return end
  if button.__styled then return end

  local buttonName = button:GetName()
  local icon = _G[buttonName.."Icon"]
  local flash = _G[buttonName.."Flash"]
  local flyoutBorder = _G[buttonName.."FlyoutBorder"]
  local flyoutBorderShadow = _G[buttonName.."FlyoutBorderShadow"]
  local flyoutArrow = _G[buttonName.."FlyoutArrow"]
  local hotKey = _G[buttonName.."HotKey"]
  local count = _G[buttonName.."Count"]
  local name = _G[buttonName.."Name"]
  local border = _G[buttonName.."Border"]
  local NewActionTexture = button.NewActionTexture
  local cooldown = _G[buttonName.."Cooldown"]
  local normalTexture = button:GetNormalTexture()
  local pushedTexture = button:GetPushedTexture()
  local highlightTexture = button:GetHighlightTexture()
  local checkedTexture = button:GetCheckedTexture()
  local floatingBG = _G[buttonName.."FloatingBG"]

  --hide stuff
  if floatingBG then floatingBG:Hide() end

  --flyout
  if flyoutBorder then flyoutBorder:SetTexture(nil) end
  if flyoutBorderShadow then flyoutBorderShadow:SetTexture(nil) end

  --BACKDROP

  ApplyBackground(button,cfg)

  --ICON

  --iconTexCoord
  if cfg.iconTexCoord then
    icon:SetTexCoord(unpack(cfg.iconTexCoord))
  end
  --iconPoints
   ApplyPoints(icon, cfg.iconPoints)

   --NORMALTEXTURE

  --normalTextureFile
  if cfg.normalTextureFile then
    button:SetNormalTexture(cfg.normalTextureFile)
    normalTexture = button:GetNormalTexture()
    button.__normalTextureFile = cfg.normalTextureFile
    hooksecurefunc(button, "SetNormalTexture", ResetNormalTexture)
  end
  --normalTexturePoints
  ApplyPoints(normalTexture, cfg.normalTexturePoints)
  --normalTextureColor
  if cfg.normalTextureColor then
    normalTexture:SetVertexColor(unpack(cfg.normalTextureColor))
  end

  button.__styled = true
end

function L:StyleExtraActionButton(cfg)

  local button = ExtraActionButton1

  if button.__styled then return end

  local buttonName = button:GetName()

  local icon = _G[buttonName.."Icon"]
  --local flash = _G[buttonName.."Flash"] --wierd the template has two textures of the same name
  local hotKey = _G[buttonName.."HotKey"]
  local count = _G[buttonName.."Count"]
  local art = button.style --artwork around the button
  local cooldown = _G[buttonName.."Cooldown"]

  local normalTexture = button:GetNormalTexture()
  --local pushedTexture = button:GetPushedTexture() --no push texture?!
  local highlightTexture = button:GetHighlightTexture()
  local checkedTexture = button:GetCheckedTexture()

  button.__styled = true
end

function L:StyleAllActionButtons(cfg)
  for i = 1, NUM_ACTIONBAR_BUTTONS do
    StyleActionButton(_G["ActionButton"..i],cfg)
    StyleActionButton(_G["MultiBarBottomLeftButton"..i],cfg)
    StyleActionButton(_G["MultiBarBottomRightButton"..i],cfg)
    StyleActionButton(_G["MultiBarRightButton"..i],cfg)
    StyleActionButton(_G["MultiBarLeftButton"..i],cfg)
  end
  for i = 1, 6 do
    StyleActionButton(_G["OverrideActionBarButton"..i],cfg)
  end
  --petbar buttons
  for i=1, NUM_PET_ACTION_SLOTS do
    StyleActionButton(_G["PetActionButton"..i],cfg)
  end
  --stancebar buttons
  for i=1, NUM_STANCE_SLOTS do
    StyleActionButton(_G["StanceButton"..i],cfg)
  end
  --possess buttons
  for i=1, NUM_POSSESS_SLOTS do
    StyleActionButton(_G["PossessButton"..i],cfg)
  end
end
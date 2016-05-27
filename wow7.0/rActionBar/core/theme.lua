
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

function L:StyleActionButton(button, cfg)
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

  --normalTexture
  if normalTextures and cfg.normalTexture then
    if cfg.normalTexture.textureFile then
      button:SetNormalTexture(cfg.normalTexture.textureFile)
      normalTexture = button:GetNormalTexture()
      normalTexture:SetAllPoints()
    end
    if cfg.normalTexture.color then
      normalTexture:SetVertexColor(unpack(cfg.normalTexture.color))
    end
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
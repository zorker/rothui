
  ---------------------------------------
  -- VARIABLES
  ---------------------------------------

  --get the addon namespace
  local addon, ns = ...

  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------

  --initial style func
  local function styleActionButton(bu)
    if not bu or (bu and bu.rabs_styled) then
      return
    end
    local action = bu.action
    local name = bu:GetName()
    local ic  = _G[name.."Icon"]
    local co  = _G[name.."Count"]
    local bo  = _G[name.."Border"]
    local ho  = _G[name.."HotKey"]
    local cd  = _G[name.."Cooldown"]
    local na  = _G[name.."Name"]
    local fl  = _G[name.."Flash"]
    local nt  = _G[name.."NormalTexture"]
    local fbg  = _G[name.."FloatingBG"]
    local fob = _G[name.."FlyoutBorder"]
    local fobs = _G[name.."FlyoutBorderShadow"]
    --floating background
    if fbg then fbg:Hide() end
    --flyout border
    if fob then fob:SetTexture(nil) end
    if fobs then fobs:SetTexture(nil) end
    --border
    bo:SetTexture(nil)
    --more textures
    --fl:SetTexture("abc")
    bu:SetHighlightTexture(nil)
    bu:SetPushedTexture(nil)
    bu:SetCheckedTexture(nil)
    bu:SetNormalTexture(nil)

    --icon
    ic:SetTexCoord(0,1,0,1)
    SetPortraitToTexture(ic,ic:GetTexture())
    hooksecurefunc(ic, "SetTexture", function(ic, texture)
      SetPortraitToTexture(ic,texture)
    end)

  end


  ---------------------------------------
  -- INIT
  ---------------------------------------

  local function init()
    --style the actionbar buttons
    for i = 1, NUM_ACTIONBAR_BUTTONS do
      styleActionButton(_G["ActionButton"..i])
      styleActionButton(_G["MultiBarBottomLeftButton"..i])
      styleActionButton(_G["MultiBarBottomRightButton"..i])
      styleActionButton(_G["MultiBarRightButton"..i])
      styleActionButton(_G["MultiBarLeftButton"..i])
    end
  end

  ---------------------------------------
  -- CALL
  ---------------------------------------

  local a = CreateFrame("Frame")
  a:RegisterEvent("PLAYER_LOGIN")
  a:SetScript("OnEvent", init)
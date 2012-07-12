
  --get the addon namespace
  local addon, ns = ...

  --get the config values
  local cfg = ns.cfg

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
    if not bu or (bu and bu.bg) then return end
    --shadows+background
    if bu:GetFrameLevel() < 1 then bu:SetFrameLevel(1) end
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

  --style extraactionbutton
  local function styleExtraActionButton(bu)
    if not bu or (bu and bu.rabs_styled) then return end
    local name = bu:GetName()
    local ho = _G[name.."HotKey"]
    --remove the style background theme
    bu.style:SetTexture(nil)
    hooksecurefunc(bu.style, "SetTexture", function(self, texture)
      if texture then
        --print("reseting texture: "..texture)
        self:SetTexture(nil)
      end
    end)
    --icon
    bu.icon:SetTexCoord(0.1,0.9,0.1,0.9)
    bu.icon:SetAllPoints(bu)
    --cooldown
    bu.cooldown:SetAllPoints(bu.icon)
    --hotkey
    ho:Hide()
    --add button normaltexture
    bu:SetNormalTexture(cfg.textures.normal)
    local nt = bu:GetNormalTexture()
    nt:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b,1)
    nt:SetAllPoints(bu)
    --apply background
    if not bu.bg then applyBackground(bu) end
    bu.rabs_styled = true
  end

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
    if fbg then fbg:Hide() end  --floating background
    --flyout border stuff
    if fob then fob:SetTexture(nil) end
    if fobs then fobs:SetTexture(nil) end
    bo:SetTexture(nil) --hide the border (plain ugly, sry blizz)
    --hotkey
    if cfg.hotkeys.show then
      ho:SetFont(cfg.font, cfg.hotkeys.fontsize, "OUTLINE")
      ho:ClearAllPoints()
      ho:SetPoint(cfg.hotkeys.pos1.a1,bu,cfg.hotkeys.pos1.x,cfg.hotkeys.pos1.y)
      ho:SetPoint(cfg.hotkeys.pos2.a1,bu,cfg.hotkeys.pos2.x,cfg.hotkeys.pos2.y)
    else
      ho:Hide()
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
    if not nt then
      --fix the non existent texture problem (no clue what is causing this)
      nt = bu:GetNormalTexture()
    end
    --cut the default border of the icons and make them shiny
    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
    --adjust the cooldown frame
    cd:SetPoint("TOPLEFT", bu, "TOPLEFT", cfg.cooldown.spacing, -cfg.cooldown.spacing)
    cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -cfg.cooldown.spacing, cfg.cooldown.spacing)
    --apply the normaltexture
    if action and  IsEquippedAction(action) then
      bu:SetNormalTexture(cfg.textures.equipped)
      nt:SetVertexColor(cfg.color.equipped.r,cfg.color.equipped.g,cfg.color.equipped.b,1)
    else
      bu:SetNormalTexture(cfg.textures.normal)
      nt:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b,1)
    end
    --make the normaltexture match the buttonsize
    nt:SetAllPoints(bu)
    --hook to prevent Blizzard from reseting our colors
    hooksecurefunc(nt, "SetVertexColor", function(nt, r, g, b, a)
      local bu = nt:GetParent()
      local action = bu.action
      --print("bu"..bu:GetName().."R"..r.."G"..g.."B"..b)
      if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
        if cfg.color.equipped.r == 1 and  cfg.color.equipped.g == 1 and  cfg.color.equipped.b == 1 then
          nt:SetVertexColor(0.999,0.999,0.999,1)
        else
          nt:SetVertexColor(cfg.color.equipped.r,cfg.color.equipped.g,cfg.color.equipped.b,1)
        end
      elseif r==0.5 and g==0.5 and b==1 then
        --blizzard oom color
        if cfg.color.normal.r == 0.5 and  cfg.color.normal.g == 0.5 and  cfg.color.normal.b == 1 then
          nt:SetVertexColor(0.499,0.499,0.999,1)
        else
          nt:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b,1)
        end
      elseif r==1 and g==1 and b==1 then
        if cfg.color.normal.r == 1 and  cfg.color.normal.g == 1 and  cfg.color.normal.b == 1 then
          nt:SetVertexColor(0.999,0.999,0.999,1)
        else
          nt:SetVertexColor(cfg.color.normal.r,cfg.color.normal.g,cfg.color.normal.b,1)
        end
      end
    end)
    --shadows+background
    if not bu.bg then applyBackground(bu) end
    bu.rabs_styled = true
  end

  local function styleLeaveButton(bu)
    if not bu or (bu and bu.rabs_styled) then return end
    --shadows+background
    if not bu.bg then applyBackground(bu) end
    bu.rabs_styled = true
  end

  --style pet buttons
  local function stylePetButton(bu)
    if not bu or (bu and bu.rabs_styled) then return end
    local name = bu:GetName()
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
    hooksecurefunc(bu, "SetNormalTexture", function(self, texture)
      --make sure the normaltexture stays the way we want it
      if texture and texture ~= cfg.textures.normal then
        self:SetNormalTexture(cfg.textures.normal)
      end
    end)
    --cut the default border of the icons and make them shiny
    ic:SetTexCoord(0.1,0.9,0.1,0.9)
    ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 2, -2)
    ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -2, 2)
    --shadows+background
    if not bu.bg then applyBackground(bu) end
    bu.rabs_styled = true
  end

  --style stance buttons
  local function styleStanceButton(bu)
    if not bu or (bu and bu.rabs_styled) then return end
    local name = bu:GetName()
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
    bu.rabs_styled = true
  end

  --style possess buttons
  local function stylePossessButton(bu)
    if not bu or (bu and bu.rabs_styled) then return end
    local name = bu:GetName()
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
    bu.rabs_styled = true
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
    for i = 1, 6 do
      styleActionButton(_G["OverrideActionBarButton"..i])
    end
    --style leave button
    styleLeaveButton(OverrideActionBarLeaveFrameLeaveButton)
    styleLeaveButton(rABS_LeaveVehicleButton)
    --petbar buttons
    for i=1, NUM_PET_ACTION_SLOTS do
      stylePetButton(_G["PetActionButton"..i])
    end
    --stancebar buttons
    for i=1, NUM_STANCE_SLOTS do
      styleStanceButton(_G["StanceButton"..i])
    end
    --possess buttons
    for i=1, NUM_POSSESS_SLOTS do
      stylePossessButton(_G["PossessButton"..i])
    end
    --extraactionbutton1
    styleExtraActionButton(ExtraActionButton1)
    --spell flyout
    SpellFlyoutBackgroundEnd:SetTexture(nil)
    SpellFlyoutHorizontalBackground:SetTexture(nil)
    SpellFlyoutVerticalBackground:SetTexture(nil)
    local function checkForFlyoutButtons(self)
      local NUM_FLYOUT_BUTTONS = 10
      for i = 1, NUM_FLYOUT_BUTTONS do
        styleActionButton(_G["SpellFlyoutButton"..i])
      end
    end
    SpellFlyout:HookScript("OnShow",checkForFlyoutButtons)
  
  end

  ---------------------------------------
  -- CALL
  ---------------------------------------

  local a = CreateFrame("Frame")
  a:RegisterEvent("PLAYER_LOGIN")
  a:SetScript("OnEvent", init)
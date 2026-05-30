local A, L = ...

---------------------------------------------------------------------
-- vars
---------------------------------------------------------------------

local darkColor =  { 0.5, 0.40, 0.35, 1 }
local darkAuraColor =  { 1, 0.9, 0.85, 1 }
local darkTextColor =  { 0.75, 0.73, 0.7, 1 }
local darkButtonColor =  { 0.85, 0.73, 0.7, 1 }

local visitedFrames = {}

---------------------------------------------------------------------
-- ApplyDarkMode(parent, region, colorOverride)
---------------------------------------------------------------------

local function ApplyDarkMode(parent, region, colorOverride)
  if not region then return end
  if issecretvalue(region) or region:IsForbidden() then
    return
  end
  region:SetDesaturated(true)
  local color = colorOverride or darkColor
  region:SetVertexColor(unpack(color))
  --region:SetBlendMode("ADD")
end

---------------------------------------------------------------------
-- SearchTexturesRecursive(parent, depth, filter)
---------------------------------------------------------------------

local function SearchTexturesRecursive(parent, depth, filter)
  if depth == 0 then visitedFrames = {} end
  if not parent or visitedFrames[parent] then return end
  visitedFrames[parent] = true
  --local indent = string.rep("  ", depth)
  local numRegions = parent.GetNumRegions and parent:GetNumRegions() or 0
  if numRegions > 0 then
    local regions = { parent:GetRegions() }
    for _, region in ipairs(regions) do
      if region and region.IsObjectType and region:IsObjectType("Texture") then
        --local regionName = region:GetName() or "Anonymous Texture"
        local textureFile = region:GetTexture()
        if (textureFile and not filter) or (textureFile and string.find(textureFile, filter)) then
          --print(string.format("%s|cff00ffff[Texture]|r Name: |cffffd100%s|r", indent, regionName))
          --print(string.format("%s   └─ Path/ID: %s", indent, tostring(textureFile)))
          ApplyDarkMode(parent, region)
        end
      end
    end
  end

  local numChildren = parent.GetNumChildren and parent:GetNumChildren() or 0
  if numChildren > 0 then
    local children = { parent:GetChildren() }
    for _, child in ipairs(children) do
      if child then
          --local childName = child:GetName() or "Anonymous Child Frame"
          --print(string.format("%s|cff00ff00[Child Frame]|r -> %s", indent, childName))
          SearchTexturesRecursive(child, depth + 1, filter)
      end
    end
  end
end

---------------------------------------------------------------------
-- InitDarkMode()
---------------------------------------------------------------------

local function InitDarkMode()

  ---------------------------------------------------------------------
  -- 136430 = MinimapButtonBorder
  ---------------------------------------------------------------------

  SearchTexturesRecursive(MinimapCluster, 0, "136430")

  ---------------------------------------------------------------------
  -- MinimapCompassTexture
  ---------------------------------------------------------------------

  ApplyDarkMode(MinimapBackdrop, MinimapCompassTexture)

  ---------------------------------------------------------------------
  -- TargetFrame
  ---------------------------------------------------------------------

  ApplyDarkMode(TargetFrame.TargetFrameContainer, TargetFrame.TargetFrameContainer.FrameTexture)
  TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Hide()
  TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText:ClearAllPoints()
  TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:SetPoint("TOPLEFT", TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, 3, -2)
  TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:SetPoint("TOPRIGHT", TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, -10, -2)
  TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon:SetAlpha(0)
  TargetFrame.TargetFrameContainer.Flash:SetAlpha(0.2)

  ---------------------------------------------------------------------
  -- FocusFrame
  ---------------------------------------------------------------------

  ApplyDarkMode(FocusFrame.TargetFrameContainer, FocusFrame.TargetFrameContainer.FrameTexture)
  FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Hide()
  FocusFrame.TargetFrameContent.TargetFrameContentMain.LevelText:ClearAllPoints()
  FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:SetPoint("TOPLEFT", FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, 3, -2)
  FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:SetPoint("TOPRIGHT", FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, -10, -2)
  FocusFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon:SetAlpha(0)
  FocusFrame.TargetFrameContainer.Flash:SetAlpha(0.2)

  ---------------------------------------------------------------------
  -- BuffFrame
  ---------------------------------------------------------------------

  for i=1, #BuffFrame.auraFrames do
    local aura = BuffFrame.auraFrames[i]
    --aura.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    layer, sublayer = aura.TempEnchantBorder:GetDrawLayer()
    aura.BuffBorder = aura:CreateTexture(nil, layer, nil, sublayer)
    aura.TempEnchantBorder:SetDrawLayer(layer, sublayer+1)
    aura.BuffBorder:SetSize(32,32) --40 if SetAuraBorderAtlas
    aura.BuffBorder:SetPoint("CENTER", aura.Icon)
    aura.BuffBorder:SetTexture([[Interface\Buttons\UI-TempEnchant-Border]])
    --AuraUtil.SetAuraBorderAtlas(aura.BuffBorder, nil, false)
    ApplyDarkMode(aura, aura.BuffBorder, darkAuraColor)
  end

  ---------------------------------------------------------------------
  -- ObjectiveTracker
  ---------------------------------------------------------------------

  ApplyDarkMode(ObjectiveTrackerFrame.Header, ObjectiveTrackerFrame.Header.Background)
  ObjectiveTrackerFrame.Header.Text:SetTextColor(unpack(darkTextColor))
  ApplyDarkMode(QuestObjectiveTracker.Header, QuestObjectiveTracker.Header.Background)
  QuestObjectiveTracker.Header.Text:SetTextColor(unpack(darkTextColor))
  ApplyDarkMode(CampaignQuestObjectiveTracker.Header, CampaignQuestObjectiveTracker.Header.Background)
  CampaignQuestObjectiveTracker.Header.Text:SetTextColor(unpack(darkTextColor))

  ---------------------------------------------------------------------
  -- TargetFrame buffs
  ---------------------------------------------------------------------

  hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(self, aura, index, numDebuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    if aura.BuffBorder then
      aura.BuffBorder:Show()
      return
    end
    layer, sublayer = aura.Stealable:GetDrawLayer()
    aura.BuffBorder = aura:CreateTexture(nil, layer, nil, sublayer-1)
    aura.BuffBorder:SetSize(aura.Stealable:GetSize())
    aura.BuffBorder:SetPoint("CENTER", aura.Icon)
    aura.BuffBorder:SetTexture([[Interface\Buttons\UI-TempEnchant-Border]])
    ApplyDarkMode(aura, aura.BuffBorder, darkAuraColor)
  end)

  ---------------------------------------------------------------------
  -- TargetFrame debuffs
  ---------------------------------------------------------------------

  hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(self, aura, index, numBuffs, anchorBuff, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    if aura.BuffBorder then
      aura.BuffBorder:Hide()
    end
  end)

  ---------------------------------------------------------------------
  -- Action buttons
  ---------------------------------------------------------------------

  for i = 1, 12 do
    ApplyDarkMode(_G["ActionButton" .. i], _G["ActionButton" .. i .. "NormalTexture"], darkButtonColor)
    ApplyDarkMode(_G["MultiBarBottomLeftButton" .. i], _G["MultiBarBottomLeftButton" .. i .. "NormalTexture"], darkButtonColor)
    ApplyDarkMode(_G["MultiBarBottomRightButton" .. i], _G["MultiBarBottomRightButton" ..i.. "NormalTexture"], darkButtonColor)
    ApplyDarkMode(_G["MultiBarRightButton" .. i], _G["MultiBarRightButton" ..i.. "NormalTexture"], darkButtonColor)
    ApplyDarkMode(_G["MultiBarLeftButton" .. i], _G["MultiBarLeftButton" ..i.. "NormalTexture"], darkButtonColor)
    ApplyDarkMode(_G["PetActionButton" .. i], _G["PetActionButton" ..i.. "NormalTexture"], darkButtonColor)
    ApplyDarkMode(_G["StanceButton" .. i], _G["StanceButton" ..i.. "NormalTexture"], darkButtonColor)
  end

  ---------------------------------------------------------------------
  -- StatusTracking bars
  ---------------------------------------------------------------------

  ApplyDarkMode(StatusTrackingBarManager.MainStatusTrackingBarContainer, StatusTrackingBarManager.MainStatusTrackingBarContainer.BarFrameTexture)
  ApplyDarkMode(StatusTrackingBarManager.SecondaryStatusTrackingBarContainer, StatusTrackingBarManager.SecondaryStatusTrackingBarContainer.BarFrameTexture)

end
L.F.InitDarkMode = InitDarkMode
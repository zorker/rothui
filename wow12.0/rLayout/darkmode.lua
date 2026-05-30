local A, L = ...

local darkColor =  { 0.5, 0.40, 0.35, 1 }
local darkTextColor =  { 0.75, 0.73, 0.7, 1 }

--tone down some colors

local function ApplyDarkMode(parent, region, textureFile)
  if not region then return end
  if issecretvalue(region) or region:IsForbidden() then
    return
  end
  region:SetDesaturated(true)
  region:SetVertexColor(unpack(darkColor))
  --region:SetBlendMode("ADD")
end

local visitedFrames = {}

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
          ApplyDarkMode(parent, region, textureFile)
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

local function InitDarkMode()

  SearchTexturesRecursive(MinimapCluster, 0, "136430")
  SearchTexturesRecursive(MinimapBackdrop, 0, "4618666")

  ApplyDarkMode(TargetFrame.TargetFrameContainer, TargetFrame.TargetFrameContainer.FrameTexture, nil)
  TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Hide()
  TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText:ClearAllPoints()
  TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:SetPoint("TOPLEFT", TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, 3, -2)
  TargetFrame.TargetFrameContent.TargetFrameContentMain.Name:SetPoint("TOPRIGHT", TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, -10, -2)
  TargetFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon:SetAlpha(0)

  ApplyDarkMode(FocusFrame.TargetFrameContainer, FocusFrame.TargetFrameContainer.FrameTexture, nil)
  FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor:Hide()
  FocusFrame.TargetFrameContent.TargetFrameContentMain.LevelText:ClearAllPoints()
  FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:SetPoint("TOPLEFT", FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, 3, -2)
  FocusFrame.TargetFrameContent.TargetFrameContentMain.Name:SetPoint("TOPRIGHT", FocusFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor, -10, -2)
  FocusFrame.TargetFrameContent.TargetFrameContentContextual.PvpIcon:SetAlpha(0)

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
    ApplyDarkMode(aura, aura.BuffBorder)
    aura.BuffBorder:SetVertexColor(1,0.9,0.85)
  end

  ApplyDarkMode(ObjectiveTrackerFrame.Header, ObjectiveTrackerFrame.Header.Background)
  ObjectiveTrackerFrame.Header.Text:SetTextColor(unpack(darkTextColor))

  ApplyDarkMode(CampaignQuestObjectiveTracker.Header, CampaignQuestObjectiveTracker.Header.Background)
  CampaignQuestObjectiveTracker.Header.Text:SetTextColor(unpack(darkTextColor))


end
L.F.InitDarkMode = InitDarkMode
local newPlates, namePlateIndex, _G, string = {}, nil, _G, string

WorldFrame:HookScript('OnUpdate', function(self)
  if not namePlateIndex then
    for _, blizzPlate in pairs({self:GetChildren()}) do
      local name = blizzPlate:GetName()
      if name and string.match(name, '^NamePlate%d+$') then
        namePlateIndex = string.gsub(name,'NamePlate','')
        break
      end
    end
  else
    local blizzPlate = _G["NamePlate"..namePlateIndex]
    if not blizzPlate then return end
    if not newPlates[blizzPlate] then
      local newPlate = CreateFrame('Frame', nil, WorldFrame)
      newPlate.id = namePlateIndex
      newPlate.blizzPlate = blizzPlate
      newPlates[blizzPlate] = newPlate
      namePlateIndex = namePlateIndex+1
      newPlate:SetSize(1, 1)      
      for i = 1, 500 do -- Make a bunch of regions for a stress test
        local fs = newPlate:CreateFontString(nil, nil, 'GameFontNormalHuge')
        fs:SetText(namePlateIndex)
        fs:SetPoint('CENTER', newPlate, math.random(-50,50), math.random(-12,12))
      end       
      -- Attach a frame to the nameblizzPlate which will fire OnSizeChanged when it moves
      local sizer = CreateFrame('Frame', nil, newPlate)
      sizer:SetPoint('BOTTOMLEFT', WorldFrame)
      sizer:SetPoint('TOPRIGHT', blizzPlate, 'CENTER')
      sizer:SetScript('OnSizeChanged', function(self, x, y)
        if blizzPlate:IsShown() then
          newPlate:Hide() -- Important, never move the frame while it's visible
          newPlate:SetPoint('CENTER', WorldFrame, 'BOTTOMLEFT', x, y) -- Immediately reposition frame
          newPlate:Show()
        end
      end)     
      blizzPlate:HookScript('OnHide', function() newPlate:Hide() end)
      blizzPlate:HookScript('OnShow', function() newPlate:Show() end)
    end
  end  
end)

  --addonName and namespace
  local addonName, ns = ...

  --container
  local core = CreateFrame("Frame")
  ns.core = core
  
  ---------------------------------------------
  -- FUNCTIONS
  ---------------------------------------------
  
  function core:CreateDropShadow(parent,edgeFile,edgeSize,padding)
    if parent.dropShadow then return end
    edgeFile = edgeFile or ""
    edgeSize = edgeSize or 8
    padding = padding or 8
    parent.dropShadow = CreateFrame("Frame", nil, parent)
    parent.dropShadow:SetPoint("TOPLEFT",-padding,padding)
    parent.dropShadow:SetPoint("BOTTOMRIGHT",padding,-padding)
    parent.dropShadow:SetBackdrop({ bgFile = nil, edgeFile = edgeFile, tile = false, tileSize = 16, edgeSize = edgeSize, insets = { left = 0, right = 0, top = 0, bottom = 0, }, })  
    local mt = getmetatable(parent).__index
    mt.SetDropShadowColor = function(self,r,g,b,a) self.dropShadow:SetBackdropBorderColor(r or 1, g or 1, b or 1, a or 1) end
  end
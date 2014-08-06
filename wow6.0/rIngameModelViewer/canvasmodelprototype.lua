
  -------------------------------------
  -- ADDON TABLES
  -------------------------------------

  local an, at = ...

  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- local variables
  local G, L, C = at.G, at.L, at.C

  --stuff from global scope
  local math, unpack  = math, unpack
  local PlaySound     = PlaySound
  local GT, UIP       = GameTooltip, UIParent

  -------------------------------------
  -- FUNCTIONS
  -------------------------------------

  L.canvasModelPrototype = {}

  --canvas UpdateModelPosition func
  function canvasModelPrototype:UpdatePosition(row,col)
    local size = self:GetParent().modelSize
    self:SetSize(size,size)
    self:SetPoint("TOPLEFT",size*row,size*col*(-1))
    self.title:SetFont(STANDARD_TEXT_FONT, math.max(size*10/100,8), "OUTLINE")
    self:Show()
  end

  --canvas ResetModelValues func
  function canvasModelPrototype:ResetValues()
    self.camDistanceScale = 1
    self.portraitZoom = 0
    self.posX = 0
    self.posY = 0
    self.rotation = 0
    self:SetPortraitZoom(self.portraitZoom)
    self:SetCamDistanceScale(self.camDistanceScale)
    self:SetPosition(0,self.posX,self.posY)
    self:SetRotation(self.rotation)
  end

  --canvas UpdateModelBackgroundColor func
  function canvasModelPrototype:UpdateBackgroundColor()
    self.color:SetVertexColor(unpack(C.modelBackgroundColor))
  end

  --canvas UpdateModelDisplayId func
  function canvasModelPrototype:UpdateDisplayId(displayId)
    self:ClearModel()
    --displayId 1 will return no model...so why not add the player model
    if displayId == 1 then
      self.unit = "player"
      self:SetUnit(self.unit)
    else
      self.unit = nil
      self:SetModel(C.defaultmodel) --in case setdisplayinfo fails
      self:SetDisplayInfo(displayId)
    end
    self.model = self:GetModel()
    self.displayId = displayId
    self.title:SetText(self.displayId)
    if self.model == C.defaultmodel then
      self:SetCamDistanceScale(0.4)
      self:SetPosition(0,0,0.5)
      self:EnableMouse(false)
      self:SetAlpha(0.4)
    else
      self:EnableMouse(true)
      self:SetAlpha(1)
    end
  end

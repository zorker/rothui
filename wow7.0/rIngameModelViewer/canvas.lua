
  -------------------------------------
  -- ADDON TABLES
  -------------------------------------

  local an, at = ...

  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- local variables
  local G, L, C, DB = at.G, at.L, at.C, at.DB

  --stuff from global scope
  local math, unpack, format  = math, unpack, format
  local PlaySound     = PlaySound
  local GT            = GameTooltip
  local pi, halfpi    = math.pi, math.pi / 2

  -------------------------------------
  -- FUNCTIONS
  -------------------------------------

  local function SetModelOrientation(self, distance, yaw, pitch)
    if not self:HasCustomCamera() then return end
    self.distance, self.yaw, self.pitch = distance, yaw, pitch
    local x = distance * math.cos(yaw) * math.cos(pitch)
    local y = distance * math.sin(- yaw) * math.cos(pitch)
    local z = (distance * math.sin(- pitch))
    self:SetCameraPosition(x, y, z)
  end

  local function LeftButtonOnUpdate(self, elapsed)
    if not self:HasCustomCamera() then return end
    if not self.pitch then return end
    local x, y = GetCursorPosition()
    local pitch = self.pitch + (y - self.cursorY) * pi / 256
    local limit = false
    if pitch > halfpi - 0.05 or pitch < - halfpi + 0.05 then
      limit = true
    end
    if limit then
      local rotation = format("%.0f", math.abs(math.deg(((x - self.cursorX) / 64 + self:GetFacing())) % 360))
      if rotation ~= format("%.0f", math.abs(math.deg(self:GetFacing()) % 360)) then
        self:SetRotation(math.rad(rotation))
        self.rotation = rotation
      end
    else
      local yaw = self.yaw + (x - self.cursorX) * pi / 256
      SetModelOrientation(self, self.distance, yaw, pitch)
    end
    self.cursorX, self.cursorY = x, y
  end

  local function RightButtonOnUpdate(self, elapsed)
    local x, y = GetCursorPosition()
    local px, py, pz = self:GetPosition()
    if IsShiftKeyDown() then
      local mx = format("%.2f", (px + (y - self.cursorY) / 100))
      if format("%.2f", px) ~= mx then
        self:SetPosition(mx, py, pz)
        self.posX, self.posY = py, pz
      end
    else
      local my = format("%.2f", (py + (x - self.cursorX) / 84))
      local mz = format("%.2f", (pz + (y - self.cursorY) / 84))
      if format("%.2f", py) ~= my or format("%.2f", pz) ~= mz then
        self:SetPosition(px, my, mz)
        self.posX, self.posY = my, mz
      end
    end
    self.cursorX, self.cursorY = x, y
  end

  local function MiddleButtonOnUpdate(self, elapsed)
    local x, y = GetCursorPosition()
    local rotation = format("%.0f", math.abs(math.deg(((x - self.cursorX) / 84 + self:GetFacing())) % 360))
    if rotation ~= format("%.0f", math.abs(math.deg(self:GetFacing()) % 360)) then
      self:SetRotation(math.rad(rotation))
      self.rotation = rotation
    end
    self.cursorX, self.cursorY = x, y
  end

  local function ResetModelValues(self)
    self.camDistanceScale = 1
    self.portraitZoom = 0
    self.posX = 0
    self.posY = 0
    self.rotation = 0
    self:SetPortraitZoom(self.portraitZoom)
    self:SetCamDistanceScale(self.camDistanceScale)
    self:SetPosition(0,self.posX,self.posY)
    self:SetRotation(self.rotation)
    self:RefreshCamera()
    self:SetCustomCamera(1)
    if self:HasCustomCamera() then
      local x, y, z = self:GetCameraPosition()
      local tx, ty, tz = self:GetCameraTarget()
      self:SetCameraTarget(0, ty, tz)
      if x == 0 then return end
      SetModelOrientation(self, math.sqrt(x * x + y * y + z * z), - math.atan(y / x), - math.atan(z / x))
    end
  end

  local function ModelOnMouseDown(self,button)
    if button == "LeftButton" then
      local canvas = self:GetParent()
      if canvas.isCanvas then
        if IsShiftKeyDown() then
          if self:HasCustomCamera() then
            self.cursorX, self.cursorY = GetCursorPosition()
            self:SetScript("OnUpdate", LeftButtonOnUpdate)
          end
        else
          if not canvas.overlay then canvas.overlay = canvas:CreateOverlay() end
          canvas.overlay:Enable(self.displayIndex)
        end
      else
        if self:HasCustomCamera() then
          self.cursorX, self.cursorY = GetCursorPosition()
          self:SetScript("OnUpdate", LeftButtonOnUpdate)
        end
      end
    elseif button == "RightButton" then
      if IsControlKeyDown() then
        ResetModelValues(self)
      else
        self.cursorX, self.cursorY = GetCursorPosition()
        self:SetScript("OnUpdate", RightButtonOnUpdate)
      end
    elseif button == "MiddleButton" then
      if IsControlKeyDown() then
        ResetModelValues(self)
      else
        self.cursorX, self.cursorY = GetCursorPosition()
        self:SetScript("OnUpdate", MiddleButtonOnUpdate)
      end
    end
  end

  local function ModelOnMouseUp(self, button)
    self:SetScript("OnUpdate", nil)
  end

  local function ModelOnMouseWheel(self,delta)
    if self:HasCustomCamera() then
      local max = 40
      local min = 0.1
      self.distance = math.min(math.max(self.distance-delta*0.15,min),max)
      SetModelOrientation(self, self.distance, self.yaw, self.pitch)
    else
      if IsShiftKeyDown() then
        local max = 1
        local min = 0
        self.portraitZoom = math.min(math.max(self.portraitZoom+delta*0.15,min),max)
        self:SetPortraitZoom(self.portraitZoom)
      else
        local max = 10
        local min = 0.1
        self.camDistanceScale = math.min(math.max(self.camDistanceScale-delta*0.15,min),max)
        self:SetCamDistanceScale(self.camDistanceScale)
      end
    end
  end

  local function ModelOnEnter(self)
    if not IsAltKeyDown() then return end
    local pz, px, py = self:GetPosition()
    pz, px, py = L:RoundNumber(pz), L:RoundNumber(px), L:RoundNumber(py)
    GT:SetOwner(self, "ANCHOR_CURSOR")
    --GT:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
    GT:AddLine("Model Info", 0, 1, 0.5, 1, 1, 1)
    GT:AddLine(" ")
    GT:AddDoubleLine("DisplayID", self:GetDisplayInfo(), 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetPosition", "("..pz..","..px..","..px..")", 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetRotation", self.rotation, 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("SetFacing", L:RoundNumber(self:GetFacing()), 1, 1, 1, 1, 1, 1)
    GT:AddDoubleLine("GetModel", self.model, 1, 1, 1, 1, 1, 1)
    if self:HasCustomCamera() then
      local x, y, z = self:GetCameraPosition()
      local tx, ty, tz = self:GetCameraTarget()
      x, y, z = L:RoundNumber(x), L:RoundNumber(y), L:RoundNumber(z)
      tx, ty, tz = L:RoundNumber(tx), L:RoundNumber(ty), L:RoundNumber(tz)
      GT:AddDoubleLine("CustomCamera", "true", 1, 1, 1, 1, 1, 1)
      GT:AddDoubleLine("SetCameraPosition", "("..x..","..y..","..z..")", 1, 1, 1, 1, 1, 1)
      GT:AddDoubleLine("SetCameraTarget", "("..tx..","..ty..","..tz..")", 1, 1, 1, 1, 1, 1)
    else
      GT:AddDoubleLine("CustomCamera", "false", 1, 1, 1, 1, 1, 1)
      GT:AddDoubleLine("SetCamDistanceScale", self.camDistanceScale, 1, 1, 1, 1, 1, 1)
      GT:AddDoubleLine("SetPortraitZoom", self.portraitZoom, 1, 1, 1, 1, 1, 1)
    end
    GT:AddLine(" ")
    if self.isOverlayModel then
      if self:HasCustomCamera() then
        GT:AddLine("Hold LEFT and drag mouse to move model camera.")
      else
        GT:AddLine("Model has no custom camera, cannot be moved freely with LEFT mouse.")
      end
    else
      GT:AddLine("Click LEFT for big overlay.")
      if self:HasCustomCamera() then
        GT:AddLine("Hold SHIFT + LEFT and drag mouse to move model camera.")
      end
    end
    GT:AddLine("Hold RIGHT and drag mouse to move model.")
    GT:AddLine("Hold MIDDLE and drag mouse to rotate model.")
    if self:HasCustomCamera() then
      GT:AddLine("Use MWHEEL to scale camera.")
    else
      GT:AddLine("Use MWHEEL to scale camera.")
      GT:AddLine("Use SHIFT + MWHEEL to zoom to portrait.")
    end
    GT:AddLine("Click CONTROL + RIGHT to reset.")
    GT:Show()
  end

  local function ModelOnLeave(self)
    GT:Hide()
  end

  local function UpdateModelPosition(self,row,col,size)
    self.title:SetFont(STANDARD_TEXT_FONT, math.max(size*10/100,8), "OUTLINE")
    self:SetSize(size,size)
    self:SetPoint("TOPLEFT",size*row,size*col*(-1))
    self:Show()
  end

  local function UpdateDisplayIndex(self,displayIndex)
    self.displayIndex = displayIndex
    self:ClearModel()
    self:EnableMouse(false)
    self:SetAlpha(0.3)
    self.title:SetText(self.displayIndex)
    self:SetDisplayInfo(self.displayIndex)
    --self:SetCreature(self.displayIndex)
    --self.model = self:GetModel()
    self.model = self.displayIndex
    if self.model == "" then
      --self.e404:Show()
      return
    end
    --self.e404:Hide()
    self:EnableMouse(true)
    self:SetAlpha(1)
  end

  --create model func
  local function CreateModel(self,id)
    --model frame
    local m = CreateFrame("PlayerModel",nil,self)
    --model attributes
    m.name = "model"..id
    m.id = id
    --model background (border)
    m.bg = m:CreateTexture(nil,"BACKGROUND",nil,-8)
    m.bg:SetColorTexture(1,1,1)
    m.bg:SetVertexColor(0,0,0,.2)
    m.bg:SetAllPoints()
    --model background color
    m.color = m:CreateTexture(nil,"BACKGROUND",nil,-7)
    m.color:SetColorTexture(1,1,1)
    --color bugfix
    m.color:SetVertexColor(unpack(DB.GLOB["COLOR"]))
    m.color:SetPoint("TOPLEFT", m, "TOPLEFT", 2, -2)
    m.color:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", -2, 2)
    --model title
    m.title = m:CreateFontString(nil, "BACKGROUND")
    m.title:SetFont(STANDARD_TEXT_FONT, 32, "OUTLINE")
    m.title:SetPoint("TOP", 0, -2)
    m.title:SetAlpha(.5)
    --no model found
    --m.e404 = m:CreateTexture(nil,"BACKGROUND",nil,-6)
    --m.e404:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
    --m.e404:SetPoint("CENTER")
    --m.e404:SetSize(40,40)
    --m.e404:SetAlpha(.5)
    --scripts
    m:SetScript("OnMouseWheel",ModelOnMouseWheel)
    m:SetScript("OnMouseDown",ModelOnMouseDown)
    m:SetScript("OnMouseUp",ModelOnMouseUp)
    m:SetScript("OnEnter",ModelOnEnter)
    m:SetScript("OnLeave",ModelOnLeave)

    return m
  end

  --create canvas func
  function L:CreateCanvas()

    --canvas frame
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("FULLSCREEN")
    f:SetAlpha(1)
    f:SetAllPoints()
    f:EnableMouse(true)

    --canvas attributes
    f.canvasWidth, f.canvasHeight = f:GetSize()
    f.canvasHeight  = f.canvasHeight-60 --remove 70px for the bottom bar
    f.modelSize     = DB.GLOB["MODELSIZE"]
    f.canvasPage    = DB.GLOB["PAGE"]
    f.M             = {}
    f.isCanvas      = true

    --canvas background
    f.bg = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    f.bg:SetAllPoints()
    f.bg:SetColorTexture(1,1,1)
    f.bg:SetVertexColor(0.15,0.15,0.15)

    --fade in anim
    f.fadeIn = f:CreateAnimationGroup()
    f.fadeIn.anim = f.fadeIn:CreateAnimation("Alpha")
    f.fadeIn.anim:SetDuration(0.8)
    f.fadeIn.anim:SetSmoothing("IN")
    f.fadeIn.anim:SetFromAlpha(0)
    f.fadeIn.anim:SetToAlpha(1)
    f.fadeIn:HookScript("OnFinished", function(self)
      self:GetParent():SetAlpha(1)
    end)

    --fade out anim
    f.fadeOut = f:CreateAnimationGroup()
    f.fadeOut.anim = f.fadeOut:CreateAnimation("Alpha")
    f.fadeOut.anim:SetDuration(0.8)
    f.fadeOut.anim:SetSmoothing("OUT")
    f.fadeOut.anim:SetFromAlpha(1)
    f.fadeOut.anim:SetToAlpha(0)
    f.fadeOut:HookScript("OnFinished", function(self)
      self:GetParent():SetAlpha(0)
      --hide canvas
      self:GetParent():Hide()
      --reset the color picker frame strata to the default value
      if ColorPickerFrame:GetFrameStrata() ~= L.defaultColorPickerFrameStrata then
        ColorPickerFrame:SetFrameStrata(L.defaultColorPickerFrameStrata)
      end
    end)

    -- canvas enable func
    function f:Enable()
      self:Show()
      self:UpdateAllModels() --model update has to be run, otherwise certain models stay hidden
      self.fadeIn:Play()
    end

    -- canvas disable func
    function f:Disable()
      self.fadeOut:Play()
    end

    --canvas close button
    f.closeButton = L:CreateButton(f,L.name.."CanvasCloseButton","Close")
    f.closeButton:SetPoint("BOTTOMRIGHT",-10,10)
    f.closeButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():Disable()
    end)
    f.closeButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GT:SetOwner(self, "ANCHOR_TOPRIGHT",0,5)
      GT:AddLine("Click to close.", 1, 1, 1, 1, 1, 1)
      GT:Show()
    end)
    f.closeButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GT:Hide()
    end)

    --canvas page editbox
    f.pageEditBox = L:CreateEditBox(f,L.name.."CanvasPageEditbox","Page",f.canvasPage)
    f.pageEditBox:SetPoint("BOTTOM",f,"BOTTOM",0,10)
    f.pageEditBox:SetScript("OnEnterPressed", function(self)
      PlaySound(C.sound.swap)
      local value = math.max(math.floor(self:GetNumber()),1)
      self:SetText(value)
      self:GetParent().canvasPage = value
      DB.GLOB["PAGE"] = self:GetParent().canvasPage
      self:GetParent():UpdateAllModels()
    end)

    --canvas next page button
    f.nextPageButton = L:CreateButton(f,L.name.."CanvasNextPageButton","next >")
    f.nextPageButton:SetPoint("LEFT",f.pageEditBox,"RIGHT",5,0)
    f.nextPageButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdatePage(1)
    end)
    f.nextPageButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GT:SetOwner(self, "ANCHOR_TOP",0,5)
      GT:AddLine("Click for next page.", 1, 1, 1, 1, 1, 1)
      GT:Show()
    end)
    f.nextPageButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GT:Hide()
    end)

    --canvas previous page button
    f.previousPageButton = L:CreateButton(f,L.name.."CanvasPreviousPageButton","< prev")
    f.previousPageButton:SetPoint("RIGHT",f.pageEditBox,"LEFT",-10,0)
    f.previousPageButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdatePage(-1)
    end)
    f.previousPageButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GT:SetOwner(self, "ANCHOR_TOP",0,5)
      GT:AddLine("Click for previous page.", 1, 1, 1, 1, 1, 1)
      GT:Show()
    end)
    f.previousPageButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GT:Hide()
    end)

    --canvas color picker button
    f.colorPickerButton = L:CreateColorPickerButton(f,L.name.."CanvasColorPickerButton")
    f.colorPickerButton:SetPoint("BOTTOMLEFT",10,10)
    f.colorPickerButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GT:SetOwner(self, "ANCHOR_TOPLEFT",0,5)
      GT:AddLine("Click for color picker.", 1, 1, 1, 1, 1, 1)
      GT:Show()
    end)
    f.colorPickerButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GT:Hide()
    end)
    --canvas color picker button update color func
    function f.colorPickerButton:UpdateColor(r,g,b)
      DB.GLOB["COLOR"] = {r,g,b}
      self:GetParent():UpdateAllColors(r,g,b)
    end

    --canvas minus size button
    f.minusSizeButton = L:CreateButton(f,L.name.."CanvasMinusSizeButton","- size")
    f.minusSizeButton:SetPoint("LEFT",f.colorPickerButton,"RIGHT",10,0)
    f.minusSizeButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdateModelSize(-20)
    end)
    f.minusSizeButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GT:SetOwner(self, "ANCHOR_TOP",0,5)
      GT:AddLine("Click for decreased model size.", 1, 1, 1, 1, 1, 1)
      GT:Show()
    end)
    f.minusSizeButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GT:Hide()
    end)

    --canvas plus size button
    f.plusSizeButton = L:CreateButton(f,L.name.."CanvasPlusSizeButton","+ size")
    f.plusSizeButton:SetPoint("LEFT",f.minusSizeButton,"RIGHT",5,0)
    f.plusSizeButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdateModelSize(20)
    end)
    f.plusSizeButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GT:SetOwner(self, "ANCHOR_TOP",0,5)
      GT:AddLine("Click for increased model size.", 1, 1, 1, 1, 1, 1)
      GT:Show()
    end)
    f.plusSizeButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GT:Hide()
    end)

    --canvas displayid editbox
    f.displayIdEditBox = L:CreateEditBox(f,L.name.."CanvasDisplayIdEditbox","DisplayId",1)
    f.displayIdEditBox:SetPoint("LEFT",f.plusSizeButton,"RIGHT",20,0)
    f.displayIdEditBox:SetScript("OnEnterPressed", function(self)
      PlaySound(C.sound.swap)
      local value = math.max(math.floor(self:GetNumber()),1)
      self:SetText(value)
      self:GetParent():UpdatePageForDisplayID(value)
    end)

    --canvas UpdateModelSize func
    function f:UpdateModelSize(value)
      if (self.modelSize+value) < 50 and value < 0 then return end
      if (self.modelSize+value) > 400 and value > 0 then return end
      self.modelSize = self.modelSize+value
      DB.GLOB["MODELSIZE"] = self.modelSize
      self:UpdateAllModels()
    end

    --canvas UpdatePage func
    function f:UpdatePage(value)
      if self.canvasPage == 1 and value < 0 then return end
      self.canvasPage = self.canvasPage+value
      DB.GLOB["PAGE"] = self.canvasPage
      self.pageEditBox:SetText(self.canvasPage)
      self:UpdateAllModels()
    end

    --canvas GetPageForDisplayID func
    function f:UpdatePageForDisplayID(displayId)
      self.canvasPage = math.max(math.ceil(displayId/self.modelCount),1)
      DB.GLOB["PAGE"] = self.canvasPage
      self.pageEditBox:SetText(self.canvasPage)
      self:UpdateAllModels()
    end

    --canvas GetFirstDisplayIdOfPage func
    function f:GetFirstDisplayIdOfPage()
      return ((self.canvasPage*self.modelCount)+1)-self.modelCount
    end

    --canvas UpdateAllColors func
    function f:UpdateAllColors(r,g,b)
      for i, model in pairs(self.M) do
        model.color:SetVertexColor(r,g,b)
      end
      if self.overlay then
        self.overlay.model.color:SetVertexColor(r,g,b)
        self.overlay.colorPickerButton.color:SetVertexColor(r,g,b)
      end
      self.colorPickerButton.color:SetVertexColor(r,g,b)
      --self.bg:SetVertexColor(r*0.1,g*0.1,b*0.1)
    end

    --canvas HideAllModels func
    function f:HideAllModels()
      for i, model in pairs(self.M) do
        model:ClearAllPoints()
        model:Hide()
      end
    end

    --canvas UpdateAllModels func
    function f:UpdateAllModels()
      self:HideAllModels()
      self.modelRows = math.floor(self.canvasHeight/self.modelSize)
      self.modelCols = math.floor(self.canvasWidth/self.modelSize)
      self.modelCount = self.modelRows*self.modelCols
      self.displayIdEditBox:SetText(self:GetFirstDisplayIdOfPage())
      local id = 1
      for i=1, self.modelRows do
        for k=1, self.modelCols do
          if not self.M[id] then
            self.M[id] = CreateModel(self,id)
          end
          UpdateModelPosition(self.M[id],k-1,i-1,self.modelSize)
          UpdateDisplayIndex(self.M[id],self.M[id].id+self.modelCount*(self.canvasPage-1))
          ResetModelValues(self.M[id])
          id = id+1
        end--for cols
      end--for rows
    end

    --create overlay
    function f:CreateOverlay()

      local f = CreateFrame("Frame",nil,self)
      f:SetFrameStrata("FULLSCREEN_DIALOG")
      f:SetAllPoints()
      f:EnableMouse(true)
      f:SetAlpha(1)

      f.bg = f:CreateTexture(nil, "BACKGROUND",nil,-8)
      f.bg:SetColorTexture(1,1,1)
      f.bg:SetVertexColor(0.15,0.15,0.15)
      f.bg:SetAllPoints()

      --overlay model
      f.model = CreateModel(f,1)
      f.model:SetPoint("TOPLEFT",100,-10)
      f.model:SetPoint("BOTTOMLEFT",100,10)
      f.model:SetPoint("TOPRIGHT",-100,-10)
      f.model:SetPoint("BOTTOMRIGHT",-100,10)
      f.model.isOverlayModel = true

      --overlay color picker button
      f.colorPickerButton = L:CreateColorPickerButton(f,L.name.."CanvasOverlayColorPickerButton")
      f.colorPickerButton:SetPoint("BOTTOMLEFT",10,10)
      f.colorPickerButton:HookScript("OnEnter", function(self)
        --PlaySound(C.sound.select)
        GT:SetOwner(self, "ANCHOR_TOPLEFT",0,5)
        GT:AddLine("Click for color picker.", 1, 1, 1, 1, 1, 1)
        GT:Show()
      end)
      f.colorPickerButton:HookScript("OnLeave", function(self)
        --PlaySound(C.sound.swap)
        GT:Hide()
      end)
      --canvas color picker button update color func
      function f.colorPickerButton:UpdateColor(r,g,b)
        DB.GLOB["COLOR"] = {r,g,b}
        self:GetParent():GetParent():UpdateAllColors(r,g,b)
      end

      --canvas next button
      f.nextButton = L:CreateButton(f,L.name.."CanvasOverlayNextButton","next >")
      f.nextButton:SetPoint("LEFT",f.model,"RIGHT",10,0)
      f.nextButton.text:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
      f.nextButton:SetHeight(50)
      f.nextButton:SetWidth(f.nextButton.text:GetStringWidth()+20)
      f.nextButton:HookScript("OnClick", function(self)
        PlaySound(C.sound.click)
        self:GetParent():Next()
      end)
      f.nextButton:HookScript("OnEnter", function(self)
        --PlaySound(C.sound.select)
        GT:SetOwner(self, "ANCHOR_TOP",0,5)
        GT:AddLine("Click for next model.", 1, 1, 1, 1, 1, 1)
        GT:Show()
      end)
      f.nextButton:HookScript("OnLeave", function(self)
        --PlaySound(C.sound.swap)
        GT:Hide()
      end)

      --canvas previous button
      f.previousButton = L:CreateButton(f,L.name.."CanvasOverlayPreviousButton","< prev")
      f.previousButton:SetPoint("RIGHT",f.model,"LEFT",-10,0)
      f.previousButton.text:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
      f.previousButton:SetHeight(50)
      f.previousButton:SetWidth(f.previousButton.text:GetStringWidth()+20)
      f.previousButton:HookScript("OnClick", function(self)
        PlaySound(C.sound.click)
        self:GetParent():Previous()
      end)
      f.previousButton:HookScript("OnEnter", function(self)
        --PlaySound(C.sound.select)
        GT:SetOwner(self, "ANCHOR_TOP",0,5)
        GT:AddLine("Click for previous model.", 1, 1, 1, 1, 1, 1)
        GT:Show()
      end)
      f.previousButton:HookScript("OnLeave", function(self)
        --PlaySound(C.sound.swap)
        GT:Hide()
      end)

      --fade in anim
      f.fadeIn = f:CreateAnimationGroup()
      f.fadeIn.anim = f.fadeIn:CreateAnimation("Alpha")
      f.fadeIn.anim:SetDuration(0.8)
      f.fadeIn.anim:SetSmoothing("IN")
      f.fadeIn.anim:SetFromAlpha(0)
      f.fadeIn.anim:SetToAlpha(1)
      f.fadeIn:HookScript("OnFinished", function(self)
        self:GetParent():SetAlpha(1)
      end)

      --fade out anim
      f.fadeOut = f:CreateAnimationGroup()
      f.fadeOut.anim = f.fadeOut:CreateAnimation("Alpha")
      f.fadeOut.anim:SetDuration(0.8)
      f.fadeOut.anim:SetSmoothing("OUT")
      f.fadeOut.anim:SetFromAlpha(1)
      f.fadeOut.anim:SetToAlpha(0)
      f.fadeOut:HookScript("OnFinished", function(self)
        self:GetParent():SetAlpha(0)
        self:GetParent():Hide()
      end)

      -- previous model
      function f:Previous()
        UpdateDisplayIndex(self.model,math.max(self.model.displayIndex-1,1))
        ResetModelValues(self.model)
      end

      -- next model
      function f:Next()
        UpdateDisplayIndex(self.model,self.model.displayIndex+1)
        ResetModelValues(self.model)
      end

      -- canvas enable func
      function f:Enable(displayIndex)
        self:Show()
        UpdateDisplayIndex(self.model,displayIndex)
        ResetModelValues(self.model)
        self.fadeIn:Play()
      end

      -- canvas disable func
      function f:Disable()
        self.fadeOut:Play()
      end

      f:SetScript("OnMouseDown", function(self)
        PlaySound(C.sound.click)
        self:Disable()
      end)

      f:HookScript("OnEnter", function(self)
        GT:SetOwner(self, "ANCHOR_CURSOR")
        GT:AddLine("Click for close the overlay.", 1, 1, 1, 1, 1, 1)
        GT:Show()
      end)
      f:HookScript("OnLeave", function(self)
        GT:Hide()
      end)

      return f

    end

    return f

  end
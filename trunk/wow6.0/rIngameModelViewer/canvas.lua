
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
  local GT            = GameTooltip

  -------------------------------------
  -- FUNCTIONS
  -------------------------------------

  --create canvas func
  function L:CreateCanvas()

    --canvas frame
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetFrameStrata("FULLSCREEN")
    f:SetAlpha(0)
    f:SetAllPoints()
    f:EnableMouse(true)

    --canvas attributes
    f.canvasWidth, f.canvasHeight = f:GetSize()
    f.canvasHeight  = f.canvasHeight-60 --remove 70px for the bottom bar
    f.modelSize     = 200
    f.canvasPage    = 1
    f.M             = {}

    --canvas background
    f.bg = f:CreateTexture(nil,"BACKGROUND",nil,-8)
    f.bg:SetAllPoints()
    f.bg:SetTexture(1,1,1)
    local r,g,b = unpack(C.modelBackgroundColor)
    f.bg:SetVertexColor(r*0.1,g*0.1,b*0.1)

    --[[
    f.panelBg = f:CreateTexture(nil,"BACKGROUND",nil,-7)
    f.panelBg:SetPoint("BOTTOMLEFT")
    f.panelBg:SetPoint("BOTTOMRIGHT")
    f.panelBg:SetHeight(60)
    f.panelBg:SetTexture(1,1,1)
    f.panelBg:SetVertexColor(0.15,0.15,0.15)
    ]]--

    --fade in anim
    f.fadeIn = f:CreateAnimationGroup()
    f.fadeIn.anim = f.fadeIn:CreateAnimation("Alpha")
    f.fadeIn.anim:SetDuration(0.8)
    f.fadeIn.anim:SetSmoothing("IN")
    f.fadeIn.anim:SetChange(1)
    f.fadeIn:HookScript("OnFinished", function(self)
      self:GetParent():SetAlpha(1)
    end)

    --fade out anim
    f.fadeOut = f:CreateAnimationGroup()
    f.fadeOut.anim = f.fadeOut:CreateAnimation("Alpha")
    f.fadeOut.anim:SetDuration(0.8)
    f.fadeOut.anim:SetSmoothing("OUT")
    f.fadeOut.anim:SetChange(-1)
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
      C.modelBackgroundColor = {r,g,b}
      self:GetParent():UpdateAllModelBackgroundColors()
      self:GetParent().bg:SetVertexColor(r*0.1,g*0.1,b*0.1)
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

    --canvas UpdateModelCount func
    function f:UpdateModelCount()
      self.modelRows = math.floor(self.canvasHeight/self.modelSize)
      self.modelCols = math.floor(self.canvasWidth/self.modelSize)
      self.modelCount = self.modelRows*self.modelCols
    end

    --canvas UpdateModelSize func
    function f:UpdateModelSize(value)
      if (self.modelSize+value) < 50 and value < 0 then return end
      if (self.modelSize+value) > 400 and value > 0 then return end
      self.modelSize = self.modelSize+value
      self:UpdateAllModels()
    end

    --canvas UpdatePage func
    function f:UpdatePage(value)
      if self.canvasPage == 1 and value < 0 then return end
      self.canvasPage = self.canvasPage+value
      self.pageEditBox:SetText(self.canvasPage)
      self:UpdateAllModels()
    end

    --canvas GetPageForDisplayID func
    function f:UpdatePageForDisplayID(displayId)
      self.canvasPage = math.max(math.ceil(displayId/self.modelCount),1)
      self.pageEditBox:SetText(self.canvasPage)
      self:UpdateAllModels()
    end

    --canvas GetFirstDisplayIdOfPage func
    function f:GetFirstDisplayIdOfPage()
      return ((self.canvasPage*self.modelCount)+1)-self.modelCount
    end

    --canvas UpdateAllModelBackgroundColors func
    function f:UpdateAllModelBackgroundColors()
      for i, model in pairs(self.M) do
        model.color:SetVertexColor(unpack(C.modelBackgroundColor))
      end
    end

    --canvas UpdateAllModels func
    function f:UpdateAllModels()
      self:HideAllModels()
      self:UpdateModelCount()
      self.displayIdEditBox:SetText(self:GetFirstDisplayIdOfPage())
      local id = 1
      for i=1, self.modelRows do
        for k=1, self.modelCols do
          if not self.M[id] then
            self.M[id] = self:CreateModel(id)
          end
          self:UpdateModelPosition(self.M[id],k-1,i-1)
          self:ResetModelValues(self.M[id])
          self:UpdateDisplayIndex(self.M[id])
          id = id+1
        end--for cols
      end--for rows
    end

    --canvas HideAllModels func
    function f:HideAllModels()
      for i, model in pairs(self.M) do
        model:ClearAllPoints()
        model:Hide()
      end
    end

    function f:UpdateModelPosition(model,row,col)
      model.title:SetFont(STANDARD_TEXT_FONT, math.max(self.modelSize*10/100,8), "OUTLINE")
      model:SetSize(self.modelSize,self.modelSize)
      model:SetPoint("TOPLEFT",self.modelSize*row,self.modelSize*col*(-1))
      model.displayIndex = model.id+self.modelCount*(self.canvasPage-1)
      model.title:SetText("not found")
      model:Show()
    end

    function f:UpdateDisplayIndex(model)
      model:SetDisplayInfo(model.displayIndex)
      --model:SetCreature(model.displayIndex)
      model.model = model:GetModel()
      if model.model == "" then return end
      model:EnableMouse(true)
      model:SetAlpha(1)
      model.title:SetText(model.displayIndex)
    end

    function f:ResetModelValues(model)
      model.camDistanceScale = 1
      model.portraitZoom = 0
      model.posX = 0
      model.posY = 0
      model.rotation = 0
      model:SetPortraitZoom(model.portraitZoom)
      model:SetCamDistanceScale(model.camDistanceScale)
      model:SetPosition(0,model.posX,model.posY)
      model:SetRotation(model.rotation)
      model:ClearModel()
      model:EnableMouse(false)
      model:SetAlpha(0.3)
    end

    --create model func
    function f:CreateModel(id)
      --model frame
      local m = CreateFrame("PlayerModel",nil,self)
      --model attributes
      m.name = "model"..id
      m.id = id
      --model background (border)
      m.bg = m:CreateTexture(nil,"BACKGROUND",nil,-8)
      m.bg:SetTexture(0,0,0,.2)
      m.bg:SetAllPoints()
      --model background color
      m.color = m:CreateTexture(nil,"BACKGROUND",nil,-7)
      m.color:SetTexture(1,1,1)
      --color bugfix
      m.color:SetVertexColor(unpack(C.modelBackgroundColor))
      m.color:SetPoint("TOPLEFT", m, "TOPLEFT", 2, -2)
      m.color:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", -2, 2)
      --model title
      m.title = m:CreateFontString(nil, "BACKGROUND")
      m.title:SetPoint("TOP", 0, -2)
      m.title:SetAlpha(.5)
      return m
    end

    return f

  end
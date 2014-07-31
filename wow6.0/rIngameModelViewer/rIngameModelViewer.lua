
  -- rIngameModelViewer
  -- zork 2014

  -------------------------------------
  -- ADDON TABLES
  -------------------------------------

  local an, at = ...

  at.G = {} --global (if any)
  at.L = {} --local
  at.C = {} --config
  at.M = {} --models

  -------------------------------------
  -- VARIABLES
  -------------------------------------

  -- local variables
  local G, L, C, M = at.G, at.L, at.C, at.M

  -- version stuff
  L.name          = an
  L.version       = GetAddOnMetadata(L.name, "Version")
  L.versionNumber = tonumber(L.version)
  L.locale        = GetLocale()

  --stuff from global scope
  local math, unpack  = math, unpack
  local PlaySound     = PlaySound
  local GT, UIP, CPF  = GameTooltip, UIParent, ColorPickerFrame

  CPF:SetFrameStrata("FULLSCREEN_DIALOG")

  -------------------------------------
  -- CONFIG
  -------------------------------------

  C.sound = {}
  C.sound.select =  "igcreatureaggroselect"
  C.sound.swap    = "interfacesound_losttargetunit"
  C.sound.click   = "igmainmenuoption"
  C.sound.clack   = "igmainmenulogout"

  C.modelBackgroundColor = {1,1,1}

  C.defaultmodel = "interface\\buttons\\talktomequestionmark.m2"

  C.backdrop = {
    bgFile = "",
    edgeFile = "interface\\tooltips\\ui-tooltip-border",
    tile = false,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  }

  -------------------------------------
  -- FUNCTIONS
  -------------------------------------

  --create button func
  function L:CreateButton(parent,name,text,adjustWidth,adjustHeight)

    --button frame
    local b = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    b.text = _G[b:GetName().."Text"]
    b.text:SetText(text)
    b:SetWidth(b.text:GetStringWidth()+(adjustWidth or 20))
    b:SetHeight(b.text:GetStringHeight()+(adjustHeight or 12))

    return b

  end

  --create color picker button func
  function L:CreateColorPickerButton(parent,name)

    --color picker button frame
    local b = CreateFrame("Button", name, parent)
    b:SetSize(75,25)
    b:SetBackdrop(C.backdrop)
    b:SetBackdropBorderColor(0.5,0.5,0.5)

    --color picker background color
    b.color = b:CreateTexture(nil,"BACKGROUND",nil,-7)
    b.color:SetPoint("TOPLEFT",4,-4)
    b.color:SetPoint("BOTTOMRIGHT",-4,4)
    b.color:SetTexture(unpack(C.modelBackgroundColor))

    --color picker Callback func
    function b:Callback(color)
      if not color then color = {CPF:GetColorRGB()} end
      --to bad no self reference is available
      b.color:SetVertexColor(unpack(color))
      --call the object specific UpdateColor func
      b:UpdateColor(unpack(color))
    end

    --color picker OnClick func
    b:HookScript("OnClick", function(self)
      --set the callback functions
      local r,g,b = self.color:GetVertexColor()
      local a = nil
      CPF.func, CPF.opacityFunc, CPF.cancelFunc = self.Callback, self.Callback, self.Callback
      CPF.hasOpacity, CPF.opacity = (a ~= nil), a
      CPF.previousValues = {r,g,b,a}
      CPF:Hide()
      CPF:Show()
      CPF:SetColorRGB(r,g,b)
    end)

    return b

  end

  --create canvas func
  function L:CreateCanvas()

    --print("creating canvas")

    --canvas frame
    local f = CreateFrame("Frame",nil,UIP)
    f:SetFrameStrata("FULLSCREEN")
    f:SetAlpha(0)
    f:SetAllPoints()
    f:EnableMouse(true)

    --canvas attributes
    f.canvasWidth, f.canvasHeight = f:GetSize()
    f.canvasHeight  = f.canvasHeight-70 --remove 70px for the bottom bar
    f.modelSize     = 200
    f.canvasPage    = 1

    --canvas background
    f.bg = f:CreateTexture()
    f.bg:SetAllPoints()
    f.bg:SetTexture(1,1,1)
    local r,g,b = unpack(C.modelBackgroundColor)
    f.bg:SetVertexColor(r*0.1,g*0.1,b*0.1)

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
    end)

    -- canvas enable func
    function f:Enable()
      self:Show()
      self:UpdateModels() --model update has to be run, otherwise certain models stay hidden
      self.fadeIn:Play()
      --print("enabling")
    end

    -- canvas disable func
    function f:Disable()
      self.fadeOut:Play()
      --print("disabling")
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

    --canvas next page button
    f.nextPageButton = L:CreateButton(f,L.name.."CanvasNextPageButton","next >")
    f.nextPageButton:SetPoint("BOTTOMRIGHT",-200,10)
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
    f.previousPageButton:SetPoint("BOTTOMRIGHT",-400,10)
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
      self:GetParent():UpdateAllModelBackgrounds()
      self:GetParent().bg:SetVertexColor(r*0.1,g*0.1,b*0.1)
    end

    --canvas minus size button
    f.minusSizeButton = L:CreateButton(f,L.name.."CanvasMinusSizeButton","- size")
    f.minusSizeButton:SetPoint("LEFT",f.colorPickerButton,"RIGHT",10,0)
    f.minusSizeButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdateModelSize(-50)
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
    f.plusSizeButton:SetPoint("LEFT",f.minusSizeButton,"RIGHT",10,0)
    f.plusSizeButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdateModelSize(50)
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

    --create model func
    function f:CreateModel(id)
      --print("creating new model",id)
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

    --canvas UpdateModelCount func
    function f:UpdateModelCount()
      self.modelRows = math.floor(self.canvasHeight/self.modelSize)
      self.modelCols = math.floor(self.canvasWidth/self.modelSize)
      self.modelCount = self.modelRows*self.modelCols
    end

    --canvas UpdateModelSize func
    function f:UpdateModelSize(value)
      if (self.modelSize+value) < 50 and value < 0 then return end
      if (self.modelSize+value) > self.canvasHeight and value > 0 then return end
      self.modelSize = self.modelSize+value
      self:UpdateModels()
    end

    --canvas UpdateModelPosition func
    function f:UpdateModelPosition(model,row,col)
      local size = self.modelSize
      model:SetSize(size,size)
      model:SetPoint("TOPLEFT",size*row,size*col*(-1))
      model.title:SetFont(STANDARD_TEXT_FONT, math.max(size*10/100,8), "OUTLINE")
      model:Show()
    end

    --canvas ResetModelValues func
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
    end

    --canvas UpdateModelBackgroundColor func
    function f:UpdateModelBackgroundColor(model)
      model.color:SetVertexColor(unpack(C.modelBackgroundColor))
    end

    --canvas UpdateModelDisplayId func
    function f:UpdateModelDisplayId(model,displayId)
      model:ClearModel()
      model:SetModel(C.defaultmodel) --in case setdisplayinfo fails
      model:SetDisplayInfo(displayId)
      model.model = model:GetModel()
      model.displayId = displayId
      model.title:SetText(model.displayId)
      if model.model == C.defaultmodel then
        model:SetCamDistanceScale(0.4)
        model:SetPosition(0,0,0.5)
        model:EnableMouse(false)
        model:SetAlpha(0.4)
      else
        model:EnableMouse(true)
        model:SetAlpha(1)
      end
    end

    --canvas UpdatePage func
    function f:UpdatePage(value)
      if self.canvasPage == 1 and value < 0 then return end
      self.canvasPage = self.canvasPage+value
      self:UpdateModels()
    end

    --canvas CalcPageForDisplayID func
    function f:CalcPageForDisplayID(displayId)
      self.canvasPage = math.max(math.ceil(displayId/self.modelCount),1)
      self:UpdateModels()
    end

    --canvas CalcFirstDisplayIdOfPage func
    function f:CalcFirstDisplayIdOfPage()
      return ((self.canvasPage*self.modelCount)+1)-self.modelCount
    end

    --canvas HideAllModels func
    function f:HideAllModels()
      for i, model in pairs(M) do
        model:ClearAllPoints()
        model:Hide()
      end
    end

    --canvas UpdateAllModelBackgrounds func
    function f:UpdateAllModelBackgrounds()
      for i, model in pairs(M) do
        self:UpdateModelBackgroundColor(model)
      end
    end

    --canvas UpdateModels func
    function f:UpdateModels()
      self:HideAllModels()
      self:UpdateModelCount()
      local displayId = 1+((self.canvasPage-1)*self.modelCount)
      local id = 1
      for i=1, self.modelRows do
        for k=1, self.modelCols do
          if not M[id] then
            --create a new model frame if needed
            M[id] = self:CreateModel(id)
          end
          self:UpdateModelPosition(M[id],k-1,i-1)
          self:ResetModelValues(M[id])
          self:UpdateModelDisplayId(M[id],displayId)
          displayId = displayId+1
          id = id+1
        end--for cols
      end--for rows
    end

    return f

  end

  --create the murloc button
  function L:CreateMurlocButton()

    --murloc frame
    local m = CreateFrame("PlayerModel",L.name.."MurlocButton",UIP)
    m:SetSize(200,200)
    m:SetPoint("CENTER",0,0)
    m:SetMovable(true)
    m:SetResizable(true)
    m:SetUserPlaced(true)
    m:EnableMouse(true)
    m:SetClampedToScreen(true)
    m:RegisterForDrag("RightButton")

    --murloc OnDragStart func
    m:HookScript("OnDragStart", function(self)
      if IsShiftKeyDown() then
        self:StartSizing()
      else
        self:StartMoving()
      end
    end)

    --murloc OnSizeChanged func
    m:HookScript("OnSizeChanged", function(self,w,h)
      w = math.min(math.max(w,20),400)
      self:SetSize(w,w) --height = width
    end)

    --murloc OnDragStop func
    m:HookScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    --murloc OnSizeChanged func
    m:HookScript("OnSizeChanged", function(self,w,h)
      w = math.min(math.max(w,40),400)
      self:SetSize(w,w) --height = width
    end)

    --murloc OnMouseDown func
    m:HookScript("OnMouseDown", function(self,button)
      if button ~= "LeftButton" then return end
      --on first call create the canvas
      if not L.canvas then L.canvas = L:CreateCanvas() end
      L.canvas:Enable()
    end)

    --murloc OnEnter func
    m:HookScript("OnEnter", function(self)
      PlaySound(C.sound.select)
      GT:SetOwner(self, "ANCHOR_TOP",0,5)
      GT:AddLine("rIngameModelViewer", 0, 1, 0.5, 1, 1, 1)
      GT:AddLine("Click |cffff00ffleft|r to open.", 1, 1, 1, 1, 1, 1)
      GT:AddLine("Hold |cff00ffffright|r to move.", 1, 1, 1, 1, 1, 1)
      GT:AddLine("Hold |cffffff00shift|r + |cff00ffffright|r to resize.", 1, 1, 1, 1, 1, 1)
      GT:Show()
    end)

    --murloc OnLeave func
    m:HookScript("OnLeave", function(self)
      PlaySound(C.sound.swap)
      GT:Hide()
    end)

    --murloc UpdateDisplayId func
    function m:UpdateDisplayId()
      self:SetCamDistanceScale(0.8)
      self:SetRotation(-0.4)
      self:SetDisplayInfo(21723) --murcloc costume
    end

    return m

  end

  --init func
  function L:Init ()
    L.murlockButton = L:CreateMurlocButton()
    print(L.name,L.versionNumber,"loaded")
  end

  -------------------------------------
  -- CALL
  -------------------------------------

  --init
  L:Init()

  --models defined on loadup are not rendered properly. model display needs to be delayed.
  local addonCallAfterLogin = CreateFrame("Frame")
  addonCallAfterLogin:HookScript("OnEvent", function(self)
    L.murlockButton:UpdateDisplayId()
    self:UnregisterEvent("PLAYER_LOGIN")
  end)
  addonCallAfterLogin:RegisterEvent("PLAYER_LOGIN")
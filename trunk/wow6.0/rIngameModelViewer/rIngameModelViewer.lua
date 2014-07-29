
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

  local math, unpack = math, unpack
  local UIP = UIParent
  local CPF = ColorPickerFrame
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

  C.backdrop = {
    bgFile = "",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
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
    local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    button.text = _G[button:GetName().."Text"]
    button.text:SetText(text)
    button:SetWidth(button.text:GetStringWidth()+(adjustWidth or 20))
    button:SetHeight(button.text:GetStringHeight()+(adjustHeight or 12))
    return button
  end

  --create color picker button func
  function L:CreateColorPickerButton(parent,name)
    local picker = CreateFrame("Button", name, parent)
    picker:SetSize(75,25)
    picker:SetBackdrop(C.backdrop)
    picker:SetBackdropBorderColor(0.5,0.5,0.5)
    --texture
    picker.color = picker:CreateTexture(nil,"BACKGROUND",nil,-7)
    picker.color:SetPoint("TOPLEFT",4,-4)
    picker.color:SetPoint("BOTTOMRIGHT",-4,4)
    picker.color:SetTexture(unpack(C.modelBackgroundColor))
    --picker.show
    function picker:Setup(r,g,b,a,callback)
      CPF:SetColorRGB(r,g,b)
      CPF.hasOpacity, CPF.opacity = (a ~= nil), a
      CPF.previousValues = {r,g,b,a}
      CPF.func, CPF.opacityFunc, CPF.cancelFunc = callback, callback, callback
      CPF:Hide() -- Need to run the OnShow handler.
      CPF:Show()
    end
    function picker:Callback(color)
      local r,g,b
      if color then r,g,b = unpack(color) else r,g,b = CPF:GetColorRGB() end
      picker.color:SetVertexColor(r,g,b)
      picker:UpdateColor(r,g,b)
    end
    picker:HookScript("OnClick", function(self)
      --reset the callback functions
      CPF.func, CPF.opacityFunc, CPF.cancelFunc = function() end, function() end, function() end
      local r,g,b = self.color:GetVertexColor()
      self:Setup(r,g,b,nil,self.Callback)
    end)
    return picker
  end

  --create model func
  function L:CreateModel(id)
    --print("creating new model",id)
    local m = CreateFrame("PlayerModel",nil,L.canvas)
    m.name = "model"..id
    m.id = id
    m.bg = m:CreateTexture(nil, "BACKGROUND",nil,-8)
    m.bg:SetTexture(0,0,0,.2)
    m.bg:SetAllPoints()
    m.color = m:CreateTexture(nil, "BACKGROUND",nil,-7)
    m.color:SetTexture(1,1,1)
    m.color:SetPoint("TOPLEFT", m, "TOPLEFT", 2, -2)
    m.color:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", -2, 2)
    m.p = m:CreateFontString(nil, "BACKGROUND")
    m.p:SetPoint("TOP", 0, -2)
    m.p:SetAlpha(.5)
    function m:UpdateModelPosition(row,col)
      local size = self:GetParent().modelSize
      self:SetSize(size,size)
      self:SetPoint("TOPLEFT",size*row,size*col*(-1))
      local fs = size*10/100
      if fs < 8 then fs = 8 end
      self.p:SetFont(STANDARD_TEXT_FONT, fs, "THINOUTLINE")
      self:Show()
    end
    --set some default values to work with
    function m:ResetModelValues()
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
    --update the model background color
    function m:UpdateModelBackgroundColor()
      self.color:SetVertexColor(unpack(C.modelBackgroundColor))
    end
    function m:UpdateModelDisplayId(displayId)
      self:ClearModel()
      local defaultmodel = "interface\\buttons\\talktomequestionmark.m2"
      self:SetModel(defaultmodel) --in case setdisplayinfo fails
      self:SetDisplayInfo(displayId)
      local model = self:GetModel()
      if model == defaultmodel then
        self:SetCamDistanceScale(0.4)
        self:SetPosition(0,0,0.5)
        self:EnableMouse(false)
        self:SetAlpha(0.4)
      else
        self:EnableMouse(true)
        self:SetAlpha(1)
      end
      self.model = model
      self.displayId = displayId
      self.p:SetText(self.displayId)
    end
    return m
  end


  --create canvas func
  function L:CreateCanvas()
    --print("creating canvas")
    local f = CreateFrame("Frame",nil,UIP)
    f:SetFrameStrata("FULLSCREEN")
    f:SetAlpha(0)
    f:SetAllPoints()
    f:EnableMouse(true)
    --bg
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
      self:GetParent():Hide()
    end)
    function f:Enable()
      self:Show()
      self:UpdateModels() --wierd. some models bug out on hidden frames, this makes sure we update the view after the OnShow
      self.fadeIn:Play()
      --print("enabling")
    end
    function f:Disable()
      self.fadeOut:Play()
      --print("disabling")
    end
    --create the close button
    f.closeButton = L:CreateButton(f,L.name.."CanvasCloseButton","Close")
    f.closeButton:SetPoint("BOTTOMRIGHT",-10,10)
    f.closeButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():Disable()
    end)
    f.closeButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT",0,5)
      GameTooltip:AddLine("Click to close.", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f.closeButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GameTooltip:Hide()
    end)
    --create next page button
    f.nextPageButton = L:CreateButton(f,L.name.."CanvasNextPageButton","next >")
    f.nextPageButton:SetPoint("BOTTOMRIGHT",-200,10)
    f.nextPageButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdatePage(1)
    end)
    f.nextPageButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GameTooltip:SetOwner(self, "ANCHOR_TOP",0,5)
      GameTooltip:AddLine("Click for next page.", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f.nextPageButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GameTooltip:Hide()
    end)
    --create previous page button
    f.previousPageButton = L:CreateButton(f,L.name.."CanvasPreviousPageButton","< prev")
    f.previousPageButton:SetPoint("BOTTOMRIGHT",-400,10)
    f.previousPageButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdatePage(-1)
    end)
    f.previousPageButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GameTooltip:SetOwner(self, "ANCHOR_TOP",0,5)
      GameTooltip:AddLine("Click for previous page.", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f.previousPageButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GameTooltip:Hide()
    end)
    --create color picker button
    f.colorPickerButton = L:CreateColorPickerButton(f,L.name.."CanvasColorPickerButton")
    f.colorPickerButton:SetPoint("BOTTOMLEFT",10,10)
    f.colorPickerButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,5)
      GameTooltip:AddLine("Click for color picker.", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f.colorPickerButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GameTooltip:Hide()
    end)
    function f.colorPickerButton:UpdateColor(r,g,b)
      C.modelBackgroundColor = {r,g,b}
      self:GetParent():UpdateAllModelBackgrounds()
      self:GetParent().bg:SetVertexColor(r*0.1,g*0.1,b*0.1)
    end
    --create minus size button
    f.minusSizeButton = L:CreateButton(f,L.name.."CanvasMinusSizeButton","- size")
    f.minusSizeButton:SetPoint("LEFT",f.colorPickerButton,"RIGHT",10,0)
    f.minusSizeButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdateModelSize(-50)
    end)
    f.minusSizeButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GameTooltip:SetOwner(self, "ANCHOR_TOP",0,5)
      GameTooltip:AddLine("Click for decreased model size.", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f.minusSizeButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GameTooltip:Hide()
    end)
    --create plus size button
    f.plusSizeButton = L:CreateButton(f,L.name.."CanvasPlusSizeButton","+ size")
    f.plusSizeButton:SetPoint("LEFT",f.minusSizeButton,"RIGHT",10,0)
    f.plusSizeButton:HookScript("OnClick", function(self)
      PlaySound(C.sound.click)
      self:GetParent():UpdateModelSize(50)
    end)
    f.plusSizeButton:HookScript("OnEnter", function(self)
      --PlaySound(C.sound.select)
      GameTooltip:SetOwner(self, "ANCHOR_TOP",0,5)
      GameTooltip:AddLine("Click for increased model size.", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f.plusSizeButton:HookScript("OnLeave", function(self)
      --PlaySound(C.sound.swap)
      GameTooltip:Hide()
    end)
    --canvas size
    f.canvasWidth, f.canvasHeight = f:GetSize()
    f.canvasHeight  = f.canvasHeight-70 --remove 70px for the bottom bar
    f.modelSize     = 200
    f.canvasPage    = 1
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
    --canvas UpdatePage func
    function f:UpdatePage(value)
      if self.canvasPage == 1 and value < 0 then return end
      self.canvasPage = self.canvasPage+value
      self:UpdateModels()
    end
    --calc page for displayId func
    function f:CalcPageForDisplayID(displayId)
      self.canvasPage = math.max(math.ceil(displayId/self.modelCount),1)
      self:UpdateModels()
    end
    --calc first displayId of page func
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
        model:UpdateModelBackgroundColor()
      end
    end
    --canvas UpdateModels func
    function f:UpdateModels()
      self:HideAllModels()
      self:UpdateModelCount()
      local displayId = 1 + ((self.canvasPage-1)*self.modelCount)
      local id = 1
      for i=1, self.modelRows do
        for k=1, self.modelCols do
          if not M[id] then
            --create a new model frame if needed
            M[id] = L:CreateModel(id)
          end
          M[id]:UpdateModelPosition(k-1,i-1)
          M[id]:ResetModelValues()
          M[id]:UpdateModelDisplayId(displayId)
          M[id]:UpdateModelBackgroundColor()
          displayId = displayId+1
          id=id+1
        end--for cols
      end--for rows
    end
    return f
  end

  --create the murloc button
  function L:CreateMurlocButton()
    local f = CreateFrame("PlayerModel",L.name.."MurlocButton",UIP)
    f:SetSize(200,200)
    f:SetPoint("CENTER",0,0)
    function f:ModelUpdate()
      self:SetCamDistanceScale(0.8)
      self:SetRotation(-0.4)
      self:SetDisplayInfo(21723) --murcloc costume
    end
    f:SetMovable(true)
    f:SetUserPlaced(true)
    f:EnableMouse(true)
    f:RegisterForDrag("RightButton")
    f:HookScript("OnDragStart", function(self) self:StartMoving() end)
    f:HookScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    f:HookScript("OnMouseDown", function(self,button)
      if button ~= "LeftButton" then return end
      if not L.canvas then
        L.canvas = L:CreateCanvas()
      end
      L.canvas:Enable()
    end)
    f:HookScript("OnEnter", function(self)
      PlaySound(C.sound.select)
      GameTooltip:SetOwner(self, "ANCHOR_TOP",0,5)
      --GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -90, 90)
      GameTooltip:AddLine("rIngameModelViewer", 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("Click |cff00ff00left|r to open the model viewer.", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("Drag |cff00ffffright|r to move the murloc.", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    f:HookScript("OnLeave", function(self)
      PlaySound(C.sound.swap)
      GameTooltip:Hide()
    end)
    return f
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
  addonCallAfterLogin:HookScript("OnEvent", function(...)
    L.murlockButton:ModelUpdate()
  end)
  addonCallAfterLogin:RegisterEvent("PLAYER_LOGIN")
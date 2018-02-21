
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
  local math, unpack  = math, unpack
  local PlaySound     = PlaySound
  local GT, UIP, CPF  = GameTooltip, UIParent, ColorPickerFrame

  --save the default color picker frame strata for later
  L.defaultColorPickerFrameStrata = CPF:GetFrameStrata()

  -------------------------------------
  -- FUNCTIONS
  -------------------------------------

  function L:RoundNumber(n)
    return math.floor((n)*10)/10
  end

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
    b.color:SetColorTexture(1,1,1)
    b.color:SetVertexColor(unpack(DB.GLOB["COLOR"]))

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
      CPF:SetFrameStrata("FULLSCREEN_DIALOG") --make sure the CPF lives ontop of the canvas
      CPF:Hide()
      CPF:Show()
      CPF:SetColorRGB(r,g,b)
    end)

    return b

  end

  function L:CreateEditBox(parent, name, title, value)
    local e = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
    e:SetSize(80,30)
    e:SetAutoFocus(false)
    e:SetText(value)
    e:SetJustifyH("CENTER")
    if title then
      e.title = e:CreateFontString(nil, "BACKGROUND")
      e.title:SetPoint("BOTTOM",e,"TOP", 0, 0)
      e.title:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
      e.title:SetText(title)
      e.title:SetAlpha(0.5)
    end
    return e
  end
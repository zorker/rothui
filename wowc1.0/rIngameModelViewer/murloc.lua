
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

  --create the murloc button
  function L:CreateMurlocButton()

    --murloc frame
    local m = CreateFrame("PlayerModel",L.name.."MurlocButton",UIParent)
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
      GT:AddLine(L.name.." "..L.versionNumber, 0, 1, 0.5, 1, 1, 1)
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
      self:SetDisplayInfo(4) --murcloc costume
    end

    return m

  end

  -------------------------------------
  -- CALL
  -------------------------------------

  --init
  L.murlockButton = L:CreateMurlocButton()

  --models defined on loadup are not rendered properly. model display needs to be delayed.
  L.murlockButton:HookScript("OnEvent", function(self)
    self:UpdateDisplayId()
    self:UnregisterEvent("PLAYER_LOGIN")
  end)
  L.murlockButton:RegisterEvent("PLAYER_LOGIN")

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

    local function getTableLng(tbl)
      local getN = 0
      for n in pairs(tbl) do
        getN = getN + 1
      end
      return getN
    end


    local function BuildModelList(loopCounter)
      if loopCounter > 10 then
        print('loop-count exceeded')
        return
      end
      local ml = DB.GLOB["MODEL_LIST"]
      local last_id = DB.GLOB["LAST_DISPLAY_ID"]
      if not ml or not last_id then
        rIMV_DBGLOB = DB:LoadGlobDefaults()
        DB.GLOB = rIMV_DBGLOB
        print('model list table not found, reseting global SavedVariables. Please try again.')
        return
      end
      local steps = 2000
      local new_id = (last_id+steps)
      local counter = 0
      for i = last_id,new_id,1
      do
        if i == 74632 then
          print('skip memory-leak id ',i)
        else
          m:SetDisplayInfo(i)
          local fileID = m:GetModelFileID()
          m:ClearModel()
          if fileID and not ml[fileID] then
            ml[fileID] = i
            --print('adding new entry to model list for fileID',fileID,'displayID',i)
            counter = counter+1
          end
        end
      end
      print('searched from id: [',last_id,'] - [',new_id,'], found this many new models: [',counter,']')
      print('model-list has now a size of:',getTableLng(ml))
      m:SetDisplayInfo(21723)
      if counter == 0 then
        print('no new entry for model list found. stopping script.')
        return
      end
      DB.GLOB["MODEL_LIST"] = ml
      DB.GLOB["LAST_DISPLAY_ID"] = new_id
      C_Timer.After(5, function() BuildModelList(loopCounter+1) end)
    end

    --murloc OnMouseDown func
    m:HookScript("OnMouseDown", function(self,button)
      if button ~= "LeftButton" then return end
      if IsAltKeyDown() then
        BuildModelList(1)
        return
      end
      --on first call create the canvas
      if not L.canvas then L.canvas = L:CreateCanvas() end
      if IsControlKeyDown() then
        C.canvasMode = 'displayIds'
      else
        C.canvasMode = 'displayIndexList'
      end
      L.canvas:Enable()
    end)

    --murloc OnEnter func
    m:HookScript("OnEnter", function(self)
      PlaySound(C.sound.select)
      GT:SetOwner(self, "ANCHOR_TOP",0,5)
      GT:AddLine(L.name.." "..L.versionNumber, 0, 1, 0.5, 1, 1, 1)
      GT:AddLine("Click |cffff00ffleft|r to open model-list canvas by database list.", 1, 1, 1, 1, 1, 1)
      GT:AddLine("Click |cffff00ffleft|r + |cffff00ffCTRL|r to open model-list canvas without a list.", 1, 1, 1, 1, 1, 1)
      GT:AddLine("Click |cffff00ffleft|r + |cffff00ffALT|r to build model database.", 1, 1, 1, 1, 1, 1)
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
      self:SetCamDistanceScale(1)
      self:SetRotation(0)
      self:SetDisplayInfo(21723) --murcloc costume
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
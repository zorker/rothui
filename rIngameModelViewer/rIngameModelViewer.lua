  
  -- rIngameModelViewer 0.1
  -- zork 2010

  -----------------------------
  -- CONFIG
  -----------------------------
  
  -- size of each modelframe
  local size = 80
  
  -- usage typ this in the chat
  -- /run changeIMVP(PAGEID)  
  -- default pageid is 1
  -- if you want to go to page 3 type into the chat
  -- /run changeIMVP(3)  

  -----------------------------
  -- FUNCTIONS
  -----------------------------
 
  local a = CreateFrame("Frame")
 
  a:RegisterEvent("PLAYER_LOGIN")
  
  a:SetScript("OnEvent", function (s,e,...)
    if(e=="PLAYER_LOGIN") then
      a:init()
    end 
  end)

  local page = 1

  local w = floor(UIParent:GetWidth()*UIParent:GetEffectiveScale())
  local h = floor(UIParent:GetHeight()*UIParent:GetEffectiveScale())
  
  local rows = floor(h/size)
  local cols = floor(w/size)
  local num = rows*cols
  local models = {}
    
  local createModel = function(id,row,col)
    local m = CreateFrame("PlayerModel", nil)
    m:SetSize(size,size)
    m:SetPoint("TOPLEFT",size*row,size*col*(-1))
    --m:SetFacing(math.pi) --math.pi = 180° 
    m:SetDisplayInfo(id)
    m.id = id

    local t = m:CreateTexture(nil, "BACKGROUND",nil,-8)
    t:SetTexture(0,0,0,0.1)
    t:SetPoint("TOPLEFT", m, "TOPLEFT", 2, -2)
    t:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", -2, 2)
    m.t = t

    local p = m:CreateFontString(nil, "BACKGROUND")
    local fs = size*10/100
    if fs < 8 then 
      fs = 8
    end    
    p:SetFont("Fonts\\FRIZQT__.ttf", fs, "THINOUTLINE")
    p:SetPoint("TOP", 0, -2)
    p:SetText(id)
    p:SetAlpha(.5)
    m.p = p
    
    return m

  end  
  
  --GLOBAL FUNCTION TO ACCESS FROM CHAT
  function changeIMVP(pageid)
    print("Changing to page: "..pageid)
    local modelid = 1 + ((pageid-1)*num) 
    local id = 1
    
    for i=1, rows do
      for k=1, cols do
        models[id]:SetDisplayInfo(modelid)
        models[id].id = modelid
        models[id].p:SetText(modelid)
        --print(models[id].id)
        modelid = modelid+1
        id=id+1
      end    
    end
  
  end
  

  function a:init()
   
    local modelid = 1 + ((page-1)*num)    
    local id = 1
    
    for i=1, rows do
      for k=1, cols do
        models[id] = createModel(modelid,k-1,i-1)
        --print(models[id].id)
        modelid = modelid+1
        id=id+1        
      end    
    end
    
  end
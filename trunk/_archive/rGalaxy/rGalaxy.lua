  
  -- Zorks round texture animation testmod

  local function createme(h,tex,circle,x,y,size,dur,degree)    
        
    local t = h:CreateTexture(nil,"BACKGROUND",nil,-8)
    t:SetPoint("CENTER",x,y)
    t:SetSize(size,size)
    t:SetBlendMode("ADD")
    
    if circle then
      SetPortraitToTexture(t, "Interface\\AddOns\\rGalaxy\\"..tex)
    else
      t:SetTexture("Interface\\AddOns\\rGalaxy\\"..tex)
    end
    
    if dur then
    
      local ag = t:CreateAnimationGroup()    
      local anim = ag:CreateAnimation("Rotation")
      anim:SetDegrees(degree)
      anim:SetDuration(dur)    
      ag:Play()
      ag:SetLooping("REPEAT")
    
    end
    
    return t    
  
  end  
  
  local h = CreateFrame("Frame",nil,UIParent)  
  h:SetPoint("CENTER",0,0)
  h:SetSize(64,64)
  
  local a = createme(h,"bob",true,70,70,128)
  local b = createme(h,"bob",false,-70,70,128)
  local c = createme(h,"bob",true,70,-70,128,15,360)
  local d = createme(h,"bob",false,-70,-70,128,15,360)
  local e = createme(h,"bob",true,70,-140,128,15,-360)
  local f = createme(h,"bob",false,-70,-140,128,15,-360)  
  local g = createme(h,"galaxy",true,210,70,128,15,360)
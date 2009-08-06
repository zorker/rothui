
  --Blizzard documentation
  --http://forums.worldofwarcraft.com/thread.html?sid=1&topicId=15443414368
  
  --Black box
  --http://wow.curseforge.com/addons/blackboxlua/

  local function createme(x,y,size,alpha,dur)
    local h = CreateFrame("Frame",nil,UIParent)
    h:SetHeight(size)
    h:SetWidth(size)		  
    h:SetPoint("CENTER",x,y)
    h:SetAlpha(alpha)
  
    local t = h:CreateTexture()
    t:SetAllPoints(h)
    t:SetTexture("Interface\\AddOns\\rGalaxy\\galaxy")
    h.t = t
    
    local ag = h:CreateAnimationGroup()
    h.ag = ag
    
    local a1 = h.ag:CreateAnimation("Rotation")
    a1:SetDegrees(360)
    a1:SetDuration(dur)
    h.ag.a1 = a1
    
    h:SetScript("OnUpdate",function(self,elapsed)
      local t = self.total
      if (not t) then
        self.total = 0
        return
      end
      t = t + elapsed
      if (t<1) then
        self.total = t
        return
      else
        h.ag:Play()
      end
    end)
    
    return h
  
  end
  
  local a = createme(0,0,100,0.8,20)
  local b = createme(5,0,130,0.5,10)
  local c = createme(5,5,120,0.6,15)
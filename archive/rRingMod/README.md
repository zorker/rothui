##The ring
*Posted 06/08/09 at 7:24 AM by zork*
This is a repost of a tutorial I wrote sometime ago. It is about how to do 360° rings in World of Warcraft based on Iriels findings in his addon StatRings.

###Sources:
[API Texture SetTexCoord - WoWWiki - Your guide to the World of Warcraft](http://www.wowwiki.com/API_Texture_SetTexCoord)
[SetTexCoord Transformations - WoWWiki - Your guide to the World of Warcraft](http://wowwiki.wikia.com/wiki/SetTexCoord_Transformations)
[StatRings - Anchor configuration preview - WoWInterface](http://www.wowinterface.com/forums/showthread.php?p=99052#post99052)
[StatRings : WoWInterface Downloads : Iriel's Castle](http://www.wowinterface.com/downloads/info4474-StatRings.html)

Link to original article: 360° Ring Castbar

###What's important?
A ring consists of 4 segments. If you want this ring to be your castbar (for example) it will always have a status. "Nothing is casted", "Cast finished", "Cast finished to 10%" ... stuff like that.

If you want to use 4 segments (less are possible too) each segment is 25% of your castbar (25%*4=100%).

![ring_basic.gif](http://img3.abload.de/img/ring_basicql5z.gif)

To create that ring you only need the texture of 1 segment of that ring and a slice texture. One texture of that segment is enough since textures can be rotated.

If we assume our castbar is at 40% then segment-one would be completly visible. Thus no special mathematics are needed. Just display the texture and thats it. Only the segment where the castbar currently is, has to be looked at.

Ok, now to keep it simple I assume my castbar is at ~10% and it fills clock-wise. Thus only segment-one (the upper right in my case) is visible and everything else is unvisible.

To get that radial look we have to cheat. This segment will consist of 3 textures. Two of these will be the ring and one will be the slice.

To understand how this is possible you need to know how the alpha-layer of TGA-texture files work. The alpha layer describes what part of a texture will be visible and what will be not visible. Ok, we need to create (in GIMP or Photoshop) two of these textures. A ring textures which is one segment of that ring and will be rotated later and a slice which is a square that consists of two triangles, one visible and one unvisible.

If our segment would be fully visible we would just show the texture (maybe rotation is needed) but thats it.

![ring_square.gif](http://img3.abload.de/img/ring_squaresjd6v.gif)

In this case we are looking at a segment the castbar currently is at. If you check the images (ring_square.gif) you see a red and a blue rectangle and a yellow triangle (the slice).

Ok here comes SetTexCoord() into play. This thing is great. Not only can you rotate textures with it, the more important thing is that you can describe rectangles that lay on the texture. Those rectangles behave like alpha channels. Only parts of that texture that are inside the rectangle will be visible.

This plus the ring texture with the alpha layer makes it possible to create the illusion of a ring.

Now as you can see on the images, when we have the red and the blue rectangle there is a gap. This is where the slice comes into play. It will be spanned between those two rectangles and thanks to the alpha layer on that texture only one part of it will be visible.

Ok, lets do some math.

We assume castbar filled to ~10%. So thats easy, 25% is one segment and one segment is 90°.

So:

    25/90 = 10/x --> x = (10*90)/25 --> x = 36°

This angle is important. Its the angle of the line that clips the ring. When the line clips the ring it produces two intersection points (point I and point O).

Ok here are the functions to calculate the coordinates:

    outer_radius = texture_width
    inner_radius = outer_radius - ring_width
    Arad = math.rad(angle)
    Ix = inner_radius * math.sin(Arad)
    Iy = outer_radius - (inner_radius * math.cos(Arad))
    Ox = outer_radius * math.sin(Arad)
    Oy = outer_radius - (outer_radius * math.cos(Arad))

The starting point is the upper left corner (point N). This is always (0,0).

The standard definition of SetTexCoord is: SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);

    UL = upper left
    LL = lower left
    UR = upper right
    LR = lower right

![ring_textures.gif](http://img3.abload.de/img/ring_texturesvkg0.gif)

Ok check the ring_square image again. We are creating two ring segment textures (in LUA) with the following coordinates:

Red square: SetTexCoord(Nx,Ny, Nx,IyCoord, IxCoord,Ny, IxCoord, IyCoord)
Blue square: SetTexCoord(IxCoord,Ny, IxCoord,OyCoord, OxCoord,Ny, OxCoord, OyCoord)

Now we create another texture that contains the slice and move it into position:

    SetPoint("TOPLEFT",Ix,-Oy)
    SetWidth(Ox-Ix)
    SetHeight(Iy-Oy)

This is the basic stuff. Now lets move on to rotations which are not that complicated if you make yourself a little helper. Get yourself a sheet of paper (in real life!) and cut out a square. Now mark the edges of that square. Upper left = UL, lower left = LL, upper right = UR and lower right = LR.

Ok now lets assume we want to rotate that thing 90° to the right. Now get your square and rotate it 90° and see what happened. All points have moved clockwise to the right...right?!

    UL => UR
    LL => UL
    UR => LR
    LR => LL

So:

    SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy) =>
    SetTexCoord(LLx, LLy, LRx, LRy, ULx, ULy, URx, URy)

This is how you rotate the texture 90°. You can use the same technique for 180° and 270°.

Thats the basic explanation on how to create a ring that moves clock-wise. If you want to get a ring that moves counter-clock-wise that's possible too. Check the ring reverse graphic. Your starting point changed to M (1,1). What you need is a new slice texture or you create a 2in1 texture that contains both sides of the slice and must be adjusted with SetTexCoord aswell.

![ring_reverse.gif](http://img3.abload.de/img/ring_reverseclfl.gif)

Still reading?

Here is a small example addon, don't forget to create your ring and slice textures and replace them accordingly:

  
    local addon = CreateFrame("Frame", nil, UIParent)
   
    addon:RegisterEvent("PLAYER_LOGIN")
    
    addon:SetScript("OnEvent", function ()
      if(event=="PLAYER_LOGIN") then
        addon:initme(1,"BOTTOMLEFT")
        addon:initme(2,"TOPLEFT")
        addon:initme(3,"TOPRIGHT")
        addon:initme(4,"BOTTOMRIGHT")
      end 
    end)
  
    function addon:initme(id,anchor)
    
      --outer ring
      local outer_radius = 128
      
      --inner ring
      local ring_factor = 1.12280702
      local inner_radius = outer_radius/ring_factor
    
      local f = CreateFrame("Frame", nil,UIParent)
      f:SetFrameStrata("BACKGROUND")
      f:SetWidth(outer_radius)
      f:SetHeight(outer_radius)
      f:SetPoint(anchor,UIParent,"CENTER",0,0)
      f:Show()
      
      local statusbarvalue = 50
      
      --angle
      local angle = statusbarvalue * 90 / 100
      local Arad = math.rad(angle)
      
      local ULx,ULy, LLx,LLy, URx,URy, LRx,LRy
  
      local Nx = 0
      local Ny = 0
      local Ix = inner_radius * math.sin(Arad)
      local Iy = outer_radius - (inner_radius * math.cos(Arad))
      local Ox = outer_radius * math.sin(Arad)
      local Oy = outer_radius - (outer_radius * math.cos(Arad))
      
      local IxCoord = Ix / outer_radius 
      local IyCoord = Iy / outer_radius
      local OxCoord = Ox / outer_radius
      local OyCoord = Oy / outer_radius    
  
      if id == 1 then
        
        local t0 = f:CreateTexture(nil, "BACKGROUND")
        t0:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t0:SetPoint("TOPLEFT",Nx,Ny)
        t0:SetWidth(Ix)
        t0:SetHeight(Iy)
        t0:SetTexCoord(Nx,Ny, Nx,IyCoord, IxCoord,Ny, IxCoord, IyCoord)
        
        local t1 = f:CreateTexture(nil, "BACKGROUND")
        t1:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t1:SetPoint("TOPLEFT",Ix,Ny)
        t1:SetWidth(Ox-Ix)
        t1:SetHeight(Oy)
        t1:SetTexCoord(IxCoord,Ny, IxCoord,OyCoord, OxCoord,Ny, OxCoord, OyCoord)
        
        local t2 = f:CreateTexture(nil, "BACKGROUND")
        t2:SetTexture("Interface\\AddOns\\StatRingsRevived\\slice1")
        t2:SetPoint("TOPLEFT",Ix,-Oy)
        t2:SetWidth(Ox-Ix)
        t2:SetHeight(Iy-Oy)
  
        local t9 = f:CreateTexture(nil, "BACKGROUND")
        t9:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t9:SetPoint("CENTER",0,0)
        t9:SetWidth(outer_radius)
        t9:SetHeight(outer_radius)
        t9:SetAlpha(0.2)
  
        DEFAULT_CHAT_FRAME:AddMessage("angle "..angle)
        DEFAULT_CHAT_FRAME:AddMessage("Arad "..Arad)
        DEFAULT_CHAT_FRAME:AddMessage("Ix "..Ix)
        DEFAULT_CHAT_FRAME:AddMessage("Iy "..Iy)
        DEFAULT_CHAT_FRAME:AddMessage("Ox "..Ox)
        DEFAULT_CHAT_FRAME:AddMessage("Oy "..Oy)
        DEFAULT_CHAT_FRAME:AddMessage("IxCoord "..IxCoord)
        DEFAULT_CHAT_FRAME:AddMessage("IyCoord "..IyCoord)
        DEFAULT_CHAT_FRAME:AddMessage("OxCoord "..OxCoord)
        DEFAULT_CHAT_FRAME:AddMessage("OyCoord "..OyCoord)
        DEFAULT_CHAT_FRAME:AddMessage("BOTTOMRIGHTX "..(outer_radius-Ix))
        DEFAULT_CHAT_FRAME:AddMessage("BOTTOMRIGHTY "..(outer_radius-Iy))
  
      end
  
      if id == 2 then
        local t0 = f:CreateTexture(nil, "BACKGROUND")
        t0:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t0:SetPoint("TOPRIGHT",0,0)
        t0:SetWidth(Iy)
        t0:SetHeight(Ix)
        --t0:SetTexCoord(0,1, 1,1, 0,0, 1,0)
        t0:SetTexCoord(Nx,IyCoord, IxCoord,IyCoord, Nx,Ny, IxCoord,Ny)
        
        local t1 = f:CreateTexture(nil, "BACKGROUND")
        t1:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t1:SetPoint("TOPRIGHT",Ny,-Ix)
        t1:SetWidth(Oy)
        t1:SetHeight(Ox-Ix)
        --t1:SetTexCoord(IxCoord,Ny, IxCoord,OyCoord, OxCoord,Ny, OxCoord, OyCoord)
        t1:SetTexCoord(IxCoord,OyCoord,  OxCoord, OyCoord,  IxCoord,Ny,  OxCoord,Ny)
        
        local t2 = f:CreateTexture(nil, "BACKGROUND")
        t2:SetTexture("Interface\\AddOns\\StatRingsRevived\\slice1")
        t2:SetPoint("TOPRIGHT",-Oy,-Ix)
        t2:SetWidth(Iy-Oy)
        t2:SetHeight(Ox-Ix)
        t2:SetTexCoord(0,1, 1,1, 0,0, 1,0)
  
        local t9 = f:CreateTexture(nil, "BACKGROUND")
        t9:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t9:SetPoint("CENTER",0,0)
        t9:SetWidth(outer_radius)
        t9:SetHeight(outer_radius)
        t9:SetTexCoord(0,1, 1,1, 0,0, 1,0)
        t9:SetAlpha(0.2)
  
      end
  
      if id == 3 then
        
        local t0 = f:CreateTexture(nil, "BACKGROUND")
        t0:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t0:SetPoint("BOTTOMRIGHT",Nx,Ny)
        t0:SetWidth(Ix)
        t0:SetHeight(Iy)
        --t0:SetTexCoord(Nx,Ny, Nx,IyCoord, IxCoord,Ny, IxCoord, IyCoord)
        t0:SetTexCoord(IxCoord, IyCoord, IxCoord,Ny, Nx,IyCoord, Nx,Ny)
        
        local t1 = f:CreateTexture(nil, "BACKGROUND")
        t1:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t1:SetPoint("BOTTOMRIGHT",-Ix,Ny)
        t1:SetWidth(Ox-Ix)
        t1:SetHeight(Oy)
        t1:SetTexCoord(OxCoord, OyCoord, OxCoord,Ny, IxCoord,OyCoord, IxCoord,Ny)
        
        local t2 = f:CreateTexture(nil, "BACKGROUND")
        t2:SetTexture("Interface\\AddOns\\StatRingsRevived\\slice1")
        t2:SetPoint("BOTTOMRIGHT",-Ix,Oy)
        t2:SetWidth(Ox-Ix)
        t2:SetHeight(Iy-Oy)
        t2:SetTexCoord(1,1, 1,0, 0,1, 0,0)
        
        local t9 = f:CreateTexture(nil, "BACKGROUND")
        t9:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t9:SetPoint("CENTER",0,0)
        t9:SetWidth(outer_radius)
        t9:SetHeight(outer_radius)
        t9:SetTexCoord(1,1, 1,0, 0,1, 0,0)
        t9:SetAlpha(0.2)
  
      end
  
  
      if id == 4 then
        local t0 = f:CreateTexture(nil, "BACKGROUND")
        t0:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t0:SetPoint("BOTTOMLEFT",0,0)
        t0:SetWidth(Iy)
        t0:SetHeight(Ix)
        t0:SetTexCoord(IxCoord,Ny, Nx,Ny, IxCoord, IyCoord, Nx,IyCoord)
        
        local t1 = f:CreateTexture(nil, "BACKGROUND")
        t1:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t1:SetPoint("BOTTOMLEFT",Ny,Ix)
        t1:SetWidth(Oy)
        t1:SetHeight(Ox-Ix)
        t1:SetTexCoord(OxCoord,Ny, IxCoord,Ny, OxCoord, OyCoord, IxCoord,OyCoord)
        
        local t2 = f:CreateTexture(nil, "BACKGROUND")
        t2:SetTexture("Interface\\AddOns\\StatRingsRevived\\slice1")
        t2:SetPoint("BOTTOMLEFT",Oy,Ix)
        t2:SetWidth(Iy-Oy)
        t2:SetHeight(Ox-Ix)
        t2:SetTexCoord(1,0, 0,0, 1,1, 0,1)
                   
        local t9 = f:CreateTexture(nil, "BACKGROUND")
        t9:SetTexture("Interface\\AddOns\\StatRingsRevived\\ring1")
        t9:SetPoint("CENTER",0,0)
        t9:SetWidth(outer_radius)
        t9:SetHeight(outer_radius)
        t9:SetTexCoord(1,0, 0,0, 1,1, 0,1)
        t9:SetAlpha(0.2)
  
      end    
  
  
    end

There is another more graphical way to approach the 360° ring. Since Wrath of the Lich King 2048x2048 px textures are allowed. This is huge! Remember what SetTexCoord() can do for use? It can behave like an alpha-channel only making stuff visible we want to look at. Now think of a 2048x2048px texture that is split in 8 colums and 8 rows each 256x256px in size. Thats a total number of 64 possible textures or 16 texturer per segment! Dugu does this with his CursorCastbar and SpartanUI does this for the bar animation aswell. A neat way to create some sort of animation.

Bob Ross: "What we are trying to do is create a single access point that has no wrong door."

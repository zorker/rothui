
  ---------------------------------
  -- INIT
  ---------------------------------

  local addon, ns = ...
  ns.rLibRing = {}
  local rLibRing = ns.rLibRing
  local _G = _G


  ---------------------------------
  -- VARIABLES / CONSTANTS
  ---------------------------------

  local rad = rad
  local sqrt = sqrt
  local floor = floor
  local tinsert = tinsert

  --    ring segment layout
  --     ____ ____
  --    /    |    \
  --    |  4 | 1  |
  --     ----+----
  --    |  3 | 2  |
  --    \____|____/
  --

  local ringSegmentSettings = {
    { defaultRotation = 0,    primeNum = 2,   point = "TOPRIGHT",     }, --segment 1
    { defaultRotation = 270,  primeNum = 3,   point = "BOTTOMRIGHT",  }, --segment 2
    { defaultRotation = 180,  primeNum = 5,   point = "BOTTOMLEFT",   }, --segment 3
    { defaultRotation = 90,   primeNum = 7,   point = "TOPLEFT",      }, --segment 4
  }

  ---------------------------------
  -- LOCAL FUNCTIONS
  ---------------------------------

  local function CreateRingSegment(ringFrame,i)

    --scrollframe
    local scrollFrame = CreateFrame("ScrollFrame", ringFrame.name.."ScrollFrame"..i, ringFrame.lastParent)
    scrollFrame:SetSize(ringFrame.size/2,ringFrame.size/2)
    scrollFrame:SetPoint(ringSegmentSettings[i].point,ringFrame)
    scrollFrame.defaultRotation = ringSegmentSettings[i].defaultRotation
    scrollFrame.primeNum = ringSegmentSettings[i].primeNum
    scrollFrame.segmentId = i

    --scrollchild
    local scrollChild = CreateFrame("Frame", ringFrame.name.."ScrollChild"..i, scrollFrame)
    scrollChild:SetSize(ringFrame.size/2,ringFrame.size/2)
    --scrollChild:SetBackdrop(cfg.backdrop)
    scrollFrame:SetScrollChild(scrollChild)
    scrollFrame.scrollChild = scrollChild

    ringFrame.lastParent = scrollFrame
    tinsert(ringFrame.segments, scrollFrame)

  end

  --calculate the segment id based on direction, index and starting point
  local function CalculateRingSegmentID(start,direction,i)
    i = i - 1
    if direction == 0 then
      if start-i < 1 then
        return start-i+4
      else
        return start-i
      end
    else
      if start+i > 4 then
        return start+i-4
      else
        return start+i
      end
    end
  end


  ---------------------------------
  -- rLibRing:FUNCTIONS
  ---------------------------------

  --create one ring frame containing a scrollFrame for each ring segment (4 segments per ring)

  function rLibRing:CreateRingFrame(parent,size)

    local ringFrame = CreateFrame("Frame", "$parentRingFrame", parent)
    ringFrame:SetPoint("CENTER")
    ringFrame:SetSize(size,size)
    ringFrame.size = size
    ringFrame.name = ringFrame:GetName()

    ringFrame.segments = {}
    ringFrame.lastParent = ringFrame

    for i=1, 4 do
      CreateRingSegment(ringFrame, i)
    end

    return ringFrame

  end

  --create a ring table that references to the correct ringFrame segments
  function rLibRing:CreateRing(ringFrame,start,num,direction,radius,type)
    local ring = {}
    ring.size = ringFrame.size
    ring.start = start
    ring.type = type or "default"
    ring.num = num
    ring.direction = direction
    ring.modulo = 1
    ring.segments = {}
    ring.textures = {}
    for i=1, num do
      local id = CalculateRingSegmentID(start,direction,i)
      ring.segments[i] = ringFrame.semgents[id]
      ring.textures[i] = {}
      ring.textures[i].bg = CreateRingTexture()
      ring.textures[i].fill = CreateRingTexture()
      ring.textures[i].spark = CreateRingTexture()
      if type == "castring" then
        ring.textures[i].latency = CreateRingTexture()
      end
      ring.modulo = ring.modulo * ringFrame.segments[id].primeNum
    end
    return ring
  end




  ---------------------------------
  -- REGISTER
  ---------------------------------

  _G["rLibRing"] = rLibRing

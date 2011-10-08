
  -- cfg

  local db = {
    [1] = {
      frame = {
        parent = UIParent,
        width = 100,
        height = 100,
        scale = 1,
        alpha = 0.5,
        level = 0,
        pos = { a1 = "CENTER", x = -120, y = -120, },
      },
      texture = {
        file = "Interface\\AddOns\\rFramerotater\\media\\zahnrad",
        color = { r = 255/255, g = 255/255, b = 0/255, },
        blendmode = "BLEND", --ADD or BLEND
      },
      anim = {
        rotateframe = true, --rotateframe, if false rotates the texture only
        duration = 90, --how long should the rotation need to finish 360°
        direction = 0, --0 = counter-clockwise, 1 = clockwise
      },
    },
    [2] = {
      frame = {
        parent = UIParent,
        width = 100,
        height = 100,
        scale = 1,
        alpha = 0.5,
        level = 0,
        pos = { a1 = "CENTER", x = 0, y = -120, },
      },
      texture = {
        file = "Interface\\AddOns\\rFramerotater\\media\\zahnrad",
        color = { r = 255/255, g = 0/255, b = 0/255, },
        blendmode = "BLEND", --ADD or BLEND
      },
      anim = {
        rotateframe = true, --rotateframe, if false rotates the texture only
        duration = 90, --how long should the rotation need to finish 360°
        direction = 1, --0 = counter-clockwise, 1 = clockwise
      },
    },
    [3] = {
      frame = {
        parent = UIParent,
        width = 100,
        height = 100,
        scale = 1,
        alpha = 0.5,
        level = 0,
        pos = { a1 = "CENTER", x = -120, y = 0, },
      },
      texture = {
        file = "Interface\\AddOns\\rFramerotater\\media\\zahnrad",
        color = { r = 255/255, g = 255/255, b = 0/255, },
        blendmode = "BLEND", --ADD or BLEND
      },
      anim = {
        rotateframe = false, --rotateframe, if false rotates the texture only
        duration = 60, --how long should the rotation need to finish 360°
        direction = 0, --0 = counter-clockwise, 1 = clockwise
      },
    },
    [4] = {
      frame = {
        parent = UIParent,
        width = 100,
        height = 100,
        scale = 1,
        alpha = 0.5,
        level = 0,
        pos = { a1 = "CENTER", x = 0, y = 0, },
      },
      texture = {
        file = "Interface\\AddOns\\rFramerotater\\media\\zahnrad",
        color = { r = 255/255, g = 0/255, b = 0/255, },
        blendmode = "BLEND", --ADD or BLEND
      },
      anim = {
        rotateframe = false, --rotateframe, if false rotates the texture only
        duration = 60, --how long should the rotation need to finish 360°
        direction = 1, --0 = counter-clockwise, 1 = clockwise
      },
    },
    [5] = {
      frame = {
        parent = UIParent,
        width = 100,
        height = 100,
        scale = 1,
        alpha = 0.5,
        level = 0,
        pos = { a1 = "CENTER", x = -120, y = 120, },
      },
      texture = {
        file = "Interface\\AddOns\\rFramerotater\\media\\zahnrad",
        color = { r = 255/255, g = 255/255, b = 0/255, },
        blendmode = "BLEND", --ADD or BLEND
      },
      anim = {
        rotateframe = false, --rotateframe, if false rotates the texture only
        duration = 30, --how long should the rotation need to finish 360°
        direction = 0, --0 = counter-clockwise, 1 = clockwise
      },
    },
    [6] = {
      frame = {
        parent = UIParent,
        width = 100,
        height = 100,
        scale = 1,
        alpha = 0.5,
        level = 0,
        pos = { a1 = "CENTER", x = 0, y = 120, },
      },
      texture = {
        file = "Interface\\AddOns\\rFramerotater\\media\\zahnrad",
        color = { r = 255/255, g = 0/255, b = 0/255, },
        blendmode = "BLEND", --ADD or BLEND
      },
      anim = {
        rotateframe = false, --rotateframe, if false rotates the texture only
        duration = 30, --how long should the rotation need to finish 360°
        direction = 1, --0 = counter-clockwise, 1 = clockwise
      },
    },
    [7] = {
      frame = {
        parent = UIParent,
        width = 100,
        height = 100,
        scale = 1,
        alpha = 0.5,
        level = 0,
        pos = { a1 = "CENTER", x = -120, y = 240, },
      },
      texture = {
        file = "Interface\\AddOns\\rFramerotater\\media\\zahnrad",
        color = { r = 255/255, g = 255/255, b = 0/255, },
        blendmode = "BLEND", --ADD or BLEND
      },
      anim = {
        rotateframe = false, --rotateframe, if false rotates the texture only
        duration = 15, --how long should the rotation need to finish 360°
        direction = 0, --0 = counter-clockwise, 1 = clockwise
      },
    },
    [8] = {
      frame = {
        parent = UIParent,
        width = 100,
        height = 100,
        scale = 1,
        alpha = 0.5,
        level = 0,
        pos = { a1 = "CENTER", x = 0, y = 240, },
      },
      texture = {
        file = "Interface\\AddOns\\rFramerotater\\media\\zahnrad",
        color = { r = 255/255, g = 0/255, b = 0/255, },
        blendmode = "BLEND", --ADD or BLEND
      },
      anim = {
        rotateframe = false, --rotateframe, if false rotates the texture only
        duration = 15, --how long should the rotation need to finish 360°
        direction = 1, --0 = counter-clockwise, 1 = clockwise
      },
    },
  }

  ---------------------
  -- CONFIG AREA END --
  ---------------------

  function init(id)

    local cfg = db[id]

    local h = CreateFrame("Frame",nil,cfg.frame.parent)
    h:SetHeight(cfg.frame.height)
    h:SetWidth(cfg.frame.width)
    h:SetPoint(cfg.frame.pos.a1,cfg.frame.pos.x,cfg.frame.pos.y)
    h:SetScale(cfg.frame.scale)
    h:SetAlpha(cfg.frame.alpha)
    h:SetFrameLevel(cfg.frame.level)

    h.time = GetTime()

    local t = h:CreateTexture(nil,"BACKGROUND")
    t:SetAllPoints(h)
    t:SetTexture(cfg.texture.file)
    t:SetBlendMode(cfg.texture.blendmode)
    t:SetVertexColor(cfg.texture.color.r,cfg.texture.color.g,cfg.texture.color.b)
    h.t = t

    local o = t --object to animate
    if cfg.anim.rotateframe then
      o = h --frame is object to animate
    end

    local ag = o:CreateAnimationGroup()
    o.ag = ag

    local a1 = o.ag:CreateAnimation("Rotation")
    if cfg.anim.direction == 0 then
      a1:SetDegrees(360)
    else
      a1:SetDegrees(-360)
    end
    a1:SetDuration(cfg.anim.duration)
    o.ag.a1 = a1

    o.ag:Play()
    o.ag:SetLooping("REPEAT")

    --debug
    h:SetScript("OnShow", function() print("id: "..i.." duration: "..cfg.anim.duration.." time: "..floor(GetTime()-h.time)) end)
    h:SetScript("OnHide", function() print("id: "..i.." duration: "..cfg.anim.duration.." time: "..floor(GetTime()-h.time)) end)

  end

  local a = CreateFrame("Frame")
  a:RegisterEvent("PLAYER_LOGIN")
  a:SetScript("OnEvent", function (self,event,...)
    for i,v in ipairs(db) do
      init(i)
    end
  end)
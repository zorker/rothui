
local an, at = ...
 
-- Some math stuff
local cos, sin, pi2, halfpi = math.cos, math.sin, math.rad(360), math.rad(90)

local function Round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end

local function Transform(tx, x, y, angle, aspect) -- Translates texture to x, y and rotates about its center
    local c, s = cos(angle), sin(angle)
    local y, oy = y / aspect, 0.5 / aspect
    local ULx, ULy = 0.5 + (x - 0.5) * c - (y - oy) * s, (oy + (y - oy) * c + (x - 0.5) * s) * aspect
    local LLx, LLy = 0.5 + (x - 0.5) * c - (y + oy) * s, (oy + (y + oy) * c + (x - 0.5) * s) * aspect
    local URx, URy = 0.5 + (x + 0.5) * c - (y - oy) * s, (oy + (y - oy) * c + (x + 0.5) * s) * aspect
    local LRx, LRy = 0.5 + (x + 0.5) * c - (y + oy) * s, (oy + (y + oy) * c + (x + 0.5) * s) * aspect
    tx:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
end
 
local function SetValue(self, value)

    if not value then 
      value = self._oldvalue or 0 
    end
    
    -- Correct invalid ranges, preferably just don"t feed it invalid numbers
    if value > 1 then value = 1
    elseif value < 0 then value = 0 end
    
    -- Reverse our normal behavior
    if self._reverse then
        value = 1 - value
    end
    
    self._oldvalue = value
    
    -- Determine which quadrant we"re in
    local q, quadrant = self._clockwise and (1 - value) or value -- 4 - floor(value / 0.25)
    if q >= 0.75 then
        quadrant = 1
    elseif q >= 0.5 then
        quadrant = 2
    elseif q >= 0.25 then
        quadrant = 3
    else
        quadrant = 4
    end
    
    if self._quadrant ~= quadrant then
        self._quadrant = quadrant
        -- Show/hide necessary textures if we need to
        if self._clockwise then
            for i = 1, 4 do
                self._textures[i]:SetShown(i < quadrant)
            end
        else
            for i = 1, 4 do
                self._textures[i]:SetShown(i > quadrant)
            end
        end
        -- Move scrollframe/wedge to the proper quadrant
        self._scrollframe:SetAllPoints(self._textures[quadrant])    
    end
 
    -- Rotate the things
    local rads = value * pi2
    if not self._clockwise then rads = -rads + halfpi end
    self._rotation:SetRadians(-rads)
    Transform(self._wedge, -0.5, -0.5, rads, self._aspect)
    end
 
local function SetClockwise(self, clockwise)
    self._clockwise = clockwise
    self:SetValue(nil)
end
 
local function SetReverse(self, reverse)
    self._reverse = reverse
    self:SetValue(nil)
end
 
local function OnSizeChanged(self, width, height)
    self._wedge:SetSize(width, height) -- it"s important to keep this texture sized correctly
    self._aspect = width / height -- required to calculate the texture coordinates
    self:SetValue(nil)
end
 
-- Creates a function that calls a method on all textures at once
local function CreateTextureFunction(func, self, ...)
    return function(self, ...)
        for i = 1, 4 do
            local tx = self._textures[i]
            tx[func](tx, ...)
        end
        self._wedge[func](self._wedge, ...)
        self._bg[func](self._bg, ...)
    end
end
 
-- Pass calls to these functions on our frame to its textures
local TextureFunctions = {
    SetTexture = CreateTextureFunction("SetTexture"),
    SetBlendMode = CreateTextureFunction("SetBlendMode"),
    SetVertexColor = CreateTextureFunction("SetVertexColor"),
}
 
local function CreateSpinner(parent)
    local spinner = CreateFrame("Frame", nil, parent)
    
    local bg = spinner:CreateTexture(nil,"BACKGROUND",nil,-8)
    --bg:SetVertexColor(0,1,0,0.2)
    bg:SetAlpha(0.2)
    bg:SetAllPoints()
    spinner._bg = bg
    
    -- Top Right
    local trTexture = spinner:CreateTexture(nil,"BACKGROUND",nil,-7)
    trTexture:SetPoint("BOTTOMLEFT", spinner, "CENTER")
    trTexture:SetPoint("TOPRIGHT")
    trTexture:SetTexCoord(0.5, 1, 0, 0.5)
    
    -- Bottom Right
    local brTexture = spinner:CreateTexture(nil,"BACKGROUND",nil,-7)
    brTexture:SetPoint("TOPLEFT", spinner, "CENTER")
    brTexture:SetPoint("BOTTOMRIGHT")
    brTexture:SetTexCoord(0.5, 1, 0.5, 1)
    
    -- Bottom Left
    local blTexture = spinner:CreateTexture(nil,"BACKGROUND",nil,-7)
    blTexture:SetPoint("TOPRIGHT", spinner, "CENTER")
    blTexture:SetPoint("BOTTOMLEFT")
    blTexture:SetTexCoord(0, 0.5, 0.5, 1)
    
    -- Top Left
    local tlTexture = spinner:CreateTexture(nil,"BACKGROUND",nil,-7)
    tlTexture:SetPoint("BOTTOMRIGHT", spinner, "CENTER")
    tlTexture:SetPoint("TOPLEFT")
    tlTexture:SetTexCoord(0, 0.5, 0, 0.5)
    
    -- ScrollFrame clips the actively animating portion of the spinner
    local scrollframe = CreateFrame("ScrollFrame", nil, spinner)
    scrollframe:SetPoint("BOTTOMLEFT", spinner, "CENTER")
    scrollframe:SetPoint("TOPRIGHT")
    spinner._scrollframe = scrollframe
    
    local scrollchild = CreateFrame("Frame", nil, scrollframe)
    scrollframe:SetScrollChild(scrollchild)
    scrollchild:SetAllPoints(scrollframe)
    
    -- Wedge thing
    local wedge = scrollchild:CreateTexture()
    --local wedge = spinner:CreateTexture(nil,"BACKGROUND",nil,-6)
    wedge:SetPoint("BOTTOMRIGHT", spinner, "CENTER")
    spinner._wedge = wedge
    
    -- /4|1\ -- Clockwise texture arrangement
    -- \3|2/ --
 
    spinner._textures = {trTexture, brTexture, blTexture, tlTexture}
    spinner._quadrant = nil -- Current active quadrant
    spinner._clockwise = true -- fill clockwise
    spinner._reverse = false -- Treat the provided value as its inverse, eg. 75% will display as 25%
    spinner._aspect = 1 -- aspect ratio, width / height of spinner frame
    spinner:HookScript("OnSizeChanged", OnSizeChanged)
    
    for method, func in pairs(TextureFunctions) do
        spinner[method] = func
    end
    
    spinner.SetClockwise = SetClockwise
    spinner.SetReverse = SetReverse
    spinner.SetValue = SetValue
    
    local group = wedge:CreateAnimationGroup()
    local rotation = group:CreateAnimation("Rotation")
    rotation:SetOrigin("BOTTOMRIGHT", 0, 0)
    rotation:SetDuration(0)
    rotation:SetEndDelay(1)
    group:Play()
    group:Pause()
    spinner._rotation = rotation
    
    return spinner
end
 
----------
-- Demo
----------
 
local spinner1 = CreateSpinner(UIParent)
spinner1:SetPoint("BOTTOM",UIParent,"CENTER")
spinner1:SetSize(64, 64)
spinner1:SetTexture("interface/icons/inv_mushroom_11")
 
spinner1:SetClockwise(true)
spinner1:SetReverse(false)

local value = 0.1

spinner1:SetValue(value)

local slider = CreateFrame("Slider", an.."RingSlider", UIParent, "OptionsSliderTemplate")

slider:SetMinMaxValues(0,1)
slider:SetValue(value)
slider:SetValueStep(0.01)

slider.text = _G[an.."RingSliderText"]
slider.low = _G[an.."RingSliderLow"]
slider.high = _G[an.."RingSliderHigh"]

slider:SetPoint("TOP", spinner1, "BOTTOM", 0, -30)
slider.title = "Value"
slider.text:SetText(slider.title..": "..Round(value, 3))
local smin, smax = slider:GetMinMaxValues()
slider.low:SetText(smin)
slider.high:SetText(smax)

slider:SetScript("OnValueChanged", function(self,value)
  spinner1:SetValue(value)
  self.text:SetText(self.title..": "..Round(value, 3))
end)

local slider2 = CreateFrame("Slider", an.."RingSlider2", UIParent, "OptionsSliderTemplate")

slider2:SetMinMaxValues(32,128)
slider2:SetValue(64)
slider2:SetValueStep(1)

slider2.text = _G[an.."RingSlider2Text"]
slider2.low = _G[an.."RingSlider2Low"]
slider2.high = _G[an.."RingSlider2High"]

slider2:SetPoint("TOP", slider, "BOTTOM", 0, -15)
slider2.title = "Width"
slider2.text:SetText(slider2.title..": "..Round(64, 0))
local smin, smax = slider2:GetMinMaxValues()
slider2.low:SetText(smin)
slider2.high:SetText(smax)

slider2:SetScript("OnValueChanged", function(self,value)
  spinner1:SetWidth(Round(value, 0))
  self.text:SetText(self.title..": "..Round(value, 0))
end)

local slider3 = CreateFrame("Slider", an.."RingSlider3", UIParent, "OptionsSliderTemplate")

slider3:SetMinMaxValues(32,128)
slider3:SetValue(64)
slider3:SetValueStep(1)

slider3.text = _G[an.."RingSlider3Text"]
slider3.low = _G[an.."RingSlider3Low"]
slider3.high = _G[an.."RingSlider3High"]

slider3:SetPoint("TOP", slider2, "BOTTOM", 0, -15)
slider3.title = "Height"
slider3.text:SetText(slider3.title..": "..Round(64, 0))
local smin, smax = slider3:GetMinMaxValues()
slider3.low:SetText(smin)
slider3.high:SetText(smax)

slider3:SetScript("OnValueChanged", function(self,value)
  spinner1:SetHeight(Round(value, 0))
  self.text:SetText(self.title..": "..Round(value, 0))
end)

local slider4 = CreateFrame("Slider", an.."RingSlider4", UIParent, "OptionsSliderTemplate")

slider4:SetMinMaxValues(0,1)
slider4:SetValue(0.2)
slider4:SetValueStep(0.01)

slider4.text = _G[an.."RingSlider4Text"]
slider4.low = _G[an.."RingSlider4Low"]
slider4.high = _G[an.."RingSlider4High"]

slider4:SetPoint("TOP", slider3, "BOTTOM", 0, -15)
slider4.title = "BgAlpha"
slider4.text:SetText(slider4.title..": "..Round(0.2, 3))
local smin, smax = slider4:GetMinMaxValues()
slider4.low:SetText(smin)
slider4.high:SetText(smax)

slider4:SetScript("OnValueChanged", function(self,value)
  spinner1._bg:SetAlpha(value)
  self.text:SetText(self.title..": "..Round(value, 3))
end)

--checkbutton

local checkbutton = CreateFrame("CheckButton", an.."Checkbutton1", UIParent, "OptionsCheckButtonTemplate")
checkbutton.text = _G[an.."Checkbutton1Text"]
checkbutton.text:SetText("Clockwise")

checkbutton:HookScript("OnClick", function(self)
  spinner1:SetClockwise(self:GetChecked())
end)

checkbutton:SetPoint("TOP", slider4, "BOTTOM", -30, -10)
checkbutton:SetChecked(spinner1._clockwise)

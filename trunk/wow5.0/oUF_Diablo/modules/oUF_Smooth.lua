
local _, ns = ...
local oUF = ns.oUF or oUF

local smoothing = {}
local function Smooth(self, value)
  if value ~= self:GetValue() or value == 0 then
    smoothing[self] = value
  else
    smoothing[self] = nil
  end
end

local function SmoothBar(self, bar)
  bar.SetValue_ = bar.SetValue
  bar.SetValue = Smooth
end

local function hook(frame)
  frame.SmoothBar = SmoothBar
  if frame.Health and frame.Health.Smooth then
    frame:SmoothBar(frame.Health)
  end
  if frame.Power and frame.Power.Smooth then
    frame:SmoothBar(frame.Power)
  end
end

for i, frame in ipairs(oUF.objects) do hook(frame) end
oUF:RegisterInitCallback(hook)

local f, min, max, abs = CreateFrame("Frame"), math.min, math.max, math.abs
f:SetScript("OnUpdate", function()
  for bar, value in pairs(smoothing) do
    local cur = bar:GetValue()
    local new = cur + (value-cur)/15
    bar:SetValue_(new)
    if cur == value or abs(cur - value) < 1 then
      bar:SetValue_(value)
      smoothing[bar] = nil
    end
  end
end)
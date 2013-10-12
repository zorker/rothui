
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
  if frame.TotalAbsorb and frame.TotalAbsorb.Smooth then
    frame:SmoothBar(frame.TotalAbsorb)
  end
end

for i, frame in ipairs(oUF.objects) do hook(frame) end
oUF:RegisterInitCallback(hook)

local f, min, max, abs = CreateFrame("Frame"), math.min, math.max, math.abs
local lastUpdate, div, new, cur = 0, 15, 0, 0
f:SetScript("OnUpdate", function(self, elapsed)
  lastUpdate = lastUpdate+elapsed
  if lastUpdate > 1 then
    div = 15*GetFramerate()/100
    lastUpdate=0
  end
  for bar, value in pairs(smoothing) do
    cur = bar:GetValue()
    --at a rate of 100 fps the divisor should be 15
    new = cur + (value-cur)/div
    bar:SetValue_(new)
    if cur == value or abs(cur - value) < 1 then
      bar:SetValue_(value)
      smoothing[bar] = nil
    end
  end
end)
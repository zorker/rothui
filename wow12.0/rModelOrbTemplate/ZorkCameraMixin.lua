--[[
  ZorkCameraMixin - A simple camera that can orbit a target point at a fixed distance.

  The orbit is represented using a distance from a target point in world space and yaw, pitch and roll.
  The yaw, pitch and roll represent the camera's orientation, or inversely the direction of the camera from the target point.

  Optionally, the target, orientation and zoom can have splines that are added to the respective axes. The splines are fed the zoom percentage to calculate the point on the spline.
  This is ideal for changing view points based on zoom distance from the target. For example, target model's face on zoom in and center on the model on zoom out.
]]

local ZORK_CAMERA_MOUSE_MODE_NOTHING = 0
local ZORK_CAMERA_MOUSE_MODE_YAW_ROTATION = 1
local ZORK_CAMERA_MOUSE_MODE_PITCH_ROTATION = 2
local ZORK_CAMERA_MOUSE_MODE_ROLL_ROTATION = 3
local ZORK_CAMERA_MOUSE_MODE_TARGET_HORIZONTAL = 4
local ZORK_CAMERA_MOUSE_MODE_TARGET_VERTICAL = 5
local ZORK_CAMERA_MOUSE_MODE_ZOOM = 6
local ZORK_CAMERA_MOUSE_PAN_HORIZONTAL = 7
local ZORK_CAMERA_MOUSE_PAN_VERTICAL = 8

local mpi = math.pi

ZorkCameraMixin = CreateFromMixins(CameraBaseMixin)

local CAMERA_NAME = "ZorkCamera"
CameraRegistry:AddCameraFactoryFromMixin(CAMERA_NAME, ZorkCameraMixin)

-- "public" functions
function ZorkCameraMixin:GetCameraType() -- override
  return CAMERA_NAME
end

function ZorkCameraMixin:SetTarget(x, y, z)
  self.targetX, self.targetY, self.targetZ = x, y, z
end

function ZorkCameraMixin:GetTarget(x, y, z)
  return self.targetX, self.targetY, self.targetZ
end

function ZorkCameraMixin:SetYaw(yaw)
  self.yaw = yaw
end

function ZorkCameraMixin:GetYaw()
  return self.yaw
end

function ZorkCameraMixin:SetPitch(pitch)
  self.pitch = pitch
end

function ZorkCameraMixin:GetPitch()
  return self.pitch
end

function ZorkCameraMixin:SetRoll(roll)
  self.roll = roll
end

function ZorkCameraMixin:GetRoll()
  return self.roll
end

-- where 100% is fully zoomed out
function ZorkCameraMixin:GetZoomPercent()
  return self.zoomPercent
end

function ZorkCameraMixin:SetZoomPercent(zoomPercent)
  self.zoomPercent = Saturate(zoomPercent)
end

function ZorkCameraMixin:ZoomByPercent(percent)
  local zoom = self:GetZoomPercent() - percent
  self:SetZoomPercent(zoom)
end

function ZorkCameraMixin:SetMaxZoomDistance(distance)
  self.maxZoomDistance = distance
  if self:GetZoomPercent() then
    self:SetZoomDistance(self:GetZoomDistance())
  end
end

function ZorkCameraMixin:GetMaxZoomDistance()
  return self.maxZoomDistance
end

function ZorkCameraMixin:SetMinZoomDistance(distance)
  self.minZoomDistance = distance
  if self:GetZoomPercent() then
    self:SetZoomDistance(self:GetZoomDistance())
  end
end

function ZorkCameraMixin:GetMinZoomDistance()
  return self.minZoomDistance
end

function ZorkCameraMixin:SetZoomDistance(distance)
  self:SetZoomPercent(self:CalculateZoomPercentFromDistance(distance))
end

function ZorkCameraMixin:CalculateZoomPercentFromDistance(distance)
  if self:GetMinZoomDistance() and self:GetMaxZoomDistance() then
    return PercentageBetween(distance, self:GetMinZoomDistance(), self:GetMaxZoomDistance())
  end
  return 0.0
end

function ZorkCameraMixin:CalculateZoomDistanceFromPercent(percent)
  if self:GetMinZoomDistance() and self:GetMaxZoomDistance() then
    return Lerp(self:GetMinZoomDistance(), self:GetMaxZoomDistance(), percent)
  end
  return 0.0
end

function ZorkCameraMixin:GetZoomDistance()
  return self:CalculateZoomDistanceFromPercent(self:GetZoomPercent())
end

-- If min and max values are the same, zoom cannot really happen.
function ZorkCameraMixin:GetZoomAvailable()
  if self:GetMinZoomDistance() and self:GetMaxZoomDistance() then
    return self:GetMinZoomDistance() ~= self:GetMaxZoomDistance()
  end
  return false
end

function ZorkCameraMixin:ZoomBy(distance)
  self:SetZoomDistance(self:GetZoomDistance() - distance)
end

-- Expects a three dimensional spline where a point of the curve represents a target position
function ZorkCameraMixin:SetTargetSpline(targetSpline)
  self.targetSpline = targetSpline
end

function ZorkCameraMixin:GetTargetSpline()
  return self.targetSpline
end

-- Expects a three dimensional spline where a point of the curve represents the camera yaw, pitch, roll
function ZorkCameraMixin:SetOrientationSpline(orientationSpline)
  self.orientationSpline = orientationSpline
end

function ZorkCameraMixin:GetOrientationSpline()
  return self.orientationSpline
end

-- Expects an one dimensional spline where a point of the curve represents the camera's distance from the target
function ZorkCameraMixin:SetZoomSpline(zoomSpline)
  self.zoomSpline = zoomSpline
end

function ZorkCameraMixin:GetZoomSpline()
  return self.zoomSpline
end

--[[ These return the simple + spline values ]]--
function ZorkCameraMixin:GetDerivedTarget()
  local targetX, targetY, targetZ = self:GetTarget()

  local targetSpline = self:GetTargetSpline()
  if targetSpline then
    return Vector3D_Add(targetX, targetY, targetZ, targetSpline:CalculatePointOnGlobalCurve(1.0 - self:GetZoomPercent()))
  end

  return targetX, targetY, targetZ
end

function ZorkCameraMixin:GetDerivedOrientation()
  local yaw, pitch, roll = self:GetYaw(), self:GetPitch(), self:GetRoll()

  local orientationSpline = self:GetOrientationSpline()
  if orientationSpline then
    return Vector3D_Add(yaw, pitch, roll, orientationSpline:CalculatePointOnGlobalCurve(1.0 - self:GetZoomPercent()))
  end

  return yaw, pitch, roll
end

function ZorkCameraMixin:GetDerivedZoomDistance()
  local zoomDistance = self:GetZoomDistance()

  local zoomSpline = self:GetZoomSpline()
  if zoomSpline then
    return zoomDistance + zoomSpline:CalculatePointOnGlobalCurve(1.0 - self:GetZoomPercent())
  end

  return zoomDistance
end

--[[
  Interpolation API
  For each API, "amount" is the percentage to approach in an "ideal" frame (60 fps), such that setting the value to >= 1 would snap to the desired target and <= 0 would freeze the interpolation.
  Setting to nil will disable the interpolation.
]]

function ZorkCameraMixin:SetYawInterpolationAmount(yawInterpolationAmount)
  self.yawInterpolationAmount = yawInterpolationAmount
end

function ZorkCameraMixin:GetYawInterpolationAmount()
  return self.yawInterpolationAmount
end

function ZorkCameraMixin:SetPitchInterpolationAmount(pitchInterpolationAmount)
  self.pitchInterpolationAmount = pitchInterpolationAmount
end

function ZorkCameraMixin:GetPitchInterpolationAmount()
  return self.pitchInterpolationAmount
end

function ZorkCameraMixin:SetRollInterpolationAmount(rollInterpolationAmount)
  self.rollInterpolationAmount = rollInterpolationAmount
end

function ZorkCameraMixin:GetRollInterpolationAmount()
  return self.rollInterpolationAmount
end

function ZorkCameraMixin:SetTargetInterpolationAmount(targetInterpolationAmount)
  self.targetInterpolationAmount = targetInterpolationAmount
end

function ZorkCameraMixin:GetTargetInterpolationAmount()
  return self.targetInterpolationAmount
end

function ZorkCameraMixin:SetZoomInterpolationAmount(zoomInterpolationAmount)
  self.zoomInterpolationAmount = zoomInterpolationAmount
end

function ZorkCameraMixin:GetZoomInterpolationAmount()
  return self.zoomInterpolationAmount
end

function ZorkCameraMixin:GetInterpolatedTarget()
  if self.interpolatedTargetX then
    return self.interpolatedTargetX, self.interpolatedTargetY, self.interpolatedTargetZ
  end
  return self:GetDerivedTarget()
end

function ZorkCameraMixin:GetInterpolatedOrientation()
  if self.interpolatedYaw then
    return self.interpolatedYaw, self.interpolatedPitch, self.interpolatedRoll
  end
  return self:GetDerivedOrientation()
end

function ZorkCameraMixin:GetInterpolatedZoomDistance()
  if self.interpolatedZoomDistance then
    return self.interpolatedZoomDistance
  end
  return self:GetDerivedZoomDistance()
end

function ZorkCameraMixin:SnapToTargetInterpolationYaw()
  self.interpolatedYaw = nil
end

function ZorkCameraMixin:SnapToTargetInterpolationPitch()
  self.interpolatedPitch = nil
end

function ZorkCameraMixin:SnapToTargetInterpolationRoll()
  self.interpolatedRoll = nil
end

function ZorkCameraMixin:SnapToTargetInterpolationZoom()
  self.interpolatedZoomDistance = nil
end

function ZorkCameraMixin:SnapToTargetInterpolationTarget()
  self.interpolatedTargetX = nil
  self.interpolatedTargetY = nil
  self.interpolatedTargetZ = nil
end

function ZorkCameraMixin:SnapAllInterpolatedValues()
  self:SnapToTargetInterpolationYaw()
  self:SnapToTargetInterpolationPitch()
  self:SnapToTargetInterpolationRoll()
  self:SnapToTargetInterpolationZoom()
  self:SnapToTargetInterpolationTarget()
end

function ZorkCameraMixin:SetLeftMouseButtonXMode(mouseMode, snap)
  self.buttonModes.leftX = mouseMode
  self.buttonModes.leftXinterpolate = not snap
end

function ZorkCameraMixin:GetLeftMouseButtonXMode()
  return self.buttonModes.leftX, not self.buttonModes.leftXinterpolate
end

function ZorkCameraMixin:SetLeftMouseButtonYMode(mouseMode, snap)
  self.buttonModes.leftY = mouseMode
  self.buttonModes.leftYinterpolate = not snap
end

function ZorkCameraMixin:GetLeftMouseButtonYMode()
  return self.buttonModes.leftY, not self.buttonModes.leftYinterpolate
end

function ZorkCameraMixin:SetRightMouseButtonXMode(mouseMode, snap)
  self.buttonModes.rightX = mouseMode
  self.buttonModes.rightXinterpolate = not snap
end

function ZorkCameraMixin:GetRightMouseButtonXMode()
  return self.buttonModes.rightX, not self.buttonModes.rightXinterpolate
end

function ZorkCameraMixin:SetRightMouseButtonYMode(mouseMode, snap)
  self.buttonModes.rightY = mouseMode
  self.buttonModes.rightYinterpolate = not snap
end

function ZorkCameraMixin:GetRightMouseButtonYMode()
  return self.buttonModes.rightY, not self.buttonModes.rightYinterpolate
end

--NEW: mouse 4 modes
function ZorkCameraMixin:SetMouse4ButtonXMode(mouseMode, snap)
  self.buttonModes.m4X = mouseMode
  self.buttonModes.m4Xinterpolate = not snap
end

function ZorkCameraMixin:GetMouse4ButtonXMode()
  return self.buttonModes.m4X, not self.buttonModes.m4Xinterpolate
end

function ZorkCameraMixin:SetMouse4ButtonYMode(mouseMode, snap)
  self.buttonModes.m4Y = mouseMode
  self.buttonModes.m4Yinterpolate = not snap
end

function ZorkCameraMixin:GetMouse4ButtonYMode()
  return self.buttonModes.m4Y, not self.buttonModes.m4Yinterpolate
end

--NEW: mouse 5 modes
function ZorkCameraMixin:SetMouse5ButtonXMode(mouseMode, snap)
  self.buttonModes.m5X = mouseMode
  self.buttonModes.m5Xinterpolate = not snap
end

function ZorkCameraMixin:GetMouse5ButtonXMode()
  return self.buttonModes.m5X, not self.buttonModes.m5Xinterpolate
end

function ZorkCameraMixin:SetMouse5ButtonYMode(mouseMode, snap)
  self.buttonModes.m5Y = mouseMode
  self.buttonModes.m5Yinterpolate = not snap
end

function ZorkCameraMixin:GetMouse5ButtonYMode()
  return self.buttonModes.m5Y, not self.buttonModes.m5Yinterpolate
end

function ZorkCameraMixin:SetMouseWheelMode(mouseMode, snap)
  self.buttonModes.wheel = mouseMode
  self.buttonModes.wheelInterpolate = not snap
end

function ZorkCameraMixin:GetMouseWheelMode()
  return self.buttonModes.wheel, not self.buttonModes.wheelInterpolate
end

function ZorkCameraMixin:HandleMouseMovement(mode, delta, snapToValue)
  if mode == ZORK_CAMERA_MOUSE_MODE_YAW_ROTATION then
    self:SetYaw(Clamp(self:GetYaw() - delta, -mpi, mpi))
    if snapToValue then
      self:SnapToTargetInterpolationYaw()
    end
  elseif mode == ZORK_CAMERA_MOUSE_MODE_PITCH_ROTATION then
    self:SetPitch(Clamp(self:GetPitch() - delta, -mpi, mpi))
    if snapToValue then
      self:SnapToTargetInterpolationPitch()
    end
  elseif mode == ZORK_CAMERA_MOUSE_MODE_ROLL_ROTATION then
    self:SetRoll(Clamp(self:GetRoll() - delta, -mpi, mpi))
    if snapToValue then
      self:SnapToTargetInterpolationRoll()
    end
  elseif mode == ZORK_CAMERA_MOUSE_MODE_ZOOM then
    self:ZoomByPercent(delta)
    if snapToValue then
      self:SnapToTargetInterpolationZoom()
    end
  elseif mode == ZORK_CAMERA_MOUSE_MODE_TARGET_HORIZONTAL then
    local rightX, rightY, rightZ = Vector3D_ScaleBy(delta, self:GetRightVector())
    self:SetTarget(Vector3D_Add(rightX, rightY, rightZ, self:GetTarget()))
    if snapToValue then
      self:SnapToTargetInterpolationTarget()
    end
  elseif mode == ZORK_CAMERA_MOUSE_MODE_TARGET_VERTICAL then
    local upX, upY, upZ = Vector3D_ScaleBy(delta, self:GetUpVector())
    self:SetTarget(Vector3D_Add(upX, upY, upZ, self:GetTarget()))
    if snapToValue then
      self:SnapToTargetInterpolationTarget()
    end
  elseif mode == ZORK_CAMERA_MOUSE_PAN_HORIZONTAL then
    self.panningXOffset = self.panningXOffset + delta
  elseif mode == ZORK_CAMERA_MOUSE_PAN_VERTICAL then
    self.panningYOffset = self.panningYOffset + delta
  end
end

function ZorkCameraMixin:ResetDefaultInputModes()
  --left
  self:SetLeftMouseButtonXMode(ZORK_CAMERA_MOUSE_MODE_YAW_ROTATION, true)
  self:SetLeftMouseButtonYMode(ZORK_CAMERA_MOUSE_MODE_NOTHING, true)
  --right 
  self:SetRightMouseButtonXMode(ZORK_CAMERA_MOUSE_MODE_PITCH_ROTATION, true)
  self:SetRightMouseButtonYMode(ZORK_CAMERA_MOUSE_MODE_NOTHING, true)
  --NEW: m4
  self:SetMouse4ButtonXMode(ZORK_CAMERA_MOUSE_MODE_ROLL_ROTATION, true) --ZORK_CAMERA_MOUSE_MODE_TARGET_HORIZONTAL
  self:SetMouse4ButtonYMode(ZORK_CAMERA_MOUSE_MODE_NOTHING, true) --ZORK_CAMERA_MOUSE_MODE_TARGET_VERTICAL
  --NEW: m5
  self:SetMouse5ButtonXMode(ZORK_CAMERA_MOUSE_PAN_HORIZONTAL, true)
  self:SetMouse5ButtonYMode(ZORK_CAMERA_MOUSE_PAN_VERTICAL)
  --wheel
  self:SetMouseWheelMode(ZORK_CAMERA_MOUSE_MODE_ZOOM, true)
end

function ZorkCameraMixin:OnRemoved()
  print("OnRemoved")
end

function ZorkCameraMixin:SetAndRefreshValues(panX, panY, zoomDist, yaw, pitch, roll)
  self:SetTarget(0, 0, 0)
  self.panningXOffset = panX or 0
  self.panningYOffset = panY or 0
  self:SetZoomDistance(zoomDist or 15)
  self:SetYaw(yaw or 0)
  self:SetPitch(pitch or 0)
  self:SetRoll(roll or 0)
  self:SnapAllInterpolatedValues()
  self:UpdateCameraOrientationAndPosition()
end

-- "private" function
function ZorkCameraMixin:OnAdded() -- override

  print("ZorkCameraMixin2","OnAdded")

  self.buttonModes = {}

  --local targetSpline = CreateCatmullRomSpline(3)
  --targetSpline:AddPoint(0, 0, 0)
  --targetSpline:AddPoint(0, 0, .5)
  --self:SetTargetSpline(targetSpline)

  self:SetMinZoomDistance(1)
  self:SetMaxZoomDistance(30)

  self:SetZoomInterpolationAmount(.15)
  self:SetYawInterpolationAmount(.15)
  self:SetPitchInterpolationAmount(.15)
  self:SetRollInterpolationAmount(.15)
  self:SetTargetInterpolationAmount(.15)

  self:ResetDefaultInputModes()
  self:SetAndRefreshValues()

end

function ZorkCameraMixin:GetDeltaModifierForCameraMode(mode)
  if mode == ZORK_CAMERA_MOUSE_MODE_YAW_ROTATION then
    return .008
  elseif mode == ZORK_CAMERA_MOUSE_MODE_PITCH_ROTATION then
    return .008
  elseif mode == ZORK_CAMERA_MOUSE_MODE_ROLL_ROTATION then
    return .008
  elseif mode == ZORK_CAMERA_MOUSE_MODE_ZOOM then
    return .008
  elseif mode == ZORK_CAMERA_MOUSE_MODE_TARGET_HORIZONTAL then
    return .05
  elseif mode == ZORK_CAMERA_MOUSE_MODE_TARGET_VERTICAL then
    return .05
  elseif mode == ZORK_CAMERA_MOUSE_PAN_HORIZONTAL then
    return 0.93
  elseif mode == ZORK_CAMERA_MOUSE_PAN_VERTICAL then
    return 0.93
  end
  return 0.0
end

function ZorkCameraMixin:OnUpdate(elapsed) -- override

  --left
  if self:IsLeftMouseButtonDown() then
    local deltaX, deltaY = GetScaledCursorDelta()
    self:HandleMouseMovement(self.buttonModes.leftX,  deltaX * self:GetDeltaModifierForCameraMode(self.buttonModes.leftX), not self.buttonModes.leftXinterpolate)
    self:HandleMouseMovement(self.buttonModes.leftY, -deltaY * self:GetDeltaModifierForCameraMode(self.buttonModes.leftY), not self.buttonModes.leftYinterpolate)
  end

  --right
  if self:IsRightMouseButtonDown() then
    local deltaX, deltaY = GetScaledCursorDelta()
    self:HandleMouseMovement(self.buttonModes.rightX,  deltaX * self:GetDeltaModifierForCameraMode(self.buttonModes.rightX), not self.buttonModes.rightXinterpolate)
    self:HandleMouseMovement(self.buttonModes.rightY, -deltaY * self:GetDeltaModifierForCameraMode(self.buttonModes.rightY), not self.buttonModes.rightYinterpolate)
  end

  --NEW: m4
  if self:IsMouse4ButtonDown() then
    local deltaX, deltaY = GetScaledCursorDelta()
    self:HandleMouseMovement(self.buttonModes.m4X,  deltaX * self:GetDeltaModifierForCameraMode(self.buttonModes.m4X), not self.buttonModes.m4Xinterpolate)
    self:HandleMouseMovement(self.buttonModes.m4Y, -deltaY * self:GetDeltaModifierForCameraMode(self.buttonModes.m4Y), not self.buttonModes.m4Yinterpolate)
  end

  --NEW: m5
  if self:IsMouse5ButtonDown() then
    local deltaX, deltaY = GetScaledCursorDelta()
    self:HandleMouseMovement(self.buttonModes.m5X,  deltaX * self:GetDeltaModifierForCameraMode(self.buttonModes.m5X), not self.buttonModes.m5Xinterpolate)
    self:HandleMouseMovement(self.buttonModes.m5Y, -deltaY * self:GetDeltaModifierForCameraMode(self.buttonModes.m5Y), not self.buttonModes.m5Yinterpolate)
  end

  --self:UpdateInterpolationTargets(elapsed)
  self:SnapAllInterpolatedValues()
  self:UpdateCameraOrientationAndPosition()

end

local function InterpolateDimension(lastValue, targetValue, amount, elapsed)
  return lastValue and amount and DeltaLerp(lastValue, targetValue, amount, elapsed) or targetValue
end

function ZorkCameraMixin:UpdateInterpolationTargets(elapsed)
  local yaw, pitch, roll = self:GetDerivedOrientation()
  local targetX, targetY, targetZ = self:GetDerivedTarget()
  local zoomDistance = self:GetDerivedZoomDistance()

  self.interpolatedYaw = InterpolateDimension(self.interpolatedYaw, yaw, self.yawInterpolationAmount, elapsed)
  self.interpolatedPitch = InterpolateDimension(self.interpolatedPitch, pitch, self.pitchInterpolationAmount, elapsed)
  self.interpolatedRoll = InterpolateDimension(self.interpolatedRoll, roll, self.rollInterpolationAmount, elapsed)

  self.interpolatedZoomDistance = InterpolateDimension(self.interpolatedZoomDistance, zoomDistance, self.zoomInterpolationAmount, elapsed)

  self.interpolatedTargetX = InterpolateDimension(self.interpolatedTargetX, targetX, self.targetInterpolationAmount, elapsed)
  self.interpolatedTargetY = InterpolateDimension(self.interpolatedTargetY, targetY, self.targetInterpolationAmount, elapsed)
  self.interpolatedTargetZ = InterpolateDimension(self.interpolatedTargetZ, targetZ, self.targetInterpolationAmount, elapsed)
end

function ZorkCameraMixin:UpdateCameraOrientationAndPosition()
  local yaw, pitch, roll = self:GetInterpolatedOrientation()
  local axisAngleX, axisAngleY, axisAngleZ = Vector3D_CalculateNormalFromYawPitch(yaw, pitch)

  local targetX, targetY, targetZ = self:GetInterpolatedTarget()

  local zoomDistance = self:GetInterpolatedZoomDistance()

  -- Panning start --
  -- We want the model to move 1-to-1 with the mouse.
  -- Panning formula: dx / hypotenuse * (zoomDistance - 1 / zoomDistance^3)
  -- It was experimentally determined that adding the additional fudge factor 1/z^3 resulted in better tracking.

  local width = 256
  local height = 256
  local scaleFactor = (width ~= 0 and height ~= 0) and math.sqrt(width * width + height * height) or 1
  local zoomFactor = 1
  if zoomDistance > 1 then
    zoomFactor = zoomDistance - (1 / (zoomDistance * zoomDistance * zoomDistance))
    if zoomFactor < 1 then
      zoomFactor = 1
    end
  end

  local rightX, rightY, rightZ = Vector3D_ScaleBy((self.panningXOffset / scaleFactor) * zoomFactor, self:GetRightVector())
  local upX, upY, upZ = Vector3D_ScaleBy((self.panningYOffset / scaleFactor) * zoomFactor, self:GetUpVector())

  -- Panning end --

  targetX, targetY, targetZ = Vector3D_Add(targetX, targetY, targetZ, rightX, rightY, rightZ)
  targetX, targetY, targetZ = Vector3D_Add(targetX, targetY, targetZ, upX, upY, upZ)

  self:SetPosition(self:CalculatePositionByDistanceFromTarget(targetX, targetY, targetZ, zoomDistance, axisAngleX, axisAngleY, axisAngleZ))
  self:GetOwningScene():SetCameraOrientationByYawPitchRoll(yaw, pitch, roll)

end

function ZorkCameraMixin:UpdateLight()
  if self:ShouldAlignLightToOrbitDelta() then
    local owningScene = self:GetOwningScene()
    owningScene:SetLightDirection(self:GetForwardVector())
  end
end

function ZorkCameraMixin:CalculatePositionByDistanceFromTarget(targetX, targetY, targetZ, zoomDistance, axisAngleX, axisAngleY, axisAngleZ)
  local towardsPosX, towardsPosY, towardsPosZ = Vector3D_ScaleBy(-zoomDistance, axisAngleX, axisAngleY, axisAngleZ)
  return Vector3D_Add(towardsPosX, towardsPosY, towardsPosZ, targetX, targetY, targetZ)
end

function ZorkCameraMixin:OnMouseWheel(delta) -- override
  self:HandleMouseMovement(self.buttonModes.wheel, delta * self:GetDeltaModifierForCameraMode(self.buttonModes.wheel), not self.buttonModes.wheelInterpolate)
  self:SnapAllInterpolatedValues()
  self:UpdateCameraOrientationAndPosition()
end

function ZorkCameraMixin:IsLeftMouseButtonDown()
  return self:GetOwningScene():IsLeftMouseButtonDown()
end

function ZorkCameraMixin:IsRightMouseButtonDown()
  return self:GetOwningScene():IsRightMouseButtonDown()
end

function ZorkCameraMixin:IsMouse4ButtonDown()
  return self:GetOwningScene():IsMouse4ButtonDown()
end

function ZorkCameraMixin:IsMouse5ButtonDown()
  return self:GetOwningScene():IsMouse5ButtonDown()
end
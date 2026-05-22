local function TryCreateZoomSpline(x, y, z, existingSpline)
	if x and y and z and (x ~= 0 or y ~= 0 or z ~= 0) then
		local spline = existingSpline or CreateCatmullRomSpline(3);
		spline:ClearPoints();
		spline:AddPoint(0, 0, 0);
		spline:AddPoint(x, y, z);

		return spline;
	end
	return nil;
end

function OrbitCameraMixin:UpdateCameraOrientationAndPositionZork()
	local yaw, pitch, roll = self:GetInterpolatedOrientation();
	local axisAngleX, axisAngleY, axisAngleZ = Vector3D_CalculateNormalFromYawPitch(yaw, pitch);

	local targetX, targetY, targetZ = self:GetInterpolatedTarget();

	local zoomDistance = self:GetInterpolatedZoomDistance();

	-- Panning start --
	-- We want the model to move 1-to-1 with the mouse.
	-- Panning formula: dx / hypotenuse * (zoomDistance - 1 / zoomDistance^3)
	-- It was experimentally determined that adding the additional fudge factor 1/z^3 resulted in better tracking.

	local width = 256;
	local height = 256;
	local scaleFactor = (width ~= 0 and height ~= 0) and math.sqrt(width * width + height * height) or 1;
	local zoomFactor = 1;
	if zoomDistance > 1 then
		zoomFactor = zoomDistance - (1 / (zoomDistance * zoomDistance * zoomDistance));
		if zoomFactor < 1 then
			zoomFactor = 1;
		end
	end

	local rightX, rightY, rightZ = Vector3D_ScaleBy((self.panningXOffset / scaleFactor) * zoomFactor, self:GetRightVector());
	local upX, upY, upZ = Vector3D_ScaleBy((self.panningYOffset / scaleFactor) * zoomFactor, self:GetUpVector());

	-- Panning end --

	targetX, targetY, targetZ = Vector3D_Add(targetX, targetY, targetZ, rightX, rightY, rightZ);
	targetX, targetY, targetZ = Vector3D_Add(targetX, targetY, targetZ, upX, upY, upZ);

	self:SetPosition(self:CalculatePositionByDistanceFromTarget(targetX, targetY, targetZ, zoomDistance, axisAngleX, axisAngleY, axisAngleZ));
	self:GetOwningScene():SetCameraOrientationByYawPitchRoll(yaw, pitch, roll);
end


function OrbitCameraMixin:ApplyFromModelSceneCameraInfoZork(modelSceneCameraInfo, transitionType, modificationType) -- override
	self.panningXOffset = 0;
	self.panningYOffset = 0;

	local transitionalCameraInfo = self:CalculateTransitionalValues(self.modelSceneCameraInfo, modelSceneCameraInfo, modificationType);

	self.modelSceneCameraInfo = modelSceneCameraInfo;

	self:SetTarget(transitionalCameraInfo.target:GetXYZ());
	self:SetTargetSpline(TryCreateZoomSpline(transitionalCameraInfo.zoomedTargetOffset:GetXYZ()), self:GetTargetSpline());
	self:SetOrientationSpline(TryCreateZoomSpline(transitionalCameraInfo.zoomedYawOffset, transitionalCameraInfo.zoomedPitchOffset, transitionalCameraInfo.zoomedRollOffset), self:GetOrientationSpline());

	self:SetMinZoomDistance(transitionalCameraInfo.minZoomDistance);
	self:SetMaxZoomDistance(transitionalCameraInfo.maxZoomDistance);

	self:SetZoomDistance(transitionalCameraInfo.zoomDistance);

	self:SetYaw(transitionalCameraInfo.yaw);
	self:SetPitch(transitionalCameraInfo.pitch);
	self:SetRoll(transitionalCameraInfo.roll);

	if transitionType == CAMERA_TRANSITION_TYPE_IMMEDIATE then
		self:SnapAllInterpolatedValues();
	end
	self:UpdateCameraOrientationAndPositionZork();
end


function ModelSceneMixin:CreateCameraFromSceneZork(modelSceneCameraID)
	local modelSceneCameraInfo = C_ModelInfo.GetModelSceneCameraInfoByID(modelSceneCameraID);
	if modelSceneCameraInfo then
		local camera = CameraRegistry:CreateCameraByType(modelSceneCameraInfo.cameraType);
		if camera then
			if modelSceneCameraInfo.scriptTag then
				self.tagToCamera[modelSceneCameraInfo.scriptTag] = camera;
			end
			self:AddCamera(camera);
			camera:ApplyFromModelSceneCameraInfoZork(modelSceneCameraInfo, CAMERA_TRANSITION_TYPE_IMMEDIATE, CAMERA_MODIFICATION_TYPE_DISCARD);
			return camera;
		end
	end
end

function ModelSceneMixin:SetFromModelSceneIDZork(modelSceneID, forceEvenIfSame, noAutoCreateActors)
	local modelSceneType, cameraIDs, actorIDs = C_ModelInfo.GetModelSceneInfoByID(modelSceneID);
	if not modelSceneType then
		return;
	end

	if self.modelSceneID ~= modelSceneID or forceEvenIfSame then
		self.modelSceneID = modelSceneID;
		self:ReleaseAllActors();
		self:ReleaseAllCameras();

		if not noAutoCreateActors then
			for actorIndex, actorID in ipairs(actorIDs) do
				self:CreateActorFromScene(actorID);
			end
		end

		for cameraIndex, cameraID in ipairs(cameraIDs) do
			self:CreateCameraFromSceneZork(cameraID);
		end
	end

	C_ModelInfo.AddActiveModelScene(self, self.modelSceneID);
	EventRegistry:TriggerEvent("ModelScene.SetFromModelSceneID", self, self.modelSceneID);
end
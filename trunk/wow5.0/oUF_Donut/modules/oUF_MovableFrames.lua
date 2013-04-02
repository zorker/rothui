local _NAME, _NS = ...
local oUF = _NS.oUF or oUF

assert(oUF, "oUF_MovableFrames was unable to locate oUF install.")

-- The DB is organized as the following:
-- {
--    Lily = {
--       player = "CENTER\031UIParent\0310\031-621\0310.8",
-- }
--}
local _DB
local _DBNAME = GetAddOnMetadata(_NAME, 'X-SavedVariables')
local _LOCK
local _TITLE = GetAddOnMetadata(_NAME, 'title')

local _BACKDROP = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background";
}

-- I could use the title field in the TOC, but people tend to put color and
-- other shit there, so we'll just use the folder name:
local slashGlobal = _NAME:gsub('%s+', '_'):gsub('[^%a%d_]+', ''):upper()
slashGlobal = slashGlobal .. '_OMF'

local print_fmt = string.format('|cff33ff99%s:|r', _TITLE)
local print = function(...)
	return print(print_fmt, ...)
end

local backdropPool = {}

local getPoint = function(obj, anchor)
	if(not anchor) then
		local UIx, UIy = UIParent:GetCenter()
		local Ox, Oy = obj:GetCenter()

		-- Frame doesn't really have a positon yet.
		if(not Ox) then return end

		local OS = obj:GetScale()
		Ox, Oy = Ox * OS, Oy * OS

		local UIWidth, UIHeight = UIParent:GetRight(), UIParent:GetTop()

		local LEFT = UIWidth / 3
		local RIGHT = UIWidth * 2 / 3

		local point, x, y
		if(Ox >= RIGHT) then
			point = 'RIGHT'
			x = obj:GetRight() - UIWidth
		elseif(Ox <= LEFT) then
			point = 'LEFT'
			x = obj:GetLeft()
		else
			x = Ox - UIx
		end

		local BOTTOM = UIHeight / 3
		local TOP = UIHeight * 2 / 3

		if(Oy >= TOP) then
			point = 'TOP' .. (point or '')
			y = obj:GetTop() - UIHeight
		elseif(Oy <= BOTTOM) then
			point = 'BOTTOM' .. (point or '')
			y = obj:GetBottom()
		else
			if(not point) then point = 'CENTER' end
			y = Oy - UIy
		end

		return string.format(
			'%s\031%s\031%d\031%d\031\%.3f',
			point, 'UIParent', x,  y, OS
		)
	else
		local point, parent, _, x, y = anchor:GetPoint()

		return string.format(
			'%s\031%s\031%d\031%d\031\%.3f',
			point, 'UIParent', x, y, obj:GetScale()
		)
	end
end

local getObjectInformation  = function(obj)
	-- This won't be set if we're dealing with oUF <1.3.22. Due to this we're just
	-- setting it to Unknown. It will only break if the user has multiple layouts
	-- spawning the same unit or change between layouts.
	local style = obj.style or 'Unknown'
	local identifier = obj:GetName() or obj.unit

	-- Are we dealing with header units?
	local isHeader
	local parent = obj:GetParent()

	if(parent) then
		if(parent:GetAttribute'initialConfigFunction' and parent.style) then
			isHeader = parent

			identifier = parent:GetName()
		elseif(parent:GetAttribute'oUF-onlyProcessChildren') then
			isHeader = parent:GetParent()

			identifier = isHeader:GetName()
		end
	end

	return style, identifier, isHeader
end

local restoreDefaultPosition = function(style, identifier)
	-- We've not saved any default position for this style.
	if(not _DB.__INITIAL or not _DB.__INITIAL[style] or not _DB.__INITIAL[style][identifier]) then return end

	local obj, isHeader
	for _, frame in next, oUF.objects do
		local fStyle, fIdentifier, fIsHeader = getObjectInformation(frame)
		if(fStyle == style and fIdentifier == identifier) then
			obj = frame
			isHeader = fIsHeader

			break
		end
	end

	if(obj) then
		local target = isHeader or obj

		target:ClearAllPoints()
		local point, parentName, x, y, scale = string.split('\031', _DB.__INITIAL[style][identifier])
		if(not scale) then scale = 1 end

		target:_SetScale(scale)
		target:_SetPoint(point, parentName, point, x, y)

		local backdrop = backdropPool[target]
		if(backdrop) then
			backdrop:ClearAllPoints()
			backdrop:SetAllPoints(target)
		end

		-- We don't need this anymore
		_DB.__INITIAL[style][identifier] = nil
		if(not next(_DB.__INITIAL[style])) then
			_DB[style] = nil
		end
	end
end

local function restorePosition(obj)
	if(InCombatLockdown()) then return end
	local style, identifier, isHeader = getObjectInformation(obj)
	-- We've not saved any custom position for this style.
	if(not _DB[style] or not _DB[style][identifier]) then return end

	local target = isHeader or obj
	if(not target._SetPoint) then
		target._SetPoint = target.SetPoint
		target.SetPoint = restorePosition
		target._SetScale = target.SetScale
		target.SetScale = restorePosition
	end
	target:ClearAllPoints()

	-- damn it Blizzard, _how_ did you manage to get the input of this function
	-- reversed. Any sane person would implement this as: split(str, dlm, lim);
	local point, parentName, x, y, scale = string.split('\031', _DB[style][identifier])
	if(not scale) then
		scale = 1
	end

	if(scale) then
		target:_SetScale(scale)
	else
		scale = target:GetScale()
	end
	target:_SetPoint(point, parentName, point, x / scale, y / scale)
end

local restoreCustomPosition = function(style, ident)
	for _, obj in next, oUF.objects do
		local objStyle, objIdent = getObjectInformation(obj)
		if(objStyle == style and objIdent == ident) then
			return restorePosition(obj)
		end
	end
end

local saveDefaultPosition = function(obj)
	local style, identifier, isHeader = getObjectInformation(obj)
	if(not _DB.__INITIAL) then
		_DB.__INITIAL = {}
	end

	if(not _DB.__INITIAL[style]) then
		_DB.__INITIAL[style] = {}
	end

	if(not _DB.__INITIAL[style][identifier]) then
		local point
		if(isHeader) then
			point = getPoint(isHeader)
		else
			point = getPoint(obj)
		end

		_DB.__INITIAL[style][identifier] = point
	end
end

local savePosition = function(obj, anchor)
	local style, identifier, isHeader = getObjectInformation(obj)
	if(not _DB[style]) then _DB[style] = {} end

	_DB[style][identifier] = getPoint(isHeader or obj, anchor)
end

local saveCustomPosition = function(style, ident, point, x, y, scale)
	-- Shouldn't really be the case, but you never know!
	if(not _DB[style]) then _DB[style] = {} end

	_DB[style][ident] = string.format(
		'%s\031%s\031%d\031%d\031\%.3f',
		point, 'UIParent', x,  y, scale
	)
end

-- Attempt to figure out a more sane name to dispaly.
local smartName
do
	local nameCache = {}
	local validNames = {
		'player',
		'target',
		'focus',
		'raid',
		'pet',
		'party',
		'maintank',
		'mainassist',
		'arena',
	}

	local rewrite = {
		mt = 'maintank',
		mtt = 'maintanktarget',

		ma = 'mainassist',
		mat = 'mainassisttarget',
	}

	local validName = function(smartName)
		-- Not really a valid name, but we'll accept it for simplicities sake.
		if(tonumber(smartName)) then
			return smartName
		end

		if(type(smartName) == 'string') then
			-- strip away trailing s from pets, but don't touch boss/focus.
			smartName = smartName:gsub('([^us])s$', '%1')

			if(rewrite[smartName]) then
				return rewrite[smartName]
			end

			for _, v in next, validNames do
				if(v == smartName) then
					return smartName
				end
			end

			if(
				smartName:match'^party%d?$' or
				smartName:match'^arena%d?$' or
				smartName:match'^boss%d?$' or
				smartName:match'^partypet%d?$' or
				smartName:match'^raid%d?%d?$' or
				smartName:match'%w+target$' or
				smartName:match'%w+pet$'
				) then
				return smartName
			end
		end
	end

	local function guessName(...)
		local name = validName(select(1, ...))

		local n = select('#', ...)
		if(n > 1) then
			for i=2, n do
				local inp = validName(select(i, ...))
				if(inp) then
					name = (name or '') .. inp
				end
			end
		end

		return name
	end

	local smartString = function(name)
		if(nameCache[name]) then
			return nameCache[name]
		end

		-- Here comes the substitute train!
		local n = name
			:gsub('ToT', 'targettarget')
			:gsub('(%l)(%u)', '%1_%2')
			:gsub('([%l%u])(%d)', '%1_%2_')
			:gsub('Main_', 'Main')
			:lower()

		n = guessName(string.split('_', n))
		if(n) then
			nameCache[name] = n
			return n
		end

		return name
	end

	smartName = function(obj, header)
		if(type(obj) == 'string') then
			return smartString(obj)
		elseif(header) then
			return smartString(header:GetName())
		else
			local name = obj:GetName()
			if(name) then
				return smartString(name)
			end

			return obj.unit or '<unknown>'
		end
	end
end

do
	local frame = CreateFrame"Frame"
	frame:SetScript("OnEvent", function(self, event)
		return self[event](self)
	end)

	function frame:VARIABLES_LOADED()
		-- I honestly don't trust the load order of SVs.
		_DB = _G[_DBNAME] or {}
		_G[_DBNAME] = _DB
		-- Got to catch them all!
		for _, obj in next, oUF.objects do
			restorePosition(obj)
		end

		-- Clean up the defaults DB:
		if(_DB.__INITIAL) then
			for layout, frames in next, _DB.__INITIAL do
				if(not _DB[layout])  then
					_DB.__INITIAL[layout] = nil
				else
					for frame in next, frames do
						if(not _DB[layout][frame]) then
							_DB.__INITIAL[layout][frame] = nil
						end
					end
				end
			end
		end

		oUF:RegisterInitCallback(restorePosition)
		self:UnregisterEvent"VARIABLES_LOADED"
	end
	frame:RegisterEvent"VARIABLES_LOADED"

	function frame:PLAYER_REGEN_DISABLED()
		if(_LOCK) then
			print("Anchors hidden due to combat.")
			for k, bdrop in next, backdropPool do
				bdrop:Hide()
			end
			_LOCK = nil
		end
	end
	frame:RegisterEvent"PLAYER_REGEN_DISABLED"
end

local getBackdrop
do
	local OnShow = function(self)
		return self.name:SetText(smartName(self.obj, self.header))
	end

	local OnHide = function(self)
		if(self.dirtyMinHeight) then
			self:SetAttribute('minHeight', nil)
		end

		if(self.dirtyMinWidth) then
			self:SetAttribute('minWidth', nil)
		end
	end

	local OnDragStart = function(self)
		saveDefaultPosition(self.obj)
		self:StartMoving()

		local frame = self.header or self.obj
		frame:ClearAllPoints();
		frame:SetAllPoints(self);
	end

	local OnDragStop = function(self)
		self:StopMovingOrSizing()
		savePosition(self.obj, self)

		-- Restore the initial anchoring, so the anchor follows the frame when we
		-- edit positions through the UI.
		restorePosition(self.obj)
		self:ClearAllPoints()
		self:SetAllPoints(self.header or self.obj)
	end

	local OnMouseDown = function(self)
		local anchor = self:GetParent()
		saveDefaultPosition(anchor.obj)
		anchor:StartSizing('BOTTOMRIGHT')

		local frame = anchor.header or anchor.obj
		frame:ClearAllPoints()
		frame:SetAllPoints(anchor)

		self:SetButtonState("PUSHED", true)
	end

	local OnMouseUp = function(self)
		local anchor = self:GetParent()
		self:SetButtonState("NORMAL", false)

		anchor:StopMovingOrSizing()
		savePosition(anchor.obj, anchor)
	end

	local OnSizeChanged = function(self, width, height)
		local baseWidth, baseHeight = self.baseWidth, self.baseHeight

		local scale = width / baseWidth

		-- This is damn tiny!
		if(scale <= .3) then
			scale = .3
		end

		self:SetSize(scale * baseWidth, scale * baseHeight)
		local target = self. target;
		(target._SetScale or target.SetScale) (target, scale)
	end

	getBackdrop = function(obj, isHeader)
		local target = isHeader or obj
		if(not target:GetCenter()) then return end
		if(backdropPool[target]) then return backdropPool[target] end

		local backdrop = CreateFrame"Frame"
		backdrop:SetParent(UIParent)
		backdrop:Hide()

		backdrop:SetBackdrop(_BACKDROP)
		backdrop:SetFrameStrata"TOOLTIP"
		backdrop:SetAllPoints(target)

		backdrop:EnableMouse(true)
		backdrop:SetMovable(true)
		backdrop:SetResizable(true)
		backdrop:RegisterForDrag"LeftButton"

		local name = backdrop:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		name:SetPoint"CENTER"
		name:SetJustifyH"CENTER"
		name:SetFont(GameFontNormal:GetFont(), 12)
		name:SetTextColor(1, 1, 1)

		local scale = CreateFrame('Button', nil, backdrop)
		scale:SetPoint'BOTTOMRIGHT'
		scale:SetSize(16, 16)

		scale:SetNormalTexture[[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]]
		scale:SetHighlightTexture[[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight]]
		scale:SetPushedTexture[[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Down]]

		scale:SetScript('OnMouseDown', OnMouseDown)
		scale:SetScript('OnMouseUp', OnMouseUp)

		backdrop.name = name
		backdrop.obj = obj
		backdrop.header = isHeader
		backdrop.target = target

		backdrop:SetBackdropBorderColor(0, .9, 0)
		backdrop:SetBackdropColor(0, .9, 0)

		backdrop.baseWidth, backdrop.baseHeight = obj:GetSize()

		-- We have to define a minHeight on the header if it doesn't have one. The
		-- reason for this is that the header frame will have an height of 0.1 when
		-- it doesn't have any frames visible.
		if(
			isHeader and
			(
				not isHeader:GetAttribute'minHeight' and math.floor(isHeader:GetHeight()) == 0 or
				not isHeader:GetAttribute'minWidth' and math.floor(isHeader:GetWidth()) == 0
			)
		) then
			isHeader:SetHeight(obj:GetHeight())
			isHeader:SetWidth(obj:GetWidth())

			if(not isHeader:GetAttribute'minHeight') then
				isHeader.dirtyMinHeight = true
				isHeader:SetAttribute('minHeight', obj:GetHeight())
			end

			if(not isHeader:GetAttribute'minWidth') then
				isHeader.dirtyMinWidth = true
				isHeader:SetAttribute('minWidth', obj:GetWidth())
			end
		elseif(isHeader) then
			backdrop.baseWidth, backdrop.baseHeight = isHeader:GetSize()
		end

		backdrop:SetScript("OnShow", OnShow)
		backdrop:SetScript('OnHide', OnHide)

		backdrop:SetScript("OnDragStart", OnDragStart)
		backdrop:SetScript("OnDragStop", OnDragStop)

		backdrop:SetScript('OnSizeChanged', OnSizeChanged)

		backdropPool[target] = backdrop

		return backdrop
	end
end

do
	local opt = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
	opt:Hide()

	opt.name = _TITLE
	opt:SetScript("OnShow", function(self)
		local title = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		title:SetPoint('TOPLEFT', 16, -16)
		title:SetText(_TITLE)

		local subtitle = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
		subtitle:SetHeight(40)
		subtitle:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -8)
		subtitle:SetPoint('RIGHT', self, -32, 0)
		subtitle:SetNonSpaceWrap(true)
		subtitle:SetWordWrap(true)
		subtitle:SetJustifyH'LEFT'
		subtitle:SetFormattedText('Type %s to toggle frame anchors.', _G['SLASH_' .. slashGlobal .. 1])

		local scroll = CreateFrame("ScrollFrame", nil, self)
		scroll:SetPoint('TOPLEFT', subtitle, 'BOTTOMLEFT', 0, -8)
		scroll:SetPoint("BOTTOMRIGHT", 0, 4)

		local scrollchild = CreateFrame("Frame", nil, self)
		scrollchild:SetPoint"LEFT"
		scrollchild:SetHeight(scroll:GetHeight())
		scrollchild:SetWidth(scroll:GetWidth())

		scroll:SetScrollChild(scrollchild)
		scroll:UpdateScrollChildRect()
		scroll:EnableMouseWheel(true)

		local slider = CreateFrame("Slider", nil, scroll)

		local backdrop = {
			bgFile = [[Interface\ChatFrame\ChatFrameBackground]], tile = true, tileSize = 16,
			edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		}

		local createOrUpdateMadnessOfGodIhateGUIs
		local OnClick = function(self)
			local row = self:GetParent()
			scroll.value = slider:GetValue()
			_DB[row.style][row.ident] = nil

			if(not next(_DB[row.style])) then
				_DB[row.style] = nil
			end

			restoreDefaultPosition(row.style, row.ident)

			return createOrUpdateMadnessOfGodIhateGUIs()
		end

		local OnEnter = function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetText(DELETE)
		end

		local handleInput = function(label)
			local text = label:GetText()
			if(text == '-' or text == '' or text == '.') then
				text = 0
			end

			local num = tonumber(text)
			if(label.hasPostfix and not num) then
				num = tonumber(text:sub(1,-2))
			end

			if(label.onlyAboveZero) then
				if(not (num > 0)) then
					return .01
				else
					return num
				end
			end

			return num or text
		end

		local saveRestorePosition = function(row)
			saveCustomPosition(
				row.style,
				row.ident,

				handleInput(row.pointLabel),
				handleInput(row.xLabel),
				handleInput(row.yLabel),
				handleInput(row.scaleLabel)
			)

			restoreCustomPosition(row.style, row.ident)
		end

		local createEditBox
		do
			local OnEscapePressed = function(self)
				self:SetText(self.oldText)
				self:ClearFocus()

				saveRestorePosition(self:GetParent())
			end

			local OnEnterPressed = function(self)
				local text = self:GetText()
				self:ClearFocus()

				saveRestorePosition(self:GetParent())
			end

			local OnEditFocusGained = function(self)
				self.oldText = self:GetText()

				if(self.hasPostfix) then
					self.oldText = self.oldText:sub(1, -2)
				end

				self:SetText(self.oldText)
				self.newText = nil
			end

			local OnEditFocusLost = function(self)
				local text = self:GetText()
				if(text == '-' or text == '' or text == '.') then
					if(self.onlyAboveZero) then
						text = 0.01
					else
						text = 0
					end
				end

				self:SetText(string.format(self.numFormat, text))

				self.newText = nil
				self.oldText = nil
			end

			local OnTextChanged = function(self, userInput)
				if(userInput) then
					self.newText = self:GetText()
					saveRestorePosition(self:GetParent())
				end
			end

			local OnChar = function(self, key)
				local text = self:GetText()
				if(
					not tonumber(text .. '0') or
					(not tonumber(key) and key ~= '-' and key ~= '.') or
					(self.onlyAboveZero and key == '-' and not (self:GetNumber() < 0))
				) then
					local pos = self:GetCursorPosition() - 1
					self:SetText(self.newText or self.oldText)
					self:SetCursorPosition(pos)
				end

				self.newText = self:GetText()
			end

			createEditBox = function(self)
				local editbox = CreateFrame('EditBox', nil, self)

				editbox:SetWidth(40)
				editbox:SetMaxLetters(5)
				editbox:SetAutoFocus(false)
				editbox:SetFontObject(GameFontHighlight)

				editbox:SetPoint('TOP', 0, -4)
				editbox:SetPoint('BOTTOM', 0, 0)

				local background = editbox:CreateTexture(nil, 'BACKGROUND')
				background:SetPoint('TOP', 0, -1)
				background:SetPoint'LEFT'
				background:SetPoint'RIGHT'
				background:SetPoint('BOTTOM', 0, 4)

				background:SetTexture(1, 1, 1, .05)

				editbox:SetScript('OnEscapePressed', OnEscapePressed)
				editbox:SetScript('OnEnterPressed', OnEnterPressed)
				editbox:SetScript('OnEditFocusGained', OnEditFocusGained)
				editbox:SetScript('OnEditFocusLost', OnEditFocusLost)
				editbox:SetScript('OnTextChanged', OnTextChanged)
				editbox:SetScript('OnChar', OnChar)

				return editbox
			end
		end

		function createOrUpdateMadnessOfGodIhateGUIs()
			local data = self.data or {}

			local slideHeight = 0
			local numStyles = 1
			for style, styleData in next, _DB do
				if(style ~= '__INITIAL') then
					if(not data[numStyles]) then
						local box = CreateFrame('Frame', nil, scrollchild)
						box:SetBackdrop(backdrop)
						box:SetBackdropColor(.1, .1, .1, .5)
						box:SetBackdropBorderColor(.3, .3, .3, 1)

						if(numStyles == 1) then
							box:SetPoint('TOP', 0, -12)
						else
							box:SetPoint('TOP', data[numStyles - 1], 'BOTTOM', 0, -16)
						end
						box:SetPoint'LEFT'
						box:SetPoint('RIGHT', -30, 0)

						local title = box:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
						title:SetPoint('BOTTOMLEFT', box, 'TOPLEFT', 8, 0)
						box.title = title

						if(numStyles == 1) then
							local scaleTitle = box:CreateFontString(nil, nil, 'GameFontHighlight')
							scaleTitle:SetPoint('BOTTOMRIGHT', box, 'TOPRIGHT', -35, 0)
							scaleTitle:SetWidth(40)
							scaleTitle:SetText'Scale'
							scaleTitle:SetJustifyH'CENTER'
							box.scaleTitle = scaleTitle

							local yTitle = box:CreateFontString(nil, nil, 'GameFontHighlight')
							yTitle:SetPoint('RIGHT', scaleTitle, 'LEFT', -5, 0)
							yTitle:SetWidth(40)
							yTitle:SetText'Y'
							yTitle:SetJustifyH'CENTER'
							box.yTitle = yTitle

							local xTitle = box:CreateFontString(nil, nil, 'GameFontHighlight')
							xTitle:SetPoint('RIGHT', yTitle, 'LEFT', -5, 0)
							xTitle:SetWidth(40)
							xTitle:SetText'X'
							xTitle:SetJustifyH'CENTER'
							box.xTitle = xTitle
						end

						data[numStyles] = box
					end

					-- Fetch the box and update it
					local box = data[numStyles]
					box.title:SetText(style)

					local rows = box.rows or {}
					local numFrames = 1
					for unit, points in next, styleData do
						if(not rows[numFrames]) then
							local row = CreateFrame('Button', nil, box)

							row:SetBackdrop(backdrop)
							row:SetBackdropBorderColor(.3, .3, .3)
							row:SetBackdropColor(.1, .1, .1, .5)

							if(numFrames == 1) then
								row:SetPoint('TOP', 0, -8)
							else
								row:SetPoint('TOP', rows[numFrames-1], 'BOTTOM')
							end

							row:SetPoint('LEFT', 6, 0)
							row:SetPoint('RIGHT', -25, 0)
							row:SetHeight(24)

							-- Notice how these are anchored right to left. Initially when I
							-- implemented these, I swapped X and Y positioning. It was really
							-- fun to debug!
							local scaleLabel = createEditBox(row)
							scaleLabel:SetPoint('RIGHT', -10, 0)
							scaleLabel:SetJustifyH'CENTER'

							scaleLabel.hasPostfix = true
							scaleLabel.onlyAboveZero = true
							scaleLabel.numFormat = '%.2fx'

							row.scaleLabel = scaleLabel

							local yLabel = createEditBox(row)
							yLabel:SetPoint('RIGHT', scaleLabel, 'LEFT', -5, 0)
							yLabel:SetJustifyH'CENTER'

							yLabel.numFormat = '%d'
							row.yLabel = yLabel

							local xLabel = createEditBox(row)
							xLabel:SetPoint('RIGHT', yLabel, 'LEFT', -5, 0)
							xLabel:SetJustifyH'CENTER'

							xLabel.numFormat = '%d'
							row.xLabel = xLabel

							local pointLabel = row:CreateFontString(nil, nil, 'GameFontHighlight')
							pointLabel:SetPoint('RIGHT', xLabel, 'LEFT', -5, 0)
							pointLabel:SetJustifyH'CENTER'
							pointLabel:SetText'BOTTOMRIGHT'
							pointLabel:SetWidth(pointLabel:GetWidth())
							row.pointLabel = pointLabel

							local unitLabel= row:CreateFontString(nil, nil, 'GameFontHighlight')
							unitLabel:SetPoint('LEFT', 10, 0)
							unitLabel:SetPoint('TOP', 0, -4)
							unitLabel:SetPoint'BOTTOM'
							unitLabel:SetJustifyH'LEFT'
							row.unitLabel = unitLabel

							local delete = CreateFrame("Button", nil, row)
							delete:SetWidth(16)
							delete:SetHeight(16)
							delete:SetPoint('LEFT', row, 'RIGHT')

							delete:SetNormalTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Up]]
							delete:SetPushedTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Down]]
							delete:SetHighlightTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]]

							delete:SetScript("OnClick", OnClick)
							delete:SetScript("OnEnter", OnEnter)
							delete:SetScript("OnLeave", GameTooltip_Hide)
							row.delete = delete

							rows[numFrames] = row
						end

						-- Fetch row and update it:
						local row = rows[numFrames]
						local point, _, x, y, s = string.split('\031', points)
						row.scaleLabel:SetText(string.format('%.2fx', s or 1))
						row.xLabel:SetText(x)
						row.yLabel:SetText(y)
						row.pointLabel:SetText(point)
						row.unitLabel:SetText(smartName(unit))

						row.style = style
						row.ident = unit
						row:Show()

						numFrames = numFrames + 1
					end

					box.rows = rows

					local height = (numFrames * 24) - 8
					slideHeight = slideHeight + height + 16
					box:SetHeight(height)
					box:Show()

					-- Hide left over rows we aren't using:
					while(rows[numFrames]) do
						rows[numFrames]:Hide()
						numFrames = numFrames + 1
					end

					numStyles = numStyles + 1
				end
			end

			-- Hide left over boxes we aren't using:
			while(data[numStyles]) do
				data[numStyles]:Hide()
				numStyles = numStyles + 1
			end

			self.data = data
			local height = slideHeight - scroll:GetHeight()
			if(height > 0) then
				slider:SetMinMaxValues(0, height)
			else
				slider:SetMinMaxValues(0, 0)
			end

			slider:SetValue(scroll.value or 0)
		end

		slider:SetWidth(16)

		slider:SetPoint("TOPRIGHT", -8, -24)
		slider:SetPoint("BOTTOMRIGHT", -8, 24)

		local up = CreateFrame("Button", nil, slider)
		up:SetPoint("BOTTOM", slider, "TOP")
		up:SetWidth(16)
		up:SetHeight(16)
		up:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
		up:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
		up:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled")
		up:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight")

		up:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
		up:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
		up:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
		up:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
		up:GetHighlightTexture():SetBlendMode("ADD")

		up:SetScript("OnClick", function(self)
			local box = self:GetParent()
			box:SetValue(box:GetValue() - box:GetHeight()/2)
		end)

		local down = CreateFrame("Button", nil, slider)
		down:SetPoint("TOP", slider, "BOTTOM")
		down:SetWidth(16)
		down:SetHeight(16)
		down:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
		down:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
		down:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
		down:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight")

		down:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
		down:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
		down:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
		down:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
		down:GetHighlightTexture():SetBlendMode("ADD")

		down:SetScript("OnClick", function(self)
			local box = self:GetParent()
			box:SetValue(box:GetValue() + box:GetHeight()/2)
		end)

		slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		local thumb = slider:GetThumbTexture()
		thumb:SetWidth(16)
		thumb:SetHeight(24)
		thumb:SetTexCoord(1/4, 3/4, 1/8, 7/8)

		slider:SetScript("OnValueChanged", function(self, val, ...)
			local min, max = self:GetMinMaxValues()
			if(val == min) then up:Disable() else up:Enable() end
			if(val == max) then down:Disable() else down:Enable() end

			scroll.value = val
			scroll:SetVerticalScroll(val)
			scrollchild:SetPoint('TOP', 0, val)
		end)

		opt:SetScript("OnShow", function()
			return createOrUpdateMadnessOfGodIhateGUIs()
		end)

		return createOrUpdateMadnessOfGodIhateGUIs()
	end)

	InterfaceOptions_AddCategory(opt)
end

local slashList = GetAddOnMetadata(_NAME, 'X-SlashCmdList'):gsub('%s+', '')
local handleCmds = function(...)
	for i=1, select('#', ...) do
		local cmd = select(i, ...)
		_G['SLASH_' ..slashGlobal .. i] = cmd
	end
end
handleCmds(string.split(',', slashList))

SlashCmdList[slashGlobal] = function(inp)
	if(InCombatLockdown()) then
		return print"Frames cannot be moved while in combat. Bailing out."
	end

	if(inp:match("%S+")) then
		InterfaceOptionsFrame_OpenToCategory(_TITLE)
	else
		if(not _LOCK) then
			for k, obj in next, oUF.objects do
				local style, identifier, isHeader = getObjectInformation(obj)
				local backdrop = getBackdrop(obj, isHeader)
				if(backdrop) then backdrop:Show() end
			end

			_LOCK = true
		else
			for k, bdrop in next, backdropPool do
				bdrop:Hide()
			end

			_LOCK = nil
		end
	end
end
-- It's not in your best interest to disconnect me. Someone could get hurt.

local PlayerService = cloneref(game:GetService("Players"))
local LocalPlayer = PlayerService.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local GuiService = cloneref(game:GetService("GuiService"))

local Colors = {
	info = Color3.new(0.180392, 0.235294, 1),
	success = Color3.new(0.160784, 1, 0.258824),
	warning = Color3.new(1, 0.87451, 0.152941),
	error = Color3.new(1, 0.129412, 0.129412),
	fatal = Color3.new(0.0823529, 0.0823529, 0.0823529),
	unidentified = Color3.new(0.85098, 0.85098, 0.85098),
}

local DisplayImportance = {
	Lowest = -2147483648,
	Minimum = -10,
	Base = 10,
	High = 1000,
	Higher = 5000,
	Max = 2147483647
}

local notificationsystem = {}

local function CreateNewNotificationObject(name)
	local theme = getgenv().UiLibVariables.CoreConfiguration.ui.Theme
	
	local NotificationBase = Instance.new("Frame")
	local Identifier = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UICorner_2 = Instance.new("UICorner")
	local Message = Instance.new("TextLabel")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	NotificationBase.Name = name
	NotificationBase.Visible = false
	NotificationBase.Parent = getgenv().UiLibVariables.NotificationSystem.ChangingObjects["notification_scroll_frame"]
	NotificationBase.BackgroundColor3 = theme.Background
	NotificationBase.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NotificationBase.BorderSizePixel = 0
	NotificationBase.Position = UDim2.new(0.300730735, 0, 0.344036698, 0)
	NotificationBase.Size = UDim2.new(1, 0, 0.15, 0)

	Identifier.Name = "Identifier"
	Identifier.Parent = NotificationBase
	Identifier.BackgroundColor3 = Color3.fromRGB(216, 216, 216)
	Identifier.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Identifier.BorderSizePixel = 0
	Identifier.Position = UDim2.new(0.0270000007, 0, 0.860000014, 0)
	Identifier.Size = UDim2.new(0.944999993, 0, 0.0666666701, 0)

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Identifier

	UICorner_2.CornerRadius = UDim.new(0.100000001, 0)
	UICorner_2.Parent = NotificationBase

	Message.Name = "Message"
	Message.Parent = NotificationBase
	Message.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Message.BackgroundTransparency = 1.000
	Message.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Message.BorderSizePixel = 0
	Message.Position = UDim2.new(0.0270001218, 0, 0.100000001, 0)
	Message.Size = UDim2.new(0.944999874, 0, 0.699999988, 0)
	Message.Font = Enum.Font.Ubuntu
	Message.Text = "scary placeholder"
	Message.TextColor3 = theme.Text
	Message.TextSize = 18.0000
	Message.TextWrapped = true
	Message.TextXAlignment = Enum.TextXAlignment.Left
	Message.TextYAlignment = Enum.TextYAlignment.Top

	UIAspectRatioConstraint.Parent = NotificationBase
	UIAspectRatioConstraint.AspectRatio = 6.666
	
	return NotificationBase
end

notificationsystem.NotificationObjects = {}
notificationsystem.CurrentCounter = DisplayImportance["Max"]
notificationsystem.NotificationCounter = 1

function notificationsystem:Initialize()
	local success, returned = pcall(function()
		return getgenv().UiLibVariables.CoreConfiguration.notifications
	end)
	
	if not success then return returned end
	
	local notifconfig = returned
	
	local max, fade, timebeforefade, fadetime = notifconfig.Maximum, notifconfig.Fade, notifconfig.BaseTimeBeforeFade, notifconfig.FadeTime
	
	if not max or fade == nil or not timebeforefade or not fadetime then return "Incomplete notfication configuration." end
	
	self.TimeFade = fadetime
	self.Fade = fade
	self.TimeBeforeFade = timebeforefade
	self.Max = max
	
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

	ScrollingFrame.Parent = getgenv().UiLibVariables.MainScreenGui
	ScrollingFrame.Active = true
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0.775154591, 0, 0, 0)
	ScrollingFrame.Size = UDim2.new(0.224845424, 0, 0.998853207, 0)
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.ScrollBarThickness = 6
	ScrollingFrame.Active = false

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0.0025, 0)
	
	UIAspectRatioConstraint.Parent = ScrollingFrame
	UIAspectRatioConstraint.AspectRatio = 0.459
	UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
	
	getgenv().UiLibVariables.NotificationSystem.ChangingObjects["notification_scroll_frame"] = ScrollingFrame
	
	for i = 1, max do
		table.insert(self.NotificationObjects, CreateNewNotificationObject("Notification"..i))
	end
end

function notificationsystem:SendNotification(text, notiftype, waittime)
	if not waittime then waittime = self.TimeBeforeFade end
	if not notiftype then notiftype = "unidentified" end
	if not text then return end
	
	local order = self.CurrentCounter
	self.CurrentCounter -= 1
	
	local object : Frame = self.NotificationObjects[self.NotificationCounter]
	
	self.NotificationCounter += 1
	
	if self.NotificationCounter > self.Max then
		self.NotificationCounter = 1
	end
	
	object.LayoutOrder = order
	object.Visible = true
	object.Message.Text = text
	object.Identifier.BackgroundColor3 = Colors[notiftype:lower()]
	
	task.spawn(function()
		task.wait(waittime)
		
		if object.LayoutOrder == order then
			if self.TimeFade then
				local tinfo = TweenInfo.new(self.TimeFade, Enum.EasingStyle.Linear)
				local t= TweenService:Create(object, tinfo, {BackgroundTransparency = 1})
				TweenService:Create(object.Identifier, tinfo, {BackgroundTransparency = 1}):Play()
				TweenService:Create(object.Message, tinfo, {TextTransparency = 1}):Play()
				
				t:Play()
				local c; c= object:GetPropertyChangedSignal("LayoutOrder"):Connect(function()
					t:Cancel()
					object.BackgroundTransparency = 0
					object.Identifier.BackgroundTransparency = 0
					object.Message.TextTransparency = 0
					
					c:Disconnect()
				end)
				
				t.Completed:Wait()
				
				if c.Connected then
					object.Visible = false
					
					object.BackgroundTransparency = 0
					object.Identifier.BackgroundTransparency = 0
					object.Message.TextTransparency = 0
					
					c:Disconnect()
				end
			else
				object.Visible = false
			end
		end
	end)
end

local uimoduletable = {}

local function GetMouseScreenPos()
	local loc = UserInputService:GetMouseLocation()
	local inset = GuiService:GetGuiInset()
	return Vector2.new(loc.X - inset.X, loc.Y - inset.Y)
end

local function GetMouseUDim2()
	local p = GetMouseScreenPos()
	return UDim2.fromOffset(p.X, p.Y)
end

local function StartDragDetection(frame, fused_objects)
	if typeof(frame) ~= "Instance" then return end
	if getgenv().UiLibVariables.Drags[frame.Name] then return end

	local Outliner = Instance.new("Frame", getgenv().UiLibVariables.MainScreenGui)
	Outliner.BackgroundTransparency = 1
	Outliner.Size = frame.Size
	Outliner.ZIndex = DisplayImportance["Max"]
	Outliner.Name = "LibraryDragOutliner_"..frame.Name
	Outliner.Visible = false
	local uistroke = Instance.new("UIStroke", Outliner)
	uistroke.Color = Color3.fromRGB(255,255,255)
	uistroke.Thickness = 2

	getgenv().UiLibVariables.Drags[frame.Name] = {
		Dragging = false,
		CurrentlyDraggedOnPosition = UDim2.new(0,0,0,0),
		MoveConnection = nil,
		MouseUDim2Offset = UDim2.fromOffset(0,0),
	}

	frame.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		local screenpos = UserInputService:GetMouseLocation()
		local inset = GuiService:GetGuiInset()
		local qx, qy = screenpos.X - inset.X, screenpos.Y - inset.Y

		local stack = LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(qx, qy)
		local TopObject = stack[1]

		local isValid = TopObject == frame or (fused_objects and table.find(fused_objects, TopObject))
		if not isValid then return end

		getgenv().UiLibVariables.Drags[frame.Name].Dragging = true	
		local offset = frame.Position - GetMouseUDim2()
		getgenv().UiLibVariables.Drags[frame.Name]["MouseUDim2Offset"] = offset
		getgenv().UiLibVariables.Drags[frame.Name]["CurrentlyDraggedOnPosition"] = GetMouseUDim2()
		Outliner.Position = GetMouseUDim2() + offset
		Outliner.Visible = true

		getgenv().UiLibVariables.Drags[frame.Name]["MoveConnection"] = Mouse.Move:Connect(function()
			local pos = GetMouseUDim2()
			getgenv().UiLibVariables.Drags[frame.Name]["CurrentlyDraggedOnPosition"] = pos
			Outliner.Position = pos + offset
		end)
	end)

	Mouse.Button1Up:Connect(function()
		if getgenv().UiLibVariables.Drags[frame.Name].Dragging then

			local current = getgenv().UiLibVariables.Drags[frame.Name]
			current.MoveConnection:Disconnect()
			Outliner.Visible = false

			frame.Position = current.CurrentlyDraggedOnPosition + current.MouseUDim2Offset

			getgenv().UiLibVariables.Drags[frame.Name] = {
				Dragging = false,
				CurrentlyDraggedOnPosition = UDim2.new(0,0,0,0),
				MoveConnection = nil,
				MouseUDim2Offset = UDim2.fromOffset(0,0),
			}
		end
	end)
end

function uimoduletable:Notify(...)
	notificationsystem:SendNotification(...)
end

local UIHandler = {}
UIHandler.Count = 0

function UIHandler:AddInputOpeningToFrame(frame, keycode : Enum.KeyCode)
	if not keycode then keycode = self.DefaultKey end
	
	if not getgenv().UiLibVariables.KeyOpenings then
		getgenv().UiLibVariables.KeyOpenings = {}
		getgenv().UiLibVariables.KeyOpenings[frame] = keycode
	else
		getgenv().UiLibVariables.KeyOpenings[frame] = keycode
	end
end

local function RebuildBinds()
	local formed = {}
	for _, handler in getgenv().UiLibVariables.Handlers do
		local h = handler:GetHandler()
		for id, payload in h.funcids do
			formed[id] = {
				KeyCode = payload[1],
				Function = payload[2],
				Object = h.ids[id],
			}
		end
	end
	getgenv().BindToFunction = formed
end

function UIHandler:NewFrame(FrameSize, FrameFirstPosition)
	local newframehandler = {
		ids = {},
		funcids = {}
	}
	
	local succ, ret = pcall(function()

		if not FrameFirstPosition then FrameFirstPosition = UDim2.new(0,0,0,0) end
		if not FrameSize then FrameSize = UDim2.new(0.1,0,0.1,0) end

		local newframe = Instance.new("Frame", getgenv().UiLibVariables.MainScreenGui)

		local theme = getgenv().UiLibVariables.CoreConfiguration.ui.Theme

		newframe.Name = "NewLibraryFrame"..self.Count
		self.Count += 1
		newframe.Size = FrameSize
		newframe.Position = FrameFirstPosition
		newframe.BackgroundColor3 = theme.DarkBackground
		Instance.new("UIStroke", newframe).Color = theme.Outline
		
		local titlelabel = Instance.new("TextLabel", newframe)
		titlelabel.TextScaled = true
		titlelabel.RichText = true
		titlelabel.Text = "New Frame"
		titlelabel.Size = UDim2.new(1,0,0.1,0)
		titlelabel.Font = Enum.Font.Ubuntu
		titlelabel.TextColor3 = theme.Text
		titlelabel.BackgroundColor3 = theme.Background
		titlelabel.BorderSizePixel = 0
		
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")

		ScrollingFrame.Parent = newframe
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.BackgroundTransparency = 1.000
		ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0,0,0.1,0)
		ScrollingFrame.Size = UDim2.new(1,0,0.9,0)
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		ScrollingFrame.ScrollBarThickness = 6
		ScrollingFrame.Active = false

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0.00749999983, 0)
		
		StartDragDetection(newframe, {titlelabel, ScrollingFrame})
		
		return {
			frame = newframe,
			title = titlelabel,
			scroll = ScrollingFrame,
			["theme"] = theme,
		}
	end)
	
	function newframehandler:GetHandler()
		return newframehandler
	end
	
	table.insert(getgenv().UiLibVariables.Handlers, newframehandler)
	
	function newframehandler:SetTitle(text : string, scale_dimensions : Vector2)
		local title = ret.title
		
		if text then
			title.Text = text
		end
		
		if scale_dimensions then
			title.Size = UDim2.new(scale_dimensions.X, 0, scale_dimensions.Y, 0)
			
			local ynum = 1 - scale_dimensions.Y
			ret.scroll.Size = UDim2.new(1,0,ynum,0)
			ret.scroll.Position = UDim2.new(0,0,scale_dimensions.Y,0)
		end
	end
	
	newframehandler.ElementCount = DisplayImportance["Lowest"]
	
	function newframehandler:AddText(text : string, id : string, XAlignment : Enum.TextXAlignment)
		if not text then return end
		if not XAlignment then XAlignment = Enum.TextXAlignment.Left end
		if not id then uimoduletable:Notify("Id wasn't passed. Element will not be controllable.", "warning") end
		if self.ids[id] then uimoduletable:Notify("Id "..id.." already exists!", "error") return end
		
		local textlabel = Instance.new("TextLabel", ret.scroll)
		textlabel.TextScaled = true
		textlabel.Text = text
		textlabel.Size = UDim2.new(1,0,0.035,0)
		textlabel.Font = Enum.Font.Ubuntu
		textlabel.TextColor3 = ret.theme.Text
		textlabel.BackgroundTransparency = 1
		textlabel.BorderSizePixel = 0
		textlabel.LayoutOrder = self.ElementCount
		textlabel.TextXAlignment = XAlignment
		self.ElementCount += 1

		if id then
			self.ids[id] = textlabel
		end
	end
	
	function newframehandler:AddDivider(id : string)
		if not id then uimoduletable:Notify("Id wasn't passed. Element will not be controllable.", "warning") end
		if self.ids[id] then uimoduletable:Notify("Id "..id.." already exists!", "error") return end
		
		local frame = Instance.new("Frame", ret.scroll)
		frame.Size = UDim2.new(1,0,0.035,0)
		frame.BackgroundTransparency = 1
		
		local divider = Instance.new("Frame", frame)
		divider.Size = UDim2.new(1,0,0.05,0)
		divider.Position = UDim2.new(0,0,0.475,0)
		
		local gradient = Instance.new("UIGradient", divider)
		gradient.Color = ret.theme.DividerColor
		gradient.Transparency = ret.theme.DividerTransparency
		
		frame.LayoutOrder = self.ElementCount
		self.ElementCount += 1
		
		if id then
			self.ids[id] = divider
		end
	end
	
	function newframehandler:AddButton(id : string, event_function, optional_text : string, optional_xalignment : Enum.TextXAlignment)
		if not id then uimoduletable:Notify("Id wasn't passed. Element will not be controllable.", "warning") end
		if not event_function then uimoduletable:Notify("No function passed to button! Button won't do anything.", "warning") end
		if self.ids[id] then uimoduletable:Notify("Id "..id.." already exists!", "error") return end
		if not optional_text then optional_text = "" end
		if not optional_xalignment then optional_xalignment = Enum.TextXAlignment.Center end
		
		local button = Instance.new("TextButton", ret.scroll)
		button.Text = optional_text
		button.TextScaled = true
		button.TextXAlignment = optional_xalignment
		button.Font = Enum.Font.Ubuntu
		button.Size = UDim2.new(1,0,0.035,0)
		button.BackgroundColor3 = ret.theme.Background
		button.TextColor3 = ret.theme.Text
		button.BorderSizePixel = 0
		
		if event_function then
			button.Activated:Connect(event_function)
		end
		
		button.LayoutOrder = self.ElementCount
		self.ElementCount += 1
		
		if id then
			self.ids[id] = button
		end
	end
	
	if succ then
		uimoduletable:Notify("New frame added successfully.", "success")
		newframehandler.Frame = ret.frame
	else
		uimoduletable:Notify(ret, "error")
		return
	end
	
	function newframehandler:AddKeybindToId(id : string)
		if not id then uimoduletable:Notify("Id wasn't passed to addkeybindtoid. Pass an id to use it!", "error") return end
		if not self.ids[id] then uimoduletable:Notify("Couldn't find id "..id..". Pass a valid id to use keybinds!", "error") return end
		if not self.ids[id]:HasTag("Keybindable") then uimoduletable:Notify("Id isn't a keybind frame!", "error") return end
		if self.ids[id].Keybind.Visible then uimoduletable:Notify("Element already has a keybind!", "error") return end
		
		local kb = self.ids[id].Keybind
		
		kb.Visible = true
		
		kb.Activated:Connect(function()
			kb.Text = "[...]"
			
			task.wait(0.05)
			
			local c; c = UserInputService.InputBegan:Connect(function(inp, gp)
				if not gp and inp.UserInputType == Enum.UserInputType.Keyboard then
					if inp.KeyCode == Enum.KeyCode.Escape then
						kb.Text = "[None]"
						
						self.funcids[id][1] = Enum.KeyCode.None
					else
						kb.Text = `[{inp.KeyCode.Name}]`
						
						self.funcids[id][1] = inp.KeyCode
					end
					c:Disconnect()
					RebuildBinds()
				end
			end)
		end)
	end
	
	function newframehandler:AddToggle(id : string, event_function, optional_text : string, optional_xalignment : Enum.TextXAlignment)
		if not id then uimoduletable:Notify("Id wasn't passed! Toggles need ids.", "error") return end
		if not event_function then uimoduletable:Notify("No function was passed! Toggles need functions.", "error") return end
		if self.ids[id] then uimoduletable:Notify("Id "..id.." already exists!", "error") return end
		if not optional_text then optional_text = "Toggle" end
		if not optional_xalignment then optional_xalignment = Enum.TextXAlignment.Left end
		
		self.funcids[id] = {
			Enum.KeyCode.None, event_function
		}
		
		local frame = Instance.new("Frame", ret.scroll)
		frame.Size = UDim2.new(1,0,0.035,0)
		frame.BackgroundTransparency = 1
		frame:AddTag("Keybindable")
		frame:SetAttribute("ToggleState", false)
		
		local outertoggle = Instance.new("Frame", frame)
		outertoggle.Size = UDim2.new(0.15,0,1,0)
		outertoggle.BackgroundColor3 = ret.theme.Background
		outertoggle.BorderSizePixel = 0
		outertoggle.Name = "Toggle"
		
		local innertoggle = Instance.new("TextButton", outertoggle)
		innertoggle.Size = UDim2.new(0.5,0,1,0)
		innertoggle.BackgroundColor3 = ret.theme.LightBackground
		innertoggle.Text = ""
		innertoggle.BorderSizePixel = 0
		innertoggle.Name = "Toggle"
	
		innertoggle.Activated:Connect(function()
			local toggled = not frame:GetAttribute("ToggleState")
			frame:SetAttribute("ToggleState", toggled)
			
			task.spawn(function()
				event_function(toggled)
			end)
			
			if toggled then
				innertoggle.Position = UDim2.new(0.5,0,0,0)
			else
				innertoggle.Position = UDim2.new(0,0,0,0)
			end
		end)
		
		local textlabel = Instance.new("TextLabel", frame)
		textlabel.Text = optional_text
		textlabel.TextScaled = true
		textlabel.TextXAlignment = optional_xalignment
		textlabel.Font = Enum.Font.Ubuntu
		textlabel.Size = UDim2.new(0.3,0,1,0)
		textlabel.Position = UDim2.new(0.25,0,0,0)
		textlabel.BackgroundTransparency = 1
		textlabel.TextColor3 = ret.theme.Text
		textlabel.BorderSizePixel = 0
		
		local kbbutton = Instance.new("TextButton", frame)
		kbbutton.Size = UDim2.new(0.2,0,1,0)
		kbbutton.Position = UDim2.new(0.8,0,0,0)
		kbbutton.BackgroundColor3 = ret.theme.LightBackground
		kbbutton.Text = "[None]"
		kbbutton.BorderSizePixel = 0
		kbbutton.TextColor3 = ret.theme.Text
		kbbutton.TextXAlignment = Enum.TextXAlignment.Center
		kbbutton.Visible = false
		kbbutton.Name = "Keybind"

		frame.LayoutOrder = self.ElementCount
		self.ElementCount += 1
		
		if id then
			self.ids[id] = frame
			RebuildBinds()
		end
	end
	
	return newframehandler
end

function uimoduletable:Initialize(PassedCoreConfiguration)
	if getgenv().UiLibVariables then
		getgenv().UiLibVariables.NotificationSystem.CoreSystem:SendNotification("Library already loaded. Press inspect.", "info")
		return
	end
	
	local ScreenGui = Instance.new("ScreenGui", gethui()) 
	ScreenGui.Name = "GenericUiLibrary"
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = DisplayImportance["Max"]
	
	local CoreConfigurationSettings = {
		notifications = {
			Maximum = 3,
			Fade = true,
			BaseTimeBeforeFade = 5,
			FadeTime = 1
		},
		
		ui = {
			Key = Enum.KeyCode.Insert,
			Theme = {
				DarkBackground = Color3.new(0.0509804, 0.0509804, 0.0509804),
				LightBackground = Color3.new(0.129412, 0.129412, 0.129412),
				Background = Color3.new(0.0784314, 0.0784314, 0.0784314),
				Outline = Color3.new(0.027451, 0.027451, 0.027451),
				Text = Color3.new(0.870588, 0.870588, 0.870588),
				DividerColor = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
				}),
				DividerTransparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.1,1),
					NumberSequenceKeypoint.new(0.3,0),
					NumberSequenceKeypoint.new(0.7,0),
					NumberSequenceKeypoint.new(0.9, 1),
					NumberSequenceKeypoint.new(1,1)
				})
			}
		},
		
		
	}
	
	if PassedCoreConfiguration then
		if PassedCoreConfiguration then
			if PassedCoreConfiguration["notifications"] then
				for itemname, itemvalue in CoreConfigurationSettings["notifications"] do
					if PassedCoreConfiguration["notifications"][itemname] ~= nil then
						CoreConfigurationSettings["notifications"][itemname] = PassedCoreConfiguration["notifications"][itemname]
					end
				end
			end

			if PassedCoreConfiguration["ui"] then
				for itemname, itemvalue in CoreConfigurationSettings["ui"] do
					if itemname == "Theme" then
						if PassedCoreConfiguration["ui"]["Theme"] then
							for themekey, themevalue in CoreConfigurationSettings["ui"]["Theme"] do
								if PassedCoreConfiguration["ui"]["Theme"][themekey] ~= nil then
									CoreConfigurationSettings["ui"]["Theme"][themekey] = PassedCoreConfiguration["ui"]["Theme"][themekey]
								end
							end
						end
					elseif PassedCoreConfiguration["ui"][itemname] ~= nil then
						CoreConfigurationSettings["ui"][itemname] = PassedCoreConfiguration["ui"][itemname]
					end
				end
			end
		end
	end
	
	getgenv().UiLibVariables = {
		NotificationSystem = {
			CoreSystem = notificationsystem,
			ChangingObjects = {}
		},
		Drags = {},
		MainScreenGui = ScreenGui,
		CoreConfiguration = CoreConfigurationSettings,
		Handlers = {},
		BindToFunction = {},
	}
	
	getgenv().UiLibVariables.NotificationSystem.CoreSystem:Initialize()
	self:Notify("Loaded successfully.", "success")
	
	UIHandler.DefaultKey = CoreConfigurationSettings.ui.Key
	
	return UIHandler
end

game:GetService("UserInputService").InputBegan:Connect(function(inp, gpe) -- input handler
	if not gpe then
		if getgenv().UiLibVariables.KeyOpenings then
			for frame, keycode in getgenv().UiLibVariables.KeyOpenings do
				if keycode == inp.KeyCode then
					frame.Visible = not frame.Visible
				end
			end
		end
		
		if inp.UserInputType == Enum.UserInputType.Keyboard then
			for id, payload in getgenv().BindToFunction do
				if inp.KeyCode == payload.KeyCode then
					if payload.Object:GetAttribute("ToggleState") ~= nil then
						local toggled = not payload.Object:GetAttribute("ToggleState")
						
						payload.Object:SetAttribute("ToggleState", toggled)

						task.spawn(function()
							payload.Function(toggled)
						end)
						
						local true_toggle = payload.Object.Toggle.Toggle
						
						if toggled then
							true_toggle.Position = UDim2.new(0.5,0,0,0)
						else
							true_toggle.Position = UDim2.new(0,0,0,0)
						end
					end
				end
			end
		end
	end
end)

return uimoduletable

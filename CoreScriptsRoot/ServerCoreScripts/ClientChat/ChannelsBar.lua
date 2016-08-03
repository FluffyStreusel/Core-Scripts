local source = [[
local module = {}
--////////////////////////////// Include
--//////////////////////////////////////
local modulesFolder = script.Parent
local moduleChannelsTab = require(modulesFolder:WaitForChild("ChannelsTab"))
local moduleTransparencyTweener = require(modulesFolder:WaitForChild("TransparencyTweener"))

--////////////////////////////// Details
--//////////////////////////////////////
local metatable = {}
metatable.__ClassName = "ChannelsBar"

metatable.__tostring = function(tbl)
	return tbl.__ClassName .. ": " .. tbl.MemoryLocation
end

metatable.__metatable = "The metatable is locked"
metatable.__index = function(tbl, index, value)
	if rawget(tbl, index) then return rawget(tbl, index) end
	if rawget(metatable, index) then return rawget(metatable, index) end
	error(index .. " is not a valid member of " .. tbl.__ClassName)
end
metatable.__newindex = function(tbl, index, value)
	error(index .. " is not a valid member of " .. tbl.__ClassName)
end


--////////////////////////////// Methods
--//////////////////////////////////////
local function CreateGuiObject()
	local BaseFrame = Instance.new("Frame")
	BaseFrame.Size = UDim2.new(1, 0, 1, 0)
	BaseFrame.BackgroundTransparency = 1

	local ScrollingBase = Instance.new("Frame", BaseFrame)
	ScrollingBase.Name = "ScrollingBase"
	ScrollingBase.BackgroundTransparency = 1
	ScrollingBase.ClipsDescendants = true
	ScrollingBase.Size = UDim2.new(1, 0, 1, 0)
	ScrollingBase.Position = UDim2.new(0, 0, 0, 0)

	local ScrollerFrame = Instance.new("Frame", ScrollingBase)
	ScrollerFrame.Name = "ScrollerFrame"
	ScrollerFrame.BackgroundTransparency = 1
	ScrollerFrame.Size = UDim2.new(1, 0, 1, 0)
	ScrollerFrame.Position = UDim2.new(0, 0, 0, 0)


	local LeaveConfirmationFrameBase = Instance.new("Frame", BaseFrame)
	LeaveConfirmationFrameBase.Size = UDim2.new(1, 0, 1, 0)
	LeaveConfirmationFrameBase.Position = UDim2.new(0, 0, 0, 0)
	LeaveConfirmationFrameBase.ClipsDescendants = true
	LeaveConfirmationFrameBase.BackgroundTransparency = 1

	local LeaveConfirmationFrame = Instance.new("Frame", LeaveConfirmationFrameBase)
	LeaveConfirmationFrame.Name = "LeaveConfirmationFrame"
	LeaveConfirmationFrame.Size = UDim2.new(1, 0, 1, 0)
	LeaveConfirmationFrame.Position = UDim2.new(0, 0, 1, 0)
	LeaveConfirmationFrame.BackgroundTransparency = 0.6
	LeaveConfirmationFrame.BorderSizePixel = 0
	LeaveConfirmationFrame.BackgroundColor3 = Color3.new(0, 0, 0)

	local InputBlocker = Instance.new("TextButton", LeaveConfirmationFrame)
	InputBlocker.Size = UDim2.new(1, 0, 1, 0)
	InputBlocker.BackgroundTransparency = 1
	InputBlocker.Text = ""

	local LeaveConfirmationButtonYes = Instance.new("TextButton", LeaveConfirmationFrame)
	LeaveConfirmationButtonYes.Size = UDim2.new(0.25, 0, 1, 0)
	LeaveConfirmationButtonYes.BackgroundTransparency = 1
	LeaveConfirmationButtonYes.Font = Enum.Font.SourceSansBold
	LeaveConfirmationButtonYes.FontSize = Enum.FontSize.Size18
	LeaveConfirmationButtonYes.TextStrokeTransparency = 0.75
	LeaveConfirmationButtonYes.Position = UDim2.new(0, 0, 0, 0)
	LeaveConfirmationButtonYes.TextColor3 = Color3.new(0, 1, 0)
	LeaveConfirmationButtonYes.Text = "Confirm"
	
	local LeaveConfirmationButtonNo = LeaveConfirmationButtonYes:Clone()
	LeaveConfirmationButtonNo.Parent = LeaveConfirmationFrame
	LeaveConfirmationButtonNo.Position = UDim2.new(0.75, 0, 0, 0)
	LeaveConfirmationButtonNo.TextColor3 = Color3.new(1, 0, 0)
	LeaveConfirmationButtonNo.Text = "Cancel"

	local LeaveConfirmationNotice = Instance.new("TextLabel", LeaveConfirmationFrame)
	LeaveConfirmationNotice.Size = UDim2.new(0.5, 0, 1, 0)
	LeaveConfirmationNotice.Position = UDim2.new(0.25, 0, 0, 0)
	LeaveConfirmationNotice.BackgroundTransparency = 1
	LeaveConfirmationNotice.TextColor3 = Color3.new(1, 1, 1)
	LeaveConfirmationNotice.TextStrokeTransparency = 0.75
	LeaveConfirmationNotice.Text = "Leave channel <XX>?"
	LeaveConfirmationNotice.Font = Enum.Font.SourceSansBold
	LeaveConfirmationNotice.FontSize = Enum.FontSize.Size18

	local outPos = LeaveConfirmationFrame.Position
	LeaveConfirmationButtonYes.MouseButton1Click:connect(function()
		print("Leave channel")
		LeaveConfirmationFrame:TweenPosition(outPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
	end)
	LeaveConfirmationButtonNo.MouseButton1Click:connect(function()
		print("Do not leave channel")
		LeaveConfirmationFrame:TweenPosition(outPos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
	end)



	local scale = 0.7
	local scaleOther = (1 - scale) / 2

	local PageLeftButton = Instance.new("ImageButton", BaseFrame)
	PageLeftButton.Name = "PageLeftButton"
	PageLeftButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	PageLeftButton.Size = UDim2.new(scale, 0, scale, 0)
	PageLeftButton.BackgroundTransparency = 1
	PageLeftButton.Position = UDim2.new(0, 4, scaleOther, 0)
	PageLeftButton.Visible = false
	PageLeftButton.Image = "rbxasset://textures/ui/Chat/TabArrowBackground.png"
	local ArrowLabel = Instance.new("ImageLabel", PageLeftButton)
	ArrowLabel.Name = "ArrowLabel"
	ArrowLabel.BackgroundTransparency = 1
	ArrowLabel.Size = UDim2.new(0.4, 0, 0.4, 0)
	ArrowLabel.Image = "rbxasset://textures/ui/Chat/TabArrow.png"

	local PageRightButtonPositionalHelper = Instance.new("Frame", BaseFrame)
	PageRightButtonPositionalHelper.BackgroundTransparency = 1
	PageRightButtonPositionalHelper.Name = "PositionalHelper"
	PageRightButtonPositionalHelper.Size = PageLeftButton.Size
	PageRightButtonPositionalHelper.SizeConstraint = PageLeftButton.SizeConstraint
	PageRightButtonPositionalHelper.Position = UDim2.new(1, 0, scaleOther, 0)

	local PageRightButton = PageLeftButton:Clone()
	PageRightButton.Parent = PageRightButtonPositionalHelper
	PageRightButton.Name = "PageRightButton"
	PageRightButton.Size = UDim2.new(1, 0, 1, 0)
	PageRightButton.SizeConstraint = Enum.SizeConstraint.RelativeXY
	PageRightButton.Position = UDim2.new(-1, -4, 0, 0)

	local positionOffset = UDim2.new(0.05, 0, 0, 0)

	PageRightButton.ArrowLabel.Position = UDim2.new(0.3, 0, 0.3, 0) + positionOffset
	PageLeftButton.ArrowLabel.Position = UDim2.new(0.3, 0, 0.3, 0) - positionOffset
	PageLeftButton.ArrowLabel.Rotation = 180


	return BaseFrame, ScrollerFrame, PageLeftButton, PageRightButton, LeaveConfirmationFrame, LeaveConfirmationNotice
end

function metatable:Dump()
	return tostring(self)
end

function metatable:UpdateMessagePostedInChannel(channelName)
	local tab = self:GetChannelTab(channelName)
	if (tab) then
		tab:UpdateMessagePostedInChannel()
	else
		warn("ChannelsTab '" .. channelName .. "' does not exist!")
	end
end
		
function metatable:AddChannelTab(channelName)
	if (self:GetChannelTab(channelName)) then
		error("Channel tab '" .. channelName .. "'already exists!")
	end

	local tab = moduleChannelsTab.new(channelName)
	tab.GuiObject.Parent = self.ScrollerFrame
	self.ChannelTabs[channelName:lower()] = tab

	self.NumTabs = self.NumTabs + 1
	self:OrganizeChannelTabs()

	self.BackgroundTweener:RegisterTweenObjectProperty(tab.BackgroundTweener, "Transparency")
	self.TextTweener:RegisterTweenObjectProperty(tab.TextTweener, "Transparency")

	--tab.NameTag.MouseButton2Click:connect(function()
	--	self.LeaveConfirmationNotice.Text = "Leave channel " .. tab.ChannelName .. "?"
	--	self.LeaveConfirmationFrame:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
	--end)

	return tab
end

function metatable:RemoveChannelTab(channelName)
	if (not self:GetChannelTab(channelName)) then
		error("Channel tab '" .. channelName .. "'does not exist!")
	end

	local indexName = channelName:lower() 
	self.ChannelTabs[indexName]:Destroy()
	self.ChannelTabs[indexName] = nil

	self.NumTabs = self.NumTabs - 1
	self:OrganizeChannelTabs()
end

function metatable:GetChannelTab(channelName)
	return self.ChannelTabs[channelName:lower()]
end

function metatable:OrganizeChannelTabs()
	local order = {}

	table.insert(order, self:GetChannelTab("All"))
	table.insert(order, self:GetChannelTab("System"))

	for tabIndexName, tab in pairs(self.ChannelTabs) do
		if (tab.ChannelName ~= "All" and tab.ChannelName ~= "System") then
			table.insert(order, tab)
		end
	end

	for index, tab in pairs(order) do
		tab.GuiObject.Position = UDim2.new((index - 1) * 0.25, 0, 0, 0)
	end

	--// This does the effect of dynamic tab resizing when a player 
	--// is in less than 4 channels. It was mathematically easier to
	--// think about and do rather than resizing the actual tabs 
	--// themselves.
	local xSize = math.max(1, 4/self.NumTabs)
	self.ScrollerFrame.Size = UDim2.new(xSize, 0, 1, 0)

	self:ScrollChannelsFrame(0)
end

local lockScrollChannelsFrame = false
function metatable:ScrollChannelsFrame(dir)
	if (lockScrollChannelsFrame) then return end
	lockScrollChannelsFrame = true

	local newPageNum = self.CurPageNum + dir
	if (newPageNum < 0) then
		newPageNum = 0
	elseif (newPageNum > 0 and newPageNum + 4 > self.NumTabs) then
		newPageNum = self.NumTabs - 4
	end

	self.CurPageNum = newPageNum


	local tweenTime = 0.15
	local endPos = UDim2.new(-(self.CurPageNum * 0.25), 0, 0, 0)

	self.PageLeftButton.Visible = (self.CurPageNum > 0)
	self.PageRightButton.Visible = (self.CurPageNum + 4 < self.NumTabs)

	local function UnlockFunc()
		lockScrollChannelsFrame = false
	end
	self.ScrollerFrame:TweenPosition(endPos, Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, tweenTime, true, UnlockFunc)
end

function metatable:FadeOutBackground(duration)
	self.BackgroundTweener:Tween(duration, 1)
end

function metatable:FadeInBackground(duration)
	self.BackgroundTweener:Tween(duration, 0)
end

function metatable:FadeOutText(duration)
	self.TextTweener:Tween(duration, 1)
end

function metatable:FadeInText(duration)
	self.TextTweener:Tween(duration, 0)
end

function metatable:CreateTweeners()
	self.BackgroundTweener:CancelTween()
	self.TextTweener:CancelTween()

	self.BackgroundTweener = moduleTransparencyTweener.new()
	self.TextTweener = moduleTransparencyTweener.new()

	--// Register BackgroundTweener objects and properties
	self.BackgroundTweener:RegisterTweenObjectProperty(self.PageLeftButton, "ImageTransparency")
	self.BackgroundTweener:RegisterTweenObjectProperty(self.PageRightButton, "ImageTransparency")
	self.BackgroundTweener:RegisterTweenObjectProperty(self.PageLeftButtonArrow, "ImageTransparency")
	self.BackgroundTweener:RegisterTweenObjectProperty(self.PageRightButtonArrow, "ImageTransparency")

	--// Register TextTweener objects and properties
	
end

--///////////////////////// Constructors
--//////////////////////////////////////
function module.new()
	local obj = {}
	obj.MemoryLocation = tostring(obj):match("[0123456789ABCDEF]+")

	local BaseFrame, ScrollerFrame, PageLeftButton, PageRightButton, LeaveConfirmationFrame, LeaveConfirmationNotice = CreateGuiObject()
	obj.GuiObject = BaseFrame
	obj.ScrollerFrame = ScrollerFrame
	obj.PageLeftButton = PageLeftButton
	obj.PageRightButton = PageRightButton
	obj.LeaveConfirmationFrame = LeaveConfirmationFrame
	obj.LeaveConfirmationNotice = LeaveConfirmationNotice

	obj.PageLeftButtonArrow = obj.PageLeftButton.ArrowLabel
	obj.PageRightButtonArrow = obj.PageRightButton.ArrowLabel

	obj.ChannelTabs = {}
	obj.NumTabs = 0
	obj.CurPageNum = 0

	obj.BackgroundTweener = moduleTransparencyTweener.new()
	obj.TextTweener = moduleTransparencyTweener.new()

	obj = setmetatable(obj, metatable)

	obj:CreateTweeners()

	PageLeftButton.MouseButton1Click:connect(function() obj:ScrollChannelsFrame(-1) end)
	PageRightButton.MouseButton1Click:connect(function() obj:ScrollChannelsFrame(1) end)

	--// Have to wait to tween until it's properly parented to PlayerGui
	spawn(function()
		wait()
		obj:ScrollChannelsFrame(0)
	end)
	return obj
end

return module
]]

local generated = Instance.new("ModuleScript")
generated.Name = "Generated"
generated.Source = source
generated.Parent = script
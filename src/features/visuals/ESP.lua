-- this esp is opewnsource i should just used mine but shi imaking this for free so nah :laugh
local ESP = {}
ESP.__index = ESP

local PlayerESP = {}
PlayerESP.__index = PlayerESP

local BODY_PARTS = {
    Head = true, Torso = true, ["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true,
    UpperTorso = true, LowerTorso = true, LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
    RightUpperArm = true, RightLowerArm = true, RightHand = true, LeftUpperLeg = true, LeftLowerLeg = true,
    LeftFoot = true, RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
}

local function safeDestroy(object)
    if object then pcall(function() object:Destroy() end) end
end

local function safeRemove(drawing)
    if drawing then pcall(function() if drawing.Remove then drawing:Remove() else drawing:Destroy() end end) end
end

local function hideDrawings(drawings)
    for _, drawing in pairs(drawings) do
        if type(drawing) == "table" then hideDrawings(drawing) elseif drawing then drawing.Visible = false end
    end
end

local function destroyDrawings(drawings)
    for _, drawing in pairs(drawings) do
        if type(drawing) == "table" then destroyDrawings(drawing) else safeRemove(drawing) end
    end
end

local function getGuiParent()
    if gethui then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if ok and coreGui then return coreGui end
    local player = game:GetService("Players").LocalPlayer
    return player and player:FindFirstChildOfClass("PlayerGui")
end

local function capitalize(text)
    if not text or text == "" then return "" end
    return string.upper(string.sub(text, 1, 1)) .. string.lower(string.sub(text, 2))
end

local function createLabel(parent)
    local text = Instance.new("TextLabel")
    text.BackgroundTransparency = 1
    text.BorderSizePixel = 0
    text.AutomaticSize = Enum.AutomaticSize.XY
    text.Size = UDim2.new(0, 0, 0, 0)
    text.Font = Enum.Font.Code
    text.TextScaled = false
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.Parent = parent

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.new(0, 0, 0)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    stroke.LineJoinMode = Enum.LineJoinMode.Miter
    stroke.Parent = text

    return text, stroke
end

local function getBounds(character, camera)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local rootPoint, onScreen = camera:WorldToViewportPoint(root.Position)
    if not onScreen then return nil end

    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local found = false
    local animeModel = character:FindFirstChild("AnimeModel")

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 0.95 and part.Name ~= "HumanoidRootPart" and part.Name ~= "CollisionCapsule" then
            if BODY_PARTS[part.Name] or (animeModel and part:IsDescendantOf(animeModel)) then
                found = true
                local half = part.Size * 0.5
                local offsets = {
                    Vector3.new(-half.X, -half.Y, -half.Z), Vector3.new(half.X, -half.Y, -half.Z),
                    Vector3.new(-half.X, half.Y, -half.Z), Vector3.new(half.X, half.Y, -half.Z),
                    Vector3.new(-half.X, -half.Y, half.Z), Vector3.new(half.X, -half.Y, half.Z),
                    Vector3.new(-half.X, half.Y, half.Z), Vector3.new(half.X, half.Y, half.Z),
                }
                for _, offset in ipairs(offsets) do
                    local point = camera:WorldToViewportPoint(part.CFrame * offset)
                    minX = math.min(minX, point.X)
                    minY = math.min(minY, point.Y)
                    maxX = math.max(maxX, point.X)
                    maxY = math.max(maxY, point.Y)
                end
            end
        end
    end

    if found and minX ~= math.huge then
        return Vector2.new(minX, minY), Vector2.new(maxX - minX, maxY - minY)
    end

    local scale = (root.Size.Y * camera.ViewportSize.Y) / math.max(rootPoint.Z * 2, 1)
    local width, height = 3.2 * scale, 4.5 * scale
    return Vector2.new(rootPoint.X - width * 0.5, rootPoint.Y - height * 0.5), Vector2.new(width, height)
end

local function getTeamColor(character, teammate)
    local parent = character and character.Parent
    if parent and parent.Name == "Terrorists" then return Color3.fromRGB(255, 130, 0) end
    if parent and (parent.Name == "Enforcers" or parent.Name == "Counter-Terrorists") then return Color3.fromRGB(0, 140, 255) end
    return teammate and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 60, 60)
end

local function getValue(parent)
    if not parent then return nil end
    for _, name in ipairs({ "Cash", "Money", "Credits", "Points" }) do
        local child = parent:FindFirstChild(name)
        if child and (child:IsA("ValueBase") or child.ClassName:find("Value")) then return child.Value end
    end
end

local function getMoney(player)
    local character = player.Character
    return player:GetAttribute("Cash") or player:GetAttribute("Money") or player:GetAttribute("Credits")
        or (character and (character:GetAttribute("Cash") or character:GetAttribute("Money") or character:GetAttribute("Credits")))
        or getValue(player:FindFirstChild("leaderstats")) or getValue(player) or getValue(character)
end

local function getWeapon(player, character)
    local raw = character:GetAttribute("CurrentEquipped") or character:GetAttribute("Weapon") or character:GetAttribute("Equipped")
        or player:GetAttribute("CurrentEquipped") or player:GetAttribute("Weapon") or player:GetAttribute("Equipped") or player:GetAttribute("CurrentWeapon")
    if type(raw) == "string" and raw ~= "" and raw ~= "None" then return raw end
    local tool = character:FindFirstChildWhichIsA("Tool")
    if tool then return tool.Name end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Model") and child.Name ~= "AnimeModel" then return child.Name end
    end
    return "None"
end

function PlayerESP.new(owner, player)
    local self = setmetatable({}, PlayerESP)
    self.owner = owner
    self.player = player
    self.character = player.Character
    self.connections = {}
    self.drawings = {}
    self.lastUpdate = 0
    self:CreateGui()
    self:CreateDrawings()
    table.insert(self.connections, player.CharacterAdded:Connect(function(character) self.character = character end))
    table.insert(self.connections, player.CharacterRemoving:Connect(function() self.character = nil; self:Hide(); self:DestroyChams() end))
    return self
end

function PlayerESP:CreateGui()
    self.holder = Instance.new("Frame")
    self.holder.BackgroundTransparency = 1
    self.holder.BorderSizePixel = 0
    self.holder.Visible = false
    self.holder.Parent = self.owner.gui

    self.boxOuter = Instance.new("Frame")
    self.boxOuter.BackgroundTransparency = 1
    self.boxOuter.BorderSizePixel = 0
    self.boxOuter.Position = UDim2.new(0, -2, 0, -2)
    self.boxOuter.Size = UDim2.new(1, 4, 1, 4)
    self.boxOuter.Parent = self.holder
    self.boxOuterStroke = Instance.new("UIStroke")
    self.boxOuterStroke.Thickness = 1
    self.boxOuterStroke.LineJoinMode = Enum.LineJoinMode.Miter
    self.boxOuterStroke.Color = Color3.new(0, 0, 0)
    self.boxOuterStroke.Parent = self.boxOuter

    self.boxMiddle = Instance.new("Frame")
    self.boxMiddle.BackgroundTransparency = 1
    self.boxMiddle.BorderSizePixel = 0
    self.boxMiddle.Position = UDim2.new(0, -1, 0, -1)
    self.boxMiddle.Size = UDim2.new(1, 2, 1, 2)
    self.boxMiddle.Parent = self.holder
    self.boxMiddleStroke = Instance.new("UIStroke")
    self.boxMiddleStroke.Thickness = 1
    self.boxMiddleStroke.LineJoinMode = Enum.LineJoinMode.Miter
    self.boxMiddleStroke.Parent = self.boxMiddle

    self.boxInner = Instance.new("Frame")
    self.boxInner.BackgroundTransparency = 1
    self.boxInner.BorderSizePixel = 0
    self.boxInner.Size = UDim2.new(1, 0, 1, 0)
    self.boxInner.Parent = self.holder
    self.boxInnerStroke = Instance.new("UIStroke")
    self.boxInnerStroke.Thickness = 1
    self.boxInnerStroke.LineJoinMode = Enum.LineJoinMode.Miter
    self.boxInnerStroke.Color = Color3.new(0, 0, 0)
    self.boxInnerStroke.Parent = self.boxInner

    self.boxFill = Instance.new("Frame")
    self.boxFill.BorderSizePixel = 0
    self.boxFill.BackgroundTransparency = 0.5
    self.boxFill.Size = UDim2.new(1, 0, 1, 0)
    self.boxFill.ZIndex = -1
    self.boxFill.Parent = self.holder
    self.boxFillGradient = Instance.new("UIGradient")
    self.boxFillGradient.Rotation = 90
    self.boxFillGradient.Parent = self.boxFill

    self.boxGlow = Instance.new("ImageLabel")
    self.boxGlow.BackgroundTransparency = 1
    self.boxGlow.BorderSizePixel = 0
    self.boxGlow.Image = "rbxassetid://110204605000367"
    self.boxGlow.ImageTransparency = 0.8
    self.boxGlow.ScaleType = Enum.ScaleType.Slice
    self.boxGlow.SliceCenter = Rect.new(21, 21, 79, 79)
    self.boxGlow.Position = UDim2.new(0, -21, 0, -21)
    self.boxGlow.Size = UDim2.new(1, 42, 1, 42)
    self.boxGlow.ZIndex = -2
    self.boxGlow.Parent = self.holder
    self.boxGlowGradient = Instance.new("UIGradient")
    self.boxGlowGradient.Rotation = 90
    self.boxGlowGradient.Parent = self.boxGlow

    self.healthOutline = Instance.new("Frame")
    self.healthOutline.BackgroundColor3 = Color3.new(0, 0, 0)
    self.healthOutline.BorderSizePixel = 0
    self.healthOutline.Position = UDim2.new(0, -7, 0, -3)
    self.healthOutline.Size = UDim2.new(0, 3, 1, 6)
    self.healthOutline.Parent = self.holder
    self.healthFill = Instance.new("Frame")
    self.healthFill.BorderSizePixel = 0
    self.healthFill.AnchorPoint = Vector2.new(0, 1)
    self.healthFill.Position = UDim2.new(0, 1, 1, -1)
    self.healthFill.Size = UDim2.new(0, 1, 1, -2)
    self.healthFill.Parent = self.healthOutline
    self.healthGradient = Instance.new("UIGradient")
    self.healthGradient.Rotation = 90
    self.healthGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)) })
    self.healthGradient.Parent = self.healthFill

    self.top = Instance.new("Frame")
    self.top.BackgroundTransparency = 1
    self.top.BorderSizePixel = 0
    self.top.Position = UDim2.new(0.5, 0, 0, -5)
    self.top.AnchorPoint = Vector2.new(0.5, 1)
    self.top.AutomaticSize = Enum.AutomaticSize.XY
    self.top.Size = UDim2.new(0, 0, 0, 0)
    self.top.Parent = self.holder
    Instance.new("UIListLayout", self.top).HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.nameLabel, self.nameStroke = createLabel(self.top)

    self.bottom = Instance.new("Frame")
    self.bottom.BackgroundTransparency = 1
    self.bottom.BorderSizePixel = 0
    self.bottom.Position = UDim2.new(0.5, 0, 1, 5)
    self.bottom.AnchorPoint = Vector2.new(0.5, 0)
    self.bottom.AutomaticSize = Enum.AutomaticSize.XY
    self.bottom.Size = UDim2.new(0, 0, 0, 0)
    self.bottom.Parent = self.holder
    Instance.new("UIListLayout", self.bottom).HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.distanceLabel, self.distanceStroke = createLabel(self.bottom)
    self.weaponLabel, self.weaponStroke = createLabel(self.bottom)

    self.right = Instance.new("Frame")
    self.right.BackgroundTransparency = 1
    self.right.BorderSizePixel = 0
    self.right.Position = UDim2.new(1, 5, 0, -4)
    self.right.AutomaticSize = Enum.AutomaticSize.XY
    self.right.Size = UDim2.new(0, 0, 0, 0)
    self.right.Parent = self.holder
    Instance.new("UIListLayout", self.right).HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.flagsLabel, self.flagsStroke = createLabel(self.right)
    self.flagsLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.flagsLabel.LineHeight = 0.8
end

function PlayerESP:CreateDrawings()
    if not Drawing then return end
    pcall(function()
        self.drawings.tracer = Drawing.new("Line")
        self.drawings.tracer.Thickness = 1.2
        self.drawings.tracer.Transparency = 0.7
        self.drawings.headDot = Drawing.new("Circle")
        self.drawings.headDot.Radius = 3
        self.drawings.headDot.Filled = true
        self.drawings.headDot.Transparency = 1
        self.drawings.skeleton = {}
        for _, name in ipairs({ "headTorso", "leftArm", "rightArm", "leftLeg", "rightLeg", "leftForearm", "rightForearm", "leftShin", "rightShin" }) do
            self.drawings.skeleton[name] = Drawing.new("Line")
            self.drawings.skeleton[name].Thickness = 1.5
            self.drawings.skeleton[name].Transparency = 0.9
        end
    end)
end

function PlayerESP:Hide()
    if self.holder then self.holder.Visible = false end
    hideDrawings(self.drawings)
end

function PlayerESP:DestroyChams()
    safeDestroy(self.highlight)
    self.highlight = nil
end

function PlayerESP:UpdateText(object, stroke, visible, text, color, size)
    object.Visible = visible
    if visible then
        object.Text = text
        object.TextColor3 = color
        object.TextSize = size
        stroke.Color = Color3.new(0, 0, 0)
    end
end

function PlayerESP:DrawSkeleton(camera, color)
    local lines = self.drawings.skeleton
    if not lines then return end
    local character = self.character
    local function part(...)
        for _, name in ipairs({ ... }) do
            local found = character:FindFirstChild(name)
            if found then return found end
        end
    end
    local function screen(partObject)
        if not partObject then return nil end
        local point, visible = camera:WorldToViewportPoint(partObject.Position)
        if not visible then return nil end
        return Vector2.new(point.X, point.Y)
    end
    local function line(name, fromPart, toPart)
        local from, to = screen(fromPart), screen(toPart)
        lines[name].Visible = from ~= nil and to ~= nil
        if lines[name].Visible then lines[name].From = from; lines[name].To = to; lines[name].Color = color end
    end
    local head = part("Head")
    local torso = part("UpperTorso", "Torso", "LowerTorso", "HumanoidRootPart")
    local leftUpperArm = part("LeftUpperArm", "Left Arm")
    local rightUpperArm = part("RightUpperArm", "Right Arm")
    local leftLowerArm = part("LeftLowerArm", "LeftHand", "Left Arm")
    local rightLowerArm = part("RightLowerArm", "RightHand", "Right Arm")
    local leftUpperLeg = part("LeftUpperLeg", "Left Leg")
    local rightUpperLeg = part("RightUpperLeg", "Right Leg")
    local leftLowerLeg = part("LeftLowerLeg", "LeftFoot", "Left Leg")
    local rightLowerLeg = part("RightLowerLeg", "RightFoot", "Right Leg")
    line("headTorso", head, torso); line("leftArm", torso, leftUpperArm); line("rightArm", torso, rightUpperArm); line("leftLeg", torso, leftUpperLeg); line("rightLeg", torso, rightUpperLeg)
    line("leftForearm", leftUpperArm, leftLowerArm); line("rightForearm", rightUpperArm, rightLowerArm); line("leftShin", leftUpperLeg, leftLowerLeg); line("rightShin", rightUpperLeg, rightLowerLeg)
end

function PlayerESP:UpdateChams(color)
    if not self.owner.settings.showChams then self:DestroyChams(); return end
    local adornee = self.character and (self.character:FindFirstChild("AnimeModel") or self.character)
    if not adornee then self:DestroyChams(); return end
    if not self.highlight or self.highlight.Parent ~= adornee then
        self:DestroyChams()
        self.highlight = Instance.new("Highlight")
        self.highlight.Name = "AntigravityChams"
        self.highlight.Adornee = adornee
        self.highlight.Parent = adornee
    end
    self.highlight.Enabled = true
    self.highlight.FillColor = color
    self.highlight.FillTransparency = 0.5
    self.highlight.OutlineColor = Color3.new(1, 1, 1)
    self.highlight.OutlineTransparency = 0.2
    self.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

function PlayerESP:Update(camera, localPlayer)
    local settings = self.owner.settings
    self.character = self.character or self.player.Character
    local character = self.character
    if not settings.enabled or not character or not character.Parent or self.player == localPlayer then self:Hide(); self:DestroyChams(); return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root or humanoid.Health <= 0 then self:Hide(); self:DestroyChams(); return end
    local teammate = self.owner:IsTeammate(self.player, character)
    if settings.teamCheck and teammate then self:Hide(); self:DestroyChams(); return end
    local distance = self.owner:Distance(root.Position, camera)
    if settings.maxDistance > 0 and distance > settings.maxDistance then self:Hide(); self:DestroyChams(); return end
    local now = os.clock()
    if now - self.lastUpdate < 1 / settings.refreshRate then return end
    self.lastUpdate = now
    local position, size = getBounds(character, camera)
    if not position or not size then self:Hide(); return end

    local baseColor = settings.rainbow and self.owner:Rainbow() or getTeamColor(character, teammate)
    local boxColor = settings.rainbow and baseColor or settings.boxColor
    local textColor = settings.rainbow and baseColor or settings.textColor
    self.holder.Position = UDim2.fromOffset(math.floor(position.X), math.floor(position.Y))
    self.holder.Size = UDim2.fromOffset(math.floor(size.X), math.floor(size.Y))
    self.holder.Visible = true

    self.boxOuter.Visible = settings.showBox
    self.boxMiddle.Visible = settings.showBox
    self.boxInner.Visible = settings.showBox
    self.boxFill.Visible = settings.showBox
    self.boxGlow.Visible = settings.showBox
    if settings.showBox then
        self.boxMiddleStroke.Color = boxColor
        self.boxMiddleStroke.Thickness = settings.boxThickness
        local sequence = ColorSequence.new({ ColorSequenceKeypoint.new(0, boxColor:Lerp(Color3.fromRGB(255, 255, 200), 0.35)), ColorSequenceKeypoint.new(1, boxColor:Lerp(Color3.fromRGB(122, 122, 255), 0.35)) })
        self.boxFillGradient.Color = sequence
        self.boxGlowGradient.Color = sequence
    end

    self.healthOutline.Visible = settings.showHealth
    if settings.showHealth then self.healthFill.Size = UDim2.new(0, 1, math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1), -2) end
    local displayName = self.player.DisplayName ~= "" and self.player.DisplayName or self.player.Name
    self:UpdateText(self.nameLabel, self.nameStroke, settings.showName, capitalize(displayName), textColor, settings.textSize)
    self:UpdateText(self.distanceLabel, self.distanceStroke, settings.showDistance, string.format("%d studs", math.floor(distance + 0.5)), textColor, math.max(settings.textSize - 2, 10))
    self:UpdateText(self.weaponLabel, self.weaponStroke, settings.showWeapon, capitalize(getWeapon(self.player, character)), textColor, math.max(settings.textSize - 2, 10))
    local flags = {}
    if settings.showFlags then table.insert(flags, capitalize(humanoid.MoveDirection.Magnitude > 0.05 and "moving" or "idle")); table.insert(flags, humanoid.RigType == Enum.HumanoidRigType.R6 and "R6" or "R15") end
    if settings.showMoney then local cash = getMoney(self.player); if cash ~= nil then table.insert(flags, "$" .. tostring(cash)) end end
    self:UpdateText(self.flagsLabel, self.flagsStroke, #flags > 0, table.concat(flags, "\n"), textColor, math.max(settings.textSize - 3, 10))

    local rootPoint, rootVisible = camera:WorldToViewportPoint(root.Position)
    if self.drawings.tracer then
        self.drawings.tracer.Visible = settings.showTracers and rootVisible
        if self.drawings.tracer.Visible then self.drawings.tracer.From = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y); self.drawings.tracer.To = Vector2.new(rootPoint.X, rootPoint.Y); self.drawings.tracer.Color = settings.rainbow and baseColor or settings.tracerColor end
    end
    if self.drawings.headDot then
        local head = character:FindFirstChild("Head")
        local headPoint, headVisible = head and camera:WorldToViewportPoint(head.Position)
        self.drawings.headDot.Visible = settings.showHeadDot and headVisible == true
        if self.drawings.headDot.Visible then self.drawings.headDot.Position = Vector2.new(headPoint.X, headPoint.Y); self.drawings.headDot.Color = settings.rainbow and baseColor or settings.headDotColor end
    end
    if settings.showSkeleton then self:DrawSkeleton(camera, settings.rainbow and baseColor or settings.skeletonColor) elseif self.drawings.skeleton then hideDrawings(self.drawings.skeleton) end
    self:UpdateChams(baseColor)
end

function PlayerESP:Destroy()
    for _, connection in ipairs(self.connections) do connection:Disconnect() end
    self.connections = {}
    self:DestroyChams()
    safeDestroy(self.holder)
    destroyDrawings(self.drawings)
end

function ESP.new(context)
    local self = setmetatable({}, ESP)
    self.globals = context.globals
    self.services = context.services
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.players = self.services.Players or game:GetService("Players")
    self.localPlayer = self.players.LocalPlayer
    self.objects = {}
    self.settings = {
        enabled = false, teamCheck = false, showBox = false, showName = false, showHealth = false, showDistance = false,
        showSkeleton = false, showHeadDot = false, showTracers = false, showWeapon = false, showMoney = false,
        showFlags = false, showChams = false, maxDistance = 0, rainbow = false, rainbowSpeed = 2.0,
        boxColor = Color3.fromRGB(255, 255, 255), textColor = Color3.fromRGB(255, 255, 255), skeletonColor = Color3.fromRGB(255, 255, 255),
        tracerColor = Color3.fromRGB(255, 51, 153), headDotColor = Color3.fromRGB(255, 255, 255), textSize = 11, boxThickness = 1, refreshRate = 120,
    }

    local parent = getGuiParent()
    if parent then safeDestroy(parent:FindFirstChild("AntigravityESP")) end
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "AntigravityESP"
    self.gui.IgnoreGuiInset = true
    self.gui.DisplayOrder = 999
    self.gui.ResetOnSpawn = false
    self.gui.Parent = parent

    for _, player in ipairs(self.players:GetPlayers()) do self:AddPlayer(player) end
    self.cleaner:Give(self.players.PlayerAdded:Connect(function(player) self:AddPlayer(player) end))
    self.cleaner:Give(self.players.PlayerRemoving:Connect(function(player) self:RemovePlayer(player) end))
    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.Heartbeat, "ESP Heartbeat", function() self:Update() end))
    self.cleaner:Give(function() self:DestroyAll(); safeDestroy(self.gui) end)
    return self
end

function ESP:AddPlayer(player)
    if player == self.localPlayer or self.objects[player] then return end
    self.objects[player] = PlayerESP.new(self, player)
end

function ESP:RemovePlayer(player)
    local object = self.objects[player]
    if object then object:Destroy(); self.objects[player] = nil end
end

function ESP:DestroyAll()
    for player, object in pairs(self.objects) do object:Destroy(); self.objects[player] = nil end
end

function ESP:Rainbow()
    return Color3.fromHSV((tick() * self.settings.rainbowSpeed) % 1, 1, 1)
end

function ESP:IsTeammate(player, character)
    if player == self.localPlayer then return true end
    if self.localPlayer.Team and player.Team then return self.localPlayer.Team == player.Team end
    local localCharacter = self.localPlayer.Character or (workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(self.localPlayer.Name, true))
    if localCharacter and localCharacter.Parent and character and character.Parent and localCharacter.Parent ~= workspace and character.Parent ~= workspace then return localCharacter.Parent == character.Parent end
    return false
end

function ESP:Distance(position, camera)
    local root = self.localPlayer.Character and self.localPlayer.Character:FindFirstChild("HumanoidRootPart")
    return root and (root.Position - position).Magnitude or (camera.CFrame.Position - position).Magnitude
end

function ESP:Update()
    local camera = self.globals:GetCamera() or workspace.CurrentCamera
    if not camera then return end
    for _, object in pairs(self.objects) do
        local ok, err = pcall(function() object:Update(camera, self.localPlayer) end)
        if not ok then warn("[Wyvern ESP Error]: " .. tostring(err)); object:Hide() end
    end
end

function ESP:SetSetting(key, value)
    if self.settings[key] ~= nil then self.settings[key] = value end
end

function ESP:Destroy()
    self.cleaner:Cleanup()
end

return ESP

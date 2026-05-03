local ESP = {}
ESP.__index = ESP

local function safeRemove(drawing)
    if drawing then
        pcall(function()
            drawing:Remove()
        end)
    end
end

function ESP.new(context)
    local self = setmetatable({}, ESP)

    self.globals = context.globals
    self.services = context.services
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.cache = {}
    self.settings = {
        enabled = false,
        teamCheck = false,
        showBox = false,
        showName = false,
        showHealth = false,
        showDistance = false,
        showSkeleton = false,
        showHeadDot = false,
        showTracers = false,
        maxDistance = 0,
        rainbow = false,
        rainbowSpeed = 2.0,
        boxColor = Color3.fromRGB(255, 255, 255),
        textColor = Color3.fromRGB(255, 255, 255),
        skeletonColor = Color3.fromRGB(255, 255, 255),
        tracerColor = Color3.fromRGB(255, 51, 153),
        headDotColor = Color3.fromRGB(255, 0, 0),
        textSize = 15,
        boxThickness = 1.5,
    }

    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.RenderStepped, "ESP RenderStepped", function()
        self:_update()
    end))

    self.cleaner:Give(function()
        self:_destroyAll()
    end)

    return self
end

function ESP:_createEntry()
    local entry = {
        boxOutline = Drawing.new("Square"),
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        distance = Drawing.new("Text"),
        healthOutline = Drawing.new("Line"),
        healthBackground = Drawing.new("Line"),
        healthBar = Drawing.new("Line"),
        headDot = Drawing.new("Circle"),
        tracer = Drawing.new("Line"),
        skeleton = {
            headToNeck = Drawing.new("Line"),
            neckToTorso = Drawing.new("Line"),
            torsoToLeftUpper = Drawing.new("Line"),
            torsoToRightUpper = Drawing.new("Line"),
            leftUpperToLower = Drawing.new("Line"),
            rightUpperToLower = Drawing.new("Line"),
            leftLowerToFoot = Drawing.new("Line"),
            rightLowerToFoot = Drawing.new("Line"),
        },
    }

    entry.boxOutline.Thickness = 3
    entry.boxOutline.Filled = false
    entry.boxOutline.Color = Color3.new(0, 0, 0)

    entry.box.Filled = false

    entry.name.Center = true
    entry.name.Outline = true

    entry.distance.Center = true
    entry.distance.Outline = true

    entry.healthOutline.Thickness = 3
    entry.healthOutline.Color = Color3.new(0, 0, 0)

    entry.healthBackground.Thickness = 4
    entry.healthBackground.Color = Color3.new(0, 0, 0)
    entry.healthBackground.Transparency = 0.7

    entry.healthBar.Thickness = 2

    entry.headDot.Radius = 3
    entry.headDot.Filled = true
    entry.headDot.Transparency = 1

    entry.tracer.Thickness = 1.5
    entry.tracer.Transparency = 0.8

    for _, line in pairs(entry.skeleton) do
        line.Thickness = 1.5
        line.Transparency = 0.9
    end

    return entry
end

function ESP:_hideEntry(entry)
    for _, drawing in pairs(entry) do
        if type(drawing) == "table" then
            for _, line in pairs(drawing) do
                line.Visible = false
            end
        else
            drawing.Visible = false
        end
    end
end

function ESP:_destroyEntry(entry)
    for _, drawing in pairs(entry) do
        if type(drawing) == "table" then
            for _, line in pairs(drawing) do
                safeRemove(line)
            end
        else
            safeRemove(drawing)
        end
    end
end

function ESP:_destroyAll()
    for enemy, entry in pairs(self.cache) do
        self:_destroyEntry(entry)
        self.cache[enemy] = nil
    end
end

function ESP:_getRainbowColor()
    local hue = (tick() * self.settings.rainbowSpeed) % 1
    return Color3.fromHSV(hue, 1, 1)
end

function ESP:_update()
    if not self.settings.enabled or not self.globals:IsAlive() then
        for _, entry in pairs(self.cache) do
            self:_hideEntry(entry)
        end
        return
    end

    local camera = self.globals:GetCamera()
    if not camera then
        return
    end

    local currentAlive = {}
    local screenCenter = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y)
    local rainbowColor = self.settings.rainbow and self:_getRainbowColor() or nil

    for _, enemy in ipairs(self.globals:GetTargetModels(self.settings.teamCheck)) do
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        local head = enemy:FindFirstChild("Head")

        if humanoid and humanoid.Health > 0 and root and head then
            currentAlive[enemy] = true
            if not self.cache[enemy] then
                self.cache[enemy] = self:_createEntry()
            end

            local entry = self.cache[enemy]
            local rootPosition, onScreen = camera:WorldToViewportPoint(root.Position)
            local headPosition = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.4, 0))
            local legPosition = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.2, 0))
            local distance = (camera.CFrame.Position - root.Position).Magnitude

            if (self.settings.maxDistance > 0 and distance > self.settings.maxDistance) or not onScreen then
                self:_hideEntry(entry)
            else
                local boxHeight = math.abs(headPosition.Y - legPosition.Y) * 1.05
                local boxWidth = boxHeight * 0.55
                local boxX = rootPosition.X - (boxWidth * 0.5)
                local boxY = headPosition.Y

                local boxColor = rainbowColor or self.settings.boxColor
                local textColor = rainbowColor or self.settings.textColor
                local skeletonColor = rainbowColor or self.settings.skeletonColor
                local tracerColor = rainbowColor or self.settings.tracerColor
                local headDotColor = rainbowColor or self.settings.headDotColor

                if self.settings.showBox then
                    entry.boxOutline.Size = Vector2.new(boxWidth, boxHeight)
                    entry.boxOutline.Position = Vector2.new(boxX, boxY)
                    entry.boxOutline.Visible = true

                    entry.box.Size = Vector2.new(boxWidth, boxHeight)
                    entry.box.Position = Vector2.new(boxX, boxY)
                    entry.box.Color = boxColor
                    entry.box.Thickness = self.settings.boxThickness
                    entry.box.Visible = true
                else
                    entry.boxOutline.Visible = false
                    entry.box.Visible = false
                end

                if self.settings.showHealth then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barX = boxX - 7
                    local barTop = boxY
                    local barBottom = boxY + boxHeight

                    entry.healthBackground.From = Vector2.new(barX, barTop)
                    entry.healthBackground.To = Vector2.new(barX, barBottom)
                    entry.healthBackground.Visible = true

                    entry.healthOutline.From = Vector2.new(barX - 1, barTop - 1)
                    entry.healthOutline.To = Vector2.new(barX + 1, barBottom + 1)
                    entry.healthOutline.Visible = true

                    entry.healthBar.From = Vector2.new(barX, barBottom)
                    entry.healthBar.To = Vector2.new(barX, barBottom - (boxHeight * healthPercent))
                    entry.healthBar.Color = Color3.fromHSV(healthPercent * 0.33, 1, 1)
                    entry.healthBar.Visible = true
                else
                    entry.healthBackground.Visible = false
                    entry.healthOutline.Visible = false
                    entry.healthBar.Visible = false
                end

                if self.settings.showName then
                    entry.name.Text = enemy.Name
                    entry.name.Position = Vector2.new(rootPosition.X, headPosition.Y - 22)
                    entry.name.Color = textColor
                    entry.name.Size = self.settings.textSize
                    entry.name.Visible = true
                else
                    entry.name.Visible = false
                end

                if self.settings.showDistance then
                    entry.distance.Text = string.format("[%d studs]", math.floor(distance))
                    entry.distance.Position = Vector2.new(rootPosition.X, boxY + boxHeight + 4)
                    entry.distance.Color = textColor
                    entry.distance.Size = self.settings.textSize - 2
                    entry.distance.Visible = true
                else
                    entry.distance.Visible = false
                end

                if self.settings.showHeadDot then
                    entry.headDot.Position = Vector2.new(headPosition.X, headPosition.Y)
                    entry.headDot.Color = headDotColor
                    entry.headDot.Visible = true
                else
                    entry.headDot.Visible = false
                end

                if self.settings.showTracers then
                    entry.tracer.From = screenCenter
                    entry.tracer.To = Vector2.new(rootPosition.X, rootPosition.Y + (boxHeight * 0.5))
                    entry.tracer.Color = tracerColor
                    entry.tracer.Visible = true
                else
                    entry.tracer.Visible = false
                end

                if self.settings.showSkeleton then
                    local neck = enemy:FindFirstChild("Neck") or head
                    local torso = enemy:FindFirstChild("UpperTorso") or enemy:FindFirstChild("Torso")
                    local leftUpper = enemy:FindFirstChild("LeftUpperArm")
                    local rightUpper = enemy:FindFirstChild("RightUpperArm")
                    local leftLower = enemy:FindFirstChild("LeftLowerArm")
                    local rightLower = enemy:FindFirstChild("RightLowerArm")
                    local leftFoot = enemy:FindFirstChild("LeftFoot") or enemy:FindFirstChild("Left Leg")
                    local rightFoot = enemy:FindFirstChild("RightFoot") or enemy:FindFirstChild("Right Leg")

                    local function toScreen(position)
                        local point = camera:WorldToViewportPoint(position)
                        return Vector2.new(point.X, point.Y)
                    end

                    for _, line in pairs(entry.skeleton) do
                        line.Color = skeletonColor
                        line.Visible = true
                    end

                    entry.skeleton.headToNeck.From = Vector2.new(headPosition.X, headPosition.Y)
                    entry.skeleton.headToNeck.To = toScreen(neck.Position)

                    entry.skeleton.neckToTorso.From = toScreen(neck.Position)
                    entry.skeleton.neckToTorso.To = toScreen((torso and torso.Position) or root.Position)

                    entry.skeleton.torsoToLeftUpper.From = toScreen((torso and torso.Position) or root.Position)
                    entry.skeleton.torsoToLeftUpper.To = toScreen((leftUpper and leftUpper.Position) or root.Position)

                    entry.skeleton.torsoToRightUpper.From = toScreen((torso and torso.Position) or root.Position)
                    entry.skeleton.torsoToRightUpper.To = toScreen((rightUpper and rightUpper.Position) or root.Position)

                    entry.skeleton.leftUpperToLower.From = toScreen((leftUpper and leftUpper.Position) or root.Position)
                    entry.skeleton.leftUpperToLower.To = toScreen((leftLower and leftLower.Position) or root.Position)

                    entry.skeleton.rightUpperToLower.From = toScreen((rightUpper and rightUpper.Position) or root.Position)
                    entry.skeleton.rightUpperToLower.To = toScreen((rightLower and rightLower.Position) or root.Position)

                    entry.skeleton.leftLowerToFoot.From = toScreen((leftLower and leftLower.Position) or root.Position)
                    entry.skeleton.leftLowerToFoot.To = toScreen((leftFoot and leftFoot.Position) or root.Position)

                    entry.skeleton.rightLowerToFoot.From = toScreen((rightLower and rightLower.Position) or root.Position)
                    entry.skeleton.rightLowerToFoot.To = toScreen((rightFoot and rightFoot.Position) or root.Position)
                else
                    for _, line in pairs(entry.skeleton) do
                        line.Visible = false
                    end
                end
            end
        end
    end

    for enemy, entry in pairs(self.cache) do
        if not currentAlive[enemy] then
            self:_destroyEntry(entry)
            self.cache[enemy] = nil
        end
    end
end

function ESP:SetSetting(key, value)
    if self.settings[key] ~= nil then
        self.settings[key] = value
    end
end

function ESP:Destroy()
    self.cleaner:Cleanup()
end

return ESP

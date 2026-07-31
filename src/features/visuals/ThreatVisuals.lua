local ThreatVisuals = {}
ThreatVisuals.__index = ThreatVisuals

function ThreatVisuals.new(context)
    local self = setmetatable({}, ThreatVisuals)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.settings = {
        explosivePath = false,
        deviceScanner = false,
        gazeIndicators = false,
        indicatorReach = 15,
    }
    
    self.bombData = {}
    self.gazeLines = {}

    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "AstroThreats"
    self.gui.IgnoreGuiInset = true
    self.gui.DisplayOrder = 1000
    self.gui.Parent = (gethui and gethui()) or self.services.CoreGui

    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.RenderStepped, "ThreatVisuals Render", function()
        self:_updateGaze()
        self:_updateExplosives()
    end))
    
    self.cleaner:Give(function()
        for _, data in pairs(self.bombData) do
            if data.label then data.label:Destroy() end
            for _, line in ipairs(data.lines) do line:Remove() end
        end
        for _, line in pairs(self.gazeLines) do line:Remove() end
        self.gui:Destroy()
    end)

    return self
end

function ThreatVisuals:_updateGaze()
    local camera = self.globals:GetCamera()
    if not camera or not self.settings.gazeIndicators then
        for _, line in pairs(self.gazeLines) do line.Visible = false end
        return
    end

    local models = self.globals:GetTargetModels(false) 
    local activeModels = {}
    for _, model in ipairs(models) do
        activeModels[model] = true
        local head = model:FindFirstChild("Head")
        if head then
            local line = self.gazeLines[model]
            if not line then
                line = Drawing.new("Line")
                line.Thickness = 1.5
                line.Transparency = 0.8
                self.gazeLines[model] = line
            end

            local startPos, startVisible = camera:WorldToViewportPoint(head.Position)
            local endPos, endVisible = camera:WorldToViewportPoint(head.Position + head.CFrame.LookVector * self.settings.indicatorReach)

            if startVisible or endVisible then
                line.Visible = true
                line.From = Vector2.new(startPos.X, startPos.Y)
                line.To = Vector2.new(endPos.X, endPos.Y)
                line.Color = Color3.fromRGB(255, 60, 60)
            else
                line.Visible = false
            end
        end
    end
    
    for model, line in pairs(self.gazeLines) do
        if not activeModels[model] then
            line.Visible = false
        end
    end
end

function ThreatVisuals:_updateExplosives()
    local camera = self.globals:GetCamera()
    local debris = self.services.Workspace:FindFirstChild("Debris")
    if not camera or not debris then return end

    local currentDebris = {}

    for _, obj in ipairs(debris:GetChildren()) do
        local isBomb = false
        if string.find(string.lower(obj.Name), "c4") or string.find(string.lower(obj.Name), "bomb") then
            isBomb = true
        elseif obj:FindFirstChild("Weapon") and obj.Weapon:FindFirstChild("Circle") then
            isBomb = true
        end

        if isBomb then
            currentDebris[obj] = true
            local data = self.bombData[obj]
            if not data then
                data = { lines = {}, points = {}, label = nil }
                if Drawing then
                    for i = 1, 40 do
                        local line = Drawing.new("Line")
                        line.Thickness = 2
                        line.Color = Color3.fromRGB(255, 50, 50)
                        table.insert(data.lines, line)
                    end
                end
                self.bombData[obj] = data
            end

            local mainPart = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
            if mainPart then
                local screenPos, onScreen = camera:WorldToViewportPoint(mainPart.Position)
                
                if self.settings.deviceScanner and onScreen then
                    if not data.label then
                        local label = Instance.new("TextLabel")
                        label.BackgroundTransparency = 1
                        label.TextColor3 = Color3.fromRGB(255, 50, 50)
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 12
                        label.Parent = self.gui
                        data.label = label
                    end
                    local dist = (camera.CFrame.Position - mainPart.Position).Magnitude
                    data.label.Text = string.format("DEVICE [%dm]", math.floor(dist/3))
                    data.label.Position = UDim2.fromOffset(screenPos.X, screenPos.Y - 20)
                    data.label.Visible = true
                elseif data.label then
                    data.label.Visible = false
                end

                if self.settings.explosivePath then
                    if #data.points == 0 or (data.points[#data.points] - mainPart.Position).Magnitude > 0.5 then
                        table.insert(data.points, mainPart.Position)
                        if #data.points > 40 then table.remove(data.points, 1) end
                    end

                    for i, line in ipairs(data.lines) do
                        if i < #data.points then
                            local p1, v1 = camera:WorldToViewportPoint(data.points[i])
                            local p2, v2 = camera:WorldToViewportPoint(data.points[i+1])
                            if v1 and v2 then
                                line.Visible = true
                                line.From = Vector2.new(p1.X, p1.Y)
                                line.To = Vector2.new(p2.X, p2.Y)
                            else
                                line.Visible = false
                            end
                        else
                            line.Visible = false
                        end
                    end
                else
                    for _, line in ipairs(data.lines) do line.Visible = false end
                end
            end
        end
    end
    
    for obj, data in pairs(self.bombData) do
        if not currentDebris[obj] then
            if data.label then data.label.Visible = false end
            for _, line in ipairs(data.lines) do line.Visible = false end
        end
    end
end

function ThreatVisuals:SetSetting(key, value)
    if self.settings[key] ~= nil then
        self.settings[key] = value
    end
end

function ThreatVisuals:Destroy()
    self.cleaner:Cleanup()
end

return ThreatVisuals


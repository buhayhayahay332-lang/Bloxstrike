local BulletTracers = {}
BulletTracers.__index = BulletTracers

function BulletTracers.new(context)
    local self = setmetatable({}, BulletTracers)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.parts = {}
    self.settings = {
        enabled = false,
        color = Color3.fromRGB(0, 255, 255),
        transparency = 0.3,
        duration = 0.6,
        thickness = 0.2,
        pattern = "Straight",
    }

    self.cleaner:Give(self.errorHandler:Connect(self.services.UserInputService.InputBegan, "BulletTracers InputBegan", function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        if not self.settings.enabled or not self.globals:IsAlive() then
            return
        end

        local camera = self.globals:GetCamera()
        if not camera then
            return
        end

        local origin = camera.CFrame.Position
        local direction = camera.CFrame.LookVector * 300
        self:_createTracer(origin, direction)
    end))

    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.Heartbeat, "BulletTracers Heartbeat", function()
        for index = #self.parts, 1, -1 do
            if not self.parts[index] or not self.parts[index].Parent then
                table.remove(self.parts, index)
            end
        end
    end))

    self.cleaner:Give(function()
        for _, part in ipairs(self.parts) do
            if part and part.Parent then
                part:Destroy()
            end
        end
        table.clear(self.parts)
    end)

    return self
end

function BulletTracers:_createTracer(origin, direction)
    local tracer = Instance.new("Part")
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Transparency = self.settings.transparency
    tracer.Color = self.settings.color
    tracer.Material = Enum.Material.Neon
    tracer.Size = Vector3.new(self.settings.thickness, self.settings.thickness, 300)
    tracer.CFrame = CFrame.new(origin, origin + direction) * CFrame.new(0, 0, -150)
    tracer.Parent = self.services.Workspace

    self.parts[#self.parts + 1] = tracer

    local duration = self.settings.duration
    local pattern = self.settings.pattern

    if pattern == "Wave" then
        self.errorHandler:Spawn("BulletTracers Wave", function()
            local started = tick()
            while tracer.Parent and (tick() - started) < duration do
                local offset = Vector3.new(math.sin((tick() - started) * 15) * 2, 0, 0)
                tracer.CFrame = CFrame.new(origin + offset, origin + direction + offset) * CFrame.new(0, 0, -150)
                self.services.RunService.Heartbeat:Wait()
            end
            if tracer.Parent then
                tracer:Destroy()
            end
        end)
    elseif pattern == "Spiral" then
        self.errorHandler:Spawn("BulletTracers Spiral", function()
            local started = tick()
            while tracer.Parent and (tick() - started) < duration do
                local t = (tick() - started) * 20
                local offset = Vector3.new(math.cos(t) * 1.5, math.sin(t) * 1.5, 0)
                tracer.CFrame = CFrame.new(origin + offset, origin + direction + offset) * CFrame.new(0, 0, -150)
                self.services.RunService.Heartbeat:Wait()
            end
            if tracer.Parent then
                tracer:Destroy()
            end
        end)
    elseif pattern == "Dashed" then
        self.errorHandler:Spawn("BulletTracers Dashed", function()
            local started = tick()
            while tracer.Parent and (tick() - started) < duration do
                tracer.Transparency = (math.sin(tick() * 30) > 0) and self.settings.transparency or 1
                self.services.RunService.Heartbeat:Wait()
            end
            if tracer.Parent then
                tracer:Destroy()
            end
        end)
    else
        task.delay(duration, self.errorHandler:Wrap("BulletTracers Delay Cleanup", function()
            if tracer.Parent then
                tracer:Destroy()
            end
        end))
    end
end

function BulletTracers:SetSetting(key, value)
    if self.settings[key] ~= nil then
        self.settings[key] = value
    end
end

function BulletTracers:Destroy()
    self.cleaner:Cleanup()
end

return BulletTracers

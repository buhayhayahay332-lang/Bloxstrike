local ParticleEffects = {}
ParticleEffects.__index = ParticleEffects

function ParticleEffects.new(context)
    local self = setmetatable({}, ParticleEffects)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.settings = {
        enabled = false,
        color = Color3.fromRGB(255, 100, 0),
        amount = 25,
        lifetime = 1.2,
        style = "Spark",
    }

    self.cleaner:Give(self.errorHandler:Connect(self.services.UserInputService.InputBegan, "ParticleEffects InputBegan", function(input)
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

        local ray = camera:ViewportPointToRay(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y * 0.5)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ignoreList = { camera }
        local character = self.globals:GetPlayer().Character
        if character then
            ignoreList[#ignoreList + 1] = character
        end
        params.FilterDescendantsInstances = ignoreList

        local result = self.services.Workspace:Raycast(ray.Origin, ray.Direction * 500, params)
        local position = result and result.Position or (camera.CFrame.Position + (camera.CFrame.LookVector * 3))
        self:_createEffect(position)
    end))

    return self
end

function ParticleEffects:_createEffect(position)
    local attachment = Instance.new("Attachment")
    attachment.Position = position
    attachment.Parent = self.services.Workspace.Terrain

    local particle = Instance.new("ParticleEmitter")
    particle.Color = ColorSequence.new(self.settings.color)
    particle.Texture = "rbxassetid://243660364"
    particle.Lifetime = NumberRange.new(self.settings.lifetime * 0.6, self.settings.lifetime)
    particle.Rate = 0
    particle.EmissionDirection = Enum.NormalId.Front
    particle.SpreadAngle = Vector2.new(35, 35)
    particle.Speed = NumberRange.new(8, 18)
    particle.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(1, 0.1),
    })
    particle.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    particle.Parent = attachment

    if self.settings.style == "Smoke" then
        particle.Texture = "rbxassetid://243098098"
        particle.Speed = NumberRange.new(2, 6)
    elseif self.settings.style == "Fire" then
        particle.Texture = "rbxassetid://241650934"
        particle.Speed = NumberRange.new(5, 12)
    elseif self.settings.style == "Explosion" then
        particle.Lifetime = NumberRange.new(0.4, 0.8)
        particle.Speed = NumberRange.new(15, 30)
        particle.SpreadAngle = Vector2.new(80, 80)
    elseif self.settings.style == "Magic" then
        particle.Texture = "rbxassetid://243098098"
        particle.RotSpeed = NumberRange.new(-200, 200)
    end

    particle:Emit(self.settings.amount)

    task.delay(self.settings.lifetime + 0.5, self.errorHandler:Wrap("ParticleEffects Cleanup", function()
        if attachment and attachment.Parent then
            attachment:Destroy()
        end
    end))
end

function ParticleEffects:SetSetting(key, value)
    if self.settings[key] ~= nil then
        self.settings[key] = value
    end
end

function ParticleEffects:Destroy()
    self.cleaner:Cleanup()
end

return ParticleEffects

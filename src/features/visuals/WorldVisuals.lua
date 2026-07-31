local WorldVisuals = {}
WorldVisuals.__index = WorldVisuals

function WorldVisuals.new(context)
    local self = setmetatable({}, WorldVisuals)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.settings = {
        antiFlash = false,
        antiSmoke = false,
        midnightTint = false,
        externalView = false,
        cameraDepth = 8,
        minimalVisuals = false,
    }
    
    self.originalState = {
        shadows = self.services.Lighting.GlobalShadows,
        materials = {},
        reflectances = {},
        textures = {},
    }

    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.RenderStepped, "WorldVisuals RenderStepped", function()
        local player = self.globals:GetPlayer()
        local camera = self.globals:GetCamera()
        if not player or not camera then return end

        if self.settings.antiFlash then
            local playerGui = player:FindFirstChild("PlayerGui")
            local flash = playerGui and playerGui:FindFirstChild("FlashbangEffect")
            if flash then flash:Destroy() end
            
            local flashLighting = self.services.Lighting:FindFirstChild("FlashbangColorCorrection")
            if flashLighting then flashLighting:Destroy() end
            
            self.services.Lighting.ExposureCompensation = 0
        end

        local nightEffect = camera:FindFirstChild("AstroNight")
        if self.settings.midnightTint then
            if not nightEffect then
                nightEffect = Instance.new("ColorCorrectionEffect")
                nightEffect.Name = "AstroNight"
                nightEffect.Parent = camera
            end
            nightEffect.TintColor = Color3.fromRGB(100, 100, 160)
            nightEffect.Brightness = -0.15
            nightEffect.Contrast = 0.2
            nightEffect.Enabled = true
        elseif nightEffect then
            nightEffect:Destroy()
        end

        if self.settings.externalView then
            player.CameraMode = Enum.CameraMode.Classic
            camera.CFrame = camera.CFrame * CFrame.new(0, 0, self.settings.cameraDepth)
            
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.LocalTransparencyModifier = 0
                    end
                end
            end
            
            for _, model in ipairs(camera:GetChildren()) do
                if model:IsA("Model") then
                    for _, part in ipairs(model:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        else
            player.CameraMode = Enum.CameraMode.LockFirstPerson
        end
    end))

    local running = true
    self.cleaner:Give(function() running = false end)

    self.errorHandler:Spawn("WorldVisuals AntiSmoke Loop", function()
        while running do
            task.wait(0.5)
            if self.settings.antiSmoke then
                local debris = self.services.Workspace:FindFirstChild("Debris")
                if debris then
                    for _, folder in ipairs(debris:GetChildren()) do
                        if string.match(folder.Name, "Voxel") then
                            folder:Destroy()
                        end
                    end
                end
            end
        end
    end)

    return self
end

function WorldVisuals:SetSetting(key, value)
    local old = self.settings[key]
    if old == value then return end
    
    self.settings[key] = value

    if key == "minimalVisuals" then
        if value then
            self:_applyLowGfx()
        else
            self:_restoreGfx()
        end
    end
end

function WorldVisuals:_applyLowGfx()
    local lighting = self.services.Lighting
    local camera = self.globals:GetCamera()
    
    self.originalState.shadows = lighting.GlobalShadows
    lighting.GlobalShadows = false

    for _, part in ipairs(self.services.Workspace:GetDescendants()) do
        if part:IsDescendantOf(camera) or (part.Parent and part.Parent:FindFirstChildOfClass("Humanoid")) then
            continue
        end
        
        if part:IsA("BasePart") then
            self.originalState.materials[part] = part.Material
            self.originalState.reflectances[part] = part.Reflectance
            part.Material = Enum.Material.SmoothPlastic
            part.Reflectance = 0
        elseif part:IsA("Decal") or part:IsA("Texture") then
            self.originalState.textures[part] = part.Transparency
            part.Transparency = 1
        end
    end
end

function WorldVisuals:_restoreGfx()
    self.services.Lighting.GlobalShadows = self.originalState.shadows
    
    for part, material in pairs(self.originalState.materials) do
        if part and part.Parent then part.Material = material end
    end
    for part, reflectance in pairs(self.originalState.reflectances) do
        if part and part.Parent then part.Reflectance = reflectance end
    end
    for part, trans in pairs(self.originalState.textures) do
        if part and part.Parent then part.Transparency = trans end
    end
    
    table.clear(self.originalState.materials)
    table.clear(self.originalState.reflectances)
    table.clear(self.originalState.textures)
end

function WorldVisuals:Destroy()
    self:_restoreGfx()
    self.cleaner:Cleanup()
end

return WorldVisuals

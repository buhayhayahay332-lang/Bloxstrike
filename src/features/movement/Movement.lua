local Movement = {}
Movement.__index = Movement

function Movement.new(context)
    local self = setmetatable({}, Movement)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.settings = {
        enabled = false,
        bunnyHop = false,
        aerialGlide = false,
        motionScale = 16,
        leapForce = 25,
        glideVelocity = 16,
    }

    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.RenderStepped, "Movement RenderStepped", function()
        if not self.settings.enabled then
            return
        end

        local character = self.globals:GetPlayer().Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then
            return
        end

        humanoid.WalkSpeed = self.settings.motionScale
        humanoid.UseJumpPower = true
        humanoid.JumpPower = self.settings.leapForce

        -- Bunny Hop
        local isMoving = self.services.UserInputService:IsKeyDown(Enum.KeyCode.W) or self.services.UserInputService:IsKeyDown(Enum.KeyCode.A) or self.services.UserInputService:IsKeyDown(Enum.KeyCode.S) or self.services.UserInputService:IsKeyDown(Enum.KeyCode.D)
        if self.settings.bunnyHop and self.services.UserInputService:IsKeyDown(Enum.KeyCode.Space) and isMoving then
            if humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid.Jump = true
            end
        end

        if self.settings.aerialGlide and (humanoid:GetState() == Enum.HumanoidStateType.Freefall or humanoid.FloorMaterial == Enum.Material.Air) then
            local camera = self.globals:GetCamera()
            if not camera then return end

            local moveDir = Vector3.new(0, 0, 0)
            local uis = self.services.UserInputService

            if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end

            moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
                local vel = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(moveDir.X * self.settings.glideVelocity, vel.Y, moveDir.Z * self.settings.glideVelocity)
            end
        end
    end))

    return self
end

function Movement:SetSetting(key, value)
    if self.settings[key] ~= nil then
        self.settings[key] = value
    end
end

function Movement:SetEnabled(value)
    self.settings.enabled = value == true
end

function Movement:Destroy()
    self.cleaner:Cleanup()
end

return Movement

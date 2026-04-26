local BunnyHop = {}
BunnyHop.__index = BunnyHop

function BunnyHop.new(context)
    local self = setmetatable({}, BunnyHop)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.enabled = false

    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.RenderStepped, "BunnyHop RenderStepped", function()
        if not self.enabled then
            return
        end

        if not self.globals:IsAlive() then
            return
        end

        if not self.services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            return
        end

        local character = self.globals:GetPlayer().Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return
        end

        local state = humanoid:GetState()
        if state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall then
            humanoid.Jump = true
        end
    end))

    return self
end

function BunnyHop:SetEnabled(value)
    self.enabled = value == true
end

function BunnyHop:Destroy()
    self.cleaner:Cleanup()
end

return BunnyHop

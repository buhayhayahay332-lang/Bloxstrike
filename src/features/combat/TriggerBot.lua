local TriggerBot = {}
TriggerBot.__index = TriggerBot

function TriggerBot.new(context)
    local self = setmetatable({}, TriggerBot)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.settings = {
        enabled = false,
        delayMs = 0,
    }
    self.running = true

    self.cleaner:Give(function()
        self.running = false
    end)

    self.errorHandler:Spawn("TriggerBot Loop", function()
        while self.running do
            task.wait(0.01)

            if self.settings.enabled and self.globals:IsAlive() then
                local camera = self.globals:GetCamera()
                if camera then
                    local viewportSize = camera.ViewportSize
                    local ray = camera:ViewportPointToRay(viewportSize.X * 0.5, viewportSize.Y * 0.5)
                    local params = RaycastParams.new()
                    params.FilterType = Enum.RaycastFilterType.Exclude

                    local ignoreList = { camera }
                    local character = self.globals:GetPlayer().Character
                    if character then
                        ignoreList[#ignoreList + 1] = character
                    end
                    params.FilterDescendantsInstances = ignoreList

                    local result = self.services.Workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
                    if result and result.Instance then
                        local model = result.Instance:FindFirstAncestorOfClass("Model")
                        local humanoid = model and model:FindFirstChildOfClass("Humanoid")

                        if model and self.globals:IsEnemyModel(model) and humanoid and humanoid.Health > 0 then
                            if self.settings.delayMs > 0 then
                                task.wait(self.settings.delayMs / 1000)
                            end

                            if mouse1press then
                                mouse1press()
                            end

                            task.wait(0.05)

                            if mouse1release then
                                mouse1release()
                            end
                        end
                    end
                end
            end
        end
    end)

    return self
end

function TriggerBot:SetEnabled(value)
    self.settings.enabled = value == true
end

function TriggerBot:SetDelayMs(value)
    self.settings.delayMs = math.max(0, tonumber(value) or 0)
end

function TriggerBot:Destroy()
    self.cleaner:Cleanup()
end

return TriggerBot

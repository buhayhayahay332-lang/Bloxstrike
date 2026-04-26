local WorldEffects = {}
WorldEffects.__index = WorldEffects

function WorldEffects.new(context)
    local self = setmetatable({}, WorldEffects)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.settings = {
        antiFlash = false,
        antiSmoke = false,
    }
    self.running = true

    self.cleaner:Give(function()
        self.running = false
    end)

    self.errorHandler:Spawn("WorldEffects AntiFlash Loop", function()
        while self.running do
            task.wait(0.2)

            if self.settings.antiFlash then
                local playerGui = self.globals:GetPlayer():FindFirstChild("PlayerGui")
                local gui = playerGui and playerGui:FindFirstChild("FlashbangEffect")
                local effect = self.services.Lighting:FindFirstChild("FlashbangColorCorrection")

                if gui then
                    gui:Destroy()
                end

                if effect then
                    effect:Destroy()
                end
            end
        end
    end)

    self.errorHandler:Spawn("WorldEffects AntiSmoke Loop", function()
        while self.running do
            task.wait(0.5)

            if self.settings.antiSmoke then
                local debris = self.services.Workspace:FindFirstChild("Debris")
                if debris then
                    for _, folder in ipairs(debris:GetChildren()) do
                        if string.match(folder.Name, "Voxel") then
                            folder:ClearAllChildren()
                            folder:Destroy()
                        end
                    end
                end
            end
        end
    end)

    return self
end

function WorldEffects:SetSetting(key, value)
    if self.settings[key] ~= nil then
        self.settings[key] = value
    end
end

function WorldEffects:Destroy()
    self.cleaner:Cleanup()
end

return WorldEffects

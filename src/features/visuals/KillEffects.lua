local KillEffects = {}
KillEffects.__index = KillEffects

function KillEffects.new(context)
    local self = setmetatable({}, KillEffects)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.settings = {
        enabled = false,
        color = Color3.fromRGB(255, 0, 100),
        duration = 0.8,
        intensity = 0.6,
    }
    self.running = true
    self.lastHealth = {}
    self.flashGui = nil

    self.cleaner:Give(function()
        self.running = false
        if self.flashGui and self.flashGui.Parent then
            self.flashGui:Destroy()
        end
    end)

    self.errorHandler:Spawn("KillEffects Loop", function()
        while self.running do
            task.wait(0.1)

            if self.settings.enabled then
                local enemyFolder = self.globals:GetEnemyFolder()
                if enemyFolder then
                    for _, enemy in ipairs(enemyFolder:GetChildren()) do
                        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local previousHealth = self.lastHealth[enemy]
                            local currentHealth = humanoid.Health

                            if previousHealth and previousHealth > 0 and currentHealth <= 0 then
                                self:_play()
                            end

                            self.lastHealth[enemy] = currentHealth
                        end
                    end
                end
            end
        end
    end)

    return self
end

function KillEffects:_getFlashGui()
    if self.flashGui and self.flashGui.Parent then
        return self.flashGui
    end

    local playerGui = self.globals:GetPlayer():WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "BloxtrikeKillEffects"
    gui.ResetOnSpawn = false
    gui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "Flash"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = gui

    self.flashGui = gui
    return gui
end

function KillEffects:_play()
    local gui = self:_getFlashGui()
    local flash = gui:FindFirstChild("Flash")
    if not flash then
        return
    end

    local duration = self.settings.duration
    local intensity = math.clamp(self.settings.intensity, 0.2, 1)
    flash.BackgroundColor3 = self.settings.color
    flash.BackgroundTransparency = 1 - (intensity * 0.8)

    self.services.TweenService:Create(
        flash,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { BackgroundTransparency = 1 }
    ):Play()

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 300, 0, 100)
    label.Position = UDim2.new(0.5, -150, 0.4, 0)
    label.BackgroundTransparency = 1
    label.Text = "KILL"
    label.TextColor3 = self.settings.color
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextTransparency = 0
    label.Parent = self.globals:GetPlayer():WaitForChild("PlayerGui")

    self.services.TweenService:Create(
        label,
        TweenInfo.new(duration * 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0.5, -150, 0.25, 0),
            TextTransparency = 1 - intensity,
        }
    ):Play()

    task.delay(duration, self.errorHandler:Wrap("KillEffects Label Cleanup", function()
        if label and label.Parent then
            label:Destroy()
        end
    end))
end

function KillEffects:SetSetting(key, value)
    if self.settings[key] ~= nil then
        self.settings[key] = value
    end
end

function KillEffects:Destroy()
    self.cleaner:Cleanup()
end

return KillEffects

local Chams = {}
Chams.__index = Chams

function Chams.new(context)
    local self = setmetatable({}, Chams)

    self.globals = context.globals
    self.services = context.services
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.playerCache = {}
    self.weaponCache = {}
    self.settings = {
        rainbow = false,
        rainbowSpeed = 2.0,
        playerEnabled = false,
        playerTeamCheck = false,
        playerVisibleOnly = false,
        playerColor = Color3.fromRGB(255, 0, 0),
        playerFillTransparency = 0.7,
        playerOutlineTransparency = 0,
        weaponEnabled = false,
        weaponColor = Color3.fromRGB(0, 255, 255),
        weaponFillTransparency = 0.5,
        weaponOutlineTransparency = 0,
    }

    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.Heartbeat, "Chams Heartbeat", function()
        self:_update()
    end))

    self.cleaner:Give(function()
        self:_clearCache(self.playerCache)
        self:_clearCache(self.weaponCache)
    end)

    return self
end

function Chams:_getRainbowColor()
    return Color3.fromHSV((tick() * self.settings.rainbowSpeed) % 1, 1, 1)
end

function Chams:_clearCache(cache)
    for target, highlight in pairs(cache) do
        if highlight then
            highlight:Destroy()
        end
        cache[target] = nil
    end
end

function Chams:_getColor(fallback)
    if self.settings.rainbow then
        return self:_getRainbowColor()
    end

    return fallback
end

function Chams:_updatePlayers()
    if not self.settings.playerEnabled then
        self:_clearCache(self.playerCache)
        return
    end

    local color = self:_getColor(self.settings.playerColor)
    local active = {}

    for _, enemy in ipairs(self.globals:GetTargetModels(self.settings.playerTeamCheck)) do
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            active[enemy] = true

            if not self.playerCache[enemy] then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = enemy
                highlight.Parent = enemy
                self.playerCache[enemy] = highlight
            end

            local highlight = self.playerCache[enemy]
            highlight.DepthMode = self.settings.playerVisibleOnly
                and Enum.HighlightDepthMode.Occluded
                or Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.FillTransparency = self.settings.playerFillTransparency
            highlight.OutlineTransparency = self.settings.playerOutlineTransparency
        end
    end

    for enemy, highlight in pairs(self.playerCache) do
        local humanoid = enemy and enemy:FindFirstChildOfClass("Humanoid")
        if not active[enemy] or not humanoid or humanoid.Health <= 0 or not enemy.Parent then
            if highlight then
                highlight:Destroy()
            end
            self.playerCache[enemy] = nil
        end
    end
end

function Chams:_updateWeapons()
    if not self.settings.weaponEnabled then
        self:_clearCache(self.weaponCache)
        return
    end

    local camera = self.globals:GetCamera()
    if not camera then
        return
    end

    local color = self:_getColor(self.settings.weaponColor)
    local active = {}

    for _, object in ipairs(camera:GetChildren()) do
        if object:IsA("Model") and (object.Name:find("Knife") or object:FindFirstChild("Weapon")) then
            active[object] = true

            if not self.weaponCache[object] then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = object
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = object
                self.weaponCache[object] = highlight
            end

            local highlight = self.weaponCache[object]
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.FillTransparency = self.settings.weaponFillTransparency
            highlight.OutlineTransparency = self.settings.weaponOutlineTransparency
        end
    end

    for object, highlight in pairs(self.weaponCache) do
        if not active[object] or not object.Parent then
            if highlight then
                highlight:Destroy()
            end
            self.weaponCache[object] = nil
        end
    end
end

function Chams:_update()
    self:_updatePlayers()
    self:_updateWeapons()
end

function Chams:SetSetting(key, value)
    if self.settings[key] ~= nil then
        self.settings[key] = value
    end
end

function Chams:Destroy()
    self.cleaner:Cleanup()
end

return Chams

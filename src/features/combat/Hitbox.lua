local Hitbox = {}
Hitbox.__index = Hitbox

function Hitbox.new(context)
    local self = setmetatable({}, Hitbox)

    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.settings = {
        enabled = false,
        teamCheck = false,
        size = 3,
        transparency = 0.5,
    }
    self.running = true
    self.originalHeadStates = {}

    self.cleaner:Give(function()
        self.running = false
        self:_restoreAll()
    end)

    self.errorHandler:Spawn("Hitbox Loop", function()
        while self.running do
            task.wait(0.5)

            for _, enemy in ipairs(self.globals:GetTargetModels(self.settings.teamCheck)) do
                local head = enemy:FindFirstChild("Head")
                local humanoid = enemy:FindFirstChildOfClass("Humanoid")

                if head and humanoid and humanoid.Health > 0 then
                    if not self.originalHeadStates[head] then
                        self.originalHeadStates[head] = {
                            size = head.Size,
                            transparency = head.Transparency,
                            canCollide = head.CanCollide,
                        }
                    end

                    if self.settings.enabled then
                        head.Size = Vector3.new(self.settings.size, self.settings.size, self.settings.size)
                        head.CanCollide = false
                        head.Transparency = self.settings.transparency
                    else
                        self:_restoreHead(head)
                    end
                end
            end
        end
    end)

    return self
end

function Hitbox:_restoreHead(head)
    local state = self.originalHeadStates[head]
    if not state or not head or not head.Parent then
        return
    end

    head.Size = state.size
    head.Transparency = state.transparency
    head.CanCollide = state.canCollide
end

function Hitbox:_restoreAll()
    for head in pairs(self.originalHeadStates) do
        pcall(function()
            self:_restoreHead(head)
        end)
    end
end

function Hitbox:SetEnabled(value)
    self.settings.enabled = value == true
    if not self.settings.enabled then
        self:_restoreAll()
    end
end

function Hitbox:SetTeamCheck(value)
    self.settings.teamCheck = value == true
    if not self.settings.teamCheck and not self.settings.enabled then
        self:_restoreAll()
    end
end

function Hitbox:SetSize(value)
    local size = tonumber(value)
    if size then
        self.settings.size = math.clamp(size, 1, 5)
    end
end

function Hitbox:SetTransparency(value)
    local transparency = tonumber(value)
    if transparency then
        self.settings.transparency = math.clamp(transparency, 0, 1)
    end
end

function Hitbox:Destroy()
    self.cleaner:Cleanup()
end

return Hitbox

local Aimbot = {}
Aimbot.__index = Aimbot

function Aimbot.new(context)
    local self = setmetatable({}, Aimbot)

    self.services = context.services
    self.globals = context.globals
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.settings = {
        enabled = false,
        teamCheck = false,
        wallCheck = false,
        showFov = false,
        fovRadius = 100,
        smoothing = 3,
        aimInput = Enum.UserInputType.MouseButton2,
    }
    self.isAiming = false
    self.fovCircle = nil

    if Drawing and Drawing.new then
        local ok, circle = pcall(Drawing.new, "Circle")
        if ok and circle then
            circle.Filled = false
            circle.Color = Color3.fromRGB(0, 255, 255)
            circle.Visible = false
            circle.Thickness = 1
            self.fovCircle = circle

            self.cleaner:Give(function()
                pcall(function()
                    circle.Visible = false
                    circle:Remove()
                end)
            end)
        end
    end

    self:_bind()
    return self
end

function Aimbot:_getAimScreenPosition(camera)
    local activeCamera = camera or self.globals:GetCamera()
    if not activeCamera then
        return nil
    end

    return Vector2.new(
        activeCamera.ViewportSize.X * 0.5,
        activeCamera.ViewportSize.Y * 0.5
    )
end

function Aimbot:_hasLineOfSight(head)
    local camera = self.globals:GetCamera()
    if not camera or not head then
        return false
    end

    local origin = camera.CFrame.Position
    local direction = head.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local ignoreList = { camera }
    local character = self.globals:GetPlayer().Character
    if character then
        ignoreList[#ignoreList + 1] = character
    end
    params.FilterDescendantsInstances = ignoreList

    local result = self.services.Workspace:Raycast(origin, direction, params)
    if not result then
        return true
    end

    local hitModel = result.Instance and result.Instance:FindFirstAncestorOfClass("Model")
    return hitModel ~= nil and hitModel == head:FindFirstAncestorOfClass("Model")
end

function Aimbot:_getClosestEnemyToMouse()
    if not self.settings.enabled then
        return nil
    end

    local camera = self.globals:GetCamera()
    if not camera then
        return nil
    end

    local aimPosition = self:_getAimScreenPosition(camera)
    if not aimPosition then
        return nil
    end

    local closestHead = nil
    local shortestDistance = self.settings.fovRadius

    for _, enemy in ipairs(self.globals:GetTargetModels(self.settings.teamCheck)) do
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        local head = enemy:FindFirstChild("Head")

        if humanoid and humanoid.Health > 0 and head
            and (not self.settings.wallCheck or self:_hasLineOfSight(head))
        then
            local headPosition, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local distance = (Vector2.new(headPosition.X, headPosition.Y) - aimPosition).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestHead = head
                end
            end
        end
    end

    return closestHead
end

function Aimbot:_updateFovCircle()
    if not self.fovCircle then
        return
    end

    if self.settings.showFov then
        local aimPosition = self:_getAimScreenPosition()
        if not aimPosition then
            self.fovCircle.Visible = false
            return
        end

        self.fovCircle.Position = aimPosition
        self.fovCircle.Radius = self.settings.fovRadius
        self.fovCircle.Visible = true
    else
        self.fovCircle.Visible = false
    end
end

function Aimbot:_bind()
    self.cleaner:Give(self.errorHandler:Connect(self.services.UserInputService.InputBegan, "Aimbot InputBegan", function(input)
        if input.UserInputType == self.settings.aimInput then
            self.isAiming = true
        end
    end))

    self.cleaner:Give(self.errorHandler:Connect(self.services.UserInputService.InputEnded, "Aimbot InputEnded", function(input)
        if input.UserInputType == self.settings.aimInput then
            self.isAiming = false
        end
    end))

    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.RenderStepped, "Aimbot RenderStepped", function()
        self:_updateFovCircle()

        if not self.settings.enabled or not self.isAiming or not self.globals:IsAlive() then
            return
        end

        local camera = self.globals:GetCamera()
        local targetHead = self:_getClosestEnemyToMouse()
        if not camera or not targetHead then
            return
        end

        local headPosition = camera:WorldToViewportPoint(targetHead.Position)
        local aimPosition = self:_getAimScreenPosition(camera)
        if not aimPosition then
            return
        end

        local moveX = (headPosition.X - aimPosition.X) / self.settings.smoothing
        local moveY = (headPosition.Y - aimPosition.Y) / self.settings.smoothing

        if mousemoverel then
            mousemoverel(moveX, moveY)
        end
    end))
end

function Aimbot:SetEnabled(value)
    self.settings.enabled = value == true
end

function Aimbot:SetTeamCheck(value)
    self.settings.teamCheck = value == true
end

function Aimbot:SetWallCheck(value)
    self.settings.wallCheck = value == true
end

function Aimbot:SetShowFov(value)
    self.settings.showFov = value == true
end

function Aimbot:SetFovRadius(value)
    self.settings.fovRadius = tonumber(value) or self.settings.fovRadius
end

function Aimbot:SetSmoothing(value)
    local smoothing = tonumber(value)
    if smoothing and smoothing > 0 then
        self.settings.smoothing = smoothing
    end
end

function Aimbot:Destroy()
    self.cleaner:Cleanup()
end

return Aimbot

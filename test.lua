-- init
if not game:IsLoaded() then 
    game.Loaded:Wait()
end

local SilentAimSettings = {
    Enabled = false,
    ToggleKey = "RightAlt",
    
    TeamCheck = false,
    VisibleCheck = false, 
    TargetPart = "HumanoidRootPart",
    SilentAimMethod = "Raycast",
    
    FOVRadius = 130,
    FOVVisible = false,
    ShowSilentAimTarget = false, 
    
    MouseHitPrediction = false,
    MouseHitPredictionAmount = 0.165,
    HitChance = 100
}

-- variables
local Global = getgenv()
Global.SilentAimSettings = SilentAimSettings

if Global.__test_lua_cleanup then
    pcall(Global.__test_lua_cleanup)
end

local RuntimeState = {
    Connections = {},
    Drawings = {}
}

Global.__test_lua_state = RuntimeState
Global.__test_lua_cleanup = function()
    for _, Connection in ipairs(RuntimeState.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end

    for _, DrawingObject in ipairs(RuntimeState.Drawings) do
        pcall(function()
            DrawingObject:Remove()
        end)
    end
end

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local GetPlayers = Players.GetPlayers
local WorldToScreen = Camera.WorldToScreenPoint
local WorldToViewportPoint = Camera.WorldToViewportPoint
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local FindFirstChild = game.FindFirstChild
local RenderStepped = RunService.RenderStepped
local GetMouseLocation = UserInputService.GetMouseLocation

local ValidTargetParts = {"Head", "HumanoidRootPart"}
local PredictionAmount = 0.165

local mouse_box = Drawing.new("Square")
mouse_box.Visible = true 
mouse_box.ZIndex = 999 
mouse_box.Color = Color3.fromRGB(54, 57, 241)
mouse_box.Thickness = 20 
mouse_box.Size = Vector2.new(20, 20)
mouse_box.Filled = true 
mouse_box.Visible = SilentAimSettings.Enabled and SilentAimSettings.ShowSilentAimTarget
table.insert(RuntimeState.Drawings, mouse_box)

local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.NumSides = 100
fov_circle.Radius = 180
fov_circle.Filled = false
fov_circle.Visible = false
fov_circle.ZIndex = 999
fov_circle.Transparency = 1
fov_circle.Color = Color3.fromRGB(54, 57, 241)
fov_circle.Radius = SilentAimSettings.FOVRadius
fov_circle.Visible = SilentAimSettings.FOVVisible
table.insert(RuntimeState.Drawings, fov_circle)

local RadarSettings = {
    Enabled = true,
    Radius = 110,
    Range = 300,
    Anchor = Vector2.new(170, 170),
    Rotate = true,
    ShowOffscreen = true,
    DotSize = 4,
    SelfDotSize = 5
}

Global.RadarSettings = RadarSettings

local radar_background = Drawing.new("Circle")
radar_background.Filled = true
radar_background.Thickness = 1
radar_background.NumSides = 100
radar_background.Radius = RadarSettings.Radius
radar_background.Color = Color3.fromRGB(18, 18, 22)
radar_background.Transparency = 0.72
radar_background.Visible = RadarSettings.Enabled
radar_background.ZIndex = 990
table.insert(RuntimeState.Drawings, radar_background)

local radar_outline = Drawing.new("Circle")
radar_outline.Filled = false
radar_outline.Thickness = 1
radar_outline.NumSides = 100
radar_outline.Radius = RadarSettings.Radius
radar_outline.Color = Color3.fromRGB(80, 80, 90)
radar_outline.Transparency = 1
radar_outline.Visible = RadarSettings.Enabled
radar_outline.ZIndex = 991
table.insert(RuntimeState.Drawings, radar_outline)

local radar_cross_h = Drawing.new("Line")
radar_cross_h.Color = Color3.fromRGB(70, 70, 80)
radar_cross_h.Thickness = 1
radar_cross_h.Transparency = 0.7
radar_cross_h.Visible = RadarSettings.Enabled
radar_cross_h.ZIndex = 991
table.insert(RuntimeState.Drawings, radar_cross_h)

local radar_cross_v = Drawing.new("Line")
radar_cross_v.Color = Color3.fromRGB(70, 70, 80)
radar_cross_v.Thickness = 1
radar_cross_v.Transparency = 0.7
radar_cross_v.Visible = RadarSettings.Enabled
radar_cross_v.ZIndex = 991
table.insert(RuntimeState.Drawings, radar_cross_v)

local radar_self = Drawing.new("Circle")
radar_self.Filled = true
radar_self.Thickness = 1
radar_self.NumSides = 100
radar_self.Radius = RadarSettings.SelfDotSize
radar_self.Color = Color3.fromRGB(245, 245, 245)
radar_self.Transparency = 1
radar_self.Visible = RadarSettings.Enabled
radar_self.ZIndex = 992
table.insert(RuntimeState.Drawings, radar_self)

local radar_dots = {}

local ExpectedArguments = {
    FindPartOnRayWithIgnoreList = {
        ArgCountRequired = 3,
        Args = {
            "Instance", "Ray", "table", "boolean", "boolean"
        }
    },
    FindPartOnRayWithWhitelist = {
        ArgCountRequired = 3,
        Args = {
            "Instance", "Ray", "table", "boolean"
        }
    },
    FindPartOnRay = {
        ArgCountRequired = 2,
        Args = {
            "Instance", "Ray", "Instance", "boolean", "boolean"
        }
    },
    Raycast = {
        ArgCountRequired = 3,
        Args = {
            "Instance", "Vector3", "Vector3", "RaycastParams"
        }
    }
}

function CalculateChance(Percentage)
    -- // Floor the percentage
    Percentage = math.floor(Percentage)

    -- // Get the chance
    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100

    -- // Return
    return chance <= Percentage / 100
end

local function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then
        return false
    end
    for Pos, Argument in next, Args do
        if typeof(Argument) == RayMethod.Args[Pos] then
            Matches = Matches + 1
        end
    end
    return Matches >= RayMethod.ArgCountRequired
end

local function getDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end

local function getMousePosition()
    return GetMouseLocation(UserInputService)
end

local function isSilentAimEnabled()
    return SilentAimSettings.Enabled
end

local function isFovVisible()
    return SilentAimSettings.FOVVisible
end

local function isTargetVisible()
    return SilentAimSettings.ShowSilentAimTarget
end

local function getTargetPartName()
    return SilentAimSettings.TargetPart
end

local function getMethod()
    return SilentAimSettings.SilentAimMethod
end

local function syncVisualState()
    mouse_box.Visible = isSilentAimEnabled() and isTargetVisible()
    fov_circle.Visible = isFovVisible()
    fov_circle.Radius = SilentAimSettings.FOVRadius
    PredictionAmount = SilentAimSettings.MouseHitPredictionAmount
end

local function getCharacterRoot(character)
    if not character then
        return nil
    end

    return FindFirstChild(character, "HumanoidRootPart")
        or FindFirstChild(character, "UpperTorso")
        or FindFirstChild(character, "Torso")
end

local function getRadarDot(player)
    local dot = radar_dots[player]
    if dot then
        return dot
    end

    dot = Drawing.new("Circle")
    dot.Filled = true
    dot.Thickness = 1
    dot.NumSides = 100
    dot.Radius = RadarSettings.DotSize
    dot.Transparency = 1
    dot.Visible = false
    dot.ZIndex = 992
    radar_dots[player] = dot
    table.insert(RuntimeState.Drawings, dot)
    return dot
end

local function removeRadarDot(player)
    local dot = radar_dots[player]
    if not dot then
        return
    end

    radar_dots[player] = nil
    local drawIndex = table.find(RuntimeState.Drawings, dot)
    if drawIndex then
        table.remove(RuntimeState.Drawings, drawIndex)
    end
    pcall(function()
        dot:Remove()
    end)
end

table.insert(RuntimeState.Connections, Players.PlayerRemoving:Connect(removeRadarDot))

local function updateRadar()
    if not RadarSettings.Enabled then
        radar_background.Visible = false
        radar_outline.Visible = false
        radar_cross_h.Visible = false
        radar_cross_v.Visible = false
        radar_self.Visible = false

        for _, dot in pairs(radar_dots) do
            dot.Visible = false
        end
        return
    end

    local character = LocalPlayer.Character
    local root = getCharacterRoot(character)
    if not root then
        radar_background.Visible = false
        radar_outline.Visible = false
        radar_cross_h.Visible = false
        radar_cross_v.Visible = false
        radar_self.Visible = false

        for _, dot in pairs(radar_dots) do
            dot.Visible = false
        end
        return
    end

    local center = Vector2.new(RadarSettings.Anchor.X, Camera.ViewportSize.Y - RadarSettings.Anchor.Y)
    local radius = RadarSettings.Radius
    local look = Camera.CFrame.LookVector
    local yaw = math.atan2(look.X, look.Z)
    local sinYaw = math.sin(-yaw)
    local cosYaw = math.cos(-yaw)

    radar_background.Visible = true
    radar_outline.Visible = true
    radar_cross_h.Visible = true
    radar_cross_v.Visible = true
    radar_self.Visible = true

    radar_background.Position = center
    radar_background.Radius = radius
    radar_outline.Position = center
    radar_outline.Radius = radius
    radar_cross_h.From = Vector2.new(center.X - radius, center.Y)
    radar_cross_h.To = Vector2.new(center.X + radius, center.Y)
    radar_cross_v.From = Vector2.new(center.X, center.Y - radius)
    radar_cross_v.To = Vector2.new(center.X, center.Y + radius)
    radar_self.Position = center
    radar_self.Radius = RadarSettings.SelfDotSize

    local localTeam = LocalPlayer.Team
    local localPos = root.Position

    for _, player in ipairs(GetPlayers(Players)) do
        if player == LocalPlayer then
            continue
        end

        local dot = getRadarDot(player)
        local character = player.Character
        local targetRoot = getCharacterRoot(character)
        local humanoid = character and FindFirstChild(character, "Humanoid")

        if not character or not targetRoot or not humanoid or humanoid.Health <= 0 then
            dot.Visible = false
            continue
        end

        if SilentAimSettings.TeamCheck and localTeam and player.Team == localTeam then
            dot.Visible = false
            continue
        end

        local delta = targetRoot.Position - localPos
        local rel = Vector2.new(delta.X, -delta.Z)

        if RadarSettings.Rotate then
            rel = Vector2.new(
                rel.X * cosYaw - rel.Y * sinYaw,
                rel.X * sinYaw + rel.Y * cosYaw
            )
        end

        local dist = rel.Magnitude
        if dist <= 0 then
            dot.Visible = false
            continue
        end

        if dist > RadarSettings.Range then
            if not RadarSettings.ShowOffscreen then
                dot.Visible = false
                continue
            end

            rel = rel.Unit * RadarSettings.Range
        end

        local finalPos = center + (rel / RadarSettings.Range) * radius
        dot.Position = finalPos
        dot.Radius = RadarSettings.DotSize
        dot.Color = (player.Team and localTeam and player.Team == localTeam) and Color3.fromRGB(54, 57, 241)
            or Color3.fromRGB(255, 80, 80)
        dot.Transparency = (SilentAimSettings.VisibleCheck and not IsPlayerVisible(player)) and 0.35 or 1
        dot.Visible = true
    end
end

local function getToggleKeyCode()
    return Enum.KeyCode[SilentAimSettings.ToggleKey]
end

local function IsPlayerVisible(Player)
    local PlayerCharacter = Player.Character
    local LocalPlayerCharacter = LocalPlayer.Character
    
    if not PlayerCharacter or not LocalPlayerCharacter then return end 
    
    local PlayerRoot = FindFirstChild(PlayerCharacter, getTargetPartName()) or FindFirstChild(PlayerCharacter, "HumanoidRootPart")
    
    if not PlayerRoot then return end 
    
    local CastPoints, IgnoreList = {PlayerRoot.Position, LocalPlayerCharacter, PlayerCharacter}, {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringObjects = #GetPartsObscuringTarget(Camera, CastPoints, IgnoreList)
    
    return ((ObscuringObjects == 0 and true) or (ObscuringObjects > 0 and false))
end

local function getClosestPlayer()
    if not getTargetPartName() then return end
    local Closest
    local DistanceToMouse
    for _, Player in next, GetPlayers(Players) do
        if Player == LocalPlayer then continue end
        if SilentAimSettings.TeamCheck and Player.Team == LocalPlayer.Team then continue end

        local Character = Player.Character
        if not Character then continue end
        
        if SilentAimSettings.VisibleCheck and not IsPlayerVisible(Player) then continue end

        local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart")
        local Humanoid = FindFirstChild(Character, "Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end

        local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)
        if not OnScreen then continue end

        local Distance = (getMousePosition() - ScreenPosition).Magnitude
        if Distance <= (DistanceToMouse or SilentAimSettings.FOVRadius or 2000) then
            local targetPartName = getTargetPartName()
            if targetPartName == "Random" then
                Closest = Character[ValidTargetParts[math.random(1, #ValidTargetParts)]]
            else
                Closest = Character[targetPartName]
            end
            DistanceToMouse = Distance
        end
    end
    return Closest
end

syncVisualState()

table.insert(RuntimeState.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if Global.__test_lua_state ~= RuntimeState then return end
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    local toggleKey = getToggleKeyCode()
    if toggleKey and input.KeyCode == toggleKey then
        SilentAimSettings.Enabled = not SilentAimSettings.Enabled
        syncVisualState()
    end
end))

coroutine.resume(coroutine.create(function()
    table.insert(RuntimeState.Connections, RenderStepped:Connect(function()
        if Global.__test_lua_state ~= RuntimeState then return end
        local ClosestPlayer = getClosestPlayer()

        if isTargetVisible() and isSilentAimEnabled() then
            if ClosestPlayer then 
                local Root = ClosestPlayer.Parent.PrimaryPart or ClosestPlayer
                local RootToViewportPoint, IsOnScreen = WorldToViewportPoint(Camera, Root.Position);
                -- using PrimaryPart instead because if your Target Part is "Random" it will flicker the square between the Target's Head and HumanoidRootPart (its annoying)
                
                mouse_box.Visible = IsOnScreen
                mouse_box.Position = Vector2.new(RootToViewportPoint.X, RootToViewportPoint.Y)
            else 
                mouse_box.Visible = false 
                mouse_box.Position = Vector2.new()
            end
        else
            mouse_box.Visible = false
        end
        
        if isFovVisible() then 
            fov_circle.Visible = true
            fov_circle.Position = getMousePosition()
        else
            fov_circle.Visible = false
        end

        updateRadar()
    end))
end))

-- hooks
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    if Global.__test_lua_state ~= RuntimeState then
        return oldNamecall(...)
    end

    local Method = getnamecallmethod()
    local Arguments = {...}
    local self = Arguments[1]
    local chance = CalculateChance(SilentAimSettings.HitChance)
    if isSilentAimEnabled() and self == workspace and not checkcaller() and chance == true then
        if Method == "FindPartOnRayWithIgnoreList" and getMethod() == Method then
            if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithIgnoreList) then
                local A_Ray = Arguments[2]

                local HitPart = getClosestPlayer()
                if HitPart then
                    local Origin = A_Ray.Origin
                    local Direction = getDirection(Origin, HitPart.Position)
                    Arguments[2] = Ray.new(Origin, Direction)

                    return oldNamecall(unpack(Arguments))
                end
            end
        elseif Method == "FindPartOnRayWithWhitelist" and getMethod() == Method then
            if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithWhitelist) then
                local A_Ray = Arguments[2]

                local HitPart = getClosestPlayer()
                if HitPart then
                    local Origin = A_Ray.Origin
                    local Direction = getDirection(Origin, HitPart.Position)
                    Arguments[2] = Ray.new(Origin, Direction)

                    return oldNamecall(unpack(Arguments))
                end
            end
        elseif (Method == "FindPartOnRay" or Method == "findPartOnRay") and getMethod():lower() == Method:lower() then
            if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRay) then
                local A_Ray = Arguments[2]

                local HitPart = getClosestPlayer()
                if HitPart then
                    local Origin = A_Ray.Origin
                    local Direction = getDirection(Origin, HitPart.Position)
                    Arguments[2] = Ray.new(Origin, Direction)

                    return oldNamecall(unpack(Arguments))
                end
            end
        elseif Method == "Raycast" and getMethod() == Method then
            if ValidateArguments(Arguments, ExpectedArguments.Raycast) then
                local A_Origin = Arguments[2]

                local HitPart = getClosestPlayer()
                if HitPart then
                    Arguments[3] = getDirection(A_Origin, HitPart.Position)

                    return oldNamecall(unpack(Arguments))
                end
            end
        end
    end
    return oldNamecall(...)
end))

local oldIndex = nil 
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Index)
    if Global.__test_lua_state ~= RuntimeState then
        return oldIndex(self, Index)
    end

    if self ~= Mouse or checkcaller() or not isSilentAimEnabled() or getMethod() ~= "Mouse.Hit/Target" then
        return oldIndex(self, Index)
    end

    if Index == "X" or Index == "x" or Index == "Y" or Index == "y" then
        return oldIndex(self, Index)
    end

    if Index ~= "Target" and Index ~= "target" and Index ~= "Hit" and Index ~= "hit" and Index ~= "UnitRay" then
        return oldIndex(self, Index)
    end

    local HitPart = getClosestPlayer()
    if not HitPart then
        return oldIndex(self, Index)
    end

    if Index == "Target" or Index == "target" then 
        return HitPart
    elseif Index == "Hit" or Index == "hit" then 
        return ((SilentAimSettings.MouseHitPrediction and (HitPart.CFrame + (HitPart.Velocity * PredictionAmount))) or HitPart.CFrame)
    elseif Index == "UnitRay" then
        local Origin = oldIndex(self, "Origin")
        local HitPosition = (SilentAimSettings.MouseHitPrediction and (HitPart.Position + (HitPart.Velocity * PredictionAmount))) or HitPart.Position
        return Ray.new(Origin, (HitPosition - Origin).Unit)
    end

    return oldIndex(self, Index)
end))

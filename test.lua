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

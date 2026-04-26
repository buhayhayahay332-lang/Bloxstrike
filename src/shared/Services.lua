local function getService(name)
    local service = game:GetService(name)

    if cloneref then
        local ok, cloned = pcall(cloneref, service)
        if ok and cloned then
            return cloned
        end
    end

    return service
end

return {
    Players = getService("Players"),
    Workspace = getService("Workspace"),
    RunService = getService("RunService"),
    TweenService = getService("TweenService"),
    ContextActionService = getService("ContextActionService"),
    UserInputService = getService("UserInputService"),
    ReplicatedStorage = getService("ReplicatedStorage"),
    Lighting = getService("Lighting"),
}

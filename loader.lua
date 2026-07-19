local DEFAULT_BASE_URL = "https://raw.githubusercontent.com/buhayhayahay332-lang/Bloxstrike/main"
local WHITELIST_URL = "https://raw.githubusercontent.com/PLU3t0/Meathead/main/Bloxstrike/whitelist.lua"

local function getFileName(path)
    local text = tostring(path or "")
    return text:match("([^/\\]+)$") or text
end

local function getHttpGet()
    if syn and syn.request then
        return function(url)
            local response = syn.request({ Url = url, Method = "GET" })
            return response and response.Body
        end
    end

    if http and http.request then
        return function(url)
            local response = http.request({ Url = url, Method = "GET" })
            return response and response.Body
        end
    end

    if game and game.HttpGet then
        return function(url)
            return game:HttpGet(url)
        end
    end

    error("No HTTP request function is available in this executor.")
end

local function getGuiParent()
    local players = game:GetService("Players")
    local coreGui = game:GetService("CoreGui")
    local localPlayer = players.LocalPlayer
    local parent = (gethui and gethui()) or coreGui

    local ok = pcall(function()
        local probe = Instance.new("ScreenGui")
        probe.Parent = coreGui
        probe:Destroy()
    end)

    if not ok and localPlayer then
        parent = localPlayer:WaitForChild("PlayerGui")
    end

    return parent
end

local function createLoadingOverlay(message)
    local guiParent = getGuiParent()
    local existing = guiParent:FindFirstChild("BLOXTRIKE_BOOTSTRAP_LOADING")
    if existing then
        existing:Destroy()
    end

    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "BLOXTRIKE_BOOTSTRAP_LOADING"
    loadingGui.ResetOnSpawn = false
    loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadingGui.DisplayOrder = 2147483647
    loadingGui.Parent = guiParent

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.new(0, 360, 0, 92)
    card.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    card.BackgroundTransparency = 0.15
    card.BorderSizePixel = 0
    card.Parent = loadingGui

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 12)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(65, 65, 65)
    cardStroke.Thickness = 1
    cardStroke.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 16, 0, 16)
    titleLabel.Size = UDim2.new(1, -32, 0, 20)
    titleLabel.Text = "Bloxtrike"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card

    local statusLabel = Instance.new("TextLabel")
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 16, 0, 42)
    statusLabel.Size = UDim2.new(1, -32, 0, 34)
    statusLabel.Text = tostring(message or "Loading Bloxtrike...")
    statusLabel.TextColor3 = Color3.fromRGB(205, 205, 205)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextYAlignment = Enum.TextYAlignment.Top
    statusLabel.Parent = card

    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(loadingGui)
        elseif protect_gui then
            protect_gui(loadingGui)
        end
    end)

    return {
        gui = loadingGui,
        setText = function(text)
            if statusLabel and statusLabel.Parent then
                statusLabel.Text = tostring(text or "Loading Bloxtrike...")
            end
        end,
        dismiss = function()
            if loadingGui and loadingGui.Parent then
                loadingGui:Destroy()
            end
        end,
    }
end

local function kickOnFatal(err)
    local detailedMessage = "[Bloxtrike] Loader error: " .. tostring(err)
    local firstLine = tostring(err or ""):match("([^\r\n]+)") or tostring(err or "")
    firstLine = firstLine:gsub("[^\32-\126]", "?")
    firstLine = firstLine:gsub("%s+", " ")
    firstLine = firstLine:gsub("^%s+", ""):gsub("%s+$", "")
    if #firstLine > 120 then
        firstLine = firstLine:sub(1, 117) .. "..."
    end

    local shortMessage = "[Bloxtrike] Loader error"
    if firstLine ~= "" then
        shortMessage = shortMessage .. " | " .. firstLine
    end
    warn(detailedMessage)

    local players = game and game:GetService("Players")
    local player = players and players.LocalPlayer
    if player then
        pcall(function()
            player:Kick(shortMessage)
        end)
    end

    error(shortMessage, 0)
end

local function kickUnsupported(missing)
    local shortMessage = "[Bloxtrike] Executor doesn't support required functions"
    if type(missing) == "table" and #missing > 0 then
        shortMessage = shortMessage .. " | " .. table.concat(missing, ", ")
    end

    local players = game and game:GetService("Players")
    local player = players and players.LocalPlayer
    if player then
        pcall(function()
            player:Kick(shortMessage)
        end)
    end

    error(shortMessage, 0)
end

local function getExecutorName()
    if type(identifyexecutor) == "function" then
        local ok, name = pcall(identifyexecutor)
        if ok and type(name) == "string" and name ~= "" then
            return name
        end
    end

    if type(getexecutorname) == "function" then
        local ok, name = pcall(getexecutorname)
        if ok and type(name) == "string" and name ~= "" then
            return name
        end
    end

    return "Unknown"
end

local function kickDenied(reason)
    local message = "[Bloxtrike] Executor not whitelisted, Contact Dev for ur Executor to Whitelist"
    if type(reason) == "string" and reason ~= "" then
        message = message .. " | " .. reason
    end

    local players = game:GetService("Players")
    local player = players.LocalPlayer
    if player then
        pcall(function()
            player:Kick(message)
        end)
    end

    error(message, 0)
end

local function runExecutorWhitelist(httpGet)
    local body = httpGet(WHITELIST_URL)
    assert(type(body) == "string" and body ~= "", "Failed to fetch whitelist.lua")

    local chunk = assert(loadstring(body, "@loader/whitelist.lua"))
    local whitelist = chunk()
    assert(type(whitelist) == "table", "whitelist.lua must return a table")

    local executorName = getExecutorName()
    for _, allowedName in ipairs(whitelist) do
        if tostring(allowedName):lower() == executorName:lower() then
            return
        end
    end

    kickDenied(executorName)
end

local function collectMissingSupport()
    local missing = {}

    if type(loadstring) ~= "function" then
        missing[#missing + 1] = "loadstring"
    end

    if type(cloneref) ~= "function" then
        missing[#missing + 1] = "cloneref"
    end

    local hasHttpSupport = (syn and type(syn.request) == "function")
        or (http and type(http.request) == "function")
        or (game and type(game.HttpGet) == "function")
    if not hasHttpSupport then
        missing[#missing + 1] = "HTTP"
    end

    if not (Drawing and type(Drawing.new) == "function") then
        missing[#missing + 1] = "Drawing.new"
    end

    if type(mousemoverel) ~= "function" then
        missing[#missing + 1] = "mousemoverel"
    end

    if type(mouse1click) ~= "function" then
        missing[#missing + 1] = "mouse1click"
    end

    if type(hookfunction) ~= "function" then
        missing[#missing + 1] = "hookfunction"
    end

    if type(getgc) ~= "function" then
        missing[#missing + 1] = "getgc"
    end

    if type(isfolder) ~= "function" then
        missing[#missing + 1] = "isfolder"
    end

    if type(makefolder) ~= "function" then
        missing[#missing + 1] = "makefolder"
    end

    if type(isfile) ~= "function" then
        missing[#missing + 1] = "isfile"
    end

    if type(readfile) ~= "function" then
        missing[#missing + 1] = "readfile"
    end

    if type(writefile) ~= "function" then
        missing[#missing + 1] = "writefile"
    end

    if type(listfiles) ~= "function" then
        missing[#missing + 1] = "listfiles"
    end

    if type(delfile) ~= "function" then
        missing[#missing + 1] = "delfile"
    end

    return missing
end

assert(type(DEFAULT_BASE_URL) == "string" and DEFAULT_BASE_URL ~= "", "DEFAULT_BASE_URL must not be empty")

local missingSupport = collectMissingSupport()
if #missingSupport > 0 then
    kickUnsupported(missingSupport)
end

local httpGet = getHttpGet()
runExecutorWhitelist(httpGet)
local loadingOverlay = createLoadingOverlay("Fetching script files...")
local files = {
    "main.lua",
    "ui_lib.lua",
    "src/shared/Cleaner.lua",
    "src/shared/ErrorHandler.lua",
    "src/shared/Services.lua",
    "src/shared/Globals.lua",
    "src/features/combat/Aimbot.lua",
    "src/features/combat/TriggerBot.lua",
    "src/features/combat/Hitbox.lua",
    "src/features/combat/Rage.lua",
    "src/features/movement/BunnyHop.lua",
    "src/features/skins/Skinchanger.lua",
    "src/features/visuals/ESP.lua",
    "src/features/visuals/Chams.lua",
    --"src/features/visuals/BulletTracers.lua",
    --"src/features/visuals/ParticleEffects.lua",
    "src/features/visuals/KillEffects.lua",
    "src/features/visuals/WorldEffects.lua",
}


local ok, result = xpcall(function()
    local sources = {}
    for index, relativePath in ipairs(files) do
        local fileName = getFileName(relativePath)
        loadingOverlay.setText(string.format("Fetching %s (%d/%d)...", fileName, index, #files))
        local url = DEFAULT_BASE_URL .. "/" .. relativePath
        local body = httpGet(url)
        assert(type(body) == "string" and body ~= "", "Failed to fetch: " .. fileName)
        local lowered = body:sub(1, 256):lower()
        assert(not lowered:find("<!doctype html>", 1, true), "Non-raw response for: " .. fileName)
        assert(not lowered:find("<html", 1, true), "HTML returned for: " .. fileName)
        assert(body ~= "404: Not Found", "Missing file: " .. fileName)
        sources[relativePath] = body
    end

    loadingOverlay.dismiss()

    local mainChunk = assert(loadstring(sources["main.lua"], "@loader/main.lua"))
    return mainChunk({
        baseUrl = DEFAULT_BASE_URL,
        moduleSources = sources,
    })
end, function(err)
    if debug and debug.traceback then
        return tostring(err) .. "\n" .. debug.traceback()
    end

    return tostring(err)
end)

if not ok then
    pcall(function()
        loadingOverlay.dismiss()
    end)
    kickOnFatal(result)
end

return result

local DEFAULT_BASE_URL = "https://github.com/buhayhayahay332-lang/Bloxstrike"

local function normalizePath(path)
    return tostring(path or ""):gsub("\\", "/")
end

local function sanitizeBaseUrl(url)
    local text = tostring(url or ""):gsub("%s+", "")
    text = text:gsub("#.*$", "")
    text = text:gsub("%?.*$", "")
    text = text:gsub("/+$", "")

    local owner, repo, branch, rest

    owner, repo, branch, rest = text:match("^https://github%.com/([^/]+)/([^/]+)/blob/([^/]+)/(.*)$")
    if owner and repo and branch then
        return "https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/" .. branch .. (rest ~= "" and "/" .. rest or "")
    end

    owner, repo, branch, rest = text:match("^https://github%.com/([^/]+)/([^/]+)/raw/([^/]+)/(.*)$")
    if owner and repo and branch then
        return "https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/" .. branch .. (rest ~= "" and "/" .. rest or "")
    end

    owner, repo, branch, rest = text:match("^https://raw%.githubusercontent%.com/([^/]+)/([^/]+)/([^/]+)/(.*)$")
    if owner and repo and branch then
        return "https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/" .. branch .. (rest ~= "" and "/" .. rest or "")
    end

    owner, repo, branch = text:match("^https://github%.com/([^/]+)/([^/]+)/tree/([^/]+)$")
    if owner and repo and branch then
        return "https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/" .. branch
    end

    owner, repo = text:match("^https://github%.com/([^/]+)/([^/]+)$")
    if owner and repo then
        return "https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/main"
    end

    return text
end

local function joinPath(...)
    local parts = { ... }
    local out = {}

    for _, part in ipairs(parts) do
        local text = normalizePath(part):gsub("^/+", ""):gsub("/+$", "")
        if text ~= "" then
            out[#out + 1] = text
        end
    end

    return table.concat(out, "/")
end

local function getFileName(path)
    local normalized = normalizePath(path)
    return normalized:match("([^/]+)$") or normalized
end

local function getEnv()
    if getgenv then
        return getgenv()
    end

    return _G
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

local env = getEnv()
local baseUrl = sanitizeBaseUrl(env.BloxtrikeBaseUrl or DEFAULT_BASE_URL)
assert(type(baseUrl) == "string" and baseUrl ~= "", "Set getgenv().BloxtrikeBaseUrl before running loader.lua")
assert(baseUrl:find("^https://raw%.githubusercontent%.com/"), "Base URL must resolve to raw.githubusercontent.com")

local httpGet = getHttpGet()
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
        local url = joinPath(baseUrl, relativePath)
        local body = httpGet(url)
        assert(type(body) == "string" and body ~= "", "Failed to fetch: " .. fileName)
        local lowered = body:sub(1, 256):lower()
        assert(not lowered:find("<!doctype html>", 1, true), "Non-raw response for: " .. fileName)
        assert(not lowered:find("<html", 1, true), "HTML returned for: " .. fileName)
        assert(body ~= "404: Not Found", "Missing file: " .. fileName)
        sources[relativePath] = body
    end

    env.BloxtrikeBaseUrl = baseUrl
    env.BloxtrikeModuleSources = sources
    loadingOverlay.dismiss()

    local mainChunk = assert(loadstring(sources["main.lua"], "@loader/main.lua"))
    return mainChunk()
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

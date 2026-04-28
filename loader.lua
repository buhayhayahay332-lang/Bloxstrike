local function decodeBytes(bytes)
    local out = {}
    for index, byte in ipairs(bytes) do
        out[index] = string.char(byte)
    end
    return table.concat(out)
end

local DEFAULT_BUNDLE_URL = decodeBytes({
    104, 116, 116, 112, 115, 58, 47, 47, 114, 97, 119, 46, 103, 105, 116, 104, 117, 98, 117, 115,
    101, 114, 99, 111, 110, 116, 101, 110, 116, 46, 99, 111, 109, 47, 98, 117, 104, 97, 121, 104,
    97, 121, 97, 104, 97, 121, 51, 51, 50, 45, 108, 97, 110, 103, 47, 66, 108, 111, 120, 115, 116,
    114, 105, 107, 101, 47, 109, 97, 105, 110, 47, 66, 108, 111, 120, 116, 114, 105, 107, 101, 47,
    98, 117, 110, 100, 108, 101, 46, 108, 117, 97
})

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

local function createLoadingOverlay()
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
    statusLabel.Text = "Loading, please wait..."
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

local httpGet = getHttpGet()
local loadingOverlay = createLoadingOverlay()

local ok, result = xpcall(function()
    local body = httpGet(DEFAULT_BUNDLE_URL)
    assert(type(body) == "string" and body ~= "", "Failed to fetch bundle")

    local lowered = body:sub(1, 256):lower()
    assert(not lowered:find("<!doctype html>", 1, true), "Non-raw response")
    assert(not lowered:find("<html", 1, true), "HTML returned")
    assert(body ~= "404: Not Found", "Missing bundle")

    loadingOverlay.dismiss()

    local compile = loadstring or load
    assert(type(compile) == "function", "No loadstring/load available")

    local bundleChunk = assert(compile(body, "@loader/bundle.lua"))
    return bundleChunk()
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

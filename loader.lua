local DEFAULT_BASE_URL = ""

local function normalizePath(path)
    return tostring(path or ""):gsub("\\", "/")
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

local function kickOnFatal(err)
    local message = "[Bloxtrike] Loader error: " .. tostring(err)
    warn(message)

    local players = game and game:GetService("Players")
    local player = players and players.LocalPlayer
    if player then
        pcall(function()
            player:Kick(message)
        end)
    end

    error(message, 0)
end

local env = getEnv()
local baseUrl = env.BloxtrikeBaseUrl or DEFAULT_BASE_URL
assert(type(baseUrl) == "string" and baseUrl ~= "", "Set getgenv().BloxtrikeBaseUrl before running loader.lua, or edit DEFAULT_BASE_URL inside loader.lua.")

local httpGet = getHttpGet()
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
    "src/features/visuals/BulletTracers.lua",
    "src/features/visuals/ParticleEffects.lua",
    "src/features/visuals/KillEffects.lua",
    "src/features/visuals/WorldEffects.lua",
}

local ok, result = xpcall(function()
    local sources = {}
    for _, relativePath in ipairs(files) do
        local url = joinPath(baseUrl, relativePath)
        local body = httpGet(url)
        assert(type(body) == "string" and body ~= "", "Failed to fetch: " .. url)
        sources[relativePath] = body
    end

    env.BloxtrikeBaseUrl = baseUrl
    env.BloxtrikeModuleSources = sources

    local mainChunk = assert(loadstring(sources["main.lua"], "@loader/main.lua"))
    return mainChunk()
end, function(err)
    if debug and debug.traceback then
        return tostring(err) .. "\n" .. debug.traceback()
    end

    return tostring(err)
end)

if not ok then
    kickOnFatal(result)
end

return result

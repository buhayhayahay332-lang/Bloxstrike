local bootstrap = ...
if type(bootstrap) ~= "table" then
    bootstrap = {}
end

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

local function getRootPath()
    local source = debug.info and debug.info(1, "s")
    if type(source) == "string" and source ~= "" then
        source = normalizePath(source):gsub("^@", "")
        return source:match("^(.*)/[^/]+$") or "."
    end

    return "."
end

local ROOT = getRootPath()
local moduleCache = {}
local httpGet = (syn and syn.request and function(url)
    local response = syn.request({ Url = url, Method = "GET" })
    return response and response.Body
end) or (http and http.request and function(url)
    local response = http.request({ Url = url, Method = "GET" })
    return response and response.Body
end)

if not httpGet and game and game.HttpGet then
    httpGet = function(url)
        return game:HttpGet(url)
    end
end

local function loadLocal(relativePath)
    local preloadedSources = bootstrap.moduleSources
    local baseUrl = bootstrap.baseUrl
    local cacheKey = relativePath

    if moduleCache[cacheKey] ~= nil then
        return moduleCache[cacheKey]
    end

    local chunk, err = nil, nil
    local source = nil

    if type(preloadedSources) == "table" and type(preloadedSources[relativePath]) == "string" then
        source = preloadedSources[relativePath]
        if loadstring then
            chunk, err = loadstring(source, "@" .. relativePath)
        end
    end

    if not chunk and type(baseUrl) == "string" and baseUrl ~= "" and httpGet then
        local url = joinPath(baseUrl, relativePath)
        local ok, body = pcall(httpGet, url)
        if ok and type(body) == "string" and body ~= "" then
            source = body
            if loadstring then
                chunk, err = loadstring(source, "@" .. url)
            end
        end
    end

    if not chunk and loadfile then
        local path = joinPath(ROOT, relativePath)
        chunk, err = loadfile(path)
    end

    if not chunk and readfile and loadstring then
        local path = joinPath(ROOT, relativePath)
        local ok, contents = pcall(readfile, path)
        if ok and contents then
            chunk, err = loadstring(contents, "@" .. path)
        end
    end

    assert(chunk, err or ("Failed to load module: " .. tostring(relativePath)))

    local result = chunk()
    moduleCache[cacheKey] = result
    return result
end

local Cleaner = loadLocal("src/shared/Cleaner.lua")
local Services = loadLocal("src/shared/Services.lua")
local ErrorHandler = loadLocal("src/shared/ErrorHandler.lua")
local GlobalsFactory = loadLocal("src/shared/Globals.lua")
local UILib = loadLocal("ui_lib.lua")

local Aimbot = loadLocal("src/features/combat/Aimbot.lua")
local TriggerBot = loadLocal("src/features/combat/TriggerBot.lua")
local Hitbox = loadLocal("src/features/combat/Hitbox.lua")
local Rage = loadLocal("src/features/combat/Rage.lua")
local BunnyHop = loadLocal("src/features/movement/BunnyHop.lua")
local ESP = loadLocal("src/features/visuals/ESP.lua")
local Chams = loadLocal("src/features/visuals/Chams.lua")
--local BulletTracers = loadLocal("src/features/visuals/BulletTracers.lua")
--local ParticleEffects = loadLocal("src/features/visuals/ParticleEffects.lua")
local KillEffects = loadLocal("src/features/visuals/KillEffects.lua")
local WorldEffects = loadLocal("src/features/visuals/WorldEffects.lua")
local Skinchanger = loadLocal("src/features/skins/Skinchanger.lua")

local globals = GlobalsFactory(Services)
local errorHandler = ErrorHandler.new(Services)
local context = {
    services = Services,
    globals = globals,
    Cleaner = Cleaner,
    errorHandler = errorHandler,
}

if getgenv and getgenv().BloxtrikeCleanup then
    pcall(getgenv().BloxtrikeCleanup)
end

local appCleaner = Cleaner.new()

local features = {
    aimbot = Aimbot.new(context),
    triggerBot = TriggerBot.new(context),
    hitbox = Hitbox.new(context),
    rage = Rage.new(context),
    bunnyHop = BunnyHop.new(context),
    esp = ESP.new(context),
    chams = Chams.new(context),
   -- bulletTracers = BulletTracers.new(context),
    --particleEffects = ParticleEffects.new(context),
    killEffects = KillEffects.new(context),
    worldEffects = WorldEffects.new(context),
    skinchanger = Skinchanger.new(context),
}

for _, feature in pairs(features) do
    appCleaner:Give(function()
        if feature and feature.Destroy then
            feature:Destroy()
        end
    end)
end

local window = UILib.new("Bloxtrike", Enum.KeyCode.RightShift)
window:setConfigFolder("Bloxtrike")
window:onClose(errorHandler:Wrap("Window Close", function()
    appCleaner:Cleanup()
end))

if getgenv then
    getgenv().BloxtrikeCleanup = function()
        appCleaner:Cleanup()
        if window and window.screenGui and window.screenGui.Parent then
            window.screenGui:Destroy()
        end
    end
end

local combatTab = window:addTab("Combat")
local skinsTab = window:addTab("Skins")
local visualsTab = window:addTab("Visuals")
local configTab = window:addTab("Config")

window:switchTab(combatTab)
window:addSection("Aimbot")
local function safeUi(label, fn)
    return errorHandler:Wrap("UI - " .. label, fn)
end

window:addToggle("Aimbot Enabled", false, safeUi("Aimbot Enabled", function(value)
    features.aimbot:SetEnabled(value)
end))
window:addToggle("Aimbot Team Check", false, safeUi("Aimbot Team Check", function(value)
    features.aimbot:SetTeamCheck(value)
end))
window:addToggle("Aimbot Wall Check", false, safeUi("Aimbot Wall Check", function(value)
    features.aimbot:SetWallCheck(value)
end))
window:addToggle("Aimbot Show FOV", false, safeUi("Aimbot Show FOV", function(value)
    features.aimbot:SetShowFov(value)
end))
window:addSlider("Aimbot FOV Radius", 10, 500, 100, 10, safeUi("Aimbot FOV Radius", function(value)
    features.aimbot:SetFovRadius(value)
end))
window:addSlider("Aimbot Smoothing", 1, 10, 3, 1, safeUi("Aimbot Smoothing", function(value)
    features.aimbot:SetSmoothing(value)
end))

window:addSection("TriggerBot")
window:addToggle("TriggerBot Enabled", false, safeUi("TriggerBot Enabled", function(value)
    features.triggerBot:SetEnabled(value)
end))
window:addSlider("TriggerBot Delay MS", 0, 500, 0, 10, safeUi("TriggerBot Delay MS", function(value)
    features.triggerBot:SetDelayMs(value)
end))

window:addSection("Hitbox")
window:addToggle("Hitbox Enabled", false, safeUi("Hitbox Enabled", function(value)
    features.hitbox:SetEnabled(value)
end))
window:addToggle("Hitbox Team Check", false, safeUi("Hitbox Team Check", function(value)
    features.hitbox:SetTeamCheck(value)
end))
window:addSlider("Hitbox Size", 1, 3, 3, 0.1, safeUi("Hitbox Size", function(value)
    features.hitbox:SetSize(value)
end))
window:addSlider("Hitbox Transparency", 0, 1, 0.5, 0.05, safeUi("Hitbox Transparency", function(value)
    features.hitbox:SetTransparency(value)
end))

window:addSection("Rage")
window:addToggle("Rage Mode", false, safeUi("Rage Mode", function(value)
    features.rage:SetRageMode(value)
end))
--[[
window:addKeybind("Rage Toggle Key", Enum.KeyCode.Unknown, safeUi("Rage Toggle Key", function(value)
    features.rage:SetRageToggleKey(value)
end))
]]
window:addSection("Aimlock")
window:addToggle("Aimlock", false, safeUi("Aimlock", function(value)
    features.rage:SetAimlock(value)
end))
--[[window:addKeybind("Aimlock Toggle Key", Enum.KeyCode.Unknown, safeUi("Aimlock Toggle Key", function(value)
    features.rage:SetAimlockToggleKey(value)
end))
window:addKeybind("Aimlock HoldKey", Enum.UserInputType.MouseButton2, safeUi("Aimlock HoldKey", function(value)
    features.rage:SetAimlockHoldKey(value)
end))]]
window:addDropdown("Aimlock Method", { "Raw Mouse" }, "Raw Mouse", safeUi("Aimlock Method", function(value)
    features.rage:SetAimlockMethod(value)
end))
window:addSlider("Aimlock Fov Size", 10, 1000, 150, 1, safeUi("Aimlock Fov Size", function(value)
    features.rage:SetAimlockFov(value)
end))
window:addSlider("Aim Smoothness", 1, 10, 2, 1, safeUi("Aim Smoothness", function(value)
    features.rage:SetAimSmoothness(value)
end))
window:addSlider("Aim Jitter (Randomize)", 0, 50, 10, 1, safeUi("Aim Jitter (Randomize)", function(value)
    features.rage:SetAimJitter(value)
end))
window:addToggle("FlickBOT", false, safeUi("FlickBOT", function(value)
    features.rage:SetFlickBot(value)
end))
window:addSection("Silent Aim")
window:addToggle("Silent Aim", false, safeUi("Silent Aim", function(value)
    features.rage:SetSilentAim(value)
end))
window:addToggle("Ignore Walls / Wallbang", false, safeUi("Ignore Walls / Wallbang", function(value)
    features.rage:SetWallbang(value)
end))
--[[window:addKeybind("Wallbang Toggle Key", Enum.KeyCode.Unknown, safeUi("Wallbang Toggle Key", function(value)
    features.rage:SetWallbangToggleKey(value)
end))
window:addKeybind("Silent Aim Toggle Key", Enum.KeyCode.Unknown, safeUi("Silent Aim Toggle Key", function(value)
    features.rage:SetSilentAimToggleKey(value)
end))]]
window:addToggle("Dynamic Miss (Hit Chance)", false, safeUi("Dynamic Miss (Hit Chance)", function(value)
    features.rage:SetDynamicMiss(value)
end))
window:addSlider("Hit Chance %", 1, 100, 100, 1, safeUi("Hit Chance %", function(value)
    features.rage:SetBaseHitChance(value)
end))
window:addToggle("Show Circle", false, safeUi("Show Circle", function(value)
    features.rage:SetShowFovCircle(value)
end))
window:addSlider("Fov Size", 50, 1000, 150, 1, safeUi("Fov Size", function(value)
    features.rage:SetFovSize(value)
end))
window:addSection("Targeting")
window:addDropdown("TargetPart", features.rage:GetTargetParts(), features.rage:GetTargetPart(), safeUi("TargetPart", function(value)
    features.rage:SetTargetPart(value)
end))
window:addToggle("Random Part", false, safeUi("Random Part", function(value)
    features.rage:SetRandomPart(value)
end))
window:addToggle("360 FOV (All Directions)", false, safeUi("360 FOV (All Directions)", function(value)
    features.rage:SetFullFov360(value)
end))
window:addToggle("AimWall Check", true, safeUi("AimWall Check", function(value)
    features.rage:SetAimWallCheck(value)
end))
window:addToggle("TeamCheck", true, safeUi("TeamCheck", function(value)
    features.rage:SetTeamCheck(value)
end))
window:addSection("Weapon Mods")
window:addToggle("Memory No Recoil", false, safeUi("Memory No Recoil", function(value)
    features.rage:SetMemoryNoRecoil(value)
end))
window:addToggle("No Spread", false, safeUi("No Spread", function(value)
    features.rage:SetNoSpread(value)
end))
window:addToggle("Auto Clicker (Hold LMB)", false, safeUi("Auto Clicker (Hold LMB)", function(value)
    features.rage:SetAutoClicker(value)
end))
window:addSlider("Auto Click Delay (ms)", 10, 500, 50, 1, safeUi("Auto Click Delay (ms)", function(value)
    features.rage:SetAutoClickDelay(value)
end))
window:addToggle("Instant Reload", false, safeUi("Instant Reload", function(value)
    features.rage:SetInstantReload(value)
end))
window:addToggle("Insta Equip", false, safeUi("Insta Equip", function(value)
    features.rage:SetInstaEquip(value)
end))
window:addToggle("RCS", false, safeUi("RCS", function(value)
    features.rage:SetRcs(value)
end))
window:addSlider("RCS Strength", 0, 100, 50, 1, safeUi("RCS Strength", function(value)
    features.rage:SetRcsStrength(value)
end))
window:addSlider("RCS Delay", 0, 500, 0, 1, safeUi("RCS Delay", function(value)
    features.rage:SetRcsDelay(value)
end))

window:addSection("Movement")
window:addToggle("Bunny Hop Enabled", false, safeUi("Bunny Hop Enabled", function(value)
    features.bunnyHop:SetEnabled(value)
end))

window:switchTab(skinsTab)
window:addSection("Skin Changer")
window:addToggle("Weapon Skin Changer Enabled", false, safeUi("Weapon Skin Changer Enabled", function(value)
    features.skinchanger:SetSkinChangerEnabled(value)
end))
window:addToggle("Knife Changer Enabled", false, safeUi("Knife Changer Enabled", function(value)
    features.skinchanger:SetKnifeChangerEnabled(value)
end))

local knifeModels = features.skinchanger:GetKnifeModels()
local knifeSkinDropdown
local knifeModelDropdown = window:addDropdown(
    "Knife Model",
    knifeModels,
    features.skinchanger:GetKnifeModel(),
    safeUi("Knife Model", function(value)
        features.skinchanger:SetKnifeModel(value)
        if knifeSkinDropdown then
            local knifeModel = features.skinchanger:GetKnifeModel()
            knifeSkinDropdown.refresh(features.skinchanger:GetSkinOptions(knifeModel))
            knifeSkinDropdown.set(features.skinchanger:GetWeaponSkin(knifeModel))
        end
    end)
)

knifeSkinDropdown = window:addDropdown(
    "Knife Skin",
    features.skinchanger:GetSkinOptions(features.skinchanger:GetKnifeModel()),
    features.skinchanger:GetWeaponSkin(features.skinchanger:GetKnifeModel()),
    safeUi("Knife Skin", function(value)
        features.skinchanger:SetWeaponSkin(features.skinchanger:GetKnifeModel(), value)
    end)
)

local function refreshKnifeSkinDropdown()
    local knifeModel = features.skinchanger:GetKnifeModel()
    knifeSkinDropdown.refresh(features.skinchanger:GetSkinOptions(knifeModel))
    knifeSkinDropdown.set(features.skinchanger:GetWeaponSkin(knifeModel))
end

local function queueSkinchangerConfigSync()
    task.spawn(function()
        task.wait(0.05)
        pcall(refreshKnifeSkinDropdown)
        pcall(function()
            features.skinchanger:ApplyNow()
        end)
        task.wait(0.35)
        pcall(function()
            features.skinchanger:ApplyNow()
        end)
        task.wait(0.8)
        pcall(function()
            features.skinchanger:ApplyNow()
        end)
    end)
end

knifeModelDropdown.set(features.skinchanger:GetKnifeModel())
refreshKnifeSkinDropdown()

window:addToggle("Glove Changer Enabled", false, safeUi("Glove Changer Enabled", function(value)
    features.skinchanger:SetGloveChangerEnabled(value)
end))

local gloveModels = features.skinchanger:GetGloveModels()
local selectedGloveModel = features.skinchanger:GetGloveModel() or gloveModels[1] or "Default"
local gloveSkinDropdown

local gloveModelDropdown = window:addDropdown(
    "Glove Model",
    gloveModels,
    selectedGloveModel,
    safeUi("Glove Model", function(value)
        features.skinchanger:SetGloveModel(value)
        local skinOptions = features.skinchanger:GetGloveSkinOptions(value)
        if gloveSkinDropdown then
            gloveSkinDropdown.refresh(skinOptions)
            gloveSkinDropdown.set(features.skinchanger:GetGloveSkin(value))
        end
    end)
)

gloveSkinDropdown = window:addDropdown(
    "Glove Skin",
    features.skinchanger:GetGloveSkinOptions(selectedGloveModel),
    features.skinchanger:GetGloveSkin(selectedGloveModel),
    safeUi("Glove Skin", function(value)
        features.skinchanger:SetGloveSkin(value)
    end)
)

window:addSlider("Skin Inventory Refresh Rate", 1, 10, 2, 1, safeUi("Skin Inventory Refresh Rate", function(value)
    features.skinchanger:SetInventoryRefreshRate(value)
end))
window:addButton("Apply Skin Changes", safeUi("Apply Skin Changes", function()
    features.skinchanger:ApplyNow()
    refreshKnifeSkinDropdown()
end))

window:addSection("Weapon Skins")
for _, weaponName in ipairs(features.skinchanger:GetWeaponNames()) do
    if not features.skinchanger:IsKnifeModel(weaponName) then
        window:addDropdown(
            "Skin - " .. weaponName,
            features.skinchanger:GetSkinOptions(weaponName),
            features.skinchanger:GetWeaponSkin(weaponName),
            safeUi("Skin - " .. weaponName, function(value)
                features.skinchanger:SetWeaponSkin(weaponName, value)
            end)
        )
    end
end

window:switchTab(visualsTab)
window:addSection("ESP")
window:addToggle("ESP Enabled", false, safeUi("ESP Enabled", function(value)
    features.esp:SetSetting("enabled", value)
end))
window:addToggle("ESP Team Check", false, safeUi("ESP Team Check", function(value)
    features.esp:SetSetting("teamCheck", value)
end))
window:addToggle("ESP Show Box", false, safeUi("ESP Show Box", function(value)
    features.esp:SetSetting("showBox", value)
end))
window:addToggle("ESP Show Health", false, safeUi("ESP Show Health", function(value)
    features.esp:SetSetting("showHealth", value)
end))
window:addToggle("ESP Show Name", false, safeUi("ESP Show Name", function(value)
    features.esp:SetSetting("showName", value)
end))
window:addToggle("ESP Show Distance", false, safeUi("ESP Show Distance", function(value)
    features.esp:SetSetting("showDistance", value)
end))
window:addToggle("ESP Show Skeleton", false, safeUi("ESP Show Skeleton", function(value)
    features.esp:SetSetting("showSkeleton", value)
end))
window:addToggle("ESP Show Head Dot", false, safeUi("ESP Show Head Dot", function(value)
    features.esp:SetSetting("showHeadDot", value)
end))
window:addToggle("ESP Show Tracers", false, safeUi("ESP Show Tracers", function(value)
    features.esp:SetSetting("showTracers", value)
end))
window:addToggle("ESP Rainbow", false, safeUi("ESP Rainbow", function(value)
    features.esp:SetSetting("rainbow", value)
end))
window:addSlider("ESP Rainbow Speed", 0.1, 10, 2, 0.1, safeUi("ESP Rainbow Speed", function(value)
    features.esp:SetSetting("rainbowSpeed", value)
end))
window:addSlider("ESP Text Size", 10, 20, 15, 1, safeUi("ESP Text Size", function(value)
    features.esp:SetSetting("textSize", value)
end))
window:addSlider("ESP Box Thickness", 1, 3, 1.5, 0.1, safeUi("ESP Box Thickness", function(value)
    features.esp:SetSetting("boxThickness", value)
end))
window:addSlider("ESP Max Distance", 0, 500, 0, 10, safeUi("ESP Max Distance", function(value)
    features.esp:SetSetting("maxDistance", value)
end))
window:addColorPicker("ESP Box Color", Color3.fromRGB(255, 255, 255), safeUi("ESP Box Color", function(value)
    features.esp:SetSetting("boxColor", value)
end))
window:addColorPicker("ESP Text Color", Color3.fromRGB(255, 255, 255), safeUi("ESP Text Color", function(value)
    features.esp:SetSetting("textColor", value)
end))
window:addColorPicker("ESP Skeleton Color", Color3.fromRGB(255, 255, 255), safeUi("ESP Skeleton Color", function(value)
    features.esp:SetSetting("skeletonColor", value)
end))
window:addColorPicker("ESP Tracer Color", Color3.fromRGB(255, 51, 153), safeUi("ESP Tracer Color", function(value)
    features.esp:SetSetting("tracerColor", value)
end))
window:addColorPicker("ESP Head Dot Color", Color3.fromRGB(255, 255, 255), safeUi("ESP Head Dot Color", function(value)
    features.esp:SetSetting("headDotColor", value)
end))

window:addSection("Chams")
window:addToggle("Chams Rainbow", false, safeUi("Chams Rainbow", function(value)
    features.chams:SetSetting("rainbow", value)
end))
window:addSlider("Chams Rainbow Speed", 0.1, 10, 2, 0.1, safeUi("Chams Rainbow Speed", function(value)
    features.chams:SetSetting("rainbowSpeed", value)
end))
window:addToggle("Player Chams Enabled", false, safeUi("Player Chams Enabled", function(value)
    features.chams:SetSetting("playerEnabled", value)
end))
window:addToggle("Player Chams Team Check", false, safeUi("Player Chams Team Check", function(value)
    features.chams:SetSetting("playerTeamCheck", value)
end))
window:addToggle("Visible Only", false, safeUi("Player Chams Visible Only", function(value)
    features.chams:SetSetting("playerVisibleOnly", value)
end))
window:addSlider("Player Chams Fill", 0, 1, 0.7, 0.05, safeUi("Player Chams Fill", function(value)
    features.chams:SetSetting("playerFillTransparency", value)
end))
window:addSlider("Player Chams Outline", 0, 1, 0, 0.05, safeUi("Player Chams Outline", function(value)
    features.chams:SetSetting("playerOutlineTransparency", value)
end))
window:addColorPicker("Player Chams Color", Color3.fromRGB(255, 0, 0), safeUi("Player Chams Color", function(value)
    features.chams:SetSetting("playerColor", value)
end))
window:addToggle("Weapon Chams Enabled", false, safeUi("Weapon Chams Enabled", function(value)
    features.chams:SetSetting("weaponEnabled", value)
end))
window:addSlider("Weapon Chams Fill", 0, 1, 0.5, 0.05, safeUi("Weapon Chams Fill", function(value)
    features.chams:SetSetting("weaponFillTransparency", value)
end))
window:addSlider("Weapon Chams Outline", 0, 1, 0, 0.05, safeUi("Weapon Chams Outline", function(value)
    features.chams:SetSetting("weaponOutlineTransparency", value)
end))
window:addColorPicker("Weapon Chams Color", Color3.fromRGB(0, 255, 255), safeUi("Weapon Chams Color", function(value)
    features.chams:SetSetting("weaponColor", value)
end))

--[[window:addSection("Bullet Tracers")
window:addToggle("Bullet Tracers Enabled", false, safeUi("Bullet Tracers Enabled", function(value)
    features.bulletTracers:SetSetting("enabled", value)
end))
window:addDropdown("Bullet Tracer Pattern", { "Straight", "Wave", "Spiral", "Dashed" }, "Straight", safeUi("Bullet Tracer Pattern", function(value)
    features.bulletTracers:SetSetting("pattern", value)
end))
window:addSlider("Bullet Tracer Transparency", 0, 1, 0.3, 0.05, safeUi("Bullet Tracer Transparency", function(value)
    features.bulletTracers:SetSetting("transparency", value)
end))
window:addSlider("Bullet Tracer Duration", 0.1, 2, 0.6, 0.1, safeUi("Bullet Tracer Duration", function(value)
    features.bulletTracers:SetSetting("duration", value)
end))
window:addSlider("Bullet Tracer Thickness", 0.1, 1, 0.2, 0.05, safeUi("Bullet Tracer Thickness", function(value)
    features.bulletTracers:SetSetting("thickness", value)
end))
window:addColorPicker("Bullet Tracer Color", Color3.fromRGB(0, 255, 255), safeUi("Bullet Tracer Color", function(value)
    features.bulletTracers:SetSetting("color", value)
end))]]

--[[window:addSection("Particle Effects")
window:addToggle("Particle Effects Enabled", false, safeUi("Particle Effects Enabled", function(value)
    features.particleEffects:SetSetting("enabled", value)
end))
window:addSlider("Particle Amount", 5, 80, 25, 5, safeUi("Particle Amount", function(value)
    features.particleEffects:SetSetting("amount", value)
end))
window:addSlider("Particle Lifetime", 0.3, 3, 1.2, 0.1, safeUi("Particle Lifetime", function(value)
    features.particleEffects:SetSetting("lifetime", value)
end))
window:addDropdown("Particle Style", { "Spark", "Smoke", "Fire", "Explosion", "Magic" }, "Spark", safeUi("Particle Style", function(value)
    features.particleEffects:SetSetting("style", value)
end))
window:addColorPicker("Particle Color", Color3.fromRGB(255, 100, 0), safeUi("Particle Color", function(value)
    features.particleEffects:SetSetting("color", value)
end))]]

window:addSection("Kill Effects")
window:addToggle("Kill Effects Enabled", false, safeUi("Kill Effects Enabled", function(value)
    features.killEffects:SetSetting("enabled", value)
end))
window:addSlider("Kill Effect Duration", 0.3, 2, 0.8, 0.1, safeUi("Kill Effect Duration", function(value)
    features.killEffects:SetSetting("duration", value)
end))
window:addSlider("Kill Effect Intensity", 0.2, 1, 0.6, 0.1, safeUi("Kill Effect Intensity", function(value)
    features.killEffects:SetSetting("intensity", value)
end))
window:addColorPicker("Kill Effect Color", Color3.fromRGB(255, 0, 100), safeUi("Kill Effect Color", function(value)
    features.killEffects:SetSetting("color", value)
end))

window:addSection("World Effects")
window:addToggle("Anti Flash", false, safeUi("Anti Flash", function(value)
    features.worldEffects:SetSetting("antiFlash", value)
end))
window:addToggle("Anti Smoke", false, safeUi("Anti Smoke", function(value)
    features.worldEffects:SetSetting("antiSmoke", value)
end))

do
    local originalLoadConfig = window.loadConfig
    function window:loadConfig(name)
        local ok, err = originalLoadConfig(self, name)
        if ok then
            queueSkinchangerConfigSync()
        end
        return ok, err
    end
end

window:switchTab(configTab)
window:addConfigManager("default")

task.defer(function()
    local okList, configNames = pcall(function()
        return window:listConfigs()
    end)
    if not okList or type(configNames) ~= "table" or #configNames == 0 then
        return
    end

    local selectedConfig = nil
    local latestSavedAt = nil

    for _, configName in ipairs(configNames) do
        local normalizedName = tostring(configName):lower()
        if normalizedName ~= "default" then
            local payload = nil
            pcall(function()
                if window._readJsonFile and window._getConfigFilePath then
                    payload = window:_readJsonFile(window:_getConfigFilePath(configName))
                end
            end)

            local savedAt = type(payload) == "table"
                and type(payload.meta) == "table"
                and payload.meta.saved_at

            if type(savedAt) == "string" and (not latestSavedAt or savedAt > latestSavedAt) then
                latestSavedAt = savedAt
                selectedConfig = configName
            elseif not selectedConfig then
                selectedConfig = configName
            end
        end
    end

    if selectedConfig then
        pcall(function()
            window:loadConfig(selectedConfig)
        end)
    end
end)

window:notify("Bloxtrike", "loaded.", nil, false)

return {
    window = window,
    features = features,
}

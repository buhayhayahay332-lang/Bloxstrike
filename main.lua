warn("lmao1")
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
local startupConfig = "Default"
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

local Aimbot = loadLocal("src/features/combat/Aimbot.lua")
local TriggerBot = loadLocal("src/features/combat/TriggerBot.lua")
local Hitbox = loadLocal("src/features/combat/Hitbox.lua")
local Rage = loadLocal("src/features/combat/Rage.lua")
local Movement = loadLocal("src/features/movement/Movement.lua")
local ESP = loadLocal("src/features/visuals/ESP.lua")
local Chams = loadLocal("src/features/visuals/Chams.lua")
local KillEffects = loadLocal("src/features/visuals/KillEffects.lua")
local WorldVisuals = loadLocal("src/features/visuals/WorldVisuals.lua")
local HazardTracker = loadLocal("src/features/visuals/ThreatVisuals.lua")
local Skinchanger = loadLocal("src/features/skins/Skinchanger.lua")
--local BulletTracers = loadLocal("src/features/visuals/BulletTracers.lua")

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
    movement = Movement.new(context),
    esp = ESP.new(context),
    chams = Chams.new(context),
    killEffects = KillEffects.new(context),
    worldVisuals = WorldVisuals.new(context),
    hazardTracker = HazardTracker.new(context),
    skinchanger = Skinchanger.new(context),
    --bulletTracers = BulletTracers.new(context),
}

for _, feature in pairs(features) do
    appCleaner:Give(function()
        if feature and feature.Destroy then
            feature:Destroy()
        end
    end)
end

local function safeUi(label, fn)
    return errorHandler:Wrap("UI - " .. label, fn)
end

local NeverLose = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/source.luau"))()

local Notification = NeverLose:CreateNotification()
local Logging = NeverLose:CreateLogger()
local Indicator = NeverLose:CreateIndicator()

local window = NeverLose:CreateWindow({
    Logo = "rbxassetid://13129527031",
    Name = "ASTRO.WTF",
    Content = "Bloxtrike",
    Size = NeverLose.Scales.Large,
    ConfigFolder = "Bloxtrike",
    Enable3DRenderer = true,
    Keybind = "RightShift"
})  

if getgenv then
    getgenv().BloxtrikeCleanup = function()
        appCleaner:Cleanup()
        NeverLose.UnloadEnabled = true
        pcall(function() NeverLose:Unload() end)
    end
end

task.defer(function()
    if startupConfig ~= "Default" and isfile and readfile and writefile then
        local configPath = window.ConfigFolder .. "/" .. startupConfig
        local ok, data = pcall(readfile, configPath)
        if ok and type(data) == "string" and data ~= "" then
            pcall(writefile, window.ConfigFolder .. "/Default", data)
        end
    end
end)

local Watermark = window:Watermark()
local discordBlock = Watermark:AddBlock("discord", "discord.gg/NtBMqWXySm")
if discordBlock then
    pcall(function()
        discordBlock.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard("https://discord.gg/NtBMqWXySm")
                Notification.new({ Title = "ASTRO.WTF", Content = "Discord link copied to clipboard!", Duration = 3 })
            end
        end)
    end)
end



window:AddTabLabel('MAIN')
local CombatTab = window:AddTab({ Icon = 'crosshair', Name = "Combat" })
local VisualsTab = window:AddTab({ Icon = 'eye', Name = "Visuals" })

window:AddTabLabel('CUSTOMIZATION')
local SkinsTab = window:AddTab({ Icon = 'sparkles', Name = "Skins" })

window:AddTabLabel('MISC')
local MiscTab = window:AddTab({ Icon = 'backpack', Name = "Misc" })

local AimSection = CombatTab:AddSection({ Name = "AIMBOT", Position = 'left' })
local aimLabel = AimSection:AddLabel("Aimbot")
aimLabel:AddToggle({
    Default = false,
    Callback = safeUi("Aimbot Enabled", function(v) features.aimbot:SetEnabled(v) end),
    Flag = "aimbot_enabled"
})
local aimOptions = aimLabel:AddOption()
aimOptions:AddLabel("Team Check"):AddToggle({ Default = false, Flag = "aimbot_team_check", Callback = safeUi("Aimbot Team Check", function(v) features.aimbot:SetTeamCheck(v) end) })
aimOptions:AddLabel("Wall Check"):AddToggle({ Default = false, Flag = "aimbot_wall_check", Callback = safeUi("Aimbot Wall Check", function(v) features.aimbot:SetWallCheck(v) end) })
aimOptions:AddLabel("Show FOV"):AddToggle({ Default = false, Flag = "aimbot_show_fov", Callback = safeUi("Aimbot Show FOV", function(v) features.aimbot:SetShowFov(v) end) })

AimSection:AddLabel("FOV Radius"):AddSlider({ Min = 10, Max = 500, Default = 100, Step = 10, Flag = "aimbot_fov_radius", Callback = safeUi("Aimbot FOV Radius", function(v) features.aimbot:SetFovRadius(v) end) })
AimSection:AddLabel("Smoothing"):AddSlider({ Min = 1, Max = 10, Default = 3, Step = 1, Flag = "aimbot_smoothing", Callback = safeUi("Aimbot Smoothing", function(v) features.aimbot:SetSmoothing(v) end) })

local TrigSection = CombatTab:AddSection({ Name = "TRIGGERBOT", Position = 'left' })
TrigSection:AddLabel("TriggerBot"):AddToggle({ Default = false, Flag = "triggerbot_enabled", Callback = safeUi("TriggerBot Enabled", function(v) features.triggerBot:SetEnabled(v) end) })
TrigSection:AddLabel("Delay MS"):AddSlider({ Min = 0, Max = 500, Default = 0, Step = 10, Flag = "triggerbot_delay", Callback = safeUi("TriggerBot Delay MS", function(v) features.triggerBot:SetDelayMs(v) end) })

local HitboxSection = CombatTab:AddSection({ Name = "HITBOX", Position = 'left' })
local hbLabel = HitboxSection:AddLabel("Expand Hitboxes")
hbLabel:AddToggle({ Default = false, Flag = "hitbox_enabled", Callback = safeUi("Hitbox Enabled", function(v) features.hitbox:SetEnabled(v) end) })
local hbOpt = hbLabel:AddOption()
hbOpt:AddToggle({ Default = false, Flag = "hitbox_team_check", Callback = safeUi("Hitbox Team Check", function(v) features.hitbox:SetTeamCheck(v) end) })
HitboxSection:AddLabel("Hitbox Size"):AddSlider({ Min = 1, Max = 3, Default = 3, Step = 0.1, Flag = "hitbox_size", Callback = safeUi("Hitbox Size", function(v) features.hitbox:SetSize(v) end) })
HitboxSection:AddLabel("Transparency"):AddSlider({ Min = 0, Max = 1, Default = 0.5, Step = 0.05, Flag = "hitbox_transparency", Callback = safeUi("Hitbox Transparency", function(v) features.hitbox:SetTransparency(v) end) })

local SilentSection = CombatTab:AddSection({ Name = "SILENT AIM", Position = 'right' })
local saLabel = SilentSection:AddLabel("Silent Aim")
saLabel:AddToggle({ Default = false, Flag = "rage_silent_aim", Callback = safeUi("Silent Aim", function(v) features.rage:SetSilentAim(v) end) })
local saOpt = saLabel:AddOption()
saOpt:AddLabel("Wallbang"):AddToggle({ Default = false, Flag = "rage_wallbang", Callback = safeUi("Ignore Walls", function(v) features.rage:SetWallbang(v) end) })
saOpt:AddLabel("Dynamic Miss"):AddToggle({ Default = false, Flag = "rage_dynamic_miss", Callback = safeUi("Dynamic Miss", function(v) features.rage:SetDynamicMiss(v) end) })
saOpt:AddLabel("360 FOV"):AddToggle({ Default = false, Flag = "rage_full_fov", Callback = safeUi("360 FOV", function(v) features.rage:SetFullFov360(v) end) })
saOpt:AddLabel("AimWall Check"):AddToggle({ Default = true, Flag = "rage_wall_check", Callback = safeUi("AimWall Check", function(v) features.rage:SetAimWallCheck(v) end) })
saOpt:AddLabel("Team Check"):AddToggle({ Default = true, Flag = "rage_team_check", Callback = safeUi("TeamCheck", function(v) features.rage:SetTeamCheck(v) end) })
saOpt:AddLabel("Random Part"):AddToggle({ Default = false, Flag = "rage_random_part", Callback = safeUi("Random Part", function(v) features.rage:SetRandomPart(v) end) })

SilentSection:AddLabel("Hit Chance %"):AddSlider({ Min = 1, Max = 100, Default = 100, Step = 1, Flag = "rage_hit_chance", Callback = safeUi("Hit Chance %", function(v) features.rage:SetBaseHitChance(v) end) })
SilentSection:AddLabel("Show FOV Circle"):AddToggle({ Default = false, Flag = "rage_show_fov", Callback = safeUi("Show Circle", function(v) features.rage:SetShowFovCircle(v) end) })
SilentSection:AddLabel("FOV Size"):AddSlider({ Min = 50, Max = 1000, Default = 150, Step = 1, Flag = "rage_fov_size", Callback = safeUi("Fov Size", function(v) features.rage:SetFovSize(v) end) })
SilentSection:AddLabel("Target Part"):AddDropdown({ Values = features.rage:GetTargetParts(), Default = features.rage:GetTargetPart(), Flag = "rage_target_part", Callback = safeUi("TargetPart", function(v) features.rage:SetTargetPart(v) end) })

local WeaponModsSection = CombatTab:AddSection({ Name = "WEAPON MODS", Position = 'right' })
WeaponModsSection:AddLabel("No Recoil"):AddToggle({ Default = false, Flag = "rage_no_recoil", Callback = safeUi("Memory No Recoil", function(v) features.rage:SetMemoryNoRecoil(v) end) })
WeaponModsSection:AddLabel("No Spread"):AddToggle({ Default = false, Flag = "rage_no_spread", Callback = safeUi("No Spread", function(v) features.rage:SetNoSpread(v) end) })
WeaponModsSection:AddLabel("Rapid Fire"):AddToggle({ Default = false, Flag = "rage_rapid_fire", Callback = safeUi("Rapid Fire", function(v) features.rage:SetAutoClicker(v) end) })
WeaponModsSection:AddLabel("Rapid Fire Delay (ms)"):AddSlider({ Min = 1, Max = 500, Default = 50, Step = 1, Flag = "rage_rapid_delay", Callback = safeUi("Rapid Fire Delay", function(v) features.rage:SetAutoClickDelay(v) end) })
WeaponModsSection:AddLabel("Instant Reload"):AddToggle({ Default = false, Flag = "rage_instant_reload", Callback = safeUi("Instant Reload", function(v) features.rage:SetInstantReload(v) end) })
WeaponModsSection:AddLabel("Insta Equip"):AddToggle({ Default = false, Flag = "rage_insta_equip", Callback = safeUi("Insta Equip", function(v) features.rage:SetInstaEquip(v) end) })
WeaponModsSection:AddLabel("Auto Recoil Control (RCS)"):AddToggle({ Default = false, Flag = "rage_rcs", Callback = safeUi("RCS", function(v) features.rage:SetRcs(v) end) })
WeaponModsSection:AddLabel("RCS Strength"):AddSlider({ Min = 0, Max = 100, Default = 50, Step = 1, Flag = "rage_rcs_strength", Callback = safeUi("RCS Strength", function(v) features.rage:SetRcsStrength(v) end) })
WeaponModsSection:AddLabel("RCS Delay"):AddSlider({ Min = 0, Max = 500, Default = 0, Step = 1, Flag = "rage_rcs_delay", Callback = safeUi("RCS Delay", function(v) features.rage:SetRcsDelay(v) end) })


local EspSection = VisualsTab:AddSection({ Name = "PLAYER ESP", Position = 'left' })
local espLabel = EspSection:AddLabel("ESP Enabled")
espLabel:AddToggle({ Default = false, Flag = "esp_enabled", Callback = safeUi("ESP Enabled", function(v) features.esp:SetSetting("enabled", v) end) })
local espOpt = espLabel:AddOption()
espOpt:AddToggle({ Default = false, Flag = "esp_team_check", Callback = safeUi("ESP Team Check", function(v) features.esp:SetSetting("teamCheck", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_box", Callback = safeUi("ESP Show Box", function(v) features.esp:SetSetting("showBox", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_health_bar", Callback = safeUi("ESP Show Health", function(v) features.esp:SetSetting("showHealth", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_names", Callback = safeUi("ESP Show Name", function(v) features.esp:SetSetting("showName", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_distance", Callback = safeUi("ESP Show Distance", function(v) features.esp:SetSetting("showDistance", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_skeleton", Callback = safeUi("ESP Show Skeleton", function(v) features.esp:SetSetting("showSkeleton", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_tracers", Callback = safeUi("ESP Show Tracers", function(v) features.esp:SetSetting("showTracers", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_weapon", Callback = safeUi("ESP Show Weapon", function(v) features.esp:SetSetting("showWeapon", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_money", Callback = safeUi("ESP Show Money", function(v) features.esp:SetSetting("showMoney", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_flags", Callback = safeUi("ESP Show Flags", function(v) features.esp:SetSetting("showFlags", v) end) })
espOpt:AddToggle({ Default = false, Flag = "esp_chams", Callback = safeUi("ESP Show Chams", function(v) features.esp:SetSetting("showChams", v) end) })

EspSection:AddLabel("Text Size"):AddSlider({ Min = 10, Max = 20, Default = 11, Step = 1, Flag = "esp_text_size", Callback = safeUi("ESP Text Size", function(v) features.esp:SetSetting("textSize", v) end) })
EspSection:AddLabel("Box Thickness"):AddSlider({ Min = 1, Max = 3, Default = 1, Step = 0.1, Flag = "esp_box_thickness", Callback = safeUi("ESP Box Thickness", function(v) features.esp:SetSetting("boxThickness", v) end) })
EspSection:AddLabel("Max Distance"):AddSlider({ Min = 0, Max = 500, Default = 0, Step = 10, Flag = "esp_max_distance", Callback = safeUi("ESP Max Distance", function(v) features.esp:SetSetting("maxDistance", v) end) })

local ChamsSection = VisualsTab:AddSection({ Name = "CHAMS", Position = 'left' })
ChamsSection:AddLabel("Rainbow Chams"):AddToggle({ Default = false, Flag = "chams_rainbow", Callback = safeUi("Chams Rainbow", function(v) features.chams:SetSetting("rainbow", v) end) })
ChamsSection:AddLabel("Rainbow Speed"):AddSlider({ Min = 0.1, Max = 10, Default = 2, Step = 0.1, Flag = "chams_rainbow_speed", Callback = safeUi("Chams Rainbow Speed", function(v) features.chams:SetSetting("rainbowSpeed", v) end) })

local pchamsLabel = ChamsSection:AddLabel("Player Chams")
pchamsLabel:AddToggle({ Default = false, Flag = "chams_player_enabled", Callback = safeUi("Player Chams Enabled", function(v) features.chams:SetSetting("playerEnabled", v) end) })
local pcOpt = pchamsLabel:AddOption()
pcOpt:AddToggle({ Default = false, Flag = "chams_player_team_check", Callback = safeUi("Player Chams Team Check", function(v) features.chams:SetSetting("playerTeamCheck", v) end) })
pcOpt:AddToggle({ Default = false, Flag = "chams_player_visible_only", Callback = safeUi("Player Chams Visible Only", function(v) features.chams:SetSetting("playerVisibleOnly", v) end) })
pcOpt:AddColorPicker({ Default = Color3.fromRGB(255, 0, 0), Flag = "chams_player_color", Callback = safeUi("Player Chams Color", function(v) features.chams:SetSetting("playerColor", v) end) })
ChamsSection:AddLabel("Player Fill"):AddSlider({ Min = 0, Max = 1, Default = 0.7, Step = 0.05, Flag = "chams_player_fill", Callback = safeUi("Player Chams Fill", function(v) features.chams:SetSetting("playerFillTransparency", v) end) })
ChamsSection:AddLabel("Player Outline"):AddSlider({ Min = 0, Max = 1, Default = 0, Step = 0.05, Flag = "chams_player_outline", Callback = safeUi("Player Chams Outline", function(v) features.chams:SetSetting("playerOutlineTransparency", v) end) })

local wchamsLabel = ChamsSection:AddLabel("Weapon Chams")
wchamsLabel:AddToggle({ Default = false, Flag = "chams_weapon_enabled", Callback = safeUi("Weapon Chams Enabled", function(v) features.chams:SetSetting("weaponEnabled", v) end) })
local wcOpt = wchamsLabel:AddOption()
wcOpt:AddColorPicker({ Default = Color3.fromRGB(0, 255, 255), Flag = "chams_weapon_color", Callback = safeUi("Weapon Chams Color", function(v) features.chams:SetSetting("weaponColor", v) end) })
ChamsSection:AddLabel("Weapon Fill"):AddSlider({ Min = 0, Max = 1, Default = 0.5, Step = 0.05, Flag = "chams_weapon_fill", Callback = safeUi("Weapon Chams Fill", function(v) features.chams:SetSetting("weaponFillTransparency", v) end) })
ChamsSection:AddLabel("Weapon Outline"):AddSlider({ Min = 0, Max = 1, Default = 0, Step = 0.05, Flag = "chams_weapon_outline", Callback = safeUi("Weapon Chams Outline", function(v) features.chams:SetSetting("weaponOutlineTransparency", v) end) })

local WorldSection = VisualsTab:AddSection({ Name = "WORLD & EFFECTS", Position = 'right' })
local keLabel = WorldSection:AddLabel("Kill Effects")
keLabel:AddToggle({ Default = false, Flag = "killfx_enabled", Callback = safeUi("Kill Effects Enabled", function(v) features.killEffects:SetSetting("enabled", v) end) })
local keOpt = keLabel:AddOption()
keOpt:AddColorPicker({ Default = Color3.fromRGB(255, 0, 100), Flag = "killfx_color", Callback = safeUi("Kill Effect Color", function(v) features.killEffects:SetSetting("color", v) end) })
WorldSection:AddLabel("Kill Duration"):AddSlider({ Min = 0.3, Max = 2, Default = 0.8, Step = 0.1, Flag = "killfx_duration", Callback = safeUi("Kill Effect Duration", function(v) features.killEffects:SetSetting("duration", v) end) })
WorldSection:AddLabel("Kill Intensity"):AddSlider({ Min = 0.2, Max = 1, Default = 0.6, Step = 0.1, Flag = "killfx_intensity", Callback = safeUi("Kill Effect Intensity", function(v) features.killEffects:SetSetting("intensity", v) end) })

WorldSection:AddLabel("Midnight Tint"):AddToggle({ Default = false, Flag = "world_midnight_tint", Callback = safeUi("Midnight Tint", function(v) features.worldVisuals:SetSetting("midnightTint", v) end) })
WorldSection:AddLabel("Minimal Visuals"):AddToggle({ Default = false, Flag = "world_minimal_visuals", Callback = safeUi("Minimal Visuals", function(v) features.worldVisuals:SetSetting("minimalVisuals", v) end) })
WorldSection:AddLabel("Anti Flash"):AddToggle({ Default = false, Flag = "world_anti_flash", Callback = safeUi("Anti Flash", function(v) features.worldVisuals:SetSetting("antiFlash", v) end) })
WorldSection:AddLabel("Anti Smoke"):AddToggle({ Default = false, Flag = "world_anti_smoke", Callback = safeUi("Anti Smoke", function(v) features.worldVisuals:SetSetting("antiSmoke", v) end) })

WorldSection:AddLabel("ThirdPerson"):AddToggle({ Default = false, Flag = "world_third_person", Callback = safeUi("ThirdPerson", function(v) features.worldVisuals:SetSetting("externalView", v) end) })
WorldSection:AddLabel("View Depth"):AddSlider({ Min = 5, Max = 25, Default = 8, Step = 1, Flag = "world_view_depth", Callback = safeUi("View Depth", function(v) features.worldVisuals:SetSetting("cameraDepth", v) end) })

local ThreatSection = VisualsTab:AddSection({ Name = "Throwables", Position = 'right' })
ThreatSection:AddLabel("Grenades"):AddToggle({ Default = false, Flag = "threat_grenades", Callback = safeUi("Hazard Scan", function(v) features.hazardTracker:SetSetting("deviceScanner", v) end) })
ThreatSection:AddLabel("Impact Trail"):AddToggle({ Default = false, Flag = "threat_impact_trail", Callback = safeUi("Impact Trail", function(v) features.hazardTracker:SetSetting("explosivePath", v) end) })
ThreatSection:AddLabel("Line of Sight"):AddToggle({ Default = false, Flag = "threat_line_of_sight", Callback = safeUi("Focus Lines", function(v) features.hazardTracker:SetSetting("gazeIndicators", v) end) })
ThreatSection:AddLabel("Sight Reach"):AddSlider({ Min = 5, Max = 50, Default = 15, Step = 1, Flag = "threat_sight_reach", Callback = safeUi("Focus Reach", function(v) features.hazardTracker:SetSetting("indicatorReach", v) end) })

--[[
local TracersSection = VisualsTab:AddSection({ Name = "BULLET TRACERS", Position = 'right' })
local btLabel = TracersSection:AddLabel("Tracers Enabled")
btLabel:AddToggle({
    Default = false,
    Callback = safeUi("Bullet Tracers Enabled", function(v) features.bulletTracers:SetSetting("enabled", v) end)
})
local btOpt = btLabel:AddOption()
btOpt:AddLabel("Color"):AddColorPicker({
    Default = Color3.fromRGB(0, 255, 255),
    Callback = safeUi("Bullet Tracers Color", function(v) features.bulletTracers:SetSetting("color", v) end)
})

TracersSection:AddLabel("Pattern"):AddDropdown({
    Values = {"Straight", "Wave", "Spiral", "Dashed"},
    Default = "Straight",
    Callback = safeUi("Bullet Tracers Pattern", function(v) features.bulletTracers:SetSetting("pattern", v) end)
})
TracersSection:AddLabel("Duration"):AddSlider({ Min = 0.1, Max = 3, Default = 0.6, Step = 0.1, Callback = safeUi("Bullet Tracers Duration", function(v) features.bulletTracers:SetSetting("duration", v) end) })
TracersSection:AddLabel("Thickness"):AddSlider({ Min = 0.05, Max = 1, Default = 0.2, Step = 0.05, Callback = safeUi("Bullet Tracers Thickness", function(v) features.bulletTracers:SetSetting("thickness", v) end) })
TracersSection:AddLabel("Transparency"):AddSlider({ Min = 0, Max = 1, Default = 0.3, Step = 0.05, Callback = safeUi("Bullet Tracers Transparency", function(v) features.bulletTracers:SetSetting("transparency", v) end) })
]]


local SkinSection = SkinsTab:AddSection({ Name = "SKINCHANGER", Position = 'left' })
SkinSection:AddLabel("Weapon Skins"):AddToggle({ Default = false, Flag = "skin_weapon_skins", Callback = safeUi("Weapon Skin Changer Enabled", function(v) features.skinchanger:SetSkinChangerEnabled(v) end) })
SkinSection:AddLabel("Knife Changer"):AddToggle({ Default = false, Flag = "skin_knife_changer", Callback = safeUi("Knife Changer Enabled", function(v) features.skinchanger:SetKnifeChangerEnabled(v) end) })
SkinSection:AddLabel("Glove Changer"):AddToggle({ Default = false, Flag = "skin_glove_changer", Callback = safeUi("Glove Changer Enabled", function(v) features.skinchanger:SetGloveChangerEnabled(v) end) })

local knifeModels = features.skinchanger:GetKnifeModels()
local knifeModelDropdown
local knifeSkinDropdown

knifeModelDropdown = SkinSection:AddLabel("Knife Model"):AddDropdown({
    Values = knifeModels,
    Default = features.skinchanger:GetKnifeModel(),
    Flag = "skin_knife_model",
    Callback = safeUi("Knife Model", function(value)
        features.skinchanger:SetKnifeModel(value)
        if knifeSkinDropdown then
            local knifeModel = features.skinchanger:GetKnifeModel()
            if knifeSkinDropdown.SetValues then
                knifeSkinDropdown:SetValues(features.skinchanger:GetSkinOptions(knifeModel))
            end
            if knifeSkinDropdown.SetValue then
                knifeSkinDropdown:SetValue(features.skinchanger:GetWeaponSkin(knifeModel))
            end
        end
    end)
})

knifeSkinDropdown = SkinSection:AddLabel("Knife Skin"):AddDropdown({
    Values = features.skinchanger:GetSkinOptions(features.skinchanger:GetKnifeModel()),
    Default = features.skinchanger:GetWeaponSkin(features.skinchanger:GetKnifeModel()),
    Flag = "skin_knife_skin",
    Callback = safeUi("Knife Skin", function(value)
        features.skinchanger:SetWeaponSkin(features.skinchanger:GetKnifeModel(), value)
    end)
})

local function refreshKnifeSkinDropdown()
    local knifeModel = features.skinchanger:GetKnifeModel()
    if knifeSkinDropdown then
        if knifeSkinDropdown.SetValues then
            knifeSkinDropdown:SetValues(features.skinchanger:GetSkinOptions(knifeModel))
        end
        if knifeSkinDropdown.SetValue then
            knifeSkinDropdown:SetValue(features.skinchanger:GetWeaponSkin(knifeModel))
        end
    end
end

local gloveModels = features.skinchanger:GetGloveModels()
local selectedGloveModel = features.skinchanger:GetGloveModel() or gloveModels[1] or "Default"
local gloveSkinDropdown

local gloveModelDropdown = SkinSection:AddLabel("Glove Model"):AddDropdown({
    Values = gloveModels,
    Default = selectedGloveModel,
    Flag = "skin_glove_model",
    Callback = safeUi("Glove Model", function(value)
        features.skinchanger:SetGloveModel(value)
        local skinOptions = features.skinchanger:GetGloveSkinOptions(value)
        if gloveSkinDropdown then
            if gloveSkinDropdown.SetValues then
                gloveSkinDropdown:SetValues(skinOptions)
            end
            if gloveSkinDropdown.SetValue then
                gloveSkinDropdown:SetValue(features.skinchanger:GetGloveSkin(value))
            end
        end
    end)
})

gloveSkinDropdown = SkinSection:AddLabel("Glove Skin"):AddDropdown({
    Values = features.skinchanger:GetGloveSkinOptions(selectedGloveModel),
    Default = features.skinchanger:GetGloveSkin(selectedGloveModel),
    Flag = "skin_glove_skin",
    Callback = safeUi("Glove Skin", function(value)
        features.skinchanger:SetGloveSkin(value)
    end)
})

SkinSection:AddLabel("Inventory Refresh Rate"):AddSlider({ Min = 1, Max = 10, Default = 2, Step = 1, Flag = "skin_refresh_rate", Callback = safeUi("Skin Inventory Refresh Rate", function(v) features.skinchanger:SetInventoryRefreshRate(v) end) })
SkinSection:AddButton({ Name = "Apply Skin Changes", Callback = safeUi("Apply Skin Changes", function()
    features.skinchanger:ApplyNow()
    refreshKnifeSkinDropdown()
end) })

local WeaponSkinsSection = SkinsTab:AddSection({ Name = "WEAPONS", Position = 'right' })
for _, weaponName in ipairs(features.skinchanger:GetWeaponNames()) do
    if not features.skinchanger:IsKnifeModel(weaponName) then
        WeaponSkinsSection:AddLabel(weaponName):AddDropdown({
            Values = features.skinchanger:GetSkinOptions(weaponName),
            Default = features.skinchanger:GetWeaponSkin(weaponName),
            Flag = "skin_" .. weaponName,
            Callback = safeUi("Skin - " .. weaponName, function(value)
                features.skinchanger:SetWeaponSkin(weaponName, value)
            end)
        })
    end
end


local MiscSection = MiscTab:AddSection({ Name = "Movement", Position = 'left' })
MiscSection:AddLabel("Strafes"):AddToggle({ Default = false, Flag = "move_strafes", Callback = safeUi("Movement", function(v) features.movement:SetEnabled(v) end) })
MiscSection:AddLabel("Bunny Hop"):AddToggle({ Default = false, Flag = "move_bunny_hop", Callback = safeUi("Bunny Hop", function(v) features.movement:SetSetting("bunnyHop", v) end) })
MiscSection:AddLabel("Aerial Glide"):AddToggle({ Default = false, Flag = "move_aerial_glide", Callback = safeUi("Aerial Glide", function(v) features.movement:SetSetting("aerialGlide", v) end) })
MiscSection:AddLabel("Speed"):AddSlider({ Min = 16, Max = 100, Default = 16, Step = 1, Flag = "move_speed", Callback = safeUi("Speed", function(v) features.movement:SetSetting("motionScale", v) end) })
MiscSection:AddLabel("Leap Force"):AddSlider({ Min = 25, Max = 100, Default = 25, Step = 1, Flag = "move_leap_force", Callback = safeUi("Leap Force", function(v) features.movement:SetSetting("leapForce", v) end) })
MiscSection:AddLabel("Glide Velocity"):AddSlider({ Min = 16, Max = 50, Default = 16, Step = 1, Flag = "move_glide_velocity", Callback = safeUi("Glide Velocity", function(v) features.movement:SetSetting("glideVelocity", v) end) })

window.UserSettings:AddLabel("Menu Keybind"):AddKeybind({ Default = 'RightShift', Flag = "ui_menu_keybind", Callback = function(v) window.Keybind = v end })
window.UserSettings:AddLabel("Menu Scale"):AddDropdown({ Values = {"Default", "Large", "Mobile", "Small"}, Default = "Default", Flag = "ui_menu_scale", Callback = function(v) window:SetSize(NeverLose.Scales[v]) end })
window.UserSettings:AddLabel("3D Menu"):AddToggle({ Default = false, Flag = "ui_menu_3d", Callback = function(v) pcall(function() window:Set3DRender(v) end) end })
window.UserSettings:AddButton({
    Icon = 'x',
    Name = "Unload Script",
    Callback = function()
        if getgenv and getgenv().BloxtrikeCleanup then
            pcall(getgenv().BloxtrikeCleanup)
        end
    end
})

Notification.new({
    Title = "Bloxtrike",
    Content = "Script loaded successfully!",
    Duration = 5
})

return {
    window = window,
    features = features,
}
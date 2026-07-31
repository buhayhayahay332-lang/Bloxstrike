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

local Aimbot = loadLocal("src/features/combat/Aimbot.lua")
local TriggerBot = loadLocal("src/features/combat/TriggerBot.lua")
local Hitbox = loadLocal("src/features/combat/Hitbox.lua")
local Rage = loadLocal("src/features/combat/Rage.lua")
local BunnyHop = loadLocal("src/features/movement/BunnyHop.lua")
local ESP = loadLocal("src/features/visuals/ESP.lua")
local Chams = loadLocal("src/features/visuals/Chams.lua")
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

local function safeUi(label, fn)
    return errorHandler:Wrap("UI - " .. label, fn)
end

-- NEVERLOSE UI INITIALIZATION
local NeverLose = loadstring(game:HttpGet("https://raw.githubusercontent.com/4lpaca-pin/NeverLose/refs/heads/main/source.luau"))()

local Notification = NeverLose:CreateNotification()
local Logging = NeverLose:CreateLogger()
local Indicator = NeverLose:CreateIndicator()

local window = NeverLose:CreateWindow({
    Logo = "rbxassetid://13129527031",
    Name = "Bloxtrike",
    Content = "Bloxtrike | discord.gg/NtBMqWXySm",
    Size = NeverLose.Scales.Default,
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

-- WATERMARK
local Watermark = window:Watermark()
Watermark:AddBlock("cube-vertexes", "ASTRO.WTF")
Watermark:AddBlock("person", game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Name or "User")
local discordBlock = Watermark:AddBlock("link", "discord.gg/NtBMqWXySm")
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

local pingBlock = Watermark:AddBlock("radio", "Ping: 0ms")
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            if pingBlock and pingBlock:FindFirstChild("Text") then
                pingBlock.Text.Text = "Ping: " .. tostring(ping) .. "ms"
            end
        end)
    end
end)

-- TABS
window:AddTabLabel('MAIN')
local CombatTab = window:AddTab({ Icon = 'crosshair', Name = "Combat" })
local VisualsTab = window:AddTab({ Icon = 'eye', Name = "Visuals" })

window:AddTabLabel('CUSTOMIZATION')
local SkinsTab = window:AddTab({ Icon = 'sparkles', Name = "Skins" })

window:AddTabLabel('MISC')
local MiscTab = window:AddTab({ Icon = 'backpack', Name = "Misc" })

-- ==================== COMBAT TAB ====================
local AimSection = CombatTab:AddSection({ Name = "AIMBOT", Position = 'left' })
local aimLabel = AimSection:AddLabel("Aimbot")
aimLabel:AddToggle({
    Default = false,
    Callback = safeUi("Aimbot Enabled", function(v) features.aimbot:SetEnabled(v) end),
    Flag = "aimbot_enabled"
})
local aimOptions = aimLabel:AddOption()
aimOptions:AddLabel("Team Check"):AddToggle({ Default = false, Callback = safeUi("Aimbot Team Check", function(v) features.aimbot:SetTeamCheck(v) end) })
aimOptions:AddLabel("Wall Check"):AddToggle({ Default = false, Callback = safeUi("Aimbot Wall Check", function(v) features.aimbot:SetWallCheck(v) end) })
aimOptions:AddLabel("Show FOV"):AddToggle({ Default = false, Callback = safeUi("Aimbot Show FOV", function(v) features.aimbot:SetShowFov(v) end) })

AimSection:AddLabel("FOV Radius"):AddSlider({ Min = 10, Max = 500, Default = 100, Step = 10, Callback = safeUi("Aimbot FOV Radius", function(v) features.aimbot:SetFovRadius(v) end) })
AimSection:AddLabel("Smoothing"):AddSlider({ Min = 1, Max = 10, Default = 3, Step = 1, Callback = safeUi("Aimbot Smoothing", function(v) features.aimbot:SetSmoothing(v) end) })

local TrigSection = CombatTab:AddSection({ Name = "TRIGGERBOT", Position = 'left' })
TrigSection:AddLabel("TriggerBot"):AddToggle({ Default = false, Callback = safeUi("TriggerBot Enabled", function(v) features.triggerBot:SetEnabled(v) end) })
TrigSection:AddLabel("Delay MS"):AddSlider({ Min = 0, Max = 500, Default = 0, Step = 10, Callback = safeUi("TriggerBot Delay MS", function(v) features.triggerBot:SetDelayMs(v) end) })

local HitboxSection = CombatTab:AddSection({ Name = "HITBOX", Position = 'left' })
local hbLabel = HitboxSection:AddLabel("Expand Hitboxes")
hbLabel:AddToggle({ Default = false, Callback = safeUi("Hitbox Enabled", function(v) features.hitbox:SetEnabled(v) end) })
local hbOpt = hbLabel:AddOption()
hbOpt:AddLabel("Team Check"):AddToggle({ Default = false, Callback = safeUi("Hitbox Team Check", function(v) features.hitbox:SetTeamCheck(v) end) })
HitboxSection:AddLabel("Hitbox Size"):AddSlider({ Min = 1, Max = 3, Default = 3, Step = 0.1, Callback = safeUi("Hitbox Size", function(v) features.hitbox:SetSize(v) end) })
HitboxSection:AddLabel("Transparency"):AddSlider({ Min = 0, Max = 1, Default = 0.5, Step = 0.05, Callback = safeUi("Hitbox Transparency", function(v) features.hitbox:SetTransparency(v) end) })

local SilentSection = CombatTab:AddSection({ Name = "SILENT AIM", Position = 'right' })
local saLabel = SilentSection:AddLabel("Silent Aim")
saLabel:AddToggle({ Default = false, Callback = safeUi("Silent Aim", function(v) features.rage:SetSilentAim(v) end) })
local saOpt = saLabel:AddOption()
saOpt:AddLabel("Wallbang"):AddToggle({ Default = false, Callback = safeUi("Ignore Walls", function(v) features.rage:SetWallbang(v) end) })
saOpt:AddLabel("Dynamic Miss"):AddToggle({ Default = false, Callback = safeUi("Dynamic Miss", function(v) features.rage:SetDynamicMiss(v) end) })
saOpt:AddLabel("360 FOV"):AddToggle({ Default = false, Callback = safeUi("360 FOV", function(v) features.rage:SetFullFov360(v) end) })
saOpt:AddLabel("AimWall Check"):AddToggle({ Default = true, Callback = safeUi("AimWall Check", function(v) features.rage:SetAimWallCheck(v) end) })
saOpt:AddLabel("Team Check"):AddToggle({ Default = true, Callback = safeUi("TeamCheck", function(v) features.rage:SetTeamCheck(v) end) })
saOpt:AddLabel("Random Part"):AddToggle({ Default = false, Callback = safeUi("Random Part", function(v) features.rage:SetRandomPart(v) end) })

SilentSection:AddLabel("Hit Chance %"):AddSlider({ Min = 1, Max = 100, Default = 100, Step = 1, Callback = safeUi("Hit Chance %", function(v) features.rage:SetBaseHitChance(v) end) })
SilentSection:AddLabel("Show FOV Circle"):AddToggle({ Default = false, Callback = safeUi("Show Circle", function(v) features.rage:SetShowFovCircle(v) end) })
SilentSection:AddLabel("FOV Size"):AddSlider({ Min = 50, Max = 1000, Default = 150, Step = 1, Callback = safeUi("Fov Size", function(v) features.rage:SetFovSize(v) end) })
SilentSection:AddLabel("Target Part"):AddDropdown({ Values = features.rage:GetTargetParts(), Default = features.rage:GetTargetPart(), Callback = safeUi("TargetPart", function(v) features.rage:SetTargetPart(v) end) })

local WeaponModsSection = CombatTab:AddSection({ Name = "WEAPON MODS", Position = 'right' })
WeaponModsSection:AddLabel("No Recoil"):AddToggle({ Default = false, Callback = safeUi("Memory No Recoil", function(v) features.rage:SetMemoryNoRecoil(v) end) })
WeaponModsSection:AddLabel("No Spread"):AddToggle({ Default = false, Callback = safeUi("No Spread", function(v) features.rage:SetNoSpread(v) end) })
WeaponModsSection:AddLabel("Rapid Fire"):AddToggle({ Default = false, Callback = safeUi("Rapid Fire", function(v) features.rage:SetAutoClicker(v) end) })
WeaponModsSection:AddLabel("Rapid Fire Delay (ms)"):AddSlider({ Min = 1, Max = 500, Default = 50, Step = 1, Callback = safeUi("Rapid Fire Delay", function(v) features.rage:SetAutoClickDelay(v) end) })
WeaponModsSection:AddLabel("Instant Reload"):AddToggle({ Default = false, Callback = safeUi("Instant Reload", function(v) features.rage:SetInstantReload(v) end) })
WeaponModsSection:AddLabel("Insta Equip"):AddToggle({ Default = false, Callback = safeUi("Insta Equip", function(v) features.rage:SetInstaEquip(v) end) })
WeaponModsSection:AddLabel("Auto Recoil Control (RCS)"):AddToggle({ Default = false, Callback = safeUi("RCS", function(v) features.rage:SetRcs(v) end) })
WeaponModsSection:AddLabel("RCS Strength"):AddSlider({ Min = 0, Max = 100, Default = 50, Step = 1, Callback = safeUi("RCS Strength", function(v) features.rage:SetRcsStrength(v) end) })
WeaponModsSection:AddLabel("RCS Delay"):AddSlider({ Min = 0, Max = 500, Default = 0, Step = 1, Callback = safeUi("RCS Delay", function(v) features.rage:SetRcsDelay(v) end) })


-- ==================== VISUALS TAB ====================
local EspSection = VisualsTab:AddSection({ Name = "PLAYER ESP", Position = 'left' })
local espLabel = EspSection:AddLabel("ESP Enabled")
espLabel:AddToggle({ Default = false, Callback = safeUi("ESP Enabled", function(v) features.esp:SetSetting("enabled", v) end) })
local espOpt = espLabel:AddOption()
espOpt:AddLabel("Team Check"):AddToggle({ Default = false, Callback = safeUi("ESP Team Check", function(v) features.esp:SetSetting("teamCheck", v) end) })
espOpt:AddLabel("Box"):AddToggle({ Default = false, Callback = safeUi("ESP Show Box", function(v) features.esp:SetSetting("showBox", v) end) })
espOpt:AddLabel("Health Bar"):AddToggle({ Default = false, Callback = safeUi("ESP Show Health", function(v) features.esp:SetSetting("showHealth", v) end) })
espOpt:AddLabel("Names"):AddToggle({ Default = false, Callback = safeUi("ESP Show Name", function(v) features.esp:SetSetting("showName", v) end) })
espOpt:AddLabel("Distance"):AddToggle({ Default = false, Callback = safeUi("ESP Show Distance", function(v) features.esp:SetSetting("showDistance", v) end) })
espOpt:AddLabel("Skeleton"):AddToggle({ Default = false, Callback = safeUi("ESP Show Skeleton", function(v) features.esp:SetSetting("showSkeleton", v) end) })
espOpt:AddLabel("Tracers"):AddToggle({ Default = false, Callback = safeUi("ESP Show Tracers", function(v) features.esp:SetSetting("showTracers", v) end) })
espOpt:AddLabel("Weapon"):AddToggle({ Default = false, Callback = safeUi("ESP Show Weapon", function(v) features.esp:SetSetting("showWeapon", v) end) })
espOpt:AddLabel("Money"):AddToggle({ Default = false, Callback = safeUi("ESP Show Money", function(v) features.esp:SetSetting("showMoney", v) end) })
espOpt:AddLabel("Flags"):AddToggle({ Default = false, Callback = safeUi("ESP Show Flags", function(v) features.esp:SetSetting("showFlags", v) end) })
espOpt:AddLabel("Chams Overlays"):AddToggle({ Default = false, Callback = safeUi("ESP Show Chams", function(v) features.esp:SetSetting("showChams", v) end) })

EspSection:AddLabel("Text Size"):AddSlider({ Min = 10, Max = 20, Default = 11, Step = 1, Callback = safeUi("ESP Text Size", function(v) features.esp:SetSetting("textSize", v) end) })
EspSection:AddLabel("Box Thickness"):AddSlider({ Min = 1, Max = 3, Default = 1, Step = 0.1, Callback = safeUi("ESP Box Thickness", function(v) features.esp:SetSetting("boxThickness", v) end) })
EspSection:AddLabel("Max Distance"):AddSlider({ Min = 0, Max = 500, Default = 0, Step = 10, Callback = safeUi("ESP Max Distance", function(v) features.esp:SetSetting("maxDistance", v) end) })

local ChamsSection = VisualsTab:AddSection({ Name = "CHAMS", Position = 'left' })
ChamsSection:AddLabel("Rainbow Chams"):AddToggle({ Default = false, Callback = safeUi("Chams Rainbow", function(v) features.chams:SetSetting("rainbow", v) end) })
ChamsSection:AddLabel("Rainbow Speed"):AddSlider({ Min = 0.1, Max = 10, Default = 2, Step = 0.1, Callback = safeUi("Chams Rainbow Speed", function(v) features.chams:SetSetting("rainbowSpeed", v) end) })

local pchamsLabel = ChamsSection:AddLabel("Player Chams")
pchamsLabel:AddToggle({ Default = false, Callback = safeUi("Player Chams Enabled", function(v) features.chams:SetSetting("playerEnabled", v) end) })
local pcOpt = pchamsLabel:AddOption()
pcOpt:AddLabel("Team Check"):AddToggle({ Default = false, Callback = safeUi("Player Chams Team Check", function(v) features.chams:SetSetting("playerTeamCheck", v) end) })
pcOpt:AddLabel("Visible Only"):AddToggle({ Default = false, Callback = safeUi("Player Chams Visible Only", function(v) features.chams:SetSetting("playerVisibleOnly", v) end) })
pcOpt:AddLabel("Color"):AddColorPicker({ Default = Color3.fromRGB(255, 0, 0), Callback = safeUi("Player Chams Color", function(v) features.chams:SetSetting("playerColor", v) end) })
ChamsSection:AddLabel("Player Fill"):AddSlider({ Min = 0, Max = 1, Default = 0.7, Step = 0.05, Callback = safeUi("Player Chams Fill", function(v) features.chams:SetSetting("playerFillTransparency", v) end) })
ChamsSection:AddLabel("Player Outline"):AddSlider({ Min = 0, Max = 1, Default = 0, Step = 0.05, Callback = safeUi("Player Chams Outline", function(v) features.chams:SetSetting("playerOutlineTransparency", v) end) })

local wchamsLabel = ChamsSection:AddLabel("Weapon Chams")
wchamsLabel:AddToggle({ Default = false, Callback = safeUi("Weapon Chams Enabled", function(v) features.chams:SetSetting("weaponEnabled", v) end) })
local wcOpt = wchamsLabel:AddOption()
wcOpt:AddLabel("Color"):AddColorPicker({ Default = Color3.fromRGB(0, 255, 255), Callback = safeUi("Weapon Chams Color", function(v) features.chams:SetSetting("weaponColor", v) end) })
ChamsSection:AddLabel("Weapon Fill"):AddSlider({ Min = 0, Max = 1, Default = 0.5, Step = 0.05, Callback = safeUi("Weapon Chams Fill", function(v) features.chams:SetSetting("weaponFillTransparency", v) end) })
ChamsSection:AddLabel("Weapon Outline"):AddSlider({ Min = 0, Max = 1, Default = 0, Step = 0.05, Callback = safeUi("Weapon Chams Outline", function(v) features.chams:SetSetting("weaponOutlineTransparency", v) end) })

local WorldSection = VisualsTab:AddSection({ Name = "WORLD & EFFECTS", Position = 'right' })
local keLabel = WorldSection:AddLabel("Kill Effects")
keLabel:AddToggle({ Default = false, Callback = safeUi("Kill Effects Enabled", function(v) features.killEffects:SetSetting("enabled", v) end) })
local keOpt = keLabel:AddOption()
keOpt:AddLabel("Color"):AddColorPicker({ Default = Color3.fromRGB(255, 0, 100), Callback = safeUi("Kill Effect Color", function(v) features.killEffects:SetSetting("color", v) end) })
WorldSection:AddLabel("Kill Duration"):AddSlider({ Min = 0.3, Max = 2, Default = 0.8, Step = 0.1, Callback = safeUi("Kill Effect Duration", function(v) features.killEffects:SetSetting("duration", v) end) })
WorldSection:AddLabel("Kill Intensity"):AddSlider({ Min = 0.2, Max = 1, Default = 0.6, Step = 0.1, Callback = safeUi("Kill Effect Intensity", function(v) features.killEffects:SetSetting("intensity", v) end) })

WorldSection:AddLabel("Anti Flash"):AddToggle({ Default = false, Callback = safeUi("Anti Flash", function(v) features.worldEffects:SetSetting("antiFlash", v) end) })
WorldSection:AddLabel("Anti Smoke"):AddToggle({ Default = false, Callback = safeUi("Anti Smoke", function(v) features.worldEffects:SetSetting("antiSmoke", v) end) })


-- ==================== SKINS TAB ====================
local SkinSection = SkinsTab:AddSection({ Name = "SKINCHANGER", Position = 'left' })
SkinSection:AddLabel("Weapon Skins"):AddToggle({ Default = false, Callback = safeUi("Weapon Skin Changer Enabled", function(v) features.skinchanger:SetSkinChangerEnabled(v) end) })
SkinSection:AddLabel("Knife Changer"):AddToggle({ Default = false, Callback = safeUi("Knife Changer Enabled", function(v) features.skinchanger:SetKnifeChangerEnabled(v) end) })
SkinSection:AddLabel("Glove Changer"):AddToggle({ Default = false, Callback = safeUi("Glove Changer Enabled", function(v) features.skinchanger:SetGloveChangerEnabled(v) end) })

local knifeModels = features.skinchanger:GetKnifeModels()
local knifeModelDropdown
local knifeSkinDropdown

knifeModelDropdown = SkinSection:AddLabel("Knife Model"):AddDropdown({
    Values = knifeModels,
    Default = features.skinchanger:GetKnifeModel(),
    Callback = safeUi("Knife Model", function(value)
        features.skinchanger:SetKnifeModel(value)
        if knifeSkinDropdown then
            local knifeModel = features.skinchanger:GetKnifeModel()
            knifeSkinDropdown.refresh(features.skinchanger:GetSkinOptions(knifeModel))
            knifeSkinDropdown.set(features.skinchanger:GetWeaponSkin(knifeModel))
        end
    end)
})

knifeSkinDropdown = SkinSection:AddLabel("Knife Skin"):AddDropdown({
    Values = features.skinchanger:GetSkinOptions(features.skinchanger:GetKnifeModel()),
    Default = features.skinchanger:GetWeaponSkin(features.skinchanger:GetKnifeModel()),
    Callback = safeUi("Knife Skin", function(value)
        features.skinchanger:SetWeaponSkin(features.skinchanger:GetKnifeModel(), value)
    end)
})

local function refreshKnifeSkinDropdown()
    local knifeModel = features.skinchanger:GetKnifeModel()
    if knifeSkinDropdown and knifeSkinDropdown.refresh then
        knifeSkinDropdown.refresh(features.skinchanger:GetSkinOptions(knifeModel))
        knifeSkinDropdown.set(features.skinchanger:GetWeaponSkin(knifeModel))
    end
end

local gloveModels = features.skinchanger:GetGloveModels()
local selectedGloveModel = features.skinchanger:GetGloveModel() or gloveModels[1] or "Default"
local gloveSkinDropdown

local gloveModelDropdown = SkinSection:AddLabel("Glove Model"):AddDropdown({
    Values = gloveModels,
    Default = selectedGloveModel,
    Callback = safeUi("Glove Model", function(value)
        features.skinchanger:SetGloveModel(value)
        local skinOptions = features.skinchanger:GetGloveSkinOptions(value)
        if gloveSkinDropdown and gloveSkinDropdown.refresh then
            gloveSkinDropdown.refresh(skinOptions)
            gloveSkinDropdown.set(features.skinchanger:GetGloveSkin(value))
        end
    end)
})

gloveSkinDropdown = SkinSection:AddLabel("Glove Skin"):AddDropdown({
    Values = features.skinchanger:GetGloveSkinOptions(selectedGloveModel),
    Default = features.skinchanger:GetGloveSkin(selectedGloveModel),
    Callback = safeUi("Glove Skin", function(value)
        features.skinchanger:SetGloveSkin(value)
    end)
})

SkinSection:AddLabel("Inventory Refresh Rate"):AddSlider({ Min = 1, Max = 10, Default = 2, Step = 1, Callback = safeUi("Skin Inventory Refresh Rate", function(v) features.skinchanger:SetInventoryRefreshRate(v) end) })
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
            Callback = safeUi("Skin - " .. weaponName, function(value)
                features.skinchanger:SetWeaponSkin(weaponName, value)
            end)
        })
    end
end


-- ==================== MISC TAB ====================
local MiscSection = MiscTab:AddSection({ Name = "MOVEMENT", Position = 'left' })
MiscSection:AddLabel("Bunny Hop"):AddToggle({ Default = false, Callback = safeUi("Bunny Hop Enabled", function(v) features.bunnyHop:SetEnabled(v) end) })

-- USER SETTINGS / SYSTEM
window.UserSettings:AddLabel("Menu Keybind"):AddKeybind({ Default = 'RightShift', Callback = function(v) window.Keybind = v end })
window.UserSettings:AddLabel("Menu Scale"):AddDropdown({ Values = {"Default", "Large", "Mobile", "Small"}, Default = "Default", Callback = function(v) window:SetSize(NeverLose.Scales[v]) end })
window.UserSettings:AddLabel("3D Menu"):AddToggle({ Default = false, Callback = function(v) pcall(function() window:Set3DRender(v) end) end })
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

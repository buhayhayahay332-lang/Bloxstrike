--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]


local char, byte, bxor = (string.char), (string.byte), (bit32.bxor)
local fn_001 = function(arg_001, arg_002)
    local var_001 = ''

    for i_1 = 97, (#arg_001 - 1) + 97 do
        var_001 = var_001 .. char(bxor(byte(arg_001, (i_1 - 97) + (1)), byte(arg_002, (i_1 - 97) % #arg_002 + 1)))
    end

    return var_001
end
local gsub, char_2 = (string.gsub), (string.char)
local gsub_2 = (function(arg_003)
    arg_003 = gsub(arg_003, '[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]', '')

    return (arg_003:gsub('.', function(arg_004)
        if (arg_004 == '=') then
            return ''
        end

        local var_002, find = '', (('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'):find(arg_004) - 1)

        for i_2 = 6, 1, -1 do
            var_002 = var_002 .. (find % 2 ^ i_2 - find % 2 ^ (i_2 - 1) > 0 and '1' or '0')
        end

        return var_002
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(arg_005)
        if (#arg_005 ~= 8) then
            return ''
        end

        local var_003 = 0

        for i_3 = 1, 8 do
            var_003 = var_003 + (arg_005:sub(i_3, i_3) == '1' and 2 ^ (8 - i_3) or 0)
        end

        return char_2(var_003)
    end))
end)
local var_004, var_005, var_006, fromRGB, var_007, floor, ceil, clamp, random, var_008, wait_2, spawn_2, delay_2, lower, find_2, var_009, format, Players, UserInputService, Lighting, HttpService_2, CoreGui, TweenService = Vector3.new, Vector2.new, CFrame.new, Color3.fromRGB, UDim2.new, math.floor, math.ceil, math.clamp, math.random, math.abs, task.wait, task.spawn, task.delay, string.lower, string.find, string.sub, string.format, game:GetService("Players"), game:GetService("UserInputService"), game:GetService("Lighting"), game:GetService("HttpService"), game:GetService("CoreGui"), game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function fn_002()
    local CoreGui_2, var_010 = pcall(function()
        return game:GetService("CoreGui")
    end)

    if CoreGui_2 and var_010 then
        return var_010
    end

    local Players_2 = game:GetService("Players").LocalPlayer

    if Players_2 then
        local FindFirstChildOfClass = Players_2:FindFirstChildOfClass("PlayerGui")

        if FindFirstChildOfClass then
            return FindFirstChildOfClass
        end
    end
end
local function fn_003()
    local var_011 = fn_002()

    if var_011 then
        for it_1, it_2 in ipairs(var_011:GetChildren())do
            if not (it_2.Name == "Wyvern_MemeShell_UIOnly" or it_2.Name == "AntigravityESP" or it_2.Name == "Wyvern_ESP_GUI") then
            else
                pcall(function()
                    it_2:Destroy()
                end)
            end
        end
    end
    if gethui then
        local var_012 = gethui()

        if var_012 then
            for it_3, it_4 in ipairs(var_012:GetChildren())do
                if it_4.Name == "Wyvern_MemeShell_UIOnly" or it_4.Name == "AntigravityESP" or it_4.Name == "Wyvern_ESP_GUI" then
                    pcall(function()
                        it_4:Destroy()
                    end)
                end
            end
        end
    end

    local Players_3 = game:GetService("Players").LocalPlayer

    if Players_3 then
        local FindFirstChildOfClass_2 = Players_3:FindFirstChildOfClass("PlayerGui")

        if FindFirstChildOfClass_2 then
            for it_5, it_6 in ipairs(FindFirstChildOfClass_2:GetChildren())do
                if not (it_6.Name == "Wyvern_MemeShell_UIOnly" or it_6.Name == "AntigravityESP" or it_6.Name == "Wyvern_ESP_GUI") then
                else
                    pcall(function()
                        it_6:Destroy()
                    end)
                end
            end
        end
    end

    local FindFirstChild = Lighting:FindFirstChild("Wyvern_MemeShell_Blur")

    if FindFirstChild then
        FindFirstChild:Destroy()
    end
    if getgenv().AntigravityESP_Connection then
        pcall(function()
            getgenv().AntigravityESP_Connection:Disconnect()
        end)

        getgenv().AntigravityESP_Connection = nil
    end
    if getgenv().AntigravityESP_Objects then
        for it_7, it_8 in pairs(getgenv().AntigravityESP_Objects)do
            pcall(function()
                it_8:Destroy()
            end)
        end

        getgenv().AntigravityESP_Objects = nil
    end
end

fn_003()

local var_013 = identifyexecutor and identifyexecutor() or "Unknown"
local var_014 = lower(var_013)
local var_015, var_016, var_017 = find_2(var_014, "velocity") or find_2(var_014, "potassium") or find_2(var_014, "volt"), {
    Main = fromRGB(16, 17, 20),
    Top = fromRGB(19, 20, 24),
    Sidebar = fromRGB(17, 18, 21),
    Body = fromRGB(18, 19, 22),
    Field = fromRGB(28, 30, 36),
    FieldAlt = fromRGB(24, 26, 32),
    Outline = fromRGB(47, 56, 72),
    Accent = fromRGB(44, 171, 255),
    AccentSoft = fromRGB(88, 210, 255),
    Hot = fromRGB(255, 63, 146),
    Text = fromRGB(236, 239, 243),
    TextDim = fromRGB(155, 161, 170),
    TextMute = fromRGB(106, 112, 121),
    White = fromRGB(255, 255, 255),
}, {
    "knife",
    "karambit",
    "bayonet",
    "butterfly",
    "gut",
    "huntsman",
    "falchion",
    "bowie",
    "daggers",
    "navaja",
    "stiletto",
    "talon",
    "ursus",
    "kukri",
    "dagger",
    "sickle",
    "machete",
}

local function fn_004(m)
    return lower(m)
end
local function fn_005(arg_006, arg_007)
    return find_2(fn_004(arg_006), fn_004(arg_007), 1, true) ~= nil
end
local function fn_006(arg_008, arg_009, arg_010)
    if not arg_010[arg_009] then
        arg_010[arg_009] = true

        table.insert(arg_008, arg_009)
    end
end
local function fn_007(arg_011, arg_012)
    return (arg_011 and arg_011[1]) or arg_012
end
local function fn_008()
    local var_018, var_019, var_020, var_021 = {
        gunNames = {},
        gunSkins = {},
        knifeNames = {},
        knifeSkins = {},
        gloveNames = {},
        gloveSkins = {},
    }, {
        ["AK-47"] = {
            "Stock",
            "Neon Rider",
            "Vulcan",
            "Slate",
            "Fuel Injector",
        },
        ["AWP"] = {
            "Stock",
            "Asiimov",
            "Dragon Lore",
            "Hyper Beast",
            "Neo-Noir",
        },
        ["Desert Eagle"] = {
            "Stock",
            "Blaze",
            "Printstream",
            "Code Red",
            "Kumicho Dragon",
        },
        ["Glock-18"] = {
            "Stock",
            "Fade",
            "Neo-Noir",
            "Water Elemental",
            "Vogue",
        },
        ["M4A1-S"] = {
            "Stock",
            "Printstream",
            "Golden Coil",
            "Nightmare",
            "Chantico's Fire",
        },
        ["MP9"] = {
            "Stock",
            "Starlight Protector",
            "Food Chain",
            "Hydra",
            "Hot Rod",
        },
        ["P90"] = {
            "Stock",
            "Asiimov",
            "Death by Kitty",
            "Emerald Dragon",
            "Trigon",
        },
        ["USP-S"] = {
            "Stock",
            "Kill Confirmed",
            "Neo-Noir",
            "Orion",
            "The Traitor",
        },
    }, {
        ["Bayonet"] = {
            "Vanilla",
            "Doppler",
            "Fade",
            "Crimson Web",
            "Lore",
        },
        ["Karambit"] = {
            "Vanilla",
            "Doppler",
            "Fade",
            "Slaughter",
            "Tiger Tooth",
        },
    }, {
        ["Sports Gloves"] = {
            "Imperial",
            "Vice",
            "Omega",
            "Pandora",
            "Nocts",
        },
    }

    for it_9, it_10 in pairs(var_019)do
        table.insert(var_018.gunNames, it_9)

        var_018.gunSkins[it_9] = it_10
    end
    for it_11, it_12 in pairs(var_020)do
        table.insert(var_018.knifeNames, it_11)

        var_018.knifeSkins[it_11] = it_12
    end
    for it_13, it_14 in pairs(var_021)do
        table.insert(var_018.gloveNames, it_13)

        var_018.gloveSkins[it_13] = it_14
    end

    local var_022

    for it_15, it_16 in ipairs(game:GetChildren())do
        local var_023, var_024 = pcall(function()
            return it_16.Assets.Skins
        end)

        if var_023 and var_024 then
            var_022 = var_024

            break
        end
    end

    if not (not var_022) then
    else
        table.sort(var_018.gunNames)
        table.sort(var_018.knifeNames)
        table.sort(var_018.gloveNames)

        return var_018
    end

    var_018.gunNames = {}
    var_018.gunSkins = {}
    var_018.knifeNames = {}
    var_018.knifeSkins = {}
    var_018.gloveNames = {}
    var_018.gloveSkins = {}

    local var_025, var_026, var_027 = {}, {}, {}

    for it_17, it_18 in ipairs(var_022:GetChildren())do
        local Name = it_18.Name
        local var_028, var_029, var_030 = fn_004(Name), {}, {}

        for it_19, it_20 in ipairs(it_18:GetChildren())do
            local var_031 = fn_004(it_20.Name)

            if var_031 ~= "vanilla" and var_031 ~= "stock" then
                fn_006(var_029, it_20.Name, var_030)
            end
        end

        local var_032 = false

        for it_21, it_22 in ipairs(var_017)do
            if not (fn_005(var_028, it_22)) then
            else
                var_032 = true

                break
            end
        end

        local var_033 = fn_005(var_028, "glove") or fn_005(var_028, "wraps")

        if var_032 then
            fn_006(var_018.knifeNames, Name, var_026)

            var_018.knifeSkins[Name] = (#var_029 > 0 and var_029) or {
                "Vanilla",
            }
        elseif var_033 then
            fn_006(var_018.gloveNames, Name, var_027)

            var_018.gloveSkins[Name] = (#var_029 > 0 and var_029) or {
                "Imperial",
            }
        else
            fn_006(var_018.gunNames, Name, var_025)

            var_018.gunSkins[Name] = (#var_029 > 0 and var_029) or {
                "Stock",
            }
        end
    end

    if #var_018.gunNames == 0 then
        for it_23, it_24 in pairs(var_019)do
            table.insert(var_018.gunNames, it_23)

            var_018.gunSkins[it_23] = it_24
        end
    end
    if #var_018.knifeNames == 0 then
        var_018.knifeNames = {
            "Karambit",
            "Bayonet",
        }
        var_018.knifeSkins = var_020
    end
    if not (#var_018.gloveNames == 0) then
    else
        var_018.gloveNames = {
            "Sports Gloves",
        }
        var_018.gloveSkins = var_021
    end

    table.insert(var_018.knifeNames, "Vanilla")

    var_018.knifeSkins["Vanilla"] = {
        "Vanilla",
    }

    table.sort(var_018.gunNames)
    table.sort(var_018.knifeNames)
    table.sort(var_018.gloveNames)

    return var_018
end

local var_034 = fn_008()

local function fn_009(arg_013)
    if not arg_013 or type(arg_013) ~= "string" then
        return "?"
    end

    local var_035 = lower(arg_013)

    for it_25, it_26 in ipairs(var_034.gunNames)do
        if not (lower(it_26) == var_035) then
        else
            return it_26
        end
    end
    for it_27, it_28 in ipairs(var_034.knifeNames)do
        if not (lower(it_28) == var_035) then
        else
            return it_28
        end
    end

    if not (var_035 == "c4") then
    else
        return "C4"
    end
    if var_035 == "flashbang" then
        return "Flashbang"
    end
    if not (var_035 == "hegrenade" or var_035 == "he grenade" or var_035 == "he_grenade") then
    else
        return "HE Grenade"
    end
    if var_035 == "smokegrenade" or var_035 == "smoke grenade" or var_035 == "smoke_grenade" then
        return "Smoke Grenade"
    end
    if not (var_035 == "molotov") then
    else
        return "Molotov"
    end
    if var_035 == "incendiary" then
        return "Incendiary"
    end

    local var_036 = {}

    for it_29 in string.gmatch(arg_013, "[^-_\n\t ]+")do
        table.insert(var_036, string.upper(var_009(it_29, 1, 1)) .. string.lower(var_009(it_29, 2)))
    end

    if #var_036 > 0 then
        return table.concat(var_036, " ")
    end

    return arg_013
end
local function fn_010(arg_014)
    if not (type(arg_014) ~= "string" or arg_014 == '') then
    else
        return nil
    end

    local var_037, var_038 = arg_014, ''

    if not (var_009(arg_014, 1, 1) == "{") then
    else
        local JSONDecode, var_039 = pcall(function()
            return HttpService_2:JSONDecode(arg_014)
        end)

        if JSONDecode and type(var_039) == "table" then
            var_037 = var_039.name or var_039.Name or var_039._id or "?"

            local Skin = var_039.skin or var_039.Skin

            if Skin and Skin ~= '' and Skin ~= "stock" and Skin ~= "Stock" and Skin ~= "vanilla" and Skin ~= "Vanilla" then
                var_038 = " (" .. fn_009(Skin) .. ")"
            end
        end
    end

    local var_040 = fn_009(var_037)

    if var_040 == "?" or var_040 == "None" or var_040 == '' then
        return nil
    end

    return var_040 .. var_038
end

local var_041, var_042 = {
    activeTab = "Legitbot",
    menuOpen = true,
    menuKey = Enum.KeyCode.V,
    menuScale = 100,
    menuOpacity = 95,
    blurOnOpen = true,
    masterSwitch = true,
    configName = "Default",
    mobileAimlockUI = true,
    mobileJumpUI = true,
    mobileJumpActive = false,
    mobileAimlockActive = false,
    enableCustomModel = false,
    customModelId = "81420911257826",
    showHitmarkerChat = false,
    hitmarkerMode = "Chat",
    hitsoundEnable = false,
    hitsoundSelectedId = "9120386436",
    hitsoundVolume = 80,
    hitsoundCustomId = '',
    rageMode = false,
    rageToggleKey = Enum.KeyCode.Unknown,
    silentAim = false,
    silentAimToggleKey = Enum.KeyCode.Unknown,
    showFovCircle = true,
    fovSize = 150,
    wallbang = false,
    wallbangToggleKey = Enum.KeyCode.Unknown,
    dynamicMiss = false,
    baseHitChance = 100,
    memoryNoRecoil = false,
    noSpread = false,
    rapidFire = false,
    rapidFireDelay = 50,
    autoClicker = false,
    autoClickDelay = 50,
    instantReload = false,
    instaEquip = false,
    targetPart = "Head",
    randomPart = false,
    fullFov360 = false,
    aimWallCheck = true,
    teamCheck = true,
    rcs = false,
    rcsStrength = 50,
    rcsDelay = 0,
    triggerBot = false,
    triggerToggleKey = Enum.KeyCode.Unknown,
    triggerDelay = 0,
    aimlock = false,
    aimlockToggleKey = Enum.KeyCode.Unknown,
    aimlockHoldKey = Enum.UserInputType.MouseButton2,
    aimlockMethod = "Raw Mouse",
    aimlockFov = 150,
    aimSmoothness = 2,
    aimJitter = 10,
    flickBot = false,
    hitboxExpander = false,
    hitboxToggleKey = Enum.KeyCode.Unknown,
    hitboxSize = 2,
    hitboxTransparency = 50,
    visualsEnable = false,
    visualsToggleKey = Enum.KeyCode.Unknown,
    boxes = false,
    box3d = false,
    nameEsp = false,
    distanceEsp = false,
    moneyEsp = false,
    weaponEsp = false,
    hpBar = false,
    skeletonEsp = false,
    chams = false,
    tracers = false,
    viewTracers = false,
    traceLength = 15,
    showTeammates = false,
    teamColorsAuto = true,
    nightMode = false,
    nightModeToggleKey = Enum.KeyCode.Unknown,
    lowGfx = false,
    antiFlash = false,
    antiSmoke = false,
    showSpectators = false,
    worldWeaponEsp = false,
    c4Esp = false,
    bulletTracers = false,
    tracerColor = "Yellow",
    bombTrail2d = false,
    thirdPerson = false,
    thirdPersonToggleKey = Enum.KeyCode.Unknown,
    tpsDistance = 8,
    showWatermark = true,
    showKeybinds = true,
    showHitmarkerChat = false,
    hitmarkerMode = "Chat",
    movementEnable = false,
    movementToggleKey = Enum.KeyCode.Unknown,
    jumpPower = 25,
    speedPower = 16,
    bunnyHop = false,
    airStrafe = false,
    airStrafeSpeed = 16,
    selectedGun = fn_007(var_034.gunNames, "AK-47"),
    selectedGunSkin = fn_007(var_034.gunSkins[fn_007(var_034.gunNames, "AK-47")], "Stock"),
    selectedKnife = fn_007(var_034.knifeNames, "Karambit"),
    selectedKnifeSkin = fn_007(var_034.knifeSkins[fn_007(var_034.knifeNames, "Karambit")], "Vanilla"),
    selectedGlove = fn_007(var_034.gloveNames, "Sports Gloves"),
    selectedGloveSkin = fn_007(var_034.gloveSkins[fn_007(var_034.gloveNames, "Sports Gloves")], "Imperial"),
}, {}

for it_30, it_31 in pairs(var_041)do
    var_042[it_30] = it_31
end

local var_043, var_044, var_045, var_046, var_047, var_048, var_049, var_050, var_051, var_052 = {}, {}, {}, {}, {}, {}, {
    {
        name = "Menu",
        bindKey = "menuKey",
        stateKey = "menuOpen",
    },
    {
        name = "Rage Mode",
        bindKey = "rageToggleKey",
        stateKey = "rageMode",
    },
    {
        name = "Silent Aim",
        bindKey = "silentAimToggleKey",
        stateKey = "silentAim",
    },
    {
        name = "Wallbang",
        bindKey = "wallbangToggleKey",
        stateKey = "wallbang",
    },
    {
        name = "TriggerBot",
        bindKey = "triggerToggleKey",
        stateKey = "triggerBot",
    },
    {
        name = "Aimlock",
        bindKey = "aimlockToggleKey",
        stateKey = "aimlock",
    },
    {
        name = "Hitbox Expander",
        bindKey = "hitboxToggleKey",
        stateKey = "hitboxExpander",
    },
    {
        name = "Visuals",
        bindKey = "visualsToggleKey",
        stateKey = "visualsEnable",
    },
    {
        name = "NightMode",
        bindKey = "nightModeToggleKey",
        stateKey = "nightMode",
    },
    {
        name = "Third Person",
        bindKey = "thirdPersonToggleKey",
        stateKey = "thirdPerson",
    },
    {
        name = "Movement",
        bindKey = "movementToggleKey",
        stateKey = "movementEnable",
    },
}, {
    "rageMode",
    "silentAim",
    "wallbang",
    "rapidFire",
    "autoClicker",
    "instantReload",
    "instaEquip",
    "dynamicMiss",
    "triggerBot",
    "aimlock",
    "hitboxExpander",
    "visualsEnable",
    "boxes",
    "box3d",
    "nameEsp",
    "distanceEsp",
    "moneyEsp",
    "weaponEsp",
    "hpBar",
    "skeletonEsp",
    "chams",
    "tracers",
    "nightMode",
    "thirdPerson",
    "movementEnable",
    "memoryNoRecoil",
    "noSpread",
}, {
    "rageMode",
    "silentAim",
    "wallbang",
    "rapidFire",
    "autoClicker",
    "instantReload",
    "instaEquip",
    "dynamicMiss",
    "memoryNoRecoil",
    "noSpread",
}, {
    "aimlock",
    "hitboxExpander",
    "movementEnable",
}

local function fn_011(arg_015, arg_016)
    var_043[arg_015] = var_043[arg_015] or {}

    table.insert(var_043[arg_015], arg_016)
end
local function fn_012(arg_017)
    local var_053 = var_043[arg_017]

    if not (not var_053) then
    else
        return
    end

    for it_32, it_33 in ipairs(var_053)do
        it_33(var_042[arg_017])
    end
end
local function fn_013()
    for it_34 in pairs(var_043)do
        fn_012(it_34)
    end
    for it_35, it_36 in ipairs(var_048)do
        it_36()
    end
end
local function fn_014(arg_018, arg_019)
    var_042[arg_018] = arg_019

    fn_012(arg_018)
end
local function fn_015(arg_020)
    if typeof(arg_020) ~= "EnumItem" then
        if type(arg_020) == "string" and var_009(arg_020, 1, 6) == "ENUM::" then
            return "Unknown"
        end

        return tostring(arg_020)
    end
    if arg_020 == Enum.KeyCode.Unknown then
        return "Unknown"
    end

    return arg_020.Name
end
local function fn_016(arg_021, arg_022)
    if not (typeof(arg_022) ~= "EnumItem") then
    else
        return false
    end
    if arg_022 == Enum.KeyCode.Unknown then
        return false
    end
    if arg_022.EnumType == Enum.KeyCode then
        return arg_021.KeyCode == arg_022
    end
    if arg_022.EnumType == Enum.UserInputType then
        return arg_021.UserInputType == arg_022
    end

    return false
end
local function fn_017()
    local var_054 = {}

    for it_37, it_38 in pairs(var_042)do
        if not (it_37 ~= "menuOpen") then
        else
            if not (typeof(it_38) == "EnumItem") then
                var_054[it_37] = it_38
            else
                var_054[it_37] = "ENUM::" .. tostring(it_38)
            end
        end
    end

    return var_054
end
local function fn_018(arg_023)
    if not (type(arg_023) ~= "string") then
    else
        return arg_023
    end
    if not (var_009(arg_023, 1, 6) ~= "ENUM::") then
    else
        return arg_023
    end

    local var_055 = var_009(arg_023, 7)
    local var_056 = string.split(var_055, ".")
    local var_057, var_058

    if not (#var_056 == 3 and var_056[1] == "Enum") then
        if #var_056 == 2 then
            var_057 = var_056[1]
            var_058 = var_056[2]
        else
            return arg_023
        end
    else
        var_057 = var_056[2]
        var_058 = var_056[3]
    end

    local var_059, var_060 = pcall(function()
        return Enum[var_057]
    end)

    if not (var_059 and var_060) then
    else
        local var_061, var_062 = pcall(function()
            return var_060[var_058]
        end)

        if var_061 and var_062 then
            return var_062
        end
    end

    return arg_023
end
local function fn_019()
    local var_063 = readfile or (getgenv and getgenv().readfile)

    if not var_063 then
        return {}
    end

    local var_064, var_065 = pcall(function()
        return var_063("wyvern_memeshell_ui.json")
    end)

    if not (not var_064 or type(var_065) ~= "string" or var_065 == '') then
    else
        return {}
    end

    local JSONDecode_2, var_066 = pcall(function()
        return HttpService_2:JSONDecode(var_065)
    end)

    if JSONDecode_2 and type(var_066) == "table" then
        return var_066
    end

    return {}
end
local function fn_020(arg_024)
    local var_067 = writefile or (getgenv and getgenv().writefile)

    if not (not var_067) then
    else
        return false, "File API unavailable"
    end

    local JSONEncode, var_068 = pcall(function()
        var_067("wyvern_memeshell_ui.json", HttpService_2:JSONEncode(arg_024))
    end)

    if not (JSONEncode) then
    else
        return true, "Saved"
    end

    return false, tostring(var_068)
end
local function fn_021()
    if not table.find(var_034.gunNames, var_042.selectedGun) then
        var_042.selectedGun = fn_007(var_034.gunNames, "AK-47")
    end

    local var_069 = var_034.gunSkins[var_042.selectedGun] or {
        "Stock",
    }

    if not (not table.find(var_069, var_042.selectedGunSkin)) then
    else
        var_042.selectedGunSkin = var_069[1]
    end
    if not (not table.find(var_034.knifeNames, var_042.selectedKnife)) then
    else
        var_042.selectedKnife = fn_007(var_034.knifeNames, "Karambit")
    end

    local var_070 = var_034.knifeSkins[var_042.selectedKnife] or {
        "Vanilla",
    }

    if not table.find(var_070, var_042.selectedKnifeSkin) then
        var_042.selectedKnifeSkin = var_070[1]
    end
    if not table.find(var_034.gloveNames, var_042.selectedGlove) then
        var_042.selectedGlove = fn_007(var_034.gloveNames, "Sports Gloves")
    end

    local var_071 = var_034.gloveSkins[var_042.selectedGlove] or {
        "Imperial",
    }

    if not (not table.find(var_071, var_042.selectedGloveSkin)) then
    else
        var_042.selectedGloveSkin = var_071[1]
    end
end

fn_021()

local function fn_022()
    local FindFirstChild_2 = Lighting:FindFirstChild("Wyvern_MemeShell_Blur")

    if FindFirstChild_2 and FindFirstChild_2:IsA("BlurEffect") then
        return FindFirstChild_2
    end

    FindFirstChild_2 = Instance.new("BlurEffect")
    FindFirstChild_2.Name = "Wyvern_MemeShell_Blur"
    FindFirstChild_2.Enabled = false
    FindFirstChild_2.Size = 0
    FindFirstChild_2.Parent = Lighting

    return FindFirstChild_2
end

local Instance_new = Instance.new("ScreenGui")

Instance_new.Name = "Wyvern_MemeShell_UIOnly"
Instance_new.ResetOnSpawn = false
Instance_new.IgnoreGuiInset = true
Instance_new.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Instance_new.DisplayOrder = 999
Instance_new.Parent = fn_002()

local function fn_023(arg_025, arg_026)
    local Instance_new_2 = Instance.new("UICorner")

    Instance_new_2.CornerRadius = UDim.new(0, arg_026)
    Instance_new_2.Parent = arg_025

    return Instance_new_2
end
local function fn_024(arg_027, arg_028, arg_029, arg_030)
    local Instance_new_3 = Instance.new("UIStroke")

    Instance_new_3.Color = arg_028
    Instance_new_3.Thickness = arg_029 or 1
    Instance_new_3.Transparency = arg_030 or 0
    Instance_new_3.Parent = arg_027

    return Instance_new_3
end
local function fn_025(arg_031, arg_032, arg_033)
    local Instance_new_4 = Instance.new("UIGradient")

    Instance_new_4.Color = arg_032
    Instance_new_4.Rotation = arg_033 or 0
    Instance_new_4.Parent = arg_031

    return Instance_new_4
end
local function fn_026(arg_034)
    local var_072 = ((100) - var_042.menuOpacity) / (100)
    local var_073 = clamp(arg_034.base + var_072 * arg_034.scale, 0, 0.92)

    if arg_034.instance and arg_034.instance.Parent then
        arg_034.instance.BackgroundTransparency = var_073
    end
end
local function fn_027(arg_035, arg_036, arg_037)
    local var_074 = {
        instance = arg_035,
        base = arg_036 or 0,
        scale = arg_037 or 0.65,
    }

    table.insert(var_044, var_074)
    fn_026(var_074)

    return arg_035
end

Root = Instance.new("Frame")
Root.Size = UDim2.fromScale(1, 1)
Root.BackgroundTransparency = 1
Root.Parent = Instance_new
Backdrop = Instance.new("Frame")
Backdrop.Size = UDim2.fromScale(1, 1)
Backdrop.BackgroundColor3 = fromRGB(0, 0, 0)
Backdrop.BackgroundTransparency = 0.45
Backdrop.Parent = Root

local GetAttribute = var_005(820, 520)

Main = Instance.new("Frame")
Main.AnchorPoint = var_005(0.5, 0.5)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.Size = UDim2.fromOffset(GetAttribute.X, GetAttribute.Y)
Main.BackgroundColor3 = var_016.Main
Main.BorderSizePixel = 0
Main.Parent = Root

fn_023(Main, 4)
fn_024(Main, var_016.Outline, 1, 0.15)
fn_027(Main, 2E-2, 0.55)

TopAccent = Instance.new("Frame")
TopAccent.Size = var_007(1, -2, 0, 2)
TopAccent.Position = var_007(0, 1, 0, 1)
TopAccent.BorderSizePixel = 0
TopAccent.Parent = Main

fn_025(TopAccent, ColorSequence.new{
    ColorSequenceKeypoint.new(0, var_016.Accent),
    ColorSequenceKeypoint.new(0.55, var_016.AccentSoft),
    ColorSequenceKeypoint.new(1, var_016.AccentSoft),
}, 0)

TopBar = Instance.new("Frame")
TopBar.Size = var_007(1, 0, 0, 50)
TopBar.BackgroundColor3 = var_016.Top
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

fn_023(TopBar, 4)
fn_027(TopBar, 8E-2, 0.55)

TopBarMask = Instance.new("Frame")
TopBarMask.Size = var_007(1, 0, 0, 12)
TopBarMask.Position = var_007(0, 0, 1, -12)
TopBarMask.BackgroundColor3 = var_016.Top
TopBarMask.BorderSizePixel = 0
TopBarMask.Parent = TopBar

fn_027(TopBarMask, 8E-2, 0.55)

TitleWrap = Instance.new("Frame")
TitleWrap.Size = UDim2.fromOffset(128, 22)
TitleWrap.Position = var_007(0, 18, 0, 14)
TitleWrap.BackgroundTransparency = 1
TitleWrap.Parent = TopBar
TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.fromScale(1, 1)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "WYVERN"
TitleLabel.TextColor3 = var_016.AccentSoft
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 19
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleWrap
DragHandle = Instance.new("Frame")
DragHandle.Size = UDim2.fromScale(1, 1)
DragHandle.BackgroundTransparency = 1
DragHandle.Active = true
DragHandle.Parent = TopBar
LogoImage = Instance.new("ImageLabel")
LogoImage.AnchorPoint = var_005(1, 0)
LogoImage.Size = UDim2.fromOffset(58, 58)
LogoImage.Position = var_007(1, -16, 0, -5)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://80180896525224"
LogoImage.ScaleType = Enum.ScaleType.Fit
LogoImage.ImageTransparency = 4E-2
LogoImage.Active = true
LogoImage.ZIndex = 3
LogoImage.Parent = Main
Divider = Instance.new("Frame")
Divider.Size = var_007(1, 0, 0, 1)
Divider.Position = var_007(0, 0, 0, 50)
Divider.BackgroundColor3 = var_016.Outline
Divider.BackgroundTransparency = 0.35
Divider.BorderSizePixel = 0
Divider.Parent = Main
Sidebar = Instance.new("Frame")
Sidebar.Size = var_007(0, 154, 1, -51)
Sidebar.Position = var_007(0, 0, 0, 51)
Sidebar.BackgroundColor3 = var_016.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

fn_027(Sidebar, 0.12, 0.55)

SidebarScroll = Instance.new("Frame")
SidebarScroll.Size = var_007(1, -20, 1, -14)
SidebarScroll.Position = var_007(0, 10, 0, 7)
SidebarScroll.BackgroundTransparency = 1
SidebarScroll.Parent = Sidebar
SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 3)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = SidebarScroll
Body = Instance.new("Frame")
Body.Size = var_007(1, -162, 1, -51)
Body.Position = var_007(0, 162, 0, 51)
Body.BackgroundColor3 = var_016.Body
Body.BorderSizePixel = 0
Body.Parent = Main

fn_027(Body, 8E-2, 0.55)

SideDivider = Instance.new("Frame")
SideDivider.Size = var_007(0, 1, 1, -51)
SideDivider.Position = var_007(0, 154, 0, 51)
SideDivider.BackgroundColor3 = var_016.Outline
SideDivider.BackgroundTransparency = 0.42
SideDivider.BorderSizePixel = 0
SideDivider.Parent = Main
BodyPadding = Instance.new("UIPadding")
BodyPadding.PaddingTop = UDim.new(0, 10)
BodyPadding.PaddingBottom = UDim.new(0, 10)
BodyPadding.PaddingLeft = UDim.new(0, 18)
BodyPadding.PaddingRight = UDim.new(0, 14)
BodyPadding.Parent = Body
BodyPages = Instance.new("Frame")
BodyPages.Size = UDim2.fromScale(1, 1)
BodyPages.BackgroundTransparency = 1
BodyPages.Parent = Body
ResizeHandle = Instance.new("TextButton")
ResizeHandle.AnchorPoint = var_005(1, 1)
ResizeHandle.Size = UDim2.fromOffset(14, 14)
ResizeHandle.Position = var_007(1, -5, 1, -5)
ResizeHandle.BackgroundColor3 = var_016.Field
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Text = ''
ResizeHandle.AutoButtonColor = false
ResizeHandle.Active = true
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = Main

fn_023(ResizeHandle, 3)
fn_024(ResizeHandle, var_016.Accent, 1, 0.28)
fn_027(ResizeHandle, 0.2, 0.45)

ResizeGripA = Instance.new("Frame")
ResizeGripA.AnchorPoint = var_005(1, 1)
ResizeGripA.Size = UDim2.fromOffset(6, 1)
ResizeGripA.Position = var_007(1, -3, 1, -4)
ResizeGripA.Rotation = -45
ResizeGripA.BackgroundColor3 = var_016.AccentSoft
ResizeGripA.BorderSizePixel = 0
ResizeGripA.ZIndex = 11
ResizeGripA.Parent = ResizeHandle
ResizeGripB = Instance.new("Frame")
ResizeGripB.AnchorPoint = var_005(1, 1)
ResizeGripB.Size = UDim2.fromOffset(10, 1)
ResizeGripB.Position = var_007(1, -3, 1, -7)
ResizeGripB.Rotation = -45
ResizeGripB.BackgroundColor3 = var_016.Accent
ResizeGripB.BorderSizePixel = 0
ResizeGripB.ZIndex = 11
ResizeGripB.Parent = ResizeHandle
Watermark = Instance.new("Frame")
Watermark.Name = "Wyvern_Watermark"
Watermark.Size = UDim2.fromOffset(200, 26)
Watermark.Position = var_007(1, -218, 0, 65)
Watermark.BackgroundColor3 = fromRGB(9, 11, 15)
Watermark.BorderSizePixel = 0
Watermark.Visible = false
Watermark.ZIndex = 20
Watermark.Parent = Root

fn_023(Watermark, 4)
fn_024(Watermark, var_016.Outline, 1, 0.15)

WatermarkFade = Instance.new("UIGradient")
WatermarkFade.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, fromRGB(9, 11, 15)),
    ColorSequenceKeypoint.new(0.5, fromRGB(18, 24, 31)),
    ColorSequenceKeypoint.new(1, fromRGB(9, 11, 15)),
}
WatermarkFade.Parent = Watermark
WatermarkAccent = Instance.new("Frame")
WatermarkAccent.Size = var_007(1, -14, 0, 1)
WatermarkAccent.Position = var_007(0, 7, 1, -3)
WatermarkAccent.BackgroundColor3 = var_016.Accent
WatermarkAccent.BorderSizePixel = 0
WatermarkAccent.ZIndex = 21
WatermarkAccent.Parent = Watermark
WatermarkAccentFade = Instance.new("UIGradient")
WatermarkAccentFade.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, var_016.Accent),
    ColorSequenceKeypoint.new(0.5, var_016.AccentSoft),
    ColorSequenceKeypoint.new(1, var_016.Accent),
}
WatermarkAccentFade.Parent = WatermarkAccent
WatermarkTitle = Instance.new("TextLabel")
WatermarkTitle.Size = var_007(0, 70, 1, 0)
WatermarkTitle.Position = UDim2.fromOffset(10, 0)
WatermarkTitle.BackgroundTransparency = 1
WatermarkTitle.Text = "WYVERN"
WatermarkTitle.TextColor3 = var_016.AccentSoft
WatermarkTitle.Font = Enum.Font.GothamBlack
WatermarkTitle.TextSize = 12
WatermarkTitle.TextXAlignment = Enum.TextXAlignment.Left
WatermarkTitle.ZIndex = 21
WatermarkTitle.Parent = Watermark
WatermarkMeta = Instance.new("TextLabel")
WatermarkMeta.Size = var_007(1, -90, 1, 0)
WatermarkMeta.Position = UDim2.fromOffset(80, 0)
WatermarkMeta.BackgroundTransparency = 1
WatermarkMeta.Text = "RISK: LEGIT"
WatermarkMeta.TextColor3 = var_016.TextDim
WatermarkMeta.Font = Enum.Font.GothamBold
WatermarkMeta.TextSize = 10
WatermarkMeta.TextXAlignment = Enum.TextXAlignment.Right
WatermarkMeta.ZIndex = 21
WatermarkMeta.Parent = Watermark
SpectatorPanel = Instance.new("Frame")
SpectatorPanel.Name = "SpectatorPanel"
SpectatorPanel.Size = UDim2.fromOffset(226, 36)
SpectatorPanel.Position = var_007(0, 18, 0.5, -146)
SpectatorPanel.BackgroundColor3 = fromRGB(10, 12, 16)
SpectatorPanel.BorderSizePixel = 0
SpectatorPanel.Visible = false
SpectatorPanel.ZIndex = 20
SpectatorPanel.Parent = Root

fn_023(SpectatorPanel, 4)
fn_024(SpectatorPanel, var_016.Outline, 1, 0.2)

SpecLogo = Instance.new("ImageLabel")
SpecLogo.Size = UDim2.fromOffset(16, 16)
SpecLogo.Position = UDim2.fromOffset(8, 10)
SpecLogo.BackgroundTransparency = 1
SpecLogo.Image = "rbxassetid://80180896525224"
SpecLogo.ScaleType = Enum.ScaleType.Fit
SpecLogo.ImageColor3 = var_016.AccentSoft
SpecLogo.ZIndex = 21
SpecLogo.Parent = SpectatorPanel
SpectatorCountLabel = Instance.new("TextLabel")
SpectatorCountLabel.Size = var_007(1, -34, 1, 0)
SpectatorCountLabel.Position = UDim2.fromOffset(30, 0)
SpectatorCountLabel.BackgroundTransparency = 1
SpectatorCountLabel.Text = "SPECTATORS: 0"
SpectatorCountLabel.TextColor3 = var_016.Text
SpectatorCountLabel.Font = Enum.Font.GothamBlack
SpectatorCountLabel.TextSize = 11
SpectatorCountLabel.TextXAlignment = Enum.TextXAlignment.Left
SpectatorCountLabel.ZIndex = 21
SpectatorCountLabel.Parent = SpectatorPanel

fn_011("showSpectators", function(arg_038)
    SpectatorPanel.Visible = arg_038 == true
end)
spawn_2(function()
    while wait_2(0.5) do
        if not (var_042.showSpectators) then
        else
            local var_075 = 0

            if LocalPlayer then
                local GetAttribute_2 = LocalPlayer:GetAttribute("Spectators")

                if not (type(GetAttribute_2) == "number") then
                    local FindFirstChild_3 = LocalPlayer:FindFirstChild("Spectators")

                    if FindFirstChild_3 and FindFirstChild_3:IsA("IntValue") then
                        var_075 = FindFirstChild_3.Value
                    end
                else
                    var_075 = GetAttribute_2
                end
            end

            SpectatorCountLabel.Text = "SPECTATORS: " .. tostring(var_075)
            SpectatorCountLabel.TextColor3 = var_075 > 0 and var_016.Hot or var_016.Text
        end
    end
end)

KeybindPanel = Instance.new("Frame")
KeybindPanel.Size = UDim2.fromOffset(226, 42)
KeybindPanel.Position = var_007(0, 18, 0.5, -100)
KeybindPanel.BackgroundColor3 = fromRGB(10, 12, 16)
KeybindPanel.BorderSizePixel = 0
KeybindPanel.Visible = false
KeybindPanel.ZIndex = 20
KeybindPanel.Parent = Root

fn_023(KeybindPanel, 4)
fn_024(KeybindPanel, var_016.Outline, 1, 0.2)

KeybindPanelFade = Instance.new("UIGradient")
KeybindPanelFade.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, fromRGB(11, 13, 18)),
    ColorSequenceKeypoint.new(0.56, fromRGB(17, 20, 26)),
    ColorSequenceKeypoint.new(1, fromRGB(9, 10, 13)),
}
KeybindPanelFade.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.32),
    NumberSequenceKeypoint.new(0.58, 8E-2),
    NumberSequenceKeypoint.new(1, 0.28),
}
KeybindPanelFade.Parent = KeybindPanel
KeybindLogo = Instance.new("ImageLabel")
KeybindLogo.Size = UDim2.fromOffset(16, 16)
KeybindLogo.Position = UDim2.fromOffset(8, 4)
KeybindLogo.BackgroundTransparency = 1
KeybindLogo.Image = "rbxassetid://80180896525224"
KeybindLogo.ScaleType = Enum.ScaleType.Fit
KeybindLogo.ImageColor3 = var_016.AccentSoft
KeybindLogo.ZIndex = 21
KeybindLogo.Parent = KeybindPanel
KeybindHeader = Instance.new("TextLabel")
KeybindHeader.Size = var_007(1, -34, 0, 20)
KeybindHeader.Position = UDim2.fromOffset(30, 2)
KeybindHeader.BackgroundTransparency = 1
KeybindHeader.Text = "KEYBINDS"
KeybindHeader.TextColor3 = var_016.AccentSoft
KeybindHeader.Font = Enum.Font.GothamBlack
KeybindHeader.TextSize = 11
KeybindHeader.TextXAlignment = Enum.TextXAlignment.Left
KeybindHeader.ZIndex = 21
KeybindHeader.Parent = KeybindPanel
KeybindAccent = Instance.new("Frame")
KeybindAccent.Size = var_007(1, -14, 0, 1)
KeybindAccent.Position = var_007(0, 7, 0, 24)
KeybindAccent.BackgroundColor3 = var_016.Accent
KeybindAccent.BorderSizePixel = 0
KeybindAccent.ZIndex = 21
KeybindAccent.Parent = KeybindPanel
KeybindAccentFade = Instance.new("UIGradient")
KeybindAccentFade.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, var_016.Accent),
    ColorSequenceKeypoint.new(0.5, var_016.AccentSoft),
    ColorSequenceKeypoint.new(1, var_016.Accent),
}
KeybindAccentFade.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.88),
    NumberSequenceKeypoint.new(0.45, 8E-2),
    NumberSequenceKeypoint.new(1, 0.88),
}
KeybindAccentFade.Parent = KeybindAccent
KeybindList = Instance.new("Frame")
KeybindList.Size = var_007(1, -14, 0, 0)
KeybindList.Position = UDim2.fromOffset(7, 30)
KeybindList.BackgroundTransparency = 1
KeybindList.ZIndex = 21
KeybindList.Parent = KeybindPanel
KeybindListLayout = Instance.new("UIListLayout")
KeybindListLayout.Padding = UDim.new(0, 3)
KeybindListLayout.SortOrder = Enum.SortOrder.LayoutOrder
KeybindListLayout.Parent = KeybindList
KeybindEmpty = Instance.new("TextLabel")
KeybindEmpty.Size = var_007(1, 0, 0, 16)
KeybindEmpty.BackgroundTransparency = 1
KeybindEmpty.Text = "No assigned toggle binds"
KeybindEmpty.TextColor3 = var_016.TextMute
KeybindEmpty.Font = Enum.Font.GothamMedium
KeybindEmpty.TextSize = 10
KeybindEmpty.TextXAlignment = Enum.TextXAlignment.Left
KeybindEmpty.ZIndex = 21
KeybindEmpty.Parent = KeybindList

local var_076 = {}

for it_39, it_40 in ipairs(var_049)do
    local Instance_new_5 = Instance.new("Frame")

    Instance_new_5.Size = var_007(1, 0, 0, 18)
    Instance_new_5.BackgroundTransparency = 1
    Instance_new_5.LayoutOrder = it_39
    Instance_new_5.ZIndex = 21
    Instance_new_5.Parent = KeybindList

    local Instance_new_6 = Instance.new("TextLabel")

    Instance_new_6.Size = var_007(1, -96, 1, 0)
    Instance_new_6.BackgroundTransparency = 1
    Instance_new_6.Text = it_40.name
    Instance_new_6.TextColor3 = var_016.Text
    Instance_new_6.Font = Enum.Font.GothamSemibold
    Instance_new_6.TextSize = 10
    Instance_new_6.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_6.ZIndex = 22
    Instance_new_6.Parent = Instance_new_5

    local Instance_new_7 = Instance.new("TextLabel")

    Instance_new_7.Size = UDim2.fromOffset(54, 18)
    Instance_new_7.Position = var_007(1, -82, 0, 0)
    Instance_new_7.BackgroundTransparency = 1
    Instance_new_7.TextColor3 = var_016.Hot
    Instance_new_7.Font = Enum.Font.GothamBold
    Instance_new_7.TextSize = 10
    Instance_new_7.TextXAlignment = Enum.TextXAlignment.Right
    Instance_new_7.ZIndex = 22
    Instance_new_7.Parent = Instance_new_5

    local Instance_new_8 = Instance.new("TextLabel")

    Instance_new_8.Size = UDim2.fromOffset(24, 18)
    Instance_new_8.Position = var_007(1, -24, 0, 0)
    Instance_new_8.BackgroundTransparency = 1
    Instance_new_8.Font = Enum.Font.GothamBlack
    Instance_new_8.TextSize = 9
    Instance_new_8.TextXAlignment = Enum.TextXAlignment.Right
    Instance_new_8.ZIndex = 22
    Instance_new_8.Parent = Instance_new_5
    var_076[it_40.bindKey] = {
        row = Instance_new_5,
        key = Instance_new_7,
        state = Instance_new_8,
        item = it_40,
    }
end

local var_077 = fn_022()
local var_078
local var_079
local var_080

local function fn_028()
    for it_41, it_42 in ipairs(var_044)do
        fn_026(it_42)
    end

    Backdrop.BackgroundTransparency = clamp(0.42 + (((100) - var_042.menuOpacity) / (100)) * (0.38), 0.3, 0.82)
end
local function fn_029()
    var_077.Enabled = var_042.menuOpen and var_042.blurOnOpen
    var_077.Size = var_077.Enabled and 16 or 0
end
local function fn_030()
    var_042.menuScale = clamp(var_042.menuScale, 80, 130)

    local var_081 = var_042.menuScale / (100)

    Main.Size = UDim2.fromOffset(floor(GetAttribute.X * var_081), floor(GetAttribute.Y * var_081))
end
local function fn_031(arg_039)
    local var_082 = var_042.menuOpen ~= arg_039

    var_042.menuOpen = arg_039
    Main.Visible = arg_039
    Backdrop.Visible = arg_039

    fn_029()

    if not (var_082) then
    else
        fn_012("menuOpen")
    end
end
local function fn_032(arg_040)
    return typeof(arg_040) == "EnumItem" and arg_040 ~= Enum.KeyCode.Unknown
end
local function fn_033()
    for it_43, it_44 in ipairs(var_051)do
        if var_042[it_44] == true then
            return "RAGE", var_016.Hot
        end
    end
    for it_45, it_46 in ipairs(var_052)do
        if var_042[it_46] == true then
            return "SEMI", var_016.AccentSoft
        end
    end

    return "LEGIT", var_016.TextDim
end
local function fn_034()
    Watermark.Visible = var_042.showWatermark == true
    KeybindPanel.Visible = var_042.showKeybinds == true

    local var_083, var_084 = fn_033()

    WatermarkMeta.Text = "RISK: " .. var_083
    WatermarkMeta.TextColor3 = var_084

    local var_085 = 0

    for it_47, it_48 in ipairs(var_049)do
        local var_086, var_087 = var_076[it_48.bindKey], var_042[it_48.bindKey]

        if var_086 then
            local var_088 = fn_032(var_087)

            var_086.row.Visible = var_088

            if not (var_088) then
            else
                var_085 = var_085 + 1
                var_086.key.Text = fn_015(var_087)

                local var_089 = var_042[it_48.stateKey] == true

                if var_089 then
                    var_086.state.Text = "ON"
                    var_086.state.TextColor3 = var_016.AccentSoft
                else
                    var_086.state.Text = "OFF"
                    var_086.state.TextColor3 = var_016.TextMute
                end
            end
        end
    end

    KeybindEmpty.Visible = var_085 == 0

    local var_090 = var_085 > 0 and ((var_085 * (18)) + math.max(var_085 - 1, 0) * (3)) or 16

    KeybindList.Size = var_007(1, -14, 0, var_090)
    KeybindPanel.Size = UDim2.fromOffset(226, clamp((40) + var_090, 48, 270))
end

fn_011("menuOpacity", fn_028)
fn_011("menuScale", fn_030)
fn_011("blurOnOpen", fn_029)
fn_011("menuOpen", fn_034)
fn_011("showWatermark", fn_034)
fn_011("showKeybinds", fn_034)

for it_49, it_50 in ipairs(var_049)do
    fn_011(it_50.bindKey, fn_034)
    fn_011(it_50.stateKey, fn_034)
end
for it_51, it_52 in ipairs(var_050)do
    fn_011(it_52, fn_034)
end

local TweenInfo_new = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

fn_011("activeTab", function(arg_041)
    for it_53, it_54 in pairs(var_045)do
        if not (it_53 == arg_041) then
            it_54.Visible = false
        else
            it_54.Visible = true
            it_54.Position = var_007(0, 25, 0, 0)

            TweenService:Create(it_54, TweenInfo_new, {
                Position = var_007(0, 0, 0, 0),
            }):Play()
        end
    end
    for it_55, it_56 in pairs(var_046)do
        local var_091, FindFirstChild_4, FindFirstChild_5 = it_55 == arg_041, it_56:FindFirstChild("Accent"), it_56:FindFirstChild("Label")

        if not (FindFirstChild_4) then
        else
            FindFirstChild_4.Visible = var_091

            if not (var_091) then
            else
                FindFirstChild_4.Size = UDim2.fromOffset(2, 0)

                TweenService:Create(FindFirstChild_4, TweenInfo_new, {
                    Size = UDim2.fromOffset(2, 18),
                }):Play()
            end
        end

        it_56.BackgroundColor3 = var_091 and var_016.FieldAlt or var_016.Sidebar

        if not (FindFirstChild_5) then
        else
            FindFirstChild_5.TextColor3 = var_091 and var_016.Text or var_016.TextDim
        end

        fn_028()
    end
end)

local function fn_035(arg_042, arg_043)
    local Instance_new_9 = Instance.new("TextButton")

    Instance_new_9.Size = var_007(1, 0, 0, 31)
    Instance_new_9.BackgroundColor3 = var_016.Sidebar
    Instance_new_9.BorderSizePixel = 0
    Instance_new_9.Text = ''
    Instance_new_9.AutoButtonColor = false
    Instance_new_9.LayoutOrder = arg_043
    Instance_new_9.Parent = SidebarScroll

    fn_027(Instance_new_9, 0.14, 0.55)

    local Instance_new_10 = Instance.new("Frame")

    Instance_new_10.Name = "Accent"
    Instance_new_10.Size = UDim2.fromOffset(2, 18)
    Instance_new_10.Position = var_007(0, 6, 0.5, -9)
    Instance_new_10.BackgroundColor3 = var_016.Hot
    Instance_new_10.BorderSizePixel = 0
    Instance_new_10.Visible = false
    Instance_new_10.Parent = Instance_new_9

    local Instance_new_11 = Instance.new("TextLabel")

    Instance_new_11.Name = "Label"
    Instance_new_11.Size = var_007(1, -28, 1, 0)
    Instance_new_11.Position = var_007(0, 18, 0, 0)
    Instance_new_11.BackgroundTransparency = 1
    Instance_new_11.Text = arg_042
    Instance_new_11.TextColor3 = var_016.TextDim
    Instance_new_11.Font = Enum.Font.GothamBold
    Instance_new_11.TextSize = 12
    Instance_new_11.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_11.Parent = Instance_new_9

    Instance_new_9.MouseButton1Click:Connect(function()
        fn_014("activeTab", arg_042)
    end)

    var_046[arg_042] = Instance_new_9
end
local function fn_036(arg_044)
    local Instance_new_12 = Instance.new("ScrollingFrame")

    Instance_new_12.Name = arg_044 .. "Page"
    Instance_new_12.Size = UDim2.fromScale(1, 1)
    Instance_new_12.BackgroundTransparency = 1
    Instance_new_12.BorderSizePixel = 0
    Instance_new_12.ScrollBarThickness = 2
    Instance_new_12.ScrollBarImageColor3 = var_016.Accent
    Instance_new_12.ScrollBarImageTransparency = 0.28
    Instance_new_12.CanvasSize = var_007(0, 0, 0, 0)
    Instance_new_12.Parent = BodyPages

    local function fn_037()
        local var_092 = 0

        for it_57, it_58 in ipairs(Instance_new_12:GetChildren())do
            if not (it_58:IsA("Frame")) then
            else
                local var_093 = it_58.Position.Y.Offset + it_58.AbsoluteSize.Y

                if not (var_093 > var_092) then
                else
                    var_092 = var_093
                end
            end
        end

        Instance_new_12.CanvasSize = var_007(0, 0, 0, var_092 + (10))
    end

    Instance_new_12:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn_037)
    table.insert(var_048, fn_037)

    var_045[arg_044] = Instance_new_12

    return Instance_new_12, fn_037
end
local function fn_038(arg_045, arg_046, arg_047)
    local Instance_new_13, var_094 = Instance.new("Frame"), arg_047 > 0

    Instance_new_13.Size = var_007(arg_046, var_094 and -28 or -18, 0, 0)
    Instance_new_13.Position = var_007(arg_047, var_094 and 12 or 0, 0, 0)
    Instance_new_13.BackgroundTransparency = 1
    Instance_new_13.AutomaticSize = Enum.AutomaticSize.Y
    Instance_new_13.Parent = arg_045

    local Instance_new_14 = Instance.new("UIListLayout")

    Instance_new_14.Padding = UDim.new(0, 14)
    Instance_new_14.SortOrder = Enum.SortOrder.LayoutOrder
    Instance_new_14.Parent = Instance_new_13

    return Instance_new_13, Instance_new_14
end
local function fn_039(arg_048, arg_049)
    local Instance_new_15 = Instance.new("Frame")

    Instance_new_15.Size = var_007(1, 0, 0, 0)
    Instance_new_15.AutomaticSize = Enum.AutomaticSize.Y
    Instance_new_15.BackgroundTransparency = 1
    Instance_new_15.Parent = arg_048

    local Instance_new_16 = Instance.new("Frame")

    Instance_new_16.Size = var_007(1, 0, 0, 1)
    Instance_new_16.BackgroundColor3 = var_016.Outline
    Instance_new_16.BackgroundTransparency = 0.72
    Instance_new_16.BorderSizePixel = 0
    Instance_new_16.Parent = Instance_new_15

    local Instance_new_17 = Instance.new("TextLabel")

    Instance_new_17.Size = var_007(1, 0, 0, 14)
    Instance_new_17.Position = UDim2.fromOffset(0, 8)
    Instance_new_17.BackgroundTransparency = 1
    Instance_new_17.Text = arg_049
    Instance_new_17.TextColor3 = var_016.TextMute
    Instance_new_17.Font = Enum.Font.GothamSemibold
    Instance_new_17.TextSize = 11
    Instance_new_17.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_17.Parent = Instance_new_15

    local Instance_new_18 = Instance.new("Frame")

    Instance_new_18.Size = var_007(1, 0, 0, 1)
    Instance_new_18.Position = var_007(0, 0, 0, 26)
    Instance_new_18.BackgroundColor3 = var_016.Outline
    Instance_new_18.BackgroundTransparency = 0.38
    Instance_new_18.BorderSizePixel = 0
    Instance_new_18.Parent = Instance_new_15

    local Instance_new_19 = Instance.new("Frame")

    Instance_new_19.Size = var_007(1, 0, 0, 0)
    Instance_new_19.Position = var_007(0, 0, 0, 34)
    Instance_new_19.BackgroundTransparency = 1
    Instance_new_19.AutomaticSize = Enum.AutomaticSize.Y
    Instance_new_19.Parent = Instance_new_15

    local Instance_new_20 = Instance.new("UIListLayout")

    Instance_new_20.Padding = UDim.new(0, 8)
    Instance_new_20.SortOrder = Enum.SortOrder.LayoutOrder
    Instance_new_20.Parent = Instance_new_19

    local function j()
        Instance_new_15.Size = var_007(1, 0, 0, (34) + Instance_new_20.AbsoluteContentSize.Y)
    end

    Instance_new_20:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(j)
    j()

    return Instance_new_19
end
local function fn_040(arg_050, arg_051)
    local Instance_new_21 = Instance.new("Frame")

    Instance_new_21.Size = UDim2.fromOffset(arg_051, 20)
    Instance_new_21.BackgroundColor3 = var_016.Field
    Instance_new_21.BorderSizePixel = 0
    Instance_new_21.Parent = arg_050

    fn_023(Instance_new_21, 3)
    fn_024(Instance_new_21, var_016.Outline, 1, 0.24)
    fn_027(Instance_new_21, 0.2, 0.55)

    return Instance_new_21
end
local function fn_041(arg_052, arg_053, arg_054)
    local Instance_new_22 = Instance.new("Frame")

    Instance_new_22.Size = var_007(1, 0, 0, 20)
    Instance_new_22.BackgroundTransparency = 1
    Instance_new_22.Parent = arg_052

    local Instance_new_23 = Instance.new("TextButton")

    Instance_new_23.Size = UDim2.fromScale(1, 1)
    Instance_new_23.BackgroundTransparency = 1
    Instance_new_23.Text = ''
    Instance_new_23.Parent = Instance_new_22

    local Instance_new_24 = Instance.new("Frame")

    Instance_new_24.Size = UDim2.fromOffset(12, 12)
    Instance_new_24.Position = var_007(0, 2, 0.5, -6)
    Instance_new_24.BackgroundColor3 = var_016.Field
    Instance_new_24.BorderSizePixel = 0
    Instance_new_24.Parent = Instance_new_22

    fn_023(Instance_new_24, 2)
    fn_024(Instance_new_24, var_016.Hot, 1, 4E-2)
    fn_027(Instance_new_24, 0.22, 0.55)

    local Instance_new_25 = Instance.new("Frame")

    Instance_new_25.Size = var_007(1, -4, 1, -4)
    Instance_new_25.Position = var_007(0, 2, 0, 2)
    Instance_new_25.BackgroundColor3 = var_016.Hot
    Instance_new_25.BorderSizePixel = 0
    Instance_new_25.Parent = Instance_new_24

    fn_023(Instance_new_25, 1)

    local Instance_new_26 = Instance.new("TextLabel")

    Instance_new_26.Size = var_007(1, -24, 1, 0)
    Instance_new_26.Position = var_007(0, 24, 0, 0)
    Instance_new_26.BackgroundTransparency = 1
    Instance_new_26.Text = arg_053
    Instance_new_26.TextColor3 = var_016.Text
    Instance_new_26.Font = Enum.Font.GothamMedium
    Instance_new_26.TextSize = 12
    Instance_new_26.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_26.Parent = Instance_new_22

    local function fn_042()
        Instance_new_25.Visible = var_042[arg_054] == true
        Instance_new_26.TextColor3 = var_042[arg_054] and var_016.Text or var_016.TextDim
    end

    Instance_new_23.MouseButton1Click:Connect(function()
        fn_014(arg_054, not var_042[arg_054])
    end)
    fn_011(arg_054, fn_042)
    fn_042()
end
local function fn_043(arg_055, arg_056, arg_057)
    local Instance_new_27 = Instance.new("Frame")

    Instance_new_27.Size = var_007(1, 0, 0, 20)
    Instance_new_27.BackgroundTransparency = 1
    Instance_new_27.Parent = arg_055

    local Instance_new_28 = Instance.new("TextLabel")

    Instance_new_28.Size = var_007(1, -102, 1, 0)
    Instance_new_28.BackgroundTransparency = 1
    Instance_new_28.Text = arg_056
    Instance_new_28.TextColor3 = var_016.Text
    Instance_new_28.Font = Enum.Font.GothamMedium
    Instance_new_28.TextSize = 12
    Instance_new_28.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_28.Parent = Instance_new_27

    local var_095 = fn_040(Instance_new_27, 92)

    var_095.Position = var_007(1, -92, 0, 0)

    local Instance_new_29 = Instance.new("TextButton")

    Instance_new_29.Size = UDim2.fromScale(1, 1)
    Instance_new_29.BackgroundTransparency = 1
    Instance_new_29.Text = ''
    Instance_new_29.Parent = var_095

    local Instance_new_30 = Instance.new("TextLabel")

    Instance_new_30.Size = var_007(1, -8, 1, 0)
    Instance_new_30.Position = var_007(0, 4, 0, 0)
    Instance_new_30.BackgroundTransparency = 1
    Instance_new_30.TextColor3 = var_016.Hot
    Instance_new_30.Font = Enum.Font.GothamBold
    Instance_new_30.TextSize = 11
    Instance_new_30.TextXAlignment = Enum.TextXAlignment.Right
    Instance_new_30.Parent = var_095

    local function fn_044()
        if not (var_078 == arg_057) then
            Instance_new_30.Text = fn_015(var_042[arg_057])
            Instance_new_30.TextColor3 = var_016.Hot
        else
            Instance_new_30.Text = "Press key"
            Instance_new_30.TextColor3 = var_016.Accent
        end
    end

    Instance_new_29.MouseButton1Click:Connect(function()
        var_078 = arg_057

        for it_59, it_60 in pairs(var_047)do
            it_60()
        end
    end)

    var_047[arg_057] = fn_044

    fn_011(arg_057, fn_044)
    fn_044()
end
local function fn_045(arg_058, arg_059, arg_060, arg_061)
    local Instance_new_31 = Instance.new("Frame")

    Instance_new_31.Size = var_007(1, 0, 0, 20)
    Instance_new_31.BackgroundTransparency = 1
    Instance_new_31.Parent = arg_058
    Instance_new_31.ClipsDescendants = true

    local Instance_new_32 = Instance.new("TextLabel")

    Instance_new_32.Size = var_007(1, -150, 1, 0)
    Instance_new_32.BackgroundTransparency = 1
    Instance_new_32.Text = arg_059
    Instance_new_32.TextColor3 = var_016.Text
    Instance_new_32.Font = Enum.Font.GothamMedium
    Instance_new_32.TextSize = 12
    Instance_new_32.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_32.Parent = Instance_new_31

    local var_096 = fn_040(Instance_new_31, 140)

    var_096.Position = var_007(1, -140, 0, 0)

    local Instance_new_33 = Instance.new("TextButton")

    Instance_new_33.Size = UDim2.fromScale(1, 1)
    Instance_new_33.BackgroundTransparency = 1
    Instance_new_33.Text = ''
    Instance_new_33.Parent = var_096

    local Instance_new_34 = Instance.new("TextLabel")

    Instance_new_34.Size = var_007(1, -22, 1, 0)
    Instance_new_34.Position = var_007(0, 6, 0, 0)
    Instance_new_34.BackgroundTransparency = 1
    Instance_new_34.TextColor3 = var_016.TextDim
    Instance_new_34.Font = Enum.Font.GothamBold
    Instance_new_34.TextSize = 11
    Instance_new_34.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_34.Parent = var_096

    local Instance_new_35 = Instance.new("TextLabel")

    Instance_new_35.Size = UDim2.fromOffset(10, 10)
    Instance_new_35.Position = var_007(1, -14, 0.5, -5)
    Instance_new_35.BackgroundTransparency = 1
    Instance_new_35.Text = "v"
    Instance_new_35.TextColor3 = var_016.TextMute
    Instance_new_35.Font = Enum.Font.GothamBold
    Instance_new_35.TextSize = 10
    Instance_new_35.Parent = var_096

    local Instance_new_36 = Instance.new("Frame")

    Instance_new_36.Size = var_007(0, 140, 0, 0)
    Instance_new_36.Position = var_007(1, -140, 0, 24)
    Instance_new_36.BackgroundTransparency = 1
    Instance_new_36.Parent = Instance_new_31

    local Instance_new_37 = Instance.new("UIListLayout")

    Instance_new_37.Padding = UDim.new(0, 4)
    Instance_new_37.SortOrder = Enum.SortOrder.LayoutOrder
    Instance_new_37.Parent = Instance_new_36

    local var_097 = false

    local function fn_046()
        local var_098 = var_097 and (Instance_new_37.AbsoluteContentSize.Y + (4)) or 0

        Instance_new_31.Size = var_007(1, 0, 0, 24 + var_098)
        Instance_new_36.Size = var_007(0, 140, 0, var_098)
        Instance_new_35.Text = var_097 and "^" or "v"
    end

    for it_61, it_62 in ipairs(arg_061)do
        local var_099 = fn_040(Instance_new_36, 140)

        var_099.Size = var_007(1, 0, 0, 18)

        local Instance_new_38 = Instance.new("TextButton")

        Instance_new_38.Size = UDim2.fromScale(1, 1)
        Instance_new_38.BackgroundTransparency = 1
        Instance_new_38.Text = ''
        Instance_new_38.Parent = var_099

        local Instance_new_39 = Instance.new("TextLabel")

        Instance_new_39.Size = var_007(1, -8, 1, 0)
        Instance_new_39.Position = var_007(0, 6, 0, 0)
        Instance_new_39.BackgroundTransparency = 1
        Instance_new_39.Text = it_62
        Instance_new_39.TextColor3 = var_016.TextDim
        Instance_new_39.Font = Enum.Font.GothamMedium
        Instance_new_39.TextSize = 11
        Instance_new_39.TextXAlignment = Enum.TextXAlignment.Left
        Instance_new_39.Parent = var_099

        Instance_new_38.MouseButton1Click:Connect(function()
            fn_014(arg_060, it_62)

            var_097 = false

            fn_046()
        end)
        fn_011(arg_060, function(arg_062)
            Instance_new_39.TextColor3 = arg_062 == it_62 and var_016.Accent or var_016.TextDim
        end)
    end

    Instance_new_33.MouseButton1Click:Connect(function()
        var_097 = not var_097

        fn_046()
    end)
    Instance_new_37:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn_046)
    fn_011(arg_060, function(arg_063)
        Instance_new_34.Text = tostring(arg_063)
    end)
    fn_046()
    fn_012(arg_060)
end
local function fn_047(arg_064, arg_065, arg_066)
    local Instance_new_40 = Instance.new("Frame")

    Instance_new_40.Size = var_007(1, 0, 0, 20)
    Instance_new_40.BackgroundTransparency = 1
    Instance_new_40.Parent = arg_064

    local Instance_new_41 = Instance.new("TextLabel")

    Instance_new_41.Size = var_007(1, -150, 1, 0)
    Instance_new_41.BackgroundTransparency = 1
    Instance_new_41.Text = arg_065
    Instance_new_41.TextColor3 = var_016.Text
    Instance_new_41.Font = Enum.Font.GothamMedium
    Instance_new_41.TextSize = 12
    Instance_new_41.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_41.Parent = Instance_new_40

    local var_100 = fn_040(Instance_new_40, 140)

    var_100.Position = var_007(1, -140, 0, 0)

    local Instance_new_42 = Instance.new("TextBox")

    Instance_new_42.Size = var_007(1, -12, 1, 0)
    Instance_new_42.Position = var_007(0, 6, 0, 0)
    Instance_new_42.BackgroundTransparency = 1
    Instance_new_42.TextColor3 = var_016.TextDim
    Instance_new_42.Font = Enum.Font.GothamBold
    Instance_new_42.TextSize = 11
    Instance_new_42.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_42.Text = tostring(var_042[arg_066] or '')
    Instance_new_42.ClearTextOnFocus = false
    Instance_new_42.Parent = var_100

    Instance_new_42.FocusLost:Connect(function()
        fn_014(arg_066, Instance_new_42.Text)
    end)
    fn_011(arg_066, function(arg_067)
        Instance_new_42.Text = tostring(arg_067 or '')
    end)
end
local function fn_048(arg_068, arg_069, arg_070, arg_071, c, arg_072)
    local Instance_new_43 = Instance.new("Frame")

    Instance_new_43.Size = var_007(1, 0, 0, 34)
    Instance_new_43.BackgroundTransparency = 1
    Instance_new_43.Parent = arg_068

    local Instance_new_44 = Instance.new("TextLabel")

    Instance_new_44.Size = var_007(1, -70, 0, 14)
    Instance_new_44.BackgroundTransparency = 1
    Instance_new_44.Text = arg_069
    Instance_new_44.TextColor3 = var_016.Text
    Instance_new_44.Font = Enum.Font.GothamMedium
    Instance_new_44.TextSize = 12
    Instance_new_44.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_44.Parent = Instance_new_43

    local Instance_new_45 = Instance.new("TextLabel")

    Instance_new_45.Size = var_007(0, 64, 0, 14)
    Instance_new_45.Position = var_007(1, -64, 0, 0)
    Instance_new_45.BackgroundTransparency = 1
    Instance_new_45.TextColor3 = var_016.Accent
    Instance_new_45.Font = Enum.Font.GothamBold
    Instance_new_45.TextSize = 11
    Instance_new_45.TextXAlignment = Enum.TextXAlignment.Right
    Instance_new_45.Parent = Instance_new_43

    local Instance_new_46 = Instance.new("Frame")

    Instance_new_46.Size = var_007(1, 0, 0, 6)
    Instance_new_46.Position = var_007(0, 0, 1, -8)
    Instance_new_46.BackgroundColor3 = fromRGB(7, 7, 8)
    Instance_new_46.BorderSizePixel = 0
    Instance_new_46.ClipsDescendants = true
    Instance_new_46.Parent = Instance_new_43

    fn_023(Instance_new_46, 999)
    fn_024(Instance_new_46, var_016.Outline, 1, 0.42)

    local Instance_new_47 = Instance.new("Frame")

    Instance_new_47.Size = var_007(0, 0, 1, -4)
    Instance_new_47.Position = UDim2.fromOffset(2, 2)
    Instance_new_47.BackgroundColor3 = var_016.Accent
    Instance_new_47.BorderSizePixel = 0
    Instance_new_47.Parent = Instance_new_46

    fn_023(Instance_new_47, 999)

    local Instance_new_48 = Instance.new("TextButton")

    Instance_new_48.Size = var_007(1, 0, 1, 10)
    Instance_new_48.Position = var_007(0, 0, 0.5, -5)
    Instance_new_48.BackgroundTransparency = 1
    Instance_new_48.Text = ''
    Instance_new_48.Parent = Instance_new_46

    local var_101 = false

    arg_072 = arg_072 or 1

    local function fn_049(arg_073)
        local var_102 = clamp(arg_073, arg_071, c)
        local var_103 = floor(((var_102 - arg_071) / arg_072) + 0.5) * arg_072 + arg_071

        var_103 = clamp(var_103, arg_071, c)

        if not (arg_072 >= 1) then
        else
            return floor(var_103 + (0.5))
        end

        return tonumber(format("%.2f", var_103))
    end
    local function fn_050()
        local var_104 = tonumber(var_042[arg_070]) or arg_071
        local var_105 = clamp((var_104 - arg_071) / (c - arg_071), 0, 1)

        Instance_new_47.Size = var_007(var_105, -floor((4) * var_105), 1, -4)
        Instance_new_45.Text = tostring(var_104)
    end
    local function fn_051(arg_074)
        local Connect = clamp((arg_074.Position.X - Instance_new_46.AbsolutePosition.X) / Instance_new_46.AbsoluteSize.X, 0, 1)

        fn_014(arg_070, fn_049(arg_071 + (c - arg_071) * Connect))
    end

    Instance_new_48.InputBegan:Connect(function(arg_075)
        if arg_075.UserInputType == Enum.UserInputType.MouseButton1 or arg_075.UserInputType == Enum.UserInputType.Touch then
            var_101 = true

            fn_051(arg_075)
        end
    end)
    UserInputService.InputChanged:Connect(function(arg_076)
        if not (var_101 and (arg_076.UserInputType == Enum.UserInputType.MouseMovement or arg_076.UserInputType == Enum.UserInputType.Touch)) then
        else
            fn_051(arg_076)
        end
    end)
    UserInputService.InputEnded:Connect(function(arg_077)
        if not (arg_077.UserInputType == Enum.UserInputType.MouseButton1 or arg_077.UserInputType == Enum.UserInputType.Touch) then
        else
            var_101 = false
        end
    end)
    fn_011(arg_070, fn_050)
    fn_050()
end
local function fn_052(arg_078, arg_079, arg_080, arg_081)
    local function fn_053()
        arg_081()
    end

    arg_079:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn_053)
    arg_080:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn_053)
    fn_053()
end
local function fn_054()
    local q, var_106 = fn_036("Legitbot")
    local var_107, var_108 = fn_038(q, 0.5, 0)
    local var_109, var_110 = fn_038(q, 0.5, 0.5)
    local var_111 = fn_039(var_107, "TriggerBot")

    fn_041(var_111, "Enable", "triggerBot")
    fn_043(var_111, "Toggle Keybind", "triggerToggleKey")
    fn_048(var_111, "Delay (ms)", "triggerDelay", 0, 500, 1)

    local var_112 = fn_039(var_107, "Aimlock")

    fn_041(var_112, "Enable", "aimlock")
    fn_043(var_112, "Toggle Keybind", "aimlockToggleKey")
    fn_043(var_112, "Aimlock HoldKey", "aimlockHoldKey")
    fn_045(var_112, "Aimlock Method", "aimlockMethod", {
        "Raw Mouse",
    })
    fn_048(var_112, "Aimlock Fov Size", "aimlockFov", 10, 1E3, 1)
    fn_048(var_112, "Aim Smoothness", "aimSmoothness", 1, 10, 1)
    fn_048(var_112, "Aim Jitter (Randomize)", "aimJitter", 0, 50, 1)
    fn_041(var_112, "FlickBOT", "flickBot")

    local var_113 = fn_039(var_109, "Hitbox Expander")

    fn_041(var_113, "Enable", "hitboxExpander")
    fn_043(var_113, "Toggle Keybind", "hitboxToggleKey")
    fn_048(var_113, "Hitbox Size", "hitboxSize", 1, 3, 1)
    fn_048(var_113, "Hitbox Transparency", "hitboxTransparency", 0, 100, 1)
    fn_052(q, var_108, var_110, var_106)
end
local function fn_055()
    local var_114, var_115 = fn_036("Ragebot")
    local var_116, var_117 = fn_038(var_114, 0.5, 0)
    local var_118, var_119 = fn_038(var_114, 0.5, 0.5)
    local var_120 = fn_039(var_116, "Ragebot")

    fn_041(var_120, "Master Rage Mode", "rageMode")
    fn_043(var_120, "Rage Toggle Key", "rageToggleKey")

    local var_121 = fn_039(var_116, "Weapon Mods")

    fn_041(var_121, "Memory No Recoil", "memoryNoRecoil")
    fn_041(var_121, "No Spread", "noSpread")
    fn_041(var_121, "RapidFire", "rapidFire")
    fn_048(var_121, "Rapid Fire Delay (ms)", "rapidFireDelay", 1, 500, 1)
    fn_041(var_121, "Auto Clicker (Hold LMB)", "autoClicker")
    fn_048(var_121, "Auto Click Delay (ms)", "autoClickDelay", 10, 500, 1)
    fn_041(var_121, "Instant Reload", "instantReload")
    fn_041(var_121, "Insta Equip", "instaEquip")

    local var_122, Instance_new_49 = fn_039(var_118, "Silent Aim"), Instance.new("TextLabel")

    Instance_new_49.Size = var_007(1, 0, 0, 16)
    Instance_new_49.BackgroundTransparency = 1
    Instance_new_49.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_49.Font = Enum.Font.GothamBold
    Instance_new_49.TextSize = 10
    Instance_new_49.Parent = var_122

    if var_015 then
        Instance_new_49.Text = "Status: Supported (" .. var_013 .. ")"
        Instance_new_49.TextColor3 = var_016.Accent
    else
        Instance_new_49.Text = "Status: NO SUPPORT"
        Instance_new_49.TextColor3 = var_016.Hot

        local Instance_new_50 = Instance.new("Frame")

        Instance_new_50.Size = var_007(1, 0, 0, 24)
        Instance_new_50.BackgroundTransparency = 1
        Instance_new_50.Parent = var_122

        local var_123 = fn_040(Instance_new_50, 120)

        var_123.Position = var_007(0, 0, 0, 2)

        local Instance_new_51 = Instance.new("TextButton", var_123)

        Instance_new_51.Size = UDim2.fromScale(1, 1)
        Instance_new_51.BackgroundTransparency = 1
        Instance_new_51.Text = "IDC NO SUPPORT"
        Instance_new_51.TextColor3 = var_016.Hot
        Instance_new_51.Font = Enum.Font.GothamBlack
        Instance_new_51.TextSize = 10

        Instance_new_51.MouseButton1Click:Connect(function()
            fn_014("forceSilentAim", true)

            Instance_new_49.Text = "Status: Forced Override"
            Instance_new_49.TextColor3 = var_016.AccentSoft
            Instance_new_50.Visible = false
        end)
    end

    fn_011("silentAim", function(arg_082)
        if arg_082 == true and not var_015 and not var_042.forceSilentAim then
            fn_014("silentAim", false)

            if sendNotification then
                sendNotification("Restricted", "Silent Aim is locked! Click 'IDC NO SUPPORT' first.", 4)
            end
        end
    end)
    fn_041(var_122, "Enable", "silentAim")
    fn_041(var_122, "Ignore Walls / Wallbang", "wallbang")
    fn_041(var_122, "Dynamic Miss (Hit Chance)", "dynamicMiss")
    fn_048(var_122, "Hit Chance %", "baseHitChance", 1, 100, 1)
    fn_043(var_122, "Wallbang Toggle Key", "wallbangToggleKey")
    fn_043(var_122, "Toggle Keybind", "silentAimToggleKey")
    fn_041(var_122, "Show Circle", "showFovCircle")
    fn_048(var_122, "Fov Size", "fovSize", 50, 1E3, 1)

    local var_124 = fn_039(var_118, "Targeting")

    fn_045(var_124, "TargetPart", "targetPart", {
        "Head",
        "UpperTorso",
        "LowerTorso",
        "Random Part",
    })
    fn_041(var_124, "Random Part", "randomPart")
    fn_041(var_124, "360 FOV (All Directions)", "fullFov360")
    fn_041(var_124, "AimWall Check", "aimWallCheck")
    fn_041(var_124, "TeamCheck", "teamCheck")
    fn_052(var_114, var_117, var_119, var_115)
end
local function fn_056()
    local var_125, var_126 = fn_036("Visuals")
    local var_127, var_128 = fn_038(var_125, 0.5, 0)
    local var_129, var_130 = fn_038(var_125, 0.5, 0.5)
    local var_131 = fn_039(var_127, "Visuals")

    fn_041(var_131, "Enable", "visualsEnable")
    fn_043(var_131, "Toggle Keybind", "visualsToggleKey")
    fn_041(var_131, "Boxes", "boxes")
    fn_041(var_131, "3D Box Mode", "box3d")
    fn_041(var_131, "Name ESP", "nameEsp")
    fn_041(var_131, "Distance ESP", "distanceEsp")
    fn_041(var_131, "Money ESP", "moneyEsp")

    local var_132 = fn_039(var_129, "Details")

    fn_041(var_132, "Weapon ESP", "weaponEsp")
    fn_041(var_132, "HP Bar ESP", "hpBar")
    fn_041(var_132, "Skeleton ESP", "skeletonEsp")
    fn_041(var_132, "Chams (Glow)", "chams")
    fn_041(var_132, "Tracers", "tracers")
    fn_041(var_132, "Aim Viewer", "viewTracers")
    fn_048(var_132, "Trace Lenght", "traceLength", 5, 40, 1)
    fn_041(var_132, "Show Teammates", "showTeammates")
    fn_041(var_132, "Team Colors (Auto)", "teamColorsAuto")
    fn_052(var_125, var_128, var_130, var_126)
end
local function fn_057()
    local var_133, var_134 = fn_036("World")
    local var_135, var_136 = fn_038(var_133, 0.5, 0)
    local var_137, var_138 = fn_038(var_133, 0.5, 0.5)
    local var_139 = fn_039(var_135, "World")

    fn_041(var_139, "NightMode", "nightMode")
    fn_043(var_139, "Toggle Keybind", "nightModeToggleKey")
    fn_041(var_139, "Low GFX (FPS boost)", "lowGfx")
    fn_041(var_139, "Anti-Flash", "antiFlash")
    fn_041(var_139, "Anti-Smoke", "antiSmoke")
    fn_041(var_139, "Show Spectators", "showSpectators")

    local var_140 = fn_039(var_137, "World Visuals")

    fn_041(var_140, "Weapon ESP", "worldWeaponEsp")
    fn_041(var_140, "C4 ESP", "c4Esp")
    fn_041(var_140, "Bullet Tracers", "bulletTracers")
    fn_045(var_140, "Tracer Color", "tracerColor", {
        "Yellow",
        "Cyan",
        "Blue",
        "White",
        "Pink",
    })
    fn_041(var_140, "Bomb Trailer (2D)", "bombTrail2d")
    fn_041(var_140, "Third Person", "thirdPerson")
    fn_043(var_140, "Toggle Keybind", "thirdPersonToggleKey")
    fn_048(var_140, "TPS Distance", "tpsDistance", 5, 25, 1)
    fn_052(var_133, var_136, var_138, var_134)
end
local function fn_058(arg_083, arg_084, arg_085)
    local var_141 = fn_040(arg_083, arg_084)

    var_141.Size = UDim2.fromOffset(arg_084, 22)

    local Instance_new_52 = Instance.new("TextBox")

    Instance_new_52.Size = var_007(1, -8, 1, 0)
    Instance_new_52.Position = var_007(0, 4, 0, 0)
    Instance_new_52.BackgroundTransparency = 1
    Instance_new_52.Text = ''
    Instance_new_52.PlaceholderText = arg_085
    Instance_new_52.PlaceholderColor3 = var_016.TextMute
    Instance_new_52.TextColor3 = var_016.Text
    Instance_new_52.Font = Enum.Font.GothamMedium
    Instance_new_52.TextSize = 11
    Instance_new_52.ClearTextOnFocus = false
    Instance_new_52.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_52.Parent = var_141

    return var_141, Instance_new_52
end
local function fn_059(arg_086, arg_087, arg_088, arg_089, arg_090, arg_091, arg_092)
    local Instance_new_53 = Instance.new("Frame")

    Instance_new_53.Name = arg_086 .. "Page"
    Instance_new_53.Size = UDim2.fromScale(1, 1)
    Instance_new_53.BackgroundTransparency = 1
    Instance_new_53.Visible = false
    Instance_new_53.Parent = BodyPages
    var_045[arg_086] = Instance_new_53

    local Instance_new_54 = Instance.new("TextLabel")

    Instance_new_54.Size = var_007(0.5, -10, 0, 14)
    Instance_new_54.Position = UDim2.fromOffset(0, 0)
    Instance_new_54.BackgroundTransparency = 1
    Instance_new_54.Text = arg_087
    Instance_new_54.TextColor3 = var_016.TextMute
    Instance_new_54.Font = Enum.Font.GothamSemibold
    Instance_new_54.TextSize = 11
    Instance_new_54.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_54.Parent = Instance_new_53

    local Instance_new_55 = Instance.new("TextLabel")

    Instance_new_55.Size = var_007(0.5, -10, 0, 14)
    Instance_new_55.Position = var_007(0.5, 10, 0, 0)
    Instance_new_55.BackgroundTransparency = 1
    Instance_new_55.Text = arg_088
    Instance_new_55.TextColor3 = var_016.TextMute
    Instance_new_55.Font = Enum.Font.GothamSemibold
    Instance_new_55.TextSize = 11
    Instance_new_55.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_55.Parent = Instance_new_53

    local var_142, var_143 = fn_058(Instance_new_53, 320, "Search...")

    var_142.Size = var_007(0.5, -10, 0, 22)
    var_142.Position = UDim2.fromOffset(0, 18)

    local var_144, var_145 = fn_058(Instance_new_53, 320, "Search...")

    var_144.Size = var_007(0.5, -10, 0, 22)
    var_144.Position = var_007(0.5, 10, 0, 18)

    local Instance_new_56 = Instance.new("ScrollingFrame")

    Instance_new_56.Size = var_007(0.5, -10, 1, -56)
    Instance_new_56.Position = UDim2.fromOffset(0, 48)
    Instance_new_56.BackgroundTransparency = 1
    Instance_new_56.BorderSizePixel = 0
    Instance_new_56.ScrollBarThickness = 2
    Instance_new_56.ScrollBarImageColor3 = var_016.Accent
    Instance_new_56.ScrollBarImageTransparency = 0.28
    Instance_new_56.Parent = Instance_new_53

    local Instance_new_57 = Instance.new("UIListLayout")

    Instance_new_57.Padding = UDim.new(0, 4)
    Instance_new_57.SortOrder = Enum.SortOrder.LayoutOrder
    Instance_new_57.Parent = Instance_new_56

    local Instance_new_58 = Instance.new("ScrollingFrame")

    Instance_new_58.Size = var_007(0.5, -10, 1, -56)
    Instance_new_58.Position = var_007(0.5, 10, 0, 48)
    Instance_new_58.BackgroundTransparency = 1
    Instance_new_58.BorderSizePixel = 0
    Instance_new_58.ScrollBarThickness = 2
    Instance_new_58.ScrollBarImageColor3 = var_016.Accent
    Instance_new_58.ScrollBarImageTransparency = 0.28
    Instance_new_58.Parent = Instance_new_53

    local Instance_new_59 = Instance.new("UIListLayout")

    Instance_new_59.Padding = UDim.new(0, 4)
    Instance_new_59.SortOrder = Enum.SortOrder.LayoutOrder
    Instance_new_59.Parent = Instance_new_58

    local function fn_060()
        Instance_new_56.CanvasSize = var_007(0, 0, 0, Instance_new_57.AbsoluteContentSize.Y + 6)
        Instance_new_58.CanvasSize = var_007(0, 0, 0, Instance_new_59.AbsoluteContentSize.Y + (6))
    end

    Instance_new_57:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn_060)
    Instance_new_59:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn_060)

    local function fn_061(arg_093, arg_094, arg_095, arg_096)
        local Field = fn_040(arg_093, 0)

        Field.Size = var_007(1, 0, 0, 20)
        Field.BackgroundColor3 = arg_095 and var_016.FieldAlt or var_016.Field

        local Instance_new_60 = Instance.new("TextButton")

        Instance_new_60.Size = UDim2.fromScale(1, 1)
        Instance_new_60.BackgroundTransparency = 1
        Instance_new_60.Text = ''
        Instance_new_60.Parent = Field

        local Instance_new_61 = Instance.new("TextLabel")

        Instance_new_61.Size = var_007(1, -8, 1, 0)
        Instance_new_61.Position = var_007(0, 4, 0, 0)
        Instance_new_61.BackgroundTransparency = 1
        Instance_new_61.Text = arg_094
        Instance_new_61.TextColor3 = arg_095 and var_016.Accent or var_016.TextDim
        Instance_new_61.Font = Enum.Font.GothamMedium
        Instance_new_61.TextSize = 11
        Instance_new_61.TextXAlignment = Enum.TextXAlignment.Left
        Instance_new_61.Parent = Field

        Instance_new_60.MouseButton1Click:Connect(arg_096)
    end
    local function fn_062()
        for it_63, it_64 in ipairs(Instance_new_56:GetChildren())do
            if it_64:IsA("Frame") then
                it_64:Destroy()
            end
        end
        for it_65, it_66 in ipairs(Instance_new_58:GetChildren())do
            if it_66:IsA("Frame") then
                it_66:Destroy()
            end
        end

        local var_146 = fn_004(var_143.Text)

        for it_67, it_68 in ipairs(arg_091)do
            if var_146 == '' or fn_005(it_68, var_146) then
                fn_061(Instance_new_56, it_68, var_042[arg_089] == it_68, function()
                    fn_014(arg_089, it_68)

                    local var_147 = arg_092[it_68] or {
                        "Vanilla",
                    }

                    if not (not table.find(var_147, var_042[arg_090])) then
                    else
                        fn_014(arg_090, var_147[1])
                    end

                    fn_062()
                end)
            end
        end

        local var_148, var_149 = arg_092[var_042[arg_089] ] or {
            "Vanilla",
        }, fn_004(var_145.Text)

        for it_69, it_70 in ipairs(var_148)do
            if not (var_149 == '' or fn_005(it_70, var_149)) then
            else
                fn_061(Instance_new_58, it_70, var_042[arg_090] == it_70, function()
                    fn_014(arg_090, it_70)
                    fn_062()
                end)
            end
        end

        fn_060()
    end

    var_143:GetPropertyChangedSignal("Text"):Connect(fn_062)
    var_145:GetPropertyChangedSignal("Text"):Connect(fn_062)
    fn_011(arg_089, fn_062)
    fn_011(arg_090, fn_062)
    table.insert(var_048, fn_062)
    fn_062()
end
local function fn_063()
    local var_150, var_151 = fn_036("Mics")
    local var_152, var_153 = fn_038(var_150, 0.5, 0)
    local var_154, var_155 = fn_038(var_150, 0.5, 0.5)
    local var_156 = fn_039(var_152, "Mics")

    fn_041(var_156, "Show Watermark", "showWatermark")
    fn_041(var_156, "Show Keybinds", "showKeybinds")
    fn_041(var_156, "Show Hitmarker", "showHitmarkerChat")
    fn_045(var_156, "Hitmarker Mode", "hitmarkerMode", {
        "Chat",
        "Notification",
        "Both",
    })

    local var_157 = fn_039(var_152, "Hitsound")

    fn_041(var_157, "Enable Hitsound", "hitsoundEnable")
    fn_048(var_157, "Volume", "hitsoundVolume", 0, 100, 1)

    local var_158, Instance_new_62 = {
        {
            name = "CS:GO Classic",
            id = "9120386436",
        },
        {
            name = "UwU Hit",
            id = "136020182783782",
        },
        {
            name = "Metal Ding",
            id = "6042053626",
        },
        {
            name = "Bubble Pop",
            id = "9119713951",
        },
        {
            name = "Anime Hit",
            id = "4612378735",
        },
        {
            name = "Punch",
            id = "386946067",
        },
        {
            name = "Laser",
            id = "2865227271",
        },
        {
            name = "Coin",
            id = "4590662766",
        },
    }, Instance.new("Frame")

    Instance_new_62.Size = var_007(1, 0, 0, 0)
    Instance_new_62.AutomaticSize = Enum.AutomaticSize.Y
    Instance_new_62.BackgroundTransparency = 1
    Instance_new_62.Parent = var_157

    local Instance_new_63 = Instance.new("UIListLayout")

    Instance_new_63.Padding = UDim.new(0, 3)
    Instance_new_63.SortOrder = Enum.SortOrder.LayoutOrder
    Instance_new_63.Parent = Instance_new_62

    local function fn_064()
        for it_71, it_72 in ipairs(Instance_new_62:GetChildren())do
            if it_72:IsA("Frame") then
                it_72:Destroy()
            end
        end
        for it_73, it_74 in ipairs(var_158)do
            local Instance_new_64 = Instance.new("Frame")

            Instance_new_64.Size = var_007(1, 0, 0, 20)
            Instance_new_64.BackgroundTransparency = 1
            Instance_new_64.Parent = Instance_new_62

            local var_159, Instance_new_65 = var_042.hitsoundSelectedId == it_74.id, Instance.new("Frame")

            Instance_new_65.Size = UDim2.fromOffset(12, 12)
            Instance_new_65.Position = var_007(0, 2, 0.5, -6)
            Instance_new_65.BackgroundColor3 = var_016.Field
            Instance_new_65.BorderSizePixel = 0
            Instance_new_65.Parent = Instance_new_64

            fn_023(Instance_new_65, 2)
            fn_024(Instance_new_65, var_016.Accent, 1, 4E-2)

            local Instance_new_66 = Instance.new("Frame")

            Instance_new_66.Size = var_007(1, -4, 1, -4)
            Instance_new_66.Position = var_007(0, 2, 0, 2)
            Instance_new_66.BackgroundColor3 = var_016.Accent
            Instance_new_66.BorderSizePixel = 0
            Instance_new_66.Visible = var_159
            Instance_new_66.Parent = Instance_new_65

            fn_023(Instance_new_66, 1)

            local Instance_new_67 = Instance.new("TextLabel")

            Instance_new_67.Size = var_007(1, -80, 1, 0)
            Instance_new_67.Position = var_007(0, 22, 0, 0)
            Instance_new_67.BackgroundTransparency = 1
            Instance_new_67.Text = it_74.name
            Instance_new_67.TextColor3 = var_159 and var_016.Accent or var_016.TextDim
            Instance_new_67.Font = Enum.Font.GothamMedium
            Instance_new_67.TextSize = 11
            Instance_new_67.TextXAlignment = Enum.TextXAlignment.Left
            Instance_new_67.Parent = Instance_new_64

            local Instance_new_68 = Instance.new("TextButton")

            Instance_new_68.Size = UDim2.fromOffset(52, 16)
            Instance_new_68.Position = var_007(1, -54, 0.5, -8)
            Instance_new_68.BackgroundColor3 = var_016.Field
            Instance_new_68.Text = "▶ Test"
            Instance_new_68.TextColor3 = var_016.TextDim
            Instance_new_68.Font = Enum.Font.GothamBold
            Instance_new_68.TextSize = 9
            Instance_new_68.Parent = Instance_new_64

            fn_023(Instance_new_68, 3)
            fn_024(Instance_new_68, var_016.Outline, 1, 0.3)

            local SoundService = Instance.new("TextButton")

            SoundService.Size = var_007(1, -60, 1, 0)
            SoundService.BackgroundTransparency = 1
            SoundService.Text = ''
            SoundService.Parent = Instance_new_64

            SoundService.MouseButton1Click:Connect(function()
                fn_014("hitsoundSelectedId", it_74.id)
                fn_014("hitsoundCustomId", '')
                fn_064()
            end)
            Instance_new_68.MouseButton1Click:Connect(function()
                pcall(function()
                    local SoundService_2 = Instance.new("Sound")

                    SoundService_2.SoundId = "rbxassetid://" .. it_74.id
                    SoundService_2.Volume = (tonumber(var_042.hitsoundVolume) or 80) / (100)
                    SoundService_2.Parent = game:GetService("SoundService")

                    SoundService_2:Play()
                    delay_2(3, function()
                        pcall(function()
                            SoundService_2:Destroy()
                        end)
                    end)
                end)
            end)
        end
    end

    fn_064()

    local Instance_new_69 = Instance.new("Frame")

    Instance_new_69.Size = var_007(1, 0, 0, 20)
    Instance_new_69.BackgroundTransparency = 1
    Instance_new_69.Parent = var_157

    local Instance_new_70 = Instance.new("TextLabel")

    Instance_new_70.Size = var_007(0, 70, 1, 0)
    Instance_new_70.BackgroundTransparency = 1
    Instance_new_70.Text = "Custom ID"
    Instance_new_70.TextColor3 = var_016.Text
    Instance_new_70.Font = Enum.Font.GothamMedium
    Instance_new_70.TextSize = 11
    Instance_new_70.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_70.Parent = Instance_new_69

    local var_160 = fn_040(Instance_new_69, 120)

    var_160.Position = var_007(1, -120, 0, 0)

    local Instance_new_71 = Instance.new("TextBox")

    Instance_new_71.Size = var_007(1, -8, 1, 0)
    Instance_new_71.Position = var_007(0, 4, 0, 0)
    Instance_new_71.BackgroundTransparency = 1
    Instance_new_71.TextColor3 = var_016.TextDim
    Instance_new_71.Font = Enum.Font.GothamBold
    Instance_new_71.TextSize = 10
    Instance_new_71.PlaceholderText = "rbxasset ID..."
    Instance_new_71.PlaceholderColor3 = var_016.TextMute
    Instance_new_71.ClearTextOnFocus = false
    Instance_new_71.Text = var_042.hitsoundCustomId or ''
    Instance_new_71.Parent = var_160

    Instance_new_71.FocusLost:Connect(function()
        local Text = Instance_new_71.Text

        if not (Text ~= '') then
        else
            fn_014("hitsoundCustomId", Text)
            fn_014("hitsoundSelectedId", Text)
            fn_064()
        end
    end)
    fn_011("hitsoundCustomId", function(arg_097)
        Instance_new_71.Text = arg_097 or ''
    end)

    local var_161 = fn_039(var_154, "Movement")

    fn_041(var_161, "Enable Speed/Jump", "movementEnable")
    fn_043(var_161, "Toggle Keybind", "movementToggleKey")
    fn_048(var_161, "Jump Power", "jumpPower", 10, 25, 1)
    fn_048(var_161, "Speed Power", "speedPower", 16, 25, 1)
    fn_041(var_161, "Bunny Hop", "bunnyHop")
    fn_041(var_161, "AirStrafe", "airStrafe")
    fn_048(var_161, "Airstrafe Speed", "airStrafeSpeed", 16, 33, 1)
    fn_052(var_150, var_153, var_155, var_151)
end
local function fn_065()
    local var_162, var_163 = fn_036("Settings")
    local var_164, var_165 = fn_038(var_162, 0.5, 0)
    local var_166, var_167 = fn_038(var_162, 0.5, 0.5)
    local var_168 = fn_039(var_164, "Menu")

    fn_043(var_168, "Menu Toggle Keybind", "menuKey")
    fn_048(var_168, "Menu Size", "menuScale", 80, 130, 1)
    fn_048(var_168, "Menu Background Opacity", "menuOpacity", 35, 100, 1)
    fn_041(var_168, "Blur On Open", "blurOnOpen")
    fn_041(var_168, "Mobile Aimlock Toggle", "mobileAimlockUI")
    fn_041(var_168, "Mobile AutoJump Toggle", "mobileJumpUI")

    local var_169, Instance_new_72 = fn_039(var_166, "Info"), Instance.new("TextLabel")

    Instance_new_72.Size = var_007(1, 0, 0, 34)
    Instance_new_72.BackgroundTransparency = 1
    Instance_new_72.Text = "Only menu close/open and Settings visuals are live. Other tabs are UI-only."
    Instance_new_72.TextWrapped = true
    Instance_new_72.TextColor3 = var_016.TextMute
    Instance_new_72.Font = Enum.Font.GothamMedium
    Instance_new_72.TextSize = 11
    Instance_new_72.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_72.TextYAlignment = Enum.TextYAlignment.Top
    Instance_new_72.Parent = var_169

    fn_052(var_162, var_165, var_167, var_163)
end
local function fn_066(arg_098)
    local var_170 = fn_019()

    var_170[arg_098] = fn_017()

    return fn_020(var_170)
end
local function fn_067(arg_099)
    local var_171 = fn_019()
    local var_172 = var_171[arg_099]

    if not (type(var_172) ~= "table") then
    else
        return false, "Config not found"
    end

    for it_75, it_76 in pairs(var_172)do
        if var_042[it_75] ~= nil then
            var_042[it_75] = fn_018(it_76)
        end
    end

    fn_021()
    fn_013()

    return true, "Loaded"
end
local function fn_068()
    local var_173, var_174 = fn_036("Model Changer")
    local var_175, var_176 = fn_038(var_173, 0.5, 0)
    local var_177, var_178 = fn_038(var_173, 0.5, 0.5)
    local var_179 = fn_039(var_175, "Model Settings")

    fn_041(var_179, "Enable Custom Model", "enableCustomModel")
    fn_047(var_179, "Custom Model ID", "customModelId")

    local var_180, Instance_new_73 = fn_039(var_175, "Preset Models"), Instance.new("Frame")

    Instance_new_73.Size = var_007(1, 0, 0, 160)
    Instance_new_73.BackgroundTransparency = 1
    Instance_new_73.Parent = var_180

    local Instance_new_74 = Instance.new("UIListLayout")

    Instance_new_74.Padding = UDim.new(0, 4)
    Instance_new_74.SortOrder = Enum.SortOrder.LayoutOrder
    Instance_new_74.Parent = Instance_new_73

    local var_181 = {
        {
            "Miku",
            "81420911257826",
        },
        {
            "Default",
            "0",
        },
    }

    for it_77, it_78 in ipairs(var_181)do
        local Instance_new_75 = Instance.new("TextButton")

        Instance_new_75.Size = var_007(1, 0, 0, 24)
        Instance_new_75.BackgroundColor3 = var_016.Field
        Instance_new_75.Text = it_78[1]
        Instance_new_75.TextColor3 = var_016.TextDim
        Instance_new_75.Font = Enum.Font.GothamMedium
        Instance_new_75.TextSize = 11
        Instance_new_75.Parent = Instance_new_73

        fn_023(Instance_new_75, 3)
        fn_024(Instance_new_75, var_016.Outline, 1, 0.2)
        Instance_new_75.MouseButton1Click:Connect(function()
            fn_014("customModelId", it_78[2])
        end)
    end

    local function fn_069()
        Instance_new_73.Size = var_007(1, 0, 0, Instance_new_74.AbsoluteContentSize.Y)
    end

    Instance_new_74:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fn_069)
    fn_069()
    fn_052(var_173, var_176, var_178, var_174)
end
local function fn_070()
    local var_182, var_183 = fn_036("Configs")
    local var_184, var_185 = fn_038(var_182, 0.5, 0)
    local var_186, var_187 = fn_038(var_182, 0.5, 0.5)
    local var_188, Instance_new_76 = fn_039(var_184, "Configs"), Instance.new("Frame")

    Instance_new_76.Size = var_007(1, 0, 0, 22)
    Instance_new_76.BackgroundTransparency = 1
    Instance_new_76.Parent = var_188

    local Instance_new_77 = Instance.new("TextLabel")

    Instance_new_77.Size = var_007(0, 84, 1, 0)
    Instance_new_77.BackgroundTransparency = 1
    Instance_new_77.Text = "Config Name"
    Instance_new_77.TextColor3 = var_016.Text
    Instance_new_77.Font = Enum.Font.GothamMedium
    Instance_new_77.TextSize = 12
    Instance_new_77.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_77.Parent = Instance_new_76

    local Connect_2 = fn_040(Instance_new_76, 180)

    Connect_2.Position = var_007(1, -180, 0, 0)
    var_080 = Instance.new("TextBox")
    var_080.Size = var_007(1, -8, 1, 0)
    var_080.Position = var_007(0, 4, 0, 0)
    var_080.BackgroundTransparency = 1
    var_080.Text = var_042.configName
    var_080.PlaceholderText = "Default"
    var_080.PlaceholderColor3 = var_016.TextMute
    var_080.TextColor3 = var_016.Text
    var_080.Font = Enum.Font.GothamMedium
    var_080.TextSize = 11
    var_080.ClearTextOnFocus = false
    var_080.TextXAlignment = Enum.TextXAlignment.Left
    var_080.Parent = Connect_2

    var_080.FocusLost:Connect(function()
        local var_189 = var_080.Text ~= '' and var_080.Text or "Default"

        fn_014("configName", var_189)
    end)

    local Instance_new_78 = Instance.new("Frame")

    Instance_new_78.Size = var_007(1, 0, 0, 24)
    Instance_new_78.BackgroundTransparency = 1
    Instance_new_78.Parent = var_188

    local Instance_new_79 = Instance.new("UIListLayout")

    Instance_new_79.FillDirection = Enum.FillDirection.Horizontal
    Instance_new_79.Padding = UDim.new(0, 6)
    Instance_new_79.SortOrder = Enum.SortOrder.LayoutOrder
    Instance_new_79.Parent = Instance_new_78

    local function fn_071(arg_100, arg_101)
        local var_190 = fn_040(Instance_new_78, 86)

        var_190.Size = UDim2.fromOffset(86, 24)

        local Instance_new_80 = Instance.new("TextButton")

        Instance_new_80.Size = UDim2.fromScale(1, 1)
        Instance_new_80.BackgroundTransparency = 1
        Instance_new_80.Text = arg_100
        Instance_new_80.TextColor3 = arg_101 or var_016.Text
        Instance_new_80.Font = Enum.Font.GothamBold
        Instance_new_80.TextSize = 11
        Instance_new_80.Parent = var_190

        return Instance_new_80
    end

    local var_191, var_192 = fn_071("Save", var_016.Accent), fn_071("Load", var_016.Text)

    var_079 = Instance.new("TextLabel")
    var_079.Size = var_007(1, 0, 0, 14)
    var_079.BackgroundTransparency = 1
    var_079.Text = "UI presets only"
    var_079.TextColor3 = var_016.TextMute
    var_079.Font = Enum.Font.GothamMedium
    var_079.TextSize = 11
    var_079.TextXAlignment = Enum.TextXAlignment.Left
    var_079.Parent = var_188

    local var_193, Instance_new_81 = fn_039(var_184, "Saved Configs"), Instance.new("Frame")

    Instance_new_81.Size = var_007(1, 0, 0, 0)
    Instance_new_81.AutomaticSize = Enum.AutomaticSize.Y
    Instance_new_81.BackgroundTransparency = 1
    Instance_new_81.Parent = var_193

    local Instance_new_82 = Instance.new("UIListLayout")

    Instance_new_82.Padding = UDim.new(0, 3)
    Instance_new_82.SortOrder = Enum.SortOrder.LayoutOrder
    Instance_new_82.Parent = Instance_new_81

    local function fn_072()
        for it_79, it_80 in ipairs(Instance_new_81:GetChildren())do
            if not (it_80:IsA("GuiObject")) then
            else
                it_80:Destroy()
            end
        end

        local var_194, var_195 = fn_019(), false

        for it_81, it_82 in pairs(var_194)do
            var_195 = true

            local Instance_new_83 = Instance.new("Frame")

            Instance_new_83.Size = var_007(1, 0, 0, 22)
            Instance_new_83.BackgroundTransparency = 1
            Instance_new_83.Parent = Instance_new_81

            local var_196, Instance_new_84 = var_042.configName == it_81, Instance.new("TextButton")

            Instance_new_84.Size = var_007(1, -26, 1, 0)
            Instance_new_84.BackgroundColor3 = var_196 and var_016.FieldAlt or var_016.Field
            Instance_new_84.Text = ''
            Instance_new_84.BorderSizePixel = 0
            Instance_new_84.Parent = Instance_new_83

            fn_023(Instance_new_84, 3)
            fn_024(Instance_new_84, var_196 and var_016.Accent or var_016.Outline, 1, var_196 and 0.1 or 0.3)

            local Instance_new_85 = Instance.new("TextLabel")

            Instance_new_85.Size = var_007(1, -8, 1, 0)
            Instance_new_85.Position = var_007(0, 6, 0, 0)
            Instance_new_85.BackgroundTransparency = 1
            Instance_new_85.Text = it_81
            Instance_new_85.TextColor3 = var_196 and var_016.Accent or var_016.TextDim
            Instance_new_85.Font = Enum.Font.GothamBold
            Instance_new_85.TextSize = 11
            Instance_new_85.TextXAlignment = Enum.TextXAlignment.Left
            Instance_new_85.Parent = Instance_new_84

            local Instance_new_86 = Instance.new("TextButton")

            Instance_new_86.Size = UDim2.fromOffset(22, 22)
            Instance_new_86.Position = var_007(1, -22, 0, 0)
            Instance_new_86.BackgroundColor3 = fromRGB(60, 20, 20)
            Instance_new_86.Text = "✕"
            Instance_new_86.TextColor3 = var_016.Hot
            Instance_new_86.Font = Enum.Font.GothamBold
            Instance_new_86.TextSize = 10
            Instance_new_86.BorderSizePixel = 0
            Instance_new_86.Parent = Instance_new_83

            fn_023(Instance_new_86, 3)
            fn_024(Instance_new_86, var_016.Hot, 1, 0.5)
            Instance_new_84.MouseButton1Click:Connect(function()
                fn_014("configName", it_81)

                if not (var_080) then
                else
                    var_080.Text = it_81
                end

                local var_197, var_198 = fn_067(it_81)

                var_079.Text = var_197 and ("Loaded: " .. it_81) or var_198
                var_079.TextColor3 = var_197 and var_016.Accent or var_016.Hot

                fn_072()
            end)
            Instance_new_86.MouseButton1Click:Connect(function()
                local var_199 = fn_019()

                var_199[it_81] = nil

                fn_020(var_199)

                if not (var_042.configName == it_81) then
                else
                    fn_014("configName", "Default")

                    if var_080 then
                        var_080.Text = "Default"
                    end
                end

                var_079.Text = "Deleted: " .. it_81
                var_079.TextColor3 = var_016.Hot

                fn_072()
            end)
        end

        if not var_195 then
            local Instance_new_87 = Instance.new("TextLabel")

            Instance_new_87.Size = var_007(1, 0, 0, 18)
            Instance_new_87.BackgroundTransparency = 1
            Instance_new_87.Text = "No saved configs"
            Instance_new_87.TextColor3 = var_016.TextMute
            Instance_new_87.Font = Enum.Font.GothamMedium
            Instance_new_87.TextSize = 11
            Instance_new_87.TextXAlignment = Enum.TextXAlignment.Left
            Instance_new_87.Parent = Instance_new_81
        end
    end

    var_191.MouseButton1Click:Connect(function()
        local var_200 = var_080.Text ~= '' and var_080.Text or "Default"

        fn_014("configName", var_200)

        local var_201, var_202 = fn_066(var_200)

        var_079.Text = var_201 and ("Saved: " .. var_200) or var_202
        var_079.TextColor3 = var_201 and var_016.Accent or var_016.Hot

        fn_072()
    end)
    var_192.MouseButton1Click:Connect(function()
        local var_203 = var_080.Text ~= '' and var_080.Text or "Default"
        local var_204, var_205 = fn_067(var_203)

        var_079.Text = var_204 and ("Loaded: " .. var_203) or var_205
        var_079.TextColor3 = var_204 and var_016.Accent or var_016.Hot

        fn_072()
    end)
    fn_072()

    local k, Instance_new_88 = fn_039(var_186, "Notes"), Instance.new("TextLabel")

    Instance_new_88.Size = var_007(1, 0, 0, 36)
    Instance_new_88.BackgroundTransparency = 1
    Instance_new_88.Text = "Click a config to load it. ✕ to delete. Type a name and Save to create new."
    Instance_new_88.TextWrapped = true
    Instance_new_88.TextColor3 = var_016.TextMute
    Instance_new_88.Font = Enum.Font.GothamMedium
    Instance_new_88.TextSize = 11
    Instance_new_88.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_88.TextYAlignment = Enum.TextYAlignment.Top
    Instance_new_88.Parent = k

    fn_052(var_182, var_185, var_187, var_183)
end

fn_054()
fn_055()
fn_056()
fn_057()
fn_059("GunSkins", "Weapons", "Skins", "selectedGun", "selectedGunSkin", var_034.gunNames, var_034.gunSkins)
fn_059("Knives", "Knives", "Knife Skins", "selectedKnife", "selectedKnifeSkin", var_034.knifeNames, var_034.knifeSkins)
fn_059("Gloves", "Gloves", "Glove Skins", "selectedGlove", "selectedGloveSkin", var_034.gloveNames, var_034.gloveSkins)
fn_063()
fn_068()
fn_070()
fn_065()

local var_206 = {
    "Legitbot",
    "Ragebot",
    "Visuals",
    "World",
    "GunSkins",
    "Knives",
    "Gloves",
    "Mics",
    "Model Changer",
    "Configs",
    "Settings",
}

for it_83, it_84 in ipairs(var_206)do
    fn_035(it_84, it_83)
end

local var_207 = false
local var_208
local var_209
local var_210, var_211, var_212 = false, var_005(0, 0), var_005(GetAttribute.X, GetAttribute.Y)

local function fn_073(arg_102)
    if arg_102.UserInputType == Enum.UserInputType.MouseButton1 or arg_102.UserInputType == Enum.UserInputType.Touch then
        var_207 = true
        var_208 = arg_102.Position
        var_209 = Main.Position
    end
end
local function fn_074(arg_103)
    if arg_103.UserInputType == Enum.UserInputType.MouseButton1 or arg_103.UserInputType == Enum.UserInputType.Touch then
        var_207 = false
    end
end
local function fn_075(arg_104)
    if not (arg_104.UserInputType == Enum.UserInputType.MouseButton1 or arg_104.UserInputType == Enum.UserInputType.Touch) then
    else
        var_210 = true
        var_211 = var_005(arg_104.Position.X, arg_104.Position.Y)
        var_212 = Main.AbsoluteSize
    end
end
local function fn_076(arg_105)
    if arg_105.UserInputType == Enum.UserInputType.MouseButton1 or arg_105.UserInputType == Enum.UserInputType.Touch then
        var_210 = false
    end
end

DragHandle.InputBegan:Connect(fn_073)
DragHandle.InputEnded:Connect(fn_074)
LogoImage.InputBegan:Connect(fn_073)
LogoImage.InputEnded:Connect(fn_074)
ResizeHandle.InputBegan:Connect(fn_075)
ResizeHandle.InputEnded:Connect(fn_076)
UserInputService.InputChanged:Connect(function(arg_106)
    if var_210 and (arg_106.UserInputType == Enum.UserInputType.MouseMovement or arg_106.UserInputType == Enum.UserInputType.Touch) then
        local var_213 = var_005(arg_106.Position.X, arg_106.Position.Y) - var_211
        local var_214, var_215 = math.max(560, var_212.X + var_213.X), math.max(360, var_212.Y + var_213.Y)

        Main.Size = UDim2.fromOffset(floor(var_214 + (0.5)), floor(var_215 + (0.5)))
        var_042.menuScale = floor((var_214 / GetAttribute.X) * (100) + (0.5))

        return
    end
    if not (var_207 and (arg_106.UserInputType == Enum.UserInputType.MouseMovement or arg_106.UserInputType == Enum.UserInputType.Touch)) then
    else
        local var_216 = arg_106.Position - var_208

        Main.Position = var_007(var_209.X.Scale, var_209.X.Offset + var_216.X, var_209.Y.Scale, var_209.Y.Offset + var_216.Y)
    end
end)
UserInputService.InputEnded:Connect(fn_074)
UserInputService.InputEnded:Connect(fn_076)
UserInputService.InputBegan:Connect(function(arg_107, arg_108)
    if not (var_078) then
    else
        if arg_107.KeyCode == Enum.KeyCode.Escape then
            var_078 = nil

            for it_85, it_86 in pairs(var_047)do
                it_86()
            end

            return
        end
        if not (arg_107.KeyCode == Enum.KeyCode.Backspace) then
        else
            fn_014(var_078, Enum.KeyCode.Unknown)

            var_078 = nil

            for it_87, it_88 in pairs(var_047)do
                it_88()
            end

            return
        end
        if not (arg_107.KeyCode ~= Enum.KeyCode.Unknown) then
        else
            fn_014(var_078, arg_107.KeyCode)

            var_078 = nil

            for it_89, it_90 in pairs(var_047)do
                it_90()
            end

            return
        end
        if arg_107.UserInputType == Enum.UserInputType.MouseButton2 or arg_107.UserInputType == Enum.UserInputType.MouseButton3 then
            fn_014(var_078, arg_107.UserInputType)

            var_078 = nil

            for it_91, it_92 in pairs(var_047)do
                it_92()
            end

            return
        end
    end
    if fn_016(arg_107, var_042.menuKey) then
        fn_031(not var_042.menuOpen)

        return
    end
    if not (arg_108) then
    else
        return
    end
    if UserInputService:GetFocusedTextBox() then
        return
    end

    local var_217 = false

    for it_93, it_94 in ipairs(var_049)do
        if it_94.bindKey ~= "menuKey" and fn_016(arg_107, var_042[it_94.bindKey]) then
            fn_014(it_94.stateKey, not var_042[it_94.stateKey])

            var_217 = true
        end
    end

    if not (var_217) then
    else
        return
    end
end)

local y = Instance.new("Frame")

y.Name = "NotificationArea"
y.Size = var_007(0, 300, 1, -40)
y.Position = var_007(1, -320, 0, 20)
y.BackgroundTransparency = 1
y.Parent = Instance_new

local Instance_new_89 = Instance.new("UIListLayout")

Instance_new_89.SortOrder = Enum.SortOrder.LayoutOrder
Instance_new_89.VerticalAlignment = Enum.VerticalAlignment.Top
Instance_new_89.HorizontalAlignment = Enum.HorizontalAlignment.Right
Instance_new_89.Padding = UDim.new(0, 10)
Instance_new_89.Parent = y

local function fn_077(arg_109, arg_110, arg_111)
    arg_111 = arg_111 or 5

    local Instance_new_90 = Instance.new("Frame")

    Instance_new_90.Size = var_007(0, 280, 0, 60)
    Instance_new_90.BackgroundTransparency = 1
    Instance_new_90.Parent = y

    local Instance_new_91 = Instance.new("Frame")

    Instance_new_91.Size = UDim2.fromScale(1, 1)
    Instance_new_91.Position = var_007(1, 20, 0, 0)
    Instance_new_91.BackgroundColor3 = var_016.Main
    Instance_new_91.BorderSizePixel = 0
    Instance_new_91.Parent = Instance_new_90

    fn_023(Instance_new_91, 4)
    fn_024(Instance_new_91, var_016.Outline, 1, 0.4)

    local Instance_new_92 = Instance.new("Frame")

    Instance_new_92.Size = var_007(1, -2, 0, 2)
    Instance_new_92.Position = var_007(0, 1, 0, 1)
    Instance_new_92.BorderSizePixel = 0
    Instance_new_92.Parent = Instance_new_91

    fn_025(Instance_new_92, ColorSequence.new{
        ColorSequenceKeypoint.new(0, var_016.Accent),
        ColorSequenceKeypoint.new(0.55, var_016.AccentSoft),
        ColorSequenceKeypoint.new(1, var_016.AccentSoft),
    }, 0)

    local Instance_new_93 = Instance.new("ImageLabel")

    Instance_new_93.Size = UDim2.fromOffset(36, 36)
    Instance_new_93.Position = var_007(0, 12, 0.5, -18)
    Instance_new_93.BackgroundTransparency = 1
    Instance_new_93.Image = "rbxassetid://80180896525224"
    Instance_new_93.ScaleType = Enum.ScaleType.Fit
    Instance_new_93.ImageTransparency = 0.1
    Instance_new_93.Parent = Instance_new_91

    local Instance_new_94 = Instance.new("TextLabel")

    Instance_new_94.Size = var_007(1, -64, 0, 16)
    Instance_new_94.Position = var_007(0, 56, 0, 10)
    Instance_new_94.BackgroundTransparency = 1
    Instance_new_94.Text = arg_109
    Instance_new_94.TextColor3 = var_016.AccentSoft
    Instance_new_94.Font = Enum.Font.GothamBlack
    Instance_new_94.TextSize = 13
    Instance_new_94.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_94.Parent = Instance_new_91

    local Instance_new_95 = Instance.new("TextLabel")

    Instance_new_95.Size = var_007(1, -64, 0, 28)
    Instance_new_95.Position = var_007(0, 56, 0, 26)
    Instance_new_95.BackgroundTransparency = 1
    Instance_new_95.Text = arg_110
    Instance_new_95.TextColor3 = var_016.TextMute
    Instance_new_95.Font = Enum.Font.GothamMedium
    Instance_new_95.TextSize = 11
    Instance_new_95.TextXAlignment = Enum.TextXAlignment.Left
    Instance_new_95.TextYAlignment = Enum.TextYAlignment.Top
    Instance_new_95.TextWrapped = true
    Instance_new_95.Parent = Instance_new_91

    local Create, Create_2 = TweenService:Create(Instance_new_91, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = var_007(0, 0, 0, 0),
    }), TweenService:Create(Instance_new_91, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = var_007(1, 20, 0, 0),
    })

    Create:Play()
    spawn_2(function()
        wait_2(arg_111)
        Create_2:Play()
        Create_2.Completed:Wait()
        Instance_new_90:Destroy()
    end)
end

fn_077("WYVERN", "Press the V key to close the interface.\nHave a good game!", 6)

local RunService, Workspace = game:GetService("RunService"), game:GetService("Workspace")
local CurrentCamera, FindFirstChild_6 = Workspace.CurrentCamera, Workspace:FindFirstChild("Characters")

RunService.RenderStepped:Connect(function()
    local Character = LocalPlayer.Character

    if not (Character) then
    else
        local FindFirstChildOfClass_3, FindFirstChild_7 = Character:FindFirstChildOfClass("Humanoid"), Character:FindFirstChild("HumanoidRootPart")

        if not (FindFirstChildOfClass_3 and FindFirstChild_7) then
        else
            local Anchoredorfalse, IsKeyDown = FindFirstChild_7.Anchored or false, UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.D)

            if not Anchoredorfalse then
                if var_042.movementEnable then
                    FindFirstChildOfClass_3.WalkSpeed = tonumber(var_042.speedPower) or 16
                    FindFirstChildOfClass_3.UseJumpPower = true
                    FindFirstChildOfClass_3.JumpPower = tonumber(var_042.jumpPower) or 25
                end
                if var_042.bunnyHop and (UserInputService:IsKeyDown(Enum.KeyCode.Space) or var_042.mobileJumpActive) and IsKeyDown then
                    if not (FindFirstChildOfClass_3.FloorMaterial ~= Enum.Material.Air) then
                    else
                        FindFirstChildOfClass_3.Jump = true
                    end
                end
                if var_042.airStrafe and (FindFirstChildOfClass_3:GetState() == Enum.HumanoidStateType.Freefall or FindFirstChildOfClass_3.FloorMaterial == Enum.Material.Air) then
                    local LookVector, RightVector, var_218 = CurrentCamera.CFrame.LookVector, CurrentCamera.CFrame.RightVector, var_004(0, 0, 0)

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        var_218 = var_218 + LookVector
                    end
                    if not (UserInputService:IsKeyDown(Enum.KeyCode.S)) then
                    else
                        var_218 = var_218 - LookVector
                    end
                    if not (UserInputService:IsKeyDown(Enum.KeyCode.A)) then
                    else
                        var_218 = var_218 - RightVector
                    end
                    if not (UserInputService:IsKeyDown(Enum.KeyCode.D)) then
                    else
                        var_218 = var_218 + RightVector
                    end

                    var_218 = var_004(var_218.X, 0, var_218.Z)

                    if var_218.Magnitude > 0 then
                        var_218 = var_218.Unit

                        local var_219, var_220 = tonumber(var_042.airStrafeSpeed) or 16, FindFirstChild_7.AssemblyLinearVelocity

                        FindFirstChild_7.AssemblyLinearVelocity = var_004(var_218.X * var_219, var_220.Y, var_218.Z * var_219)
                    end
                end
            end
        end
    end
end)
RunService.RenderStepped:Connect(function()
    local Character_2 = LocalPlayer.Character

    if not Character_2 then
        return
    end
    if not (var_042.thirdPerson) then
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson

        for it_95, it_96 in ipairs(CurrentCamera:GetChildren())do
            if it_96:IsA("Model") then
                for it_97, it_98 in ipairs(it_96:GetDescendants())do
                    if not (it_98:IsA("BasePart")) then
                    else
                        it_98.LocalTransparencyModifier = 0
                    end
                end
            end
        end
    else
        for it_99, it_100 in ipairs(Character_2:GetDescendants())do
            if it_100:IsA("BasePart") and it_100.Name ~= "HumanoidRootPart" then
                it_100.LocalTransparencyModifier = 0
            end
        end

        LocalPlayer.CameraMode = Enum.CameraMode.Classic

        local var_221 = tonumber(var_042.tpsDistance) or 8

        CurrentCamera.CFrame = CurrentCamera.CFrame * var_006(0, 0, var_221)

        for it_101, it_102 in ipairs(CurrentCamera:GetChildren())do
            if not (it_102:IsA("Model")) then
            else
                for it_103, it_104 in ipairs(it_102:GetDescendants())do
                    if not (it_104:IsA("BasePart")) then
                    else
                        it_104.LocalTransparencyModifier = 1
                    end
                end
            end
        end
    end
end)
fn_011("nightMode", function(arg_112)
    if arg_112 then
        local FindFirstChild_8 = CurrentCamera:FindFirstChild("WyvernNight")

        if not (not FindFirstChild_8) then
        else
            FindFirstChild_8 = Instance.new("ColorCorrectionEffect")
            FindFirstChild_8.Name = "WyvernNight"
            FindFirstChild_8.Parent = CurrentCamera
        end

        FindFirstChild_8.TintColor = fromRGB(100, 100, 160)
        FindFirstChild_8.Brightness = -0.15
        FindFirstChild_8.Contrast = 0.2
        FindFirstChild_8.Enabled = true
    else
        local FindFirstChild_9 = CurrentCamera:FindFirstChild("WyvernNight")

        if FindFirstChild_9 then
            pcall(function()
                FindFirstChild_9:Destroy()
            end)
        end
    end
end)

do
    local var_222 = mousemoverel or (Input and Input.MouseMoveRel)

    isTeammate = function(arg_113)
        if not (not var_042.teamCheck) then
        else
            return false
        end

        local FindFirstChild_10 = Workspace:FindFirstChild("Characters")

        if FindFirstChild_10 then
            local var_223 = nil

            if FindFirstChild_10:FindFirstChild("Terrorists") and FindFirstChild_10.Terrorists:FindFirstChild(LocalPlayer.Name) then
                var_223 = "Terrorists"
            elseif not (FindFirstChild_10:FindFirstChild("Counter-Terrorists") and FindFirstChild_10["Counter-Terrorists"]:FindFirstChild(LocalPlayer.Name)) then
            else
                var_223 = "Counter-Terrorists"
            end
            if not (var_223 and FindFirstChild_10:FindFirstChild(var_223) and arg_113:IsDescendantOf(FindFirstChild_10[var_223])) then
            else
                return true
            end
        end

        return false
    end
    isVisible = function(arg_114)
        if var_042.wallbang then
            return true
        end
        if not (not var_042.aimWallCheck) then
        else
            return true
        end

        local Position = CurrentCamera.CFrame.Position
        local var_224, RaycastParams_new = arg_114.Position - Position, RaycastParams.new()

        RaycastParams_new.FilterType = Enum.RaycastFilterType.Exclude

        local var_225 = {
            CurrentCamera,
            LocalPlayer.Character,
        }

        if not (Workspace:FindFirstChild("Debris")) then
        else
            table.insert(var_225, Workspace.Debris)
        end
        if Workspace:FindFirstChild("RaycastVisualizers") then
            table.insert(var_225, Workspace.RaycastVisualizers)
        end

        local FindFirstChild_11 = Workspace:FindFirstChild("Characters")

        if not (FindFirstChild_11) then
        else
            for it_105, it_106 in pairs(FindFirstChild_11:GetChildren())do
                for it_107, it_108 in pairs(it_106:GetChildren())do
                    if not (it_108 ~= arg_114.Parent and (isTeammate(it_108) or it_108.Name == LocalPlayer.Name)) then
                    else
                        table.insert(var_225, it_108)
                    end
                end
            end
        end

        local var_226 = 0

        while var_226 < 15 do
            var_226 = var_226 + 1
            RaycastParams_new.FilterDescendantsInstances = var_225

            local Raycast = Workspace:Raycast(Position, var_224, RaycastParams_new)

            if not (Raycast) then
                return true
            else
                if not (Raycast.Instance:IsDescendantOf(arg_114.Parent)) then
                    if not (Raycast.Instance.Transparency >= 0.5 or not Raycast.Instance.CanCollide or find_2(lower(Raycast.Instance.Name), "hitbox") or Raycast.Instance.Name == "Glass") then
                        return false
                    else
                        table.insert(var_225, Raycast.Instance)
                    end
                else
                    return true
                end
            end
        end

        return false
    end
    getAimTarget = function()
        local var_227, var_228, var_229, FindFirstChild_12 = nil, tonumber(var_042.aimlockFov) or 150, var_005(CurrentCamera.ViewportSize.X / (2), CurrentCamera.ViewportSize.Y / (2)), Workspace:FindFirstChild("Characters")

        if not (not FindFirstChild_12) then
        else
            return nil
        end

        for it_109, it_110 in pairs(FindFirstChild_12:GetChildren())do
            for it_111, it_112 in pairs(it_110:GetChildren())do
                if it_112:IsA("Model") and it_112.Name ~= LocalPlayer.Name and not isTeammate(it_112) then
                    local FindFirstChildOfClass_4, targetPart = it_112:FindFirstChildOfClass("Humanoid"), var_042.targetPart

                    if not (targetPart == "Random Part" or var_042.randomPart) then
                    else
                        local var_230 = {
                            "Head",
                            "UpperTorso",
                            "LowerTorso",
                        }

                        targetPart = var_230[random(1, #var_230)]
                    end

                    local FindFirstChild_13 = it_112:FindFirstChild(targetPart) or it_112:FindFirstChild("Head")

                    if not (FindFirstChildOfClass_4 and FindFirstChildOfClass_4.Health > 0 and FindFirstChild_13) then
                    else
                        local WorldToViewportPoint, var_231 = CurrentCamera:WorldToViewportPoint(FindFirstChild_13.Position)

                        if var_231 or var_042.wallbang then
                            local Magnitude = (var_005(WorldToViewportPoint.X, WorldToViewportPoint.Y) - var_229).Magnitude

                            if not (Magnitude < var_228) then
                            else
                                if not (isVisible(FindFirstChild_13)) then
                                else
                                    var_227 = FindFirstChild_13
                                    var_228 = Magnitude
                                end
                            end
                        end
                    end
                end
            end
        end

        return var_227
    end

    local Connect_3 = nil

    RunService.RenderStepped:Connect(function()
        if not var_042.aimlock and not var_042.flickBot then
            return
        end

        local var_232 = var_042.mobileAimlockActive == true

        if not (not var_232 and typeof(var_042.aimlockHoldKey) == "EnumItem") then
        else
            if var_042.aimlockHoldKey.EnumType == Enum.UserInputType then
                var_232 = UserInputService:IsMouseButtonPressed(var_042.aimlockHoldKey)
            elseif not (var_042.aimlockHoldKey.EnumType == Enum.KeyCode) then
            else
                var_232 = UserInputService:IsKeyDown(var_042.aimlockHoldKey)
            end
        end

        local IsMouseButtonPressed, var_233 = var_042.flickBot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1), var_005(CurrentCamera.ViewportSize.X / (2), CurrentCamera.ViewportSize.Y / (2))

        if IsMouseButtonPressed then
            local var_234 = getAimTarget()

            if var_234 then
                local WorldToViewportPoint_2, var_235 = CurrentCamera:WorldToViewportPoint(var_234.Position)

                if not (var_235 or var_042.wallbang) then
                else
                    local var_236, var_237 = floor((WorldToViewportPoint_2.X - var_233.X) * (0.7)), floor((WorldToViewportPoint_2.Y - var_233.Y) * (0.7))

                    if var_222 then
                        pcall(function()
                            var_222(var_236, var_237)
                        end)
                    end
                end
            end
        elseif not (var_042.aimlock and var_232) then
            Connect_3 = nil
        else
            if not Connect_3 or not Connect_3.Parent or not Connect_3:IsDescendantOf(Workspace) then
                Connect_3 = getAimTarget()
            else
                local FindFirstChildOfClass_5 = Connect_3.Parent:FindFirstChildOfClass("Humanoid")

                if not (not FindFirstChildOfClass_5 or FindFirstChildOfClass_5.Health <= 0) then
                    if var_042.aimWallCheck and not isVisible(Connect_3) then
                        Connect_3 = getAimTarget()
                    end
                else
                    Connect_3 = getAimTarget()
                end
            end
            if Connect_3 then
                local Position_2, FindFirstChild_14 = Connect_3.Position, Connect_3.Parent:FindFirstChild("HumanoidRootPart")

                if FindFirstChild_14 then
                    local var_238 = (Position_2 - CurrentCamera.CFrame.Position).Magnitude

                    Position_2 = Position_2 + (FindFirstChild_14.AssemblyLinearVelocity * (var_238 / (15E2)))
                end

                local WorldToViewportPoint_3, var_239 = CurrentCamera:WorldToViewportPoint(Position_2)

                if not (var_239 or var_042.wallbang) then
                else
                    local var_240 = tonumber(var_042.aimJitter) or 10
                    local var_241 = var_240 / (100)
                    local var_242, var_243, var_244 = (random() - (0.5)) * var_241 * (2), (random() - (0.5)) * var_241 * (2), tonumber(var_042.aimSmoothness) or 2
                    local var_245, var_246, var_247 = var_244 + (random() * (0.3)), (WorldToViewportPoint_3.X - var_233.X) + var_242, (WorldToViewportPoint_3.Y - var_233.Y) + var_243

                    if var_222 then
                        local var_248, var_249 = floor(var_246 / var_245), floor(var_247 / var_245)

                        if not (var_008(var_248) < 1E3 and var_008(var_249) < 1E3) then
                        else
                            pcall(function()
                                var_222(var_248, var_249)
                            end)
                        end
                    else
                        local Lerp = CFrame.lookAt(CurrentCamera.CFrame.Position, Position_2 + var_004(var_242, var_243, 0))

                        CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(Lerp, 0.6)
                    end
                end
            end
        end
    end)
end

local var_250, Connect_4 = setmetatable({}, {
    __mode = "k",
}), setmetatable({}, {
    __mode = "k",
})

RunService.RenderStepped:Connect(function()
    local FindFirstChild_15 = Workspace:FindFirstChild("Characters")

    if not FindFirstChild_15 then
        return
    end

    for it_113, it_114 in pairs(FindFirstChild_15:GetChildren())do
        for it_115, it_116 in pairs(it_114:GetChildren())do
            if not (it_116:IsA("Model") and it_116.Name ~= LocalPlayer.Name) then
            else
                if not isTeammate(it_116) then
                    local FindFirstChildOfClass_6, targetPart_2 = it_116:FindFirstChildOfClass("Humanoid"), var_042.targetPart

                    if not (targetPart_2 == "Random Part") then
                    else
                        targetPart_2 = "Head"
                    end

                    local FindFirstChild_16 = it_116:FindFirstChild(targetPart_2) or it_116:FindFirstChild("Head")

                    if FindFirstChildOfClass_6 and FindFirstChildOfClass_6.Health > 0 and FindFirstChild_16 and FindFirstChild_16:IsA("BasePart") then
                        if not (not var_250[FindFirstChild_16]) then
                        else
                            var_250[FindFirstChild_16] = FindFirstChild_16.Size
                        end
                        if not (not Connect_4[FindFirstChild_16]) then
                        else
                            Connect_4[FindFirstChild_16] = FindFirstChild_16.Transparency
                        end
                        if not (var_042.hitboxExpander) then
                            if var_250[FindFirstChild_16] and FindFirstChild_16.Size ~= var_250[FindFirstChild_16] then
                                FindFirstChild_16.Size = var_250[FindFirstChild_16]
                                FindFirstChild_16.Transparency = Connect_4[FindFirstChild_16] or 0
                            end
                        else
                            local var_251, var_252 = tonumber(var_042.hitboxSize) or 2, (tonumber(var_042.hitboxTransparency) or 50) / (100)

                            FindFirstChild_16.Size = var_004(var_251, var_251, var_251)
                            FindFirstChild_16.Transparency = var_252
                            FindFirstChild_16.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end)

do
    local var_253, var_254, var_255, var_256, fromOffset, fromRGB_2, var_257, var_258, var_259, var_260, spawn_3, insert, concat, var_261, var_262, clamp_2, floor_2, format_2, match, gsub_3, find_3, var_263, var_264, var_265, var_266, Workspace_2, Players_4, RunService_2, HttpService_3 = {
        Enabled = true,
        TeamCheck = false,
        LimitDistance = true,
        MaxDistance = 1E3,
        RefreshRate = 360,
        TextCasing = "Capitalized",
        TextSize = 11,
        Names = {
            Enabled = true,
            Color = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0),
        },
        Boxes = {
            Enabled = true,
            Dynamic = true,
            Mode = "Full",
            IncludeAccessories = true,
            MiddleColor = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Fill = {
                Enabled = true,
                Color1 = Color3.fromRGB(255, 255, 200),
                Color2 = Color3.fromRGB(122, 122, 255),
                Transparency = 0.5,
                Rotation = 90,
            },
            Glow = {
                Enabled = true,
                Color1 = Color3.fromRGB(255, 255, 200),
                Color2 = Color3.fromRGB(122, 122, 255),
                Transparency = 0.8,
                Rotation = 90,
            },
        },
        Healthbars = {
            Enabled = true,
            ColorMode = "Regular",
            TopColor = Color3.fromRGB(0, 255, 0),
            MidColor = Color3.fromRGB(255, 255, 0),
            BottomColor = Color3.fromRGB(255, 0, 0),
            OutlineColor = Color3.fromRGB(0, 0, 0),
        },
        Distance = {
            Enabled = true,
            Suffix = " studs",
            DecimalPlaces = 0,
            Color = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0),
        },
        Weapon = {
            Enabled = true,
            Color = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0),
        },
        Flags = {
            Enabled = true,
            Color = Color3.fromRGB(255, 255, 255),
            OutlineColor = Color3.fromRGB(0, 0, 0),
            Movement = {Enabled = true},
            Avatar = {Enabled = true},
        },
    }, Vector2.new, Vector3.new, UDim2.new, UDim2.fromOffset, Color3.fromRGB, Color3.new, Font.new, ColorSequence.new, ColorSequenceKeypoint.new, task.spawn, table.insert, table.concat, math.min, math.max, math.clamp, math.floor, string.format, string.match, string.gsub, string.find, ipairs, pairs, pcall, warn, game:GetService("Workspace"), game:GetService("Players"), game:GetService("RunService"), game:GetService("HttpService")
    local LocalPlayer_2, var_267 = Players_4.LocalPlayer, fn_002()

    local function fn_078()
        local HttpGet, var_268 = var_265(function()
            if not (not isfile("Minecraftia_ESP1.ttf")) then
            else
                local HttpGet_2 = game:HttpGet("https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/MinecraftStandard.ttf")

                writefile("Minecraftia_ESP1.ttf", HttpGet_2)
            end
            if not isfile("Minecraftia_ESP1.json") then
                local JSONEncode_2 = {
                    name = "Minecraftia_ESP1",
                    faces = {
                        {
                            name = "Regular",
                            weight = 400,
                            style = "normal",
                            assetId = getcustomasset("Minecraftia_ESP1.ttf"),
                        },
                    },
                }

                writefile("Minecraftia_ESP1.json", HttpService_3:JSONEncode(JSONEncode_2))
            end

            local var_269 = var_258(getcustomasset("Minecraftia_ESP1.json"), Enum.FontWeight.Regular)

            getgenv().Wyvern_MinecraftiaFont = var_269

            if shared then
                shared.Wyvern_MinecraftiaFont = var_269
            end

            getgenv().Wyvern_FontLoaded = true

            if not (shared) then
            else
                shared.Wyvern_FontLoaded = true
            end
        end)

        if not HttpGet then
            var_266("[ESP] Minecraftia font failed: " .. tostring(var_268))
        end
    end
    local function fn_079(arg_115)
        if not (not arg_115) then
        else
            return ''
        end

        local TextCasing = var_253.TextCasing

        if TextCasing == "Lowercase" then
            return string.lower(arg_115)
        elseif TextCasing == "Uppercase" then
            return string.upper(arg_115)
        elseif not (TextCasing == "Capitalized") then
        else
            if not (#arg_115 == 0) then
            else
                return ''
            end

            return string.upper(string.sub(arg_115, 1, 1)) .. string.lower(string.sub(arg_115, 2))
        end

        return arg_115
    end
    local function fn_080(arg_116)
        local var_270, var_271 = getgenv().Wyvern_FontLoaded or (shared and shared.Wyvern_FontLoaded), getgenv().Wyvern_MinecraftiaFont or (shared and shared.Wyvern_MinecraftiaFont)

        if not (var_270 and var_271) then
            arg_116.Font = Enum.Font.Code
        else
            arg_116.FontFace = var_271
        end

        arg_116.TextSize = var_253.TextSize
        arg_116.TextScaled = false
    end

    local var_272 = {
        ["Head"] = true,
        ["Torso"] = true,
        ["Left Arm"] = true,
        ["Right Arm"] = true,
        ["Left Leg"] = true,
        ["Right Leg"] = true,
        ["UpperTorso"] = true,
        ["LowerTorso"] = true,
        ["LeftUpperArm"] = true,
        ["LeftLowerArm"] = true,
        ["LeftHand"] = true,
        ["RightUpperArm"] = true,
        ["RightLowerArm"] = true,
        ["RightHand"] = true,
        ["LeftUpperLeg"] = true,
        ["LeftLowerLeg"] = true,
        ["LeftFoot"] = true,
        ["RightUpperLeg"] = true,
        ["RightLowerLeg"] = true,
        ["RightFoot"] = true,
    }

    local function fn_081(arg_117, arg_118, arg_119, arg_120)
        arg_120 = arg_120 or Workspace_2.CurrentCamera

        local FindFirstChild_17 = arg_117:FindFirstChild("HumanoidRootPart")

        if not FindFirstChild_17 then
            return nil
        end

        local WorldToViewportPoint_4, var_273 = arg_120:WorldToViewportPoint(FindFirstChild_17.Position)

        if not (not var_273) then
        else
            return nil
        end
        if arg_119 then
            local huge, huge_2, huge_3, huge_4, var_274, FindFirstChild_18 = math.huge, math.huge, -math.huge, -math.huge, false, arg_117:FindFirstChild("AnimeModel")

            for it_117, it_118 in var_263(arg_117:GetDescendants())do
                if it_118:IsA("BasePart") then
                    if not (it_118.Transparency >= 0.95) then
                    else
                        continue
                    end
                    if not (it_118.Name == "HumanoidRootPart" or it_118.Name == "CollisionCapsule") then
                    else
                        continue
                    end

                    local var_275 = false

                    if it_118.Parent == arg_117 then
                        var_275 = true
                    elseif not (FindFirstChild_18 and it_118:IsDescendantOf(FindFirstChild_18)) then
                    else
                        var_275 = true
                    end
                    if not (not arg_118 and it_118:FindFirstAncestorOfClass("Accessory")) then
                    else
                        var_275 = false
                    end
                    if not (var_275) then
                    else
                        local Size, CFrame_2 = it_118.Size, it_118.CFrame

                        if not (CFrame_2.X ~= CFrame_2.X or Size.X ~= Size.X) then
                        else
                            continue
                        end

                        var_274 = true

                        local var_276, var_277, var_278 = Size.X / (2), Size.Y / (2), Size.Z / (2)

                        for it_119, it_120 in var_263{
                            var_255(-var_276, -var_277, -var_278),
                            var_255(var_276, -var_277, -var_278),
                            var_255(-var_276, var_277, -var_278),
                            var_255(var_276, var_277, -var_278),
                            var_255(-var_276, -var_277, var_278),
                            var_255(var_276, -var_277, var_278),
                            var_255(-var_276, var_277, var_278),
                            var_255(var_276, var_277, var_278),
                        }do
                            local WorldToViewportPoint_5 = arg_120:WorldToViewportPoint(CFrame_2 * it_120)

                            huge = var_261(huge, WorldToViewportPoint_5.X)
                            huge_3 = var_262(huge_3, WorldToViewportPoint_5.X)
                            huge_2 = var_261(huge_2, WorldToViewportPoint_5.Y)
                            huge_4 = var_262(huge_4, WorldToViewportPoint_5.Y)
                        end
                    end
                end
            end

            if not var_274 or huge ~= huge or huge_2 ~= huge_2 or huge_3 ~= huge_3 or huge_4 ~= huge_4 or huge == math.huge then
                local var_279 = (FindFirstChild_17.Size.Y * arg_120.ViewportSize.Y) / (WorldToViewportPoint_4.Z * (2))
                local var_280, v = (3.2) * var_279, (4.5) * var_279

                return var_254(WorldToViewportPoint_4.X - var_280 / (2), WorldToViewportPoint_4.Y - v / (2)), var_254(var_280, v), true
            end

            return var_254(huge, huge_2), var_254(huge_3 - huge, huge_4 - huge_2), true
        else
            local var_281 = (FindFirstChild_17.Size.Y * arg_120.ViewportSize.Y) / (WorldToViewportPoint_4.Z * (2))
            local var_282, var_283 = (3.2) * var_281, (4.5) * var_281

            return var_254(WorldToViewportPoint_4.X - var_282 / (2), WorldToViewportPoint_4.Y - var_283 / (2)), var_254(var_282, var_283), true
        end
    end
    local function fn_082(x)
        if x >= 0.5 then
            return var_253.Healthbars.MidColor:Lerp(var_253.Healthbars.TopColor, (x - (0.5)) * (2))
        else
            return var_253.Healthbars.BottomColor:Lerp(var_253.Healthbars.MidColor, x * (2))
        end
    end
    local function fn_083(arg_121)
        local Instance_new_96 = Instance.new("TextLabel")

        Instance_new_96.BackgroundTransparency = 1
        Instance_new_96.BorderSizePixel = 0
        Instance_new_96.AutomaticSize = Enum.AutomaticSize.XY
        Instance_new_96.Size = var_256(0, 0, 0, 0)
        Instance_new_96.Parent = arg_121

        local Instance_new_97 = Instance.new("UIStroke")

        Instance_new_97.Thickness = 1
        Instance_new_97.Color = var_257(0, 0, 0)
        Instance_new_97.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        Instance_new_97.LineJoinMode = Enum.LineJoinMode.Miter
        Instance_new_97.Parent = Instance_new_96

        return Instance_new_96, Instance_new_97
    end
    local function fn_084(arg_122, arg_123)
        local var_284 = arg_122

        if not (arg_122 and not arg_122:IsA("Player") and arg_122:IsA("Model")) then
        else
            var_284 = Players_4:GetPlayerFromCharacter(arg_122)
            arg_123 = arg_122
        end
        if not (var_284 and var_284 == LocalPlayer_2) then
        else
            return true
        end
        if var_284 and var_284:IsA("Player") and LocalPlayer_2.Team and var_284.Team then
            return var_284.Team == LocalPlayer_2.Team
        end

        arg_123 = arg_123 or (var_284 and var_284.Character) or (arg_122 and arg_122:IsA("Model") and arg_122)

        if not arg_123 or not arg_123.Parent then
            return false
        end

        local FindFirstChild_19 = LocalPlayer_2.Character or (Workspace_2:FindFirstChild("Characters") and Workspace_2.Characters:FindFirstChild(LocalPlayer_2.Name, true))

        if not (FindFirstChild_19 and FindFirstChild_19.Parent) then
        else
            if not (FindFirstChild_19.Parent ~= Workspace_2 and arg_123.Parent ~= Workspace_2) then
            else
                return arg_123.Parent == FindFirstChild_19.Parent
            end
        end

        return false
    end

    local var_285 = {}

    var_285.__index = var_285
    var_285.HideLines = function(arg_124)
        if arg_124.TracerLine then
            arg_124.TracerLine.Visible = false
        end
        if arg_124.ViewTracerLine then
            arg_124.ViewTracerLine.Visible = false
        end
    end
    var_285.new = function(arg_125)
        local CreateUI = setmetatable({}, var_285)

        CreateUI.Player = arg_125
        CreateUI.Connections = {}
        CreateUI.Character = arg_125.Character
        CreateUI.CachedParts = {}
        CreateUI.LastUpdate = 0

        CreateUI:CreateUI()

        if not (Drawing) then
        else
            var_265(function()
                CreateUI.TracerLine = Drawing.new("Line")
                CreateUI.TracerLine.Thickness = 1.2
                CreateUI.TracerLine.Transparency = 0.7
            end)
            var_265(function()
                CreateUI.ViewTracerLine = Drawing.new("Line")
                CreateUI.ViewTracerLine.Thickness = 1.5
                CreateUI.ViewTracerLine.Transparency = 0.8
            end)
        end

        insert(CreateUI.Connections, arg_125.CharacterAdded:Connect(function(arg_126)
            CreateUI.Character = arg_126

            CreateUI:CacheCharacterParts(arg_126)
            CreateUI:UpdateChams()
        end))
        insert(CreateUI.Connections, arg_125.CharacterRemoving:Connect(function()
            CreateUI.Character = nil
            CreateUI.CachedParts = {}

            if CreateUI.Holder then
                CreateUI.Holder.Visible = false
            end

            CreateUI:DestroyChams()
            CreateUI:HideLines()
        end))

        if CreateUI.Character then
            CreateUI:CacheCharacterParts(CreateUI.Character)
            CreateUI:UpdateChams()
        end

        return CreateUI
    end
    var_285.CacheCharacterParts = function(arg_127, arg_128)
        local FindFirstChild_20, FindFirstChildOfClass_7 = arg_128:FindFirstChild("HumanoidRootPart"), arg_128:FindFirstChildOfClass("Humanoid")

        if not (FindFirstChild_20 and FindFirstChildOfClass_7) then
            spawn_3(function()
                local WaitForChild, WaitForChildOfClass = arg_128:WaitForChild("HumanoidRootPart", 5), arg_128:WaitForChild("Humanoid", 5)

                if arg_127.Character == arg_128 then
                    arg_127.CachedParts.HumanoidRootPart = WaitForChild or arg_128:FindFirstChild("HumanoidRootPart")
                    arg_127.CachedParts.Humanoid = WaitForChildOfClass or arg_128:FindFirstChildOfClass("Humanoid")
                end
            end)
        else
            arg_127.CachedParts.HumanoidRootPart = FindFirstChild_20
            arg_127.CachedParts.Humanoid = FindFirstChildOfClass_7
        end
    end
    var_285.CreateUI = function(arg_129)
        local var_286 = getgenv().AntigravityESP_ScreenGui

        arg_129.Holder = Instance.new("Frame")
        arg_129.Holder.BackgroundTransparency = 1
        arg_129.Holder.BorderSizePixel = 0
        arg_129.Holder.Visible = false
        arg_129.Holder.Parent = var_286
        arg_129.BoxOuter = Instance.new("Frame")
        arg_129.BoxOuter.BackgroundTransparency = 1
        arg_129.BoxOuter.BorderSizePixel = 0
        arg_129.BoxOuter.Position = var_256(0, -2, 0, -2)
        arg_129.BoxOuter.Size = var_256(1, 4, 1, 4)
        arg_129.BoxOuter.Parent = arg_129.Holder
        arg_129.BoxOuterStroke = Instance.new("UIStroke")
        arg_129.BoxOuterStroke.Thickness = 1
        arg_129.BoxOuterStroke.LineJoinMode = Enum.LineJoinMode.Miter
        arg_129.BoxOuterStroke.Parent = arg_129.BoxOuter
        arg_129.BoxMiddle = Instance.new("Frame")
        arg_129.BoxMiddle.BackgroundTransparency = 1
        arg_129.BoxMiddle.BorderSizePixel = 0
        arg_129.BoxMiddle.Position = var_256(0, -1, 0, -1)
        arg_129.BoxMiddle.Size = var_256(1, 2, 1, 2)
        arg_129.BoxMiddle.Parent = arg_129.Holder
        arg_129.BoxMiddleStroke = Instance.new("UIStroke")
        arg_129.BoxMiddleStroke.Thickness = 1
        arg_129.BoxMiddleStroke.LineJoinMode = Enum.LineJoinMode.Miter
        arg_129.BoxMiddleStroke.Parent = arg_129.BoxMiddle
        arg_129.BoxInner = Instance.new("Frame")
        arg_129.BoxInner.BackgroundTransparency = 1
        arg_129.BoxInner.BorderSizePixel = 0
        arg_129.BoxInner.Size = var_256(1, 0, 1, 0)
        arg_129.BoxInner.Parent = arg_129.Holder
        arg_129.BoxInnerStroke = Instance.new("UIStroke")
        arg_129.BoxInnerStroke.Thickness = 1
        arg_129.BoxInnerStroke.LineJoinMode = Enum.LineJoinMode.Miter
        arg_129.BoxInnerStroke.Parent = arg_129.BoxInner
        arg_129.BoxFill = Instance.new("Frame")
        arg_129.BoxFill.BorderSizePixel = 0
        arg_129.BoxFill.ZIndex = -1
        arg_129.BoxFill.Size = var_256(1, 0, 1, 0)
        arg_129.BoxFill.Parent = arg_129.Holder
        arg_129.BoxFillGradient = Instance.new("UIGradient")
        arg_129.BoxFillGradient.Parent = arg_129.BoxFill
        arg_129.BoxGlow = Instance.new("ImageLabel")
        arg_129.BoxGlow.BackgroundTransparency = 1
        arg_129.BoxGlow.BorderSizePixel = 0
        arg_129.BoxGlow.Image = "rbxassetid://110204605000367"
        arg_129.BoxGlow.ScaleType = Enum.ScaleType.Slice
        arg_129.BoxGlow.SliceCenter = Rect.new(21, 21, 79, 79)
        arg_129.BoxGlow.Position = var_256(0, -21, 0, -21)
        arg_129.BoxGlow.Size = var_256(1, 42, 1, 42)
        arg_129.BoxGlow.ZIndex = -2
        arg_129.BoxGlow.Parent = arg_129.Holder
        arg_129.BoxGlowGradient = Instance.new("UIGradient")
        arg_129.BoxGlowGradient.Parent = arg_129.BoxGlow
        arg_129.CornerHolder = Instance.new("Frame")
        arg_129.CornerHolder.BackgroundTransparency = 1
        arg_129.CornerHolder.BorderSizePixel = 0
        arg_129.CornerHolder.Size = var_256(1, 0, 1, 0)
        arg_129.CornerHolder.Visible = false
        arg_129.CornerHolder.Parent = arg_129.Holder
        arg_129.Corners = {}

        for i_4 = 45, 52 do
            local Instance_new_98 = Instance.new("Frame")

            Instance_new_98.BorderSizePixel = 0
            Instance_new_98.BackgroundColor3 = var_253.Boxes.MiddleColor

            local Instance_new_99 = Instance.new("UIStroke")

            Instance_new_99.Thickness = 1
            Instance_new_99.Color = var_253.Boxes.OutlineColor
            Instance_new_99.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
            Instance_new_99.LineJoinMode = Enum.LineJoinMode.Miter
            Instance_new_99.Parent = Instance_new_98
            Instance_new_98.Parent = arg_129.CornerHolder
            arg_129.Corners[(i_4 - 44)] = {
                Frame = Instance_new_98,
                Stroke = Instance_new_99,
            }
        end

        arg_129.HealthBarOutline = Instance.new("Frame")
        arg_129.HealthBarOutline.BackgroundColor3 = var_253.Healthbars.OutlineColor
        arg_129.HealthBarOutline.BorderSizePixel = 0
        arg_129.HealthBarOutline.Position = var_256(0, -7, 0, -3)
        arg_129.HealthBarOutline.Size = var_256(0, 3, 1, 6)
        arg_129.HealthBarOutline.Parent = arg_129.Holder
        arg_129.HealthBarFill = Instance.new("Frame")
        arg_129.HealthBarFill.BorderSizePixel = 0
        arg_129.HealthBarFill.BackgroundColor3 = var_257(1, 1, 1)
        arg_129.HealthBarFill.AnchorPoint = var_254(0, 1)
        arg_129.HealthBarFill.Position = var_256(0, 1, 1, -1)
        arg_129.HealthBarFill.Size = var_256(0, 1, 1, -2)
        arg_129.HealthBarFill.Parent = arg_129.HealthBarOutline
        arg_129.HealthBarGradient = Instance.new("UIGradient")
        arg_129.HealthBarGradient.Rotation = 90
        arg_129.HealthBarGradient.Color = var_259{
            var_260(0, var_253.Healthbars.TopColor),
            var_260(0.5, var_253.Healthbars.MidColor),
            var_260(1, var_253.Healthbars.BottomColor),
        }
        arg_129.HealthBarGradient.Parent = arg_129.HealthBarFill
        arg_129.TopContainer = Instance.new("Frame")
        arg_129.TopContainer.BackgroundTransparency = 1
        arg_129.TopContainer.BorderSizePixel = 0
        arg_129.TopContainer.Position = var_256(0.5, 0, 0, -5)
        arg_129.TopContainer.AnchorPoint = var_254(0.5, 1)
        arg_129.TopContainer.AutomaticSize = Enum.AutomaticSize.XY
        arg_129.TopContainer.Size = var_256(0, 0, 0, 0)
        arg_129.TopContainer.Parent = arg_129.Holder
        Instance.new("UIListLayout", arg_129.TopContainer).HorizontalAlignment = Enum.HorizontalAlignment.Center
        arg_129.NameLabel, arg_129.NameStroke = fn_083(arg_129.TopContainer)
        arg_129.BottomContainer = Instance.new("Frame")
        arg_129.BottomContainer.BackgroundTransparency = 1
        arg_129.BottomContainer.BorderSizePixel = 0
        arg_129.BottomContainer.Position = var_256(0.5, 0, 1, 5)
        arg_129.BottomContainer.AnchorPoint = var_254(0.5, 0)
        arg_129.BottomContainer.AutomaticSize = Enum.AutomaticSize.XY
        arg_129.BottomContainer.Size = var_256(0, 0, 0, 0)
        arg_129.BottomContainer.Parent = arg_129.Holder

        local Instance_new_100 = Instance.new("UIListLayout")

        Instance_new_100.HorizontalAlignment = Enum.HorizontalAlignment.Center
        Instance_new_100.Parent = arg_129.BottomContainer
        arg_129.DistanceLabel, arg_129.DistanceStroke = fn_083(arg_129.BottomContainer)
        arg_129.WeaponLabel, arg_129.WeaponStroke = fn_083(arg_129.BottomContainer)
        arg_129.RightContainer = Instance.new("Frame")
        arg_129.RightContainer.BackgroundTransparency = 1
        arg_129.RightContainer.BorderSizePixel = 0
        arg_129.RightContainer.Position = var_256(1, 5, 0, -4)
        arg_129.RightContainer.AnchorPoint = var_254(0, 0)
        arg_129.RightContainer.AutomaticSize = Enum.AutomaticSize.XY
        arg_129.RightContainer.Size = var_256(0, 0, 0, 0)
        arg_129.RightContainer.Parent = arg_129.Holder

        local Instance_new_101 = Instance.new("UIListLayout")

        Instance_new_101.HorizontalAlignment = Enum.HorizontalAlignment.Left
        Instance_new_101.Parent = arg_129.RightContainer
        arg_129.FlagsLabel, arg_129.FlagsStroke = fn_083(arg_129.RightContainer)
        arg_129.FlagsLabel.RichText = true
        arg_129.FlagsLabel.LineHeight = 0.8
        arg_129.FlagsLabel.TextXAlignment = Enum.TextXAlignment.Left
    end
    var_285.Update = function(arg_130, arg_131, arg_132)
        if not (arg_130.Player.Character and arg_130.Player.Character ~= arg_130.Character) then
            local FindFirstChildOfClass_8 = arg_130.Character and arg_130.Character:FindFirstChildOfClass("Humanoid")

            if FindFirstChildOfClass_8 and arg_130.CachedParts.Humanoid ~= FindFirstChildOfClass_8 then
                arg_130:CacheCharacterParts(arg_130.Character)
                arg_130:UpdateChams()
            elseif var_042.chams and var_042.visualsEnable and (not arg_130.Highlight or not arg_130.Highlight.Parent or arg_130.Highlight.Parent ~= (arg_130.Character:FindFirstChild("AnimeModel") or arg_130.Character)) then
                arg_130:UpdateChams()
            end
        else
            arg_130.Character = arg_130.Player.Character

            arg_130:CacheCharacterParts(arg_130.Character)
            arg_130:UpdateChams()
        end
        if not (not var_253.Enabled or not arg_130.Player or not arg_130.Character or not arg_130.Character.Parent) then
        else
            arg_130.Holder.Visible = false

            arg_130:HideLines()

            return
        end
        if not (arg_130.Player == arg_132) then
        else
            arg_130.Holder.Visible = false

            arg_130:HideLines()

            return
        end
        if var_253.TeamCheck and fn_084(arg_130.Player, arg_130.Character) then
            arg_130.Holder.Visible = false

            arg_130:HideLines()

            return
        end

        local HumanoidRootPart, Humanoid = arg_130.CachedParts.HumanoidRootPart, arg_130.CachedParts.Humanoid

        if not (not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0) then
        else
            arg_130.Holder.Visible = false

            arg_130:HideLines()

            return
        end

        local var_287 = os.clock()

        if not ((var_287 - arg_130.LastUpdate) < ((1) / var_253.RefreshRate)) then
        else
            return
        end

        arg_130.LastUpdate = var_287

        local FindFirstChild_21 = arg_132.Character and arg_132.Character:FindFirstChild("HumanoidRootPart")
        local Magnitude_2 = FindFirstChild_21 and (FindFirstChild_21.Position - HumanoidRootPart.Position).Magnitude or (arg_131.CFrame.Position - HumanoidRootPart.Position).Magnitude

        if var_253.LimitDistance and Magnitude_2 > var_253.MaxDistance then
            arg_130.Holder.Visible = false

            arg_130:HideLines()

            return
        end

        local var_288, var_289, var_290 = fn_081(arg_130.Character, var_253.Boxes.IncludeAccessories, var_253.Boxes.Dynamic, arg_131)

        if not (not var_290 or not var_288) then
        else
            arg_130.Holder.Visible = false

            arg_130:HideLines()

            return
        end

        local var_291, var_292, var_293, var_294 = floor_2(var_288.X), floor_2(var_288.Y), floor_2(var_289.X), floor_2(var_289.Y)

        arg_130.Holder.Position = fromOffset(var_291, var_292)
        arg_130.Holder.Size = fromOffset(var_293, var_294)
        arg_130.Holder.Visible = true

        if var_253.Boxes.Enabled then
            if not (var_253.Boxes.Mode == "Full") then
                arg_130.BoxOuter.Visible = false
                arg_130.BoxMiddle.Visible = false
                arg_130.BoxInner.Visible = false
                arg_130.CornerHolder.Visible = true

                local var_295 = clamp_2(floor_2(var_261(var_293, var_294) * (0.2)), 6, 15)

                arg_130.Corners[1].Frame.Size = fromOffset(var_295, 1)
                arg_130.Corners[1].Frame.Position = fromOffset(0, 0)
                arg_130.Corners[2].Frame.Size = fromOffset(1, var_295)
                arg_130.Corners[2].Frame.Position = fromOffset(0, 0)
                arg_130.Corners[3].Frame.Size = fromOffset(var_295, 1)
                arg_130.Corners[3].Frame.Position = fromOffset(var_293 - var_295, 0)
                arg_130.Corners[4].Frame.Size = fromOffset(1, var_295)
                arg_130.Corners[4].Frame.Position = fromOffset(var_293 - (1), 0)
                arg_130.Corners[5].Frame.Size = fromOffset(var_295, 1)
                arg_130.Corners[5].Frame.Position = fromOffset(0, var_294 - (1))
                arg_130.Corners[6].Frame.Size = fromOffset(1, var_295)
                arg_130.Corners[6].Frame.Position = fromOffset(0, var_294 - var_295)
                arg_130.Corners[7].Frame.Size = fromOffset(var_295, 1)
                arg_130.Corners[7].Frame.Position = fromOffset(var_293 - var_295, var_294 - 1)
                arg_130.Corners[8].Frame.Size = fromOffset(1, var_295)
                arg_130.Corners[8].Frame.Position = fromOffset(var_293 - (1), var_294 - var_295)

                for it_121, it_122 in var_263(arg_130.Corners)do
                    it_122.Stroke.Color = var_253.Boxes.OutlineColor
                    it_122.Frame.BackgroundColor3 = var_253.Boxes.MiddleColor
                end
            else
                arg_130.BoxOuter.Visible = true
                arg_130.BoxMiddle.Visible = true
                arg_130.BoxInner.Visible = true
                arg_130.CornerHolder.Visible = false
                arg_130.BoxOuterStroke.Color = var_253.Boxes.OutlineColor
                arg_130.BoxMiddleStroke.Color = var_253.Boxes.MiddleColor
                arg_130.BoxInnerStroke.Color = var_253.Boxes.OutlineColor
            end
            if var_253.Boxes.Fill.Enabled and var_253.Boxes.Mode == "Full" then
                arg_130.BoxFill.Visible = true
                arg_130.BoxFill.BackgroundTransparency = var_253.Boxes.Fill.Transparency
                arg_130.BoxFillGradient.Rotation = clamp_2(var_253.Boxes.Fill.Rotation, 0, 90)
                arg_130.BoxFillGradient.Color = var_259{
                    var_260(0, var_253.Boxes.Fill.Color1),
                    var_260(1, var_253.Boxes.Fill.Color2),
                }
            else
                arg_130.BoxFill.Visible = false
            end
            if not (var_253.Boxes.Glow.Enabled) then
                arg_130.BoxGlow.Visible = false
            else
                arg_130.BoxGlow.Visible = true
                arg_130.BoxGlow.ImageTransparency = var_253.Boxes.Glow.Transparency
                arg_130.BoxGlowGradient.Rotation = clamp_2(var_253.Boxes.Glow.Rotation, 0, 90)
                arg_130.BoxGlowGradient.Color = var_259{
                    var_260(0, var_253.Boxes.Glow.Color1),
                    var_260(1, var_253.Boxes.Glow.Color2),
                }
            end
        else
            arg_130.BoxOuter.Visible = false
            arg_130.BoxMiddle.Visible = false
            arg_130.BoxInner.Visible = false
            arg_130.CornerHolder.Visible = false
            arg_130.BoxFill.Visible = false
            arg_130.BoxGlow.Visible = false
        end
        if var_253.Healthbars.Enabled then
            arg_130.HealthBarOutline.Visible = true

            local var_296 = clamp_2(Humanoid.Health / Humanoid.MaxHealth, 0, 1)

            arg_130.HealthBarFill.Size = var_256(0, 1, var_296, -2)

            if not (var_253.Healthbars.ColorMode == "Health-Based") then
                arg_130.HealthBarGradient.Enabled = true
                arg_130.HealthBarFill.BackgroundColor3 = var_257(1, 1, 1)
                arg_130.HealthBarGradient.Color = var_259{
                    var_260(0, var_253.Healthbars.TopColor),
                    var_260(0.5, var_253.Healthbars.MidColor),
                    var_260(1, var_253.Healthbars.BottomColor),
                }
            else
                arg_130.HealthBarGradient.Enabled = false
                arg_130.HealthBarFill.BackgroundColor3 = fn_082(var_296)
            end
        else
            arg_130.HealthBarOutline.Visible = false
        end
        if var_253.Names.Enabled then
            arg_130.NameLabel.Visible = true
            arg_130.NameLabel.Text = fn_079(arg_130.Player.DisplayName or arg_130.Player.Name)
            arg_130.NameLabel.TextColor3 = var_253.Names.Color
            arg_130.NameStroke.Color = var_253.Names.OutlineColor

            fn_080(arg_130.NameLabel)
        else
            arg_130.NameLabel.Visible = false
        end
        if not (var_253.Distance.Enabled) then
            arg_130.DistanceLabel.Visible = false
        else
            arg_130.DistanceLabel.Visible = true

            local var_297 = "%." .. var_253.Distance.DecimalPlaces .. "f"

            arg_130.DistanceLabel.Text = fn_079(format_2(var_297, Magnitude_2) .. var_253.Distance.Suffix)
            arg_130.DistanceLabel.TextColor3 = var_253.Distance.Color
            arg_130.DistanceStroke.Color = var_253.Distance.OutlineColor

            fn_080(arg_130.DistanceLabel)
        end
        if not (var_253.Weapon.Enabled) then
            arg_130.WeaponLabel.Visible = false
        else
            arg_130.WeaponLabel.Visible = true

            local var_298, GetAttribute_3 = nil, arg_130.Character:GetAttribute("CurrentEquipped") or arg_130.Character:GetAttribute("Weapon") or arg_130.Character:GetAttribute("Equipped")

            if type(GetAttribute_3) == "string" then
                var_298 = fn_010(GetAttribute_3)
            end
            if not var_298 or var_298 == '' or var_298 == "None" then
                local GetAttribute_4 = arg_130.Player:GetAttribute("CurrentEquipped") or arg_130.Player:GetAttribute("Weapon") or arg_130.Player:GetAttribute("Equipped") or arg_130.Player:GetAttribute("CurrentWeapon")

                if not (type(GetAttribute_4) == "string") then
                else
                    var_298 = fn_010(GetAttribute_4)
                end
            end
            if not var_298 or var_298 == '' or var_298 == "None" then
                local FindFirstChildWhichIsA = arg_130.Character:FindFirstChildWhichIsA("Tool")

                if FindFirstChildWhichIsA then
                    var_298 = fn_010(FindFirstChildWhichIsA.Name)
                end
            end
            if not (not var_298 or var_298 == '' or var_298 == "None") then
            else
                for it_123, it_124 in var_263(arg_130.Character:GetChildren())do
                    if it_124:IsA("Model") and it_124.Name ~= "AnimeModel" then
                        local var_299, var_300 = false, lower(it_124.Name)

                        for it_125, it_126 in var_263(var_034.gunNames)do
                            if not (lower(it_126) == var_300) then
                            else
                                var_299 = true

                                break
                            end
                        end

                        if not (not var_299) then
                        else
                            for it_127, it_128 in var_263(var_034.knifeNames)do
                                if not (lower(it_128) == var_300) then
                                else
                                    var_299 = true

                                    break
                                end
                            end
                        end
                        if not (not var_299) then
                        else
                            for it_129, it_130 in var_263(it_124:GetDescendants())do
                                if it_130:IsA("BasePart") then
                                    local var_301 = lower(it_130.Name)

                                    if find_2(var_301, "muzzle") or find_2(var_301, "trigger") or find_2(var_301, "magazine") or find_2(var_301, "silencer") then
                                        var_299 = true

                                        break
                                    end
                                end
                            end
                        end
                        if not (var_299) then
                        else
                            var_298 = fn_010(it_124.Name)

                            break
                        end
                    end
                end
            end
            if not (not var_298 or var_298 == '' or var_298 == "None") then
            else
                var_298 = "None"
            end

            arg_130.WeaponLabel.Text = fn_079(var_298)
            arg_130.WeaponLabel.TextColor3 = var_253.Weapon.Color
            arg_130.WeaponStroke.Color = var_253.Weapon.OutlineColor

            fn_080(arg_130.WeaponLabel)
        end

        local var_302 = var_253.Flags.Enabled or var_042.moneyEsp == true

        if not (var_302) then
            arg_130.FlagsLabel.Visible = false
        else
            arg_130.FlagsLabel.Visible = true

            local var_303 = {}

            if var_253.Flags.Enabled then
                if not (var_253.Flags.Movement.Enabled) then
                else
                    local var_304, var_305 = Humanoid.MoveDirection.Magnitude > 5E-2, Humanoid.FloorMaterial == Enum.Material.Air and HumanoidRootPart.AssemblyLinearVelocity.Y > 0.5

                    insert(var_303, fn_079(var_304 and "moving" or (var_305 and "jumping" or "idle")))
                end
                if var_253.Flags.Avatar.Enabled then
                    local var_306 = Humanoid.RigType == Enum.HumanoidRigType.R6

                    insert(var_303, fn_079(var_306 and "R6" or "R15"))
                end
            end
            if not (var_042.moneyEsp) then
            else
                local fn_085 = function(arg_133)
                    local GetAttribute_5 = arg_133:GetAttribute("Cash") or arg_133:GetAttribute("Money") or arg_133:GetAttribute("Credits")

                    if not (GetAttribute_5) then
                    else
                        return GetAttribute_5
                    end

                    local Character_3 = arg_133.Character

                    if Character_3 then
                        local GetAttribute_6 = Character_3:GetAttribute("Cash") or Character_3:GetAttribute("Money") or Character_3:GetAttribute("Credits")

                        if not (GetAttribute_6) then
                        else
                            return GetAttribute_6
                        end
                    end

                    local FindFirstChild_22 = arg_133:FindFirstChild("leaderstats")

                    if not (FindFirstChild_22) then
                    else
                        local FindFirstChild_23 = FindFirstChild_22:FindFirstChild("Cash") or FindFirstChild_22:FindFirstChild("Money") or FindFirstChild_22:FindFirstChild("Credits") or FindFirstChild_22:FindFirstChild("Points")

                        if FindFirstChild_23 and (FindFirstChild_23:IsA("ValueObject") or FindFirstChild_23.ClassName:find("Value")) then
                            return FindFirstChild_23.Value
                        end
                    end

                    local FindFirstChild_24 = arg_133:FindFirstChild("Cash") or arg_133:FindFirstChild("Money") or arg_133:FindFirstChild("Credits")

                    if FindFirstChild_24 and (FindFirstChild_24:IsA("ValueObject") or FindFirstChild_24.ClassName:find("Value")) then
                        return FindFirstChild_24.Value
                    end
                    if Character_3 then
                        local FindFirstChild_25 = Character_3:FindFirstChild("Cash") or Character_3:FindFirstChild("Money")

                        if not (FindFirstChild_25 and (FindFirstChild_25:IsA("ValueObject") or FindFirstChild_25.ClassName:find("Value"))) then
                        else
                            return FindFirstChild_25.Value
                        end
                    end

                    return nil
                end
                local var_307 = fn_085(arg_130.Player)

                if var_307 then
                    insert(var_303, format("$%s", tostring(var_307)))
                end
            end

            arg_130.FlagsLabel.Text = concat(var_303, "\n")
            arg_130.FlagsLabel.TextColor3 = var_253.Flags.Color
            arg_130.FlagsStroke.Color = var_253.Flags.OutlineColor

            fn_080(arg_130.FlagsLabel)
        end

        local var_308 = fn_084(arg_130.Player, arg_130.Character)
        local PsandColor3_fromRGB = var_308 and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 60, 60)

        if var_042.teamColorsAuto and not var_308 then
            local Parent = arg_130.Character.Parent

            if Parent and (Parent.Name == "Terrorists" or Parent.Name == "Enforcers" or Parent.Name == "Counter-Terrorists") then
                PsandColor3_fromRGB = Parent.Name == "Terrorists" and Color3.fromRGB(255, 130, 0) or Color3.fromRGB(0, 140, 255)
            end
        end
        if not (arg_130.TracerLine) then
        else
            local WorldToViewportPoint_6, var_309 = arg_131:WorldToViewportPoint(HumanoidRootPart.Position)

            if var_042.visualsEnable and var_042.tracers and HumanoidRootPart and var_309 then
                arg_130.TracerLine.Visible = true
                arg_130.TracerLine.From = var_005(arg_131.ViewportSize.X / (2), arg_131.ViewportSize.Y)
                arg_130.TracerLine.To = var_005(WorldToViewportPoint_6.X, WorldToViewportPoint_6.Y)
                arg_130.TracerLine.Color = PsandColor3_fromRGB
            else
                arg_130.TracerLine.Visible = false
            end
        end
        if arg_130.ViewTracerLine then
            local FindFirstChild_26 = arg_130.Character:FindFirstChild("Head")

            if not (var_042.visualsEnable and var_042.viewTracers and FindFirstChild_26) then
                arg_130.ViewTracerLine.Visible = false
            else
                local Position_3, LookVector_2 = FindFirstChild_26.Position, FindFirstChild_26.CFrame.LookVector
                local var_310 = Position_3 + LookVector_2 * (tonumber(var_042.traceLength) or 15)
                local WorldToViewportPoint_7, var_311 = arg_131:WorldToViewportPoint(Position_3)
                local WorldToViewportPoint_8, var_312 = arg_131:WorldToViewportPoint(var_310)

                if var_311 or var_312 then
                    arg_130.ViewTracerLine.Visible = true
                    arg_130.ViewTracerLine.From = var_005(WorldToViewportPoint_7.X, WorldToViewportPoint_7.Y)
                    arg_130.ViewTracerLine.To = var_005(WorldToViewportPoint_8.X, WorldToViewportPoint_8.Y)
                    arg_130.ViewTracerLine.Color = PsandColor3_fromRGB
                else
                    arg_130.ViewTracerLine.Visible = false
                end
            end
        end
    end
    var_285.UpdateChams = function(arg_134)
        if not (not arg_134.Character or not arg_134.Character.Parent) then
        else
            arg_134:DestroyChams()

            return
        end

        local FindFirstChildOfClass_9 = arg_134.Character:FindFirstChildOfClass("Humanoid")

        if not (FindFirstChildOfClass_9 and arg_134.CachedParts.Humanoid ~= FindFirstChildOfClass_9) then
        else
            arg_134:CacheCharacterParts(arg_134.Character)
        end

        local var_313 = var_042.visualsEnable == true and var_042.chams == true

        if not var_313 then
            arg_134:DestroyChams()

            return
        end
        if arg_134.Player == LocalPlayer_2 then
            arg_134:DestroyChams()

            return
        end
        if not (not var_253.Enabled) then
        else
            arg_134:DestroyChams()

            return
        end
        if var_253.TeamCheck and fn_084(arg_134.Player, arg_134.Character) then
            arg_134:DestroyChams()

            return
        end

        local var_314 = fn_084(arg_134.Player, arg_134.Character)
        local MqandColor3_fromRGB = var_314 and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 60, 60)

        if not (var_042.teamColorsAuto and not var_314) then
        else
            local Parent_2 = arg_134.Character.Parent

            if not (Parent_2 and (Parent_2.Name == "Terrorists" or Parent_2.Name == "Enforcers")) then
            else
                MqandColor3_fromRGB = Parent_2.Name == "Terrorists" and Color3.fromRGB(255, 130, 0) or Color3.fromRGB(0, 140, 255)
            end
        end

        local FindFirstChild_27, Highlight = arg_134.Character:FindFirstChild("AnimeModel") or arg_134.Character, arg_134.Highlight

        if not Highlight or not Highlight.Parent or Highlight.Parent ~= FindFirstChild_27 then
            if not (Highlight) then
            else
                var_265(function()
                    Highlight:Destroy()
                end)
            end

            Highlight = Instance.new("Highlight")
            Highlight.Name = "AntigravityChams"
            Highlight.Adornee = FindFirstChild_27
            Highlight.Parent = FindFirstChild_27
            arg_134.Highlight = Highlight
        end

        Highlight.Enabled = true
        Highlight.FillColor = MqandColor3_fromRGB
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.new(1, 1, 1)
        Highlight.OutlineTransparency = 0.2
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
    var_285.DestroyChams = function(arg_135)
        if arg_135.Highlight then
            var_265(function()
                arg_135.Highlight:Destroy()
            end)

            arg_135.Highlight = nil
        end
    end
    var_285.Destroy = function(arg_136)
        for it_131, it_132 in var_263(arg_136.Connections)do
            it_132:Disconnect()
        end

        arg_136.Connections = {}
        arg_136.CachedParts = {}

        arg_136:DestroyChams()

        if arg_136.Holder then
            arg_136.Holder:Destroy()

            arg_136.Holder = nil
        end
        if not (arg_136.TracerLine) then
        else
            var_265(function()
                arg_136.TracerLine:Destroy()
            end)

            arg_136.TracerLine = nil
        end
        if arg_136.ViewTracerLine then
            var_265(function()
                arg_136.ViewTracerLine:Destroy()
            end)

            arg_136.ViewTracerLine = nil
        end
    end

    local FindFirstChild_28 = var_267:FindFirstChild("AntigravityESP")

    if FindFirstChild_28 then
        FindFirstChild_28:Destroy()
    end
    if not (getgenv().AntigravityESP_Connection) then
    else
        var_265(function()
            getgenv().AntigravityESP_Connection:Disconnect()
        end)

        getgenv().AntigravityESP_Connection = nil
    end
    if getgenv().AntigravityESP_Objects then
        for it_133, it_134 in var_264(getgenv().AntigravityESP_Objects)do
            it_134:Destroy()
        end

        getgenv().AntigravityESP_Objects = nil
    end

    getgenv().AntigravityESP_ScreenGui = Instance.new("ScreenGui")
    getgenv().AntigravityESP_ScreenGui.Name = "AntigravityESP"
    getgenv().AntigravityESP_ScreenGui.IgnoreGuiInset = true
    getgenv().AntigravityESP_ScreenGui.DisplayOrder = 999
    getgenv().AntigravityESP_ScreenGui.Parent = var_267
    getgenv().AntigravityESP_Objects = {}

    fn_078()

    local function fn_086(arg_137)
        if not (arg_137 == LocalPlayer_2) then
        else
            return
        end

        getgenv().AntigravityESP_Objects[arg_137] = var_285.new(arg_137)
    end
    local function fn_087(arg_138)
        local var_315 = getgenv().AntigravityESP_Objects[arg_138]

        if not (var_315) then
        else
            var_315:Destroy()

            getgenv().AntigravityESP_Objects[arg_138] = nil
        end
    end

    for it_135, it_136 in var_263(Players_4:GetPlayers())do
        fn_086(it_136)
    end

    local Connect_5, Connect_6, Connect_7 = Players_4.PlayerAdded:Connect(fn_086), Players_4.PlayerRemoving:Connect(fn_087), RunService_2.Heartbeat:Connect(function()
        local CurrentCamera_2 = Workspace_2.CurrentCamera

        if not (not CurrentCamera_2) then
        else
            return
        end

        var_253.Enabled = var_042.visualsEnable == true
        var_253.TeamCheck = not var_042.showTeammates
        var_253.Names.Enabled = var_042.nameEsp == true
        var_253.Boxes.Enabled = var_042.boxes == true
        var_253.Boxes.Mode = var_042.box3d and "Corner" or "Full"
        var_253.Healthbars.Enabled = var_042.hpBar == true
        var_253.Distance.Enabled = var_042.distanceEsp == true
        var_253.Weapon.Enabled = var_042.weaponEsp == true

        for it_137, it_138 in var_264(getgenv().AntigravityESP_Objects)do
            local Update, var_316 = var_265(function()
                it_138:Update(CurrentCamera_2, LocalPlayer_2)
                it_138:UpdateChams()
            end)

            if not (not Update) then
            else
                var_266("[Wyvern ESP Error]: " .. tostring(var_316))
            end
        end
    end)

    getgenv().AntigravityESP_Connection = {
        Disconnect = function()
            Connect_5:Disconnect()
            Connect_6:Disconnect()
            Connect_7:Disconnect()
        end,
    }
end

local var_317, var_318, var_319, Connect_8 = false, 0, 0, mousemoverel or (Input and Input.MouseMoveRel)

RunService.RenderStepped:Connect(function(arg_139)
    local IsMouseButtonPressed_2 = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

    if not (IsMouseButtonPressed_2) then
        var_317 = false
        var_319 = 0
    else
        if not var_317 then
            var_317 = true
            var_318 = tick()
        end

        local var_320, var_321, var_322 = var_042.rcs == true or var_042.rageMode == true, tonumber(var_042.rcsDelay) or 0, tonumber(var_042.rcsStrength) or 50
        local var_323 = var_321 / (1E3)

        if var_320 and (tick() - var_318) >= var_323 then
            var_319 = var_319 + (var_322 * arg_139 * (0.8))

            if not (var_319 >= 1) then
            else
                local var_324 = floor(var_319)

                var_319 = var_319 - var_324

                if not (Connect_8) then
                    CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.Angles(math.rad(-var_324 * (0.1)), 0, 0)
                else
                    pcall(function()
                        Connect_8(0, var_324)
                    end)
                end
            end
        end
    end
end)

local var_325, var_326, var_327, Connect_9 = false, mouse1press or (Input and Input.LeftClickPress) or function() end, mouse1release or (Input and Input.LeftClickRelease) or function() end, mouse1click or (Input and Input.LeftClick) or function() end

RunService.RenderStepped:Connect(function()
    if not (not var_042.triggerBot or var_325) then
    else
        return
    end

    local var_328 = false

    if not (LocalPlayer.Character) then
    else
        local FindFirstChildOfClass_10 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if FindFirstChildOfClass_10 and FindFirstChildOfClass_10.Health > 0 then
            var_328 = true
        end
    end
    if not (not var_328) then
    else
        return
    end

    local var_329 = getAimTarget and getAimTarget()

    if var_329 then
        local var_330 = var_005(CurrentCamera.ViewportSize.X / (2), CurrentCamera.ViewportSize.Y / (2))
        local WorldToViewportPoint_9, var_331 = CurrentCamera:WorldToViewportPoint(var_329.Position)

        if var_331 then
            local Magnitude_3, var_332 = (var_005(WorldToViewportPoint_9.X, WorldToViewportPoint_9.Y) - var_330).Magnitude, tonumber(var_042.aimlockFov) or 150

            if not (Magnitude_3 <= var_332) then
            else
                var_325 = true

                spawn_2(function()
                    local var_333 = tonumber(var_042.triggerDelay) or 0

                    if var_333 > 0 then
                        wait_2(var_333 / (1E3))
                    end

                    local var_334 = getAimTarget and getAimTarget()

                    if not (var_334 and var_334 == var_329) then
                    else
                        if not (mousemoverel) then
                        else
                            if var_326 and var_327 then
                                pcall(var_326)
                                wait_2(2E-2)
                                pcall(var_327)
                            elseif not (Connect_9) then
                            else
                                pcall(Connect_9)
                            end
                        end
                    end

                    wait_2(5E-2)

                    var_325 = false
                end)
            end
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if not (var_042.antiFlash) then
    else
        pcall(function()
            Lighting.ExposureCompensation = 0

            for it_139, it_140 in ipairs(Lighting:GetChildren())do
                if it_140:IsA("ColorCorrectionEffect") and (find_2(lower(it_140.Name), "flash") or it_140.TintColor == Color3.new(1, 1, 1)) then
                    it_140.Enabled = false
                end
            end

            local FindFirstChildOfClass_11 = LocalPlayer:FindFirstChildOfClass("PlayerGui")

            if FindFirstChildOfClass_11 then
                for it_141, it_142 in ipairs(FindFirstChildOfClass_11:GetChildren())do
                    if not (find_2(lower(it_142.Name), "flash") or find_2(lower(it_142.Name), "blind")) then
                    else
                        it_142:Destroy()
                    end
                end
            end
        end)
    end
end)

local var_335 = {}

local function fn_088(arg_140)
    if not arg_140:IsA("BasePart") then
        return
    end

    pcall(function()
        arg_140.LocalTransparencyModifier = 1
        arg_140.CastShadow = false
    end)

    for it_143, it_144 in ipairs(arg_140:GetDescendants())do
        if it_144:IsA("ParticleEmitter") or it_144:IsA("Smoke") or it_144:IsA("Fire") or it_144:IsA("Sparkles") or it_144:IsA("Trail") or it_144:IsA("Beam") then
            pcall(function()
                it_144:Destroy()
            end)
        end
    end

    local Connect_10 = arg_140.DescendantAdded:Connect(function(arg_141)
        if not var_042.antiSmoke then
            return
        end
        if arg_141:IsA("ParticleEmitter") or arg_141:IsA("Smoke") or arg_141:IsA("Fire") or arg_141:IsA("Sparkles") or arg_141:IsA("Trail") or arg_141:IsA("Beam") then
            pcall(function()
                arg_141:Destroy()
            end)
        end
    end)

    table.insert(var_335, Connect_10)
end
local function fn_089(arg_142)
    if not (not (arg_142:IsA("Folder") and find_2(lower(arg_142.Name), "voxelsmoke"))) then
    else
        return
    end

    for it_145, it_146 in ipairs(arg_142:GetChildren())do
        fn_088(it_146)
    end

    local Connect_11 = arg_142.ChildAdded:Connect(function(arg_143)
        if not (var_042.antiSmoke) then
        else
            fn_088(arg_143)
        end
    end)

    table.insert(var_335, Connect_11)
end
local function fn_090()
    local WaitForChild_2 = Workspace:WaitForChild("Debris", 10)

    if not WaitForChild_2 then
        return
    end

    for it_147, it_148 in ipairs(WaitForChild_2:GetChildren())do
        fn_089(it_148)
    end

    local Connect_12 = WaitForChild_2.ChildAdded:Connect(function(arg_144)
        if not (var_042.antiSmoke) then
        else
            fn_089(arg_144)
        end
    end)

    table.insert(var_335, Connect_12)
end
local function fn_091()
    for it_149, it_150 in ipairs(var_335)do
        if not (it_150) then
        else
            pcall(function()
                it_150:Disconnect()
            end)
        end
    end

    table.clear(var_335)
end

fn_011("antiSmoke", function(arg_145)
    if arg_145 then
        spawn_2(fn_090)
    else
        fn_091()
    end
end)

local var_336 = {
    Materials = {},
    Reflectances = {},
    Textures = {},
    GlobalShadows = nil,
}

local function fn_092()
    var_336.GlobalShadows = Lighting.GlobalShadows
    Lighting.GlobalShadows = false

    for it_151, it_152 in ipairs(Workspace:GetDescendants())do
        if it_152:IsDescendantOf(CurrentCamera) or (it_152.Parent and it_152.Parent:FindFirstChildOfClass("Humanoid")) then
            continue
        end
        if it_152:IsA("BasePart") then
            var_336.Materials[it_152] = it_152.Material
            var_336.Reflectances[it_152] = it_152.Reflectance
            it_152.Material = Enum.Material.SmoothPlastic
            it_152.Reflectance = 0
        elseif not (it_152:IsA("Decal") or it_152:IsA("Texture")) then
        else
            var_336.Textures[it_152] = it_152.Transparency
            it_152.Transparency = 1
        end
    end
end
local function fn_093()
    if var_336.GlobalShadows ~= nil then
        Lighting.GlobalShadows = var_336.GlobalShadows
    end

    for it_153, it_154 in pairs(var_336.Materials)do
        if not (it_153 and it_153.Parent) then
        else
            it_153.Material = it_154
        end
    end
    for it_155, it_156 in pairs(var_336.Reflectances)do
        if not (it_155 and it_155.Parent) then
        else
            it_155.Reflectance = it_156
        end
    end
    for it_157, it_158 in pairs(var_336.Textures)do
        if not (it_157 and it_157.Parent) then
        else
            it_157.Transparency = it_158
        end
    end

    table.clear(var_336.Materials)
    table.clear(var_336.Reflectances)
    table.clear(var_336.Textures)

    var_336.GlobalShadows = nil
end

fn_011("lowGfx", function(arg_146)
    if not (arg_146) then
        fn_093()
    else
        spawn_2(fn_092)
    end
end)

local var_337, Instance_new_102 = nil, Instance.new("Frame")

Instance_new_102.Name = "Wyvern_PreviewPanel"
Instance_new_102.Size = UDim2.fromOffset(280, GetAttribute.Y)
Instance_new_102.Position = var_007(1, 8, 0, 0)
Instance_new_102.BackgroundColor3 = var_016.Sidebar
Instance_new_102.BorderSizePixel = 0
Instance_new_102.Visible = false
Instance_new_102.Parent = Main

fn_023(Instance_new_102, 4)
fn_024(Instance_new_102, var_016.Outline, 1, 0.15)
fn_027(Instance_new_102, 0.12, 0.55)

local Instance_new_103 = Instance.new("TextLabel", Instance_new_102)

Instance_new_103.Size = var_007(1, 0, 0, 24)
Instance_new_103.Position = var_007(0, 0, 1, -24)
Instance_new_103.BackgroundTransparency = 1
Instance_new_103.Text = "Drag: Rotate Model | Scroll: Zoom In/Out"
Instance_new_103.TextColor3 = var_016.TextMute
Instance_new_103.Font = Enum.Font.GothamMedium
Instance_new_103.TextSize = 10
Instance_new_103.TextXAlignment = Enum.TextXAlignment.Center

local function fn_094(arg_147)
    for it_159, it_160 in ipairs(arg_147:GetDescendants())do
        if it_160:IsA("JointInstance") then
            local Part0, Part1 = it_160.Part0, it_160.Part1

            if not (Part0 and Part1 and Part0:IsA("BasePart") and Part1:IsA("BasePart")) then
            else
                pcall(function()
                    Part1.CFrame = Part0.CFrame * it_160.C0 * it_160.C1:Inverse()
                end)
            end
        end
    end
end
local function fn_095(arg_148)
    local p, var_338 = nil, -1

    for it_161, it_162 in ipairs(arg_148:GetDescendants())do
        if it_162:IsA("BasePart") and it_162.Transparency < 0.95 then
            local var_339 = it_162.Size.X * it_162.Size.Y * it_162.Size.Z

            if not (var_339 > var_338) then
            else
                var_338 = var_339
                p = it_162
            end
        end
    end

    if not p then
        p = arg_148:FindFirstChildWhichIsA("BasePart", true)
    end
    if not (not p) then
    else
        return var_006(), var_004(1, 1, 1)
    end

    local huge_5, huge_6, huge_7, huge_8, huge_9, huge_10, var_340 = math.huge, math.huge, math.huge, -math.huge, -math.huge, -math.huge, false

    for it_163, it_164 in ipairs(arg_148:GetDescendants())do
        if it_164:IsA("BasePart") then
            if (it_164.Position - p.Position).Magnitude > 15 then
                continue
            end
            if not (it_164.Transparency >= 0.95) then
            else
                continue
            end

            var_340 = true

            local CFrame_3, var_341, FindFirstChildWhichIsA_2 = it_164.CFrame, it_164.Size / (2), it_164:FindFirstChildWhichIsA("SpecialMesh")

            if not (FindFirstChildWhichIsA_2) then
            else
                var_341 = var_341 * FindFirstChildWhichIsA_2.Scale
            end

            local var_342 = {
                CFrame_3 * var_004(var_341.X, var_341.Y, var_341.Z),
                CFrame_3 * var_004(var_341.X, var_341.Y, -var_341.Z),
                CFrame_3 * var_004(var_341.X, -var_341.Y, var_341.Z),
                CFrame_3 * var_004(var_341.X, -var_341.Y, -var_341.Z),
                CFrame_3 * var_004(-var_341.X, var_341.Y, var_341.Z),
                CFrame_3 * var_004(-var_341.X, var_341.Y, -var_341.Z),
                CFrame_3 * var_004(-var_341.X, -var_341.Y, var_341.Z),
                CFrame_3 * var_004(-var_341.X, -var_341.Y, -var_341.Z),
            }

            for it_165, it_166 in ipairs(var_342)do
                if it_166.X < huge_5 then
                    huge_5 = it_166.X
                end
                if it_166.Y < huge_6 then
                    huge_6 = it_166.Y
                end
                if it_166.Z < huge_7 then
                    huge_7 = it_166.Z
                end
                if it_166.X > huge_8 then
                    huge_8 = it_166.X
                end
                if it_166.Y > huge_9 then
                    huge_9 = it_166.Y
                end
                if it_166.Z > huge_10 then
                    huge_10 = it_166.Z
                end
            end
        end
    end

    if not var_340 then
        return p.CFrame, p.Size
    end

    return var_006(var_004((huge_5 + huge_8) / (2), (huge_6 + huge_9) / (2), (huge_7 + huge_10) / (2))), var_004(huge_8 - huge_5, huge_9 - huge_6, huge_10 - huge_7)
end
local function fn_096(arg_149, arg_150, arg_151)
    if not (not arg_151 or arg_151 == "Vanilla" or arg_151 == "Stock") then
    else
        return
    end

    local var_343 = nil

    for it_167, it_168 in ipairs(game:GetChildren())do
        local var_344, var_345 = pcall(function()
            return it_168.Assets.Skins
        end)

        if not (var_344 and var_345) then
        else
            var_343 = var_345

            break
        end
    end

    if not (not var_343) then
    else
        return
    end

    local var_346 = nil

    for it_169, it_170 in ipairs(var_343:GetChildren())do
        if not (lower(it_170.Name) == lower(arg_150)) then
        else
            var_346 = it_170

            break
        end
    end

    if not var_346 then
        return
    end

    local var_347 = nil

    for it_171, it_172 in ipairs(var_346:GetChildren())do
        if lower(it_172.Name) == lower(arg_151) then
            var_347 = it_172

            break
        end
    end

    if not (not var_347) then
    else
        return
    end

    local FindFirstChild_29 = var_347:FindFirstChild("Camera") or var_347
    local FindFirstChild_30, var_348, var_349 = FindFirstChild_29:FindFirstChild("Factory New") or FindFirstChild_29:FindFirstChild("Minimal Wear") or FindFirstChild_29, {}, nil

    for it_173, it_174 in ipairs(FindFirstChild_30:GetChildren())do
        if not (it_174:IsA("SurfaceAppearance") or it_174:IsA("Texture") or it_174:IsA("Decal")) then
            if it_174:IsA("MeshPart") then
                var_348[lower(it_174.Name)] = it_174
            end
        else
            var_348[lower(it_174.Name)] = it_174

            if find_2(lower(it_174.Name), "body") or find_2(lower(it_174.Name), "main") then
                var_349 = it_174
            end
        end
    end

    if not (not var_349) then
    else
        for it_175, it_176 in pairs(var_348)do
            var_349 = it_176

            break
        end
    end

    for it_177, it_178 in ipairs(arg_149:GetDescendants())do
        if not (it_178:IsA("BasePart")) then
        else
            local var_350, var_351 = var_348[lower(it_178.Name)], false

            if not (not var_350) then
            else
                for it_179, it_180 in ipairs(it_178:GetChildren())do
                    if it_180:IsA("SurfaceAppearance") and var_348[lower(it_180.Name)] then
                        var_350 = var_348[lower(it_180.Name)]

                        break
                    end
                end
            end
            if not var_350 and it_178:IsA("MeshPart") then
                var_350 = var_349
                var_351 = true
            end
            if not (var_350) then
            else
                for it_181, it_182 in ipairs(it_178:GetChildren())do
                    if it_182:IsA("SurfaceAppearance") or it_182:IsA("Texture") or it_182:IsA("Decal") then
                        it_182:Destroy()
                    end
                end

                if not (it_178:IsA("MeshPart")) then
                else
                    if var_350:IsA("MeshPart") and not var_351 then
                        it_178.MeshId = var_350.MeshId
                    end

                    pcall(function()
                        it_178.TextureID = var_350.TextureID or ''
                    end)
                end

                local FindFirstChildWhichIsA_3 = it_178:FindFirstChildWhichIsA("SpecialMesh")

                if FindFirstChildWhichIsA_3 then
                    local FindFirstChildWhichIsA_4 = var_350:FindFirstChildWhichIsA("SpecialMesh")

                    if FindFirstChildWhichIsA_4 and not var_351 then
                        FindFirstChildWhichIsA_3.MeshId = FindFirstChildWhichIsA_4.MeshId
                        FindFirstChildWhichIsA_3.Scale = FindFirstChildWhichIsA_4.Scale
                        FindFirstChildWhichIsA_3.Offset = FindFirstChildWhichIsA_4.Offset
                    end
                    if FindFirstChildWhichIsA_4 then
                        FindFirstChildWhichIsA_3.TextureId = FindFirstChildWhichIsA_4.TextureId
                    else
                        FindFirstChildWhichIsA_3.TextureId = ''
                    end
                end

                for it_183, it_184 in ipairs(var_350:GetChildren())do
                    if not (it_184:IsA("SurfaceAppearance") or it_184:IsA("Texture") or it_184:IsA("Decal")) then
                    else
                        it_184:Clone().Parent = it_178
                    end
                end

                if var_350:IsA("SurfaceAppearance") or var_350:IsA("Texture") or var_350:IsA("Decal") then
                    var_350:Clone().Parent = it_178
                end
            end
        end
    end
end
local function fn_097(arg_152, arg_153, arg_154)
    if var_337 then
        var_337:Disconnect()

        var_337 = nil
    end

    local FindFirstChild_31 = Instance_new_102:FindFirstChild("Wyvern_Viewport")

    if not (FindFirstChild_31) then
    else
        FindFirstChild_31:Destroy()
    end

    local var_352 = lower(arg_152 or '')
    local var_353, FindFirstChild_32 = find_2(var_352, "sg 553") or find_2(var_352, "aug") or find_2(var_352, "berettas"), Instance_new_102:FindFirstChild("PreviewWarning")

    if not (var_353) then
        if FindFirstChild_32 then
            FindFirstChild_32.Visible = false
        end
    else
        if not FindFirstChild_32 then
            FindFirstChild_32 = Instance.new("TextLabel", Instance_new_102)
            FindFirstChild_32.Name = "PreviewWarning"
            FindFirstChild_32.Size = var_007(1, -20, 1, -40)
            FindFirstChild_32.Position = UDim2.fromOffset(10, 10)
            FindFirstChild_32.BackgroundTransparency = 1
            FindFirstChild_32.TextColor3 = var_016.Hot
            FindFirstChild_32.Font = Enum.Font.GothamBold
            FindFirstChild_32.TextSize = 12
            FindFirstChild_32.TextWrapped = true
            FindFirstChild_32.TextYAlignment = Enum.TextYAlignment.Center
        end

        FindFirstChild_32.Text = "⚠️ " .. string.upper(arg_152) .. " NOT WORKING ⚠️\n\nModel source corrupted by game engine.\nPreview disabled to prevent crash.\nYou can still change/save skin safely."
        FindFirstChild_32.Visible = true

        return
    end

    local Instance_new_104 = Instance.new("ViewportFrame", Instance_new_102)

    Instance_new_104.Name = "Wyvern_Viewport"
    Instance_new_104.Size = var_007(1, 0, 1, -24)
    Instance_new_104.Position = var_007(0, 0, 0, 0)
    Instance_new_104.BackgroundTransparency = 1
    Instance_new_104.LightColor = Color3.new(1, 1, 1)
    Instance_new_104.Ambient = Color3.new(0.8, 0.8, 0.8)

    local Instance_new_105 = Instance.new("Camera")

    Instance_new_105.FieldOfView = 25
    Instance_new_104.CurrentCamera = Instance_new_105
    Instance_new_105.Parent = Instance_new_104

    local var_354, var_355 = nil, string.gsub(string.gsub(var_352, "%-", ''), " ", '')

    for it_185, it_186 in ipairs(game:GetService("ReplicatedStorage"):GetDescendants())do
        local var_356 = string.gsub(string.gsub(lower(it_186.Name), "%-", ''), " ", '')

        if not (var_356 == var_355 and (it_186:IsA("Model") or it_186:IsA("Folder") or it_186:IsA("MeshPart"))) then
        else
            if not (it_186:FindFirstChildWhichIsA("BasePart", true)) then
            else
                var_354 = it_186:Clone()

                break
            end
        end
    end

    if not (not var_354) then
    else
        return
    end

    local var_357 = var_354

    if not (not var_357:IsA("Model")) then
    else
        var_357 = Instance.new("Model")
        var_357.Name = arg_152

        for it_187, it_188 in ipairs(var_354:GetChildren())do
            it_188.Parent = var_357
        end
    end

    for it_189, it_190 in ipairs(var_357:GetChildren())do
        local var_358 = lower(it_190.Name)

        if var_358 == "viewmodel" or var_358 == "v_model" or var_358 == "client" or var_358 == "arms" then
            it_190:Destroy()
        end
    end

    local var_359, var_360 = (find_2(var_352, "dual") or find_2(var_352, "daggers") or find_2(var_355, "berettas")) and 2 or 1, {}

    for it_191, it_192 in ipairs(var_357:GetDescendants())do
        if not (it_192:IsA("BasePart")) then
            if not (it_192:IsA("Script") or it_192:IsA("LocalScript") or it_192:IsA("Sound") or it_192:IsA("ParticleEmitter") or it_192:IsA("Light") or it_192:IsA("Attachment")) then
            else
                it_192:Destroy()
            end
        else
            local var_361, var_362 = lower(it_192.Name), it_192.Parent and lower(it_192.Parent.Name) or ''
            local var_363, var_364 = (find_2(var_361, "arm") and not find_2(var_361, "firearm")) or (find_2(var_361, "hand") and not find_2(var_361, "handle") and not find_2(var_361, "handguard")) or find_2(var_361, "sleeve"), (find_2(var_362, "arm") and not find_2(var_362, "firearm")) or (find_2(var_362, "hand") and not find_2(var_362, "handle") and not find_2(var_362, "handguard")) or find_2(var_362, "sleeve")

            if (var_363 or var_364) and not arg_154 then
                it_192:Destroy()

                continue
            end

            local var_365 = find_2(var_361, "hitbox") or find_2(var_361, "bounds") or find_2(var_361, "collision") or var_361 == "humanoidrootpart" or var_361 == "clipbox" or var_361 == "root"

            if not (var_365) then
            else
                it_192:Destroy()

                continue
            end
            if it_192.ClassName == "Part" and not arg_154 then
                if not it_192:FindFirstChildWhichIsA("DataModelMesh") and not it_192:FindFirstChildWhichIsA("SurfaceAppearance") then
                    it_192:Destroy()

                    continue
                end
            end
            if it_192.Transparency >= 0.95 and not arg_154 then
                it_192:Destroy()

                continue
            end

            local var_366, FindFirstChildWhichIsA_5 = it_192:IsA("MeshPart") and it_192.MeshId or '', it_192:FindFirstChildWhichIsA("SpecialMesh")

            if FindFirstChildWhichIsA_5 then
                var_366 = FindFirstChildWhichIsA_5.MeshId
            end
            if not (var_366 ~= '') then
            else
                var_360[var_366] = (var_360[var_366] or 0) + (1)

                if var_360[var_366] > var_359 then
                    it_192:Destroy()
                end
            end
        end
    end

    fn_094(var_357)
    fn_096(var_357, arg_152, arg_153)

    var_357.Parent = Instance_new_104

    local var_367, var_368 = fn_095(var_357)
    local var_369 = math.max(var_368.X, var_368.Y, var_368.Z)

    if var_369 < 0.5 then
        var_369 = 1.5
    end
    if var_369 > 8 then
        var_369 = 6
    end

    local var_370 = var_006()

    if not (arg_154) then
        if not (var_008(var_369 - var_368.Y) < 0.3) then
            if var_008(var_369 - var_368.Z) < 0.3 then
                var_370 = CFrame.Angles(0, math.rad(90), 0)
            end
        else
            var_370 = CFrame.Angles(0, 0, math.rad(90))
        end
    else
        var_370 = CFrame.Angles(0, math.rad(90), 0)
    end

    var_357:PivotTo(var_370)

    local var_371, var_372, var_373, var_374, var_375, Instance_new_106 = arg_154 and (var_369 * (3.5)) or (var_369 * (2.2)), math.rad(-10), math.rad(-90), false, var_005(), Instance.new("TextButton", Instance_new_104)

    Instance_new_106.Size = UDim2.fromScale(1, 1)
    Instance_new_106.BackgroundTransparency = 1
    Instance_new_106.Text = ''
    Instance_new_106.ZIndex = 5

    Instance_new_106.InputBegan:Connect(function(arg_155)
        if arg_155.UserInputType == Enum.UserInputType.MouseButton1 or arg_155.UserInputType == Enum.UserInputType.Touch then
            var_374 = true
            var_375 = var_005(arg_155.Position.X, arg_155.Position.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(arg_156)
        if not (arg_156.UserInputType == Enum.UserInputType.MouseButton1 or arg_156.UserInputType == Enum.UserInputType.Touch) then
        else
            var_374 = false
        end
    end)
    UserInputService.InputChanged:Connect(function(arg_157)
        if var_374 and (arg_157.UserInputType == Enum.UserInputType.MouseMovement or arg_157.UserInputType == Enum.UserInputType.Touch) then
            local var_376 = var_005(arg_157.Position.X, arg_157.Position.Y)
            local var_377 = var_376 - var_375

            var_373 = var_373 - math.rad(var_377.X * (0.4))
            var_372 = clamp(var_372 - math.rad(var_377.Y * (0.4)), math.rad(-85), math.rad(85))
            var_375 = var_376
        elseif not (arg_157.UserInputType == Enum.UserInputType.MouseWheel) then
        else
            var_371 = clamp(var_371 - (arg_157.Position.Z * var_369 * (0.3)), var_369 * (0.8), var_369 * (8))
        end
    end)

    var_337 = RunService.RenderStepped:Connect(function()
        if not Instance_new_104.Parent then
            if not (var_337) then
            else
                var_337:Disconnect()

                var_337 = nil
            end

            return
        end

        local var_378 = CFrame.Angles(var_372, var_373, 0)

        Instance_new_105.CFrame = CFrame.lookAt(var_378 * var_004(0, 0, var_371), var_004(0, 0, 0))
    end)
end
local function fn_098(arg_158)
    if not (not var_042.menuOpen) then
    else
        return
    end
    if arg_158 == "GunSkins" then
        fn_097(var_042.selectedGun, var_042.selectedGunSkin, false)
    elseif not (arg_158 == "Knives") then
        if arg_158 == "Gloves" then
            fn_097(var_042.selectedGlove, var_042.selectedGloveSkin, true)
        end
    else
        fn_097(var_042.selectedKnife, var_042.selectedKnifeSkin, false)
    end
end

fn_011("activeTab", function(arg_159)
    if arg_159 == "GunSkins" or arg_159 == "Knives" or arg_159 == "Gloves" then
        Instance_new_102.Visible = true

        fn_098(arg_159)
    else
        Instance_new_102.Visible = false

        if not (var_337) then
        else
            var_337:Disconnect()

            var_337 = nil
        end
    end
end)
fn_011("selectedGun", function()
    if not (var_042.activeTab == "GunSkins") then
    else
        fn_098("GunSkins")
    end
end)
fn_011("selectedGunSkin", function()
    if not (var_042.activeTab == "GunSkins") then
    else
        fn_098("GunSkins")
    end
end)
fn_011("selectedKnife", function()
    if var_042.activeTab == "Knives" then
        fn_098("Knives")
    end
end)
fn_011("selectedKnifeSkin", function()
    if not (var_042.activeTab == "Knives") then
    else
        fn_098("Knives")
    end
end)
fn_011("selectedGlove", function()
    if var_042.activeTab == "Gloves" then
        fn_098("Gloves")
    end
end)
fn_011("selectedGloveSkin", function()
    if not (var_042.activeTab == "Gloves") then
    else
        fn_098("Gloves")
    end
end)

local CollectionService, FindFirstChild_33 = game:GetService("CollectionService"), fn_002():FindFirstChild("Wyvern_ESP_GUI") or Instance.new("ScreenGui")

if not (not FindFirstChild_33.Parent) then
else
    FindFirstChild_33.Name = "Wyvern_ESP_GUI"
    FindFirstChild_33.IgnoreGuiInset = true
    FindFirstChild_33.Parent = fn_002()
end

local function fn_099()
    local Instance_new_107 = Instance.new("TextLabel")

    Instance_new_107.BackgroundTransparency = 1
    Instance_new_107.Visible = false
    Instance_new_107.Font = Enum.Font.GothamBold
    Instance_new_107.TextSize = 11
    Instance_new_107.TextColor3 = Color3.new(1, 1, 1)
    Instance_new_107.TextStrokeTransparency = 0.8
    Instance_new_107.AnchorPoint = var_005(0.5, 0.5)
    Instance_new_107.Parent = FindFirstChild_33

    return Instance_new_107
end

local var_379, var_380 = {}, {}

local function fn_100(arg_160)
    if not (not arg_160:IsA("Model") or var_379[arg_160]) then
    else
        return
    end

    local GetAttribute_7 = arg_160:GetAttribute("Weapon") or arg_160.Name

    if not (type(GetAttribute_7) ~= "string" or GetAttribute_7 == '' or GetAttribute_7 == "C4") then
    else
        return
    end

    local var_381, FindFirstChildWhichIsA_6 = fn_010(GetAttribute_7) or "Dropped Weapon", arg_160.PrimaryPart or arg_160:FindFirstChildWhichIsA("BasePart", true)

    if not (not FindFirstChildWhichIsA_6) then
    else
        return
    end

    local var_382 = fn_099()

    var_382.TextColor3 = fromRGB(180, 255, 100)
    var_382.TextSize = 11
    var_379[arg_160] = {
        Label = var_382,
        Primary = FindFirstChildWhichIsA_6,
        Name = var_381,
    }
end
local function fn_101(arg_161)
    if not (var_379[arg_161]) then
    else
        pcall(function()
            var_379[arg_161].Label:Destroy()
        end)

        var_379[arg_161] = nil
    end
end
local function fn_102(arg_162)
    if var_380[arg_162] then
        return
    end

    local var_383 = find_2(lower(arg_162.Name), "c4") or find_2(lower(arg_162.Name), "bomb")

    if not var_383 and arg_162:FindFirstChild("Weapon") then
        local Weapon = arg_162.Weapon

        if Weapon:FindFirstChild("Circle") and Weapon:FindFirstChild("Plane") then
            var_383 = true
        end
    end
    if not (not var_383) then
    else
        return
    end

    local var_384 = arg_162:IsA("BasePart") and arg_162 or arg_162.PrimaryPart or arg_162:FindFirstChildWhichIsA("BasePart", true)

    if not var_384 then
        return
    end

    local var_385 = fn_099()

    var_385.TextColor3 = var_016.Hot
    var_385.TextSize = 12
    var_380[arg_162] = {
        Label = var_385,
        Primary = var_384,
    }
end
local function fn_103(arg_163)
    if var_380[arg_163] then
        pcall(function()
            var_380[arg_163].Label:Destroy()
        end)

        var_380[arg_163] = nil
    end
end

spawn_2(function()
    for it_193, it_194 in ipairs(CollectionService:GetTagged("WeaponDropped"))do
        fn_100(it_194)
    end

    CollectionService:GetInstanceAddedSignal("WeaponDropped"):Connect(fn_100)
    CollectionService:GetInstanceRemovedSignal("WeaponDropped"):Connect(fn_101)

    local WaitForChild_3 = Workspace:WaitForChild("Debris", 10)

    if WaitForChild_3 then
        for it_195, it_196 in ipairs(WaitForChild_3:GetChildren())do
            fn_102(it_196)
        end

        WaitForChild_3.ChildAdded:Connect(fn_102)
        WaitForChild_3.ChildRemoved:Connect(fn_103)
    end
end)
RunService.RenderStepped:Connect(function()
    if not CurrentCamera then
        return
    end

    local Character_4 = LocalPlayer.Character
    local FindFirstChild_34 = Character_4 and Character_4:FindFirstChild("HumanoidRootPart")
    local zero = FindFirstChild_34 and FindFirstChild_34.Position or Vector3.zero

    for it_197, it_198 in pairs(var_379)do
        if not (it_197.Parent and it_198.Primary and it_198.Primary.Parent and var_042.worldWeaponEsp and var_042.visualsEnable) then
            it_198.Label.Visible = false
        else
            local Position_4 = it_198.Primary.Position
            local WorldToViewportPoint_10, var_386 = CurrentCamera:WorldToViewportPoint(Position_4)
            local var_387 = floor((zero - Position_4).Magnitude / (3))

            if not (var_386 and var_387 <= (tonumber(var_042.fovSize) or 500)) then
                it_198.Label.Visible = false
            else
                it_198.Label.Text = format("%s\n[%dm]", it_198.Name, var_387)
                it_198.Label.Position = UDim2.fromOffset(WorldToViewportPoint_10.X, WorldToViewportPoint_10.Y)
                it_198.Label.Visible = true
            end
        end
    end
    for it_199, it_200 in pairs(var_380)do
        if it_199.Parent and it_200.Primary and it_200.Primary.Parent and var_042.c4Esp and var_042.visualsEnable then
            local Position_5 = it_200.Primary.Position
            local WorldToViewportPoint_11, var_388 = CurrentCamera:WorldToViewportPoint(Position_5)
            local var_389 = floor((zero - Position_5).Magnitude / (3))

            if not (var_388) then
                it_200.Label.Visible = false
            else
                it_200.Label.Text = format(" BOMB \n[%dm]", var_389)
                it_200.Label.Position = UDim2.fromOffset(WorldToViewportPoint_11.X, WorldToViewportPoint_11.Y)
                it_200.Label.Visible = true
            end
        else
            it_200.Label.Visible = false
        end
    end
end)

local function fn_104()
    local var_390, fromOffset_2, Instance_new_108 = UDim2.new, UDim2.fromOffset, Instance.new("Frame")

    Instance_new_108.Name = "Wyvern_EspPreview"
    Instance_new_108.Size = UDim2.fromOffset(280, GetAttribute.Y)
    Instance_new_108.Position = var_007(1, 8, 0, 0)
    Instance_new_108.BackgroundColor3 = var_016.Sidebar
    Instance_new_108.BorderSizePixel = 0
    Instance_new_108.Visible = false
    Instance_new_108.Parent = Main

    fn_023(Instance_new_108, 4)
    fn_024(Instance_new_108, var_016.Outline, 1, 0.15)
    fn_027(Instance_new_108, 0.12, 0.55)

    local Instance_new_109 = Instance.new("TextLabel", Instance_new_108)

    Instance_new_109.Size = var_007(1, 0, 0, 35)
    Instance_new_109.BackgroundTransparency = 1
    Instance_new_109.Text = "ESP Preview"
    Instance_new_109.TextColor3 = var_016.AccentSoft
    Instance_new_109.Font = Enum.Font.GothamBlack
    Instance_new_109.TextSize = 14

    local Instance_new_110 = Instance.new("Frame", Instance_new_108)

    Instance_new_110.Size = var_007(1, -40, 1, -60)
    Instance_new_110.Position = UDim2.fromOffset(20, 45)
    Instance_new_110.BackgroundTransparency = 1

    local Instance_new_111 = Instance.new("Frame", Instance_new_110)

    Instance_new_111.Size = UDim2.fromOffset(140, 220)
    Instance_new_111.Position = var_007(0.5, -70, 0.5, -100)
    Instance_new_111.BackgroundTransparency = 1

    local Instance_new_112 = Instance.new("Frame", Instance_new_111)

    Instance_new_112.BackgroundTransparency = 1
    Instance_new_112.BorderSizePixel = 0
    Instance_new_112.Position = UDim2.new(0, -2, 0, -2)
    Instance_new_112.Size = UDim2.new(1, 4, 1, 4)

    local Instance_new_113 = Instance.new("UIStroke", Instance_new_112)

    Instance_new_113.Thickness = 1
    Instance_new_113.LineJoinMode = Enum.LineJoinMode.Miter
    Instance_new_113.Color = Color3.fromRGB(0, 0, 0)

    local Instance_new_114 = Instance.new("Frame", Instance_new_111)

    Instance_new_114.BackgroundTransparency = 1
    Instance_new_114.BorderSizePixel = 0
    Instance_new_114.Position = UDim2.new(0, -1, 0, -1)
    Instance_new_114.Size = UDim2.new(1, 2, 1, 2)

    local Instance_new_115 = Instance.new("UIStroke", Instance_new_114)

    Instance_new_115.Thickness = 1
    Instance_new_115.LineJoinMode = Enum.LineJoinMode.Miter
    Instance_new_115.Color = Color3.fromRGB(255, 255, 255)

    local Instance_new_116 = Instance.new("Frame", Instance_new_111)

    Instance_new_116.BackgroundTransparency = 1
    Instance_new_116.BorderSizePixel = 0
    Instance_new_116.Size = UDim2.new(1, 0, 1, 0)

    local Instance_new_117 = Instance.new("UIStroke", Instance_new_116)

    Instance_new_117.Thickness = 1
    Instance_new_117.LineJoinMode = Enum.LineJoinMode.Miter
    Instance_new_117.Color = Color3.fromRGB(0, 0, 0)

    local Instance_new_118 = Instance.new("Frame", Instance_new_111)

    Instance_new_118.BorderSizePixel = 0
    Instance_new_118.ZIndex = -1
    Instance_new_118.Size = UDim2.new(1, 0, 1, 0)
    Instance_new_118.BackgroundTransparency = 0.5

    local Instance_new_119 = Instance.new("UIGradient", Instance_new_118)

    Instance_new_119.Rotation = 90
    Instance_new_119.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(122, 122, 255)),
    }

    local Instance_new_120 = Instance.new("ImageLabel", Instance_new_111)

    Instance_new_120.BackgroundTransparency = 1
    Instance_new_120.BorderSizePixel = 0
    Instance_new_120.Image = "rbxassetid://110204605000367"
    Instance_new_120.ScaleType = Enum.ScaleType.Slice
    Instance_new_120.SliceCenter = Rect.new(21, 21, 79, 79)
    Instance_new_120.Position = UDim2.new(0, -21, 0, -21)
    Instance_new_120.Size = UDim2.new(1, 42, 1, 42)
    Instance_new_120.ZIndex = -2
    Instance_new_120.ImageTransparency = 0.8

    local Instance_new_121 = Instance.new("UIGradient", Instance_new_120)

    Instance_new_121.Rotation = 90
    Instance_new_121.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(122, 122, 255)),
    }

    local Instance_new_122 = Instance.new("Frame", Instance_new_111)

    Instance_new_122.BackgroundTransparency = 1
    Instance_new_122.BorderSizePixel = 0
    Instance_new_122.Size = UDim2.new(1, 0, 1, 0)
    Instance_new_122.Visible = false

    local var_391 = {}

    for i_5 = 162, 169 do
        local Instance_new_123 = Instance.new("Frame", Instance_new_122)

        Instance_new_123.BorderSizePixel = 0
        Instance_new_123.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local Instance_new_124 = Instance.new("UIStroke", Instance_new_123)

        Instance_new_124.Thickness = 1
        Instance_new_124.Color = Color3.fromRGB(0, 0, 0)
        Instance_new_124.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        Instance_new_124.LineJoinMode = Enum.LineJoinMode.Miter
        var_391[(i_5 - (161))] = {
            Frame = Instance_new_123,
            Stroke = Instance_new_124,
        }
    end

    local Instance_new_125 = Instance.new("Frame", Instance_new_111)

    Instance_new_125.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Instance_new_125.BorderSizePixel = 0
    Instance_new_125.Position = UDim2.new(0, -7, 0, -3)
    Instance_new_125.Size = UDim2.new(0, 3, 1, 6)

    local Instance_new_126 = Instance.new("Frame", Instance_new_125)

    Instance_new_126.BorderSizePixel = 0
    Instance_new_126.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance_new_126.AnchorPoint = Vector2.new(0, 1)
    Instance_new_126.Position = UDim2.new(0, 1, 1, -1)
    Instance_new_126.Size = UDim2.new(0, 1, 0.75, -2)

    local Instance_new_127 = Instance.new("UIGradient", Instance_new_126)

    Instance_new_127.Rotation = 90
    Instance_new_127.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    }

    local Instance_new_128 = Instance.new("ViewportFrame", Instance_new_111)

    Instance_new_128.Size = var_007(1, 0, 1, 0)
    Instance_new_128.BackgroundTransparency = 1
    Instance_new_128.LightColor = fromRGB(255, 255, 255)
    Instance_new_128.LightDirection = var_004(-1, -1, -1)
    Instance_new_128.Ambient = fromRGB(160, 160, 160)

    local Instance_new_129, Instance_new_130 = Instance.new("WorldModel", Instance_new_128), Instance.new("Camera")

    Instance_new_130.FieldOfView = 30
    Instance_new_130.CFrame = var_006(var_004(0, 0, 8.5), var_004(0, 0, 0))
    Instance_new_128.CurrentCamera = Instance_new_130
    Instance_new_130.Parent = Instance_new_128

    local Instance_new_131 = Instance.new("Frame", Instance_new_111)

    Instance_new_131.BackgroundTransparency = 1
    Instance_new_131.BorderSizePixel = 0
    Instance_new_131.Position = UDim2.new(0.5, 0, 0, -5)
    Instance_new_131.AnchorPoint = Vector2.new(0.5, 1)
    Instance_new_131.AutomaticSize = Enum.AutomaticSize.XY
    Instance_new_131.Size = UDim2.new(0, 0, 0, 0)
    Instance.new("UIListLayout", Instance_new_131).HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Instance_new_132 = Instance.new("TextLabel", Instance_new_131)

    Instance_new_132.BackgroundTransparency = 1
    Instance_new_132.BorderSizePixel = 0
    Instance_new_132.AutomaticSize = Enum.AutomaticSize.XY
    Instance_new_132.Size = var_390(0, 0, 0, 0)
    Instance_new_132.Text = "EnemyPlayer"
    Instance_new_132.TextColor3 = Color3.new(1, 1, 1)

    local Instance_new_133 = Instance.new("UIStroke", Instance_new_132)

    Instance_new_133.Thickness = 1
    Instance_new_133.Color = Color3.new(0, 0, 0)
    Instance_new_133.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    Instance_new_133.LineJoinMode = Enum.LineJoinMode.Miter

    local Instance_new_134 = Instance.new("Frame", Instance_new_111)

    Instance_new_134.BackgroundTransparency = 1
    Instance_new_134.BorderSizePixel = 0
    Instance_new_134.Position = UDim2.new(0.5, 0, 1, 5)
    Instance_new_134.AnchorPoint = Vector2.new(0.5, 0)
    Instance_new_134.AutomaticSize = Enum.AutomaticSize.XY
    Instance_new_134.Size = UDim2.new(0, 0, 0, 0)

    local Instance_new_135 = Instance.new("UIListLayout", Instance_new_134)

    Instance_new_135.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Instance_new_136 = Instance.new("TextLabel", Instance_new_134)

    Instance_new_136.BackgroundTransparency = 1
    Instance_new_136.BorderSizePixel = 0
    Instance_new_136.AutomaticSize = Enum.AutomaticSize.XY
    Instance_new_136.Size = var_390(0, 0, 0, 0)
    Instance_new_136.Text = "42 studs"
    Instance_new_136.TextColor3 = Color3.new(1, 1, 1)

    local Instance_new_137 = Instance.new("UIStroke", Instance_new_136)

    Instance_new_137.Thickness = 1
    Instance_new_137.Color = Color3.new(0, 0, 0)
    Instance_new_137.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    Instance_new_137.LineJoinMode = Enum.LineJoinMode.Miter

    local Instance_new_138 = Instance.new("TextLabel", Instance_new_134)

    Instance_new_138.BackgroundTransparency = 1
    Instance_new_138.BorderSizePixel = 0
    Instance_new_138.AutomaticSize = Enum.AutomaticSize.XY
    Instance_new_138.Size = var_390(0, 0, 0, 0)
    Instance_new_138.Text = "AK-47"
    Instance_new_138.TextColor3 = Color3.new(1, 1, 1)

    local Instance_new_139 = Instance.new("UIStroke", Instance_new_138)

    Instance_new_139.Thickness = 1
    Instance_new_139.Color = Color3.new(0, 0, 0)
    Instance_new_139.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    Instance_new_139.LineJoinMode = Enum.LineJoinMode.Miter

    local var_392, var_393 = {
        Char = nil,
        Highlight = nil,
    }, {}

    local function fn_105(arg_164)
        local var_394, var_395 = getgenv().Wyvern_FontLoaded or (shared and shared.Wyvern_FontLoaded), getgenv().Wyvern_MinecraftiaFont or (shared and shared.Wyvern_MinecraftiaFont)

        if not (var_394 and var_395) then
            arg_164.Font = Enum.Font.Code
        else
            arg_164.FontFace = var_395
        end

        arg_164.TextSize = 11
        arg_164.TextScaled = false
    end
    local function fn_106(arg_165)
        if not var_393[arg_165] then
            local Instance_new_140 = Instance.new("Frame")

            Instance_new_140.BorderSizePixel = 0
            Instance_new_140.AnchorPoint = var_005(0.5, 0.5)
            Instance_new_140.ZIndex = 10
            Instance_new_140.Visible = false
            Instance_new_140.Parent = Instance_new_128
            var_393[arg_165] = Instance_new_140
        end

        return var_393[arg_165]
    end
    local function fn_107(arg_166, arg_167, arg_168, arg_169)
        local var_396, Magnitude_4, var_397 = (arg_167 + arg_168) / (2), (arg_168 - arg_167).Magnitude, math.deg(math.atan2(arg_168.Y - arg_167.Y, arg_168.X - arg_167.X))

        arg_166.Position = UDim2.fromOffset(var_396.X, var_396.Y)
        arg_166.Size = UDim2.fromOffset(Magnitude_4, 1.5)
        arg_166.Rotation = var_397
        arg_166.BackgroundColor3 = arg_169
        arg_166.Visible = true
    end
    local function fn_108()
        if not (var_392.Char) then
        else
            pcall(function()
                var_392.Char:Destroy()
            end)

            var_392.Char = nil
        end

        var_392.Highlight = nil

        local Character_5 = LocalPlayer.Character

        if not (var_042.activeTab == "Model Changer") then
        else
            local var_398 = tonumber(var_042.customModelId)

            if var_398 and var_398 > 0 then
                local GetObjects, var_399 = pcall(function()
                    return game:GetObjects("rbxassetid://" .. tostring(var_398))[1]
                end)

                if not GetObjects or not var_399 then
                    GetObjects, var_399 = pcall(function()
                        return game:GetService("InsertService"):LoadLocalAsset("rbxassetid://" .. tostring(var_398))
                    end)
                end
                if GetObjects and var_399 and var_399:IsA("Model") then
                    Character_5 = var_399
                end
            end
        end
        if not (not Character_5) then
        else
            return
        end

        local var_400
        local Clone, var_401 = pcall(function()
            Character_5.Archivable = true
            var_400 = Character_5:Clone()
            Character_5.Archivable = false
        end)

        if not (not Clone or not var_400) then
        else
            warn("[ESP Preview Error] Character clone failed: " .. tostring(var_401))

            return
        end

        local GetDescendants, var_402 = pcall(function()
            return var_400:GetDescendants()
        end)

        if GetDescendants and var_402 then
            for it_201, it_202 in ipairs(var_402)do
                if not (it_202:IsA("Script") or it_202:IsA("LocalScript") or it_202:IsA("Animator") or it_202:IsA("ScreenGui")) then
                    if it_202:IsA("BasePart") then
                        it_202.Anchored = true
                        it_202.CanCollide = false
                        it_202.LocalTransparencyModifier = 0

                        if it_202.Name ~= "HumanoidRootPart" then
                            it_202.Transparency = 0
                        end
                    end
                else
                    pcall(function()
                        it_202:Destroy()
                    end)
                end
            end
        end

        var_400:PivotTo(var_006(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0))

        var_400.Parent = Instance_new_129
        var_392.Char = var_400

        local Instance_new_141 = Instance.new("Highlight")

        Instance_new_141.Name = "PreviewChams"
        Instance_new_141.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Instance_new_141.Parent = var_392.Char
        var_392.Highlight = Instance_new_141
    end
    local function fn_109()
        local var_403, var_404 = var_042.boxes == true and var_042.visualsEnable == true, not var_042.box3d

        Instance_new_111.Visible = var_403
        Instance_new_132.Visible = var_042.nameEsp == true and var_042.visualsEnable == true
        Instance_new_125.Visible = var_042.hpBar == true and var_042.visualsEnable == true
        Instance_new_138.Visible = var_042.weaponEsp == true and var_042.visualsEnable == true
        Instance_new_136.Visible = var_042.distanceEsp == true and var_042.visualsEnable == true
        Instance_new_128.Visible = var_042.visualsEnable == true

        local var_405 = fromRGB(255, 50, 50)

        if var_042.teamColorsAuto then
            var_405 = fromRGB(255, 130, 0)
        end

        Instance_new_115.Color = var_405
        Instance_new_132.TextColor3 = var_405
        Instance_new_112.Visible = var_403 and var_404
        Instance_new_114.Visible = var_403 and var_404
        Instance_new_116.Visible = var_403 and var_404
        Instance_new_118.Visible = var_403 and var_404
        Instance_new_120.Visible = var_403
        Instance_new_122.Visible = var_403 and not var_404

        if var_403 and not var_404 then
            var_391[1].Frame.Size = fromOffset_2(15, 1)
            var_391[1].Frame.Position = fromOffset_2(0, 0)
            var_391[2].Frame.Size = fromOffset_2(1, 15)
            var_391[2].Frame.Position = fromOffset_2(0, 0)
            var_391[3].Frame.Size = fromOffset_2(15, 1)
            var_391[3].Frame.Position = fromOffset_2(125, 0)
            var_391[4].Frame.Size = fromOffset_2(1, 15)
            var_391[4].Frame.Position = fromOffset_2(139, 0)
            var_391[5].Frame.Size = fromOffset_2(15, 1)
            var_391[5].Frame.Position = fromOffset_2(0, 219)
            var_391[6].Frame.Size = fromOffset_2(1, 15)
            var_391[6].Frame.Position = fromOffset_2(0, 205)
            var_391[7].Frame.Size = fromOffset_2(15, 1)
            var_391[7].Frame.Position = fromOffset_2(125, 219)
            var_391[8].Frame.Size = fromOffset_2(1, 15)
            var_391[8].Frame.Position = fromOffset_2(139, 205)

            for it_203, it_204 in ipairs(var_391)do
                it_204.Stroke.Color = Color3.fromRGB(0, 0, 0)
                it_204.Frame.BackgroundColor3 = var_405
            end
        end
        if var_392.Highlight then
            var_392.Highlight.Enabled = var_042.chams == true and var_042.visualsEnable == true
            var_392.Highlight.FillColor = var_405
            var_392.Highlight.OutlineColor = Color3.new(1, 1, 1)
            var_392.Highlight.FillTransparency = 0.5
            var_392.Highlight.OutlineTransparency = 0.2
        end

        fn_105(Instance_new_132)
        fn_105(Instance_new_136)
        fn_105(Instance_new_138)

        if not (not var_042.skeletonEsp) then
        else
            for it_205, it_206 in pairs(var_393)do
                it_206.Visible = false
            end
        end
    end

    local var_406 = {
        "boxes",
        "nameEsp",
        "hpBar",
        "weaponEsp",
        "distanceEsp",
        "teamColorsAuto",
        "chams",
        "skeletonEsp",
        "visualsEnable",
    }

    for it_207, it_208 in ipairs(var_406)do
        fn_011(it_208, fn_109)
    end

    fn_011("activeTab", function(arg_170)
        if not (arg_170 == "Visuals" or arg_170 == "Model Changer") then
            if not (arg_170 == "GunSkins" or arg_170 == "Knives" or arg_170 == "Gloves") then
                Instance_new_108.Visible = false

                if not (var_392.Char) then
                else
                    pcall(function()
                        var_392.Char:Destroy()
                    end)

                    var_392.Char = nil
                end

                var_392.Highlight = nil

                for it_209, it_210 in pairs(var_393)do
                    it_210.Visible = false
                end
            else
                Instance_new_108.Visible = false
            end
        else
            Instance_new_108.Visible = true

            fn_108()
            fn_109()
        end
    end)
    fn_011("customModelId", function()
        if var_042.activeTab == "Model Changer" then
            fn_108()
            fn_109()
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function()
        if var_042.activeTab == "Visuals" then
            wait_2(0.6)
            fn_108()
            fn_109()
        end
    end)
    RunService.Heartbeat:Connect(function()
        if not var_042.menuOpen then
            return
        end
        if not Instance_new_108.Visible or not var_392.Char then
            return
        end
        if var_042.skeletonEsp then
            local var_407 = {}

            if not (var_392.Char:FindFirstChild("UpperTorso")) then
                var_407 = {
                    {
                        "Head",
                        "Torso",
                    },
                    {
                        "Torso",
                        "Left Arm",
                    },
                    {
                        "Torso",
                        "Right Arm",
                    },
                    {
                        "Torso",
                        "Left Leg",
                    },
                    {
                        "Torso",
                        "Right Leg",
                    },
                }
            else
                var_407 = {
                    {
                        "Head",
                        "UpperTorso",
                    },
                    {
                        "UpperTorso",
                        "LowerTorso",
                    },
                    {
                        "UpperTorso",
                        "LeftUpperArm",
                    },
                    {
                        "LeftUpperArm",
                        "LeftLowerArm",
                    },
                    {
                        "UpperTorso",
                        "RightUpperArm",
                    },
                    {
                        "RightUpperArm",
                        "RightLowerArm",
                    },
                    {
                        "LowerTorso",
                        "LeftUpperLeg",
                    },
                    {
                        "LeftUpperLeg",
                        "LeftLowerLeg",
                    },
                    {
                        "LowerTorso",
                        "RightUpperLeg",
                    },
                    {
                        "RightUpperLeg",
                        "RightLowerLeg",
                    },
                }
            end

            local var_408, var_409 = var_042.teamColorsAuto and fromRGB(255, 130, 0) or fromRGB(255, 50, 50), 1

            for it_211, it_212 in ipairs(var_407)do
                local FindFirstChild_35, FindFirstChild_36 = var_392.Char:FindFirstChild(it_212[1]), var_392.Char:FindFirstChild(it_212[2])

                if not (FindFirstChild_35 and FindFirstChild_36) then
                    if var_393[var_409] then
                        var_393[var_409].Visible = false
                    end

                    var_409 = var_409 + (1)
                else
                    local WorldToViewportPoint_12, var_410 = Instance_new_130:WorldToViewportPoint(FindFirstChild_35.Position)
                    local WorldToViewportPoint_13, var_411 = Instance_new_130:WorldToViewportPoint(FindFirstChild_36.Position)

                    if var_410 and var_411 then
                        local var_412 = fn_106(var_409)

                        fn_107(var_412, var_005(WorldToViewportPoint_12.X, WorldToViewportPoint_12.Y), var_005(WorldToViewportPoint_13.X, WorldToViewportPoint_13.Y), var_408)

                        var_409 = var_409 + 1
                    else
                        if not (var_393[var_409]) then
                        else
                            var_393[var_409].Visible = false
                        end

                        var_409 = var_409 + (1)
                    end
                end
            end

            for i_6 = var_409, #var_393 do
                if var_393[i_6] then
                    var_393[i_6].Visible = false
                end
            end
        end
    end)
end

fn_104()

local function fn_110()
    local var_413, var_414, var_415 = {}, {}, {
        "Circle",
        "Handle",
        "Plane",
        "pin",
    }

    local function fn_111(arg_171)
        local var_416 = lower(arg_171.Name)

        if find_2(var_416, "_weapon") or find_2(var_416, "attachment") then
            return true
        end

        return false
    end
    local function fn_112(arg_172)
        if not (fn_111(arg_172)) then
        else
            return false
        end

        local FindFirstChild_37 = arg_172:FindFirstChild("Weapon")

        if not (not FindFirstChild_37) then
        else
            return false
        end

        local var_417 = {}

        for it_213, it_214 in ipairs(var_415)do
            var_417[it_214] = (FindFirstChild_37:FindFirstChild(it_214) ~= nil)
        end

        return var_417["Circle"] and var_417["pin"] and var_417["Plane"]
    end
    local function fn_113(arg_173, arg_174, arg_175, arg_176, arg_177)
        local var_418, Magnitude_5, var_419 = (arg_174 + arg_175) / (2), (arg_175 - arg_174).Magnitude, math.deg(math.atan2(arg_175.Y - arg_174.Y, arg_175.X - arg_174.X))

        arg_173.Position = UDim2.fromOffset(var_418.X, var_418.Y)
        arg_173.Size = UDim2.fromOffset(Magnitude_5, arg_176)
        arg_173.Rotation = var_419
        arg_173.BackgroundColor3 = arg_177
        arg_173.Visible = true
    end
    local function fn_114(arg_178)
        if not var_413[arg_178] then
            local var_420 = {
                points = {},
                lines = {},
            }

            for i_7 = 135, 173 do
                local Instance_new_142 = Instance.new("Frame")

                Instance_new_142.BorderSizePixel = 0
                Instance_new_142.AnchorPoint = var_005(0.5, 0.5)
                Instance_new_142.Visible = false
                Instance_new_142.Parent = Instance_new

                table.insert(var_420.lines, Instance_new_142)
            end

            var_413[arg_178] = var_420
        end

        return var_413[arg_178]
    end
    local function fn_115(arg_179)
        if not var_414[arg_179] then
            local Instance_new_143 = Instance.new("TextLabel")

            Instance_new_143.BackgroundTransparency = 1
            Instance_new_143.Font = Enum.Font.GothamBold
            Instance_new_143.TextSize = 11
            Instance_new_143.TextStrokeTransparency = 0
            Instance_new_143.TextStrokeColor3 = fromRGB(0, 0, 0)
            Instance_new_143.Visible = false
            Instance_new_143.Parent = Instance_new
            var_414[arg_179] = Instance_new_143
        end

        return var_414[arg_179]
    end
    local function fn_116(arg_180)
        if var_413[arg_180] then
            for it_215, it_216 in ipairs(var_413[arg_180].lines)do
                pcall(function()
                    it_216:Destroy()
                end)
            end

            var_413[arg_180] = nil
        end
        if not (var_414[arg_180]) then
        else
            pcall(function()
                var_414[arg_180]:Destroy()
            end)

            var_414[arg_180] = nil
        end
    end

    local WaitForChild_4 = Workspace:WaitForChild("Debris", 10)

    if WaitForChild_4 then
        WaitForChild_4.ChildRemoved:Connect(fn_116)
    end

    local ReplicatedStorage = 0

    RunService.RenderStepped:Connect(function()
        if not (not WaitForChild_4) then
        else
            return
        end

        local Character_6 = LocalPlayer.Character
        local FindFirstChild_38 = Character_6 and Character_6:FindFirstChild("HumanoidRootPart")
        local var_421 = FindFirstChild_38 and FindFirstChild_38.Position or Vector3.zero

        ReplicatedStorage = ReplicatedStorage + 1

        local var_422 = (ReplicatedStorage % (2) == 0)

        for it_217, it_218 in ipairs(WaitForChild_4:GetChildren())do
            if fn_112(it_218) then
                local FindFirstChild_39 = it_218:FindFirstChild("Weapon")
                local FindFirstChild_40 = FindFirstChild_39 and (FindFirstChild_39:FindFirstChild("Handle") or FindFirstChild_39:FindFirstChild("RootPart") or FindFirstChild_39:FindFirstChildWhichIsA("BasePart"))

                if not (FindFirstChild_40) then
                else
                    local WorldToViewportPoint_14, var_423 = CurrentCamera:WorldToViewportPoint(FindFirstChild_40.Position)
                    local var_424 = fn_115(it_218)

                    if var_042.c4Esp and var_042.visualsEnable and var_423 then
                        local var_425 = floor((FindFirstChild_40.Position - var_421).Magnitude / (3))

                        var_424.Text = "Bomb [" .. var_425 .. "m]"
                        var_424.TextColor3 = fromRGB(255, 50, 50)
                        var_424.Position = UDim2.fromOffset(WorldToViewportPoint_14.X, WorldToViewportPoint_14.Y - (22))
                        var_424.Visible = true
                    else
                        var_424.Visible = false
                    end
                    if not (var_042.bombTrail2d) then
                        if var_413[it_218] then
                            for it_219, it_220 in ipairs(var_413[it_218].lines)do
                                it_220.Visible = false
                            end
                        end
                    else
                        local var_426, Position_6 = fn_114(it_218), FindFirstChild_40.Position

                        if not (var_422) then
                        else
                            if #var_426.points == 0 or (var_426.points[#var_426.points] - Position_6).Magnitude > 0.5 then
                                table.insert(var_426.points, Position_6)

                                if not (#var_426.points > 40) then
                                else
                                    table.remove(var_426.points, 1)
                                end
                            end
                        end

                        local var_427 = fromRGB(255, 50, 50)

                        for i_8 = 246, (#var_426.lines) + (245)do
                            local var_428 = var_426.lines[(i_8 - 245)]

                            if not ((i_8 - 245) < #var_426.points) then
                                var_428.Visible = false
                            else
                                local WorldToViewportPoint_15, var_429 = CurrentCamera:WorldToViewportPoint(var_426.points[(i_8 - (245))])
                                local WorldToViewportPoint_16, var_430 = CurrentCamera:WorldToViewportPoint(var_426.points[(i_8 - 245) + (1)])

                                if not (var_429 and var_430) then
                                    var_428.Visible = false
                                else
                                    fn_113(var_428, var_005(WorldToViewportPoint_15.X, WorldToViewportPoint_15.Y), var_005(WorldToViewportPoint_16.X, WorldToViewportPoint_16.Y), 2, var_427)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

fn_110()
spawn_2(function()
    local ReplicatedStorage_2 = game:GetService("ReplicatedStorage")

    local function fn_117(arg_181)
        local var_431 = tick()

        while tick() - var_431 < 15 do
            local GetDescendants_2, var_432 = pcall(function()
                for it_221, it_222 in ipairs(ReplicatedStorage_2:GetDescendants())do
                    if not (it_222:IsA("ModuleScript") and it_222.Name == arg_181) then
                    else
                        local var_433, var_434 = pcall(require, it_222)

                        if not (var_433 and type(var_434) == "table") then
                        else
                            return var_434
                        end
                    end
                end
            end)

            if GetDescendants_2 and var_432 then
                return var_432
            end

            wait_2(2)
        end

        return nil
    end

    local var_435 = fn_117("Skins")

    if not (not var_435 or type(var_435.GetGloves) ~= "function") then
    else
        print("[Dedektif] Glove Changer iptal: Skins modülü bulunamadı veya yetki yok.")

        return
    end

    local z, var_436 = pcall(function()
        if setreadonly then
            pcall(setreadonly, var_435, false)
        end

        local var_437 = var_435.GetGloves

        var_435.GetGloves = function(...)
            local var_438 = {...}
            local var_439, var_440, var_441 = type(var_438[1]) == "table" and 2 or 1, var_042.selectedGlove or "Sports Gloves", var_042.selectedGloveSkin or "Imperial"

            if not (var_441 == '' or var_441 == "Vanilla" or var_441 == "Stock") then
            else
                var_441 = "Imperial"
            end

            var_438[var_439] = var_440
            var_438[var_439 + 1] = var_441

            return var_437(unpack(var_438))
        end

        if not (setreadonly) then
        else
            pcall(setreadonly, var_435, true)
        end
    end)

    if z then
        warn("[Wyvern] active")
    else
        warn("[Wyvern] use better exc pls:", var_436)
    end
end)

local var_442, var_443, var_444 = setmetatable({}, {
    __mode = "k",
}), setmetatable({}, {
    __mode = "k",
}), 0

local function fn_118()
    local var_445 = os.clock()

    if not ((var_445 - var_444) > 10) then
    else
        var_444 = var_445

        local var_446 = getgc or (debug and debug.getgc)

        if var_446 then
            local var_447 = var_446(true)

            for i_9 = 96, (#var_447) + 95 do
                local var_448 = var_447[(i_9 - (95))]

                if type(var_448) == "table" then
                    local var_449 = rawget(var_448, "FireRate")

                    if not (var_449 and type(var_449) == "number") then
                    else
                        var_443[var_448] = true
                    end
                end
            end
        end
    end

    return var_443
end

spawn_2(function()
    while wait_2(3) do
        if not (var_042.rapidFire or var_042.rageMode) then
            pcall(function()
                for it_223, it_224 in pairs(var_442)do
                    local var_450 = rawget(it_223, "FireRate")

                    if var_450 and type(var_450) == "number" and var_450 < 5E-2 then
                        if setreadonly then
                            pcall(setreadonly, it_223, false)
                        end

                        pcall(function()
                            rawset(it_223, "FireRate", it_224)
                        end)

                        if not (setreadonly) then
                        else
                            pcall(setreadonly, it_223, true)
                        end
                    end
                end
            end)
        else
            pcall(function()
                local var_451 = fn_118()

                for it_225 in pairs(var_451)do
                    local var_452 = rawget(it_225, "FireRate")

                    if var_452 and type(var_452) == "number" and var_452 > 5E-2 then
                        if not (not var_442[it_225]) then
                        else
                            var_442[it_225] = var_452
                        end
                        if setreadonly then
                            pcall(setreadonly, it_225, false)
                        end

                        pcall(function()
                            local var_453 = (tonumber(var_042.rapidFireDelay) or 50) / (1E3)

                            rawset(it_225, "FireRate", math.max(var_453, 1E-3))

                            if not (rawget(it_225, "Auto") ~= nil) then
                            else
                                rawset(it_225, "Auto", true)
                            end
                        end)

                        if not (setreadonly) then
                        else
                            pcall(setreadonly, it_225, true)
                        end
                    end
                end
            end)
        end
    end
end)

local var_454, var_455, var_456, var_457, var_458, var_459 = getgc or (debug and debug.getgc), getinfo or (debug and debug.getinfo), getupvalues or (debug and debug.getupvalues), setupvalue or (debug and debug.setupvalue), {}, 0

local function fn_119()
    local var_460 = os.clock()

    if not (#var_458 == 0 or (var_460 - var_459) > 10) then
    else
        var_458 = {}
        var_459 = var_460

        if not (var_454 and var_455) then
        else
            local var_461 = var_454()

            for i_10 = 10, (#var_461) + (9)do
                local var_462 = var_461[(i_10 - 9)]

                if type(var_462) == "function" then
                    local var_463 = var_455(var_462)
                    local g = var_463 and var_463.source

                    if g and string.find(g, "GunClient") then
                        table.insert(var_458, {
                            func = var_462,
                            source = g,
                        })
                    end
                end
            end
        end
    end

    return var_458
end
local function fn_120(arg_182)
    if not (not var_454 or not var_456 or not var_457 or not var_455) then
    else
        return
    end

    local Name_2 = arg_182 and arg_182.Name

    if not Name_2 then
        return
    end

    task.spawn(function()
        task.wait(0.2)

        local var_464 = fn_119()

        for it_226, it_227 in ipairs(var_464)do
            local func, source = it_227.func, it_227.source

            if string.find(source, Name_2) then
                for it_228, it_229 in ipairs(var_456(func))do
                    if not (type(it_229) == "number" and it_229 < 10) then
                    else
                        var_457(func, it_228, 0)
                    end
                end
            end
        end
    end)
end

local var_465 = false

local function fn_121()
    if var_465 then
        return
    end

    var_465 = true

    spawn_2(function()
        local Players_5, Workspace_3, RunService_3, ReplicatedStorage_3 = game:GetService("Players"), game:GetService("Workspace"), game:GetService("RunService"), game:GetService("ReplicatedStorage")
        local LocalPlayer_3, CurrentCamera_3, var_466, var_467 = Players_5.LocalPlayer, Workspace_3.CurrentCamera, hookfunction or (getgenv and getgenv().hookfunction), newcclosure or (getgenv and getgenv().newcclosure) or function(arg_183)
            return arg_183
        end

        if not var_466 then
            warn("[Wyvern] Executor does not support hookfunction. Silent Aim cannot work.")

            return
        end

        local var_468

        pcall(function()
            var_468 = require(ReplicatedStorage_3.Controllers.InventoryController)
        end)

        if not var_468 then
            return
        end

        local function fn_122(arg_184)
            return arg_184:GetAttribute("Team")
        end
        local function fn_123(arg_185)
            if not (arg_185 == LocalPlayer_3) then
            else
                return false
            end
            if not arg_185.Character then
                return false
            end

            local FindFirstChild_41 = arg_185.Character:FindFirstChild("HumanoidRootPart")

            if not (not FindFirstChild_41) then
            else
                return false
            end

            local FindFirstChildOfClass_12 = arg_185.Character:FindFirstChildOfClass("Humanoid")

            if not FindFirstChildOfClass_12 or FindFirstChildOfClass_12.Health <= 0 then
                return false
            end
            if arg_185.Character:GetAttribute("Invincible") == true then
                return false
            end
            if not (var_042.teamCheck) then
            else
                local var_469, var_470 = fn_122(LocalPlayer_3), fn_122(arg_185)

                if not (var_469 and var_470 and var_469 == var_470) then
                else
                    return false
                end
            end

            return true
        end
        local function fn_124(arg_186)
            local targetPart_3 = var_042.targetPart

            if targetPart_3 == "Random Part" then
                targetPart_3 = "Head"
            end

            return arg_186:FindFirstChild(targetPart_3) or arg_186:FindFirstChild("Head") or arg_186:FindFirstChild("HumanoidRootPart") or arg_186.PrimaryPart
        end
        local function fn_125()
            return tonumber(var_042.fovSize) or 150
        end
        local function fn_126()
            local var_471 = {}

            if not (LocalPlayer_3.Character) then
            else
                table.insert(var_471, LocalPlayer_3.Character)
            end

            table.insert(var_471, CurrentCamera_3)

            local FindFirstChild_42 = Workspace_3:FindFirstChild("Debris")

            if FindFirstChild_42 then
                table.insert(var_471, FindFirstChild_42)
            end

            local FindFirstChild_43 = Workspace_3:FindFirstChild("Map")

            if FindFirstChild_43 then
                for it_230, it_231 in ipairs{
                    "Cameras",
                    "Barriers",
                    "Ambience",
                }do
                    local FindFirstChild_44 = FindFirstChild_43:FindFirstChild(it_231)

                    if FindFirstChild_44 then
                        table.insert(var_471, FindFirstChild_44)
                    end
                end

                local FindFirstChild_45 = FindFirstChild_43:FindFirstChild("Zones")

                if not (FindFirstChild_45) then
                else
                    for it_232, it_233 in ipairs{
                        "Spawns",
                        "Sites",
                    }do
                        local FindFirstChild_46 = FindFirstChild_45:FindFirstChild(it_233)

                        if not (FindFirstChild_46) then
                        else
                            table.insert(var_471, FindFirstChild_46)
                        end
                    end
                end
            end

            return var_471
        end
        local function fn_127(arg_187, arg_188, arg_189, arg_190)
            local var_472 = table.clone(arg_189)

            table.insert(var_472, arg_190)

            local RaycastParams_new_2 = RaycastParams.new()

            RaycastParams_new_2.FilterType = Enum.RaycastFilterType.Exclude
            RaycastParams_new_2.CollisionGroup = "Bullet"
            RaycastParams_new_2.IgnoreWater = true
            RaycastParams_new_2.FilterDescendantsInstances = var_472

            local Raycast_2 = Workspace_3:Raycast(arg_187, arg_188 - arg_187, RaycastParams_new_2)

            return Raycast_2 == nil
        end
        local function fn_128()
            local var_473 = {}

            for it_234, it_235 in ipairs(Players_5:GetPlayers())do
                if fn_123(it_235) and it_235.Character then
                    table.insert(var_473, it_235.Character)
                end
            end

            return var_473
        end
        local function fn_129()
            CurrentCamera_3 = Workspace_3.CurrentCamera

            local var_474, huge_11, Position_7, var_475, var_476, var_477 = nil, math.huge, CurrentCamera_3.CFrame.Position, var_005(CurrentCamera_3.ViewportSize.X / (2), CurrentCamera_3.ViewportSize.Y / (2)), fn_125(), fn_126()

            for it_236, it_237 in ipairs(Players_5:GetPlayers())do
                if not (not fn_123(it_237)) then
                else
                    continue
                end

                local Character_7 = it_237.Character
                local var_478 = fn_124(Character_7)

                if not (not var_478) then
                else
                    continue
                end

                local Position_8 = var_478.Position

                if not (var_042.fullFov360) then
                    local WorldToViewportPoint_17, var_479 = CurrentCamera_3:WorldToViewportPoint(Position_8)

                    if not (not var_479) then
                    else
                        continue
                    end

                    local var_480 = var_005(WorldToViewportPoint_17.X, WorldToViewportPoint_17.Y)
                    local Magnitude_6 = (var_480 - var_475).Magnitude

                    if Magnitude_6 > var_476 then
                        continue
                    end
                    if not var_042.wallbang and var_042.aimWallCheck and not fn_127(Position_7, Position_8, var_477, Character_7) then
                        continue
                    end
                    if Magnitude_6 < huge_11 then
                        huge_11 = Magnitude_6
                        var_474 = {
                            p = it_237,
                            ch = Character_7,
                            pos = Position_8,
                        }
                    end
                else
                    local Magnitude_7 = (Position_8 - Position_7).Magnitude

                    if Magnitude_7 < huge_11 then
                        huge_11 = Magnitude_7
                        var_474 = {
                            p = it_237,
                            ch = Character_7,
                            pos = Position_8,
                        }
                    end
                end
            end

            return var_474
        end
        local function fn_130(arg_191, arg_192)
            CurrentCamera_3 = Workspace_3.CurrentCamera

            local Position_9 = CurrentCamera_3.CFrame.Position
            local Unit, var_481 = (arg_192.pos - Position_9).Unit, 500

            pcall(function()
                if not (type(arg_191) == "table" and type(arg_191.Properties) == "table") then
                    if type(arg_191) == "table" and type(arg_191.Range) == "number" then
                        var_481 = arg_191.Range
                    end
                else
                    var_481 = tonumber(arg_191.Properties.Range) or 500
                end
            end)

            local RaycastParams_new_3 = RaycastParams.new()

            RaycastParams_new_3.IgnoreWater = false

            if not (var_042.wallbang) then
                RaycastParams_new_3.FilterType = Enum.RaycastFilterType.Exclude
                RaycastParams_new_3.CollisionGroup = "Bullet"
                RaycastParams_new_3.FilterDescendantsInstances = fn_126()
            else
                RaycastParams_new_3.FilterType = Enum.RaycastFilterType.Include
                RaycastParams_new_3.FilterDescendantsInstances = fn_128()
            end

            local Magnitude_8 = (arg_192.pos - Position_9).Magnitude
            local Raycast_3 = Workspace_3:Raycast(Position_9, Unit * math.max(var_481, Magnitude_8 + 10), RaycastParams_new_3)
            local var_482, FindFirstChild_47, var_483, var_484 = Raycast_3 and Raycast_3.Position or arg_192.pos, Raycast_3 and Raycast_3.Instance or arg_192.ch:FindFirstChild(var_042.targetBone or "Head"), Raycast_3 and Raycast_3.Material.Name or "Plastic", Raycast_3 and Raycast_3.Normal or Vector3.new(0, 1, 0)

            return {
                Origin = Position_9,
                Direction = Unit,
                Hits = {
                    {
                        Position = var_482,
                        Instance = FindFirstChild_47,
                        Material = var_483,
                        Normal = var_484,
                        Exit = false,
                    },
                },
                Distance = (var_482 - Position_9).Magnitude,
            }
        end

        local var_485 = {}

        local function fn_131(arg_193)
            if type(arg_193) ~= "table" or not arg_193.Bullet then
                return
            end
            if not (type(arg_193.Bullet._performRaycast) ~= "function") then
            else
                return
            end
            if not (var_485[arg_193]) then
            else
                return
            end

            var_485[arg_193] = true

            local var_486

            var_486 = var_466(arg_193.Bullet._performRaycast, var_467(function(arg_194, arg_195)
                local var_487 = arg_195

                if var_042.noSpread then
                    if type(arg_195) == "number" then
                        var_487 = 0
                    elseif typeof(arg_195) == "Vector3" then
                        var_487 = Vector3.zero
                    elseif typeof(arg_195) == "Vector2" then
                        var_487 = Vector2.zero
                    end
                end
                if not var_042.silentAim then
                    local var_488, var_489 = pcall(var_486, arg_194, var_487)

                    if var_488 and type(var_489) == "table" then
                        if not (var_042.hitsoundEnable and var_489.Hits and #var_489.Hits > 0) then
                        else
                            spawn_2(function()
                                pcall(function()
                                    local var_490, SoundService_3 = (var_042.hitsoundCustomId ~= '' and var_042.hitsoundCustomId) or var_042.hitsoundSelectedId or "9120386436", Instance.new("Sound")

                                    SoundService_3.SoundId = "rbxassetid://" .. tostring(var_490)
                                    SoundService_3.Volume = (tonumber(var_042.hitsoundVolume) or 80) / (100)
                                    SoundService_3.RollOffMaxDistance = 0
                                    SoundService_3.Parent = game:GetService("SoundService")

                                    SoundService_3:Play()
                                    delay_2(2, function()
                                        pcall(function()
                                            SoundService_3:Destroy()
                                        end)
                                    end)
                                end)
                            end)
                        end

                        return var_489
                    end

                    return var_486(arg_194, var_487)
                end

                local var_491, var_492 = pcall(var_486, arg_194, var_487)

                if not var_491 or type(var_492) ~= "table" then
                    return var_486(arg_194, var_487)
                end

                local var_493 = tonumber(var_042.baseHitChance) or 100

                if not (var_042.dynamicMiss) then
                else
                    local Character_8 = LocalPlayer_3.Character
                    local FindFirstChild_48 = Character_8 and Character_8:FindFirstChild("HumanoidRootPart")

                    if FindFirstChild_48 then
                        local Magnitude_9 = FindFirstChild_48.AssemblyLinearVelocity.Magnitude
                        local var_494 = clamp(Magnitude_9 * (0.8), 0, 40)

                        var_493 = clamp(var_493 - var_494, 10, 100)
                    end
                end
                if random(1, 100) > var_493 then
                    return var_492
                end

                local var_495 = fn_129()

                if not var_495 then
                    return var_492
                end

                local var_496 = fn_130(arg_194, var_495)

                if not (var_496 and var_496.Hits) then
                else
                    if not (var_042.hitsoundEnable) then
                    else
                        spawn_2(function()
                            pcall(function()
                                local var_497, SoundService_4 = (var_042.hitsoundCustomId ~= '' and var_042.hitsoundCustomId) or var_042.hitsoundSelectedId or "9120386436", Instance.new("Sound")

                                SoundService_4.SoundId = "rbxassetid://" .. tostring(var_497)
                                SoundService_4.Volume = (tonumber(var_042.hitsoundVolume) or 80) / (100)
                                SoundService_4.RollOffMaxDistance = 0
                                SoundService_4.Parent = game:GetService("SoundService")

                                SoundService_4:Play()
                                delay_2(2, function()
                                    pcall(function()
                                        SoundService_4:Destroy()
                                    end)
                                end)
                            end)
                        end)
                    end

                    return var_496
                end

                return var_492
            end))
        end

        if not (var_468.getCurrentEquipped) then
        else
            pcall(function()
                local var_498 = var_468.getCurrentEquipped()

                fn_131(var_498)

                if var_042.instaEquip then
                    local FindFirstChildWhichIsA_7 = LocalPlayer_3.Character and LocalPlayer_3.Character:FindFirstChildWhichIsA("Tool")

                    if FindFirstChildWhichIsA_7 then
                        fn_120(FindFirstChildWhichIsA_7)
                    end
                end
            end)
        end
        if not (var_468.OnInventoryItemEquipped) then
        else
            var_468.OnInventoryItemEquipped:Connect(function(arg_196, arg_197)
                fn_131(arg_197)

                if not (var_042.instaEquip) then
                else
                    local FindFirstChildWhichIsA_8 = LocalPlayer_3.Character and LocalPlayer_3.Character:FindFirstChildWhichIsA("Tool")

                    if FindFirstChildWhichIsA_8 then
                        fn_120(FindFirstChildWhichIsA_8)
                    end
                end
            end)
        end
    end)
end

if var_015 then
    fn_121()
else
    fn_011("forceSilentAim", function(arg_198)
        if not (arg_198 == true) then
        else
            fn_121()
        end
    end)
end

spawn_2(function()
    local var_499 = {}

    local function fn_132()
        local ReplicatedStorage_4 = game:GetService("ReplicatedStorage"):FindFirstChild("Weapons")

        if not ReplicatedStorage_4 then
            return
        end

        for it_238, it_239 in ipairs(ReplicatedStorage_4:GetChildren())do
            if not (it_239:IsA("ModuleScript")) then
            else
                local var_500, var_501 = pcall(require, it_239)

                if not (var_500 and type(var_501) == "table") then
                else
                    if not var_499[it_239.Name] then
                        var_499[it_239.Name] = {
                            ReloadTime = var_501.ReloadTime,
                            RecoilControl = var_501.RecoilControl,
                            MaxSpread = var_501.MaxSpread,
                            FireRate = var_501.FireRate,
                            Auto = var_501.Auto,
                            EquipTime = var_501.EquipTime,
                        }
                    end

                    local var_502 = var_499[it_239.Name]

                    if var_042.instantReload then
                        var_501.ReloadTime = 0
                    else
                        var_501.ReloadTime = var_502.ReloadTime
                    end
                    if not (var_042.memoryNoRecoil) then
                        var_501.RecoilControl = var_502.RecoilControl
                    else
                        var_501.RecoilControl = 0
                    end
                    if not (var_042.noSpread) then
                        var_501.MaxSpread = var_502.MaxSpread
                    else
                        var_501.MaxSpread = 0
                    end
                    if var_042.rapidFire then
                        local FireRateend = (tonumber(var_042.rapidFireDelay) or 50) / (1E3)

                        var_501.FireRate = math.max(FireRateend, 1E-3)
                    else
                        var_501.FireRate = var_502.FireRate
                    end
                    if var_042.instaEquip then
                        var_501.EquipTime = 0
                    else
                        var_501.EquipTime = var_502.EquipTime
                    end
                    if var_042.autoClicker then
                        var_501.Auto = true
                    else
                        var_501.Auto = var_502.Auto
                    end
                end
            end
        end

        if var_042.instaEquip then
            local FindFirstChildWhichIsA_9 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")

            if FindFirstChildWhichIsA_9 then
                fn_120(FindFirstChildWhichIsA_9)
            end
        end
    end

    local var_503 = {
        "instantReload",
        "memoryNoRecoil",
        "noSpread",
        "rapidFire",
        "rapidFireDelay",
        "instaEquip",
        "autoClicker",
        "hitsoundEnable",
        "hitsoundSelectedId",
        "hitsoundVolume",
        "hitsoundCustomId",
    }

    for io, it_240 in ipairs(var_503)do
        fn_011(it_240, fn_132)
    end

    spawn_2(function()
        while wait_2(2) do
            fn_132()
        end
    end)
end)
spawn_2(function()
    local ReplicatedStorage_5, Players_6 = game:GetService("ReplicatedStorage"), game:GetService("Players").LocalPlayer

    local function fn_133(arg_199)
        local StarterPlayer = {
            ReplicatedStorage_5,
            Players_6 and Players_6:FindFirstChild("PlayerScripts"),
            game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts"),
        }

        for it_241, it_242 in ipairs(StarterPlayer)do
            if it_242 then
                for h, it_243 in pairs(it_242:GetDescendants())do
                    if not (it_243:IsA("ModuleScript") and it_243.Name == arg_199) then
                    else
                        local var_504, var_505 = pcall(function()
                            return require(it_243)
                        end)

                        if var_504 and type(var_505) == "table" then
                            return var_505
                        end
                    end
                end
            end
        end

        return nil
    end

    local var_506, var_507, var_508 = fn_133("Skins"), fn_133("Viewmodel"), hookfunction or replaceclosure

    if not (not var_506 or not var_507 or not var_508) then
    else
        return
    end

    local var_509 = {
        "CT Knife",
        "T Knife",
        "Knife",
        "BaseKnife",
        "Melee",
    }

    local function fn_134(arg_200)
        for it_244, it_245 in ipairs(var_509)do
            if not (arg_200 == it_245) then
            else
                return true
            end
        end

        return false
    end

    if setreadonly then
        setreadonly(var_506, false)
    end
    if not (setreadonly) then
    else
        setreadonly(var_507, false)
    end

    local var_510

    var_510 = var_508(var_506.GetCameraModel, function(...)
        local var_511 = {...}
        local var_512 = type(var_511[1]) == "table" and 2 or 1

        if not (type(var_511[var_512]) == "string") then
        else
            if fn_134(var_511[var_512]) then
                var_511[var_512] = var_042.selectedKnife or "Karambit"

                local var_513 = var_042.selectedKnifeSkin or "Vanilla"

                var_511[var_512 + 1] = var_513 == '' and "Vanilla" or var_513
            elseif not (var_042.selectedGun and var_511[var_512] == var_042.selectedGun) then
            else
                var_511[var_512 + 1] = var_042.selectedGunSkin or "Stock"
            end
        end

        return var_510(unpack(var_511))
    end)

    local var_514

    var_514 = var_508(var_506.GetCharacterModel, function(...)
        local var_515 = {...}
        local var_516 = type(var_515[1]) == "table" and 2 or 1

        if type(var_515[var_516]) == "string" then
            if fn_134(var_515[var_516]) then
                var_515[var_516] = var_042.selectedKnife or "Karambit"

                local var_517 = var_042.selectedKnifeSkin or "Vanilla"

                var_515[var_516 + 1] = var_517 == '' and "Vanilla" or var_517
            elseif var_042.selectedGun and var_515[var_516] == var_042.selectedGun then
                var_515[var_516 + 1] = var_042.selectedGunSkin or "Stock"
            end
        end

        return var_514(unpack(var_515))
    end)

    local var_518

    var_518 = var_508(var_507.new, function(...)
        local var_519, var_520 = {...}, 2

        if type(var_519[1]) == "string" and fn_134(var_519[1]) then
            var_520 = 1
        end
        if not (type(var_519[2]) == "string" and fn_134(var_519[2])) then
        else
            var_520 = 2
        end
        if type(var_519[var_520]) == "string" then
            if fn_134(var_519[var_520]) then
                var_519[var_520] = var_042.selectedKnife or "Karambit"

                local var_521 = var_042.selectedKnifeSkin or "Vanilla"

                var_519[var_520 + (1)] = var_521 == '' and "Vanilla" or var_521
            elseif not (var_042.selectedGun and var_519[var_520] == var_042.selectedGun) then
            else
                var_519[var_520 + (1)] = var_042.selectedGunSkin or "Stock"
            end
        end

        return var_518(unpack(var_519))
    end)

    local var_522

    var_522 = var_508(var_506.GetGloves, function(...)
        local var_523 = {...}
        local var_524 = type(var_523[1]) == "table" and 2 or 1

        var_523[var_524] = var_042.selectedGlove or "Sports Gloves"

        local var_525 = var_042.selectedGloveSkin or "Imperial"

        var_523[var_524 + 1] = var_525 == '' and "Imperial" or var_525

        return var_522(unpack(var_523))
    end)

    if setreadonly then
        setreadonly(var_506, true)
    end
    if setreadonly then
        setreadonly(var_507, true)
    end
end)

do
    local function fn_135(arg_201)
        if not (not arg_201) then
        else
            return
        end
        if arg_201:GetAttribute("WyvernHooked") then
            return
        end

        arg_201:SetAttribute("WyvernHooked", true)
        arg_201.AnimationPlayed:Connect(function(arg_202)
            local Animation = arg_202.Animation

            if not (not Animation) then
            else
                return
            end

            local var_526, var_527 = lower(Animation.Name or ''), lower(Animation.AnimationId or '')

            local function fn_136()
                if var_042.instantReload and (find_2(var_526, "reload") or find_2(var_527, "reload")) then
                    arg_202:AdjustSpeed(100)
                elseif not (var_042.instaEquip and (find_2(var_526, "equip") or find_2(var_526, "draw") or find_2(var_527, "equip") or find_2(var_527, "draw"))) then
                else
                    arg_202:AdjustSpeed(100)
                end
            end

            arg_202:GetPropertyChangedSignal("Speed"):Connect(fn_136)
            fn_136()
        end)
    end
    local function fn_137(arg_203)
        if not (not arg_203) then
        else
            return
        end

        for it_246, it_247 in ipairs(arg_203:GetDescendants())do
            if it_247:IsA("Animator") then
                fn_135(it_247)
            end
        end

        arg_203.DescendantAdded:Connect(function(arg_204)
            if arg_204:IsA("Animator") then
                fn_135(arg_204)
            end
        end)
    end

    if LocalPlayer.Character then
        task.spawn(fn_137, LocalPlayer.Character)
    end

    LocalPlayer.CharacterAdded:Connect(fn_137)
    task.spawn(fn_137, Workspace.CurrentCamera)
    Workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
        pcall(fn_137, Workspace.CurrentCamera)
    end)
end

if Drawing then
    local Drawing_new = Drawing.new("Circle")

    Drawing_new.Visible = false
    Drawing_new.Color = fromRGB(255, 63, 146)
    Drawing_new.Thickness = 1.2
    Drawing_new.Transparency = 0.8
    Drawing_new.NumSides = 64
    Drawing_new.Filled = false

    local Drawing_new_2 = Drawing.new("Circle")

    Drawing_new_2.Visible = false
    Drawing_new_2.Color = fromRGB(255, 140, 190)
    Drawing_new_2.Thickness = 1
    Drawing_new_2.Transparency = 0.6
    Drawing_new_2.NumSides = 64
    Drawing_new_2.Filled = false

    local RunService_4, Workspace_4 = game:GetService("RunService"), game:GetService("Workspace")

    RunService_4.RenderStepped:Connect(function()
        local CurrentCamera_4 = Workspace_4.CurrentCamera

        if not CurrentCamera_4 then
            return
        end

        local var_528 = var_005(CurrentCamera_4.ViewportSize.X / (2), CurrentCamera_4.ViewportSize.Y / (2))

        if var_042.silentAim and var_042.showFovCircle then
            Drawing_new.Visible = true
            Drawing_new.Position = var_528
            Drawing_new.Radius = tonumber(var_042.fovSize) or 150
        else
            Drawing_new.Visible = false
        end
        if var_042.aimlock then
            Drawing_new_2.Visible = true
            Drawing_new_2.Position = var_528
            Drawing_new_2.Radius = tonumber(var_042.aimlockFov) or 150
        else
            Drawing_new_2.Visible = false
        end
    end)
end

local MouseEnabled = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

if MouseEnabled then
    local Instance_new_144 = Instance.new("TextButton")

    Instance_new_144.Size = UDim2.fromOffset(24, 24)
    Instance_new_144.Position = var_007(1, -34, 0, 13)
    Instance_new_144.BackgroundTransparency = 1
    Instance_new_144.Text = "X"
    Instance_new_144.TextColor3 = var_016.Text
    Instance_new_144.Font = Enum.Font.GothamBold
    Instance_new_144.TextSize = 14
    Instance_new_144.ZIndex = 10
    Instance_new_144.Parent = TopBar

    local Instance_new_145 = Instance.new("ImageButton")

    Instance_new_145.Size = UDim2.fromOffset(45, 45)
    Instance_new_145.Position = var_007(0, 15, 0.5, -22)
    Instance_new_145.BackgroundColor3 = var_016.Main
    Instance_new_145.Image = "rbxassetid://80180896525224"
    Instance_new_145.ScaleType = Enum.ScaleType.Fit
    Instance_new_145.Visible = false
    Instance_new_145.ZIndex = 100
    Instance_new_145.Parent = Instance_new

    fn_023(Instance_new_145, 22)
    fn_024(Instance_new_145, var_016.Outline, 1, 0.15)
    Instance_new_144.MouseButton1Click:Connect(function()
        fn_031(false)
    end)
    Instance_new_145.MouseButton1Click:Connect(function()
        fn_031(true)
    end)
    fn_011("menuOpen", function(arg_205)
        Instance_new_145.Visible = not arg_205
    end)

    local Instance_new_146 = Instance.new("TextButton")

    Instance_new_146.Size = UDim2.fromOffset(50, 50)
    Instance_new_146.Position = var_007(1, -70, 0.5, -30)
    Instance_new_146.BackgroundColor3 = var_016.Main
    Instance_new_146.Text = "AIM"
    Instance_new_146.TextColor3 = var_016.TextMute
    Instance_new_146.Font = Enum.Font.GothamBold
    Instance_new_146.TextSize = 14
    Instance_new_146.Visible = var_042.mobileAimlockUI
    Instance_new_146.ZIndex = 100
    Instance_new_146.Parent = Instance_new

    fn_023(Instance_new_146, 25)
    fn_024(Instance_new_146, var_016.Outline, 2, 0)

    local StarterGui = Instance.new("TextButton")

    StarterGui.Size = UDim2.fromOffset(50, 50)
    StarterGui.Position = var_007(1, -70, 0.5, 30)
    StarterGui.BackgroundColor3 = var_016.Main
    StarterGui.Text = "JUMP"
    StarterGui.TextColor3 = var_016.TextMute
    StarterGui.Font = Enum.Font.GothamBold
    StarterGui.TextSize = 14
    StarterGui.Visible = var_042.mobileJumpUI
    StarterGui.ZIndex = 100
    StarterGui.Parent = Instance_new

    fn_023(StarterGui, 25)
    fn_024(StarterGui, var_016.Outline, 2, 0)

    Instance_new_146.Active = true
    StarterGui.Active = true

    Instance_new_146.Activated:Connect(function()
        delay_2(random(1, 4) * (1E-2), function()
            fn_014("mobileAimlockActive", not var_042.mobileAimlockActive)

            Instance_new_146.TextColor3 = var_042.mobileAimlockActive and var_016.Accent or var_016.TextMute
            Instance_new_146.BackgroundColor3 = var_042.mobileAimlockActive and var_016.FieldAlt or var_016.Main
        end)
    end)
    StarterGui.Activated:Connect(function()
        delay_2(random(1, 4) * (1E-2), function()
            fn_014("mobileJumpActive", not var_042.mobileJumpActive)

            StarterGui.TextColor3 = var_042.mobileJumpActive and var_016.Accent or var_016.TextMute
            StarterGui.BackgroundColor3 = var_042.mobileJumpActive and var_016.FieldAlt or var_016.Main
        end)
    end)
    fn_011("mobileAimlockUI", function(arg_206)
        Instance_new_146.Visible = arg_206
    end)
    fn_011("mobileJumpUI", function(arg_207)
        StarterGui.Visible = arg_207
    end)
end

spawn_2(function()
    local var_529, var_530 = {
        Prefix = "Wyvern",
        PrefixColor = "#00BFFF",
        HitColor = "#FF6060",
        NameColor = "#FFD700",
        MessageLifetime = 5,
        FadeTime = 0.25,
        MaxActiveMessages = 6,
        DamageWindow = 0.6,
        Debug = false,
    }, {
        ScrollingFrame = nil,
        Template = nil,
        TemplateLabel = nil,
        WatcherReady = false,
        ActiveRows = {},
        NextOrder = 1E4,
        HealthCache = {},
        LastFireTime = 0,
        PendingHits = {},
        Connections = {},
        CharConns = {},
    }

    local function fn_138()
        if var_530.ScrollingFrame and var_530.ScrollingFrame.Parent then
            return var_530.ScrollingFrame
        end

        local FindFirstChild_49 = LocalPlayer:FindFirstChild("PlayerGui")

        if not (not FindFirstChild_49) then
        else
            return nil
        end

        local FindFirstChild_50 = FindFirstChild_49:FindFirstChild("MainGui")

        if not FindFirstChild_50 then
            return nil
        end

        local FindFirstChild_51 = FindFirstChild_50:FindFirstChild("Gameplay")

        if not FindFirstChild_51 then
            return nil
        end

        local FindFirstChild_52 = FindFirstChild_51:FindFirstChild("Middle")

        if not FindFirstChild_52 then
            return nil
        end

        local FindFirstChild_53 = FindFirstChild_52:FindFirstChild("Chat")

        if not (not FindFirstChild_53) then
        else
            return nil
        end

        local FindFirstChild_54 = FindFirstChild_53:FindFirstChild("Chat")

        if not FindFirstChild_54 then
            return nil
        end

        var_530.ScrollingFrame = FindFirstChild_54:FindFirstChild("ScrollingFrame")

        return var_530.ScrollingFrame
    end
    local function fn_139(arg_208)
        if not arg_208 then
            return nil
        end

        local FindFirstChild_55 = arg_208:FindFirstChild("Message", true)

        if not (FindFirstChild_55 and FindFirstChild_55:IsA("TextLabel")) then
        else
            return FindFirstChild_55
        end

        for it_248, it_249 in ipairs(arg_208:GetDescendants())do
            if it_249:IsA("TextLabel") then
                return it_249
            end
        end

        return nil
    end
    local function fn_140(arg_209)
        if not (var_530.Template and var_530.Template.Parent) then
        else
            return var_530.Template
        end

        var_530.Template = arg_209:FindFirstChild("Template")

        if var_530.Template then
            var_530.TemplateLabel = fn_139(var_530.Template)
        end

        return var_530.Template
    end
    local function fn_141(arg_210)
        return arg_210 and arg_210.Name and arg_210.Name:find("PrivateWY_Row") ~= nil
    end
    local function fn_142()
        for i_11 = #var_530.ActiveRows, 1, -1 do
            if not (not var_530.ActiveRows[i_11] or not var_530.ActiveRows[i_11].Parent) then
            else
                table.remove(var_530.ActiveRows, i_11)
            end
        end
    end
    local function fn_143(arg_211)
        for i_12 = #var_530.ActiveRows, 1, -1 do
            if not (var_530.ActiveRows[i_12] == arg_211) then
            else
                table.remove(var_530.ActiveRows, i_12)

                return
            end
        end
    end
    local function fn_144()
        fn_142()

        while#var_530.ActiveRows > var_529.MaxActiveMessages do
            local var_531 = table.remove(var_530.ActiveRows, 1)

            if not (var_531 and var_531.Parent) then
            else
                var_531:Destroy()
            end
        end
    end
    local function fn_145(arg_212)
        if var_530.WatcherReady then
            return
        end

        var_530.WatcherReady = true

        arg_212.ChildAdded:Connect(function(arg_213)
            if not (not arg_213:IsA("GuiObject") or arg_213.Name == "Template" or fn_141(arg_213)) then
            else
                return
            end

            task.defer(function()
                if not (not arg_213 or not arg_213.Parent) then
                else
                    return
                end

                fn_142()

                for it_250, it_251 in ipairs(var_530.ActiveRows)do
                    if not (it_251 and it_251.Parent) then
                    else
                        it_251.LayoutOrder = arg_213.LayoutOrder - 1
                    end
                end
            end)
        end)
    end
    local function fn_146(arg_214, arg_215)
        return format("<font color='%s'>(%s)</font> = You hit <font color='%s'><b>%s</b></font> to <font color='%s'><b>%s</b></font>", var_529.PrefixColor, var_529.Prefix, var_529.HitColor, tostring(arg_214), var_529.NameColor, arg_215)
    end
    local function fn_147(arg_216, arg_217)
        local var_532 = fn_139(arg_216)

        if not (not var_532) then
        else
            return nil
        end

        for it_252, it_253 in ipairs(arg_216:GetDescendants())do
            if it_253:IsA("GuiObject") then
                it_253.Visible = true
            end
        end

        arg_216.Visible = true

        if var_530.Template and var_530.Template:IsA("GuiObject") then
            arg_216.Size = var_530.Template.Size
            arg_216.AutomaticSize = var_530.Template.AutomaticSize
            arg_216.BackgroundTransparency = var_530.Template.BackgroundTransparency
        end

        var_532.Visible = true
        var_532.RichText = true
        var_532.TextScaled = false
        var_532.TextWrapped = false
        var_532.TextTransparency = 0

        if not (var_530.TemplateLabel) then
        else
            var_532.Font = var_530.TemplateLabel.Font
            var_532.TextSize = var_530.TemplateLabel.TextSize
            var_532.TextColor3 = var_530.TemplateLabel.TextColor3
            var_532.TextStrokeTransparency = var_530.TemplateLabel.TextStrokeTransparency
            var_532.TextXAlignment = var_530.TemplateLabel.TextXAlignment
            var_532.TextYAlignment = var_530.TemplateLabel.TextYAlignment
            var_532.Size = var_530.TemplateLabel.Size
            var_532.Position = var_530.TemplateLabel.Position
        end
        if var_532.TextSize > 15 then
            var_532.TextSize = 14
        end

        var_532.Text = arg_217

        return var_532
    end
    local function fn_148(arg_218)
        delay_2(var_529.MessageLifetime, function()
            if not arg_218 or not arg_218.Parent then
                return
            end

            for it_254, it_255 in ipairs(arg_218:GetDescendants())do
                if not (it_255:IsA("TextLabel")) then
                else
                    TweenService:Create(it_255, TweenInfo.new(var_529.FadeTime, Enum.EasingStyle.Quad), {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1,
                    }):Play()
                end
            end

            wait_2(var_529.FadeTime + 5E-2)
            fn_143(arg_218)

            if arg_218 and arg_218.Parent then
                arg_218:Destroy()
            end
        end)
    end
    local function fn_149(arg_219, arg_220)
        if not var_042.showHitmarkerChat then
            return
        end

        local var_533, var_534 = var_042.hitmarkerMode or "Chat", floor(arg_219 + (0.5))

        if var_533 == "Notification" or var_533 == "Both" then
            spawn_2(function()
                fn_077("WYVERN", "Hit " .. arg_220 .. " for " .. tostring(var_534) .. " dmg", 2.5)
            end)
        end
        if var_533 == "Chat" or var_533 == "Both" then
            local var_535 = fn_138()

            if not var_535 then
                pcall(function()
                    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                        Text = "[Wyvern] You hit " .. arg_220 .. " for " .. tostring(var_534),
                        Color = fromRGB(255, 96, 96),
                        Font = Enum.Font.SourceSansBold,
                        TextSize = 18,
                    })
                end)

                return
            end

            fn_145(var_535)

            local var_536 = fn_140(var_535)

            if not (not var_536 or not var_536:IsA("GuiObject")) then
            else
                return
            end

            var_530.NextOrder = var_530.NextOrder + (1)

            local Clone_2 = var_536:Clone()

            Clone_2.Name = "PrivateWY_Row_" .. tostring(var_530.NextOrder)
            Clone_2.LayoutOrder = var_530.NextOrder
            Clone_2.Visible = true
            Clone_2.Parent = var_535

            local var_537 = fn_147(Clone_2, fn_146(var_534, arg_220))

            if not var_537 then
                Clone_2:Destroy()

                return
            end

            table.insert(var_530.ActiveRows, Clone_2)
            fn_144()
            fn_148(Clone_2)
        end
    end
    local function fn_150(arg_221)
        if not (arg_221 == LocalPlayer) then
        else
            return false
        end

        pcall(function()
            if LocalPlayer.Team and arg_221.Team and LocalPlayer.Team == arg_221.Team then
                return
            end
        end)

        return true
    end
    local function fn_151(arg_222)
        local var_538 = var_530.PendingHits[arg_222]

        if not var_538 then
            return
        end

        var_530.PendingHits[arg_222] = nil

        fn_149(floor(var_538.dmg + 0.5), var_538.name)
    end
    local function fn_152(arg_223, arg_224)
        local var_539 = var_530.PendingHits[arg_223]

        if var_539 then
            var_539.dmg = var_539.dmg + arg_224

            if not (var_539.timer) then
            else
                task.cancel(var_539.timer)
            end

            var_539.timer = delay_2(0.12, function()
                fn_151(arg_223)
            end)
        else
            var_530.PendingHits[arg_223] = {
                dmg = arg_224,
                name = arg_223.DisplayName ~= '' and arg_223.DisplayName or arg_223.Name,
            }
            var_530.PendingHits[arg_223].timer = delay_2(0.12, function()
                fn_151(arg_223)
            end)
        end
    end
    local function fn_153(arg_225)
        if not (var_530.Connections[arg_225]) then
        else
            return
        end

        local function fn_154(arg_226)
            if not arg_226 then
                return
            end

            local WaitForChild_5 = arg_226:WaitForChild("Humanoid", 10)

            if not (not WaitForChild_5) then
            else
                return
            end

            var_530.HealthCache[arg_225] = WaitForChild_5.Health

            local Connect_13 = WaitForChild_5.HealthChanged:Connect(function(arg_227)
                if not var_042.showHitmarkerChat then
                    return
                end

                local var_540 = var_530.HealthCache[arg_225] or arg_227

                var_530.HealthCache[arg_225] = arg_227

                local var_541 = var_540 - arg_227

                if not (var_541 <= 0) then
                else
                    return
                end

                fn_152(arg_225, var_541)
            end)

            arg_226.AncestryChanged:Connect(function(arg_228, arg_229)
                if not arg_229 then
                    Connect_13:Disconnect()

                    var_530.HealthCache[arg_225] = nil
                end
            end)

            var_530.Connections[arg_225] = Connect_13
        end

        if not (arg_225.Character) then
        else
            spawn_2(fn_154, arg_225.Character)
        end

        var_530.CharConns[arg_225] = arg_225.CharacterAdded:Connect(function(arg_230)
            if var_530.Connections[arg_225] then
                var_530.Connections[arg_225]:Disconnect()

                var_530.Connections[arg_225] = nil
            end

            spawn_2(fn_154, arg_230)
        end)
    end
    local function fn_155(arg_231)
        if var_530.Connections[arg_231] then
            var_530.Connections[arg_231]:Disconnect()

            var_530.Connections[arg_231] = nil
        end
        if not (var_530.CharConns[arg_231]) then
        else
            var_530.CharConns[arg_231]:Disconnect()

            var_530.CharConns[arg_231] = nil
        end

        var_530.HealthCache[arg_231] = nil
        var_530.PendingHits[arg_231] = nil
    end

    for it_256, it_257 in ipairs(Players:GetPlayers())do
        if fn_150(it_257) then
            fn_153(it_257)
        end
    end

    Players.PlayerAdded:Connect(function(arg_232)
        if not (fn_150(arg_232)) then
        else
            fn_153(arg_232)
        end
    end)
    Players.PlayerRemoving:Connect(fn_155)
    UserInputService.InputBegan:Connect(function(arg_233, arg_234)
        if not (arg_234) then
        else
            return
        end
        if not (arg_233.UserInputType == Enum.UserInputType.MouseButton1) then
        else
            var_530.LastFireTime = os.clock()
        end
    end)
    RunService.Heartbeat:Connect(function()
        if not (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
        else
            var_530.LastFireTime = os.clock()
        end
    end)
end)
spawn_2(function()
    local function fn_156(arg_235)
        local GetObjects_2, var_542 = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(arg_235))[1]
        end)

        if not (not GetObjects_2 or not var_542) then
        else
            GetObjects_2, var_542 = pcall(function()
                return game:GetService("InsertService"):LoadLocalAsset("rbxassetid://" .. tostring(arg_235))
            end)
        end
        if not (GetObjects_2 and var_542 and var_542:IsA("Model")) then
        else
            for it_258, it_259 in ipairs(var_542:GetDescendants())do
                if it_259:IsA("LuaSourceContainer") or it_259:IsA("Humanoid") or it_259:IsA("Sound") then
                    it_259:Destroy()
                end
            end

            return var_542
        end

        return nil
    end
    local function fn_157(arg_236, arg_237)
        if not var_042.enableCustomModel then
            return
        end
        if not (not arg_236) then
        else
            return
        end
        if arg_236:FindFirstChild("AnimeModel") then
            return
        end

        local Clone_3 = arg_237:Clone()

        Clone_3.Name = "AnimeModel"
        Clone_3.Parent = arg_236

        for it_260, it_261 in pairs(Clone_3:GetDescendants())do
            if not (it_261:IsA("BasePart")) then
                if it_261:IsA("Motor6D") then
                    it_261:Destroy()
                end
            else
                it_261.Anchored = false
                it_261.CanCollide = false
                it_261.CanTouch = false
                it_261.CanQuery = false
                it_261.Massless = true
                it_261.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)

                if it_261.Name ~= "HumanoidRootPart" then
                    it_261.Transparency = 0
                else
                    it_261.Transparency = 1
                end
            end
        end

        local function fn_158(arg_238, arg_239)
            local Instance_new_147 = Instance.new("WeldConstraint")

            Instance_new_147.Part0 = arg_238
            Instance_new_147.Part1 = arg_239
            Instance_new_147.Parent = arg_239
        end

        local var_543 = {
            "Head",
            "UpperTorso",
            "LowerTorso",
            "LeftUpperArm",
            "LeftLowerArm",
            "LeftHand",
            "RightUpperArm",
            "RightLowerArm",
            "RightHand",
            "LeftUpperLeg",
            "LeftLowerLeg",
            "LeftFoot",
            "RightUpperLeg",
            "RightLowerLeg",
            "RightFoot",
        }

        for it_262, it_263 in pairs(var_543)do
            local FindFirstChild_56, FindFirstChild_57 = arg_236:FindFirstChild(it_263), Clone_3:FindFirstChild(it_263)

            if FindFirstChild_56 and FindFirstChild_57 then
                FindFirstChild_57.CFrame = FindFirstChild_56.CFrame + var_004(0, 1.5, 0)

                fn_158(FindFirstChild_56, FindFirstChild_57)

                if not (it_263 ~= "HumanoidRootPart") then
                else
                    FindFirstChild_56.Transparency = 1
                end

                FindFirstChild_57.Name = "Miku_" .. it_263
            end
        end

        if arg_236:FindFirstChild("CharacterArmor") then
            arg_236.CharacterArmor:Destroy()
        end
        if arg_236:FindFirstChild("Clothing") then
            arg_236.Clothing:Destroy()
        end

        for it_264, it_265 in pairs(arg_236:GetChildren())do
            if not (it_265:IsA("Accessory")) then
            else
                it_265:Destroy()
            end
        end

        local function fn_159(arg_240)
            if not (not arg_240:IsA("JointInstance") and not arg_240:IsA("WeldConstraint")) then
            else
                return
            end

            local function fn_160(arg_241)
                local var_544 = arg_240[arg_241]

                if var_544 and var_544.Parent == arg_236 then
                    local FindFirstChild_58 = Clone_3:FindFirstChild("Miku_" .. var_544.Name)

                    if FindFirstChild_58 then
                        arg_240[arg_241] = FindFirstChild_58
                    end
                end
            end

            pcall(fn_160, "Part0")
            pcall(fn_160, "Part1")
        end

        for it_266, it_267 in ipairs(arg_236:GetDescendants())do
            fn_159(it_267)
        end

        arg_236.DescendantAdded:Connect(fn_159)
    end

    RunService.RenderStepped:Connect(function()
        if not (not var_042.enableCustomModel) then
        else
            return
        end

        local FindFirstChild_59 = LocalPlayer.Character or (Workspace:FindFirstChild("Characters") and Workspace.Characters:FindFirstChild(LocalPlayer.Name, true))

        if FindFirstChild_59 and FindFirstChild_59:FindFirstChild("AnimeModel") then
            local FindFirstChild_60 = FindFirstChild_59:FindFirstChild("Head")

            if FindFirstChild_60 then
                local var_545 = (Workspace.CurrentCamera.CFrame.p - FindFirstChild_60.Position).Magnitude < 1.6

                for it_268, it_269 in ipairs(FindFirstChild_59.AnimeModel:GetDescendants())do
                    if not (it_269:IsA("BasePart") and it_269.Name ~= "HumanoidRootPart" and it_269.Name ~= "Miku_HumanoidRootPart") then
                    else
                        it_269.LocalTransparencyModifier = var_545 and 1 or 0
                    end
                end
            end
        end
    end)

    local function fn_161()
        spawn_2(function()
            while wait_2(1) do
                if var_042.enableCustomModel then
                    local var_546 = tonumber(var_042.customModelId)

                    if not (var_546 and var_546 > 0) then
                    else
                        local var_547 = fn_156(var_546)

                        if var_547 then
                            local FindFirstChild_61 = Workspace:FindFirstChild("Characters")

                            if FindFirstChild_61 then
                                for it_270, it_271 in pairs(FindFirstChild_61:GetChildren())do
                                    for it_272, it_273 in pairs(it_271:GetChildren())do
                                        fn_157(it_273, var_547)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    spawn_2(fn_161)
end)
fn_028()
fn_030()
fn_031(true)
fn_014("activeTab", var_042.activeTab)
fn_013()

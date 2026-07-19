local Skinchanger = {}
Skinchanger.__index = Skinchanger

local BASE_KNIVES = {
    ["CT Knife"] = true,
    ["T Knife"] = true,
    ["Knife"] = true,
}

local KNIFE_MODELS = {
    "Skeleton Knife",
    "Stiletto Knife",
    "Karambit",
    "Butterfly Knife",
    "Flip Knife",
    "Gut Knife",
    "M9 Bayonet",
    "Huntsman",
    "Talon",
    "Ursus",
    "Kukri",
    "Daggers",
    "Navaja",
    "Bowie",
    "Falchion"
}

local IGNORE_FOLDERS = {
    ["HE Grenade"] = true,
    ["Incendiary Grenade"] = true,
    ["Molotov"] = true,
    ["Smoke Grenade"] = true,
    ["Flashbang"] = true,
    ["Decoy Grenade"] = true,
    ["C4"] = true,
    ["CT Glove"] = true,
    ["T Glove"] = true,
}

local function sortedKeys(map)
    local out = {}
    for key in pairs(map or {}) do
        out[#out + 1] = key
    end
    table.sort(out, function(a, b)
        return tostring(a):lower() < tostring(b):lower()
    end)
    return out
end

local function cloneList(list)
    local out = {}
    for index, value in ipairs(list or {}) do
        out[index] = value
    end
    return out
end

local function safeRequire(module)
    if not module then
        return nil
    end

    local ok, result = pcall(require, module)
    if ok then
        return result
    end

    return nil
end

function Skinchanger.new(context)
    local self = setmetatable({}, Skinchanger)

    self.services = context.services
    self.globals = context.globals
    self.Cleaner = context.Cleaner
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.player = self.services.Players.LocalPlayer
    self.repStore = self.services.ReplicatedStorage
    self.executor = (identifyexecutor and identifyexecutor()) or "Unknown"

    self.running = true
    self.boundCameras = {}
    self.skinApplyDebounce = false
    self.lastInventoryRefresh = 0
    self.knifeHookInstalled = false
    self.knifeChangerSupported = true
    self.inventoryController = nil
    self.getWeaponProperties = nil

    self.skinsRoot = nil
    self.weaponOptions = {}
    self.weaponNames = {}
    self.gloveOptions = {}
    self.gloveModels = {}

    self.config = {
        skinChangerEnabled = false,
        knifeChangerEnabled = false,
        knifeModel = "Default", --Karambit
        gloveChangerEnabled = false,
        gloveModel = "Sports Gloves",
        gloveSkins = {},
        weaponSkins = {},
        inventoryRefreshRate = 2,
    }

    
    if string.find(self.executor, "RonixExploit", 1, true)
        or string.find(self.executor, "Xeno", 1, true)
        or string.find(self.executor, "Solara", 1, true)
    then
        self.knifeChangerSupported = false
    end



    self:_scanSkinData()
    self:_initInventorySupport()
    if self.knifeChangerSupported then
        local installed = self:_ensureKnifeHook()
        if not installed then
            self.knifeChangerSupported = false
        end
    end
    self:_bind()

    return self
end

function Skinchanger:_isLocalSkinApplyActive()
    return self.globals and self.globals:IsAlive() ~= nil
end

function Skinchanger:_scanSkinData()
    local skinsRoot = self.repStore:FindFirstChild("Assets")
        and self.repStore.Assets:FindFirstChild("Skins")

    self.skinsRoot = skinsRoot
    if not skinsRoot then
        return
    end

    local gloveMap = {}
    local weaponMap = {}

    for _, folder in ipairs(skinsRoot:GetChildren()) do
        local options = { "Default" }
        for _, skin in ipairs(folder:GetChildren()) do
            options[#options + 1] = skin.Name
        end

        table.sort(options, function(a, b)
            if a == "Default" then
                return true
            end
            if b == "Default" then
                return false
            end
            return a:lower() < b:lower()
        end)

        if folder.Name:match("Glove") or folder.Name:match("Gloves") or folder.Name == "Hand Wraps" then
            if not folder.Name:match("^T Glove") and not folder.Name:match("^CT Glove") then
                gloveMap[folder.Name] = options
            end
        elseif not IGNORE_FOLDERS[folder.Name] then
            weaponMap[folder.Name] = options
        end
    end

    self.weaponOptions = weaponMap
    self.weaponNames = sortedKeys(weaponMap)
    self.gloveOptions = gloveMap
    self.gloveModels = sortedKeys(gloveMap)

    if not self.gloveOptions[self.config.gloveModel] then
        self.config.gloveModel = self.gloveModels[1]
    end

    for _, weaponName in ipairs(self.weaponNames) do
        if self.config.weaponSkins[weaponName] == nil then
            self.config.weaponSkins[weaponName] = "Default"
        end
    end

    for _, gloveModel in ipairs(self.gloveModels) do
        if self.config.gloveSkins[gloveModel] == nil then
            self.config.gloveSkins[gloveModel] = "Default"
        end
    end
end

function Skinchanger:_initInventorySupport()
    if not self.knifeChangerSupported then
        return
    end

    if not self.inventoryController then
        pcall(function()
            local module = self.repStore:FindFirstChild("Controllers")
                and self.repStore.Controllers:FindFirstChild("InventoryController")
            if module then
                local result = safeRequire(module)
                if result then
                    self.inventoryController = result
                end
            end
        end)
    end

    if not self.getWeaponProperties then
        pcall(function()
            local module = self.repStore:FindFirstChild("Components")
                and self.repStore.Components:FindFirstChild("Common")
                and self.repStore.Components.Common:FindFirstChild("GetWeaponProperties")
            if module then
                local result = safeRequire(module)
                if result then
                    self.getWeaponProperties = result
                end
            end
        end)
    end

    if not self.inventoryController then
        self.knifeChangerSupported = false
    end
end

function Skinchanger:_getWeaponModel()
    local camera = self.services.Workspace.CurrentCamera
    if not camera then
        return nil
    end

    for _, child in ipairs(camera:GetChildren()) do
        if child:IsA("Model")
            and child.Name ~= "Arms"
            and child.Name ~= "Arms1"
            and child.Name ~= "Arms2"
            and child.Name ~= "Viewmodel"
        then
            return child
        end
    end

    return nil
end

function Skinchanger:_updateInventoryNames()
    if not self:_isLocalSkinApplyActive() then
        return
    end

    local playerGui = self.player:FindFirstChild("PlayerGui")
    local invGui = playerGui and playerGui:FindFirstChild("MainGui")
    if not invGui then
        return
    end

    local gameplay = invGui:FindFirstChild("Gameplay")
    if not gameplay then
        return
    end

    local bottom = gameplay:FindFirstChild("Bottom")
    if not bottom then
        return
    end

    local inventory = bottom:FindFirstChild("Inventory")
    if not inventory then
        return
    end

    local meleeSlot = inventory:FindFirstChild("Melee")
    if meleeSlot and self.config.knifeChangerEnabled then
        local weapon = meleeSlot:FindFirstChild("Weapon")
        if weapon then
            local weaponName = weapon:FindFirstChild("WeaponName")
            if weaponName and weaponName:IsA("TextLabel") then
                local knifeModel = self.config.knifeModel
                local selectedSkin = self.config.weaponSkins[knifeModel]
                local star = utf8.char(9733)
                if selectedSkin and selectedSkin ~= "Default" then
                    weaponName.Text = star .. " " .. knifeModel .. " | " .. selectedSkin
                else
                    weaponName.Text = star .. " " .. knifeModel
                end
            end

            local meleeImg = weapon:FindFirstChild("Melee")
            if meleeImg and meleeImg:IsA("ImageLabel") then
                pcall(function()
                    local knifeModel = self.config.knifeModel
                    local weaponDB = self.repStore:FindFirstChild("Database")
                        and self.repStore.Database:FindFirstChild("Custom")
                        and self.repStore.Database.Custom:FindFirstChild("Weapons")
                    if weaponDB then
                        local weaponModule = weaponDB:FindFirstChild(knifeModel)
                        if weaponModule then
                            local weaponData = safeRequire(weaponModule)
                            if weaponData and type(weaponData) == "table" and weaponData.Icon then
                                meleeImg.Image = weaponData.Icon
                            end
                        end
                    end
                end)
            end
        end
    end

    for _, child in ipairs(inventory:GetDescendants()) do
        if child:IsA("TextLabel") and child.Name == "WeaponName" then
            local isMeleeChild = meleeSlot and child:IsDescendantOf(meleeSlot)
            if not isMeleeChild then
                local parts = string.split(child.Text, " | ")
                local baseName = (parts[1] or child.Text or ""):gsub("%s+$", "")
                local selectedSkin = self.config.weaponSkins[baseName]
                if selectedSkin and selectedSkin ~= "Default" then
                    child.Text = baseName .. " | " .. selectedSkin
                else
                    child.Text = baseName
                end
            end
        end
    end
end

function Skinchanger:_applyWeaponSkin()
    if not self:_isLocalSkinApplyActive() then
        return
    end

    if not self.skinsRoot then
        return
    end

    local weaponModel = self:_getWeaponModel()
    if not weaponModel then
        return
    end

    local own = weaponModel.Name
    local effectiveWeaponName = own
    local canApply = false

    if BASE_KNIVES[own] then
        if self.config.knifeChangerEnabled then
            effectiveWeaponName = self.config.knifeModel
            canApply = true
        end
    elseif self.config.skinChangerEnabled then
        canApply = true
    end

    if not canApply then
        return
    end

    local current = weaponModel:GetAttribute("AstroSkin")
    local selectedSkin = self.config.weaponSkins[effectiveWeaponName]
    if not selectedSkin or selectedSkin == "Default" then
        return
    end
    if current == selectedSkin then
        return
    end

    local weaponSkinFolder = self.skinsRoot:FindFirstChild(effectiveWeaponName)
    if not weaponSkinFolder then
        return
    end

    local skinFolder = weaponSkinFolder:FindFirstChild(selectedSkin)
    if not skinFolder then
        return
    end

    local cameraFolder = skinFolder:FindFirstChild("Camera")
    if not cameraFolder then
        return
    end

    local factoryNew = cameraFolder:FindFirstChild("Factory New")
    if not factoryNew then
        return
    end

    for _, surfaceAppearance in ipairs(factoryNew:GetChildren()) do
        if surfaceAppearance:IsA("SurfaceAppearance") then
            local part = weaponModel:FindFirstChild(surfaceAppearance.Name, true)
            if part and (part:IsA("BasePart") or part:IsA("MeshPart")) then
                for _, old in ipairs(part:GetChildren()) do
                    if old:IsA("SurfaceAppearance") then
                        old:Destroy()
                    end
                end
                surfaceAppearance:Clone().Parent = part
            end
        end
    end

    weaponModel:SetAttribute("AstroSkin", selectedSkin)
    self:_updateInventoryNames()
end

function Skinchanger:_applyGloves()
    if not self:_isLocalSkinApplyActive() then
        return
    end

    if not self.config.gloveChangerEnabled then
        return
    end

    local camera = self.services.Workspace.CurrentCamera
    if not camera then
        return
    end

    local armsModel = nil
    for _, child in ipairs(camera:GetChildren()) do
        if child:IsA("Model") and (child.Name:match("Arms") or child:FindFirstChild("Right Arm")) then
            armsModel = child
            break
        end
    end
    if not armsModel then
        return
    end

    local leftArm = armsModel:FindFirstChild("Left Arm")
    local rightArm = armsModel:FindFirstChild("Right Arm")
    if not leftArm or not rightArm then
        return
    end

    local leftGlove = leftArm:FindFirstChild("Glove")
    local rightGlove = rightArm:FindFirstChild("Glove")
    if not leftGlove or not rightGlove then
        return
    end

    for _, old in ipairs(leftGlove:GetChildren()) do
        if old:IsA("SurfaceAppearance") then
            old:Destroy()
        end
    end
    for _, old in ipairs(rightGlove:GetChildren()) do
        if old:IsA("SurfaceAppearance") then
            old:Destroy()
        end
    end

    local selectedModel = self.config.gloveModel
    if not selectedModel then
        return
    end

    local selectedSkin = self.config.gloveSkins[selectedModel]
    if not selectedSkin or selectedSkin == "Default" then
        return
    end

    if not self.skinsRoot then
        return
    end

    local gloveSkinFolder = self.skinsRoot:FindFirstChild(selectedModel)
    if not gloveSkinFolder then
        return
    end

    local skinVariant = gloveSkinFolder:FindFirstChild(selectedSkin)
    if not skinVariant then
        return
    end

    local cameraFolder = skinVariant:FindFirstChild("Camera")
    if not cameraFolder then
        return
    end

    local factoryNew = cameraFolder:FindFirstChild("Factory New")
    if not factoryNew then
        return
    end

    for _, surfaceAppearance in ipairs(factoryNew:GetChildren()) do
        if surfaceAppearance:IsA("SurfaceAppearance") then
            surfaceAppearance:Clone().Parent = leftGlove
            surfaceAppearance:Clone().Parent = rightGlove
        end
    end
end

function Skinchanger:_tryApply()
    if self.skinApplyDebounce then
        return
    end

    self.skinApplyDebounce = true
    self.errorHandler:Spawn("Skinchanger TryApply", function()
        task.wait(0.2)
        pcall(function()
            if self.config.skinChangerEnabled or self.config.knifeChangerEnabled then
                self:_applyWeaponSkin()
            end
            if self.config.gloveChangerEnabled then
                self:_applyGloves()
            end
        end)
        task.wait(0.3)
        pcall(function()
            self:_updateInventoryNames()
        end)
        self.skinApplyDebounce = false
    end)
end

function Skinchanger:_bindCamera(camera)
    if not camera or self.boundCameras[camera] then
        return
    end

    self.boundCameras[camera] = true
    self.cleaner:Give(self.errorHandler:Connect(camera.ChildAdded, "Skinchanger Camera ChildAdded", function()
        if self.config.skinChangerEnabled or self.config.knifeChangerEnabled or self.config.gloveChangerEnabled then
            self:_tryApply()
        end
    end))
end

function Skinchanger:_ensureKnifeHook()
    if self.knifeHookInstalled or not self.knifeChangerSupported then
        return self.knifeHookInstalled
    end

    local skinsModule = self.repStore:FindFirstChild("Database")
        and self.repStore.Database:FindFirstChild("Components")
        and self.repStore.Database.Components:FindFirstChild("Libraries")
        and self.repStore.Database.Components.Libraries:FindFirstChild("Skins")
    local viewmodelModule = self.repStore:FindFirstChild("Classes")
        and self.repStore.Classes:FindFirstChild("WeaponComponent")
        and self.repStore.Classes.WeaponComponent:FindFirstChild("Classes")
        and self.repStore.Classes.WeaponComponent.Classes:FindFirstChild("Viewmodel")

    if not skinsModule or not viewmodelModule then
        return false
    end

    local skinsLibrary = safeRequire(skinsModule)
    local viewmodelLibrary = safeRequire(viewmodelModule)
    if not skinsLibrary or not viewmodelLibrary then
        return false
    end
    if type(skinsLibrary) ~= "table" or type(viewmodelLibrary) ~= "table" then
        return false
    end
    if not skinsLibrary.GetCameraModel or not skinsLibrary.GetCharacterModel or not viewmodelLibrary.new then
        return false
    end

    local originalGetCameraModel = skinsLibrary.GetCameraModel
    skinsLibrary.GetCameraModel = function(weaponName, skinName, ...)
        local success, result
        if self:_isLocalSkinApplyActive()
            and self.config.knifeChangerEnabled
            and weaponName
            and BASE_KNIVES[weaponName]
        then
            local newKnife = self.config.knifeModel
            local newSkin = self.config.weaponSkins[newKnife] or "Vanilla"
            success, result = pcall(originalGetCameraModel, newKnife, newSkin, ...)
            if success and result then
                return result
            end
        end
        success, result = pcall(originalGetCameraModel, weaponName, skinName, ...)
        if success then
            return result
        end
        return nil
    end

    local originalGetCharacterModel = skinsLibrary.GetCharacterModel
    skinsLibrary.GetCharacterModel = function(weaponName, skinName, ...)
        local success, result
        if self:_isLocalSkinApplyActive()
            and self.config.knifeChangerEnabled
            and weaponName
            and BASE_KNIVES[weaponName]
        then
            local newKnife = self.config.knifeModel
            local newSkin = self.config.weaponSkins[newKnife] or "Vanilla"
            success, result = pcall(originalGetCharacterModel, newKnife, newSkin, ...)
            if success and result then
                return result
            end
        end
        success, result = pcall(originalGetCharacterModel, weaponName, skinName, ...)
        if success then
            return result
        end
        return nil
    end

    local originalViewmodelNew = viewmodelLibrary.new
    viewmodelLibrary.new = function(viewContext, weaponName, skinName, ...)
        local success, result
        if self:_isLocalSkinApplyActive()
            and self.config.knifeChangerEnabled
            and weaponName
            and BASE_KNIVES[weaponName]
        then
            local newKnife = self.config.knifeModel
            local newSkin = self.config.weaponSkins[newKnife] or "Vanilla"
            success, result = pcall(originalViewmodelNew, viewContext, newKnife, newSkin, ...)
            if success and result then
                return result
            end
        end
        success, result = pcall(originalViewmodelNew, viewContext, weaponName, skinName, ...)
        if success then
            return result
        end
        return nil
    end

    if skinsLibrary.GetGloves then
        local originalGetGloves = skinsLibrary.GetGloves
        skinsLibrary.GetGloves = function(gloveName, skinName)
            local success, result
            if self:_isLocalSkinApplyActive()
                and self.config.gloveChangerEnabled
                and self.config.gloveModel
            then
                local gloveModel = self.config.gloveModel
                local targetSkin = self.config.gloveSkins[gloveModel] or "Vanilla"
                success, result = pcall(originalGetGloves, gloveModel, targetSkin)
                if success and result then
                    return result
                end
            end
            success, result = pcall(originalGetGloves, gloveName, skinName)
            if success then
                return result
            end
            return nil
        end
    end

    self.knifeHookInstalled = true
    return true
end

function Skinchanger:_bind()
    self.cleaner:Give(function()
        self.running = false
    end)

    self.errorHandler:Spawn("Skinchanger WaitForCamera", function()
        while self.running do
            local camera = self.services.Workspace.CurrentCamera
            if camera then
                self:_bindCamera(camera)
                break
            end
            task.wait(1)
        end
    end)

    self.cleaner:Give(self.errorHandler:Connect(self.services.Workspace:GetPropertyChangedSignal("CurrentCamera"), "Skinchanger Camera Changed", function()
        local camera = self.services.Workspace.CurrentCamera
        if camera then
            self:_bindCamera(camera)
        end
    end))

    self.cleaner:Give(self.errorHandler:Connect(self.services.RunService.Heartbeat, "Skinchanger Heartbeat", function()
        if (self.config.skinChangerEnabled or self.config.knifeChangerEnabled)
            and (tick() - self.lastInventoryRefresh) > self.config.inventoryRefreshRate
        then
            self.lastInventoryRefresh = tick()
            self:_updateInventoryNames()
        end
    end))

    self.errorHandler:Spawn("Skinchanger Initial Apply", function()
        task.wait(1)
        self:_tryApply()
    end)
end

function Skinchanger:SetSkinChangerEnabled(value)
    self.config.skinChangerEnabled = value == true
    self:_tryApply()
end

function Skinchanger:SetKnifeChangerEnabled(value)
    self.config.knifeChangerEnabled = value == true
    self:_tryApply()
end

function Skinchanger:SetKnifeModel(value)
    if value and self.weaponOptions[value] then
        self.config.knifeModel = value
        self:_tryApply()
    end
end

function Skinchanger:SetGloveChangerEnabled(value)
    self.config.gloveChangerEnabled = value == true
    self:_tryApply()
end

function Skinchanger:SetGloveModel(value)
    if value and self.gloveOptions[value] then
        self.config.gloveModel = value
        if self.config.gloveSkins[value] == nil then
            self.config.gloveSkins[value] = "Default"
        end
        self:_tryApply()
    end
end

function Skinchanger:SetGloveSkin(value)
    local gloveModel = self.config.gloveModel
    if gloveModel and value then
        self.config.gloveSkins[gloveModel] = value
        self:_tryApply()
    end
end

function Skinchanger:SetWeaponSkin(weaponName, skinName)
    if self.weaponOptions[weaponName] then
        self.config.weaponSkins[weaponName] = skinName or "Default"
        self:_tryApply()
    end
end

function Skinchanger:SetInventoryRefreshRate(value)
    local number = tonumber(value)
    if number then
        self.config.inventoryRefreshRate = math.max(1, number)
    end
end

function Skinchanger:GetWeaponNames()
    return cloneList(self.weaponNames)
end

function Skinchanger:GetSkinOptions(weaponName)
    return cloneList(self.weaponOptions[weaponName] or { "Default" })
end

function Skinchanger:GetWeaponSkin(weaponName)
    return self.config.weaponSkins[weaponName] or "Default"
end

function Skinchanger:GetKnifeModels()
    local out = {}
    for _, model in ipairs(KNIFE_MODELS) do
        if self.weaponOptions[model] then
            out[#out + 1] = model
        end
    end
    return out
end

function Skinchanger:IsKnifeModel(weaponName)
    for _, model in ipairs(KNIFE_MODELS) do
        if weaponName == model then
            return true
        end
    end
    return false
end

function Skinchanger:GetKnifeModel()
    return self.config.knifeModel
end

function Skinchanger:GetGloveModels()
    return cloneList(self.gloveModels)
end

function Skinchanger:GetGloveModel()
    return self.config.gloveModel
end

function Skinchanger:GetGloveSkinOptions(gloveModel)
    return cloneList(self.gloveOptions[gloveModel] or { "Default" })
end

function Skinchanger:GetGloveSkin(gloveModel)
    return self.config.gloveSkins[gloveModel or self.config.gloveModel] or "Default"
end

function Skinchanger:ApplyNow()
    self:_tryApply()
end

function Skinchanger:Destroy()
    self.cleaner:Cleanup()
end

return Skinchanger

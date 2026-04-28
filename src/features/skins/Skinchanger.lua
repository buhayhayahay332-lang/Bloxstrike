local Skinchanger = {}
Skinchanger.__index = Skinchanger

local BASE_KNIVES = {
    ["CT Knife"] = true,
    ["T Knife"] = true,
    ["Knife"] = true,
}

local KNIFE_MODELS = {
    "Karambit",
    "Butterfly Knife",
    "M9 Bayonet",
    "Flip Knife",
    "Gut Knife",
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
    for key in pairs(map) do
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

local function getHookSkinName(selectedSkin)
    if not selectedSkin or selectedSkin == "Default" then
        return "Vanilla"
    end

    return selectedSkin
end

function Skinchanger.new(context)
    local self = setmetatable({}, Skinchanger)

    self.services = context.services
    self.Cleaner = context.Cleaner
    self.cleaner = context.Cleaner.new()
    self.errorHandler = context.errorHandler
    self.player = self.services.Players.LocalPlayer
    self.repStore = self.services.ReplicatedStorage
    self.executor = (identifyexecutor and identifyexecutor()) or "Unknown"
    self.boundCameras = {}
    self.skinApplyDebounce = false
    self.pendingApply = false
    self.lastInventoryRefresh = 0
    self.knifeHookInstalled = false
    self.knifeChangerSupported = true
    self.running = true

    self.weaponOptions = {}
    self.weaponNames = {}
    self.gloveOptions = {}
    self.gloveModels = {}

    self.config = {
        skinChangerEnabled = false,
        knifeChangerEnabled = false,
        knifeModel = "Karambit",
        gloveChangerEnabled = false,
        gloveModel = nil,
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
    self:_ensureKnifeHook()
    self:_bind()

    return self
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

    if not self.config.gloveModel then
        self.config.gloveModel = self.gloveModels[1]
    end

    for _, gloveModel in ipairs(self.gloveModels) do
        if self.config.gloveSkins[gloveModel] == nil then
            self.config.gloveSkins[gloveModel] = "Default"
        end
    end

    for _, weaponName in ipairs(self.weaponNames) do
        if self.config.weaponSkins[weaponName] == nil then
            self.config.weaponSkins[weaponName] = "Default"
        end
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
    local playerGui = self.player:FindFirstChild("PlayerGui")
    local mainGui = playerGui and playerGui:FindFirstChild("MainGui")
    if not mainGui then
        return
    end

    local gameplay = mainGui:FindFirstChild("Gameplay")
    local bottom = gameplay and gameplay:FindFirstChild("Bottom")
    local inventory = bottom and bottom:FindFirstChild("Inventory")
    if not inventory then
        return
    end

    local meleeSlot = inventory:FindFirstChild("Melee")
    if meleeSlot and self.config.knifeChangerEnabled then
        local weapon = meleeSlot:FindFirstChild("Weapon")
        if weapon then
            local label = weapon:FindFirstChild("WeaponName")
            if label and label:IsA("TextLabel") then
                local knifeModel = self.config.knifeModel
                local selectedSkin = self.config.weaponSkins[knifeModel]
                local prefix = utf8.char(9733) .. " " .. knifeModel

                if selectedSkin and selectedSkin ~= "Default" then
                    label.Text = prefix .. " | " .. selectedSkin
                else
                    label.Text = prefix
                end
            end

            local meleeImage = weapon:FindFirstChild("Melee")
            if meleeImage and meleeImage:IsA("ImageLabel") then
                pcall(function()
                    local knifeModel = self.config.knifeModel
                    local weaponDb = self.repStore:FindFirstChild("Database")
                        and self.repStore.Database:FindFirstChild("Custom")
                        and self.repStore.Database.Custom:FindFirstChild("Weapons")
                    local weaponModule = weaponDb and weaponDb:FindFirstChild(knifeModel)
                    local weaponData = weaponModule and safeRequire(weaponModule)
                    if type(weaponData) == "table" and weaponData.Icon then
                        meleeImage.Image = weaponData.Icon
                    end
                end)
            end
        end
    end

    for _, child in ipairs(inventory:GetDescendants()) do
        if child:IsA("TextLabel") and child.Name == "WeaponName" then
            if not meleeSlot or not child:IsDescendantOf(meleeSlot) then
                local parts = string.split(child.Text, " | ")
                local baseName = (parts[1] or ""):gsub("%s+$", "")
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
    if not self.skinsRoot then
        return
    end

    local weaponModel = self:_getWeaponModel()
    if not weaponModel then
        return
    end

    local effectiveWeaponName = weaponModel.Name
    local shouldApply = false

    if BASE_KNIVES[effectiveWeaponName] then
        if self.config.knifeChangerEnabled then
            effectiveWeaponName = self.config.knifeModel
            shouldApply = true
        end
    elseif self.config.skinChangerEnabled then
        shouldApply = true
    end

    if not shouldApply then
        return
    end

    local selectedSkin = self.config.weaponSkins[effectiveWeaponName]
    if not selectedSkin or selectedSkin == "Default" then
        return
    end

    if weaponModel:GetAttribute("SkinChangerApplied") == selectedSkin then
        return
    end

    local weaponFolder = self.skinsRoot:FindFirstChild(effectiveWeaponName)
    local skinFolder = weaponFolder and weaponFolder:FindFirstChild(selectedSkin)
    local cameraFolder = skinFolder and skinFolder:FindFirstChild("Camera")
    local factoryNew = cameraFolder and cameraFolder:FindFirstChild("Factory New")
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

    weaponModel:SetAttribute("SkinChangerApplied", selectedSkin)
    self:_updateInventoryNames()
end

function Skinchanger:_applyGloves()
    if not self.config.gloveChangerEnabled then
        return
    end

    local gloveModel = self.config.gloveModel
    local selectedSkin = gloveModel and self.config.gloveSkins[gloveModel]
    if not gloveModel or not selectedSkin or selectedSkin == "Default" then
        return
    end

    local camera = self.services.Workspace.CurrentCamera
    if not camera or not self.skinsRoot then
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
    local leftGlove = leftArm and leftArm:FindFirstChild("Glove")
    local rightGlove = rightArm and rightArm:FindFirstChild("Glove")
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

    local gloveFolder = self.skinsRoot:FindFirstChild(gloveModel)
    local skinVariant = gloveFolder and gloveFolder:FindFirstChild(selectedSkin)
    local cameraFolder = skinVariant and skinVariant:FindFirstChild("Camera")
    local factoryNew = cameraFolder and cameraFolder:FindFirstChild("Factory New")
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
        self.pendingApply = true
        return
    end

    self.skinApplyDebounce = true
    self.pendingApply = false

    self.errorHandler:Spawn("Skinchanger TryApply", function()
        task.wait(0.2)
        self:_ensureKnifeHook()
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
        if self.pendingApply and self.running then
            self.pendingApply = false
            self:_tryApply()
        end
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

    if type(skinsLibrary) ~= "table" or type(viewmodelLibrary) ~= "table" then
        return false
    end

    if not skinsLibrary.GetCameraModel or not skinsLibrary.GetCharacterModel or not viewmodelLibrary.new then
        return false
    end

    local originalGetCameraModel = skinsLibrary.GetCameraModel
    skinsLibrary.GetCameraModel = function(weaponName, skinName, ...)
        local ok, result

        if self.config.knifeChangerEnabled and weaponName and BASE_KNIVES[weaponName] then
            local replacementWeapon = self.config.knifeModel
            local replacementSkin = getHookSkinName(self.config.weaponSkins[replacementWeapon])
            ok, result = pcall(originalGetCameraModel, replacementWeapon, replacementSkin, ...)
            if ok and result then
                return result
            end
        end

        ok, result = pcall(originalGetCameraModel, weaponName, skinName, ...)
        return ok and result or nil
    end

    local originalGetCharacterModel = skinsLibrary.GetCharacterModel
    skinsLibrary.GetCharacterModel = function(weaponName, skinName, ...)
        local ok, result

        if self.config.knifeChangerEnabled and weaponName and BASE_KNIVES[weaponName] then
            local replacementWeapon = self.config.knifeModel
            local replacementSkin = getHookSkinName(self.config.weaponSkins[replacementWeapon])
            ok, result = pcall(originalGetCharacterModel, replacementWeapon, replacementSkin, ...)
            if ok and result then
                return result
            end
        end

        ok, result = pcall(originalGetCharacterModel, weaponName, skinName, ...)
        return ok and result or nil
    end

    local originalViewmodelNew = viewmodelLibrary.new
    viewmodelLibrary.new = function(viewContext, weaponName, skinName, ...)
        local ok, result

        if self.config.knifeChangerEnabled and weaponName and BASE_KNIVES[weaponName] then
            local replacementWeapon = self.config.knifeModel
            local replacementSkin = getHookSkinName(self.config.weaponSkins[replacementWeapon])
            ok, result = pcall(originalViewmodelNew, viewContext, replacementWeapon, replacementSkin, ...)
            if ok and result then
                return result
            end
        end

        ok, result = pcall(originalViewmodelNew, viewContext, weaponName, skinName, ...)
        return ok and result or nil
    end

    if skinsLibrary.GetGloves then
        local originalGetGloves = skinsLibrary.GetGloves
        skinsLibrary.GetGloves = function(gloveName, skinName)
            local ok, result

            if self.config.gloveChangerEnabled and self.config.gloveModel then
                local replacementGlove = self.config.gloveModel
                local replacementSkin = getHookSkinName(self.config.gloveSkins[replacementGlove])
                ok, result = pcall(originalGetGloves, replacementGlove, replacementSkin)
                if ok and result then
                    return result
                end
            end

            ok, result = pcall(originalGetGloves, gloveName, skinName)
            return ok and result or nil
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
    local available = {}

    for _, model in ipairs(KNIFE_MODELS) do
        if self.weaponOptions[model] then
            available[#available + 1] = model
        end
    end

    return available
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

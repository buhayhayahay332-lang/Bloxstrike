return function(services)
    local globals = {}
    local player = services.Players.LocalPlayer

    local function getCharactersFolder()
        return services.Workspace:FindFirstChild("Characters")
            or services.Workspace:WaitForChild("Characters", 10)
    end

    function globals:GetPlayer()
        return player
    end

    function globals:GetCamera()
        return services.Workspace.CurrentCamera
    end

    function globals:GetCharactersFolder()
        return getCharactersFolder()
    end

    function globals:GetTFolder()
        local folder = getCharactersFolder()
        return folder and folder:FindFirstChild("Terrorists") or nil
    end

    function globals:GetCTFolder()
        local folder = getCharactersFolder()
        return folder and folder:FindFirstChild("Counter-Terrorists") or nil
    end

    function globals:IsAlive()
        local tFolder = self:GetTFolder()
        local ctFolder = self:GetCTFolder()

        return (tFolder and tFolder:FindFirstChild(player.Name))
            or (ctFolder and ctFolder:FindFirstChild(player.Name))
            or nil
    end

    function globals:GetEnemyFolder()
        local myModel = self:IsAlive()
        if not myModel then
            return nil
        end

        local tFolder = self:GetTFolder()
        local ctFolder = self:GetCTFolder()

        if tFolder and tFolder:FindFirstChild(player.Name) then
            return ctFolder
        end

        if ctFolder and ctFolder:FindFirstChild(player.Name) then
            return tFolder
        end

        return nil
    end

    function globals:IsEnemyModel(model)
        local enemyFolder = self:GetEnemyFolder()
        return enemyFolder ~= nil and model ~= nil and model.Parent == enemyFolder
    end

    function globals:IsMyModel(model)
        return model ~= nil and model.Name == player.Name and model == self:IsAlive()
    end

    function globals:GetTargetModels(teamCheck)
        local models = {}

        if teamCheck ~= false then
            local enemyFolder = self:GetEnemyFolder()
            if enemyFolder then
                for _, model in ipairs(enemyFolder:GetChildren()) do
                    models[#models + 1] = model
                end
            end

            return models
        end

        local tFolder = self:GetTFolder()
        local ctFolder = self:GetCTFolder()

        for _, folder in ipairs({ tFolder, ctFolder }) do
            if folder then
                for _, model in ipairs(folder:GetChildren()) do
                    if not self:IsMyModel(model) then
                        models[#models + 1] = model
                    end
                end
            end
        end

        return models
    end

    return globals
end

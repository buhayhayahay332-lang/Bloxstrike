local Cleaner = {}
Cleaner.__index = Cleaner

function Cleaner.new()
    return setmetatable({
        tasks = {},
    }, Cleaner)
end

function Cleaner:Give(task)
    if task == nil then
        return nil
    end

    self.tasks[#self.tasks + 1] = task
    return task
end

function Cleaner:_cleanupTask(task)
    local taskType = typeof(task)

    if taskType == "RBXScriptConnection" then
        if task.Connected then
            task:Disconnect()
        end
        return
    end

    if taskType == "Instance" then
        if task.Parent ~= nil then
            task:Destroy()
        end
        return
    end

    if type(task) == "function" then
        task()
        return
    end

    if type(task) == "table" then
        if type(task.Destroy) == "function" then
            task:Destroy()
        elseif type(task.Cleanup) == "function" then
            task:Cleanup()
        elseif type(task.Remove) == "function" then
            task:Remove()
        end
    end
end

function Cleaner:Cleanup()
    for index = #self.tasks, 1, -1 do
        local task = self.tasks[index]
        self.tasks[index] = nil
        pcall(function()
            self:_cleanupTask(task)
        end)
    end
end

return Cleaner

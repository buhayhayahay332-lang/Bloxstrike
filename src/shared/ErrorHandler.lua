local ErrorHandler = {}
ErrorHandler.__index = ErrorHandler

local unpackValues = unpack or table.unpack

function ErrorHandler.new(services)
    return setmetatable({
        services = services,
        failed = false,
    }, ErrorHandler)
end

function ErrorHandler:_format(label, err)
    local prefix = label and (tostring(label) .. ": ") or ""
    local text = prefix .. tostring(err)

    if debug and debug.traceback then
        return text .. "\n" .. debug.traceback()
    end

    return text
end

function ErrorHandler:Fail(label, err)
    if self.failed then
        return
    end

    self.failed = true
    local detailedMessage = "[Bloxtrike] " .. self:_format(label, err)
    local shortLabel = label and tostring(label) or "Runtime Error"
    local shortMessage = "[Bloxtrike] " .. shortLabel

    warn(detailedMessage)

    local player = self.services and self.services.Players and self.services.Players.LocalPlayer
    if player then
        pcall(function()
            player:Kick(shortMessage)
        end)
    end
end

function ErrorHandler:Wrap(label, fn)
    return function(...)
        local args = { ... }
        local ok, result = xpcall(function()
            return fn(unpackValues(args))
        end, function(err)
            return self:_format(label, err)
        end)

        if not ok then
            self:Fail(label, result)
            return nil
        end

        return result
    end
end

function ErrorHandler:Connect(signal, label, fn)
    return signal:Connect(self:Wrap(label, fn))
end

function ErrorHandler:Spawn(label, fn)
    return task.spawn(self:Wrap(label, fn))
end

return ErrorHandler

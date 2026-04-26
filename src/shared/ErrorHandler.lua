local ErrorHandler = {}
ErrorHandler.__index = ErrorHandler

local unpackValues = unpack or table.unpack

local function sanitizeOneLine(text, maxLen)
    local line = tostring(text or ""):gsub("[\r\n]+", " ")
    line = line:gsub("%s+", " ")
    line = line:gsub("[^\32-\126]", "?")
    line = line:gsub("^%s+", ""):gsub("%s+$", "")
    maxLen = maxLen or 120
    if #line > maxLen then
        line = line:sub(1, maxLen - 3) .. "..."
    end
    return line
end

local function compactReason(err)
    local text = tostring(err or "")
    local firstLine = text:match("([^\r\n]+)") or text
    firstLine = firstLine:gsub("^%[Bloxtrike%]%s*", "")
    firstLine = firstLine:gsub("^.-:%s*", function(prefix)
        if prefix:find(":%d+:") then
            return prefix
        end
        return ""
    end)
    return sanitizeOneLine(firstLine)
end

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
    local shortLabel = sanitizeOneLine(label or "Runtime Error", 50)
    local reason = compactReason(err)
    local shortMessage = "[Bloxtrike] " .. shortLabel
    if reason ~= "" then
        shortMessage = shortMessage .. " | " .. reason
    end

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

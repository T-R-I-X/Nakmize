--@@ Author Trix

-- Modules
local config = require "config"

-- Public
local function split(s, delimiter)
    local result = {};

    for match in (s .. delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end

    return result;
end

return {
    Name = "messageCreate",
    Run = function (message)
        local client = _G.Client

        if message.author.bot then return end

        local commandName = string.sub(message.content, #config.Prefix + 1)

        local args = split(commandName, " ")

        for iteration, item in ipairs(args) do
            if item == commandName then
                args[iteration] = nil

                break
            end
        end

        local commandNameOnce = false
        for _, arg in ipairs(args) do
            if arg ~= commandName or commandNameOnce == true then
                commandName = split(commandName, arg)

                commandName = table.concat(commandName, " ")
            else
                commandNameOnce = true
            end
        end

        local command = client._Commands[commandName]

        if command and not command.Disabled == true then
            command.Run(client, args, message)
        else
            for _, alias in ipairs(client._Commands) do
                if alias.Aliases[commandName] and alias.Disabled[commandName] ~= true then
                    alias.Aliases[commandName].Run(client, args, message)

                    break
                end
            end
        end
    end
}
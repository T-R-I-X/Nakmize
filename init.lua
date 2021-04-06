--@@ Author Trix

-- Modules
local discordia = require "discordia";
local lfs = require "lfs";
local config = require "config";

-- Objects
local client = discordia.Client()
local commandDir = [[./cmds]]
local eventDir = [[./events]]

client._Commands = {}

-- Iter through the command folder

local function loadCommands(path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file

            local attr = lfs.attributes(f)

            assert(type(attr) == "table")

            print(attr.mode)
            if attr.mode == "directory" then
                loadCommands(f)
            else
                local commandFile = require(f)

                print(commandFile.Name, string.lower(commandFile.Name))

                client._Commands[string.lower(commandFile.Name)] = commandFile
            end
        end
    end
end

local function loadEvents(path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file

            local attr = lfs.attributes(f)

            assert(type(attr) == "table")

            if attr.mode == "directory" then
                loadEvents(f)
            else
                local eventFile = require(f)

                client:on(eventFile.Name, eventFile.Run)
            end
        end
    end
end

loadCommands "./cmds";
loadEvents "./events";

_G.Client = client

client:run("Bot " .. config.Token)
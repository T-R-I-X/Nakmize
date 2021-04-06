return {
    Name = "Help",
    Aliases = {},
    Disabled = false,

    Run = function (client, args, message)
        message:reply("Sorry disabled right now")
    end
}
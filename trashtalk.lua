local Lua = {
    Connections = {}
}

local Game = game
local WaitForChild = Game.WaitForChild
local GetService = Game.GetService

local HookMetaMethod = hookmetamethod
local GetNamecallMethod = getnamecallmethod
local CheckCaller = checkcaller

local Clear = table.clear

local Spawn = task.spawn

local Random = math.random

local Infinite = 1 / 0

local ReplicatedStorage = GetService(Game, "ReplicatedStorage")
local TextChatService = GetService(Game, "TextChatService")

local TextChat = TextChatService.TextChannels.RBXGeneral

local Events = WaitForChild(ReplicatedStorage, "Events", Infinite)
local FinishEvent = WaitForChild(Events, "XMHH2.2", Infinite)

local Messages = {
    "lol get owned by constant",
    "getconstant cc",
    "garbage cheat",
    "5$ cheat? terrible",
    "1",
    "dang you suck huh",
    "tap me bud",
    "pulse user? XD",
    "trash",
    "pasteohub.xyz",
    "pulse.paste",
    "love to see a detected + non tapping cheat",
    "get good, get constant",
    "femware user? nice."
}

Lua.Load = function(Modules)
    local Menu = Modules.Menu
    local Flags = Menu.Flags

    local MiscTab = Menu.Window.Find("Miscellaneous")

    local GeneralSection = MiscTab:Find("General")
    local OtherSection = GeneralSection:Find("Other")

    OtherSection:Toggle({
        Name = "Trash Talk",
        Flag = "Trash Talk"
    })

    local Namecall; Namecall = HookMetaMethod(Game, "__namecall", function(Self, ...)
        local Args = { ... }
        local Method = GetNamecallMethod()

        if
            not CheckCaller() and
            Self == FinishEvent and
            Method == "FireServer" and
            Args[4] == "2389ZFX34" and
            Flags["Trash Talk"].Value
        then
            Spawn(function()
                TextChat:SendAsync(Messages[Random(1, #Messages)])
            end)
        end

        return Namecall(Self, ...)
    end)
end

Lua.Unload = function()
    for i = 1, #Lua.Connections do
        Lua.Connections[i]:Disconnect()
    end

    Clear(Lua.Connections)
end

return Lua

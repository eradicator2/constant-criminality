local Lua = {
    Hooks = {}
}

local Game = game
local WaitForChild = Game.WaitForChild
local GetService = Game.GetService

local ReplicatedStorage = GetService(Game, "ReplicatedStorage")

Lua.Load = function(Modules)
    local Menu = Modules.Menu
    local Flags = Menu.Flags

    local MiscTab = Menu.Window.Find("misc")
    local ModsSection = MiscTab.Find("gun mods")

    if not Flags["Recoil Percent"] then
        ModsSection.Slider({
            Name = "recoil adjustment",
            Flag = "Recoil Percent",
            Min = 0, Max = 100, Default = 100,
            Specials = {"normal", 100},
            Prefix = "%"
        })
    end

    if not Flags["Spread Percent"] then
        ModsSection.Slider({
            Name = "spread adjustment",
            Flag = "Spread Percent",
            Min = 0, Max = 100, Default = 100,
            Specials = {"normal", 100},
            Prefix = "%"
        })
    end

    local GetConfig = require(WaitForChild(ReplicatedStorage.NewModules.Shared.Extensions, "GetConfig", 1 / 0))

    Lua.Hooks[#Lua.Hooks + 1] = GetConfig

    hookfunction(GetConfig, function(Tool)
        local GunData = {}
        local Config = require(WaitForChild(Tool, "Config", 1 / 0))

        for Index, Value in pairs(Config) do
            if
                Index == "Recoil" or
                string.find(Index, "_Max") or
                string.find(Index, "_Min")
            then
                GunData[Index] = Value * (Flags["Recoil Percent"].Value / 100)

                continue
            end

            if Index == "Spread" then
                GunData[Index] = Value * (Flags["Spread Percent"].Value / 100)

                continue
            end

            GunData[Index] = Value
        end

        return GunData
    end)
end

Lua.Unload = function()
    for i = 1, #Lua.Hooks do
        restorefunction(Lua.Hooks[i])
    end
end

return Lua

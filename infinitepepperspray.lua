local Lua = {
    Connections = {}
}

local Game = game
local WaitForChild = Game.WaitForChild
local IsA = Game.IsA
local GetService = Game.GetService

local Players = GetService(Game, "Players")
local LocalPlayer = Players.LocalPlayer

local Infinite = 1 / 0

Lua.Load = function(Modules)
    local Menu = Modules.Menu
    local Flags = Menu.Flags

    local MiscTab = Menu.Window.Find("misc")
    local ModsSection = MiscTab.Find("player mods")

    ModsSection.Toggle({
        Name = "infinite pepper-spray",
        Flag = "Infinite Pepper Enabled"
    })

    function Lua.CharacterAdded(Character)
        Lua.Connections["ChildAdded"] = Character.ChildAdded:Connect(function(Child)
            if not Flags["Infinite Pepper Enabled"].Value then return end

            if IsA(Child, "Tool") and Child.Name == "Pepper-spray" then
                local Ammo = WaitForChild(Child, "Ammo", Infinite)

                Ammo.MaxValue = 9223372036854775807
                Ammo.Value = 9223372036854775807
            end
        end)
    end

    Lua.Connections["CharacterAdded"] = LocalPlayer.CharacterAdded:Connect(Lua.CharacterAdded)
    if LocalPlayer.Character then
        Lua.CharacterAdded(LocalPlayer.Character)
    end
end

Lua.Unload = function()
    for _, Connection in next, Lua.Connections do
        Connection:Disconnect()
    end
end

return Lua

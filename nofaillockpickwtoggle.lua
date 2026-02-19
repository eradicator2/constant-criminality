local Lua = {}

Lua.Load = function(Modules)
    local Menu = Modules.Menu
    local Flags = Menu.Flags
    local MiscTab = Menu.Window.Find("misc")
    local ModsSection = MiscTab.Find("player mods")

    if Flags["no lockpick fail"] == nil then
        Flags["no lockpick fail"] = false
    end

    local function checkLockPickGUI()
        for _, child in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
            if child.Name == "LockpickGUI" then
                local scale = Flags["no lockpick fail"] and 10 or 1
                child.MF["LP_Frame"].Frames.B1.Bar.UIScale.Scale = scale
                child.MF["LP_Frame"].Frames.B2.Bar.UIScale.Scale = scale
                child.MF["LP_Frame"].Frames.B3.Bar.UIScale.Scale = scale
            end
        end
    end

    checkLockPickGUI()

    ModsSection.Toggle({
        Name = "no lockpick fail",
        Flag = "no lockpick fail",
        Default = false,
        Callback = function(State)
            Flags["no lockpick fail"] = State
            checkLockPickGUI()
        end
    })

    game:GetService("RunService").Heartbeat:Connect(checkLockPickGUI)
end

Lua.Unload = function()
    for _, child in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
        if child.Name == "LockpickGUI" then
            child.MF["LP_Frame"].Frames.B1.Bar.UIScale.Scale = 1
            child.MF["LP_Frame"].Frames.B2.Bar.UIScale.Scale = 1
            child.MF["LP_Frame"].Frames.B3.Bar.UIScale.Scale = 1
        end
    end
end

return Lua

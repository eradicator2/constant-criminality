local function IsEnabled(SettingsTable, Key)
    return SettingsTable[Key] == true
end

local function FireServerHook(Remote, ...)
    local Args = {...}
    local EventName = "FireServer"
    
    if Remote == RemotesList.Ragdoll then
        local SettingsValue = Settings['Adjustments'].Value
        
        if (Args[1] == "L_packlllD" or Args[1] == 'FllH') and IsEnabled(SettingsValue, "No Fall Damage") then
            return
        end
        if (Args[1] == "G_Gh") and IsEnabled(SettingsValue, "No Grinder") then
            return
        end
        if (Args[1] == "SSsH") and IsEnabled(SettingsValue, 'No Spikes') then
            return
        end
        if (Args[1] == 'BHHh') and IsEnabled(SettingsValue, "No Barbed Wire") then
            return
        end
        if (Args[1] == 'Tt__h') and IsEnabled(SettingsValue, "No Trampoline") then
            return
        end
        if (Args[1] == '__---r' or Args[1] == "-r__r3") and IsEnabled(SettingsValue, "No Ragdoll") then
            return
        end
        if (Args[1] == 'KL_B' or Args[1] == "HITRGP") and IsEnabled(SettingsValue, "No Kill Brick") then
            return
        end
    end

    if MethodName == "MOVZREP" and IsEnabled(Settings["Adjustments"].Value, 'Silent Footsteps') then
        local State = Args[1]
        State[2] = false
        State[3] = true
        State[4] = 7.9
        Args[1] = State
        return CallOriginal(Remote, unpack(Args))
    end

    if Remote == RemotesList.MeleeHitReg and Args[4] == '2389ZFX34' and Settings['Force Hitbox Enabled'].Value then
        local TargetPart = Args[8]
        local HitboxConfig = Settings["Force Hitboxes"].Value
        if TargetPart then
            local Character = FindByCharacter(TargetPart.Parent)
            if Character then
                local RedirectedPart = Character.BodyParts[HitboxConfig[Random(1, #HitboxConfig)]] or TargetPart
                Args[8] = RedirectedPart
                return CallOriginal(Remote, unpack(Args))
            end
        end
    end

    if Remote == RemotesList.GunShoot and Settings['Release Choked Packets'].Value then
        CallOriginal(Remote, ...)
        env:SetOutgoingKBPSLimit(0)
        return
    end

    return CallOriginal(Remote, ...)
end

local function RaycastHook(Origin, Direction, Params)
    if Settings['Reach Enabled'].Value then
        Direction = Direction * Settings['Reach Distance'].Value
        return CallOriginal(Origin, Direction, Params)
    end
    return CallOriginal(Origin, Direction, Params)
end

local function SoundPlayHook(Sound)
    if Sound.Name == "HitmarkerSound" and Settings["Hitsound"].Value ~= "Default" then
        local CustomSound = Cache.Hitsound:Clone()
        CustomSound.Parent = BulletsFolder
        CustomSound:Play()
        return
    end
    
    if Sound.Name == "kill_sound" and Settings["Killsound"].Value ~= "Default" then
        local CustomSound = Cache.Killsound:Clone()
        CustomSound.Parent = BulletsFolder
        CustomSound:Play()
        return
    end
end

local AntiCheatBypass = function(self)
    local env = VM[0]
    local arg1 = VM[2]
    local arg2 = VM[1]
    return function()
        local VM = arg2
        for i = 1, #VM do
            local arg3 = VM[i]
            local type_arg3 = type(arg3)
            if type_arg3 == "table" then
                if type(rawget(arg3, "Detected")) == "function" and not rawget(arg3, 'GP2') then
                    Env.Adonis = rawget(arg3, "Detected")
                elseif type(rawget(arg3, "AX1")) == 'function' and type(rawget(arg3, 'GP2')) == 'function' then
                    Env.AC = arg3
                elseif type(rawget(arg3, 'CastRay')) == "function" and type(rawget(arg3, 'SetUp')) == "function" then
                    Env.CastRay = arg3.CastRay
                end
            end
            if type_arg3 == "function" then
                local name = arg1[arg3].name
                if name == 'Flashed' then
                    Env.Flashed = arg3
                elseif name == 'ShellShock' then
                    Env.ShellShock = arg3
                elseif name == "StunEffect" then
                    Env.StunEffect = arg3
                elseif name == 'S_Get' then
                    Env.SGet = arg3
                elseif name == "DoTweak" then
                    Env.DoTweak = arg3
                end
            end
        end
        VM = nil
    end
end

if MethodName == "PV87128" and Settings['Disable PVeye'].Value then
    return
end

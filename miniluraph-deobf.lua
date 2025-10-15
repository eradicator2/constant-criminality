local module = {
    _VERSION = "1.0",
    _DESCRIPTION = "Game Mechanics Modifier"
}

-- Bitwise operations
module.bit32 = {
    rrotate = bit32.rrotate,
    bor = bit32.bor,
    countlz = bit32.countlz
}

-- Utility functions
function module.tableSet(tbl, index, value)
    tbl[index] = value
end

function module.unpackValues(context, ...)
    local values = {...}
    local results = {}
    for i = 1, #values do
        results[i] = values[i][1][10](context)
    end
    return unpack(results)
end

function module.handleDataArray(parent, key, value)
    local data = parent[1][17][key]
    local size = #data
    if value ~= parent[1][30] then
        local result = parent:OP(value)
        if result then
            return {parent.W(result)}, data, size
        end
    end
    data[size + 1] = value
    return nil, data, 0, size
end

function module.countArrayElements(arr)
    local count = arr[1][32]()
    if count >= arr[2] then
        return {count - arr[1][22]}
    end
    return {count}
end

function module.initTable(arr)
    local newTable = {}
    arr[1] = nil
    arr[2] = nil
    arr[3] = nil
    return 35, newTable
end

function module.processGameState(self, state, config, data)
    while true do
        if state == 35 then
            data[1] = 1.0
            if not config[13549] then
                state = self:u(config, state)
            else
                state = self:O(config, state)
            end
        elseif state == 38 then
            state = self:Z(config, data, state)
        elseif state == 77 then
            self:p(data)
            break
        end
    end
    
    data[4] = 4503599627370496
    data[5] = self.y
    data[6] = self.gt
    data[7] = nil
    
    local settings = {}
    data[6] = self.gt
    
    if not config[1754] then
        state = 86 + self:It(self:ot(self:Ft(self:Gt(self.r[6], state), self.r[3], self.r[7]), self.r[6]))
        config[1754] = state
    else
        state = config[1754]
    end
    
    self:L(data)
    return state, settings
end

function module.configureModule(self, config, settings)
    settings[8] = string.gsub
    settings[9] = nil
    settings[10] = nil
    settings[11] = nil
    
    local result = self:N(102, settings, config)
    self:c(settings)
    return result
end

function module.getGameValue(self, category, index, context)
    if context < 131.0 then
        category = index[1][11][context]
    end
    local value = self:SP(index, category)
    return category, value
end

function module.initGameValues(context)
    local values = {
        context[1][33](),
        context[1][33]()
    }
    return values[1], values[2], nil, nil, nil, 121
end

function module.getConfigValue(self, config, callback)
    local value = callback()
    if not config[1592] then
        config[18389] = 0x34d133A5 + (config[7696] - self.r[9] - self.r[7] - config[8214] + self.r[1])
        value = 92 + self:Vt(self:Qt(self.r[6] + config[1820])) + config[17831]
        config[1592] = value
    else
        value = self:ht(value, config)
    end
    return value
end

-- Main game hook
function module.createGameHook(context)
    local config = context.Adjustments
    local soundSettings = context.DisablePVP
    local reachSettings = context.ReachEnabled
    local soundCache = context.SoundCache
    local bodyParts = context.BodyParts
    local player = context.Player
    local character = context.Character
    local eventLog = context.EventLog
    local weapons = context.Weapons
    local hitReg = context.HitReg
    local ragdoll = context.Ragdoll
    local events = context.Events
    local utils = context.Utils
    local remotes = context.Remotes
    
    return function(event, ...)
        local args = {...}
        local eventType = remotes:GetEventType(event)
        local playerName = tostring(player)
        local eventName = tostring(event)
        
        if eventType == "FireServer" then
            -- Ragdoll events
            if event == weapons.Ragdoll then
                local setting = config.Value
                if (args[1] == "FallD" or args[1] == "FallH") and string.find(setting, "No Fall Damage") then
                    return
                elseif args[1] == "G_Gh" and string.find(setting, "No Grinder") then
                    return
                elseif args[1] == "SSsH" and string.find(setting, "No Spikes") then
                    return
                elseif args[1] == "BHHh" and string.find(setting, "No Barbed Wire") then
                    return
                elseif args[1] == "Tt__h" and string.find(setting, "No Trampoline") then
                    return
                elseif (args[1] == "__--r" or args[1] == "-r_r3") and string.find(setting, "No Ragdoll") then
                    return
                elseif (args[1] == "KL_B" or args[1] == "HITRGP") and string.find(setting, "No Kill Brick") then
                    return
                end
            end
            
            -- Disable PVP
            if eventName == "PV870128" and soundSettings.Value then
                return
            end
            
            -- Silent footsteps
            if eventName == "MOVZREP" and string.find(config.Value, "Silent Footsteps") then
                local data = args[1]
                data[2] = false
                data[3] = true
                data[4] = 7.9
                args[1] = data
                return events[1][events[3]](event, utils.Unpack(args))
            end
            
            -- Hitbox modifier
            if event == weapons.MeleeHitReg and args[4] == "2389ZFX34" and reachSettings.Value then
                local target = args[8]
                if target then
                    local enemy = utils.FindByCharacter(target.Parent)
                    if enemy then
                        local part = enemy.BodyParts[bodyParts[math.random(1, #bodyParts)]] or target
                        args[8] = part
                        return events[1][events[3]](event, utils.Unpack(args))
                    end
                end
            end
        elseif eventType == "Play" then
            -- Sound replacements
            if string.find(eventName, "Sound") then
                if eventName == "HitmarkerSound" and soundSettings.Hitsound.Value ~= "Default" then
                    events[1][events[3]](event, ...)
                    local sound = soundCache.Hitsound:Clone()
                    sound.Parent = player.Bullets
                    sound:Play()
                    return
                end
                
                if eventName == "kill_sound" and soundSettings.Killsound.Value ~= "Default" then
                    events[1][events[3]](event, ...)
                    local sound = soundCache.Killsound:Clone()
                    sound.Parent = player.Bullets
                    sound:Play()
                    return
                end
            end
        elseif eventType == "Raycast" then
            -- Reach extender
            if playerName == "Client" and eventType == "Raycast" and reachSettings.Value then
                args[2] = args[2] * reachSettings.Distance.Value
                return events[1][events[3]](event, utils.Unpack(args))
            end
        end
        
        -- Default behavior
        return events[1][events[3]](event, ...)
    end
end

return module

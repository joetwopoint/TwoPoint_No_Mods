local TURBO_MOD_TYPE = 18 -- native mod type for turbo

local lastVehicle = 0
local warnedForVehicle = false

local function isEmergencyVehicle(veh)
    if not DoesEntityExist(veh) then return false end

    local class = GetVehicleClass(veh)
    if Config.BlockedClasses[class] then
        return true
    end

    if Config.ExtraModels and next(Config.ExtraModels) ~= nil then
        local model = GetEntityModel(veh)
        -- Get model name as string (e.g. "POLICE") then lowercase
        local name = string.lower(GetDisplayNameFromVehicleModel(model) or "")
        if Config.ExtraModels[name] then
            return true
        end
    end

    return false
end

local function ensureModKit(veh)
    -- Some vehicles report -1 until we set kit 0.
    local kit = GetVehicleModKit(veh)
    if kit == -1 then
        SetVehicleModKit(veh, 0)
    end
end

local function forceNoTurbo(veh)
    if not DoesEntityExist(veh) then return end

    ensureModKit(veh)

    -- 1) Turn off the toggle turbo flag
    if IsToggleModOn(veh, TURBO_MOD_TYPE) then
        ToggleVehicleMod(veh, TURBO_MOD_TYPE, false)
    end

    -- 2) Clear the turbo mod slot (in case menu used SetVehicleMod)
    local curTurboMod = GetVehicleMod(veh, TURBO_MOD_TYPE)
    if curTurboMod ~= -1 then
        SetVehicleMod(veh, TURBO_MOD_TYPE, -1, false)
    end

    -- Debug if needed
    -- if IsToggleModOn(veh, TURBO_MOD_TYPE) then
    --     print(("[no_emergency_turbo] Warning: turbo still reported ON for vehicle %s"):format(veh))
    -- end
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)

            -- Only care if player is driving an emergency vehicle
            if GetPedInVehicleSeat(veh, -1) == ped and isEmergencyVehicle(veh) then
                -- New vehicle? reset warning flag.
                if veh ~= lastVehicle then
                    lastVehicle = veh
                    warnedForVehicle = false
                end

                -- Enforce NO turbo constantly
                forceNoTurbo(veh)

                if Config.ShowMessage and not warnedForVehicle then
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0 },
                        multiline = false,
                        args = { 'SYSTEM', Config.MessageText }
                    })
                    warnedForVehicle = true
                end

                -- While in an emergency vehicle we enforce fairly often
                Wait(250)
            else
                lastVehicle = 0
                warnedForVehicle = false
                Wait(Config.CheckInterval or 1000)
            end
        else
            lastVehicle = 0
            warnedForVehicle = false
            Wait(Config.CheckInterval or 1000)
        end
    end
end)

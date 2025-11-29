local TURBO_MOD_TYPE = 18 -- native mod type for turbo

local PERF_MOD_TYPES = {
    [11] = true, -- Engine
    [12] = true, -- Brakes
    [13] = true, -- Transmission
    [15] = true, -- Suspension
}

local lastVehicle = 0
local warnedForVehicle = false

local function isEmergencyVehicle(veh)
    if not DoesEntityExist(veh) then return false end

    local class = GetVehicleClass(veh)

    if Config.UseVehicleClass and Config.BlockedClasses[class] then
        return true
    end

    if Config.UseSirenCheck and DoesVehicleHaveSiren(veh) then
        return true
    end

    if Config.ExtraModels and next(Config.ExtraModels) ~= nil then
        local model = GetEntityModel(veh)
        local name = string.lower(GetDisplayNameFromVehicleModel(model) or "")
        if Config.ExtraModels[name] then
            return true
        end
    end

    return false
end

local function ensureModKit(veh)
    -- Some vehicles report -1 until we explicitly set kit 0.
    local kit = GetVehicleModKit(veh)
    if kit == -1 then
        SetVehicleModKit(veh, 0)
    end
end

local function clearModSlot(veh, slot)
    local current = GetVehicleMod(veh, slot)
    if current ~= -1 then
        SetVehicleMod(veh, slot, -1, false)
    end
end

local function forceNoPerformanceMods(veh)
    if not DoesEntityExist(veh) then return end

    ensureModKit(veh)

    -- Turbo is a toggle mod
    if Config.BlockTurbo then
        if IsToggleModOn(veh, TURBO_MOD_TYPE) then
            ToggleVehicleMod(veh, TURBO_MOD_TYPE, false)
        end
    end

    -- Engine and other performance mods
    if Config.BlockEngine then
        clearModSlot(veh, 11) -- engine
    end

    if Config.BlockOtherPerfMods then
        for slot, _ in pairs(PERF_MOD_TYPES) do
            if slot ~= 11 then -- engine already handled above
                clearModSlot(veh, slot)
            end
        end
    end

    -- Just in case something set power multipliers
    SetVehicleCheatPowerIncrease(veh, 0.0)
    SetVehicleEnginePowerMultiplier(veh, 0.0)
    SetVehicleEngineTorqueMultiplier(veh, 0.0)
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)

            if GetPedInVehicleSeat(veh, -1) == ped and isEmergencyVehicle(veh) then
                if veh ~= lastVehicle then
                    lastVehicle = veh
                    warnedForVehicle = false
                end

                -- Enforce NO performance mods constantly while driving emergency vehicle
                forceNoPerformanceMods(veh)

                if Config.ShowMessage and not warnedForVehicle then
                    TriggerEvent('chat:addMessage', {
                        color = { 255, 0, 0 },
                        multiline = false,
                        args = { 'SYSTEM', Config.MessageText }
                    })
                    warnedForVehicle = true
                end

                Wait(200)
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

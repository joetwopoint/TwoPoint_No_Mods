Config = {}

-- How often to check when NOT in an emergency vehicle (in ms)
Config.CheckInterval = 1000

-- Detection mode -----------------------------------------------------------

-- Treat these vehicle classes as emergency. 18 = Emergency by default.
Config.UseVehicleClass = true
Config.BlockedClasses = {
    [18] = true,  -- Emergency
}

-- Also treat ANY vehicle that has a siren as emergency.
-- This helps catch custom LEO/EMS vehicles that aren't class 18.
Config.UseSirenCheck = true

-- Extra model names (spawn/display names, lowercase) to always treat as emergency.
Config.ExtraModels = {
    -- ['police'] = true,
    -- ['police2'] = true,
    -- ['sheriff'] = true,
}

-- Blacklist: models here will NEVER be blocked, even if they match the rules above.
-- Use lowercase spawn/display names.
Config.BlacklistModels = {
     ['tillertrailer'] = true,
     ['tiller'] = true,
}

-- What to block ------------------------------------------------------------

-- Block turbo toggle on emergency vehicles
Config.BlockTurbo = true

-- Block engine upgrades (mod type 11)
Config.BlockEngine = true

-- Optionally block other performance mods too (brakes, transmission, suspension)
Config.BlockOtherPerfMods = false  -- set to true if you want *all* perf mods locked

-- Message settings ---------------------------------------------------------

Config.ShowMessage = true
Config.MessageText = 'Performance mods (engine/turbo) are disabled on emergency vehicles on this server.'

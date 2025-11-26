Config = {}

-- How often to check the player’s current vehicle (in ms)
Config.CheckInterval = 1000

-- Vehicle classes that should NOT be allowed to have turbo.
-- 18 = Emergency
Config.BlockedClasses = {
    [18] = true,  -- Emergency vehicles
}

-- Optional: extra models that should be treated as "emergency" even if not class 18.
-- Use lowercase display names (e.g. 'police', 'sheriff', 'police2').
Config.ExtraModels = {
    -- ['police'] = true,
    -- ['police2'] = true,
    -- ['sheriff'] = true,
}

-- Message settings
Config.ShowMessage = true
Config.MessageText = 'Turbos are disabled on emergency vehicles on this server.'

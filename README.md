# no_emergency_turbo
**Author:** TwoPoint Development  
**Version:** 1.3.0

Blocks performance mods (turbo + engine, optionally brakes/transmission/suspension) on emergency vehicles, even if players use vMenu / LS Customs to apply them.

This version adds a **blacklist**, so specific vehicle models can be exempted from blocking even if they otherwise match the emergency rules.

---

## Installation

1. Drop the `no_emergency_turbo` folder into your `resources/` directory.
2. In your `server.cfg`, make sure it starts *after* vMenu:
   ```cfg
   ensure vMenu
   ensure no_emergency_turbo
   ```

---

## Configuration (`config.lua`)

### Detection

- `Config.UseVehicleClass` – if true, uses `Config.BlockedClasses` to detect emergency vehicles (default: class `18`).
- `Config.BlockedClasses` – map of vehicle classes that count as emergency; by default `[18] = true`.

- `Config.UseSirenCheck` – if true, **any vehicle that has a siren** (`DoesVehicleHaveSiren`) is treated as emergency. Good for custom LEO/EMS vehicles.

- `Config.ExtraModels` – table of extra spawn/display names (lowercase) to always treat as emergency.

- `Config.BlacklistModels` – table of spawn/display names (lowercase) that are **never** blocked, even if they would count as emergency by the rules above.  
  Example:
  ```lua
  Config.BlacklistModels = {
      ['firechief'] = true,
      ['admincrownvic'] = true,
  }
  ```

### What gets blocked

- `Config.BlockTurbo` – blocks turbo toggle (mod type 18). Default: `true`.
- `Config.BlockEngine` – blocks engine upgrades (mod type 11). Default: `true`.
- `Config.BlockOtherPerfMods` – if `true`, also blocks brakes, transmission, and suspension (mod types 12, 13, 15). Default: `false`.

### Message

- `Config.ShowMessage` – whether to show a chat message the first time performance mods are stripped for the current emergency vehicle.
- `Config.MessageText` – text of that message.

---

## How it works

- Every tick while you are driving:
  - Script checks if your current vehicle is considered emergency (by class, siren, or extra model list) **and not blacklisted**.
  - If yes, it:
    - Forces turbo toggle off (if enabled in config).
    - Clears engine mod (and optionally other performance mods) back to stock.
    - Resets engine power multipliers to 0.
  - Shows a one-time warning message per vehicle if configured.

Use `Config.BlacklistModels` when you want certain emergency-ish vehicles to be allowed to keep their performance mods.

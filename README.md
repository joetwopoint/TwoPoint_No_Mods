# no_emergency_turbo
**Author:** TwoPoint Development  
**Version:** 1.2.0

Blocks performance mods (turbo + engine, optionally brakes/transmission/suspension) on emergency vehicles, even if players use vMenu / LS Customs to apply them.

This script does **not** modify vMenu itself; instead it constantly enforces "no performance mods" on any vehicle treated as emergency.

---

## Installation

1. Drop the `TwoPoint_no_turbo` folder into your `resources/` directory.
2. In your `server.cfg`, make sure it starts *after* vMenu:
   ```cfg
   ensure vMenu
   ensure TwoPoint_no_turbo
   ```

---

## Configuration (`config.lua`)

### Detection

- `Config.UseVehicleClass` – if true, uses `Config.BlockedClasses` to detect emergency vehicles (default: class `18`).
- `Config.BlockedClasses` – map of vehicle classes that count as emergency; by default `[18] = true`.

- `Config.UseSirenCheck` – if true, **any vehicle that has a siren** (`DoesVehicleHaveSiren`) is treated as emergency. This is recommended for custom LEO/EMS vehicles that might not be class 18.

- `Config.ExtraModels` – table of extra spawn/display names (lowercase) to always treat as emergency.

### What gets blocked

- `Config.BlockTurbo` – blocks turbo toggle (mod type 18). Default: `true`.
- `Config.BlockEngine` – blocks engine upgrades (mod type 11). Default: `true`.
- `Config.BlockOtherPerfMods` – if `true`, also blocks brakes, transmission, and suspension (mod types 12, 13, 15). Default: `false`.

You can enable `BlockOtherPerfMods` if you want emergency vehicles to stay completely stock in terms of performance.

### Message

- `Config.ShowMessage` – whether to show a chat message the first time performance mods are stripped for the current emergency vehicle.
- `Config.MessageText` – text of that message.

---

## How it works

- Every tick while you are driving:
  - Script checks if your current vehicle is considered emergency (by class, siren, or extra model list).
  - If yes, it:
    - Forces turbo toggle off (if enabled in config).
    - Clears engine mod (and optionally other performance mods) back to stock.
    - Resets engine power multipliers to 0.
  - Shows a one-time warning message per vehicle if configured.

Players will still see "Turbo" and engine upgrade options in vMenu, but any attempt to apply them on emergency vehicles will be automatically undone while they are driving.

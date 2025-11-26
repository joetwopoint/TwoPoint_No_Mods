# no_emergency_turbo
**Author:** TwoPoint Development  
**Version:** 1.1.0

Blocks turbo upgrades on emergency vehicles (class 18) even when players try to add them via vMenu / LS Customs.

This version aggressively enforces "no turbo" by constantly stripping turbo mods from emergency vehicles while driven.

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

- `Config.CheckInterval` – how often (in ms) to check vehicles when you are **not** in an emergency vehicle. Default: `1000`.
- `Config.BlockedClasses` – vehicle classes that are not allowed to have turbos. By default, class `18` (emergency).
- `Config.ExtraModels` – optional list of extra vehicle display names (lowercase) to treat as emergency even if they’re not class 18.
- `Config.ShowMessage` / `Config.MessageText` – whether to send a chat message when we first strip turbo from the current emergency vehicle.

---

## How it works

- Script checks if the player is the driver of a vehicle.
- If the vehicle is an emergency vehicle (class 18 or in `ExtraModels`):
  - It **continuously** forces turbo off (both toggle flag and mod slot).
  - On the first enforcement for that specific vehicle, it shows the configured message (once per vehicle).

Players will still see the "Turbo" option in vMenu, but any attempt to enable it on an emergency vehicle will be immediately neutralized.

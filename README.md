Simple Sprinting
================
- GitHub: https://github.com/octacian/sprint
- Download: https://github.com/octacian/sprint/archive/master.zip

This sprinting mod was inspired by GunshipPenguin's own [sprinting mod](https://forum.minetest.net/viewtopic.php?t=9650), however, written for ease of use and simplicity in code including the ability to configure the mod right from the advanced settings menu.

### Configuration

The speed and jump multipliers, as well as hotkeys, can be configured directly from the advanced settings menu in the sprint subsection of the top-level Mods section. You can also configure sprint directly from `minetest.conf` with the settings listed below.

| Name           | Type   | Description           |
| -------------- | ------ | --------------------- |
| sprint_primary | string | Primary sprinting key |
| sprint_speed   | float  | Speed multiplier      |
| sprint_jump    | float  | Jump multiplier       |
| sprint_dir     | bool   | Directional sprinting |

`sprint_primary` is the codename of the primary sprint key which causes the speed and jump multipliers to be applied to the player while it is held. If `sprint_dir` is set to `true`, players can only sprint while moving forward.

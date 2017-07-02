Simple Sprinting
================
- GitHub: https://github.com/octacian/sprint
- Download: https://github.com/octacian/sprint/archive/master.zip

This sprinting mod was inspired by GunshipPenguin's own [sprinting mod](https://forum.minetest.net/viewtopic.php?t=9650), however, written for ease of use and simplicity in code including the ability to configure the mod right from the advanced settings menu.

### Configuration

The speed and jump multipliers, as well as hotkeys, can be configured directly from the advanced settings menu in the sprint subsection of the top-level Mods section. You can also configure sprint directly from `minetest.conf` with the settings listed below.

| Name                 | Type   | Default | Description                |
| -------------------- | ------ | ------- | -------------------------- |
| sprint_primary       | string | aux1    | Primary sprinting key      |
| sprint_second        | string | up      | Secondary sprinting key    |
| sprint_enable_second | bool   | true    | Allow secondary sprint key |
| sprint_speed         | float  | 1.3     | Speed multiplier           |
| sprint_jump          | float  | 1.1     | Jump multiplier            |
| sprint_dir           | bool   | true    | Directional sprinting      |
| sprint_particles     | int    | 1       | Max number of particles    |

`sprint_primary` is the codename of the primary sprint key which causes the speed and jump multipliers to be applied to the player while it is held. If `sprint_dir` is set to `true`, players can only sprint while moving forward. `sprint_second` defines a key that if `sprint_enable_second` is set to `true` (default) triggers sprinting when pressed twice within 0.8 seconds. `sprint_particles` causes a configurable number of particles (`sprint_particle_num`) to be added behind the player as they sprint. While a higher number of particles produces a nicer visual effect, it causes higher load to the server.

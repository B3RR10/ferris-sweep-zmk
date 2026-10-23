# Ferris Sweep Keymap (ZMK)

This repository has the ZMK configuration for a Ferris Sweep keyboard. The keyboard has two
nice!nano v2 controllers.

The keymap file is `config/cradio.keymap`. ZMK uses the name "cradio" for the Ferris Sweep
shield.

## Layers

The keyboard has four layers.

| Layer | How to Get to the Layer | Content |
|---|---|---|
| BASE | Default layer | Colemak-DH layout. Home-row keys hold modifier keys. Refer to the Home-Row Modifier Keys table in this document. |
| NUM | Hold the right outer thumb key | Symbols on the left half. Numbers on the right half. |
| NAV | Hold the left outer thumb key | Esc, Tab, arrow keys, Insert, Delete, and the Caps Word function (key A). |
| FUN | Hold the NUM key and the NAV key together | F1 to F12, Bluetooth keys, volume keys, and media keys. |

### Home-Row Modifier Keys (BASE Layer)

The home-row keys hold modifier keys. The right half mirrors the left half.

| Key | Modifier | Key | Modifier |
|---|---|---|---|
| A | GUI | O | GUI |
| R | Alt | I | Alt |
| S | Shift | E | Shift |
| T | Ctrl | N | Ctrl |
| G | AltGr | M | AltGr |

### Bluetooth Keys (FUN Layer, Top-Left Keys)

| Key | Function |
|---|---|
| BT1, BT2, BT3 | Select Bluetooth profile 0, 1, or 2. |
| BT clr | Clear the bond for the current profile. |
| USB/BT | Change the output between USB and Bluetooth. |

### Volume and Media Keys (FUN Layer, Left Half)

| Key | Function |
|---|---|
| R | Turn the volume down. |
| S | Mute the volume. |
| T | Turn the volume up. |
| X | Go to the previous track. |
| C | Play or pause. |
| D | Go to the next track. |

The keymap has no keys for the reset function or the bootloader function. Use the physical
reset button on each half. Refer to the Flash Procedure in this document for the bootloader
procedure.

## Build Procedure

GitHub Actions builds the firmware after each push to the repository. Refer to the file
`.github/workflows/build.yml`. The build uses the file `build.yaml`. The build makes three
`.uf2` files:

- `cradio_left-nice_nano_v2-zmk.uf2`
- `cradio_right-nice_nano_v2-zmk.uf2`
- `settings_reset-nice_nano_v2-zmk.uf2`

Get these files from the Summary page of the GitHub Actions workflow run.

## Flash Procedure

Do this procedure to flash new firmware on the keyboard.

1. Push the reset button on one half two times. This puts the half in bootloader mode.
1. Drag the file `settings_reset-nice_nano_v2-zmk.uf2` to the drive with the name `NICENANO`.
1. Wait until the LED stops and the drive disconnects.
1. Do step 1 to step 3 again for the other half.
1. Push the reset button on the left half two times.
1. Drag the file `cradio_left-nice_nano_v2-zmk.uf2` to the `NICENANO` drive.
1. Push the reset button on the right half two times.
1. Drag the file `cradio_right-nice_nano_v2-zmk.uf2` to the `NICENANO` drive.
1. Supply power to both halves.

Note: Do steps 1 to 3 (the settings reset procedure) only in two cases: before the first flash,
or to remove old Bluetooth bonds.

The left half is the central half. Connect the left half to the computer or the phone. The
right half is the peripheral half. The right half connects to the left half with a Bluetooth
Low Energy (BLE) link.

To connect the keyboard to a different host, do these steps:

1. Hold the NUM key and the NAV key together to get to the FUN layer.
1. Push a BT key (BT1, BT2, or BT3) to select a profile.
1. Connect the new host to the keyboard.

To remove a Bluetooth bond, push the BT clr key.

Note: The build system assigns the left half and the right half by the `.uf2` file, not by data
in memory. A new flash procedure cannot change which half is the left half or the right half.

### Keyboard Name and Battery Level

The keyboard has one Bluetooth name and one USB name. The setting for the name is
`CONFIG_ZMK_KEYBOARD_NAME`, in the file `config/cradio.conf`. The name can have a maximum of 16
characters. The current name is "Ferris Sweep".

Only the left half sends data to a host. Only the left half shows in the Bluetooth settings of
a host. The right half has no connection to a host, and the right half does not need a name.

The file `cradio.conf` also has the setting `CONFIG_ZMK_SPLIT_BLE_CENTRAL_BATTERY_LEVEL_PROXY`.
This setting sends the battery level of both halves to the host. The battery display of the
host shows two entries. Both entries show the same device name, because both battery levels
come from the one connection with the left half.

Note: The keyboard cannot show different names for the left entry and the right entry. To
identify the halves, use a tool on the host. One example for macOS is Mighty Mitts:
<https://github.com/codyd51/Mighty-Mitts>

## Adjustment Procedure

### Caps Word Function

The Caps Word function is on the NAV layer, at key A.

The Caps Word function makes letters capital. The function continues until you push the Space
key, the Enter key, or most other keys. The function continues after these keys: digits, the
underscore key, the hyphen key, the Backspace key, and the Delete key.

Example: the text "MY-VAR_1" stays in capital letters.

The setting for this function is the `continue-list` property. Find this property on the
`&caps_word` node, near the start of the file `cradio.keymap`. The default `continue-list` has
only the underscore key, the Backspace key, and the Delete key.

### Home-Row Modifier Timing

The home-row modifier timing settings are in the file `config/cradio.keymap`. Find the settings
in the `hml` and `hmr` hold-tap behaviors. The macro `HM_PROPS` has these settings:

- `tapping-term-ms`: This is the time to hold a key before the system reads the key as a
  modifier key.
- `flavor = "balanced"`: If you push a key on the same hand before the tapping term ends, the
  system reads the key as a normal key press.
- `hold-trigger-key-positions` and `hold-trigger-on-release`: A held key is a modifier key only
  when you push the next key with the other hand, or with a thumb.
- `require-prior-idle-ms`: This setting stops the modifier function when you type fast.

For more data about these settings, refer to the ZMK documentation for the hold-tap behavior:
<https://zmk.dev/docs/keymaps/behaviors/hold-tap>

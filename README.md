# Ferris Sweep keymap (ZMK)

ZMK config for a Ferris Sweep with nice!nano v2 controllers, migrated from the QMK
userspace in `../qmk-userspace` (which was for Elite-C controllers). The keymap lives
in `config/cradio.keymap` — "cradio" is ZMK's in-tree shield name for the Sweep.

## Layers

| Layer | How to reach it | Contents |
|---|---|---|
| BASE | — | Colemak-DH, home-row mods (GUI / Alt / Shift / Ctrl, AltGr on G and M) |
| NUM | hold right outer thumb | Symbols on the left, numpad on the right |
| FUN | hold left outer thumb | Navigation, plain modifiers, Ctrl clipboard, reset/bootloader, Bluetooth |
| FUN2 | hold NUM + FUN | F1–F12, F13, Ctrl+Shift clipboard, bootloader (right half) |
| NUM2 | hold NUM + left inner thumb | AltGr characters (¿ « » €), `` ` ~ _ \| ^ ``, volume |

### Bluetooth (FUN layer, bottom-right)

| Key | Action |
|---|---|
| BT1 / BT2 / BT3 | Select Bluetooth profile 0/1/2 |
| BT clr | Clear (unpair) the current profile |
| USB/BT | Toggle output between USB and Bluetooth |

### Reset and bootloader

- FUN → top-left (`Reset`): soft reset (`&sys_reset`).
- FUN → top-right (`Boot`): bootloader, **left half only**.
- FUN2 → top-right (`Boot`): bootloader, **right half only**.

`&bootloader` only resets the half the key is physically on, so each half needs its own key —
hold the half's own thumb combo before pressing it.

## Build

GitHub Actions builds the firmware on every push (see `.github/workflows/build.yml`), using
`build.yaml` to produce three `.uf2` files per run, downloadable from the workflow's Summary
page as a zip of artifacts:

- `cradio_left-nice_nano_v2-zmk.uf2`
- `cradio_right-nice_nano_v2-zmk.uf2`
- `settings_reset-nice_nano_v2-zmk.uf2`

## Flash

1. First time (or to re-pair): put each half in bootloader mode (double-tap the reset button)
   and drag `settings_reset-nice_nano_v2-zmk.uf2` onto the `NICENANO` drive that appears. This
   clears any stored BT bonds/keymap state. Wait for the LED to settle, then repeat once per half.
2. Flash the real firmware the same way: `cradio_left-...uf2` to the left half, `cradio_right-...uf2`
   to the right half.
3. Power both halves on. The left half is the "central" (the one your computer pairs with); the
   right half is the "peripheral" and connects to the left over BLE. Pair the left half with your
   computer/phone as a normal Bluetooth keyboard.
4. To pair with another host, switch profiles with the BT1/BT2/BT3 keys on the FUN layer before
   connecting, or `BT clr` to forget the current one.

Unlike the QMK build, handedness is set by which `.uf2` you flash to which half (via the
`cradio_left`/`cradio_right` shields), not by stored EEPROM state — so re-flashing never mixes up
which half is which.

## Tuning

Home-row mod timing lives in `config/cradio.keymap`, in the `hml`/`hmr` hold-tap behaviors
(`HM_PROPS`):

- `tapping-term-ms` — how long a hold has to last to register as a modifier (was QMK's `TAPPING_TERM`).
- `flavor = "balanced"` — a same-hand key typed before the term expires rolls through as a tap
  (was QMK's `PERMISSIVE_HOLD`).
- `hold-trigger-key-positions` + `hold-trigger-on-release` — a hold only acts as a modifier when
  the next key is on the opposite hand or a thumb key (was QMK's `CHORDAL_HOLD`).
- `require-prior-idle-ms` — suppresses the hold if you were just typing fast (was QMK's `FLOW_TAP_TERM`).

See the [ZMK hold-tap docs](https://zmk.dev/docs/keymaps/behaviors/hold-tap) for the full set of
options.

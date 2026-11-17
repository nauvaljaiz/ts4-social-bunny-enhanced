# Resource Override Plan — Social Bunny Verified

## 1. Single Targeted Override

| Target | TGI | Package |
|---|---|---|
| `socialmedia` Scaleform GFX | `0x62ECC59A:0x00000000:0x8ABB350F01880C64` | `SocialBunnyVerified_UI.package` |

This is the exact identifier audited from the installed game's `Data\Client\UI.package`. The Type, Group, and Instance are preserved exactly. No original file is modified.

## 2. Package Contents

`SocialBunnyVerified_UI.package` contains **one resource only**:

- Type `0x62ECC59A`
- Group `0x00000000`
- Instance `0x8ABB350F01880C64`
- Data: compiled `GFX` replacement, 90,439 bytes in the current build

The package validation checks that exactly one resource is present and that the compiled GFX contains the verified tab symbols and `sbv.verified` command string.

## 3. Not Overridden

- `widgetlist.xml`
- `componentlibrary`
- `guicomponentlibrary`
- `hudlibrary`
- `gfxfontlib`
- `classlibrarygamedata`
- `socialmedia_I1` DDS textures
- EP12 Social Bunny tuning
- Any other phone application

## 4. Build Pipeline

1. The untouched original remains at `src/gfx/original/SocialMedia_0x8ABB350F01880C64.gfx`.
2. FFDec decompilation remains at `src/gfx/decompiled/SocialMedia/`.
3. `src/gfx/scripts/` contains the editable sources. Only `SocialMediaPanel.as` differs from vanilla.
4. `tools/build_packages.py` imports only the changed script into the original GFX using FFDec `-importScript`.
5. The output is validated for the GFX header and the presence of `btnVerifiedTabButton` and `sbv.verified`.
6. The result is written as a DBPF package with the exact native TGI.
7. The Python backend is compiled with the game's Python 3.7 interpreter and packaged as `SocialBunnyVerified.ts4script`.

## 5. Compatibility Rationale

Because the override is limited to the native Social Bunny widget, it does not conflict with:
- HUD/CAS/widget-list mods,
- shared library overrides,
- texture atlas mods,
- other phone app mods,
- native Social Bunny tuning or interaction mods.

The only expected conflict is another mod that directly replaces the same `SocialMedia` GFX instance.

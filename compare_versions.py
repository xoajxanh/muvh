import os
import filecmp

v158_dir = r"d:\MUVH\android\mu-decompiled\v158_lua"
v164_dir = r"d:\MUVH\android\mu-decompiled\v164_lua"

def get_files(d):
    return set(f for f in os.listdir(d) if os.path.isfile(os.path.join(d, f)))

v158_files = get_files(v158_dir)
v164_files = get_files(v164_dir)

missing_in_v164 = v158_files - v164_files
new_in_v164 = v164_files - v158_files

print(f"Total files in v158: {len(v158_files)}")
print(f"Total files in v164: {len(v164_files)}")

print("\n--- Files in v158 but not in v164 ---")
if not missing_in_v164:
    print("None!")
else:
    for f in sorted(missing_in_v164):
        print(f)

print("\n--- Files in v164 but not in v158 ---")
if not new_in_v164:
    print("None!")
else:
    for f in sorted(new_in_v164)[:10]: # Print up to 10
        print(f)
    if len(new_in_v164) > 10:
        print(f"... and {len(new_in_v164) - 10} more.")

print("\n--- Check specific files ---")
for f in ["Login_LoginUI.lua", "PlatformData.lua"]:
    if f in v164_files:
        print(f"{f} is PRESENT in v164.")
    else:
        print(f"{f} is MISSING in v164.")

print("\n--- Check Main.lua ---")
if "Main.lua" in v158_files and "Main.lua" in v164_files:
    is_same = filecmp.cmp(os.path.join(v158_dir, "Main.lua"), os.path.join(v164_dir, "Main.lua"), shallow=False)
    print(f"Main.lua is {'IDENTICAL' if is_same else 'DIFFERENT'} between v158 and v164.")

print("\n--- Check modified files to see if v164 base changed ---")
mod_files = ["EmmyluaDebug.lua", "NetMsgPreverifying_Map.lua"]
for f in mod_files:
    if f in v158_files and f in v164_files:
        is_same = filecmp.cmp(os.path.join(v158_dir, f), os.path.join(v164_dir, f), shallow=False)
        print(f"{f} is {'IDENTICAL' if is_same else 'DIFFERENT'} between original v158 and original v164.")
        if not is_same:
            print(f"  -> WARNING: {f} was updated in v164, you may need to port your mods to the new version!")
    else:
        print(f"{f} missing in one of the versions.")

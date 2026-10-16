import sys
sys.stdout.reconfigure(encoding='utf-8')

client_emmy = r"D:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"

with open(client_emmy, 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

print(f"Total lines: {len(lines)}")
for i, line in enumerate(lines):
    if "Mod_TowerCheck_" in line or "CheckSkill" in line or "Tháp" in line or "Nhiếp Hồn" in line:
        print(f"L{i+1}: {line.strip()[:140]}")

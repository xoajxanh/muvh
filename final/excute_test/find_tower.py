import re

client_emmy = r"D:\MUVH\android\mu-decompiled\final\modified_lua_dev_client\EmmyluaDebug.lua"

with open(client_emmy, 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

print(f"Total lines: {len(lines)}")
matches = []
for i, line in enumerate(lines):
    lower = line.lower()
    if any(k in lower for k in ["nhiếp", "tháp", "tower", "buff máu", "refine", "climbtower"]):
        matches.append((i + 1, line.strip()))

print(f"Found {len(matches)} matches")
for ln, text in matches[:40]:
    print(f"L{ln}: {text[:120]}")

# -*- coding: utf-8 -*-
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

def unescape_lua_string(s):
    try:
        raw_bytes = re.sub(r'\\(\d{1,3})', lambda m: bytes([int(m.group(1))]).decode('latin1'), s)
        return raw_bytes.encode('latin1').decode('utf-8')
    except Exception as e:
        return s

# Check exact coordinates in cfg_Map_minimap for C3 and C4
with open(r'd:\MUVH\android\mu-decompiled\final\extracted_lua\cfg_Map_minimap.lua', 'r', encoding='utf-8', errors='ignore') as f:
    minimap_content = f.read()

print('=== C3 (101094) EXACT BOSS COORDINATES ON MINIMAP ===')
for e in re.findall(r'(\[\d+\]\s*=\s*\{\s*id\s*=\s*\d+,\s*mid\s*=\s*101094.*?\n  \})', minimap_content, re.DOTALL):
    type_m = re.search(r'type\s*=\s*(\d+)', e)
    if type_m and type_m.group(1) == '4':
        name_m = re.search(r'name\s*=\s*"([^"]+)"', e)
        param_m = re.search(r'Param\s*=\s*(\d+)', e)
        pos_m = re.search(r'position\s*=\s*"([^"]+)"', e)
        print(f"Boss: {unescape_lua_string(name_m.group(1)):30s} | ID: {param_m.group(1):8s} | Pos: {pos_m.group(1)}")

print('\n=== C4 (101093) EXACT BOSS COORDINATES ON MINIMAP ===')
for e in re.findall(r'(\[\d+\]\s*=\s*\{\s*id\s*=\s*\d+,\s*mid\s*=\s*101093.*?\n  \})', minimap_content, re.DOTALL):
    type_m = re.search(r'type\s*=\s*(\d+)', e)
    if type_m and type_m.group(1) == '4':
        name_m = re.search(r'name\s*=\s*"([^"]+)"', e)
        param_m = re.search(r'Param\s*=\s*(\d+)', e)
        pos_m = re.search(r'position\s*=\s*"([^"]+)"', e)
        print(f"Boss: {unescape_lua_string(name_m.group(1)):30s} | ID: {param_m.group(1):8s} | Pos: {pos_m.group(1)}")

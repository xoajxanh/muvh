import re

with open('final/extracted_lua/cfg_Global_global.lua', 'r', encoding='latin1') as f:
    text = f.read()

entries = re.findall(r'\[(\d+)\]\s*=\s*\{([^}]+)\}', text)
for gid, content in entries:
    if '6000' in content or ' 6' in content:
        c_low = content.lower()
        if any(w in c_low for w in ['transfer', 'map', 'fight', 'pk', 'cd', 'time', 'jump', 'move']):
            print(f"ID {gid}: {content.strip()[:120]}")

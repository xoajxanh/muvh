import re

with open('final/extracted_lua/cfg_Map_minimap.lua', 'rb') as f:
    minimap_content = f.read().decode('utf-8', errors='ignore')

def decode_lua_str(s):
    b = s.encode('latin1')
    b = re.sub(br'\\(\d{1,3})', lambda m: bytes([int(m.group(1))]), b)
    return b.decode('utf-8', errors='ignore')

out = []
target_maps = [1074, 105208, 106407, 106706]

blocks = minimap_content.split('  [')
for map_id in target_maps:
    out.append(f"--- MAP {map_id} ---")
    boss_list = []
    for block in blocks:
        if f'mid = {map_id},' in block or f'mapId = {map_id},' in block:
            boss_id_match = re.search(r'id = (\d+),', block)
            param_match = re.search(r'Param = (\d+)', block)
            name_match = re.search(r'name\s*=\s*"([^"]+)"', block)
            type_match = re.search(r'Type = (\d+)', block, re.IGNORECASE)
            
            if boss_id_match and param_match and name_match:
                boss_id = int(boss_id_match.group(1))
                param = int(param_match.group(1))
                name = decode_lua_str(name_match.group(1))
                t = type_match.group(1) if type_match else "None"
                
                # Bosses typically have specific types or are not just 'Quai Lv'
                if "Quái" not in name:
                    boss_list.append((boss_id, param, name, t))
    
    boss_list.sort()
    for boss_id, param, name, t in boss_list:
        out.append(f"id: {boss_id}, Param: {param}, Type: {t}, name: {name}")

with open('c8_bosses.txt', 'w', encoding='utf-8') as f:
    f.write('\n'.join(out))

import re, unicodedata

with open('final/extracted_lua/cfg_Map_map.lua', 'rb') as f:
    content = f.read().decode('utf-8', errors='ignore')

def decode_lua_str(s):
    b = s.encode('latin1')
    b = re.sub(br'\\(\d{1,3})', lambda m: bytes([int(m.group(1))]), b)
    return b.decode('utf-8', errors='ignore')

blocks = content.split('{')

results = []
for block in blocks:
    if 'id = ' in block and 'showName = ' in block:
        id_match = re.search(r'id\s*=\s*(\d+)', block)
        name_match = re.search(r'showName\s*=\s*"([^"]+)"', block)
        if id_match and name_match:
            map_id = id_match.group(1)
            raw_name = name_match.group(1)
            decoded = decode_lua_str(raw_name)
            if map_id not in [r[0] for r in results]:
                results.append((map_id, decoded))

with open('map_all.txt', 'w', encoding='utf-8') as f:
    f.write('\n'.join(f'{m[0]}: {m[1]}' for m in results))

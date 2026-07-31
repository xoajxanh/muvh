import re

with open('final/extracted_lua/cfg_Monster_monster.lua', 'rb') as f:
    content = f.read().decode('utf-8', errors='ignore')

def decode_lua_str(s):
    b = s.encode('latin1')
    b = re.sub(br'\\(\d{1,3})', lambda m: bytes([int(m.group(1))]), b)
    return b.decode('utf-8', errors='ignore')

out = []
def get_boss_names(ids):
    blocks = content.split('  [')
    for block in blocks:
        for i in ids:
            if block.startswith(str(i) + ']'):
                name_match = re.search(r'name\s*=\s*"([^"]+)"', block)
                if name_match:
                    out.append(f'{i}: {decode_lua_str(name_match.group(1))}')

get_boss_names([10179607, 10179608, 10179609])
out.append('---')
get_boss_names([10520701, 10520702, 10520703])
out.append('---')
get_boss_names([10640601, 10640602, 10640603])
out.append('---')
get_boss_names([10670501, 10670502, 10670503])

with open('boss_names.txt', 'w', encoding='utf-8') as f:
    f.write('\n'.join(out))

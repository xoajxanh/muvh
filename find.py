import re
def decode_lua_string(s):
    def repl(m): return bytes([int(m.group(1))])
    b = s.encode('utf-8')
    b = re.sub(br'\\(\d{1,3})', repl, b)
    return b.decode('utf-8', errors='ignore')

with open(r'd:\MUVH\android\mu-decompiled\final\extracted_lua\cfg_Skill_skillManager.lua', 'r', encoding='utf-8') as f:
    lines = f.readlines()

current_id = None
out = open('d:/MUVH/android/mu-decompiled/skills_decoded.txt', 'w', encoding='utf-8')
for line in lines:
    line = line.strip()
    m_id = re.search(r'^id\s*=\s*(\d+)', line)
    if m_id:
        current_id = m_id.group(1)
    m_name = re.search(r'^name\s*=\s*"([^"]+)"', line)
    if m_name:
        current_name = decode_lua_string(m_name.group(1))
        if current_id:
            out.write(f'{current_id}: {current_name}\n')
            if 'thiên sứ' in current_name.lower():
                print(f'FOUND: {current_id} - {current_name}')
out.close()

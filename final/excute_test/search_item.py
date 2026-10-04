with open('final/extracted_lua/cfg_Count_count.lua', 'r', encoding='utf-8', errors='ignore') as fp:
    lines = fp.readlines()

for i, l in enumerate(lines):
    if '[2444009] = {' in l:
        for j in range(i, i+15):
            print(lines[j].strip())
        break

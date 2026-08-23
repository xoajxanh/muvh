import re

with open(r'd:\MUVH\android\mu-decompiled\final\modified_lua\EmmyluaDebug.lua', 'r', encoding='utf-8') as f:
    content = f.read()

# I will replace the BossState_BossId hook with a pass.
hook_str = '''                                        if v and _G.WriteLog then
                                            _G.WriteLog("[ModDebug][BossState_BossId_" .. tostring(cfg.id) .. "] " .. _G.DumpTable(v, 1, 3))
                                        end'''
                                        
hook_fixed = '''                                        -- Removed spam hook'''

if hook_str in content:
    content = content.replace(hook_str, hook_fixed)
    print("Removed BossState spam hook.")
else:
    print("Could not find BossState spam hook.")

with open(r'd:\MUVH\android\mu-decompiled\final\modified_lua\EmmyluaDebug.lua', 'w', encoding='utf-8') as f:
    f.write(content)

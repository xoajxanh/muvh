import re

with open(r'd:\MUVH\android\mu-decompiled\final\modified_lua\EmmyluaDebug.lua', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the broken section around line 374
broken_str = '''                                local statusStr = "--:--"
                                        
                                        if totalAlive > 0 or #deadList > 0 then'''

fixed_str = '''                                local statusStr = "--:--"
                                local prefix = ""
                                local validLineNum = 1
                                
                                if bossData then
                                    local bestLine = nil
                                    for _, lineNum in ipairs(bossData.lineNums) do
                                        local totalAlive = bossData.aliveCount[lineNum] or 0
                                        local deadList = bossData.deadTimes[lineNum] or {}
                                        local expectedTotal = cfg.total or 1
                                        
                                        if totalAlive > 0 or #deadList > 0 then'''

if broken_str in content:
    content = content.replace(broken_str, fixed_str)
    print("Fixed line 374 issue.")
else:
    print("Could not find broken string 1.")

# And I will also insert the 100930 hook correctly at the NetManager.Dispatch hook
# I'll look for `local msgId = args[1]` in the `_G.NetManager.Dispatch` function.
net_hook_str = '''                            local msgId = args[1]
                            local msg = args[2]
                            
                            if _G.WriteLog then'''

net_hook_fixed = '''                            local msgId = args[1]
                            local msg = args[2]
                            
                            if _G.WriteLog then
                                if msgId == 100930 then
                                    _G.WriteLog("[ModDebug][Msg_100930_BigIconMonsters] " .. _G.DumpTable(msg, 1, 5))
                                elseif msgId == 100931 then
                                    _G.WriteLog("[ModDebug][Msg_100931_BigIconMonsterSingle] " .. _G.DumpTable(msg, 1, 5))
                                elseif msgId == 100923 then
                                    _G.WriteLog("[ModDebug][Msg_100923_UniversalPoint] " .. _G.DumpTable(msg, 1, 5))
                                end'''

# To ensure we only replace the first occurrence in the NetManager.Dispatch
# Because there might be another `local msgId = args[1]` inside the file.
if content.count(net_hook_str) == 1:
    content = content.replace(net_hook_str, net_hook_fixed)
    print("Added Msg 100930/100931 hooks.")
else:
    print("Found multiple or zero net_hook_str.")

with open(r'd:\MUVH\android\mu-decompiled\final\modified_lua\EmmyluaDebug.lua', 'w', encoding='utf-8') as f:
    f.write(content)

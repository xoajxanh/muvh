import sys

with open('d:\\MUVH\\android\\mu-decompiled\\final\\modified_lua_dev\\EmmyluaDebug.lua', 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    new_lines.append(line)
    if 'local chatId = "-5255708823"' in line:
        new_lines.append('                                        local function SendTeleAsync()\n')
        new_lines.append('                                            local url = "https://api.telegram.org/bot" .. botToken .. "/sendMessage?chat_id=" .. chatId .. "&text=" .. CS.UnityEngine.WWW.EscapeURL(msg)\n')
        new_lines.append('                                            pcall(function() CS.UnityEngine.WWW(url) end)\n')
        new_lines.append('                                        end\n')
        new_lines.append('                                        SendTeleAsync()\n')

with open('d:\\MUVH\\android\\mu-decompiled\\final\\modified_lua_dev\\EmmyluaDebug.lua', 'w', encoding='utf-8') as f:
    f.writelines(new_lines)

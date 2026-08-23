import sys
import re

file_path = r'd:\MUVH\android\mu-decompiled\final\modified_lua\EmmyluaDebug.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the mapsConfig initialization
mapsConfig_old = '''        local mapsConfig = {
            {
                mapId = 101096,
                title = "Hoang Dã C7",
                bosses = {
                    { id = 10179607, name = "Tektus", col = 1, transferId = 400216, total = 2 },
                    { id = 10179608, name = "Phẫn Nộ", col = 2, transferId = 400222, total = 2 },
                    { id = 10179609, name = "Cuồng Bạo", col = 3, transferId = 400228, total = 2 },
                }
            },
            {
                mapId = 105207,
                title = "Trang Sức C7",
                bosses = {
                    { id = 10520701, name = "Tektus", col = 1, transferId = 105207101 },
                    { id = 10520702, name = "Phẫn Nộ", col = 2, transferId = 105207102 },
                }
            },
            {
                mapId = 106406,
                title = "Thí Luyện Cảnh 6",
                bosses = {
                    { id = 10640601, name = "CS Rìu To", col = 1, transferId = 10640601 },
                    { id = 10640602, name = "Ngang Ngược", col = 2, transferId = 10640602 },
                    { id = 10640603, name = "Tà Ác", col = 3, transferId = 10640603 },
                }
            },
            {
                mapId = 106704,
                title = "Luyện Ngục C7",
                bosses = {
                    { id = 10670401, name = "Tướng Quân LN", col = 1, transferId = 106704101 },
                    { id = 10670402, name = "Ngang Ngược", col = 2, transferId = 106704102 },
                    { id = 10670403, name = "Tà Ác", col = 3, transferId = 106704103 },
                }
            }
        }'''

mapsConfig_new = '''        local mapsConfig_c7 = {
            {
                mapId = 101096,
                title = "Hoang Dã C7",
                bosses = {
                    { id = 10179607, name = "Tektus", col = 1, transferId = 400216, total = 2 },
                    { id = 10179608, name = "Phẫn Nộ", col = 2, transferId = 400222, total = 2 },
                    { id = 10179609, name = "Cuồng Bạo", col = 3, transferId = 400228, total = 2 },
                }
            },
            {
                mapId = 105207,
                title = "Trang Sức C7",
                bosses = {
                    { id = 10520701, name = "Tektus", col = 1, transferId = 105207101 },
                    { id = 10520702, name = "Phẫn Nộ", col = 2, transferId = 105207102 },
                }
            },
            {
                mapId = 106406,
                title = "Thí Luyện Cảnh 6",
                bosses = {
                    { id = 10640601, name = "CS Rìu To", col = 1, transferId = 10640601 },
                    { id = 10640602, name = "Ngang Ngược", col = 2, transferId = 10640602 },
                    { id = 10640603, name = "Tà Ác", col = 3, transferId = 10640603 },
                }
            },
            {
                mapId = 106704,
                title = "Luyện Ngục C7",
                bosses = {
                    { id = 10670401, name = "Tướng Quân LN", col = 1, transferId = 106704101 },
                    { id = 10670402, name = "Ngang Ngược", col = 2, transferId = 106704102 },
                    { id = 10670403, name = "Tà Ác", col = 3, transferId = 106704103 },
                }
            }
        }
        
        local mapsConfig_c8 = {
            {
                mapId = 1074,
                title = "Philea (C8)",
                bosses = {
                    { id = 3409, name = "K.Sĩ Tử Vong", col = 1, transferId = 400244, total = 2 },
                    { id = 3411, name = "Phẫn Nộ", col = 2, transferId = 400245, total = 2 },
                    { id = 3413, name = "Cuồng Bạo", col = 3, transferId = 400246, total = 2 },
                }
            },
            {
                mapId = 105208,
                title = "Huyễn Thuật Bí Cảnh 8",
                bosses = {
                    { id = 2693, name = "K.Sĩ Tử Vong", col = 1, transferId = 105208101 },
                    { id = 2694, name = "Phẫn Nộ", col = 2, transferId = 105208102 },
                }
            },
            {
                mapId = 106407,
                title = "Vùng Thí Luyện 7",
                bosses = {
                    { id = 2789, name = "T.Vệ Giáo Dài", col = 1, transferId = 10640701 },
                    { id = 2790, name = "Ngang Ngược", col = 2, transferId = 10640702 },
                    { id = 2791, name = "Tà Ác", col = 3, transferId = 10640703 },
                }
            },
            {
                mapId = 106706,
                title = "Luyện Ngục Khổ Nạn 6",
                bosses = {
                    { id = 2991, name = "Ma Đạo Phủ", col = 1, transferId = 106706101 },
                    { id = 2992, name = "Ngang Ngược", col = 2, transferId = 106706102 },
                    { id = 2993, name = "Tà Ác", col = 3, transferId = 106706103 },
                }
            }
        }
        
        _G.ModBossTab = _G.ModBossTab or "C7"'''

# Replace the beginning of UpdateBossWatchUIText
update_old = '''                local titleIdx = 1
                local rowIdx = 1
                local btnIdx = 1
                local sepIdx = 1

                for i, mapCfg in ipairs(mapsConfig) do'''

update_new = '''                local titleIdx = 1
                local rowIdx = 1
                local btnIdx = 1
                local sepIdx = 1
                
                local tabBtnC7 = GetLineButton(btnIdx, 10, currentPosY, 100)
                tabBtnC7.go:SetActive(true)
                tabBtnC7.txt.text = "<color=" .. (_G.ModBossTab == "C7" and "#00FF00" or "#FFFFFF") .. ">[ TAB: C7 ]</color>"
                tabBtnC7.btn.onClick:RemoveAllListeners()
                tabBtnC7.btn.onClick:AddListener(function()
                    _G.ModBossTab = "C7"
                    UpdateBossWatchUIText()
                end)
                btnIdx = btnIdx + 1

                local tabBtnC8 = GetLineButton(btnIdx, 120, currentPosY, 100)
                tabBtnC8.go:SetActive(true)
                tabBtnC8.txt.text = "<color=" .. (_G.ModBossTab == "C8" and "#00FF00" or "#FFFFFF") .. ">[ TAB: C8 ]</color>"
                tabBtnC8.btn.onClick:RemoveAllListeners()
                tabBtnC8.btn.onClick:AddListener(function()
                    _G.ModBossTab = "C8"
                    UpdateBossWatchUIText()
                end)
                btnIdx = btnIdx + 1
                
                currentPosY = currentPosY - 35

                local mapsConfig = _G.ModBossTab == "C8" and mapsConfig_c8 or mapsConfig_c7
                for i, mapCfg in ipairs(mapsConfig) do'''

if mapsConfig_old.encode('utf-8') in content.encode('utf-8'):
    print("Found mapsConfig_old")
    # Need to handle encoding and whitespace issues correctly
else:
    print("Could not find mapsConfig_old")

content = re.sub(r'local mapsConfig = \{.*?\n        \}', mapsConfig_new, content, flags=re.DOTALL)
content = content.replace(update_old, update_new)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Patch applied successfully.")

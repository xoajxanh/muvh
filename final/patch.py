import sys, re

with open('d:/MUVH/android/mu-decompiled/final/modified_lua_dev/EmmyluaDebug.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Remove 'if isAd then' around tabAutoBossGo creation
text = re.sub(r'local tabAutoBossGo, tabAutoBossImg, tabAutoBossTxt, tabAutoBossBtn\r?\n        if isAd then', 
              r'local tabAutoBossGo, tabAutoBossImg, tabAutoBossTxt, tabAutoBossBtn\n        if true then', text)

# 2. UpdateTabColors
text = text.replace('if isAd then tabAutoBossImg.color = Color(0.2, 0.2, 0.2, 1) end', 'tabAutoBossImg.color = Color(0.2, 0.2, 0.2, 1)')
text = text.replace('if isAd then tabAutoBossTxt.color = Color(0.6, 0.6, 0.6, 1) end', 'tabAutoBossTxt.color = Color(0.6, 0.6, 0.6, 1)')
text = text.replace('if isAd then tabAutoBossTxt.text = "AUTO BOSS" end', 'tabAutoBossTxt.text = "AUTO BOSS"')
text = text.replace('elseif _G.ModMainTab == "AUTO_BOSS" and isAd then', 'elseif _G.ModMainTab == "AUTO_BOSS" then')

# 3. onClick listener
# Look for:
#        if isAd then
#            tabAutoBossBtn.onClick:AddListener(function()
#                _G.ModMainTab = "AUTO_BOSS"
#                pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModMainTab", _G.ModMainTab) end)
#                UpdateTabColors()
#                RefreshMainTabs()
#            end)
#            
#            tabAdminBtn.onClick:AddListener(function()

# We need to extract tabAutoBossBtn out of the if isAd then block
old_click = """        if isAd then
            tabAutoBossBtn.onClick:AddListener(function()
                _G.ModMainTab = "AUTO_BOSS"
                pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModMainTab", _G.ModMainTab) end)
                UpdateTabColors()
                RefreshMainTabs()
            end)
            
            tabAdminBtn.onClick:AddListener(function()"""

new_click = """        tabAutoBossBtn.onClick:AddListener(function()
            _G.ModMainTab = "AUTO_BOSS"
            pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModMainTab", _G.ModMainTab) end)
            UpdateTabColors()
            RefreshMainTabs()
        end)
        
        if isAd then
            tabAdminBtn.onClick:AddListener(function()"""

text = text.replace(old_click, new_click)

with open('d:/MUVH/android/mu-decompiled/final/modified_lua_dev/EmmyluaDebug.lua', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")

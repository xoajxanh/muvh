import os, re

files = [
    r'D:\MUVH\android\mu-decompiled\final\modified_lua_dev\EmmyluaDebug.lua',
    r'D:\MUVH\android\mu-decompiled\final\modified_lua_admin\EmmyluaDebug.lua',
    r'D:\MUVH\android\mu-decompiled\final\modified_lua_customer\EmmyluaDebug.lua'
]

create_range_control = '''        local function CreateRangeControl(startX, yPos, prefix, valueVarName, step)
            local centerX = startX + 90
            local valGo = GameObject(valueVarName .. "_Val")
            valGo.transform:SetParent(panelGo.transform, false)
            local vRt = valGo:AddComponent(typeof(RectTransform))
            vRt.anchorMin, vRt.anchorMax, vRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            vRt.anchoredPosition = Vector2(centerX - 80, yPos)
            vRt.sizeDelta = Vector2(160, 30)
            local vTxt = valGo:AddComponent(typeof(Text))
            vTxt.raycastTarget = false
            vTxt.text = string.format("%s%d", prefix, _G[valueVarName] or 0)
            vTxt.alignment = TextAnchor.MiddleCenter
            vTxt.color = Color(0.8, 1, 0.8, 1)
            vTxt.fontSize = 18
            if defaultFont then vTxt.font = defaultFont end

            local minusBtnGo = GameObject(valueVarName .. "_Minus")
            minusBtnGo.transform:SetParent(panelGo.transform, false)
            local mRt = minusBtnGo:AddComponent(typeof(RectTransform))
            mRt.anchorMin, mRt.anchorMax, mRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            mRt.anchoredPosition = Vector2(centerX - 120, yPos)
            mRt.sizeDelta = Vector2(40, 30)
            local mImg = minusBtnGo:AddComponent(typeof(Image))
            mImg.color = Color(0.3, 0.3, 0.3, 1)
            local mTxtGo = GameObject(valueVarName .. "_MinusTxt")
            mTxtGo.transform:SetParent(minusBtnGo.transform, false)
            local mTxtRt = mTxtGo:AddComponent(typeof(RectTransform))
            mTxtRt.anchorMin, mTxtRt.anchorMax, mTxtRt.sizeDelta = Vector2(0, 0), Vector2(1, 1), Vector2(0, 0)
            local mTxt = mTxtGo:AddComponent(typeof(Text))
            mTxt.raycastTarget, mTxt.text, mTxt.color, mTxt.fontSize, mTxt.alignment = false, "-", Color.white, 18, TextAnchor.MiddleCenter
            if defaultFont then mTxt.font = defaultFont end

            local plusBtnGo = GameObject(valueVarName .. "_Plus")
            plusBtnGo.transform:SetParent(panelGo.transform, false)
            local pRt = plusBtnGo:AddComponent(typeof(RectTransform))
            pRt.anchorMin, pRt.anchorMax, pRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            pRt.anchoredPosition = Vector2(centerX + 80, yPos)
            pRt.sizeDelta = Vector2(40, 30)
            local pImg = plusBtnGo:AddComponent(typeof(Image))
            pImg.color = Color(0.3, 0.3, 0.3, 1)
            local pTxtGo = GameObject(valueVarName .. "_PlusTxt")
            pTxtGo.transform:SetParent(plusBtnGo.transform, false)
            local pTxtRt = pTxtGo:AddComponent(typeof(RectTransform))
            pTxtRt.anchorMin, pTxtRt.anchorMax, pTxtRt.sizeDelta = Vector2(0, 0), Vector2(1, 1), Vector2(0, 0)
            local pTxt = pTxtGo:AddComponent(typeof(Text))
            pTxt.raycastTarget, pTxt.text, pTxt.color, pTxt.fontSize, pTxt.alignment = false, "+", Color.white, 18, TextAnchor.MiddleCenter
            if defaultFont then pTxt.font = defaultFont end

            local function UpdateLabel()
                vTxt.text = string.format("%s%d", prefix, _G[valueVarName])
            end

            local mBtnComp = minusBtnGo:AddComponent(typeof(Button))
            mBtnComp.onClick:AddListener(function()
                pcall(function()
                    _G[valueVarName] = _G[valueVarName] - step
                    if _G[valueVarName] < 1 then _G[valueVarName] = 1 end
                    UpdateLabel()
                    CS.UnityEngine.PlayerPrefs.SetInt(valueVarName, _G[valueVarName])
                    CS.UnityEngine.PlayerPrefs.Save()
                end)
            end)
            
            local pBtnComp = plusBtnGo:AddComponent(typeof(Button))
            pBtnComp.onClick:AddListener(function()
                pcall(function()
                    _G[valueVarName] = _G[valueVarName] + step
                    if _G[valueVarName] > 16 then _G[valueVarName] = 16 end
                    UpdateLabel()
                    CS.UnityEngine.PlayerPrefs.SetInt(valueVarName, _G[valueVarName])
                    CS.UnityEngine.PlayerPrefs.Save()
                end)
            end)
        end'''

for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Replace Mod_AttackRange16 logic in timer loop
    content = re.sub(
        r'if _G\.Mod_AttackRange16 then.*?if _G\.QiJiHelperData\.SettingData\.KillMonsterScope < 16 then.*?_G\.QiJiHelperData\.SettingData\.KillMonsterScope = 16.*?end.*?end.*?end',
        '''if _G.Mod_CustomAttackRange and _G.Mod_CustomAttackRange > 0 then
                        if _G.QiJiHelperData and _G.QiJiHelperData.SettingData then
                            if _G.QiJiHelperData.SettingData.KillMonsterScope ~= _G.Mod_CustomAttackRange then
                                _G.QiJiHelperData.SettingData.KillMonsterScope = _G.Mod_CustomAttackRange
                            end
                        end
                    end''',
        content,
        flags=re.DOTALL
    )

    # 2. Replace Mod_AttackRange16 PlayerPrefs init
    content = re.sub(
        r'if _G\.Mod_AttackRange16 == nil then _G\.Mod_AttackRange16 = CS\.UnityEngine\.PlayerPrefs\.GetInt\("Mod_AttackRange16", 0\) == 1 end',
        'if _G.Mod_CustomAttackRange == nil then _G.Mod_CustomAttackRange = CS.UnityEngine.PlayerPrefs.GetInt("Mod_CustomAttackRange", 0) end',
        content
    )

    # 3. Remove CreateToggle Mod_AttackRange16 in right column
    content = re.sub(
        r'CreateToggle\("MAX PHẠM VI TREO \(16\)", "Mod_AttackRange16", rightColX \+ 20, currentY\)\s*currentY = currentY - 25\s*',
        '',
        content
    )

    # 4. Insert CreateRangeControl definition and usage
    if 'function CreateRangeControl(' not in content:
        content = content.replace(
            'CreateSpeedControl(310, -60, "Tốc Đánh: ", "AtkSpeedMultiplier", 0.1)',
            'CreateSpeedControl(310, -60, "Tốc Đánh: ", "AtkSpeedMultiplier", 0.1)\n\n' + create_range_control + '\n        CreateRangeControl(310, -100, "Phạm Vi: ", "Mod_CustomAttackRange", 1)'
        )

    # 5. Fix spacing after -------------------------------------------------- lines
    content = re.sub(
        r'(alSepTxt\.text = "--------------------------------------------------"\s*currentY = currentY) - 25',
        r'\1 - 10',
        content
    )
    content = re.sub(
        r'(sepTxt\.text = "--------------------------------------------------"\s*currentY = currentY) - 25',
        r'\1 - 10',
        content
    )
    content = re.sub(
        r'(sep2Txt\.text = "--------------------------------------------------"\s*-- Giữ lại vách ngăn cách cho chức năng khác\s*currentY = currentY) - 20',
        r'\1 - 5',
        content
    )

    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
    print('Updated', file)

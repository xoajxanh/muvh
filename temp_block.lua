local function test()
            title1Txt.alignment = TextAnchor.MiddleLeft
            if defaultFont then title1Txt.font = defaultFont end

            local function CreateSmeltToggle(label, varName, x, y, width, isKeepGood)
                local btnGo = GameObject("SmeltToggle_" .. varName)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(x, y)
                rt.sizeDelta = Vector2(width or btnW, btnH)

                local bg = GameObject("Bg")
                bg.transform:SetParent(btnGo.transform, false)
                local bgRt = bg:AddComponent(typeof(RectTransform))
                bgRt.anchorMin, bgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                bgRt.sizeDelta = Vector2(0, 0)
                local bgImg = bg:AddComponent(typeof(Image))

                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.text = label
                txt.fontSize = fontSize
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end

                if _G.Mod_SmeltConfig == nil then _G.Mod_SmeltConfig = {} end
                if _G.Mod_SmeltConfig[varName] == nil then
                    pcall(function() _G.Mod_SmeltConfig[varName] = (CS.UnityEngine.PlayerPrefs.GetInt("Mod_Smelt_" .. varName, 0) == 1) end)
                    if _G.Mod_SmeltConfig[varName] == nil then _G.Mod_SmeltConfig[varName] = false end
                end

                local function UpdateVisual()
                    if _G.Mod_SmeltConfig[varName] then
                        if isKeepGood then
                            bgImg.color = Color(0.8, 0.5, 0.1, 1) -- Cam cho Giữ Dòng Ngon
                        else
                            bgImg.color = Color(0.2, 0.6, 0.2, 1) -- Xanh lục cho Tách Đồ
                        end
                        txt.color = Color.white
                    else
                        bgImg.color = Color(0.25, 0.25, 0.25, 1)
                        txt.color = Color(0.7, 0.7, 0.7, 1)
                    end
                end
                UpdateVisual()

                local btn = btnGo:AddComponent(typeof(Button))
                btn.onClick:AddListener(function()
                    _G.Mod_SmeltConfig[varName] = not _G.Mod_SmeltConfig[varName]
                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetInt("Mod_Smelt_" .. varName, _G.Mod_SmeltConfig[varName] and 1 or 0)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                    UpdateVisual()
                end)
            end

            local smeltTogglePool = {}

            local function CreateSmeltToggle(prefix, colIdx, x, y, width, isKeepGood)
                local varNameDummy = prefix .. "_" .. colIdx .. (isKeepGood and "_KG" or "")
                local btnGo = GameObject("SmeltToggle_" .. varNameDummy)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(x, y)
                rt.sizeDelta = Vector2(width, btnH)

                local bg = GameObject("Bg")
                bg.transform:SetParent(btnGo.transform, false)
                local bgRt = bg:AddComponent(typeof(RectTransform))
                bgRt.anchorMin, bgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                bgRt.sizeDelta = Vector2(0, 0)
                local bgImg = bg:AddComponent(typeof(Image))

                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 10
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end

                local btn = btnGo:AddComponent(typeof(Button))

                local itemObj = {
                    go = btnGo,
                    bgImg = bgImg,
                    txt = txt,
                    btn = btn,
                    prefix = prefix,
                    colIdx = colIdx,
                    isKeepGood = isKeepGood,
                    varName = nil
                }
                table.insert(smeltTogglePool, itemObj)
                return itemObj
            end

            local curY = -95
            local function CreateTracVietRow(lblText, prefix)
                local lblGo = GameObject("SmeltLbl_" .. prefix)
                lblGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, lblGo)
                local lblRt = lblGo:AddComponent(typeof(RectTransform))
                lblRt.anchorMin, lblRt.anchorMax, lblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                lblRt.anchoredPosition = Vector2(smeltStartX, curY)
                lblRt.sizeDelta = Vector2(85, btnH)
                local lblTxt = lblGo:AddComponent(typeof(Text))
                lblTxt.raycastTarget = false
                lblTxt.text = lblText
                lblTxt.color = Color.white
                lblTxt.fontSize = 12
                lblTxt.alignment = TextAnchor.MiddleLeft
                if defaultFont then lblTxt.font = defaultFont end

                for colIdx = 1, 3 do
                    CreateSmeltToggle(prefix, colIdx, smeltStartX + 88 + (colIdx - 1) * 37, curY, btnW, false)
                end
                curY = curY - 26
            end

            CreateTracVietRow("NHẪN", "Ring")
            CreateTracVietRow("DÂY CHUYỀN", "Necklace")
            CreateTracVietRow("KHUYÊN", "Earring")

            -- 2. VẠCH DASHED NGĂN CÁCH
            curY = curY - 5
            local dashGo = GameObject("SmeltDashLine")
            dashGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, dashGo)
            local dashRt = dashGo:AddComponent(typeof(RectTransform))
            dashRt.anchorMin, dashRt.anchorMax, dashRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            dashRt.anchoredPosition = Vector2(smeltStartX, curY)
            dashRt.sizeDelta = Vector2(230, 15)
            local dashTxt = dashGo:AddComponent(typeof(Text))
            dashTxt.raycastTarget = false
            dashTxt.text = "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"
            dashTxt.color = Color(0.6, 0.6, 0.6, 0.8)
            dashTxt.fontSize = 11
            dashTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then dashTxt.font = defaultFont end

            -- 3. PHẦN 2: TÁCH ĐỒ BỘ & GIỮ DÒNG NGON
            curY = curY - 20
            local title2Go = GameObject("SmeltTitle2")
            title2Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, title2Go)
            local title2Rt = title2Go:AddComponent(typeof(RectTransform))
            title2Rt.anchorMin, title2Rt.anchorMax, title2Rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            title2Rt.anchoredPosition = Vector2(smeltStartX, curY)
            title2Rt.sizeDelta = Vector2(230, 20)
            local title2Txt = title2Go:AddComponent(typeof(Text))
            title2Txt.raycastTarget = false
            title2Txt.text = "TÁCH ĐỒ BỘ & DÒNG NGON"
            title2Txt.color = Color(1, 0.8, 0, 1)
            title2Txt.fontSize = 13
            title2Txt.alignment = TextAnchor.MiddleLeft
            if defaultFont then title2Txt.font = defaultFont end

            curY = curY - 25

            local equipRows = {
                { "MŨ", "Hat" },
                { "ÁO", "Armor" },
                { "QUẦN", "Pants" },
                { "BAO TAY", "Gloves" },
                { "BAO CHÂN", "Boots" },
                { "VŨ KHÍ", "Weapon" },
                { "DÂY CHUYỀN", "Necklace2" },
                { "KHUYÊN TRÁI", "EarringL" },
                { "KHUYÊN PHẢI", "EarringR" },
                { "NHẪN TRÁI", "RingL" },
                { "NHẪN PHẢI", "RingR" },
            }

            for _, r in ipairs(equipRows) do
                local label = r[1]
                local prefix = r[2]

                local lblGo = GameObject("SmeltLbl_" .. prefix)
                lblGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, lblGo)
                local lblRt = lblGo:AddComponent(typeof(RectTransform))
                lblRt.anchorMin, lblRt.anchorMax, lblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                lblRt.anchoredPosition = Vector2(smeltStartX, curY)
                lblRt.sizeDelta = Vector2(85, btnH)
                local lblTxt = lblGo:AddComponent(typeof(Text))
                lblTxt.raycastTarget = false
                lblTxt.text = label
                lblTxt.color = Color.white
                lblTxt.fontSize = 11
                lblTxt.alignment = TextAnchor.MiddleLeft
                if defaultFont then lblTxt.font = defaultFont end

                for colIdx = 1, 4 do
                    CreateSmeltToggle(prefix, colIdx, smeltStartX + 88 + (colIdx - 1) * 37, curY, btnW, false)
                end
                curY = curY - 24
            end

            -- Hàng chọn GIỮ DÒNG NGON
            curY = curY - 5
            local kgLblGo = GameObject("SmeltLbl_KeepGood")
            kgLblGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, kgLblGo)
            local kgLblRt = kgLblGo:AddComponent(typeof(RectTransform))
            kgLblRt.anchorMin, kgLblRt.anchorMax, kgLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            kgLblRt.anchoredPosition = Vector2(smeltStartX, curY)
            kgLblRt.sizeDelta = Vector2(85, btnH)
            local kgLblTxt = kgLblGo:AddComponent(typeof(Text))
            kgLblTxt.raycastTarget = false
            kgLblTxt.text = "GIỮ DÒNG NGON"
            kgLblTxt.color = Color(1, 0.6, 0.2, 1)
            kgLblTxt.fontSize = 10
            kgLblTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then kgLblTxt.font = defaultFont end

            for colIdx = 1, 4 do
                CreateSmeltToggle("KeepGood", colIdx, smeltStartX + 88 + (colIdx - 1) * 37, curY, btnW, true)
            end

            -- Nút TÁCH NGAY thủ công
            curY = curY - 30
            local manualSmeltBtnGo = GameObject("SmeltManualBtn")
            manualSmeltBtnGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, manualSmeltBtnGo)
            local manualSmeltRt = manualSmeltBtnGo:AddComponent(typeof(RectTransform))
            manualSmeltRt.anchorMin, manualSmeltRt.anchorMax, manualSmeltRt.pivot = Vector2(0, 1), Vector2(0, 1),
                Vector2(0, 1)
            manualSmeltRt.anchoredPosition = Vector2(smeltStartX, curY)
            manualSmeltRt.sizeDelta = Vector2(233, 26)

            local manualSmeltBgImg = manualSmeltBtnGo:AddComponent(typeof(Image))
            manualSmeltBgImg.color = Color(0.8, 0.2, 0.2, 1)

            local manualSmeltTxtGo = GameObject("Text")
            manualSmeltTxtGo.transform:SetParent(manualSmeltBtnGo.transform, false)
            local manualSmeltTxtRt = manualSmeltTxtGo:AddComponent(typeof(RectTransform))
            manualSmeltTxtRt.anchorMin, manualSmeltTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            manualSmeltTxtRt.sizeDelta = Vector2(0, 0)
            local manualSmeltTxt = manualSmeltTxtGo:AddComponent(typeof(Text))
            manualSmeltTxt.raycastTarget = false
            manualSmeltTxt.text = "TÁCH NGAY (THỦ CÔNG)"
            manualSmeltTxt.color = Color.white
            manualSmeltTxt.fontSize = 12
            manualSmeltTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then manualSmeltTxt.font = defaultFont end

            local manualSmeltBtn = manualSmeltBtnGo:AddComponent(typeof(Button))
            manualSmeltBtn.targetGraphic = manualSmeltBgImg
            manualSmeltBtn.onClick:AddListener(function()
                pcall(function()
                    if _G.Mod_PerformSmeltItems then
                        _G.Mod_PerformSmeltItems()
                    elseif _G.Mod_ExecuteAutoSmelt then
                        _G.Mod_ExecuteAutoSmelt()
                    end
                    if _G.FloatingWordUtility then
                        _G.FloatingWordUtility.QuickMsg("Đã kích hoạt Tách Đồ thủ công!")
                    end
                    LogMsg("Đã kích hoạt Tách Đồ thủ công!")
                end)
            end)

            -- SUBTABS [ BOSS C7 ] / [ BOSS C8 ]
            local currentY = -155

            local function CreateTierTab(label, tabName)
                local btnGo = GameObject("AutoBossTier_" .. tabName)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.sizeDelta = Vector2(110, 30)

                local img = btnGo:AddComponent(typeof(Image))
                img.color = Color(1, 1, 1, 0)

                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 17
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end

                local btn = btnGo:AddComponent(typeof(Button))
                return { go = btnGo, img = img, txt = txt, btn = btn, tabName = tabName }
            end

            local allTiers = { "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12" }
            local tierTabBtns = {}
            for _, tag in ipairs(allTiers) do
                local tBtn = CreateTierTab("[ BOSS " .. tag .. " ]", tag)
                tBtn.go:SetActive(false)
                tierTabBtns[tag] = tBtn
            end

            currentY = currentY - 35
            local gridStartY = currentY

            local configPool = {}

            local function CreateConfigBtn(idx)
                local btnGo = GameObject("AutoBossConfig_" .. idx)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)

                local img = btnGo:AddComponent(typeof(Image))

                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 14
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end

                local btn = btnGo:AddComponent(typeof(Button))
                return { go = btnGo, rt = rt, img = img, txt = txt, btn = btn }
            end

            local function UpdateTierTabs()
                for _, tBtn in pairs(tierTabBtns) do
                    if tBtn and tBtn.go then
                        tBtn.go:SetActive(false)
                    end
                end

                if _G.ModMainTab ~= "AUTO_BOSS" then return end

                local currentTiers = GetAvailableTiers and GetAvailableTiers() or { "C7", "C8" }
                local isTabValid = false
                for _, tag in ipairs(currentTiers) do
                    if _G.ModAutoBossConfigTab == tag then
                        isTabValid = true; break
                    end
                end
                if not isTabValid and #currentTiers > 0 then
                    _G.ModAutoBossConfigTab = currentTiers[#currentTiers]
                end

                -- REFRESH SMELT DYNAMIC C BUTTONS REACTIONARY TO TOKEN / ACTIVE TAB / PRIMARY TIER
                local mainTag = _G.ModAutoBossConfigTab or currentTiers[#currentTiers] or "C4"
                local activeTabNum = tonumber(string.match(mainTag, "%d+"))
                local x = _G.Mod_Config_Reincarnation_Primary
                    or activeTabNum
                    or (GetPlayerReincarnationLevel and GetPlayerReincarnationLevel())
                    or 4

                -- Trác Việt (3 nút): x-2, x-1, x (Ví dụ: C9 chính -> C7, C8, C9)
                local tracVietTiers = {}
                for _, offset in ipairs({ 2, 1, 0 }) do
                    local tierNum = x - offset
                    if tierNum >= 3 and tierNum <= 12 then
                        table.insert(tracVietTiers, "C" .. tostring(tierNum))
                    end
                end
                if #tracVietTiers == 0 then table.insert(tracVietTiers, "C" .. tostring(x)) end

                -- Đồ Bộ & Giữ Dòng Ngon (4 nút): x-2, x-1, x, x+1 (Ví dụ: C9 chính -> C7, C8, C9, C10)
                local doBoTiers = {}
                for _, offset in ipairs({ 2, 1, 0, -1 }) do
                    local tierNum = x - offset
                    if tierNum >= 3 and tierNum <= 12 then
                        table.insert(doBoTiers, "C" .. tostring(tierNum))
                    end
                end
                if #doBoTiers == 0 then table.insert(doBoTiers, "C" .. tostring(x)) end

                -- Refresh all Smelt Toggles in pool
                for _, toggleItem in ipairs(smeltTogglePool) do
                    local tiersList = (toggleItem.prefix == "Ring" or toggleItem.prefix == "Necklace" or toggleItem.prefix == "Earring") and tracVietTiers or doBoTiers
                    local tag = tiersList[toggleItem.colIdx]
                    if tag then
                        toggleItem.go:SetActive(true)
                        toggleItem.txt.text = tag
                        local varName = toggleItem.prefix .. "_" .. tag
                        toggleItem.varName = varName

                        if _G.Mod_SmeltConfig == nil then _G.Mod_SmeltConfig = {} end
                        if _G.Mod_SmeltConfig[varName] == nil then
                            pcall(function() _G.Mod_SmeltConfig[varName] = (CS.UnityEngine.PlayerPrefs.GetInt("Mod_Smelt_" .. varName, 0) == 1) end)
                            if _G.Mod_SmeltConfig[varName] == nil then _G.Mod_SmeltConfig[varName] = false end
                        end

                        local function updateToggleVisual()
                            if _G.Mod_SmeltConfig[varName] then
                                if toggleItem.isKeepGood then
                                    toggleItem.bgImg.color = Color(0.8, 0.5, 0.1, 1)
                                else
                                    toggleItem.bgImg.color = Color(0.2, 0.6, 0.2, 1)
                                end
                                toggleItem.txt.color = Color.white
                            else
                                toggleItem.bgImg.color = Color(0.25, 0.25, 0.25, 1)
                                toggleItem.txt.color = Color(0.7, 0.7, 0.7, 1)
                            end
                        end
                        updateToggleVisual()

                        toggleItem.btn.onClick:RemoveAllListeners()
                        toggleItem.btn.onClick:AddListener(function()
                            _G.Mod_SmeltConfig[varName] = not _G.Mod_SmeltConfig[varName]
                            pcall(function()
                                CS.UnityEngine.PlayerPrefs.SetInt("Mod_Smelt_" .. varName, _G.Mod_SmeltConfig[varName] and 1 or 0)
                                CS.UnityEngine.PlayerPrefs.Save()
                            end)
                            updateToggleVisual()
                        end)
                    else
                        toggleItem.go:SetActive(false)
                    end
                end

                -- Hide all config toggles

end

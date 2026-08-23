ZoomSecretRealmManager = {}

function ZoomSecretRealmManager:GetUseItemTransferDefenseDes(_itemId)
  if _itemId == nil then
    return
  end
  local monsterDamageAbsorptionShow = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow)
  local globalEffect = GlobalConfig.GetGlobalConfig(65002001)
  if string.isNullOrEmpty(globalEffect) then
    return
  end
  local globalEffectTab = TableParse:SplitStringToIntListList(globalEffect, "&", "#")
  if table.count(globalEffectTab) == 0 then
    return
  end
  local desFormat, color = "\236\182\148\236\178\156 \235\176\169\236\150\180\235\160\165: %s", ItemQuality2ColorDic[5]
  for i, v in pairs(globalEffectTab) do
    if v[1] == _itemId then
      color = monsterDamageAbsorptionShow >= v[2] and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
      return string.GetColorText(string.format(desFormat, v[2]), color)
    end
  end
  return
end

function ZoomSecretRealmManager:GetCanCallBossPropDataTab()
  local globalEffect = GlobalConfig.GetGlobalConfig(65002002)
  if string.isNullOrEmpty(globalEffect) then
    return
  end
  local globalEffectTab = TableParse:SplitStringToIntListList(globalEffect, "&", "#")
  if table.count(globalEffectTab) == 0 then
    return
  end
  return globalEffectTab
end

function ZoomSecretRealmManager:GetCanCallPropPromptId(_itemId, _isBuy)
  if _itemId == nil or _isBuy == nil then
    return
  end
  local globalEffect = GlobalConfig.GetGlobalConfig(65002004)
  if string.isNullOrEmpty(globalEffect) then
    return
  end
  local globalEffectTab = TableParse:SplitStringToIntListList(globalEffect, "&", "#")
  if table.count(globalEffectTab) == 0 then
    return
  end
  for i, v in pairs(globalEffectTab) do
    if v[1] == _itemId then
      return _isBuy and v[3] or v[2]
    end
  end
  return
end

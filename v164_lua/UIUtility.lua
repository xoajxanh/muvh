local UIUtility = {}

function UIUtility.ShowTips(data)
  if data == nil then
    return
  end
  UIManager.Show(UIID.ItemTipUI, data)
end

function UIUtility.BindUIContainerTemp(object, template, parentUI, templateData)
  local function onCreateItem(ctr)
    ctr.itemTemp = luaTemplateManager.GetNewTemplate(ctr, template, templateData, parentUI)
  end
  
  local function onRefreshItem(ctr, _, data, ui)
    if ctr.itemTemp then
      ctr.itemTemp:Refresh(data, ui)
    end
  end
  
  return UIContainer(object, parentUI, onCreateItem, onRefreshItem)
end

function UIUtility.GetDicLength(dic)
  if dic == nil then
    return 0
  end
  local index = 0
  for i, v in pairs(dic) do
    index = index + 1
  end
  return index
end

function UIUtility.GetShowUnitConversion(num, conversion)
  if num == nil then
    return tostring(num)
  end
  local intNum = tonumber(num)
  if intNum == nil then
    return tostring(num)
  end
  local wan = 10000
  local yi = 100000000
  local wanYi = 1000000000000
  if conversion == UnitConversion.OnlyYi then
    local OnlyYi = intNum / yi
    if 1 < OnlyYi then
      return string.format("%.2f", OnlyYi) .. " tr\196\131m tri\225\187\135u"
    else
      return num
    end
  end
  local calculationResults_wan = intNum / wan
  if calculationResults_wan < 1 then
    return tostring(num)
  end
  local calculationResults_yi = intNum / yi
  if calculationResults_yi < 1 then
    return string.format("%.2f", calculationResults_wan) .. " v\225\186\161n"
  end
  local calculationResults_wanyi = intNum / wanYi
  if calculationResults_wanyi < 1 then
    return string.format("%.2f", calculationResults_yi) .. " tr\196\131m tri\225\187\135u"
  end
  return string.format("%.2f", calculationResults_wanyi) .. "Tri\225\187\135u"
end

function UIUtility.GetLevlDes(level)
  if tonumber(level) then
  end
  if level == nil then
    level = QuickFind.LuaMainPlayerViewAttrData().level
  end
  local tbl = ClientTable.cfg_Character_levelManager:TryGetValue(tonumber(level))
  if tbl == nil or string.isNullOrEmpty(tbl.name) then
    return level
  end
  return tbl.name
end

function UIUtility.RefreshAutoRoleMpHpSetting()
  local hp = QiJiHelperData.SettingData.recoverHp
  local hpNum = Mathf.Floor(hp * 100)
  local mp = QiJiHelperData.SettingData.recoverMp
  local mpNum = Mathf.Floor(mp * 100)
  networkRequest.ReqRoleMpHpSetting(hpNum, mpNum)
end

return UIUtility

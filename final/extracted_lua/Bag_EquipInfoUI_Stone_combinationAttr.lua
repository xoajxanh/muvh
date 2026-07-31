local Bag_EquipInfoUI_Stone_combinationAttr = class()

function Bag_EquipInfoUI_Stone_combinationAttr:ctor(trans, ui)
  self.trans = trans
  self.ui = ui
  self.StoneData = ViewData.meData.equipsData.StoneData
  self.EquipStoneCombination, self.EquipStoneCombinationKey = RoleEquipUtility.GetEquipStoneCombination()
  self:InitUI()
end

function Bag_EquipInfoUI_Stone_combinationAttr:InitUI()
  local Viewport = UIControl(self.trans.transform, "sw_stoneLightAttribute/Viewport/firstContent")
  local obj
  local index = 1
  for k, vv in pairs(self.EquipStoneCombinationKey) do
    local v = self.EquipStoneCombination[vv]
    if index > Viewport.transform.childCount then
      obj = Instantiate(Viewport.transform:GetChild(0).gameObject)
      obj.transform:SetParent(Viewport.transform, false)
    else
      obj = Viewport.transform:GetChild(index - 1).gameObject
    end
    self:SetSecendUIInfo(obj, v)
    index = index + 1
  end
  LayoutRebuilder:ForceRebuildLayoutImmediate(Viewport.rectTransform)
end

function Bag_EquipInfoUI_Stone_combinationAttr:SetSecendUIInfo(objUI, lightData)
  local secendIconTrans = UIControl(objUI.transform, "Viewport")
  local secendAttributeTrans = UIControl(objUI.transform, "sw_lightAttribute")
  self:SetThreeAttributeInfo(secendAttributeTrans, lightData)
  self:SetThreeIconInfo(secendIconTrans, self.notOpenCellLightItem)
end

local stoneTagByName = {
  [11] = "huobaoshi",
  [12] = "shuibaoshi",
  [13] = "bingbaoshi",
  [14] = "fengbaoshi",
  [15] = "leibaoshi",
  [16] = "tubaoshi"
}

function Bag_EquipInfoUI_Stone_combinationAttr:SetThreeIconInfo(trans, lightData)
  local condition = lightData.tbl.condition
  local conditionTbl = string.split(condition, "&")
  local obj
  for i = 1, #conditionTbl do
    if i > trans.transform.childCount then
      obj = Instantiate(trans.transform:GetChild(0).gameObject)
      obj.transform:SetParent(trans.transform, false)
    else
      obj = trans.transform:GetChild(i - 1).gameObject
    end
    local objUI = UIControl(obj)
    local stoneName = UIControl(obj.transform, "lab_stoneName")
    local conditionStr = conditionTbl[i]
    local secendTbl = string.split(conditionStr, "#")
    local level = tonumber(secendTbl[3])
    local stoneType = tonumber(secendTbl[1])
    local tblnum = tonumber(secendTbl[2])
    local tagName = ""
    local cfg_Ui_wordTable = ClientTable.cfg_Ui_wordManager:TryGetValue(stoneTagByName[stoneType])
    if cfg_Ui_wordTable ~= nil then
      tagName = cfg_Ui_wordTable.content
    end
    local StoneData = RoleEquipUtility.GetStoneAllTypeTbl(self.StoneData)
    local isHave = false
    local haveNum = 0
    if StoneData[stoneType] then
      haveNum = #StoneData[stoneType]
      if tblnum <= haveNum then
        haveNum = RoleEquipUtility.GetSingleConditionIsOk(StoneData[stoneType], level)
        if tblnum <= haveNum then
          isHave = true
        end
      end
    end
    local itemid = stoneType * 1000000 + 10010
    local iconName = ClientTable.cfg_Item_itemManager:TryGetValue(itemid).icon
    self.ui:SetSprite("Atlas_Icon", iconName, objUI)
    stoneName.text.color = isHave and Color(0.9, 0.9, 0.9, 1) or Color(0.5, 0.5, 0.5, 1)
    stoneName:SetText(string.format("Lv.%d%s: %d/%d", level, tagName, haveNum, tblnum))
  end
end

function Bag_EquipInfoUI_Stone_combinationAttr:SetThreeAttributeInfo(trans, lightData)
  self.notOpenCellLightItem = nil
  local obj
  for i = 1, #lightData do
    if i > trans.transform.childCount then
      obj = Instantiate(trans.transform:GetChild(0).gameObject)
      obj.transform:SetParent(trans.transform, false)
    else
      obj = trans.transform:GetChild(i - 1).gameObject
    end
    local objUI = UIControl(obj)
    local itemData = lightData[i]
    local level = itemData.level
    objUI.text.color = itemData.isOpen and Color(1, 1, 0, 1) or Color(0.5, 0.5, 0.5, 1)
    if not self.notOpenCellLightItem and (not itemData.isOpen or i == #lightData) then
      self.notOpenCellLightItem = itemData
    end
    objUI:SetText(string.format("T\225\186\165t c\225\186\163 \196\144\195\161 Lv%d: ", level))
    local str = self:SetAttributeName(itemData.tbl)
    str = table.concat(str, "  ")
    objUI:SetText(objUI.text.text .. str)
  end
end

local blackAttribute = {
  id = true,
  combinationId = true,
  condition = true,
  fight = true
}

function Bag_EquipInfoUI_Stone_combinationAttr:SetAttributeName(lightDataItem)
  local txtTable = {}
  for k, v in pairs(lightDataItem) do
    if not blackAttribute[k] and v ~= 0 then
      local word = RoleEquipUtility.GetEquipAtttribute(k, v, k)
      table.insert(txtTable, word)
    end
  end
  return txtTable
end

function Bag_EquipInfoUI_Stone_combinationAttr:SetAttributeInfo()
end

return Bag_EquipInfoUI_Stone_combinationAttr

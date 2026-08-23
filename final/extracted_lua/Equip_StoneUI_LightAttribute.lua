local Equip_StoneUI_LightAttribute = class()

function Equip_StoneUI_LightAttribute:ctor(trans, curSelectEquip, ui)
  self.trans = trans
  self.curSelectEquip = curSelectEquip
  self.ui = ui
  self.EquipStoneLight, self.EquipStoneLightKey = RoleEquipUtility.GetEquipStoneLight(curSelectEquip)
  self:InitUI()
end

function Equip_StoneUI_LightAttribute:InitUI()
  local Viewport = UIControl(self.trans.transform, "sw_stoneLightAttribute/Viewport/firstContent")
  local obj
  local index = 1
  for k, vv in pairs(self.EquipStoneLightKey) do
    if index > Viewport.transform.childCount then
      obj = Instantiate(Viewport.transform:GetChild(0).gameObject)
      obj.transform:SetParent(Viewport.transform, false)
    else
      obj = Viewport.transform:GetChild(index - 1).gameObject
    end
    local v = self.EquipStoneLight[vv]
    self:SetSecendUIInfo(obj, v)
    index = index + 1
  end
  LayoutRebuilder:ForceRebuildLayoutImmediate(Viewport.rectTransform)
end

function Equip_StoneUI_LightAttribute:SetSecendUIInfo(objUI, lightData)
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

function Equip_StoneUI_LightAttribute:SetThreeIconInfo(trans, lightData)
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
    local level = secendTbl[3]
    local type = tonumber(secendTbl[2])
    local cellIndex = tonumber(secendTbl[1])
    local tagName = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(stoneTagByName[type])
    local StoneData = ViewData.meData.equipsData.StoneData
    local isHave = false
    if StoneData[cellIndex] and StoneData[cellIndex].valid then
      local tblItem = StoneData[cellIndex].tblItem
      if tblItem.quality >= tonumber(level) and tblItem.type == type then
        isHave = true
      end
    end
    local itemid = type * 1000000 + 10010
    local iconName = ClientTable.cfg_Item_itemManager:TryGetValue(itemid).icon
    self.ui:SetSprite("Atlas_Icon", iconName, objUI)
    stoneName.text.color = isHave and Color(0.9, 0.9, 0.9, 1) or Color(0.5, 0.5, 0.5, 1)
    stoneName:SetText(string.format("Kh\225\186\163m \196\144\195\161 %d:%s Lv%s", cellIndex % 100, level, tagName))
  end
end

function Equip_StoneUI_LightAttribute:SetThreeAttributeInfo(trans, lightData)
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
  type = true,
  equipPosition = true,
  lightId = true,
  condition = true,
  fight = true,
  maximumPhysBaseDmg = true,
  minimumPhysBaseDmg = true,
  minimumWizBaseDmg = true,
  maximumWizBaseDmg = true
}

function Equip_StoneUI_LightAttribute:SetAttributeName(lightDataItem)
  local txtTable = {}
  for k, v in pairs(lightDataItem) do
    if not blackAttribute[k] and v ~= 0 then
      local word = AttributeWordUtil.GetUIWord(tostring(k), "equipeUI")
      local str = string.format(word, v)
      table.insert(txtTable, str)
    end
  end
  return txtTable
end

function Equip_StoneUI_LightAttribute:SetAttributeInfo()
end

return Equip_StoneUI_LightAttribute

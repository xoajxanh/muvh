local XiLianManager = {}
require("GameConst/XiLianEnum")
XiLianManager.XiLianEquipCellData = nil
XiLianManager.XiLianNewExcellenceServerData = nil

function XiLianManager:SetXiLianEquip(equipCellData, source)
  if UIManager.IsVisible(UIID.Equip_XiLianUI) == false then
    return
  end
  if equipCellData == nil or equipCellData.itemData == nil then
    return
  end
  if source == XiLianEquipDataSource.Equip_XiLianUI or source == XiLianEquipDataSource.EquipChange and self.XiLianEquipCellData ~= nil and self.XiLianEquipCellData.itemData.id == equipCellData.itemData.id or source == XiLianEquipDataSource.BagChange and self.XiLianEquipCellData ~= nil and self.XiLianEquipCellData.itemData.id == equipCellData.itemData.id then
    self.XiLianEquipCellData = equipCellData
    EventManager.Dispatch(Event.Equip_XiLianChange, self.XiLianEquipCellData)
  end
end

function XiLianManager:SetXiLianEquipByEquipData(equipData, source)
  if equipData == nil or equipData.tblItem == nil or UIManager.IsVisible(UIID.Equip_XiLianUI) == false or ItemUtility.IsEquipType(equipData.tblItem.type) == false then
    return
  end
  local itemCellData = ItemCellData()
  itemCellData:RefreshData(equipData)
  self:SetXiLianEquip(itemCellData, source)
end

function XiLianManager:SetXiLianEquipByServerDataList(itemInfoList)
  if type(itemInfoList) ~= "table" or next(itemInfoList) == nil or self.XiLianEquipCellData == nil or self.XiLianEquipCellData.itemData == nil then
    return
  end
  for k, v in pairs(itemInfoList) do
    if v.id == self.XiLianEquipCellData.itemData.id then
      self.XiLianEquipCellData.itemData:RefreshData(v)
      self:SetXiLianEquip(self.XiLianEquipCellData, XiLianEquipDataSource.BagChange)
      break
    end
  end
end

function XiLianManager:ClearXiLianData()
  self.XiLianEquipCellData = nil
end

function XiLianManager:IsXiLianEquip(id)
  return self.XiLianEquipCellData ~= nil and self.XiLianEquipCellData.itemData ~= nil and self.XiLianEquipCellData.itemData.id == id
end

function XiLianManager:HaveXiLianObj()
  return self.XiLianEquipCellData ~= nil and self.XiLianEquipCellData.itemData
end

function XiLianManager:HaveExcellenceList()
  return self:HaveXiLianObj() and #self.XiLianEquipCellData.itemData:GetEquipExcellenceDesList() > 0
end

function XiLianManager:NeedCost()
  return self:HaveXiLianObj() and type(self.XiLianEquipCellData.itemData:GetXilianCost()) == "table" and #self.XiLianEquipCellData.itemData:GetXilianCost() > 0
end

function XiLianManager:SetXiLianNewExcellenceList(data)
  self.XiLianNewExcellenceServerData = data
  self.serverDataIsDirty = true
  self.XiLianEquipCellData.itemData:SetXiLianExcellenceList(data)
  if UIManager.IsVisible(UIID.Equip_XiLianShowUI) then
    EventManager.Dispatch(Event.Equip_XiLianNewExcellenceChange)
  else
    UIManager.Show(UIID.Equip_XiLianShowUI)
  end
end

function XiLianManager:GetXiLianNewExcellenceTemplateDesList()
  if self.serverDataIsDirty then
    self.serverDataIsDirty = false
    self.xiLianNewExcellenceTemplateDesList = {}
    local xiLianExcellenceDesList = RoleEquipUtility.GetEquipExcellenceDesByServerInfo(self.XiLianNewExcellenceServerData)
    if type(xiLianExcellenceDesList) == "table" and 0 < #xiLianExcellenceDesList then
      for k, v in pairs(xiLianExcellenceDesList) do
        table.insert(self.xiLianNewExcellenceTemplateDesList, {name = v, nextIsNil = true})
      end
    end
  end
  if self.xiLianNewExcellenceTemplateDesList == nil and self.XiLianEquipCellData ~= nil and self.XiLianEquipCellData.itemData ~= nil then
    self.xiLianNewExcellenceTemplateDesList = self.XiLianEquipCellData.itemData:GetXiLianExcellenceTemplateDesList()
  end
  return self.xiLianNewExcellenceTemplateDesList
end

function XiLianManager:HaveNewExcellenceList()
  return #self:GetXiLianNewExcellenceTemplateDesList() > 0
end

function XiLianManager:ClearXiLianNewExcellenceList()
  self.XiLianNewExcellenceServerData = nil
  self.serverDataIsDirty = nil
  self.xiLianNewExcellenceTemplateDesList = nil
end

return XiLianManager

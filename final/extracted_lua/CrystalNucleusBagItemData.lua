CrystalNucleusBagItemData = class()
CrystalNucleusBagItemData.m_ServerInfo = nil
CrystalNucleusBagItemData.m_ItemConfig = nil

function CrystalNucleusBagItemData:RefreshData(_data)
  if _data == nil then
    return
  end
  self:InitData(_data)
end

function CrystalNucleusBagItemData:InitData(_data)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(_data.itemId)
  if itemConfig == nil then
    return
  end
  self.m_ServerInfo = _data
  self.m_ItemConfig = itemConfig
end

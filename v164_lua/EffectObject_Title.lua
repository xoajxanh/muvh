local EffectObject_Title = {}
setmetatable(EffectObject_Title, LuaClass.EffectObject)

function EffectObject_Title:GetEffectName()
  return self.titleName
end

function EffectObject_Title:GetEffectPath()
  return self.effectPath
end

function EffectObject_Title:Refresh(data)
  self:Reset()
  if data == nil or string.isNullOrEmpty(data.titleName) and data.itemId == nil then
    return
  end
  local itemId = data.itemId
  if itemId == nil then
    local titleTab = ClientTable.cfg_Equip_TitleManager:TryGetValue(data.titleName, "typeName")
    if titleTab == nil then
      return
    end
    itemId = titleTab.itemId
  end
  local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  if itemTbl == nil or string.isNullOrEmpty(itemTbl.modelEffect) then
    return
  end
  local itemEquipModelTab = ClientTable.cfg_Item_equip_modeleffectManager:TryGetValue(tonumber(itemTbl.modelEffect))
  if itemEquipModelTab == nil or string.isNullOrEmpty(itemEquipModelTab.name) then
    return
  end
  self.parentPanel = data.panel
  self.layer = data.layer or UI_LAYER
  self.titleName = itemEquipModelTab.name
  self.effectPath = ResourceConfig.GetUIEffectPathByItemData(itemEquipModelTab.name)
  self.position = data.position ~= nil and data.position or string.isNullOrEmpty(itemEquipModelTab.offset) and Vector3.zero or TableParse:SplitStringToVectorData(itemEquipModelTab.offset, "#")
  local ratio = self.layer == UI_LAYER and 1 or 0.01
  self.scale = data.scale ~= nil and data.scale or string.isNullOrEmpty(itemEquipModelTab.scale) and {
    x = 1 * ratio,
    y = 1 * ratio,
    z = 1 * ratio
  } or TableParse:SplitStringToVectorData(itemEquipModelTab.scale, "#", ratio)
end

function EffectObject_Title:GetEffectPosition()
  return self.position
end

function EffectObject_Title:GetEffectRotation()
end

function EffectObject_Title:GetEffectScale()
  return self.scale
end

function EffectObject_Title:GetLayer()
  return self.layer
end

function EffectObject_Title:GetOrderLayer()
  local orderLayer = 400
  if self.parentPanel then
    orderLayer = self.parentPanel.root.canvas.sortingOrder
  end
  return orderLayer
end

function EffectObject_Title:Reset()
  self.titleName = nil
  self.effectPath = nil
  self.parentPanel = nil
end

return EffectObject_Title

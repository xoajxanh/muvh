local cfg_EquipCell_cellManager = {}

function cfg_EquipCell_cellManager:GetName()
  return "cfg_EquipCell_cellManager"
end

function cfg_EquipCell_cellManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_EquipCell_cell")
  end
  return self.dic
end

setmetatable(cfg_EquipCell_cellManager, TableManagerBase)

function cfg_EquipCell_cellManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_EquipCell_cellManager:GetStoneCellDic()
  if self.mStoneCellDic == nil then
    self:InitData()
  end
  return self.mStoneCellDic
end

function cfg_EquipCell_cellManager:GetBagIndexByBasicIndexDic()
  if self.mBagIndexByBasicIndexDic == nil then
    self:InitData()
  end
  return self.mBagIndexByBasicIndexDic
end

function cfg_EquipCell_cellManager:GetBagIndexTblByEquipTypeDic()
  if self.mBagIndexTblByEquipTypeDic == nil then
    self:InitData()
  end
  return self.mBagIndexTblByEquipTypeDic
end

function cfg_EquipCell_cellManager:GetBagIndexByBasicIndexAndType(type, basicIndex)
  if self:GetBagIndexByBasicIndexDic()[type] == nil then
  end
  return self:GetBagIndexByBasicIndexDic()[type][basicIndex]
end

function cfg_EquipCell_cellManager:InitData()
  self.mStoneCellDic = {}
  self.mBagIndexByBasicIndexDic = {}
  self.mBagIndexTblByEquipTypeDic = {}
  if self:GetDic() == nil then
    return
  end
  for i, v in pairs(self:GetDic()) do
    if v then
      self:ForeachDicCallBack(v)
    end
  end
end

function cfg_EquipCell_cellManager:ForeachDicCallBack(data)
  if data.cellType == 2 and data.relationPosition ~= 0 then
    if self.mStoneCellDic[data.relationPosition] == nil then
      self.mStoneCellDic[data.relationPosition] = {}
    end
    table.insert(self.mStoneCellDic[data.relationPosition], {
      inlayIndex = data.index,
      equipIndex = data.relationPosition,
      condition = data.useCondition,
      cellTbl = data
    })
  end
  self:DoSaveIndexInfo(data)
end

function cfg_EquipCell_cellManager:DoSaveIndexInfo(data)
  if self.mBagIndexByBasicIndexDic[data.cellType] == nil then
    self.mBagIndexByBasicIndexDic[data.cellType] = {}
  end
  if data.basicPosition then
    self.mBagIndexByBasicIndexDic[data.cellType][data.basicPosition] = data.index
  end
  if self.mBagIndexTblByEquipTypeDic[data.cellType] == nil then
    self.mBagIndexTblByEquipTypeDic[data.cellType] = {}
  end
  table.insert(self.mBagIndexTblByEquipTypeDic[data.cellType], data.index)
end

function cfg_EquipCell_cellManager:GetStoneList(equipIndex)
  if type(equipIndex) ~= "number" then
    return
  end
  local stoneCellDic = self:GetStoneCellDic()
  if type(stoneCellDic) ~= "table" then
    return
  end
  return stoneCellDic[equipIndex]
end

function cfg_EquipCell_cellManager:GetCellTblByServerItemData(serverItemData)
  if serverItemData == nil or serverItemData.bagGridIndex == nil then
    return
  end
  return self:TryGetValue(serverItemData.bagGridIndex)
end

cfg_EquipCell_cellManager.IntensifyEquipIndexTypeDic = nil

function cfg_EquipCell_cellManager:InitIntensifyEquipIndexTypeDic()
  if self.IntensifyEquipIndexTypeDic ~= nil then
    return self.IntensifyEquipIndexTypeDic
  end
  self.IntensifyEquipIndexTypeDic = {}
  local dic = self:GetDic()
  for k, v in pairs(dic) do
    if v.intensifyLimit > 0 then
      if self.IntensifyEquipIndexTypeDic[v.cellType] == nil then
        self.IntensifyEquipIndexTypeDic[v.cellType] = {}
      end
      table.insert(self.IntensifyEquipIndexTypeDic[v.cellType], v)
    end
  end
  for k, v in pairs(self.IntensifyEquipIndexTypeDic) do
    table.sort(v, self.EquipIndexIntensifyCompare)
  end
  return self.IntensifyEquipIndexTypeDic
end

function cfg_EquipCell_cellManager.EquipIndexIntensifyCompare(cellTbl1, cellTbl2)
  return cellTbl1.intensifyIndex < cellTbl2.intensifyIndex
end

function cfg_EquipCell_cellManager:GetIntensifyEquipIndex(cellType)
  if cellType == nil then
    return
  end
  self:InitIntensifyEquipIndexTypeDic()
  return self.IntensifyEquipIndexTypeDic[cellType]
end

function cfg_EquipCell_cellManager:GetEquipIndexPrefix(equipCellType)
  if equipCellType == EquipCellType.HONGZHUANG then
    return 3500
  end
  return 0
end

function cfg_EquipCell_cellManager:GetCellTblByPosition(equipPosition)
  if type(equipPosition) ~= "string" then
    return
  end
  local positionList = string.split(equipPosition, "#")
  return self:TryGetValue(tonumber(positionList[1]))
end

function cfg_EquipCell_cellManager:GetCurPosition(cellId)
  if type(cellId) ~= "number" then
    return cellId
  end
  local cellTbl = self:TryGetValue(cellId)
  if cellTbl.basicPositionSetting <= 0 then
    return cellId
  end
  return cellTbl.basicPositionSetting
end

function cfg_EquipCell_cellManager:GetOriginPosition(cellType, suitType, ObjIndex)
  self:InitOriginPositionDic()
  if type(cellType) ~= "number" or type(suitType) ~= "number" or type(ObjIndex) ~= "number" then
    return
  end
  if type(self.OriginPositionDic) ~= "table" or type(self.OriginPositionDic[cellType]) ~= "table" then
    if type(suitType) == "number" then
      return suitType * 100 + ObjIndex
    end
    return
  end
  if self.OriginPositionDic[cellType] == nil or self.OriginPositionDic[cellType][ObjIndex] == nil then
    return
  end
  return self.OriginPositionDic[cellType][ObjIndex].index
end

function cfg_EquipCell_cellManager:InitOriginPositionDic()
  if self.OriginPositionDic == nil then
    self.OriginPositionDic = {}
    local dic = self:GetDic()
    for k, v in pairs(dic) do
      if v.basicPositionSetting > 0 then
        if self.OriginPositionDic[v.cellType] == nil then
          self.OriginPositionDic[v.cellType] = {}
        end
        self.OriginPositionDic[v.cellType][v.basicPositionSetting] = v
      end
    end
  end
end

return cfg_EquipCell_cellManager

ETableDataPoolType = {
  EquipeIntensifyCfg = enum(1),
  EquipZhuijiaCfg = enum(),
  ItemEquipGrowUpCfg = enum(),
  ItemEquipCfg = enum(),
  ItemEquipLuckyCfg = enum(),
  ItemEquipExcellenceCfg = enum()
}
TableDataPool = {}
TableDataPool.data = {}

function TableDataPool.Recycle(dataType, data)
  if string.isNullOrEmpty(dataType) then
    return
  end
  if data == nil then
    return
  end
  if TableDataPool.data[dataType] == nil then
    TableDataPool.data[dataType] = {}
  end
  table.insert(TableDataPool.data[dataType], data)
end

function TableDataPool.Spawn(dataType)
  if TableDataPool.data[dataType] == nil then
    return {}
  end
  return table.remove(TableDataPool.data[dataType]) or {}
end

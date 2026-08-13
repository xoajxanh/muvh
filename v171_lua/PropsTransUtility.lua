PropsTransUtility = {}
local this = PropsTransUtility
ProItem = {
  BeforeItem = enum(0),
  CurrentItem = enum(1),
  AfterItem = enum(2)
}

function PropsTransUtility.GetCareerItemIDTbl()
  local carItemBbl = ClientTable.cfg_Career_transfer_itemManager:GetDic()
  local wingIDTbl = {}
  for k, v in pairs(carItemBbl) do
    table.insert(wingIDTbl, v.id)
  end
  return wingIDTbl
end

function PropsTransUtility.GetCareerPropItemTbl(itemId)
  local carItemBbl = ConfigManager.GetConfig("cfg_Career_transfer_item", itemId, "id")
  return carItemBbl
end

function PropsTransUtility.GetCanCareerPropItem(itemId)
  local carItemBbl = ConfigManager.GetConfig("cfg_Career_transfer_item", itemId, "id")
  if carItemBbl then
    return carItemBbl.transferItemId
  end
end

function PropsTransUtility.GetCanPropItemCost(itemId)
  local carItemBbl = ConfigManager.GetConfig("cfg_Career_transfer_item", itemId, "id")
  if carItemBbl then
    return carItemBbl.cost
  end
end

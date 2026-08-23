local Commercial_NetNiudanManager = {}
setmetatable(Commercial_NetNiudanManager, LuaClass.HolidayActivity)
Commercial_NetNiudanManager.group = 36001
Commercial_NetNiudanManager.ShowItemData = {}
Commercial_NetNiudanManager.OnClickType = false
Commercial_NetNiudanManager.ModelType = nil

function Commercial_NetNiudanManager:Init()
  self:InitData()
end

function Commercial_NetNiudanManager:InitData()
  self.ServerData = nil
  self.CommercialNiudanItemDic = self:InitItemData()
  self.CommercialNiudanItemList = {}
end

function Commercial_NetNiudanManager:InitShowData(data)
  if data then
    self.ShowItemData = data
  end
end

function Commercial_NetNiudanManager:ServerClientRefreshData(data)
  if not data or self.CommercialNiudanItemDic == nil then
    return
  end
  if self.ModelType == nil then
    self.ModelType = ViewData.meData.id
  elseif self.ModelType ~= ViewData.meData.id then
    self.ModelType = ViewData.meData.id
    self:InitData()
  end
  for i, v in ipairs(self.CommercialNiudanItemDic) do
    v.wcActive = 0
    v.lqActive = 0
  end
  self.ServerData = data
  for i, v in ipairs(data.getRewards) do
    self.CommercialNiudanItemDic[v].lqActive = 1
  end
  for i, v in ipairs(data.goalIds) do
    self.CommercialNiudanItemDic[v].wcActive = 1
  end
  for i, v in ipairs(data.goals) do
    self.CommercialNiudanItemDic[v.goalId].goals = v.current
  end
  self.CommercialNiudanItemList = {}
  local wcTable = {}
  local itemList = {}
  local lqTable = {}
  for i, v in ipairs(self.CommercialNiudanItemDic) do
    if v.lqActive == 1 then
      table.insert(lqTable, v)
    elseif v.wcActive == 1 then
      table.insert(wcTable, v)
    else
      table.insert(itemList, v)
    end
  end
  table.combine(wcTable, itemList)
  table.combine(wcTable, lqTable)
  self.CommercialNiudanItemList = wcTable
  EventManager.Dispatch(Event.NiudanDataRefresh)
end

function Commercial_NetNiudanManager:GetData()
  return self.CommercialNiudanItemList
end

function Commercial_NetNiudanManager:InitItemData()
  local niudan = ClientTable.cfg_Commerce_niudantaskManager:GetDic()
  local DataList = {}
  if niudan ~= nil then
    for i, v in ipairs(niudan) do
      DataList[i] = {
        id = v.id,
        Tbl = v,
        wcActive = 0,
        lqActive = 0,
        mission = v.mission,
        goals = 0
      }
    end
  end
  return DataList
end

function Commercial_NetNiudanManager:ResetActivityData()
end

function Commercial_NetNiudanManager:GetNiudanData()
  local Niudanlist = {}
  local niudan = ClientTable.cfg_Commerce_niudanManager:GetDic()
  if not niudan then
    return
  end
  local itemData = {}
  for i, v in ipairs(niudan) do
    if v.group == self.group then
      table.insert(itemData, v)
    end
  end
  if #itemData <= 0 then
    return
  end
  for i, v in ipairs(itemData) do
    Niudanlist[i] = {
      itemId = v.itemId,
      name = v.name,
      count = v.count,
      group = v.group,
      effect = v.effect,
      basemapIcon = string.split(v.basemap, "#")[1],
      basemapLogIcon = string.split(v.basemap, "#")[2]
    }
  end
  return Niudanlist
end

function Commercial_NetNiudanManager:InitShowEffectData()
  if not self.ShowItemData.configIds then
    return
  end
  local max = 0
  for i, v in pairs(self.ShowItemData.configIds) do
    if v > max then
      max = v
    end
  end
  return ClientTable.cfg_Commerce_niudanManager:TryGetValue(max, "id").effect
end

function Commercial_NetNiudanManager:InitShowRewardData()
  if not self.ShowItemData.configIds then
    return
  end
  local ItemData = {}
  local data = ClientTable.cfg_Commerce_niudanManager:GetDic()
  for i, v in pairs(data) do
    for j, m in pairs(self.ShowItemData.configIds) do
      if v.id == m then
        local itemInfo = ItemUtility.GenerateItemData(tonumber(v.itemId))
        itemInfo.count = v.count
        table.insert(ItemData, itemInfo)
      end
    end
  end
  return ItemData
end

function Commercial_NetNiudanManager:GetRewardRedPoint()
  local function ItemList()
    for i, v in ipairs(self.CommercialNiudanItemList) do
      if v.lqActive == 0 and v.wcActive == 1 then
        return true
      end
    end
  end
  
  local effect = ClientTable.cfg_Commerce_globalManager:TryGetValue(319001).effect
  if not string.isNullOrEmpty(effect) then
    local imgId = string.split(effect, "#")[1]
    if BagInfoData.GetItemTotalCountByItemId(tonumber(imgId)) > 0 or ItemList() then
      return true
    end
  end
  return false
end

function Commercial_NetNiudanManager:GetEffectData()
  return self.ShowItemData
end

return Commercial_NetNiudanManager

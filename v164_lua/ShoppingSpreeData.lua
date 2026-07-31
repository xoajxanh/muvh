local ShoppingSpreeData = {}
setmetatable(ShoppingSpreeData, LuaClass.HolidayActivity)

function ShoppingSpreeData:Init()
  self:InitData()
end

function ShoppingSpreeData:InitData()
  self.data = nil
  local recharge = ClientTable.cfg_Commerce_globalManager:TryGetValue(314001)
  self.rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(tonumber(recharge.effect))
end

function ShoppingSpreeData:RefreshServerData(data)
  self.data = data
end

function ShoppingSpreeData:GetData()
  return self.data
end

function ShoppingSpreeData:GetShoppingSpreeShowGoods()
  local goods = {}
  for i, v in pairs(ClientTable.cfg_Commerce_shoppingcartManager:GetDic()) do
    if ConditionManager.Check4D(v.showCondition) then
      local item = {tbl = v, count = 0}
      if self.data and self.data.historyBuyList and self.data.historyBuyList then
        item.count = self.data.historyBuyList[v.id]
      end
      table.insert(goods, item)
    end
  end
  table.sort(goods, function(a, b)
    return a.tbl.commodityRanking < b.tbl.commodityRanking
  end)
  return goods
end

function ShoppingSpreeData:GetShoppingSpreeCarGoods()
  local goods = {}
  if self.data and self.data.shoppingCar then
    for i = 1, 4 do
      local v = self.data.shoppingCar[i]
      local item = {tbl = nil, count = 0}
      if v ~= nil then
        item.tbl = ClientTable.cfg_Commerce_shoppingcartManager:TryGetValue(v)
      end
      table.insert(goods, item)
    end
  end
  return goods
end

function ShoppingSpreeData:IsExistCar(id)
  for i, v in ipairs(self.data.shoppingCar) do
    if id == v then
      return true
    end
  end
  return false
end

function ShoppingSpreeData:CheckIsShowRedPoint()
  return false
end

function ShoppingSpreeData:ResetActivityData()
end

return ShoppingSpreeData

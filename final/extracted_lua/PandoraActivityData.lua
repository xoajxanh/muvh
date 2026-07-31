PandoraActivityData = {}
local this = PandoraActivityData
this.PandoraActivityAllRateInfo = {}
this.selectIndex = 1
this.selectIndexAll = {}
this.lastLayer = nil
this.lastRoleGetRewardInfo = {}
this.isAbnormalClose = false
this.lastRoleId = nil
this.nowSelectTogCommerceId = nil
this.lastOpenTogIndex = 1

function PandoraActivityData.Init()
  this.configData = ClientTable.cfg_Commerce_pandoraManager:GetDic()
  this.allGroupRewardInfo = this.GetRewardInfoWithGroup()
end

function PandoraActivityData.InitTotalWeight()
  this.total = 0
  for i, v in pairs(this.configData) do
    if v.group == 1 and v.commerceId == this.nowSelectTogCommerceId then
      this.total = v.weight + this.total
    end
  end
end

function PandoraActivityData.GetLastLayer()
  return this.lastLayer
end

function PandoraActivityData.SetLastLayer(layer)
  this.lastLayer = layer
end

function PandoraActivityData.GetMaximumNumberOfLevels()
  local maxLayer = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(64001004).effect)
  return maxLayer
end

function PandoraActivityData.CheckLoggedThisRole(rid)
  if this.selectIndexAll[rid] == nil then
    this.selectIndexAll[rid] = 1
  end
  return this.selectIndexAll[rid]
end

function PandoraActivityData.SetIsAbnormalClose(isAbnormal)
  this.isAbnormalClose = isAbnormal
end

function PandoraActivityData.GetIsAbnormalClose()
  return this.isAbnormalClose
end

function PandoraActivityData.SetLastRoleGetRewardInfo(rid, info)
  if this.lastRoleGetRewardInfo[rid] == nil then
    this.lastRoleGetRewardInfo[rid] = {}
  end
  this.lastRoleGetRewardInfo[rid] = info
end

function PandoraActivityData.GetLastRoleGetRewardInfo(rid)
  return this.lastRoleGetRewardInfo[rid]
end

function PandoraActivityData.GetRewardInfoWithGroup()
  local allInfo = {}
  for i, v in pairs(this.configData) do
    if allInfo[v.group] == nil then
      allInfo[v.group] = {}
    end
    table.insert(allInfo[v.group], v)
  end
  return allInfo
end

function PandoraActivityData.SetPandoraActivityAllRateInfo()
  this.InitTotalWeight()
  local rewardTable = {}
  for i, v in pairs(this.configData) do
    if v.commerceId == this.nowSelectTogCommerceId then
      if rewardTable[v.group] == nil then
        rewardTable[v.group] = {}
      end
      if v.group == 1 then
        table.insert(rewardTable[1], {
          rewardName = v.rewardName,
          weight = v.weight / this.total * 100,
          group = v.group,
          type = v.type,
          id = v.id,
          count = v.count,
          color = v.color,
          poolName = v.poolName
        })
      else
        local weight
        if v.group > 1 and v.type >= 2 then
          weight = v.weight / 1000000
        elseif v.group > 1 and v.type == 1 then
          local infoTbl = this.allGroupRewardInfo[v.group]
          for j, k in pairs(infoTbl) do
            if k.type == v.type + 1 then
              weight = k.weight / 1000000
              break
            end
          end
        end
        table.insert(rewardTable[v.group], {
          rewardName = v.rewardName,
          weight = weight,
          group = v.group,
          type = v.type,
          id = v.id,
          count = v.count,
          color = v.color,
          poolName = v.poolName
        })
      end
    end
  end
  if table.count(rewardTable) == 0 then
    return
  end
  table.sort(rewardTable[1], function(a, b)
    if a.type == b.type then
      return a.id < b.id
    else
      return a.type > b.type
    end
  end)
  for i = 2, #rewardTable do
    table.sort(rewardTable[i], function(a, b)
      return a.type > b.type
    end)
  end
  this.PandoraActivityAllRateInfo = rewardTable
end

function PandoraActivityData.GetPandoraActivityAllRateInfo()
  return this.PandoraActivityAllRateInfo
end

function PandoraActivityData.GetPandoraActivityOverViewList()
  local dataTab = {}
  local configTab = ConfigManager.FindConfigs("cfg_Commerce_overview", "commerceType", 10)
  if configTab == nil then
    return
  end
  for i, v in ipairs(configTab) do
    if v and v.condition and ConditionManager.Check(v.condition) and v.level and ConditionManager.Check4D(v.level) then
      table.insert(dataTab, v)
    end
  end
  if table.count(dataTab) == 0 then
    return
  end
  table.sort(dataTab, function(a, b)
    return a.order < b.order
  end)
  return dataTab
end

function PandoraActivityData.GetPandoraActivityRewardShowInfo(commerceId)
  local currentIndexRewardShowTbl = {}
  local rewardShowTbl = ClientTable.cfg_Commerce_pandorashowManager:GetDic()
  for i, v in ipairs(rewardShowTbl) do
    if v and v.showOn and v.showOn == 1 then
      table.insert(currentIndexRewardShowTbl, v)
    end
  end
  if table.count(currentIndexRewardShowTbl) == 0 then
    return
  end
  this.rewardData = {}
  local career = QuickFind.LuaMainPlayerViewAttrData():GetBaseCareerByValue(RoleManager.me.career)
  for i, v in ipairs(currentIndexRewardShowTbl) do
    local careerTbl = string.split(v.show, "&")
    for j, k in ipairs(careerTbl) do
      local isShow = string.split(k, "#")
      if tonumber(isShow[1]) == career and isShow[2] == "1" then
        local itemTbl = string.split(v.itemId, "#")
        table.insert(this.rewardData, tonumber(itemTbl[j]))
        break
      end
    end
  end
  if 0 < #this.rewardData then
    return this.rewardData
  else
    return nil
  end
end

function PandoraActivityData.GetPandoraActivityShopShowInfo()
  local shopShowTbl = {}
  local cfgInfo = ClientTable.cfg_Commerce_pandorashowManager:GetDic()
  for i, v in ipairs(cfgInfo) do
    if v.itemBuy > 0 then
      if shopShowTbl[v.group] == nil then
        shopShowTbl[v.group] = {}
      end
      table.insert(shopShowTbl[v.group], v)
      shopShowTbl[v.group].itemBuyId = v.itemBuy
    end
  end
  if table.count(shopShowTbl) == 0 then
    return
  end
  this.shopData = {}
  local career = QuickFind.LuaMainPlayerViewAttrData():GetBaseCareerByValue(RoleManager.me.career)
  for ii, vv in ipairs(shopShowTbl) do
    for i, v in ipairs(vv) do
      local careerTbl = string.split(v.show, "&")
      for j, k in ipairs(careerTbl) do
        local isShow = string.split(k, "#")
        if tonumber(isShow[1]) == career and isShow[2] == "1" then
          local itemTbl = string.split(v.itemId, "#")
          if this.shopData[ii] == nil then
            this.shopData[ii] = {}
          end
          table.insert(this.shopData[ii], tonumber(itemTbl[j]))
          break
        end
      end
      this.shopData[ii].itemBuyId = vv.itemBuyId
    end
  end
  if 0 < #this.shopData then
    table.sort(this.shopData, function(a, b)
      local itemBuyCfg1 = ClientTable.cfg_Item_buyManager:TryGetValue(a.itemBuyId)
      local itemBuyCfg2 = ClientTable.cfg_Item_buyManager:TryGetValue(b.itemBuyId)
      return itemBuyCfg1.commodityRanking < itemBuyCfg2.commodityRanking
    end)
    return this.shopData
  else
    return nil
  end
end

function PandoraActivityData.GetPandoraActivityRoleModelShowInfo(rewardData, parent)
  local equip = {}
  for i, v in ipairs(rewardData) do
    local reward = ItemUtility.GenerateItemData(v)
    reward.bagGridIndex = RoleEquipUtility.GetWearEquipPosition(reward)
    table.insert(equip, reward)
  end
  local career = QuickFind.LuaMainPlayerViewAttrData():GetBaseCareerByValue(RoleManager.me.career)
  if career == 11 or career == 14 then
    local secondWeapon = ItemUtility.GenerateItemData(rewardData[1])
    secondWeapon.bagGridIndex = tonumber(string.split(secondWeapon.tblEquip.equipPosition, "#")[2])
    table.insert(equip, secondWeapon)
  end
  local viewRoleData = {}
  viewRoleData.equipsData = RoleEquipData(equip)
  viewRoleData.career = ViewData.meData.career
  viewRoleData.modelType = EModelType.Charactor
  viewRoleData.model = ERoleModelName.default
  viewRoleData.id = tonumber(viewRoleData.model)
  viewRoleData.roleName = ViewData.meData.name
  viewRoleData.serverCoord = Vector2Int()
  viewRoleData.roleType = ERoleType.Player
  viewRoleData.parent = parent
  viewRoleData.animationName = "idle"
  viewRoleData.modelScale = 1
  return viewRoleData
end

function PandoraActivityData.CheckDiamondEnough()
  local diamond = BagInfoData.GetItemCountByItemConfigId(ECoinsType.gem)
  local diamondBind = BagInfoData.GetItemCountByItemConfigId(ECoinsType.gemNotTrade)
  if diamond + diamondBind < 100 then
    return false
  else
    return true
  end
end

function PandoraActivityData.GetGoodPrizeFromConfig()
  if this.configData == nil then
    return nil
  end
  local poolData = this.GetNowSelectPoolData()
  if poolData == nil or poolData.itemId == nil then
    return nil
  end
  local rewardData = {}
  for i, v in pairs(this.configData) do
    if v.itemId == tonumber(poolData.itemId) then
      table.insert(rewardData, v)
    end
  end
  return rewardData
end

function PandoraActivityData.GetBigSuccessLevel()
  if this.configData == nil then
    return nil
  end
  local bigSuccessLevel = {}
  for i, v in pairs(this.configData) do
    if v.type == 3 then
      table.insert(bigSuccessLevel, v.group)
    end
  end
  return bigSuccessLevel
end

function PandoraActivityData.GetNextLayerRewardData(layer, type)
  local nextLayer = layer + 1
  local GoodPrizeTbl = this.GetGoodPrizeFromConfig()
  local bigSuccessLevel = this.GetBigSuccessLevel()
  if next(GoodPrizeTbl) == nil then
    return false
  end
  if not table.contains(bigSuccessLevel, nextLayer) and type == 3 then
    return false
  end
  for i, v in pairs(GoodPrizeTbl) do
    if v.group == nextLayer and v.type == type then
      return v
    end
  end
end

function PandoraActivityData.CheckFreeDigCount()
  local poolData = this.GetNowSelectPoolData()
  if poolData == nil or poolData.count == nil then
    return false
  end
  if RechargeData.GetCount(poolData.count) == 0 then
    return true
  else
    return false
  end
end

function PandoraActivityData.SetNowSelectTogCommerceId(id)
  this.nowSelectTogCommerceId = id
end

function PandoraActivityData.GetNowSelectTogCommerceId()
  return this.nowSelectTogCommerceId
end

function PandoraActivityData.GetNowSelectPoolData()
  local curCommerceId = this.GetNowSelectTogCommerceId()
  if curCommerceId == nil then
    return
  end
  local poolData = ClientTable.cfg_Commerce_pandorapoolManager:TryGetValue(curCommerceId, "commerceId")
  if poolData == nil then
    return
  end
  return poolData
end

function PandoraActivityData.SetLastOpenTogIndex(index)
  this.lastOpenTogIndex = index
end

function PandoraActivityData.GetLastOpenTogIndex()
  return this.lastOpenTogIndex
end

function PandoraActivityData.ResetLastOpenTogIndex()
  this.lastOpenTogIndex = 1
end

this.Init()

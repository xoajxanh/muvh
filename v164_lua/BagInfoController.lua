require("GameModel/BagInfoData")
require("GameConst/RecycleEnum")
BagInfoController = {}
local this = BagInfoController

function BagInfoController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.OpenBag()
  this.reqSortCol = nil
end

function BagInfoController.OpenBag()
  this.RegistMessages()
end

function LoginController.CloseBag()
  this.messageContainer:UnRegistAll()
end

function BagInfoController.RegistMessages()
  this.messageContainer:Regist(BagMessage.ResBagInfo, this.OnResBagInfo)
  this.messageContainer:Regist(BagMessage.ResUseItem, this.OnResUseItem)
  this.messageContainer:Regist(BagMessage.ResBagChange, this.OnResBagChange)
  this.messageContainer:Regist(MapMessage.ResCallFlag, this.ShowTipCallFlag)
  this.messageContainer:Regist(BagMessage.ResItemInfoUpdate, this.ResItemInfoUpdate)
  this.messageContainer:Regist(BagMessage.ResStorageInfo, this.OnResStorageInfo)
  this.messageContainer:Regist(BagMessage.ResStorageUpdate, this.OnResStorageUpdate)
  this.messageContainer:Regist(BagMessage.ResStorageGridExtend, this.OnResStorageGridExtend)
end

function BagInfoController.ShowTipCallFlag(_, msg)
  local titleStr = ""
  local content = ""
  if msg.type == 1 then
    local tableTemp = ClientTable.cfg_Ui_wordManager:TryGetValue("Call_union")
    if tableTemp ~= nil then
      content = tableTemp.content
    end
  elseif msg.type == 2 then
    local tableTemp = ClientTable.cfg_Ui_wordManager:TryGetValue("Call_team")
    if tableTemp ~= nil then
      content = tableTemp.content
    end
  else
    local tableTemp = ClientTable.cfg_Ui_wordManager:TryGetValue("Call_camp")
    if tableTemp ~= nil then
      content = tableTemp.content
    end
  end
  titleStr = string.format(content, msg.callName)
  local promptTipArgs = {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = titleStr,
    ok = function()
      NetManager.Send(MapMessage.ReqCallFlag, {
        type = msg.type,
        rid = msg.rid,
        mapId = msg.mapId,
        line = msg.line,
        x = msg.x,
        y = msg.y,
        hostId = msg.hostId
      })
    end
  }
  UIManager.Show(UIID.PromptTipUI, promptTipArgs)
end

function BagInfoController.OnResBagInfo(_, msg)
  if msg ~= nil then
    BagInfoData.BagReSet()
    BagInfoData.UpdateCoins(msg.coins)
    BagInfoData.curBagCellCount = msg.gridCount
    BagInfoData.InitFreeSpace()
    local itemDataList = {}
    for _, item in pairs(msg.items) do
      local itemData = BagInfoData.SaveAndConfigInfo(BagInfoData.TotalItems, item, true)
      table.insert(itemDataList, itemData)
    end
    BagInfoData.GetBagGridCalcManager():InsertItemList(itemDataList)
    BagInfoData.RefreshFreeListAndUsedList()
    this.CheckBagSpaceAndAutoRecycle()
    BagInfoData.RefreshRecycle()
  end
  EventManager.Dispatch(Event.Bag_CoinChanged, msg)
  EventManager.Dispatch(Event.Bag_ResBagInfo)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function BagInfoController.OnResUseItem(_, msg)
  if msg ~= nil then
    EventManager.Dispatch(Event.Bag_ResUseItem, msg)
  end
end

function BagInfoController.GetBestFitRecoverItem(id)
  local recoverPriority = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(id), "&")
  for i = 1, #recoverPriority do
    local recoverItem = string.split(recoverPriority[i], "#")
    if LoginData.GetOpenServerDay() >= tonumber(recoverItem[1]) then
      return tonumber(recoverItem[2])
    end
  end
end

function BagInfoController.RemoveRecoverItemAtBagChange(msg)
  if msg.logType == BagChangeTypeEnum.Recycle then
    return
  end
  
  local function RemoveZeroCountRecoverItem(priority, id, priorityId)
    local count = 0
    local index = 0
    local itemId = 0
    for i, v in ipairs(SkillSettingData.skill_use_items) do
      if v ~= 0 and priority[v] then
        count = count + 1
        index = i
        itemId = v
      end
    end
    local recoverPriority = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(id), "&")
    if count == 0 then
      local itemCount = 0
      for i, v in ipairs(recoverPriority) do
        itemCount = BagInfoData.GetItemCountByItemConfigId(tonumber(v))
        if itemCount ~= 0 then
          index = SkillSettingData.GetSpaceItemIndex(tonumber(v))
          SkillSettingData.SetItem(index, tonumber(v))
          break
        end
      end
    elseif count == 1 then
      local itemCount = BagInfoData.GetItemCountByItemConfigId(itemId)
      if itemCount == 0 then
        SkillSettingData.SetItem(index, 0)
        local isReplace = false
        for i, v in ipairs(recoverPriority) do
          itemCount = BagInfoData.GetItemCountByItemConfigId(tonumber(v))
          if itemCount ~= 0 then
            isReplace = true
            SkillSettingData.SetItem(index, tonumber(v))
            break
          end
        end
        if not isReplace then
          itemId = this.GetBestFitRecoverItem(priorityId)
          index = SkillSettingData.GetSpaceItemIndex(itemId)
          SkillSettingData.SetItem(index, itemId)
        end
      else
        local manualIndex = SkillSettingData.GetManualItemIndex(itemId)
        if manualIndex == -1 then
          for i, v in ipairs(recoverPriority) do
            itemCount = BagInfoData.GetItemCountByItemConfigId(tonumber(v))
            if itemCount ~= 0 then
              SkillSettingData.SetItem(index, tonumber(v))
              break
            end
          end
        end
      end
    elseif 1 < count then
      local removeCount = 0
      for i, v in ipairs(SkillSettingData.skill_use_items) do
        if v ~= 0 and priority[v] then
          local itemCount = BagInfoData.GetItemCountByItemConfigId(v)
          if itemCount == 0 then
            SkillSettingData.SetItem(i, 0)
            removeCount = removeCount + 1
          end
        end
      end
      if removeCount == count then
        itemId = this.GetBestFitRecoverItem(priorityId)
        index = SkillSettingData.GetSpaceItemIndex(itemId)
        SkillSettingData.SetItem(index, itemId)
      end
    end
  end
  
  RemoveZeroCountRecoverItem(SkillSettingData.hpPriorityId, 2390004, 2390011)
  RemoveZeroCountRecoverItem(SkillSettingData.mpPriorityId, 2390005, 2390012)
  for i = 1, #SkillSettingData.skill_use_items do
    local itemId = SkillSettingData.skill_use_items[i]
    if not SkillSettingData.hpPriorityId[itemId] and not SkillSettingData.mpPriorityId[itemId] then
      local itemCount = BagInfoData.GetItemCountByItemConfigId(itemId)
      if itemCount <= 0 then
        SkillSettingData.SetItem(i, 0)
      end
    end
  end
end

function BagInfoController.SetOtherItems(msg)
  if msg.logType == BagChangeTypeEnum.Recycle then
    return
  end
  
  local function RefreshOtherItem(itemId)
    local itemIndex = 0
    local itemCount = BagInfoData.GetItemCountByItemConfigId(itemId)
    for i, v in ipairs(SkillSettingData.skill_use_items) do
      if v == itemId then
        itemIndex = i
        break
      end
    end
    if 0 < itemIndex then
      if 0 < itemCount then
        SkillSettingData.SetItem(itemIndex, itemId)
      else
        SkillSettingData.SetItem(itemIndex, 0)
      end
    elseif 0 < itemCount then
      local index = SkillSettingData.GetSpaceItemIndex(itemId)
      if 0 < index then
        SkillSettingData.SetItem(index, itemId)
      end
    end
  end
  
  RefreshOtherItem(20000021)
  RefreshOtherItem(20000022)
end

function BagInfoController.OnShowChangeInfo(msg, showTbl)
  if msg.logType == BagChangeTypeEnum.Recycle and table.count(showTbl) > 0 then
    BagInfoData.RecycleItemTbl = {}
    BagInfoData.RecycleCancel = {}
    EventManager.Dispatch(Event.Bag_RefreshShowSell)
    if this.reqSortCol then
      Timer.Stop()
      this.reqSortCol = nil
    end
    FloatingWordUtility.QuickMsg("Nh\225\186\173n khi thu h\225\187\147i")
    this.reqSortCol = Timer.Start(0.1, function()
      if not UIManager.IsVisible(UIID.Equip_Decompose) then
        NetManager.Send(BagMessage.ReqBagSort)
      end
    end)
  elseif msg.logType == BagChangeTypeEnum.Mail then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
    end
  elseif msg.logType == BagChangeTypeEnum.Shop then
    if table.count(showTbl) > 0 then
    end
  elseif msg.logType == BagChangeTypeEnum.Decompose then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      EventManager.Dispatch(Event.Bag_DecomposeInfoClose)
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.Recharge then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.RechargeReward then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.Gift then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.GiftDiam then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.OnlineGift then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.OptionalBox then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {
        rewards = showTbl,
        type = BagChangeTypeEnum.OptionalBox
      })
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.KaLunTeBox then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {
        rewards = showTbl,
        type = BagChangeTypeEnum.OptionalBox
      })
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.TreasureGiftProp then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.WarAllianceRedEnvelope then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.SevenDayGift then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.HolidayInvest then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  elseif msg.logType == BagChangeTypeEnum.HolidayNiudan then
    if table.count(showTbl) > 0 then
      EventManager.Dispatch(Event.NiudanDataRefresh)
    end
  elseif msg.logType == BagChangeTypeEnum.ShoppingSpree then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
    end
  elseif msg.logType == BagChangeTypeEnum.PuzzleFenJie then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
    end
  elseif msg.logType == BagChangeTypeEnum.EnchantmentSmeltingBagChange then
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_SmeltUI, {rewards = showTbl})
    end
    EventManager.Dispatch(Event.Bag_EnchantmentSmeltingBagChange)
  end
end

function BagInfoController.FloatingWordCoins(showCoins, removeTbl, msg)
  if msg then
    for i, v in pairs(showCoins) do
      local text = string.format("Sau khi quy\195\170n g\195\179p t\225\187\149ng qu\225\187\185 Guild   %s ", msg.coins[1].count)
      FloatingWordUtility.QuickMsg(text)
    end
  else
    for i, v in pairs(showCoins) do
      local text = string.format("nh\225\186\173n %s%s", v.tblItem.name, v.count)
      FloatingWordUtility.QuickMsg(text)
    end
  end
  for i, v in pairs(removeTbl) do
    local count = v.count * -1
    local text = string.format("Ti\195\170u hao %s%s", v.tblItem.name, count)
    if count ~= 0 then
      FloatingWordUtility.QuickMsg(text)
    end
  end
end

function BagInfoController.FloatingWordItems(removeItems, reduceTbl, showItems, msg)
  local RemovePropsInfo = {}
  for _, itemData in pairs(removeItems) do
    if RemovePropsInfo[itemData.itemId] then
      RemovePropsInfo[itemData.itemId].count = RemovePropsInfo[itemData.itemId].count + itemData.count
    else
      local ii = ItemUtility.GenerateItemData(itemData.itemId)
      ii.count = itemData.count
      RemovePropsInfo[itemData.itemId] = ii
    end
  end
  for itemId, itemInfo in pairs(reduceTbl) do
    if RemovePropsInfo[itemId] then
      RemovePropsInfo[itemId].count = RemovePropsInfo[itemId].count + itemInfo.count
    else
      local ii = ItemUtility.GenerateItemData(itemId)
      ii.count = itemInfo.count
      RemovePropsInfo[itemId] = ii
    end
  end
  if table.count(showItems) ~= 0 then
    for _, itemInfo in pairs(showItems) do
      local ii = ItemUtility.GenerateItemData(itemInfo.itemId)
      ii.count = itemInfo.count
      ii.id = itemInfo.id
      ii.bagGridIndex = itemInfo.bagGridIndex
      if itemInfo.honourAttr then
        ii.HonourAttribute = itemInfo.honourAttr
      end
      showItems[_] = ii
    end
  end
  for _, itemData in pairs(RemovePropsInfo) do
    if msg.logType ~= BagChangeTypeEnum.Putoff then
      FloatingWordUtility.RemoveProps(itemData)
    end
  end
  for _, itemData in pairs(showItems) do
    if msg.logType ~= BagChangeTypeEnum.Takeoff and msg.logType ~= BagChangeTypeEnum.LuckyDraw then
      FloatingWordUtility.GetProps(itemData)
    end
  end
end

function BagInfoController.RecycleFreeNodes(removeItems)
  BagInfoData.GetBagGridCalcManager():RemoveItemList(removeItems)
  BagInfoData.RefreshFreeListAndUsedList()
end

function BagInfoController.InsertItemDatas(getTbl)
  BagInfoData.GetBagGridCalcManager():InsertItemList(getTbl)
  BagInfoData.RefreshFreeListAndUsedList()
end

function BagInfoController.AutoUseItem(getTbl)
  local needUsedItem = {}
  for _, itemData in ipairs(getTbl) do
    if string.contains(itemData.tblItem.useParam, "32#") then
      table.insert(needUsedItem, Items)
    end
  end
  for _, item in ipairs(needUsedItem) do
    local useItemTbl = {
      useCount = item.count,
      useItemId = item.id,
      configId = item.itemId
    }
    ItemUtility.UseItem(useItemTbl)
  end
end

function BagInfoController.CheckBagSpaceAndAutoRecycle()
  BagInfoData.CheckBagSpace()
  BagInfoData.CheckBagFiveSpace()
  EventManager.Dispatch(Event.Bag_FullState)
  DelayRefreshManager:Add(BagInfoController.AutoRecycle, 1)
end

function BagInfoController.AutoRecycle()
  local flag, tbl = BagInfoData.GetAutoRecycleItemTbl()
  if flag and tbl ~= nil then
    networkRequest.ReqItemRecycle(tbl.recycleItems, RecycleWayType.Bag)
  end
end

function BagInfoController.OnResBagChange(_, msg)
  if msg ~= nil then
    if msg.storageType == StorageTypeEnum.SacredBone then
      gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():OnResBagChange(msg)
    end
    if msg.storageType == StorageTypeEnum.PandoraBag then
      BagInfoController.OnResPandoraUpdate(_, msg)
      return
    end
    local showCoins, removeTbl = BagInfoData.UpdateCoins(msg.coins)
    if table.count(msg.coins) ~= 0 then
      EventManager.Dispatch(Event.Bag_CoinChanged, msg)
      EventManager.Dispatch(Event.RP_RedPointRefresh, {
        index = ERedPointType.hookProfit,
        state = true
      })
    end
    local removeItems = BagInfoData.RemoveItems(msg.removeItem)
    local showItems, reduceTbl, getTbl, TrueTbl, TruereduceTbl = BagInfoData.UpdateTotalItems(msg.items)
    if msg.logType ~= BagChangeTypeEnum.Recycle then
      this.RecycleFreeNodes(removeItems)
      this.InsertItemDatas(getTbl)
    end
    if msg.logType ~= BagChangeTypeEnum.LuckyDraw and msg.logType ~= BagChangeTypeEnum.LuckyRebate then
      if msg.logType == BagChangeTypeEnum.WarAllianceFund then
        this.FloatingWordCoins(showCoins, removeTbl, msg)
      else
        this.FloatingWordCoins(showCoins, removeTbl)
      end
    end
    this.FloatingWordItems(removeItems, reduceTbl, showItems, msg)
    this.RemoveRecoverItemAtBagChange(msg)
    this.SetOtherItems(msg)
    TipData.GuidEquip(msg, TrueTbl)
    local showTbl = table.merge(showItems, showCoins)
    this.OnShowChangeInfo(msg, showTbl)
    if msg.logType ~= BagChangeTypeEnum.Recycle then
      this.CheckBagSpaceAndAutoRecycle()
      this.AutoUseItem(getTbl)
    end
    local bagInfo = {
      removeItems = removeItems,
      showItems = msg.items,
      logType = msg.logType,
      reduceTbl = reduceTbl,
      showItemTbl = showItems,
      TruereduceTbl = TruereduceTbl
    }
    EventManager.Dispatch(Event.Bag_ResBagChange, bagInfo)
    this:RefreshBagInfoChangeDelayList(bagInfo)
    if not table.contains(ForgeData.equipFunction, EForgeDataEnum.Intensify) then
      for i = 1, table.count(msg.items) do
        if table.contains(EItemIdEnum, msg.items[i].itemId) or showItems[msg.items[i].itemId] and showItems[msg.items[i].itemId].tblItem.subType == EItemSubtype.Wing then
          table.insert(ForgeData.equipFunction, EForgeDataEnum.Intensify)
          NetManager.Send(UnitMessage.ReqEquipFunction, {
            type = EForgeDataEnum.Intensify,
            open = true
          })
          NetManager.Send(UnitMessage.ReqEquipFunction, {
            type = EForgeDataEnum.Transfer,
            open = true
          })
          EventManager.Dispatch(Event.Fuc_SingleRefresh, {
            EForgeDataEnum.Intensify,
            EForgeDataEnum.Forge,
            EForgeDataEnum.Transfer
          })
          break
        end
      end
    end
    if not table.contains(ForgeData.equipFunction, EForgeDataEnum.Ornaments) then
      for i = 1, table.count(msg.items) do
        if showItems[msg.items[i].itemId] and (showItems[msg.items[i].itemId].tblItem.subType == EItemSubtype.Ring or showItems[msg.items[i].itemId].tblItem.subType == EItemSubtype.Necklace or showItems[msg.items[i].itemId].tblItem.subType == EItemSubtype.Earrings) then
          table.insert(ForgeData.equipFunction, EForgeDataEnum.Ornaments)
          NetManager.Send(UnitMessage.ReqEquipFunction, {
            type = EForgeDataEnum.Ornaments,
            open = true
          })
          EventManager.Dispatch(Event.Fuc_SingleRefresh, {
            EForgeDataEnum.Ornaments
          })
          break
        end
      end
    end
    if not UIManager.IsVisible(UIID.NewBagInfoUI) and msg.items and 0 < table.count(msg.items) then
      for _, itemInfo in pairs(msg.items) do
        local itemData = ItemUtility.GenerateItemDataByServerData(itemInfo)
        if itemData.tblItem.type == EItemType.Equipe and RoleEquipUtility.CanUpFight(itemData) == EquipUpState.CantWearUpFight then
          table.insert(BagInfoData.EquipItemIds, itemInfo.id)
        end
      end
    end
  end
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function BagInfoController.OnResStorageInfo(_, msg)
  if msg ~= nil then
    BagInfoData.StorageReSet()
    BagInfoData.curStorageCount = msg.gridCount
    for _, item in pairs(msg.items) do
      BagInfoData.SaveAndConfigInfo(BagInfoData.storageInfos, item)
    end
  end
  EventManager.Dispatch(Event.Bag_ResStorageInfo)
end

function BagInfoController.OnResStorageUpdate(_, msg)
  local removeItems = BagInfoData.RemoveStorageItem(msg.removeItem)
  BagInfoData.UpdateStorageItems(msg.item)
  EventManager.Dispatch(Event.Bag_ResStorageUpdate, {
    removeItems = removeItems,
    showItems = msg.item
  })
end

function BagInfoController.OnResPandoraInfo(msg)
  if msg ~= nil then
    BagInfoData.PandoraReSet()
    for _, item in pairs(msg.items) do
      BagInfoData.SaveAndConfigInfo(BagInfoData.pandoraBagInfos, item)
    end
  end
  BagInfoData.CheckPandoraBagSpace()
  EventManager.Dispatch(Event.Bag_ResPandoraInfo)
end

function BagInfoController.OnResPandoraUpdate(_, msg)
  local removeItems = BagInfoData.RemovePandoraItem(msg.removeItem)
  BagInfoData.UpdatePandoraItems(msg.items)
  BagInfoData.CheckPandoraBagSpace()
  EventManager.Dispatch(Event.Bag_ResPandoraUpdate, {
    removeItems = removeItems,
    showItems = msg.items
  })
end

function BagInfoController.ResItemInfoUpdate(_, msg)
  if msg then
    local moveItems = msg.items
    if msg.type == EDragUIType.Bag then
      BagInfoData.MoveItem(BagInfoData.TotalItems, moveItems, true)
    elseif msg.type == EDragUIType.WarehouseInfoUI then
      BagInfoData.MoveItem(BagInfoData.storageInfos, moveItems)
    end
    EventManager.Dispatch(Event.Bag_ResItemInfoUpdateMessage, msg)
    this.CheckBagSpaceAndAutoRecycle()
  end
end

function BagInfoController.OnResStorageGridExtend(_, msg)
  if msg.type then
    msg.type = msg.type == EDragUIType.Bag and EDragUIType.Bag or EDragUIType.WarehouseInfoUI
  end
  if msg.type == EDragUIType.Bag then
    BagInfoData.curBagCellCount = msg.gridCount
    BagInfoData.InitFreeSpace()
    BagInfoData.GetBagGridCalcManager():InsertItemList(BagInfoData.TotalItems)
    BagInfoData.RefreshFreeListAndUsedList()
  else
    BagInfoData.curStorageCount = msg.gridCount
  end
  EventManager.Dispatch(Event.Bag_GridUpdate, msg)
end

function BagInfoController.UseItemReq(count, id, param, configId)
  if configId == 20000022 then
    ForgeData.isUseInMap = true
    if QiJiHelperData.isAutoFight then
      ForgeData.UseRandomStoneState = EUseStoneRecordEnum.Fight
    elseif table.count(RoleManager.me.movePath) > 0 then
      ForgeData.UseRandomStoneState = EUseStoneRecordEnum.Path
    end
  end
  NetManager.Send(BagMessage.ReqUseItem, {
    count = count,
    itemId = id,
    clientParams = param
  })
end

function BagInfoController:SetCurSelectItemInfo(itemInfo)
  BagInfoData.curSelectItem = itemInfo
end

function BagInfoController:GetCurSelectItemInfo()
  return BagInfoData.curSelectItem
end

function BagInfoController:SetCurSelectWingInfo(itemInfo)
  BagInfoData.curSelectWing = itemInfo
end

function BagInfoController:GetCurSelectWingInfo()
  return BagInfoData.curSelectWing
end

function BagInfoController:RefreshBagInfoChangeDelayList(bagInfo)
  if self.bagInfoChangeDelayList == nil then
    self.bagInfoChangeDelayList = {}
  end
  table.insert(self.bagInfoChangeDelayList, bagInfo)
  DelayRefreshManager:Add(self.SendEventAndDeleteDelayList, 0.5, true)
end

function BagInfoController.SendEventAndDeleteDelayList()
  EventManager.Dispatch(Event.Bag_ResBagChangeDelay, this.bagInfoChangeDelayList)
  if type(this.bagInfoChangeDelayList) ~= "table" then
    return
  end
  for i = #this.bagInfoChangeDelayList, 1, -1 do
    table.remove(this.bagInfoChangeDelayList)
  end
end

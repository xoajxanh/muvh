require("GameModel/AuctionData")
require("GameConst/AuctionEnum")
AuctionController = {}
local this = AuctionController

function AuctionController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function AuctionController.RegistMessages()
  this.messageContainer:Regist(TradeMessage.ResPutOn, this.OnResPutOn)
  this.messageContainer:Regist(TradeMessage.ResPutOff, this.OnResPutOff)
  this.messageContainer:Regist(TradeMessage.ResLsTrade, this.ResLsTrade)
  this.messageContainer:Regist(TradeMessage.ResTradeCenterAdd, this.ResTradeCenterAdd)
  this.messageContainer:Regist(TradeMessage.ResTradeCenterDel, this.ResTradeCenterDel)
  this.messageContainer:Regist(TradeMessage.ResTradeCenterMod, this.ResTradeCenterMod)
  this.messageContainer:Regist(TradeMessage.ResLookItemAveragePrice, this.ResLookItemAveragePrice)
  this.messageContainer:Regist(TradeMessage.ResTradeRecommend, this.ResTradeRecommend)
  this.messageContainer:Regist(TradeMessage.ResAuctionStallPosition, this.ResAuctionStallPosition)
  this.messageContainer:Regist(TradeMessage.ResAuctionInfo, this.ResAuctionInfo)
  this.messageContainer:Regist(TradeMessage.ResOpenTradePanel, this.ResOpenPanel)
end

function AuctionController.UnRegistMessages()
  this.messageContainer:UnRegistAll()
end

function AuctionController.OnResPutOn(id, msg)
  AuctionData.PutAwayOffData(msg)
end

function AuctionController.OnResPutOff(id, msg)
  AuctionData.PutAwayOffData(msg)
  EventManager.Dispatch(Event.Auction_UpdatePutAway)
end

function AuctionController.ResLsTrade(id, msg)
  AuctionData.InitAllServerAuctionData(msg)
  if msg.type ~= AuctionData.toServerValue.History then
    if msg.index < msg.allIndex then
    else
      TipData.AuctionRecomBuyInit()
    end
    EventManager.Dispatch(Event.Auction_InitTab, msg)
  end
end

function AuctionController.ResTradeCenterAdd(id, msg)
  AuctionData.AllAuctionDataAdd(msg)
end

function AuctionController.ResTradeCenterDel(id, msg)
  AuctionData.AllAuctionDataDel(msg)
end

function AuctionController.ResTradeCenterMod(id, msg)
  AuctionData.AllAuctionDataMod(msg)
end

function AuctionController.ResLookItemAveragePrice(id, msg)
  EventManager.Dispatch(Event.Auction_excellentPrice, msg)
end

function AuctionController.OpenPanel()
  if LoginData.serverId then
    NetManager.Send(TradeMessage.ReqOpenTradePanel, {
      serverId = LoginData.serverId
    })
  end
end

function AuctionController.ResOpenPanel(id, msg)
  AuctionData.InitServerGroupData(msg)
  EventManager.Dispatch(Event.Auction_SetServerBtn)
end

function AuctionController.ClosePanel()
  NetManager.Send(TradeMessage.ReqOpenTradePanel, {state = false})
end

function AuctionController.ResTradeRecommend(_, msg)
  if msg then
    EventManager.Dispatch(Event.AuctionTipsUI, msg)
  end
end

function AuctionController.RegistEvent()
  this.eventContainer:Regist(Event.Auction_OpenPanel, this.OpenPanel)
  this.eventContainer:Regist(Event.Auction_ClosePanel, this.ClosePanel)
end

function AuctionController.GetStallMapType()
  local stallCityTab = ClientTable.cfg_Auction_stallPositionManager:GetDic()
  local stallCityMapList = {}
  local stallCityRemainStall = {}
  for i, v in pairs(stallCityTab) do
    if v.map ~= nil then
      stallCityMapList[v.map] = v
      stallCityMapList[v.map].map = v.map
      if stallCityRemainStall[v.map] == nil then
        stallCityRemainStall[v.map] = {}
        stallCityRemainStall[v.map].stallPosCount = 0
      end
      stallCityRemainStall[v.map].stallPosCount = stallCityRemainStall[v.map].stallPosCount + 1
    end
  end
  local stallCityMapListTemp = {}
  for key, value in pairs(stallCityMapList) do
    table.insert(stallCityMapListTemp, value)
  end
  stallCityMapList = AuctionController.SortStallMapByConditon(stallCityMapListTemp)
  return stallCityTab, stallCityMapList, stallCityRemainStall
end

function AuctionController.SortStallMapByConditon(_stallCityMapList)
  local isMeetCondition = AuctionController.CheckStallCondition(_stallCityMapList)
  table.sort(_stallCityMapList, function(a, b)
    if a ~= nil and b ~= nil then
      local index = isMeetCondition and 2 or 1
      return a.sortType[index] < b.sortType[index]
    else
      return false
    end
  end)
  return _stallCityMapList
end

function AuctionController.CheckStallCondition(_stallCityMapList)
  local conditionTab = {}
  local isMeetCondition = false
  for key, value in pairs(_stallCityMapList) do
    if not string.isNullOrEmpty(value.condition) then
      isMeetCondition = ConditionManager.Check4D(value.condition)
    end
  end
  return isMeetCondition
end

function AuctionController.ReqAuctionStallPosition(id, msg)
  NetManager.Send(TradeMessage.ReqAuctionStallPosition, {
    type = msg.type or 0
  })
end

function AuctionController.ResAuctionStallPosition(id, msg)
  local data = {}
  data.type = msg.type
  data.enoughNum = msg.enoughNum
  data.position = msg.position
  AuctionData.serverStallPositionData = data
  Auction_AuctionUI:RefreshStallOnPosChange()
end

function AuctionController.ReqBuyAuctionPosition(id, msg)
  NetManager.Send(TradeMessage.ReqBuyAuctionPosition, {
    title = msg.title or "",
    position = msg.position or 0,
    stallCost = msg.stallCost or 0
  })
end

function AuctionController.ReqAuctionInfo(id, msg)
  NetManager.Send(TradeMessage.ReqAuctionInfo, {
    position = msg.position or 0
  })
end

function AuctionController.ResAuctionInfo(id, msg)
  local data = {}
  data.title = msg.title
  data.position = msg.position
  data.materId = msg.materId
  data.endTime = msg.endTime
  data.shelf = msg.shelf
  AuctionData.isOwnSelfStall = true
  AuctionData.stallAuctionInfo = data
  if UIManager.IsVisible(UIID.Auction_AuctionUI) then
    Auction_AuctionUI:InitStalButtonState()
  end
  if UIManager.IsVisible(UIID.Auction_StallUI) then
    Auction_StallUI:UpdateStallInfoPanel()
  end
end

function AuctionController.ReqCloseAuctionMessage(id)
  NetManager.Send(TradeMessage.ReqCloseAuction)
end

function AuctionController.CheckMeetPutOnCondition(tblEquip, bind, intensify, additional, _isFromBag)
  local isNotBind = bind == nil or bind == 0
  local isNotIntensifyOrAdd = (intensify == nil or intensify == 0) and (additional == nil or additional == 0)
  if _isFromBag == true then
    return isNotBind
  else
    return isNotBind and isNotIntensifyOrAdd
  end
end

function AuctionController.SetSendToServerJson(_ConditionEnum, _value, _tradeTab)
  if _ConditionEnum == ConditionJsonEnum.mainType then
    AuctionController.ResetAllJson()
    AuctionData.ToServerJson.mainType = _value
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_TimeDown
  elseif _ConditionEnum == ConditionJsonEnum.strideDealType then
    AuctionData.ToServerJson.strideDealType = _value
  elseif _ConditionEnum == ConditionJsonEnum.allItem then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionController.ResetJson_Filters()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_TimeDown
    AuctionData.ToServerJson.allItem = _value
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_Equip then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_SuitEquip then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_JewelryEquip then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_HolySpirit then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_HolyRing then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_Reliquary then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_Newrunes then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_Mat then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionController.ResetJson_Filters()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_Currency then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionController.ResetJson_Filters()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.TradeScreenControl_SkillBook then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionController.ResetJson_Filters()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionController.SetJsonDataByTab(_tradeTab)
  elseif _ConditionEnum == ConditionJsonEnum.prebuyData then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionController.ResetJson_Filters()
    AuctionData.ToServerJson.sort = AuctionData.toServerValue.Sort_PriceUp
    AuctionData.ToServerJson.prebuyData = _value
  elseif _ConditionEnum == ConditionJsonEnum.prebuy then
    AuctionController.ResetJson_LeftTitleTab()
    AuctionController.ResetJson_Filters()
    AuctionData.ToServerJson.prebuy = _value
  elseif _ConditionEnum == ConditionJsonEnum.sort then
    AuctionData.ToServerJson.sort = _value
  elseif _ConditionEnum == ConditionJsonEnum.career then
    AuctionData.ToServerJson.career = _value
  elseif _ConditionEnum == ConditionJsonEnum.itemEquipClass then
    AuctionData.ToServerJson.equipClassFilter = _value
  elseif _ConditionEnum == ConditionJsonEnum.itemEquipSuit then
    AuctionData.ToServerJson.itemEquipSuit = _value
  elseif _ConditionEnum == ConditionJsonEnum.roleLevel then
    AuctionData.ToServerJson.roleLevelFilter = _value
  end
end

function AuctionController.ResetJson_MainType()
  AuctionData.ToServerJson.mainType = AuctionData.toServerValue.defMainType
  AuctionData.ToServerJson.strideDealType = AuctionData.toServerValue.defServerType
end

function AuctionController.ResetJson_LeftTitleTab()
  local jsonMsgDefValue = table.clone(AuctionData:JsonMsg(IndexerEnum.get))
  AuctionData.ToServerJson.itemType = jsonMsgDefValue.itemType
  AuctionData.ToServerJson.itemSubType = jsonMsgDefValue.itemSubType
  AuctionData.ToServerJson.itemConfigId = jsonMsgDefValue.itemConfigId
  AuctionData.ToServerJson.itemCellType = jsonMsgDefValue.itemCellType
  AuctionData.ToServerJson.auctionType = jsonMsgDefValue.auctionType
  AuctionData.ToServerJson.auctionSubtype = jsonMsgDefValue.auctionSubtype
  AuctionData.ToServerJson.prebuy = jsonMsgDefValue.prebuy
  AuctionData.ToServerJson.prebuyData = jsonMsgDefValue.prebuyData
end

function AuctionController.ResetJson_Filters()
  local jsonMsgDefValue = table.clone(AuctionData:JsonMsg(IndexerEnum.get))
  AuctionData.ToServerJson.sort = jsonMsgDefValue.sort
  AuctionData.ToServerJson.career = jsonMsgDefValue.career
  AuctionData.ToServerJson.equipClassFilter = jsonMsgDefValue.equipClassFilter
  AuctionData.ToServerJson.itemEquipSuit = jsonMsgDefValue.itemEquipSuit
  AuctionData.ToServerJson.roleLevelFilter = jsonMsgDefValue.roleLevelFilter
end

function AuctionController.ResetAllJson()
  AuctionController.ResetJson_MainType()
  AuctionController.ResetJson_LeftTitleTab()
  AuctionController.ResetJson_Filters()
end

function AuctionController.GetToServerJson()
  local jsonToServer = table.clone(AuctionData:JsonMsg(IndexerEnum.get))
  jsonToServer.sort = AuctionData.ToServerJson.sort
  jsonToServer.career = AuctionData.ToServerJson.career
  jsonToServer.roleLevelFilter = AuctionData.ToServerJson.roleLevelFilter
  local roleLvInfo = AuctionData.RoleLevelInfo[AuctionData.ToServerJson.roleLevelFilter]
  jsonToServer.roleLevel = roleLvInfo.roleLv
  jsonToServer.equipClassFilter = AuctionData.ToServerJson.equipClassFilter
  if not Auction_AuctionUI.chooseHolySpiritGrade:GetActive() then
    local equipClassInfo = AuctionData.EquipClassInfo[AuctionData.ToServerJson.equipClassFilter]
    jsonToServer.itemEquipClassMin = equipClassInfo.minClass
    jsonToServer.itemEquipClassMax = equipClassInfo.maxClass
  end
  jsonToServer.itemEquipSuit = AuctionData.ToServerJson.itemEquipSuit
  jsonToServer.itemType = AuctionData.ToServerJson.itemType
  jsonToServer.itemSubType = AuctionData.ToServerJson.itemSubType
  jsonToServer.itemCellType = AuctionData.ToServerJson.itemCellType or 0
  jsonToServer.itemConfigId = AuctionData.ToServerJson.itemConfigId or 0
  jsonToServer.auctionType = AuctionData.ToServerJson.auctionType
  jsonToServer.auctionSubtype = AuctionData.ToServerJson.auctionSubtype
  jsonToServer.prebuy = AuctionData.ToServerJson.prebuy
  jsonToServer.prebuyData = AuctionData.ToServerJson.prebuyData
  jsonToServer.strideDealType = AuctionData.ToServerJson.strideDealType
  local msg = {
    index = AuctionData.page,
    type = AuctionData.ToServerJson.mainType,
    condition = json.encode(jsonToServer)
  }
  return msg
end

function AuctionController.SendReqLsTrade()
  local msg = AuctionController.GetToServerJson()
  NetManager.Send(TradeMessage.ReqLsTrade, msg)
end

function AuctionController.InitFilterMeetTab()
  if AuctionData.filterMeetTabs ~= nil and table.count(AuctionData.filterMeetTabs) > 0 then
    return
  end
  AuctionData.filterMeetTabs = {}
  local tradeConfig = ClientTable.cfg_Trade_ScreenManager:GetDic()
  for i, v in pairs(tradeConfig) do
    if v.id ~= nil then
      AuctionData.filterMeetTabs[v.id] = v
    end
  end
end

function AuctionController.SetJsonDataByTab(_tradeTab)
  if _tradeTab ~= nil then
    AuctionData.ToServerJson.itemType = _tradeTab.type
    AuctionData.ToServerJson.itemSubType = _tradeTab.subType
    AuctionData.ToServerJson.itemConfigId = _tradeTab.itemId
    AuctionData.ToServerJson.itemCellType = _tradeTab.cellType
    AuctionData.ToServerJson.auctionType = _tradeTab.auctionType
    AuctionData.ToServerJson.auctionSubtype = _tradeTab.auctionSubtype
  else
    local jsonMsgDefValue = table.clone(AuctionData:JsonMsg(IndexerEnum.get))
    AuctionData.ToServerJson.itemType = jsonMsgDefValue.itemType
    AuctionData.ToServerJson.itemSubType = jsonMsgDefValue.itemSubType
    AuctionData.ToServerJson.itemConfigId = jsonMsgDefValue.itemConfigId
    AuctionData.ToServerJson.itemCellType = jsonMsgDefValue.itemCellType
    AuctionData.ToServerJson.auctionType = jsonMsgDefValue.auctionType
    AuctionData.ToServerJson.auctionSubtype = jsonMsgDefValue.auctionSubtype
  end
end

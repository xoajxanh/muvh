local RedPointChecker_Ext = {}

function RedPointChecker_Ext:Initialize()
  self.messageContainer = EventContainer(NetManager)
  self.eventContainer = EventContainer(EventManager)
  self:RegistEvent()
  self:RegistMessages()
  self:VariableRefresh()
  local attributeLimit = ClientTable.cfg_Global_globalManager:TryGetValue(2380001)
  local commonFruitLimit = 450
  local sdFruitLimit = 500
  local lianjiFruitLimit = 500
  if attributeLimit ~= nil then
    commonFruitLimit = tonumber(string.split(string.split(attributeLimit.effect, "&")[1], "#")[2])
    sdFruitLimit = tonumber(string.split(string.split(attributeLimit.effect, "&")[2], "#")[2])
    lianjiFruitLimit = tonumber(string.split(string.split(attributeLimit.effect, "&")[3], "#")[2])
  end
  self.fruitsLimit = {
    [3000111] = commonFruitLimit,
    [3000121] = commonFruitLimit,
    [3000131] = commonFruitLimit,
    [3000141] = commonFruitLimit,
    [3000151] = sdFruitLimit,
    [3000161] = lianjiFruitLimit
  }
  self.FIRST_TIME_BUYDAY = "FirstTimeBuyDay"
end

function RedPointChecker_Ext:RegistMessages()
  if self.ServerResRedPointUI == nil then
    function self.ServerResRedPointUI(_, msg)
      self:ServerResRedPointUICallBack(_, msg)
    end
  end
  self.messageContainer:Regist(RoleMessage.ResRedPoint, self.ServerResRedPointUI)
end

function RedPointChecker_Ext:RegistEvent()
  if self.ServerResRedPointUI == nil then
    function self.ServerResRedPointUI(_, msg)
      self:ServerResRedPointUICallBack(_, msg)
    end
  end
  self.eventContainer:Regist(Event.RefreshDailyPackRedPointByServer, self.ServerResRedPointUI)
  if self.RefreshOpenServiceParams == nil then
    function self.RefreshOpenServiceParams(_, msg)
      self:RefreshOpenServiceParamsCallBack(_, msg)
    end
  end
  self.eventContainer:Regist(Event.RefreshOpenServiceRedPointParam, self.RefreshOpenServiceParams)
  if self.GameEnter == nil then
    function self.GameEnter()
      self:GameEnterCallBack()
    end
  end
  self.eventContainer:Regist(Event.GamePlay_Enter, self.GameEnter)
  if self.UnionCompleteListen == nil then
    function self.UnionCompleteListen(id, msg)
      self:UnionCompleteListenCallBack(id, msg)
    end
  end
  self.eventContainer:Regist(Event.UnionTask_Update, self.UnionCompleteListen)
end

function RedPointChecker_Ext:ServerResRedPointUICallBack(_, msg)
  if msg.redPointId == 3 then
    self.siegeWar = msg.state == 1
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.siege,
      state = true
    })
    return
  elseif msg.redPointId == 27 then
    self.tog_sportsLevel = CommercializeData.OpenServiceRedPoint(27)
  elseif msg.redPointId == 28 then
    self.tog_sportsEquip = CommercializeData.OpenServiceRedPoint(28)
  elseif msg.redPointId == 29 then
    self.tog_sportsIntensify = CommercializeData.OpenServiceRedPoint(29)
  elseif msg.redPointId == 30 then
    self.tog_sportsZhuijia = CommercializeData.OpenServiceRedPoint(30)
  elseif msg.redPointId == 31 then
    self.tog_BossFirstKill = CommercializeData.OpenServiceRedPoint(31)
  elseif msg.redPointId == 32 then
    if CommercializeData.OpenServiceRedPoint(32) then
      NetManager.Send(CommerceMessage.ReqGetCommercialActivityInfo, {
        icon = CommercializeActivityTab.Opening_service,
        groupId = CommercializeOpeningserGrop.EquipFirstGet
      })
      return
    end
  elseif msg.redPointId == 34 then
    self.tog_sportsExcellence = CommercializeData.OpenServiceRedPoint(34)
  elseif msg.redPointId == 35 then
    self.tog_sportsOrnaments = CommercializeData.OpenServiceRedPoint(35)
  elseif msg.redPointId == 36 then
    self.tog_sportsFruit = CommercializeData.OpenServiceRedPoint(36)
  elseif msg.redPointId == 37 then
    self.tog_sportsFight = CommercializeData.OpenServiceRedPoint(37)
  elseif msg.redPointId == 60 then
    if CommercializeData.OpenServiceRedPoint(60) then
      NetManager.Send(CommerceMessage.ReqGetCommercialActivityInfo, {
        icon = CommercializeActivityTab.Opening_service,
        groupId = CommercializeOpeningserGrop.weekSignIn
      })
      return
    end
    self.tog_SevenDaysSignIn = false
  elseif msg.redPointId == 42 then
    return
  elseif msg.redPointId == 51 then
    self.warAllianceActivity = msg.state == 1
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.btnFunc,
      state = true
    })
    return
  elseif msg.redPointId == CommerceHolidayRedTogType[CommercializeHolidayGrop.BoosActivity] then
    self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.BoosActivity]] = msg.state == 1
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.holidayActivity,
      state = true
    })
    return
  elseif msg.redPointId == CommerceHolidayRedTogType[CommercializeHolidayGrop.Fireworks] then
    self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.Fireworks]] = msg.state == 1
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.holidayActivity,
      state = true
    })
    return
  elseif table.contains(CommerceHolidayContinuousRechargeRed, msg.redPointId) then
    local index = 1
    for i, v in pairs(CommerceHolidayContinuousRechargeRed) do
      if v == msg.redPointId then
        index = i
      end
    end
    self.HolidayContinuousRecharge[CommerceHolidayContinuousRechargeRed[index]] = msg.state == 1
    if self.HolidayTogGrop ~= nil then
      self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.ContinuousRecharge]] = msg.state == 1
      EventManager.Dispatch(Event.RP_RedPointRefresh, {
        index = ERedPointType.holidayActivity,
        state = true
      })
    end
    EventManager.Dispatch(Event.RP_RedPointHolidayActivityRefresh)
    return
  elseif msg.redPointId == 74 then
    self.isHaveUnionCampAuctionData = msg.state == 1
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.btnFunc,
      state = true
    })
    return
  elseif msg.redPointId == 61 then
    self.isHaveUnionAuctionData = msg.state == 1
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.btnFunc,
      state = true
    })
    return
  elseif msg.redPointId == ERedPointId.gamebook then
    gameMgr:GetGameBookMgr():SetRedPointState(msg.state)
    return
  elseif msg.redPointId == ERedPointId.return_task then
    ReturnActivityData.SetRedPointState(ReturnActivityData.ActivityGroup[2], msg.state)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.return_activity
    })
    EventManager.Dispatch(Event.Commer_RetrunActivityRedPoint)
    return
  elseif msg.redPointId == ERedPointId.return_reward then
    ReturnActivityData.SetRedPointState(ReturnActivityData.ActivityGroup[1], msg.state)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.return_activity
    })
    EventManager.Dispatch(Event.Commer_RetrunActivityRedPoint)
    return
  end
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.openActivity,
    state = true
  })
end

function RedPointChecker_Ext:RefreshOpenServiceParamsCallBack(_, name)
  if name == "tog_sportsLevel" then
    self.tog_sportsLevel = false
  elseif name == "tog_sportsEquip" then
    self.tog_sportsEquip = false
  elseif name == "tog_sportsIntensify" then
    self.tog_sportsIntensify = false
  elseif name == "tog_sportsZhuijia" then
    self.tog_sportsZhuijia = false
  elseif name == "tog_BossFirstKill" then
    self.tog_BossFirstKill = false
  elseif name == "tog_EquipFirstGet" then
    self.tog_EquipFirstGet = false
  elseif name == "tog_sportsExcellence" then
    self.tog_sportsExcellence = false
  elseif name == "tog_sportsOrnaments" then
    self.tog_sportsOrnaments = false
  elseif name == "tog_sportsFruit" then
    self.tog_sportsFruit = false
  elseif name == "tog_sportsFight" then
    self.tog_sportsFight = false
  elseif name == "tog_SevenDaysSignIn" then
    self.tog_SevenDaysSignIn = false
  end
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.openActivity,
    state = true
  })
end

function RedPointChecker_Ext:GameEnterCallBack()
  self:VariableRefresh()
end

function RedPointChecker_Ext:UnionCompleteListenCallBack()
  local isShow = self.JudgeUnionComplete()
  if self.tog_sportsBoss ~= isShow then
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.openActivity,
      state = true
    })
  end
end

function RedPointChecker_Ext:VariableRefresh()
  self.isApplyFriendSend = true
  self.isHaveNewMail = false
  self.isWelfareRecharge = true
  self.isWelfareAccumulated = true
  self.siegeWar = false
  self.IsWarAllianceMember = false
  self.isWarArmbandSend = true
  self.tog_firstGift = false
  self.tog_sportsLevel = false
  self.tog_BossFirstKill = false
  self.tog_EquipFirstGet = false
  self.tog_sportsEquip = false
  self.tog_sportsIntensify = false
  self.tog_sportsExcellence = false
  self.tog_sportsZhuijia = false
  self.tog_sportsOrnaments = false
  self.tog_sportsFruit = false
  self.tog_sportsFight = false
  self.tog_sportsBoss = false
  self.tog_SevenDaysSignIn = false
  self.everyDayGoal = false
  self.warAllianceActivity = false
  self.intensifyPrompt = false
  self.ornamentsPrompt = false
  self.isDirectRepay = false
  self.isHaveUnionAuctionData = false
  self.isHaveUnionCampAuctionData = false
  CommercialHolidayData:RedPointInit()
  self.HolidayTogGrop = {
    [CommerceHolidayRedTogType[CommercializeHolidayGrop.Exp]] = false,
    [CommerceHolidayRedTogType[CommercializeHolidayGrop.BoosActivity]] = false,
    [CommerceHolidayRedTogType[CommercializeHolidayGrop.Fireworks]] = false,
    [CommerceHolidayRedTogType[CommercializeHolidayGrop.Collect]] = false,
    [CommerceHolidayRedTogType[CommercializeHolidayGrop.Shop]] = false,
    [CommerceHolidayRedTogType[CommercializeHolidayGrop.ContinuousRecharge]] = false,
    [CommerceHolidayRedTogType[CommercializeHolidayGrop.TurntableType]] = false
  }
  self.HolidayContinuousRecharge = {
    [CommerceHolidayContinuousRechargeRed[1]] = false,
    [CommerceHolidayContinuousRechargeRed[2]] = false,
    [CommerceHolidayContinuousRechargeRed[3]] = false,
    [CommerceHolidayContinuousRechargeRed[4]] = false,
    [CommerceHolidayContinuousRechargeRed[5]] = false,
    [CommerceHolidayContinuousRechargeRed[6]] = false
  }
  CommercialTimeLimitedActivityData:RedPointInit()
  self.TimeLimitedTogGrop = {
    [CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Exp]] = false,
    [CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.BoosActivity]] = false,
    [CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Fireworks]] = false,
    [CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Collect]] = false,
    [CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Shop]] = false,
    [CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.ContinuousRecharge]] = false
  }
  self.TimeLimitedContinuousRecharge = {
    [CommerceTimeLimitedContinuousRechargeRed[1]] = false,
    [CommerceTimeLimitedContinuousRechargeRed[2]] = false,
    [CommerceTimeLimitedContinuousRechargeRed[3]] = false,
    [CommerceTimeLimitedContinuousRechargeRed[4]] = false
  }
end

function RedPointChecker_Ext:JudgeUseMethod(rootName, parentName, childName, redId)
  local isShow = false
  if childName == "Equip_ForgeNavUi#tog_intensify" then
    isShow = self:IntensifyRedPoint(rootName, parentName, childName)
    self.intensifyPrompt = isShow
  elseif childName == "Equip_ForgeNavUi#tog_zhuijia" then
    isShow = self:AddRedPoint(rootName, parentName, childName)
  elseif childName == "Equip_ForgeNavUi#tog_ornaments" then
    isShow = self:JewelryRedPoint(rootName, parentName, childName)
    self.ornamentsPrompt = isShow
  elseif childName == "Equip_ForgeNavUi#tog_decompose" then
    isShow = self:DecomposeRedPoint(rootName, parentName, childName)
  elseif childName == "Equip_ForgeNavUi#tog_overlap" then
    isShow = self:OverlapRedPoint(rootName, parentName, childName)
  elseif childName == "Instance_BossUI#tog_secretBoss" then
    isShow = self:InstanceBossRedPoint(rootName, parentName, childName)
  elseif childName == "Recharge_RechargeUI#tog_prizeList" then
    isShow = self:RechargeRewardRedPoint(rootName, parentName, childName)
  elseif childName == "Recharge_RechargeUI#tog_monthCardList" then
    isShow = self:RechargeCardRedPoint(rootName, parentName, childName)
  elseif childName == "Activity_SiegeUI#btn_goScene" then
    isShow = self:SiegeRedPoint(rootName, parentName, childName)
  elseif childName == "Main_MainMenuUI#btn_mail" then
    isShow = self:EMailRedPoint(rootName, parentName, childName)
  elseif childName == "Friend_FriChatUI#tog_addFriend#go_getFriend" then
    isShow = self:FriendApplyRedPoint(rootName, parentName, childName)
    RoleUtility.IsAddFriendRed = isShow
  elseif childName == "Main_MainMenuUI#btn_skill" then
    isShow = self:SkillRedPoint(rootName, parentName, childName)
  elseif childName == "Role_AttributeUI#btn_recommend" then
    isShow = self:AttributeAddRedPoint(rootName, parentName, childName)
  elseif childName == "Recharge_WelfareUI#tog_prizeList" then
    isShow = self:DailyGiftBagRedPoint(rootName, parentName, childName)
  elseif childName == "Recharge_WelfareUI#btn_prizeone" then
    isShow = self:DirectPurchaseRedPoint(rootName, parentName, childName)
  elseif childName == "Recharge_WelfareUI#tog_everyDayRechang" then
    isShow = self:WelfareRechargeRedPoint(rootName, parentName, childName)
  elseif childName == "Recharge_WelfareUI#tog_dailyRechang" then
    isShow = self:WelfareAccumulatedRedPoint(rootName, parentName, childName)
  elseif childName == "Main_MainMenuUI#btn_firstCharge" then
    isShow = self:FirstChargeRedPoint(rootName, parentName, childName)
  elseif childName == "Activity_TiankongmigeUI#btn_reward" then
    isShow = self:SkyRedPoint(rootName, parentName, childName)
  elseif childName == "Main_MainMenuUI#btn_TaskSchool" then
    isShow = self:TaskSchoolRedPoint(rootName, parentName, childName)
  elseif childName == "Role_AttributeUI#btn_showFruit" then
    isShow = self:FruitUseRedPoint(rootName, parentName, childName)
  elseif childName == "Main_MainMenuUI#btn_shopExp" then
    isShow = self:ShowExpRedPoint(rootName, parentName, childName)
  elseif childName == "Activity_IndexUI#btn_active" then
    isShow = self:EverydayGoalRedPoint(rootName, parentName, childName)
  elseif parentName == "Main_MainMenuUI#btn_warAlliance" then
    isShow = self:WarAllianceRedPoint(rootName, parentName, childName)
  elseif rootName == "Main_MainMenuUI#btn_shrink" then
    isShow = self:FirstActivityRedPoint(rootName, parentName, childName)
  elseif childName == "Activity_IndexUI#btn_activeTask" then
    isShow = self:ActivityRewardRedPoint(rootName, parentName, childName)
  elseif childName == "WarAlliance_Armband#btn_upgrade" then
  elseif childName == "OnHook_ProfitUI#tog_badge" then
    isShow = self:HookProfitRedPoint(rootName, parentName, childName)
  elseif childName == "Main_DownTipsUI#btn_auctionZhanEnter" then
    isShow = self:AuctionUnionRedPoint(rootName, parentName, childName)
  elseif childName == "Main_DownTipsUI#btn_auctionLianEnter" then
    isShow = self:AuctionUnionCampRedPoint(rootName, parentName, childName)
  elseif childName == "" then
  elseif childName == "Main_MainMenuUI#btn_kuafu" or childName == "CrossServer_IntoUI#btn_activeList" then
    isShow = self:CrossRealmRedPoint(rootName, parentName, childName)
  elseif childName == "Main_MainMenuUI#btn_HolidayActivity" then
    isShow = self:HolidayRedPoint(rootName, parentName, childName, redId)
  end
  return isShow
end

function RedPointChecker_Ext:JudgeUnionComplete()
  local isShow = false
  for k, v in pairs(TaskData.allMonsterLevel) do
    if TaskData.GetMonsterLevelCompletedTasks(v) then
      isShow = true
      break
    end
  end
  if not isShow and TaskData.GetPeriodicalTaskComplete() then
    isShow = true
  end
  return isShow
end

function RedPointChecker_Ext:IntensifyRedPoint(rootName, parentName, childName)
  if RoleManager.me == nil then
    return false
  end
  local checkEquiptType = {
    EquipCellType.NORMAL
  }
  if FucShowOrHideController.FuncSystemIsOpen(2010002) then
    table.insert(checkEquiptType, EquipCellType.HONGZHUANG)
  end
  local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.InputCellType, checkEquiptType)
  if not RoleEquipUtility.IsReachIntensifyLevel(equipData, tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2010002))) then
    return false
  end
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v then
        local IntensifyTable = MeEquipController.GetEquipIntensifyCfgByEquipData(v)
        local LastIntensifyTable = MeEquipController.GetEquipIntensifyCfg(v.itemId, v.intensify + 1 or 0)
        LastIntensifyTable = LastIntensifyTable or MeEquipController.GetEquipIntensifyCfg(v.tblItem.subType, v.intensify + 1 or 0)
        if LastIntensifyTable and not string.isNullOrEmpty(IntensifyTable.cost) then
          local cost = string.split(IntensifyTable.cost, "&")
          local isShow = true
          for i = 1, table.count(cost) do
            local itemTbl = string.split(cost[i], "#")
            local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
            if bagCount < tonumber(itemTbl[2]) then
              isShow = false
              break
            end
          end
          if isShow then
            if IntensifyTable.condition ~= nil then
              local isCanIntensify = false
              local conditonValue = IntensifyTable.condition[1]
              if conditonValue >= EConditionEnum.WingQualityGreater and conditonValue <= EConditionEnum.WingQualityLess then
                isCanIntensify = ConditionManager.GenerateSingleCondition(IntensifyTable.condition):Check(v.tblItem)
              elseif conditonValue >= EConditionEnum.JewelryGreater and conditonValue <= EConditionEnum.JewelryLess then
                isCanIntensify = ConditionManager.GenerateSingleCondition(IntensifyTable.condition):Check()
              elseif conditonValue == EConditionEnum.equipeClass then
                isCanIntensify = ConditionManager.GenerateSingleCondition(IntensifyTable.condition):Check(v.bagGridIndex)
              end
              if isCanIntensify then
                return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
              end
            else
              return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
            end
          end
        end
      end
    end
  end
  return false
end

function RedPointChecker_Ext:AddRedPoint(rootName, parentName, childName)
  if RoleManager.me == nil then
    return false
  end
  local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Normal)
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v then
        local additionalTab = MeEquipController.GetEquipAddtion(v.itemId, v.additional or 0)
        additionalTab = additionalTab or MeEquipController.GetEquipAddtion(v.tblItem.subType, v.additional or 0)
        local LastAddTable = MeEquipController.GetEquipAddtion(v.itemId, v.additional + 1)
        LastAddTable = LastAddTable or MeEquipController.GetEquipAddtion(v.tblItem.subType, v.additional + 1 or 0)
        if LastAddTable and additionalTab then
          local cost = string.split(additionalTab.cost, "&")
          local isShow = true
          for i = 1, table.count(cost) do
            local itemTbl = string.split(cost[i], "#")
            local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
            if bagCount < tonumber(itemTbl[2]) then
              isShow = false
              break
            end
          end
          if isShow then
            if additionalTab.condition ~= nil then
              local isCanAdditional = false
              local conditonValue = additionalTab.condition[1]
              if conditonValue >= EConditionEnum.WingQualityGreater and conditonValue <= EConditionEnum.WingQualityLess then
                isCanAdditional = ConditionManager.GenerateSingleCondition(additionalTab.condition):Check(v.tblItem)
              elseif conditonValue >= EConditionEnum.JewelryGreater and conditonValue <= EConditionEnum.JewelryLess then
                isCanAdditional = ConditionManager.GenerateSingleCondition(additionalTab.condition):Check()
              elseif conditonValue == EConditionEnum.equipeClass then
                isCanAdditional = ConditionManager.GenerateSingleCondition(additionalTab.condition):Check(v.bagGridIndex)
              end
              if isCanAdditional then
                return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
              end
              return isCanAdditional
            else
              return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
            end
          end
        end
      end
    end
  end
  return false
end

local function GetEquipBreachCost(special, normal)
  local cost = string.split(special, "&")
  local isSpEnough = true
  local isHave = false
  for i = 1, table.count(cost) do
    local itemTbl = string.split(cost[i], "#")
    local id = tonumber(itemTbl[1])
    local count = tonumber(itemTbl[2])
    local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
    if count > bagCount then
      isSpEnough = false
    end
    if 0 < bagCount then
      isHave = true
    end
  end
  cost = string.split(normal, "&")
  if not isHave then
    for i = 1, table.count(cost) do
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if 0 < bagCount then
        return normal
      end
    end
  elseif not isSpEnough then
    local norEnough = true
    for i = 1, table.count(cost) do
      local itemTbl = string.split(cost[i], "#")
      local id = tonumber(itemTbl[1])
      local count = tonumber(itemTbl[2])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if count > bagCount then
        norEnough = false
      end
    end
    if norEnough then
      return normal
    end
  end
  return special
end

function RedPointChecker_Ext:JewelryRedPoint(rootName, parentName, childName)
  if RoleManager.me == nil then
    return false
  end
  local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Normal)
  if equipData and table.count(equipData) > 0 then
    local isShow = false
    for k, v in pairs(equipData) do
      if v and v.tblEquip.subType == EItemSubtype.Necklace or v.tblEquip.subType == EItemSubtype.Ring or v.tblEquip.subType == EItemSubtype.Earrings then
        local lastGrowUpTable = MeEquipController.GetEquipGrowUpCfg(v.tblItem.subType, v.level + 1)
        if lastGrowUpTable then
          local growUpTable = MeEquipController.GetEquipGrowUpCfg(v.tblItem.subType, v.level or 0)
          if growUpTable == nil then
            break
          end
          local costStr = growUpTable.cost
          local cost = string.split(costStr, "&")
          for i = 1, table.count(cost) do
            local itemTbl = string.split(cost[i], "#")
            local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
            if not string.isNullOrEmpty(growUpTable.currencyCost) then
              local nId = tonumber(string.split(growUpTable.currencyCost, "#")[1])
              bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
            end
            if bagCount > tonumber(itemTbl[2]) then
              isShow = true
              break
            end
          end
          if isShow and self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName) then
            return isShow
          end
        end
      end
    end
    if not isShow then
      isShow = true
      for k, v in pairs(equipData) do
        if v and v.tblEquip.subType == EItemSubtype.Necklace or v.tblEquip.subType == EItemSubtype.Ring or v.tblEquip.subType == EItemSubtype.Earrings then
          local lastBreachTable = MeEquipController.GetEquipBreachCfg(v.tblItem.subType, v.breach + 1)
          if lastBreachTable then
            local breachTable = MeEquipController.GetEquipBreachCfg(v.tblItem.subType, v.breach or 0)
            local growUpTable = MeEquipController.GetEquipGrowUpCfg(v.tblItem.subType, v.level or 0)
            if growUpTable == nil or breachTable == nil then
              break
            end
            if growUpTable.level >= breachTable.exp then
              local costStr = breachTable.breachCost
              local cost = string.split(costStr, "&")
              for i = 1, table.count(cost) do
                local itemTbl = string.split(cost[i], "#")
                local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
                if not string.isNullOrEmpty(breachTable.currencyCost) then
                  local nId = tonumber(string.split(breachTable.currencyCost, "#")[1])
                  bagCount = bagCount + BagInfoData.GetItemTotalCountByItemId(nId)
                end
                if bagCount < tonumber(itemTbl[2]) then
                  isShow = false
                  break
                end
              end
              if isShow and self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName) then
                return isShow
              end
            end
          end
        end
      end
    end
  end
  return false
end

function RedPointChecker_Ext:StoneRedPoint(rootName, parentName, childName)
  local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Normal)
  local stoneData = ViewData.meData.equipsData.StoneData
  local bagData = BagInfoData.TotalItems
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v and k ~= ERoleEquipPosition.pet and k ~= ERoleEquipPosition.wing then
        local isHaveEmptyCell = false
        local normalTab = {}
        local useStoneTypeTab = {
          quality = {},
          subType = {}
        }
        local tblStone = ClientTable.cfg_item_stone_effectManager:GetDic()
        for kk, vv in pairs(tblStone) do
          for kkk, vvv in pairs(vv.subType) do
            if vvv == v.tblItem.subType then
              table.insert(normalTab, vv.type)
              break
            end
          end
        end
        for i = 1, 5 do
          local stoneCellIndex = k * 100 + i
          local cellInfo = ClientTable.cfg_EquipCell_cellManager:TryGetValue(stoneCellIndex, "index")
          if cellInfo then
            local split1 = string.split(cellInfo.useCondition, "&")
            local split2 = string.split(split1[2], "#")
            if split2[1] == "1201" and #v.excellence >= tonumber(split2[3]) then
              if stoneData[stoneCellIndex] then
                table.insert(useStoneTypeTab.quality, stoneData[stoneCellIndex].tblItem.quality)
                table.insert(useStoneTypeTab.subType, stoneData[stoneCellIndex].tblItem.subType)
              else
                isHaveEmptyCell = true
              end
            end
          end
        end
        if isHaveEmptyCell then
          for i = 1, #normalTab do
            for n, m in pairs(bagData) do
              if normalTab[i] == m.tblItem.type then
                if 0 < table.count(useStoneTypeTab.subType) then
                  for i = 1, table.count(useStoneTypeTab.subType) do
                    if m.tblItem.subType ~= useStoneTypeTab.subType[i] then
                      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
                    end
                  end
                  for i = 1, table.count(useStoneTypeTab.subType) do
                    if m.tblItem.subType == useStoneTypeTab.subType[i] and m.tblItem.quality > useStoneTypeTab.quality[i] then
                      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
                    end
                  end
                else
                  return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
                end
              end
            end
          end
        end
      end
    end
  end
  return false
end

function RedPointChecker_Ext:DecomposeRedPoint(rootName, parentName, childName)
  local bagData = BagInfoData.TotalItems
  local consumeItemTbl = BagInfoData.consumeItemTbl
  for k, v in pairs(bagData) do
    local ItemDecompose
    if ItemUtility.IsRuneType(v.tblItem.type) then
      if v.serverInfo and v.serverInfo.runesLevel then
        local id = tonumber(v.itemId .. v.serverInfo.runesLevel)
        ItemDecompose = ClientTable.cfg_Item_decompose_runesManager:TryGetValue(id, "id")
      end
    else
      ItemDecompose = ClientTable.cfg_Item_decomposeManager:TryGetValue(v.itemId, "id")
    end
    if ItemDecompose then
      local needCoins = 0
      for m, n in pairs(consumeItemTbl) do
        needCoins = n
      end
      if BagInfoData.CoinInfos[ECoinsType.gold] < tonumber(needCoins) then
        return false
      end
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:OverlapRedPoint(rootName, parentName, childName)
  local equipData = RoleEquipUtility.GetConditionEquipData(RoleManager.me.data.equipsData.Data, ERoleEquipCondition.Normal)
  local bagData = BagInfoData.TotalItems
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v and v.isSuit == true and k ~= ERoleEquipPosition.pet and k ~= ERoleEquipPosition.wing then
        for m, n in pairs(bagData) do
          if n and n ~= v and n.tblItem.type == 2 and n.tblItem.subType ~= 21 and n.tblItem.subType ~= 22 and n.isSuit == true then
            local vTemp = table.metatableCopy(nil, n.excellence)
            for kk, vv in pairs(v.excellence) do
              for kkk, vvv in pairs(vTemp) do
                if vv == vvv then
                  table.remove(vTemp, kkk)
                end
              end
            end
            if table.count(vTemp) > 0 then
              return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
            end
          end
        end
      end
    end
  end
  return false
end

function RedPointChecker_Ext:IntensifyTransferRedPoint(rootName, parentName, childName)
  local equipData = ViewData.meData.equipsData.Data
  local bagData = BagInfoData.TotalItems
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v and 0 < v.intensify and k ~= ERoleEquipPosition.pet and k ~= ERoleEquipPosition.wing then
        for m, n in pairs(equipData) do
          if n and m ~= k and m ~= ERoleEquipPosition.pet and m ~= ERoleEquipPosition.wing and n.intensify < v.intensify then
            return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
          end
        end
        for m, n in pairs(bagData) do
          if n.tblItem.type == 2 and n ~= v and n.tblItem.subType ~= 21 and n.tblItem.subType ~= 22 and n.intensify < v.intensify then
            return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
          end
        end
      end
    end
  end
  return false
end

function RedPointChecker_Ext:AddTransferRedPoint(rootName, parentName, childName)
  local equipData = ViewData.meData.equipsData.Data
  local bagData = BagInfoData.TotalItems
  if equipData and table.count(equipData) > 0 then
    for k, v in pairs(equipData) do
      if v and 0 < v.additional and k ~= ERoleEquipPosition.pet and k ~= ERoleEquipPosition.wing then
        for m, n in pairs(equipData) do
          if n and m ~= k and m ~= ERoleEquipPosition.pet and m ~= ERoleEquipPosition.wing and n.additional < v.additional then
            return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
          end
        end
        for m, n in pairs(bagData) do
          if n.tblItem.type == 2 and n ~= v and n.tblItem.subType ~= 21 and n.tblItem.subType ~= 22 and n.additional < v.additional then
            return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
          end
        end
      end
    end
  end
  return false
end

function RedPointChecker_Ext:InstanceBossRedPoint(rootName, parentName, childName)
  if RoleManager.me.level < 60 then
    return false
  end
  if TranScriptData.GetSecretBossState() then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:RechargeRewardRedPoint(rootName, parentName, childName)
  if Main_MainMenuUI and Main_MainMenuUI.rechargeRedPointMsg and ConditionManager.Check4D(Main_MainMenuUI.rechargeRedPointMsg.conditionStr) then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:RechargeCardRedPoint(rootName, parentName, childName)
  local cardData = RechargeData.GetMonthCardInfor()
  for k, v in pairs(cardData) do
    if v.residualDay > 0 and 0 >= RechargeData.GetCount(v.CountKey) then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:SiegeRedPoint(rootName, parentName, childName)
  if self.siegeWar and SceneData.mapId ~= 1031001 then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  local openActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(1003, "activityId").condition
  local isOpen = ConditionManager.Check4D(openActivityCond)
  if isOpen and SceneData.mapId ~= 1031001 then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:EMailRedPoint(rootName, parentName, childName)
  for _, v in ipairs(MailData.TotalMail) do
    if v.stateType == EMailStateType.Un_Read_Items or v.stateType == EMailStateType.Un_Read_No_Items or v.stateType == EMailStateType.Read_No_Receive then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:FriendApplyRedPoint(rootName, parentName, childName)
  if self.isApplyFriendSend then
    self.isApplyFriendSend = false
    NetManager.Send(FriendMessage.ReqOpenFriendPanel, {
      type = FriendTypeEnum.BE_APPLY_LIST
    })
  end
  if FriendData.GetFriendCountByType(FriendTypeEnum.BE_APPLY_LIST) > 0 then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:MountRedPoint(rootName, parentName, childName)
  return false
end

function RedPointChecker_Ext:SkillRedPoint(rootName, parentName, childName)
  for i = 1, table.count(SkillData.SkillList) do
    local skillInfo
    skillInfo = SkillData.SkillList[i]
    if skillInfo then
      for j = 1, table.count(skillInfo) do
        local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillInfo[j].id)
        local cfg_skillNext = ClientTable.cfg_Skill_skillManager:TryGetValue(skillInfo[j].id + 1)
        local isLearnShow = false
        local isBreachShow = false
        if cfg_skill.get == ESkillGetType.Self then
          if RoleManager.me.skills[cfg_skill.groupId] and table.contains(RoleManager.me.skills[cfg_skill.groupId], skillInfo[j].id) and cfg_skillNext then
            local conditionTab = cfg_skillNext.condition
            local isCon = true
            for m = 1, table.count(conditionTab) do
              if not ConditionManager.GenerateSingleCondition(conditionTab[m]):Check() then
                isCon = false
                break
              end
            end
            if isCon then
              local needStr = string.split(cfg_skillNext.needItem, "#")
              local itemCount = BagInfoData.GetItemTotalCountByItemId(tonumber(needStr[1]))
              if itemCount >= tonumber(needStr[2]) then
                isLearnShow = true
              end
            end
          else
            local conditionTab = cfg_skill.condition
            local isCon = true
            for m = 1, table.count(conditionTab) do
              if not ConditionManager.GenerateSingleCondition(conditionTab[m]):Check() then
                isCon = false
                break
              end
            end
            if isCon then
              local needStr = string.split(cfg_skill.needItem, "#")
              local itemCount = BagInfoData.GetItemTotalCountByItemId(tonumber(needStr[1]))
              if needStr ~= nil and 2 <= #needStr and itemCount >= tonumber(needStr[2]) then
                isLearnShow = true
              end
            end
          end
        end
        if isBreachShow or isLearnShow then
          return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
        end
      end
    end
  end
  return false
end

function RedPointChecker_Ext:AttributeAddRedPoint(rootName, parentName, childName)
  if QuickFind.LuaMainPlayerViewAttrData().validAttributePoint > 0 then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:DailyGiftBagRedPoint(rootName, parentName, childName)
  local currentPrize = RechargeData.FreePrizeRefresh()
  currentPrize = currentPrize or RechargeData.FreePrizeNoClose()
  if currentPrize.residueTime > 0 then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:DirectPurchaseRedPoint(rootName, parentName, childName)
  if not self.isDirectRepay then
    self.isDirectRepay = true
    NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
  end
  local Msgdata = CommercializeData.DirectRepayInfo.info
  if not Msgdata then
    return false
  end
  local GivebackData = CommercializeData:GetTabDirectRepayInfo()
  for i = 1, #Msgdata do
    if not Msgdata[i].canGet or Msgdata[i].alreadyGet then
    else
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:ShopGoodsRedPoint(rootName, parentName, childName)
  local shopTbl = ShopData.GetShopInfo()
  for _, shopConfig in pairs(shopTbl) do
    local strTab = string.split(shopConfig.cost, "#")
    if tonumber(strTab[2]) == 0 then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:WelfareRechargeRedPoint(rootName, parentName, childName)
  if self.isWelfareRecharge then
    self.isWelfareRecharge = false
    NetManager.Send(RechargeMessage.ReqEverydayRechargeInfo)
  end
  
  local function SorteveryDayFun(info, mass, every)
    local RoleRechargeData = RefreshData.TotalRefreshTbl
    local EveryDayMinCountKey, EveryDayMaxCountKey, DailyRechMinCountKey, DailyRechMaxCountKey = CommercializeData:GetWelfareMaxandMinCountKey()
    local min, max
    if every then
      min, max = EveryDayMinCountKey, EveryDayMaxCountKey
      for i, v in pairs(info) do
        for k, w in pairs(mass) do
          if v.goalId == w.id then
            v.massge = w
            break
          end
        end
      end
    else
      min, max = DailyRechMinCountKey, DailyRechMaxCountKey
      for i, v in pairs(info) do
        for k, w in pairs(mass) do
          if v.id == w.id then
            v.massge = w
            break
          end
        end
      end
    end
    for i, v in pairs(RoleRechargeData) do
      if i >= min and i <= max then
        local acc = 0
        for k = 1, #info do
          k = k + acc
          if info[k].giftdata.countKey == i then
            if v.count >= info[k].refreshCountLimit then
              info[k].Received = true
              table.insert(info, info[k])
              table.remove(info, k)
              acc = acc - 1
            end
            break
          end
        end
      end
    end
    local lastitem = {}
    local acc = 0
    for i = 1, #info do
      i = i + acc
      if info[i].Received then
        table.insert(lastitem, info[i])
        table.remove(info, i)
        acc = acc - 1
      end
    end
    table.sort(lastitem, function(a, b)
      return a.id < b.id
    end)
    table.combine(info, lastitem)
  end
  
  if table.count(CommercializeData.WelfareEveryDayInfo) == 0 then
    return false
  end
  local data = CommercializeData.WelfareEveryDayInfo
  local info = CommercializeData:GetEveryAndDailyDataFun(data.info, true)
  local EveryDayRechargeInfo = table.DeepCopy(info)
  SorteveryDayFun(EveryDayRechargeInfo, data.info, true)
  for _, data in pairs(EveryDayRechargeInfo) do
    if data.massge.canGet and not data.Received then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:WelfareAccumulatedRedPoint(rootName, parentName, childName)
  if self.isWelfareAccumulated then
    self.isWelfareAccumulated = false
    NetManager.Send(RechargeMessage.ReqDailyRechargeInfo)
  end
  if table.count(CommercializeData.WelfareDailyDayInfo) == 0 then
    return false
  end
  
  local function SorteveryDayFun(info, mass, every)
    local RoleRechargeData = RefreshData.TotalRefreshTbl
    local EveryDayMinCountKey, EveryDayMaxCountKey, DailyRechMinCountKey, DailyRechMaxCountKey = CommercializeData:GetWelfareMaxandMinCountKey()
    local min, max
    if every then
      min, max = EveryDayMinCountKey, EveryDayMaxCountKey
      for i, v in pairs(info) do
        for k, w in pairs(mass) do
          if v.goalId == w.id then
            v.massge = w
            break
          end
        end
      end
    else
      min, max = DailyRechMinCountKey, DailyRechMaxCountKey
      for i, v in pairs(info) do
        for k, w in pairs(mass) do
          if v.id == w.id then
            v.massge = w
            break
          end
        end
      end
    end
    for i, v in pairs(RoleRechargeData) do
      if i >= min and i <= max then
        local acc = 0
        for k = 1, #info do
          k = k + acc
          if info[k].giftdata.countKey == i then
            if v.count >= info[k].refreshCountLimit then
              info[k].Received = true
              table.insert(info, info[k])
              table.remove(info, k)
              acc = acc - 1
            end
            break
          end
        end
      end
    end
    local lastitem = {}
    local acc = 0
    for i = 1, #info do
      i = i + acc
      if info[i].Received then
        table.insert(lastitem, info[i])
        table.remove(info, i)
        acc = acc - 1
      end
    end
    table.sort(lastitem, function(a, b)
      return a.id < b.id
    end)
    table.combine(info, lastitem)
  end
  
  local data = CommercializeData.WelfareDailyDayInfo
  local info = CommercializeData:GetEveryAndDailyDataFun(data.info, false)
  local DailyRechargeInfo = table.DeepCopy(info)
  SorteveryDayFun(DailyRechargeInfo, data.info, false)
  for _, data in pairs(DailyRechargeInfo) do
    if data.massge.count >= data.goaldata.goalCount and not data.Received then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:FirstChargeRedPoint(rootName, parentName, childName)
  local FirstChargeInfo = RechargeData.GetFirstChargeInfo()
  local RechargeRecord = {}
  
  local function GetRechargeData(control, ui)
    local toggleindex = {}
    if table.count(control) == 0 then
      return toggleindex
    end
    for i, v in pairs(control) do
      if i >= ui.FirstGetKey and i <= ui.LastGetKey and v.count > 0 then
        toggleindex[i] = i
      end
      if i >= ui.FirstSetKey and i <= ui.LastSetKey and v.count > 0 then
        RechargeRecord[i] = i
      end
    end
    return toggleindex
  end
  
  local RechargeIndx = GetRechargeData(RefreshData.TotalRefreshTbl, FirstChargeInfo)
  local FirstChargGift = RechargeData.GetFirstChargGift()
  for i, v in pairs(RechargeRecord) do
    for j = 1, #FirstChargGift do
      if FirstChargGift[j].buyCond[i] then
        local giftkey = FirstChargGift[j].countKey
        if not RechargeIndx[giftkey] then
          local isShow = self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
          return isShow
        end
      end
    end
  end
  return false
end

local function IsHaveNeedStoneData(data)
  for i, v in pairs(data) do
    if RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Sky) then
      return true
    end
  end
  return false
end

function RedPointChecker_Ext:SkyRedPoint(rootName, parentName, childName)
  self.RewardData = CommercializeData:TianKongMiGeReward()
  if table.count(self.RewardData) > 0 then
    for i = 1, table.count(self.RewardData) do
      local data = self.RewardData[i]
      local score = BagInfoData.GetItemTotalCountByItemId(1000100)
      if data and data.Ordinarydata and not data.Ordinarydata.Received then
        if score >= data.Ordinarydata.canbuy then
          return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
        end
        local isHave = IsHaveNeedStoneData(ViewData.meData.equipsData.StoneData)
        if score >= data.Advanceddata.canbuy and isHave then
          return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
        end
      end
    end
  end
  return false
end

function RedPointChecker_Ext:FirstActivityRedPoint(rootName, parentName, childName)
  if childName == "Commercialization_FirstActivityUI#tog_sportsLevel" then
    return self.tog_sportsLevel
  elseif childName == "Commercialization_FirstActivityUI#tog_sportsEquip" then
    return self.tog_sportsEquip
  elseif childName == "Commercialization_FirstActivityUI#tog_sportsIntensify" then
    return self.tog_sportsIntensify
  elseif childName == "Commercialization_FirstActivityUI#tog_sportsZhuijia" then
    return self.tog_sportsZhuijia
  elseif childName == "Commercialization_FirstActivityUI#tog_BossFirstKill" then
    return self.tog_BossFirstKill
  elseif childName == "Commercialization_FirstActivityUI#tog_EquipFirstGet" then
    return self.tog_EquipFirstGet
  elseif childName == "Commercialization_FirstActivityUI#tog_sportsExcellence" then
    return self.tog_sportsExcellence
  elseif childName == "Commercialization_FirstActivityUI#tog_sportsOrnaments" then
    return self.tog_sportsOrnaments
  elseif childName == "Commercialization_FirstActivityUI#tog_sportsFruit" then
    return self.tog_sportsFruit
  elseif childName == "Commercialization_FirstActivityUI#tog_sportsFight" then
    return self.tog_sportsFight
  elseif childName == "Commercialization_FirstActivityUI#tog_sportsBoss" then
    self.tog_sportsBoss = self.JudgeUnionComplete()
    return self.tog_sportsBoss
  elseif childName == "Commercialization_FirstActivityUI#tog_SevenDaysSignIn" then
    return self.tog_SevenDaysSignIn
  end
  return false
end

function RedPointChecker_Ext:GetFirstTimeBuyDayKey(redId)
  return string.format("%s%s", self.FIRST_TIME_BUYDAY, tostring(LoginData.roleId), redId)
end

function RedPointChecker_Ext:RefreshFirstTimeBuyDayState(redId)
  local str = LoginData.openServerDay .. "#" .. 1
  PlayerPrefs.SetString(self:GetFirstTimeBuyDayKey(redId), str)
  self:HolidayRedPointRefreshState({redId = redId, state = true})
end

function RedPointChecker_Ext:HolidayRedPoint(rootName, parentName, childName, redId)
  if redId == CommerceHolidayRedTogType[CommercializeHolidayGrop.Exp] then
    return self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.Exp]]
  elseif redId == CommerceHolidayRedTogType[CommercializeHolidayGrop.BoosActivity] then
    return self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.BoosActivity]]
  elseif redId == CommerceHolidayRedTogType[CommercializeHolidayGrop.Fireworks] then
    return self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.Fireworks]]
  elseif redId == CommerceHolidayRedTogType[CommercializeHolidayGrop.Collect] then
    return self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.Collect]]
  elseif redId == CommerceHolidayRedTogType[CommercializeHolidayGrop.Shop] then
    return self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.Shop]]
  elseif redId == CommerceHolidayRedTogType[CommercializeHolidayGrop.ContinuousRecharge] then
    return self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.ContinuousRecharge]]
  elseif redId == CommerceHolidayRedTogType[CommercializeHolidayGrop.TurntableType] then
    return self.HolidayTogGrop[CommerceHolidayRedTogType[CommercializeHolidayGrop.TurntableType]]
  end
end

function RedPointChecker_Ext:HolidayRedPointRefreshState(data)
  self.HolidayTogGrop[data.redId] = data.state
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.holidayActivity,
    state = true
  })
end

function RedPointChecker_Ext:GetTogHolidayRedPoint(redId)
  return self.HolidayTogGrop[redId] and self.HolidayTogGrop[redId] or false
end

function RedPointChecker_Ext:TimeLimitedRedPoint(rootName, parentName, childName, redId)
  if redId == CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Exp] then
    return self.TimeLimitedTogGrop[CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Exp]]
  elseif redId == CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.BoosActivity] then
    return self.TimeLimitedTogGrop[CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.BoosActivity]]
  elseif redId == CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Fireworks] then
    return self.TimeLimitedTogGrop[CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Fireworks]]
  elseif redId == CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Collect] then
    return self.TimeLimitedTogGrop[CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Collect]]
  elseif redId == CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Shop] then
    return self.TimeLimitedTogGrop[CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.Shop]]
  elseif redId == CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.ContinuousRecharge] then
    return self.TimeLimitedTogGrop[CommerceTimeLimitedRedTogType[CommercializeTimeLimitedGrop.ContinuousRecharge]]
  end
end

function RedPointChecker_Ext:TimeLimitedRedPointRefreshState(data)
  self.TimeLimitedTogGrop[data.redId] = data.state
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.TimeLimitedActivity,
    state = true
  })
end

function RedPointChecker_Ext:GetTogTimeLimitedRedPoint(redId)
  return self.TimeLimitedTogGrop[redId] and self.TimeLimitedTogGrop[redId] or false
end

function RedPointChecker_Ext:TaskSchoolRedPoint(rootName, parentName, childName)
  for i = 1, table.count(TaskData.instituteMiracleTasks) do
    if TaskData.instituteMiracleTasks[i].state == TaskStateType.Completed then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:FruitUseRedPoint(rootName, parentName, childName)
  if self.fruits == nil then
    self.fruits = {}
  end
  local allPoint = 0
  if ViewData.meData then
    self.roleId = ViewData.meData.id
    self.fruits = {
      [3000111] = ViewData.meData.attributeAddPoint.strength,
      [3000121] = ViewData.meData.attributeAddPoint.agility,
      [3000131] = ViewData.meData.attributeAddPoint.vitality,
      [3000141] = ViewData.meData.attributeAddPoint.energy,
      [3000151] = ViewData.meData.attributeAddPoint.shieldRecoveryMultiplier_mul / 20,
      [3000161] = ViewData.meData.attributeAddPoint.comboRecovery_mul / 20
    }
  end
  if ViewData.meData then
    allPoint = ViewData.meData.attributeAddPoint.strength + ViewData.meData.attributeAddPoint.agility + ViewData.meData.attributeAddPoint.vitality + ViewData.meData.attributeAddPoint.energy
  end
  for i, v in pairs(BagInfoData.TotalItems) do
    if v and v.tblItem.useParam == "5" and self.fruitsLimit[v.tblItem.id] ~= nil and self.fruits[v.tblItem.id] ~= nil and self.fruits[v.tblItem.id] < self.fruitsLimit[v.tblItem.id] then
      if 3000141 >= v.tblItem.id then
        if allPoint < self.fruitsLimit[v.tblItem.id] then
          return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
        end
      else
        return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
      end
    end
  end
  return false
end

function RedPointChecker_Ext:ShowExpRedPoint(rootName, parentName, childName)
  local keys = CommercializeData:GetgoLevelCountKey()
  local key
  for i = 1, table.count(keys) do
    local count = RechargeData.GetCount(keys[i])
    if count <= 0 then
      key = keys[i]
      break
    end
  end
  if key ~= nil then
    local condition = ConfigManager.FindConfigs("cfg_Gift_gift", "countKey", key)[1].buyCondition
    if ConditionManager.Check(condition) then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:EverydayGoalRedPoint(rootName, parentName, childName)
  if self.everyDayGoal then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:WarAllianceRedPoint(rootName, parentName, childName)
  if childName == "WarAlliance_Member#btn_memberManager" then
    return self:WarAllianceMemberRedPoint(rootName, parentName, childName)
  elseif childName == "WarAlliance_menuUI#Impeach_tab" then
    return self:ImpeachRedPoint(rootName, parentName, childName)
  elseif childName == "WarAlliance_menuUI#Campaign_tab" then
    return self:CampaignRedPoint(rootName, parentName, childName)
  elseif childName == "WarAlliance_menuUI#Replace_tab" then
    return self:ReplaceRedPoint(rootName, parentName, childName)
  elseif childName == "WarAlliance_menuUI#Task_tab" then
    return self:WarAllianceTaskRedPoint(rootName, parentName, childName)
  elseif childName == "WarAlliance_menuUI#activity_tab" then
    local activityIds = {
      1001,
      1003,
      1006,
      5002
    }
    for i, id in pairs(activityIds) do
      local activityCfg = ClientTable.cfg_Activity_overviewManager:TryGetValue(id, "activityId")
      if activityCfg and ConditionManager.Check4D(activityCfg.condition) and ConditionManager.Check4D(activityCfg.enterCondition) then
        self.warAllianceActivity = true
        return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
      end
    end
  end
  return false
end

function RedPointChecker_Ext:WarAllianceMemberRedPoint(rootName, parentName, childName)
  if self.IsWarAllianceMember then
    self.IsWarAllianceMember = false
    NetManager.Send(UnionMessage.ReqUnionAdminInfo)
  end
  if table.count(WarAllianceData.MyAuditListData.info) > 0 then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:ImpeachRedPoint(rootName, parentName, childName)
  if WarAllianceData.IsImpeaching() and WarAllianceData.IsShowImpeach() and WarAllianceData.IsShowImpeachRedPoint then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:CampaignRedPoint(rootName, parentName, childName)
  if WarAllianceData.IsCampaigning() and WarAllianceData.IsShowCampaign() and WarAllianceData.IsShowCampaignRedPoint then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:ReplaceRedPoint(rootName, parentName, childName)
  if WarAllianceData.IsReplaceing() and WarAllianceData.IsShowReplace() and WarAllianceData.IsShowReplaceRedPoint then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:WarAllianceTaskRedPoint(rootName, parentName, childName)
  if not TaskData.unionCommonTask then
    return false
  end
  for index, unionTask in ipairs(TaskData.unionCommonTask) do
    if unionTask:GetState() == TaskStateType.Completed and TaskData.GetUnionCommonTaskCount(unionTask:GetId()) == 0 then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:ActivityRewardRedPoint(rootName, parentName, childName)
  local rewardList = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2530001)
  rewardList = string.split(rewardList, "&")
  for i = 1, #rewardList do
    local reward = string.split(rewardList[i], "#")
    local activityNum = tonumber(reward[1])
    if not Activity_IndexData.IsHasPhases(activityNum) and activityNum <= Activity_IndexData.activityNum then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

local function GetConfigTable(level)
  local cfgs = ConfigManager.FindConfigs("cfg_union_badge", "badgeLevel", level)
  for index, cfg in ipairs(cfgs) do
    if RoleManager.me.data.career == tonumber(cfg.career) then
      return cfg
    end
  end
  return nil
end

function RedPointChecker_Ext:WarAllianceArmbandRedPoint(rootName, parentName, childName)
  if self.isWarArmbandSend then
    NetManager.Send(UnionMessage.ReqBadgeInfo)
    self.isWarArmbandSend = false
    return
  end
  local data = WarAllianceData.MyArmbandData
  if table.count(data) > 0 and data.unionLevel > data.level then
    local NextLevelTbl = GetConfigTable(data.level + 1)
    if NextLevelTbl then
      local id = 1000070
      local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
      if bagCount >= NextLevelTbl.badgeExp then
        return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
      end
    end
  end
  return false
end

function RedPointChecker_Ext:CrossRealmRedPoint(rootName, parentName, childName)
  if childName == "Main_MainMenuUI#btn_kuafu" or childName == "CrossServer_IntoUI#btn_activeList" then
    local cfgTbl = ConfigManager.FindConfigs("cfg_Global_global", "id", 11110001)[1]
    local isJoin = ServerDataRecordData.GetIntRecordData(SerRecordIntType.joined) == nil and true or false
    if cfgTbl ~= nil and UIManager.IsVisible(UIID.CrossServer_IntoUI) and ConditionManager.Check4D(cfgTbl.effect) then
      isJoin = true
      LoginData.joined = ViewData.meData.id
    end
    if LoginData.joined == ViewData.meData.id then
      isJoin = false
    end
    if cfgTbl ~= nil and ConditionManager.Check4D(cfgTbl.effect) and isJoin then
      return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
    end
  end
  return false
end

function RedPointChecker_Ext:HookProfitRedPoint(rootName, parentName, childName)
  if OnHookData.CheckRedPointState() then
    return self:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  end
  return false
end

function RedPointChecker_Ext:AuctionUnionRedPoint(rootName, parentName, childName)
  return AuctionData.isFirstOpenAuctionUnionTips and self.isHaveUnionAuctionData and AuctionData.CheackUnion()
end

function RedPointChecker_Ext:AuctionUnionCampRedPoint(rootName, parentName, childName)
  return AuctionData.isFirstOpenAuctionUnionCampTips and self.isHaveUnionCampAuctionData and AuctionData.CheackUnionCamp()
end

function RedPointChecker_Ext:IsHaveBtnCloseRedPointUI(rootName, parentName, childName)
  if rootName ~= "" and not FucShowOrHideController.IsFuncButtonShow(rootName) then
    return false
  end
  if parentName ~= "" then
    local parentTabTest = string.split(parentName, "&")
    for i = 1, #parentTabTest do
      if not FucShowOrHideController.IsFuncButtonShow(parentTabTest[i]) then
        return false
      end
    end
  end
  if childName ~= "" and not FucShowOrHideController.IsFuncButtonShow(childName) then
    return false
  end
  return true
end

function RedPointChecker_Ext:Destory()
  self.messageContainer:UnRegistAll()
  self.eventContainer:UnRegistAll()
  for k, v in pairs(self) do
    v = nil
  end
end

function RedPointChecker_Ext:RedPointBubbleDataInit()
  self.bubbleData = {}
  local tempTab = ClientTable.cfg_Red_pointManager:GetDic()
  for k, v in pairs(tempTab) do
    table.insert(self.bubbleData, v)
  end
end

function RedPointChecker_Ext:IsActivityRefresh(index)
  if index == 3 or index == 5 or index == 6 or index == 7 or index == 8 or index == 9 or index == 11 or index == 12 or index == 13 then
    return true
  end
  return false
end

function RedPointChecker_Ext:GetSingleBubbleData()
  local uiId
  if self.intensifyPrompt then
    uiId = UIID.Equip_IntensifyUI
  elseif self.ornamentsPrompt then
    uiId = UIID.Equip_OrnamentsUI
  end
  return uiId
end

return RedPointChecker_Ext

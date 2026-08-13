local RedPointChecker = {}

function RedPointChecker:GetPlayerData()
end

function RedPointChecker:IsNoProcessing(id)
  return id == ERedPointId.combine or id == ERedPointId.forge_inlaid1 or id == ERedPointId.forge_inlaid2 or id == ERedPointId.forge_inlaid3 or id == ERedPointId.forge_inlaid4 or id == ERedPointId.forge_inlaid5 or id == ERedPointId.forge_inlaidupgrade
end

function RedPointChecker:IsNeedNewProcess(id)
  return id ~= nil and (76 < id or id == ERedPointId.waralliance_armband_HP)
end

function RedPointChecker:CheckIsNeedShow(id, type, param)
  if id == ERedPointId.guard then
    local isOpen = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():IsNeedShowGuardRed()
    return isOpen
  elseif id == ERedPointId.guard_equip then
    local isOpen = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():IsNeedShowGuardEquipRed()
    return isOpen
  elseif id == ERedPointId.guard_culture then
    local isOpen = gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():IsNeedShowGuardCultureRed()
    return isOpen
  elseif id == ERedPointId.open_guard_invest then
    local isOpen = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():IsShowGuardRedPoint()
    return isOpen
  elseif type == ERedPointType.member then
    if gameMgr:GetAvatarManager() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():IsShowRedPoint(id)
    end
  elseif type == ERedPointType.waralliance_armband then
    if gameMgr:GetAvatarManager() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetUnionArmbandDataMgr():IsShowRedPoint(id)
    end
  elseif type == ERedPointType.Equip_SignetUI then
    if gameMgr:GetAvatarManager() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetHolySealDataMgr():IsShowRedPoint(id)
    end
  elseif id == ERedPointId.forge_inlaid then
    if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer():GetInlayBagDataMgr() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetInlayBagDataMgr():GetRedPointMgr():IsShowRedPoint()
    end
  elseif id == ERedPointId.gem_UpLevel then
    if gameMgr:GetAvatarManager() then
      local recommendGem = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GetRecommendGemData()
      if recommendGem ~= nil then
        return recommendGem:IsCanUpLevel()
      end
    end
  elseif id == ERedPointId.welfare_lifeLimitBuy then
    return CommercializeData:CheckLimitBuyRed()
  elseif type == ERedPointType.Equip_GemUI then
    if gameMgr:GetAvatarManager() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():GemPositionCanUp(GemUtility.EquipGemPanelChooseEquipIndex, tonumber(param))
    end
  elseif type == ERedPointType.Bag_EquipInfoUI then
    if gameMgr:GetAvatarManager() then
      local ui, suitType, equipIndex = UIManager.GetUiByName(UIID.Bag_EquipInfoUI), EquipCellType.NORMAL, tonumber(param)
      if ui and ui.SuitType then
        suitType = ui.SuitType
      end
      equipIndex = ClientTable.cfg_EquipCell_cellManager:GetEquipIndexPrefix(suitType) + equipIndex
      if UIManager.IsVisible(UIID.Equip_GemUI) then
        return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetEquipIndexExtraDataManager():EquipIndexHaveCanUpGem(tonumber(param))
      elseif UIManager.IsVisible(UIID.Equip_IntensifyUI) then
        return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():EquipPositionCanIntensify(equipIndex)
      elseif UIManager.IsVisible(UIID.Equip_ZhuijiaUI) then
        return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():EquipPositionCanAdditional(tonumber(param))
      elseif UIManager.IsVisible(UIID.Equip_RegenerateUI) then
        return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():RegEquipPositionCanAdditional(tonumber(param))
      elseif UIManager.IsVisible(UIID.Equip_RunesInlayUI) then
        return MeRunneController:CheckEquipIndexCanSetRune(equipIndex)
      elseif UIManager.IsVisible(UIID.Equip_EnchantUpgradeUI) then
        return gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():CheckEnchantEquipIndexUpgradeRed(equipIndex)
      elseif UIManager.IsVisible(UIID.Equip_EnchantInlayUI) then
        return gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():CheckEnchantEquipIndexInlayRed(equipIndex)
      end
    end
  elseif id == ERedPointId.gamebook then
    if gameMgr:GetGameBookMgr() then
      return gameMgr:GetGameBookMgr():IsShowGameBookRedPoint()
    end
  elseif id == ERedPointId.intensify_Equip then
    local suitList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(EquipCellType.NORMAL)
    return suitList:CheckHaveIntensifyEquip()
  elseif id == ERedPointId.intensify_RedEquip then
    local suitList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(EquipCellType.HONGZHUANG)
    return FucShowOrHideController.FuncSystemIsOpen(2010002) and suitList:CheckHaveIntensifyEquip()
  elseif id == ERedPointId.regene then
    if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetRegenerateyeqian()
    end
  elseif id == ERedPointId.Regene_1 then
    if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetRegenerate()
    end
  elseif id == ERedPointId.Regene_2 then
    if gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetRegenerateEvolu()
    end
  elseif id == ERedPointId.holyspirit then
    if gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetHolySpiritDataMgr():CheckExpendCanUpgrade()
    end
  elseif id == ERedPointId.xuanshang then
    return RedPointChecker_Ext:JudgeUnionComplete()
  elseif id == ERedPointId.activity_lianchong_50 then
    return RedPointChecker_Ext:GetTogHolidayRedPoint(ERedPointId.activity_lianchong_50)
  elseif id == ERedPointId.MasterSkill then
    if FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.MasterSkill) then
      return QuickFind.MasterDataMgr() and QuickFind.MasterDataMgr():CheckShowMainMenuMasterSkillRedPoint()
    end
  elseif id == ERedPointId.Runes_Inlay then
    if gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr() then
      return MeRunneController:CheckRuneRedPoint()
    end
  elseif id == ERedPointId.Runes_Fusion then
  elseif id == ERedPointId.combineActivity_lianchong then
    if QuickFind:Co_serving_LCFLData() then
      return QuickFind:Co_serving_LCFLData():CheckRedPointState()
    end
  elseif id == ERedPointId.combineActivity_zhanlin then
    if gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.MiracleBattlePass) then
      return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.MiracleBattlePass):CheckRedPointState()
    end
  elseif id == ERedPointId.holidayActivity_WorldCup then
    if QuickFind:GetWorldCupGuessData() then
      return QuickFind:GetWorldCupGuessData():CheckRedPointState()
    end
  elseif id == ERedPointId.Holyring_1 then
    if gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():RedPointRefresh()
    end
  elseif id == ERedPointId.welfare_AccumulativeGift then
    return CommercializeData.CheckAccumulativeGiftRed()
  elseif id == ERedPointId.welfare_LuckyStar1 or id == ERedPointId.welfare_LuckyStar2 or id == ERedPointId.welfare_LuckyStar3 or id == ERedPointId.welfare_LuckyStar4 then
    if RechargeData.LuckyStarData then
      return RechargeData.LuckyStarData:RedPointRefresh(id)
    end
  elseif id == ERedPointId.welfare_everydayRMBgift then
    return RechargeData.CheckIsShowDirectPurchaseGiftRedPoint()
  elseif id == ERedPointId.holidayActivity_SevenDayGift then
    if QuickFind:GetSevenDayGiftData() then
      return QuickFind:GetSevenDayGiftData():CheckRedPointState()
    end
  elseif id == ERedPointId.holidayActivity_FirecrackerTreasureHunting then
    if QuickFind:GetFirecrackerTreasureHuntingDataMgr() then
      return QuickFind:GetFirecrackerTreasureHuntingDataMgr():CheckIsShowRedPoint()
    end
  elseif id == ERedPointId.holidayActivity_Yutulaixi then
    if QuickFind:GetYutulaixiDataMgr() then
      return QuickFind:GetYutulaixiDataMgr():CheckIsShowRedPoint()
    end
  elseif id == ERedPointId.holidayActivity_Denglu then
    if QuickFind:GetSpringActivityDataMgr() then
      return QuickFind:GetSpringActivityDataMgr():RefreshSpringRedPoint()
    end
  elseif id == ERedPointId.activity_redpacket then
    if gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetWarAllianceRedEnvelopeManager() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetWarAllianceRedEnvelopeManager():JudgeRedPointState()
    end
  elseif id == ERedPointId.TimeLimited_Investment then
    if QuickFind:GetOpenServerInvestmentData() then
      return QuickFind:GetOpenServerInvestmentData():CheckRedPointState()
    end
  elseif type == ERedPointType.sacredBone_Equip then
    if gameMgr:GetAvatarManager():GetMainPlayer() and not string.isNullOrEmpty(param) then
      if UIManager.IsVisible(UIID.Equip_HolySkeletonUI) then
        return gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():CheckHolySkeletonIntensifyPlaceRedPoint(tonumber(param))
      elseif UIManager.IsVisible(UIID.Equip_HolySkeletonInlayUI) then
        return gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SetSacredBoneEquipRedPoint(tonumber(param))
      end
    end
  elseif id == ERedPointId.TimeLimited_CollectWord then
    local isShow = RedPointChecker_Ext:GetTogTimeLimitedRedPoint(id)
    return isShow
  elseif id == ERedPointId.TimeLimited_zhanlin then
    if gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.LimitedTimeActivity):GetActivityData(TimeLimitedActivityIdType.MiracleBattlePass) then
      return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.LimitedTimeActivity):GetActivityData(TimeLimitedActivityIdType.MiracleBattlePass):CheckRedPointState()
    end
  elseif id == ERedPointId.combineActivity_Task then
    if gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.CombineTask) then
      return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.CombineTask):CheckRedPointState()
    end
  elseif id == ERedPointId.sacred_Bone_Intensify then
    if gameMgr:GetAvatarManager():GetMainPlayer() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetHolySkeletonIntensifyDataMgr():CheckHolySkeletonIntensifyRedPoint()
    end
  elseif id == ERedPointId.sacred_Bone_Inlay then
    if gameMgr:GetAvatarManager():GetMainPlayer() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():SetSacredBoneTogRedPoint()
    end
  elseif id == ERedPointId.sacred_Bone_Synthesis then
    if gameMgr:GetAvatarManager():GetMainPlayer() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():CheckIsShowCombineRedPoint()
    end
  elseif id == ERedPointId.combineActivity_GoodFiftsEveryDay then
    if QuickFind:GetGoodFiftsEveryDayData() then
      return QuickFind:GetGoodFiftsEveryDayData():RedPointCheck()
    end
  elseif id == ERedPointId.holidayActivity_HolidayInvest then
    if QuickFind:GetHolidayInvestData() then
      return QuickFind:GetHolidayInvestData():AllRedPointCheck()
    end
  elseif id == ERedPointId.holidayActivity_ConnectionGift then
    if QuickFind:GetConnectionGiftManager() then
      return QuickFind:GetConnectionGiftManager():GetRewardRedPoint()
    end
  elseif id == ERedPointId.holidayActivity_Gashapon then
    if QuickFind:GetConnectionNiudanManager() then
      return QuickFind:GetConnectionNiudanManager():GetRewardRedPoint()
    end
  elseif id == ERedPointId.holidayActivity_LuckyRebates then
    if gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.LuckyRebate) then
      return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.LuckyRebate):CheckRedPointState()
    end
  elseif id == ERedPointId.Naming then
    if gameMgr:GetAvatarManager() then
      return gameMgr:GetAvatarManager():GetMainPlayer():GetRewriteNamingData():GetNamingRedPoint()
    end
  elseif id == ERedPointId.welfare_Pccharge then
    return RechargeData.GoldDiamondRechargeData.RedPointCheck()
  elseif id == ERedPointId.pc_FirstLogin then
    return PCActivityManager:CheckFirstLoginRedPoint()
  elseif id == ERedPointId.pc_DailyRegistration then
    return PCActivityManager:CheckDailyRegistrationRedPoint()
  elseif id == ERedPointId.pc_CumulativeRecharge then
    return PCActivityManager:CheckCumulativeRechargeRedPoint()
  elseif id == ERedPointId.return_activity then
    return ReturnActivityData.CheckRedPoint()
  elseif id == ERedPointId.Enchant_upgrade then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():CheckEnchantEquipUpgradeRed()
  elseif id == ERedPointId.Enchant_enchant then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():CheckEnchantEquipInlayRed()
  elseif id == ERedPointId.AnniversaryActivity_qiandao then
    return AnniversaryActivity_SignInData.CheckRedPoint()
  elseif id == ERedPointId.AnniversaryActivity_NPC then
    return AnniversaryActivity_NPCActivityData.CheckRedPoint()
  elseif id == ERedPointId.AnniversaryActivity_zhanlin then
    return AnniversaryActivity_BattleOrderData.CheckRedPoint()
  elseif id == ERedPointId.AnniversaryActivity_chuangjue then
    return AnniversaryActivity_NewCharacterData.CheckRedPoint()
  elseif id == ERedPointId.AnniversaryActivity_monster then
    return AnniversaryActivity_MonsterData.CheckRedPoint()
  elseif id == ERedPointId.golden_hunt then
    if QuickFind:GetTask_EarlyGoldManager() then
      return QuickFind:GetTask_EarlyGoldManager():GetRedPoint()
    end
  elseif id == ERedPointId.Join_VIP then
    if QuickFind:GetJoinVipManager() then
      return QuickFind:GetJoinVipManager():RefreshRedPoint()
    end
  elseif type == ERedPointType.Team3V3UI then
    return QuickFind:GetTeam3V3DataMgr():CheckRedPoint(2)
  elseif id == ERedPointId.Team3V3 then
    return QuickFind:GetTeam3V3DataMgr():CheckRedPoint(1)
  end
  return false
end

return RedPointChecker

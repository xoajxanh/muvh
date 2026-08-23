local QuickFind = {}

function QuickFind:Init()
  self:InitPlayerFind()
  self:InitMainPlayerInfoFind()
  self:InitSceneInfoFind()
end

function QuickFind:InitPlayerFind()
  function self.LuaMainPlayer()
    return gameMgr:GetAvatarManager():GetMainPlayer()
  end
  
  function self.LuaMainPlayerData()
    return gameMgr:GetAvatarManager():GetMainPlayer():GetInfo()
  end
  
  function self.LuaMainPlayerViewAttrData()
    return gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():GetOtherAttr()
  end
  
  function self.MasterSysData()
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMasterDataMgr()
  end
  
  function self.MasterDataMgr()
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMasterSkillDataMgr()
  end
  
  function self.RunesFusionDataMgr()
    return gameMgr:GetAvatarManager():GetMainPlayer():GetRunesFusionDataMgr()
  end
end

function QuickFind:InitMainPlayerInfoFind()
  function self.LuaMainPlayerEquipData()
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager()
  end
end

function QuickFind:InitSceneInfoFind()
  function self.LuaSceneOnHookPointDataManager()
    return gameMgr:GetSceneManager():GetSceneDataManager():GetSceneOnHookPointDataManager()
  end
end

function QuickFind:DestoryPlayerFind()
  self.LuaMainPlayer = nil
  self.LuaMainPlayerData = nil
  self.LuaMainPlayerViewAttrData = nil
  self.MasterSysData = nil
  self.MasterDataMgr = nil
  self.RunesFusionDataMgr = nil
end

function QuickFind:GetCombineFirstGiftData()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.CombineFirstGiftData)
end

function QuickFind:Co_serving_LCFLData()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.LianChongFanLi)
end

function QuickFind:CommercialRankingData()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.ConsumeRanking)
end

function QuickFind:GetGoodFiftsEveryDayData()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.GoodFiftsEveryDay)
end

function QuickFind:GetWorldCupGuessData()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.WorldCupGuess)
end

function QuickFind:GetSevenDayGiftData()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.SevenDayGift)
end

function QuickFind:GetFirecrackerTreasureHuntingDataMgr()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.FirecrackerTreasureHunting)
end

function QuickFind:GetSpringActivityDataMgr()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.SpringActivity)
end

function QuickFind:GetYutulaixiDataMgr()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.Yutulaixi)
end

function QuickFind:GetOpenServerInvestmentData()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.LimitedTimeActivity):GetActivityData(TimeLimitedActivityIdType.OpenServerInvestment)
end

function QuickFind:GetKunShouBattleDataMgr()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity):GetActivityData(PlayActivityIdType.KunShouBattle)
end

function QuickFind:GetHolidayInvestData()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.HolidayInvest)
end

function QuickFind:GetConnectionGiftManager()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.ConnectionGift)
end

function QuickFind:GetConnectionNiudanManager()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.DiamondGashapon)
end

function QuickFind:GetThreeVsThreeDataMgr()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity):GetActivityData(PlayActivityIdType.ThreeVsThree)
end

function QuickFind:GetDuoQiCrossDataManager()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity):GetActivityData(PlayActivityIdType.DuoQiCross)
end

function QuickFind:GetDuoQiZhengBaManager()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity):GetActivityData(PlayActivityIdType.DuoQiZhengBa)
end

function QuickFind:GetShoppingSpreeDataMgr()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.HolidayActivity):GetActivityData(HolidayActivityIdType.ShoppongSpree)
end

function QuickFind:GetNewRuneDataManager()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetNewRuneDataManager()
end

function QuickFind:GetSpaceCrackDataManager()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity):GetActivityData(PlayActivityIdType.SpaceCrack)
end

function QuickFind:GetTask_EarlyGoldManager()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetTask_EarlyGoldManager()
end

function QuickFind:GetJoinVipManager()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetJoinVipManager()
end

function QuickFind:GetOtherWelfareDataMgr()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetOtherWelfareData()
end

function QuickFind:GetSiFangZhengBaDataManager()
  return gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.PlayActivity):GetActivityData(PlayActivityIdType.SiFangZhengBa)
end

function QuickFind:GetTeam3V3DataMgr()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetTeam3V3Data()
end

function QuickFind:Destory()
  self:DestoryPlayerFind()
end

return QuickFind

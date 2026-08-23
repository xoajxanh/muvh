require("GameConst/CommercializeEnum")
require("GameModel/CommercializeData")
require("GameModel/CommercialHolidayData")
require("GameModel/CommercialTimeLimitedActivityData")
CommercializeController = {}
local this = CommercializeController

function CommercializeController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function CommercializeController.RegistEvent()
end

function CommercializeController.RegistMessages()
  this.messageContainer:Regist(CommerceMessage.ResGetCommercialActivityTab, this.ResGetCommercialActivityTabInfo)
  this.messageContainer:Regist(CommerceMessage.ResGetCommercialActivityInfo, this.ResGetCommercialActivityInfoInfo)
  this.messageContainer:Regist(RechargeMessage.ResEverydayRechargeInfo, this.ResEverydayRechargeInfoInfo)
  this.messageContainer:Regist(RechargeMessage.ResDailyRechargeInfo, this.ResDailydayRechargeInfoInfo)
  this.messageContainer:Regist(RechargeMessage.ResDirectRepayInfo, this.ResDirectRepayInfoInfo)
  this.messageContainer:Regist(RechargeMessage.ResSkyPavilion, this.ResSkyPavilionInfo)
  this.messageContainer:Regist(CommerceMessage.ResSingleFireworkAnnounce, this.ResSingleFireworkAnnounce)
  this.messageContainer:Regist(CommerceMessage.ResAccumulateRechargeActivityInfo, this.ResAccumulativeGiftDataInfo)
end

function CommercializeController.ReqGetCommercialActivityTabFun(Tab)
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, {icon = Tab})
end

function CommercializeController.ResGetCommercialActivityTabInfo(_, data)
  local groupIds = {}
  for key, id in pairs(data.groupId) do
    local cfgs = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", id)
    local cfg
    if not table.isNullOrEmpty(cfgs) then
      for i, v in pairs(cfgs) do
        if v.commerceType == data.icon then
          cfg = v
          break
        end
      end
    end
    if cfg ~= nil and ConditionManager.Check4D(cfg.level) and id ~= 329 then
      table.insert(groupIds, id)
    end
  end
  if CommercializeActivityTab.Opening_service == data.icon then
    CommercializeData.OpenSergroupTogId = groupIds
    EventManager.Dispatch(Event.Commer_OpeningserTog)
  elseif CommercializeActivityTab.Holiday == data.icon then
    CommercialHolidayData.HolidayTogId = groupIds
    EventManager.Dispatch(Event.Commer_HolidayTog)
  elseif CommercializeActivityTab.LimitedTime == data.icon then
    CommercialTimeLimitedActivityData.HolidayTogId = groupIds
    EventManager.Dispatch(Event.Commer_HolidayTog)
  elseif CommercializeActivityTab.Return_service == data.icon then
    ReturnActivityData.HolidayTogId = groupIds
    EventManager.Dispatch(Event.Commer_HolidayTog)
  elseif CommercializeActivityTab.Anniversary == data.icon then
    AnniversaryActivity_ActivityData.ActivityTogId = groupIds
    EventManager.Dispatch(Event.Commer_HolidayTog)
  end
end

function CommercializeController.ResGetCommercialActivityInfoInfo(_, data)
  if CommercializeActivityTab.Opening_service == data.icon then
    CommercializeData.OpenSercurTogInfo = data
    EventManager.Dispatch(Event.Commer_Openingserinfo)
    CommercializeData.EquipFirstRed(data)
    CommercializeData.WeekSignRed(data)
  elseif CommercializeActivityTab.Holiday == data.icon then
    CommercialHolidayData.HolidayTogSerInfo = data
    EventManager.Dispatch(Event.Commer_Holidayinfo)
  elseif CommercializeActivityTab.LimitedTime == data.icon then
    CommercialTimeLimitedActivityData.HolidayTogSerInfo = data
    EventManager.Dispatch(Event.Commer_Holidayinfo)
  elseif CommercializeActivityTab.Return_service == data.icon then
    ReturnActivityData.HolidayTogSerInfo = data
    EventManager.Dispatch(Event.Commer_Holidayinfo)
  end
end

function CommercializeController.ReqEverydayRecharge()
  NetManager.Send(CountMessage.ReqCountByType, {
    type = RefreshData.TypeEnum.RechFristGift
  })
  NetManager.Send(CountMessage.ReqCountByType, {
    type = RefreshData.TypeEnum.DirectRecharge
  })
end

function CommercializeController.ReqTimeBuyChange()
  NetManager.Send(CountMessage.ReqCountByType, {
    type = RefreshData.TypeEnum.TimeLimitBuy
  })
end

function CommercializeController.ReqNomalrechange()
  NetManager.Send(CountMessage.ReqCountByType, {
    type = RefreshData.TypeEnum.NomalRecharge
  })
end

function CommercializeController.ReqLimitBuyChange()
  NetManager.Send(CountMessage.ReqCountByType, {
    type = RefreshData.TypeEnum.LimitBuy
  })
end

function CommercializeController.OpenserActivit()
  for i, v in pairs(CommercializeOpeningserGrop) do
    local Tbl = ConfigManager.FindConfigs("cfg_Commerce_overview", "group", v)[1]
    if Tbl then
      local condition = Tbl.condition
      if condition and ConditionManager.Check(condition) then
        NetManager.Send(CommerceMessage.ReqGetCommercialActivityInfo, {
          icon = CommercializeActivityTab.Opening_service,
          groupId = v
        })
      end
    end
  end
end

function CommercializeController.ResEverydayRechargeInfoInfo(_, data)
  CommercializeData.WelfareEveryDayInfo = data
  EventManager.Dispatch(Event.Commer_WelfareEveryDay)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.recharge,
    state = true
  })
end

function CommercializeController.ResDailydayRechargeInfoInfo(_, data)
  CommercializeData.WelfareDailyDayInfo = data
  EventManager.Dispatch(Event.Commer_WelfareDailyDay)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.recharge,
    state = true
  })
end

function CommercializeController.ResDirectRepayInfoInfo(_, data)
  CommercializeData.DirectRepayInfo = data
  EventManager.Dispatch(Event.Recharge_PrizeGiveback, true)
end

function CommercializeController.FucRefresh(_)
  local MainUI = UIManager.GetUiByName(UIID.MainMenuUI)
  if not MainUI.btn_TianKong.gameObject.activeSelf then
    local UpCloseTime = CommercializeData:SkyBtnUpCloseTime()
    local level = ConditionManager.GenerateSingleCondition(UpCloseTime.Condition[1]):Check()
    local Serverday = ConditionManager.GenerateSingleCondition(UpCloseTime.Condition[2]):Check()
    if Serverday and level then
      this.ReqSkyPavilionInfo()
    end
  end
end

function CommercializeController.ReqSkyPavilionInfo()
  NetManager.Send(RechargeMessage.ReqSkyPavilionInfo)
end

function CommercializeController.ResSkyPavilionInfo(_, data)
  local UpCloseTime = CommercializeData:SkyBtnUpCloseTime()
  local level = ConditionManager.GenerateSingleCondition(UpCloseTime.Condition[1]):Check()
  local Serverday = ConditionManager.GenerateSingleCondition(UpCloseTime.Condition[2]):Check()
  local MainUI = UIManager.GetUiByName(UIID.MainMenuUI)
  if Serverday and level and Time.GetServerSecondTime() < data.startTime + UpCloseTime.up then
    CommercializeData.SkyPaviMainBtn = true
    if MainUI and MainUI.btn_TianKong.gameObject.activeSelf ~= true then
      EventManager.Dispatch(Event.Fuc_SingleRefresh, {4011401})
    end
  else
    CommercializeData.SkyPaviMainBtn = false
    if MainUI and MainUI.btn_TianKong.gameObject.activeSelf ~= false then
      EventManager.Dispatch(Event.Fuc_SingleRefresh, {4011401})
    end
  end
  CommercializeData.SkyPavilionInfo = data
  EventManager.Dispatch(Event.Commer_SkyPavilionInfo)
  CommercializeData:TianKongMiGeRewardFun(CommercializeData.SkyPavilionInfo.groupId)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.sky,
    state = true
  })
end

function CommercializeController.ResSingleFireworkAnnounce(_, data)
  CommercialHolidayData.AddHolidayFireworksBulletin(data)
end

function CommercializeController.ResAccumulativeGiftDataInfo(_, data)
  CommercializeData.AccumulativeGiftDataInfo = data
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.welfare_AccumulativeGift
  })
  EventManager.Dispatch(Event.Commercialize_AccumulativeGift, {
    groupId = data.group
  })
end

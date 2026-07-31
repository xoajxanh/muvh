require("GameModel/PC_Activity/PCActivityManager")
require("GameModel/PC_Activity/PCActivityEnum")
PCActivityController = {}
local this = PCActivityController

function PCActivityController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  PCActivityManager:Init()
end

function PCActivityController.RegistEvent()
  this.messageContainer:Regist(RechargeMessage.ResPlatformLoginInfo, this.ResPlatformLoginInfo)
  this.messageContainer:Regist(RechargeMessage.ResPCTotalRechargePoint, this.ResPCTotalRechargePoint)
  this.eventContainer:Regist(Event.Bag_ResBagChange, this.ResBagChange)
  this.eventContainer:Regist(Event.CountsRefresh, this.ResBagChange)
end

function PCActivityController.ResPlatformLoginInfo(id, tblData)
  if tblData == nil or tblData.info == nil then
    return
  end
  PCActivityManager:RefreshDailyRegistrationDays(tblData.info)
end

function PCActivityController.ResPCTotalRechargePoint(id, tblData)
  if tblData == nil or tblData.totalPoint == nil then
    return
  end
  PCActivityManager:RefreshPCTotalRechargePoint(tblData.totalPoint)
end

function PCActivityController.ResBagChange()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    type = ERedPointType.Pc_ActivityUI
  })
end

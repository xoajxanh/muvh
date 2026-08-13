RechargeController = {}
local this = RechargeController
require("GameModel/RechargeData")

function RechargeController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function RechargeController.RegistEvent()
  this.eventContainer:Regist(Event.Recharge_CountRefresh, this.RechargeItemCountRefresh)
  this.eventContainer:Regist(Event.FirstChargeRefresh, this.RechargeItemCountRefresh)
end

function RechargeController.RechargeItemCountRefresh(_, msg)
  RechargeData.CountRefresh(msg)
end

function RechargeController.RefreshTimeRecharge()
  local isOpen = RechargeData.GetIsOpenTimeRecharge()
  EventManager.Dispatch(Event.RefreshTimeRecharge, isOpen)
end

function RechargeController.ResRechargeInfo(_, msg)
  logPurple("N\225\186\161p th\195\160nh c\195\180ng")
  FloatingWordUtility.QuickMsg("N\225\186\161p th\195\160nh c\195\180ng")
  if msg == nil then
    return
  end
  logPurple("msg ===", table.toString(msg, true))
  RoleManager.me.data.rechargePoint = msg.point
  NetManager.Send(RechargeMessage.ReqEverydayRechargeInfo)
  NetManager.Send(RechargeMessage.ReqDailyRechargeInfo)
  EventManager.Dispatch(Event.Recharge_RechargeSuccess, msg)
  EventManager.Dispatch(Event.Fuc_Refresh)
end

function RechargeController.RegistMessages()
  this.messageContainer:Regist(RechargeMessage.ResRechargeInfoMassage, this.ResRechargeInfo)
  this.messageContainer:Regist(EquipMessage.ResEquipChange, this.MonthCardInfo)
end

function RechargeController.MonthCardInfo(_, msg)
  RechargeData.SetCurrentEquipmentData(msg.items)
end

this.Init()

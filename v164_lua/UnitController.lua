UnitController = {}
local this = UnitController
this.MultipleTime = 0

function UnitController.Init()
  this.RegistEvent()
  this.InitEvents()
end

function UnitController.RegistEvent()
  this.messageContainer = EventContainer(NetManager)
  this.messageContainer:Regist(UnitMessage.ResAddUnit, this.ResAddUnit)
  this.messageContainer:Regist(UnitMessage.ResRemoveUnit, this.ResRemoveUnit)
  this.messageContainer:Regist(UnitMessage.ResSwitchUnitBuff, this.ResSwithUnitBuff)
  this.messageContainer:Regist(UnitMessage.ResUnitChange, this.ResUnitBuffChange)
  this.messageContainer:Regist(CommerceMessage.ResExpCommerce, this.ResExpCommerce)
end

function UnitController.InitEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.OnGamePlay_Leave)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.OnGamePlay_Leave)
end

function UnitController.RefreshMultipleTime(time)
  if time then
    ExpAddData.MultipleTime = time / 1000
    ExpAddData.MultipleTimeStamp = Time.GetServerSecondTime() + ExpAddData.MultipleTime
    EventManager.Dispatch(Event.Role_RefreshMultipleUI)
  end
end

function UnitController.RefreshEfficientTime(time)
  if time then
    ExpAddData.EfficientTime = time / 1000
    EventManager.Dispatch(Event.Role_RefreshEfficientUI)
  end
end

function UnitController.ResAddUnit(id, msg)
  local data = json.decode(msg.param)
  if msg.type == UnitType.ThreeExp then
    ExpAddData.IsMultiple = data.state == ThreeUnitExp.Open and true or false
    this.RefreshMultipleTime(data.totalTime)
    EventManager.Dispatch(Event.EfficientExpiredTips, data.totalTime)
  elseif msg.type == UnitType.Efficient then
    ExpAddData.IsEfficient = data.state == ThreeUnitExp.Open and true or false
    this.RefreshEfficientTime(data.totalTime)
  elseif msg.type == UnitType.KillMonster then
    KillMonsterCardData.AddBuff(data)
  elseif msg.type == UnitType.KillMonsterCross then
    KillMonsterCardData.AddCrossBuff(data)
  end
end

function UnitController.ResRemoveUnit(id, msg)
  if msg.type == UnitType.ThreeExp then
    ExpAddData.IsMultiple = false
    this.RefreshMultipleTime(0)
    if not UIManager.IsVisible(UIID.MainMenuUI) then
      ExpiredPromptData.AddExpired(ExpiredTypeEnum.Efficient, 0)
    elseif ExpiredPromptData.isTraverseUI(ExpiredTypeEnum.Efficient, 0) then
      ExpiredPromptData.ShowSortUI(ExpiredTypeEnum.Efficient)
    end
  elseif msg.type == UnitType.Efficient then
    ExpAddData.IsEfficient = false
    this.RefreshEfficientTime(0)
  elseif msg.type == UnitType.KillMonster then
    KillMonsterCardData.RemoveBuff({totalTime = 0, state = 2})
  elseif msg.type == UnitType.KillMonsterCross then
    KillMonsterCardData.RemoveCrossBuff({totalTime = 0, state = 2})
  end
end

function UnitController.ResSwithUnitBuff(id, msg)
  if msg.type == UnitType.ThreeExp then
    this.RefreshMultipleTime(msg.totalTime)
  elseif msg.type == UnitType.KillMonster then
    KillMonsterCardData.SwitchBuff(msg)
  elseif msg.type == UnitType.KillMonsterCross then
    KillMonsterCardData.SwitchCrossBuff(msg)
  end
end

function UnitController.ResUnitBuffChange(id, msg)
  if msg.type == UnitType.ThreeExp then
    ExpAddData.IsMultiple = msg.state == ThreeUnitExp.Open and true or false
    this.RefreshMultipleTime(msg.totalTime)
  elseif msg.type == UnitType.Efficient then
    ExpAddData.IsEfficient = msg.state == ThreeUnitExp.Open and true or false
    this.RefreshEfficientTime(msg.totalTime)
  elseif msg.type == UnitType.KillMonster then
    KillMonsterCardData.ChangeData(msg)
  elseif msg.type == UnitType.KillMonsterCross then
    KillMonsterCardData.ChangeCrossData(msg)
  end
end

function UnitController.ResExpCommerce(id, msg)
  if msg == nil then
    return
  end
  ExpAddData.HolidayExp = math.floor(msg.expRate / 100)
  EventManager.Dispatch(Event.Role_HolidayExp, msg)
end

function UnitController.OnGamePlay_Leave(id, msg)
  ExpAddData.IsMultiple = false
  ExpAddData.IsEfficient = false
  this.RefreshMultipleTime(0)
  this.RefreshEfficientTime(0)
end

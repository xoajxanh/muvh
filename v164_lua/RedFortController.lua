RedFortController = {}
require("GameModel/RedFortData")
require("GameConst/RedFortStateEnum")
local this = RedFortController

function RedFortController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegisterMessages()
  this.RegisterEvents()
end

function RedFortController.RegisterMessages()
  this.messageContainer:Regist(MapMessage.SystemInstance_ChiSeYaoSai, this.OnResRedFort)
  this.messageContainer:Regist(MapMessage.SystemInstance_ChiSeYaoSaiRank, this.OnResResult)
  this.messageContainer:Regist(ActivityMessage.ResSignChiSeYaoSaiActivity, this.SignChiSeActivity)
  this.messageContainer:Regist(ActivityMessage.ResChiSeYaoTimeCountDown, this.ResChiSeYaoTimeCountDown)
  this.messageContainer:Regist(ActivityMessage.ResChiSeYaoSurvival, this.PlayerSurNumChange)
  this.messageContainer:Regist(ActivityMessage.ResChiSeYaoTotal, this.PlayerTotalNumChange)
  this.messageContainer:Regist(ActivityMessage.ResChiSeYaoCircle, this.ResChiSeYaoCircle)
  this.messageContainer:Regist(ActivityMessage.ResChiSeYaoTotal, this.ResChiSeYaoTotal)
  this.messageContainer:Regist(ActivityMessage.ResSignChiSeYaoSai, this.ResSignChiSeYaoSai)
end

function RedFortController.ResSignChiSeYaoSai(id, msg)
  RedFortData.ResChiSeSingNotice(msg.prepare)
end

function RedFortController.ResChiSeYaoTotal(id, msg)
  RedFortData.ResChiSeYaoTotal(msg.total)
end

function RedFortController.ResChiSeYaoCircle(id, msg)
  RedFortData.ResChiSeYaoCircle(msg.circle)
end

function RedFortController.ResChiSeYaoTimeCountDown(id, msg)
  RedFortData.UpdateActivityCountDown(msg)
end

function RedFortController.PlayerSurNumChange(id, msg)
  if not msg then
    return
  end
  RedFortData.UpdateSurviveNum(msg.survival)
end

function RedFortController.PlayerTotalNumChange(id, msg)
  if not msg then
    return
  end
  RedFortData.UpdateSurviveNum(msg.total)
end

function RedFortController.OnResRedFort(id, msg)
  RedFortData.UpdateData(msg.chiSeYaoSaiActivity)
end

function RedFortController.ApplyActivity(id, data)
  NetManager.Send(ActivityMessage.ReqSignChiSeYaoSaiActivity, nil)
end

function RedFortController.OnResSignActivity(id, data)
  UIManager.Hide(UIID.Activity_RedfortSignUI)
end

function RedFortController.OnResRemindEnter()
end

function RedFortController.ReqEnterActivity(id, msg)
  local mapData = {mapId = 101900101}
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
end

function RedFortController.InitActivity()
  EventManager.Dispatch(Event.RedFortEntered)
end

function RedFortController.OnResResult(id, msg)
  RedFortData.UpdateRankData(msg)
end

function RedFortController.SignChiSeActivity(id, msg)
end

function RedFortController.OnShowResult()
  UIManager.Show(UIID.Activity_RedfortRankUI, {knockOut = 0, rank = 100})
end

function RedFortController.OnMapChange(id, mapId)
  local isIn = mapId == 1019001
  if RedFortData.InRedFortActivity ~= isIn then
    if not isIn then
      EventManager.Dispatch(Event.RedFortQuit)
      RedFortData.activityState = ActivityStatusEnum.INIT
    end
    RedFortData.InActivity(isIn)
    RoleManager.me:RefreshRoleInfo()
  end
end

function RedFortController.RegisterEvents()
  this.eventContainer:Regist(Event.RedFortApply, this.ApplyActivity)
  this.eventContainer:Regist(Event.Scene_SceneDataChange, this.OnMapChange)
end

RedFortController.Init()

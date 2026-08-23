require("GameModel/GradData")
require("GameConst/GradEnum")
GradController = {}
local this = GradController

function GradController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  GradData.Init()
end

function GradController.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResUnionSystemInstance_BangHuiBoss, this.GradBossInfo)
  this.messageContainer:Regist(ActivityMessage.ResUnionBossKillBossActivityData, this.GradKillBossInfo)
  this.messageContainer:Regist(UserMessage.ResLogout, this.ResLogout)
end

function GradController.RegistEvent()
  this.eventContainer:Regist(Event.Role_ChangePos, this.GradUpdatePos)
end

function GradController.GradBossInfo(id, data)
  GradData.GradBossInfo(id, data)
  data.basic.basic = data.basic
  data.type = id
  TranScriptData.InTranscriptType = id
  TranScriptData.SetInTranscript(true)
  TranScriptData.InTranscriptData = data
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType then
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
    EventManager.Dispatch(Event.UpdateCopyInfo)
  else
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
  end
  EventManager.Dispatch(Event.UpdateCopyDataInfo)
end

function GradController.GradKillBossInfo(id, data)
  GradData.GradKillBossInfo(data)
end

function GradController.GradUpdatePos()
  if not TranScriptData.InTranscript then
    return
  end
  EventManager.Dispatch(Event.WarAlliance_BossUIUpdate)
end

function GradController.ResLogout()
end

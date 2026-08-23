TowerInstanceController = {}
require("GameModel/TowerData")
local this = TowerInstanceController

function TowerInstanceController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.messageContainer:Regist(MapMessage.ResPersonInstance_Tower, this.ResPersonInstance_PersonResource)
end

function TowerInstanceController.ResPersonInstance_PersonResource(id, msg)
  msg = msg.basic
  msg.type = id
  TranScriptData.InTranscriptData = msg
  TranScriptData.SetInTranscript(true)
  TranScriptData.InTranscriptType = id
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.TaskPanelType then
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
    EventManager.Dispatch(Event.UpdateCopyInfo)
  else
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TransPanelType)
  end
  EventManager.Dispatch(Event.UpdateCopyDataInfo)
  if msg.task and msg.task[1] and msg.task[1].id and msg.monsters and msg.monsters[1] and msg.task[1].id ~= msg.monsters[1].cid then
    TowerData.SetCurrentTaskId(msg.task[1].id)
  end
end

TowerInstanceController.Init()

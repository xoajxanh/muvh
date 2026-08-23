require("GameModel/Activity_IndexData")
require("GameConst/ActivityIndexEnum")
ActivityIndexController = {}
local this = ActivityIndexController

function ActivityIndexController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
end

function ActivityIndexController.RegistMessages()
  this.messageContainer:Regist(RoleMessage.ResActiveAndFind, this.ResActiveAndFind)
  this.messageContainer:Regist(RoleMessage.ResActive, this.ResActive)
  this.messageContainer:Regist(RoleMessage.ResFind, this.ResFind)
  this.messageContainer:Regist(RoleMessage.ResActiveValue, this.ResCurrentActiveValue)
  this.messageContainer:Regist(ActivityMessage.ResHuoLongLaiXiCount, this.ResHuoLongLaiXiCount)
end

function ActivityIndexController.ResActiveAndFind(id, msg)
  Activity_IndexData.InitData(msg)
end

function ActivityIndexController.ResActive(id, msg)
  Activity_IndexData.UpdateActiveInfo(msg)
end

function ActivityIndexController.ResFind(id, msg)
  Activity_IndexData.UpdateFindInfo(msg)
end

function ActivityIndexController.ResHuoLongLaiXiCount(id, msg)
  Activity_IndexData.Activity_activeTb(msg)
end

function ActivityIndexController.ResCurrentActiveValue(id, msg)
  Activity_IndexData.CurrentActiveValue(msg)
end

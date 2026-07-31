ServerDataRecordController = {}
require("GameModel/ServerDataRecordData")
local this = ServerDataRecordController

function ServerDataRecordController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
end

function ServerDataRecordController.RegistMessages()
  this.messageContainer:Regist(RoleMessage.ResClientData, this.ResClientData)
end

function ServerDataRecordController.ResClientData(_, msg)
  ServerDataRecordData.SaveData = msg
  ServerDataRecordData.InitFun()
end

this.Init()

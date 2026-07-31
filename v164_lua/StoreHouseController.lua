require("GameModel/StoreHouseData")
StoreHouseController = {}
local this = StoreHouseController

function StoreHouseController.Init()
  this.messageContainer = EventContainer(NetManager)
  StoreHouseController.RegistEvent()
end

function StoreHouseController.RegistEvent()
  this.messageContainer:Regist(BagMessage.ResStorageInfo, StoreHouseController.OnResStorageInfo)
  this.messageContainer:Regist(BagMessage.ResStorageUpdate, StoreHouseController.OnResStorageUpdate)
end

function StoreHouseController.OnResStorageInfo(_, data)
  StoreHouseData.gridCount = data.gridCount
  StoreHouseData.storageInfoTbl = data.items
end

function StoreHouseController.OnResStorageUpdate(_, data)
end

EquipRedemptionController = {}
require("GameModel/EquipRedemptionData")
local this = EquipRedemptionController

function EquipRedemptionController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
end

function EquipRedemptionController.RegistMessages()
  this.messageContainer:Regist(EquipRansomMessage.ResGetEquipRansomInfo, this.ResGetEquipRansomInfo)
end

function EquipRedemptionController.ResGetEquipRansomInfo(_, msg)
  EquipRedemptionData.InitData(msg)
end

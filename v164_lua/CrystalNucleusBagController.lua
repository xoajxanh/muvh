require("GameModel/CrystalNucleus/CrystalNucleusBagCellContainer")
require("GameModel/CrystalNucleus/CrystalNucleusBagManager")
require("GameModel/CrystalNucleus/CrystalNucleusBagItemData")
CrystalNucleusBagController = {}
local this = CrystalNucleusBagController

function CrystalNucleusBagController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function CrystalNucleusBagController.RegistEvent()
  this.messageContainer:Regist(BagMessage.ResBagChange, this.OnResCrystalNucleusBagChange)
end

function CrystalNucleusBagController.OnResCrystalNucleusBagChange(_id, _msg)
  CrystalNucleusBagManager:OnResBagChange(_msg)
end

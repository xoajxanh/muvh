require("GameModel/EquipEnchant/EnchantEquipConstant")
require("GameModel/EquipEnchant/EnchantEquipUtility")
EnchantEquipController = {}
local this = EnchantEquipController

function EnchantEquipController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function EnchantEquipController.RegistEvent()
  this.messageContainer:Regist(EquipMessage.ResAllEnchantInfo, this.ResAllEnchantInfo)
  this.messageContainer:Regist(EquipMessage.ResEnchantInfo, this.ResEnchantInfo)
  this.eventContainer:Regist(Event.Bag_ResBagChange, this.Bag_ResBagChange)
end

function EnchantEquipController.ResAllEnchantInfo(_id, _msg)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():ResAllEnchantInfo(_msg)
end

function EnchantEquipController.ResEnchantInfo(_id, _msg)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():ResEnchantInfo(_msg)
end

function EnchantEquipController.ReqEnchantUpgrade(_equipIndex)
  networkRequest.ReqEnchantUpgrade(_equipIndex)
end

function EnchantEquipController.ReqEnchantReplace(_equipIndex, _id)
  networkRequest.ReqEnchantReplace(_equipIndex, _id)
end

function EnchantEquipController:Bag_ResBagChange()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Enchant_upgrade
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Enchant_enchant
  })
end

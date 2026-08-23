require("GameModel/CrystalNucleus/CrystalNucleusManager")
require("GameModel/CrystalNucleus/CrystalNucleusPedestal")
require("GameModel/CrystalNucleus/CrystalNucleusPointBase")
require("GameModel/CrystalNucleus/FixedCrystalNucleusPoint")
require("GameModel/CrystalNucleus/CrystalNucleusConstant")
require("GameModel/CrystalNucleus/CrystalNucleusUtility")
CrystalNucleusPointController = {}
local this = CrystalNucleusPointController

function CrystalNucleusPointController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function CrystalNucleusPointController.RegistEvent()
  this.messageContainer:Regist(RoleMessage.ResCrystalNucleusInfo, this.ResCrystalNucleusInfo)
end

function CrystalNucleusPointController.ResCrystalNucleusInfo(_id, _msg)
  if _msg == nil then
    return
  end
  CrystalNucleusManager:RefreshCrystalNucleusInfo(_msg)
end

function CrystalNucleusPointController.ReqPutOnNucleus(_row, _col, _itemId)
  if _row == nil or _col == nil or _itemId == nil then
    return
  end
  networkRequest.ReqPutOnNucleus(_row, _col, _itemId)
end

function CrystalNucleusPointController.ReqTakeOffNucleus(_itemId, _takeOffAll)
  if _itemId == nil and _takeOffAll == nil then
    return
  end
  local itemIdTab = {}
  table.insert(itemIdTab, _itemId)
  networkRequest.ReqTakeOffNucleus(itemIdTab, _takeOffAll)
end

function CrystalNucleusPointController.ReqUnLockDisk()
  networkRequest.ReqUnLockDisk()
end

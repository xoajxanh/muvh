CrystalNucleusZhuanYiController = {}
local this = CrystalNucleusZhuanYiController

function CrystalNucleusZhuanYiController.Init()
  this.canChangeBagRefreshFunc = false
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function CrystalNucleusZhuanYiController.RegistEvent()
  this.messageContainer:Regist(RoleMessage.ResCrystalNucleusTransfer, this.OnResCrystalNucleusZhuanYiChange)
end

function CrystalNucleusZhuanYiController.OnResCrystalNucleusZhuanYiChange(_id, _msg)
  for i, v in ipairs(_msg.items) do
    CrystalNucleusBagManager:OnResBagItemChange(v)
  end
  EventManager.Dispatch(Event.CrystalNucleusTransferBagChange, nil)
end

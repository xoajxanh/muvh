AttributeController = {}
require("GameConst/AttributeEnum")
local this = AttributeController

function AttributeController.Init()
  this.messageContainer = EventContainer(NetManager)
  AttributeController.RegistMessages()
end

function AttributeController.RegistMessages()
  this.messageContainer:Regist(FightMessage.ResHpMpChange, this.ResChangeAttr)
end

function AttributeController.ResChangeAttr(eventId, data)
  if data.type == HPMPTypeEnum.HP then
    if data.reason == AttributeEnum.REFLECTION then
      HpController.ResHpReflectionChange(data)
    else
      HpController.ResHpChange(data)
    end
  elseif data.type == HPMPTypeEnum.MP then
    HpController.ResMpChange(data)
  elseif data.type == HPMPTypeEnum.SHIELD then
    HpController.ResShieldChange(data)
  elseif data.type == HPMPTypeEnum.COMBO then
    HpController.ResComboChange(data)
  end
end

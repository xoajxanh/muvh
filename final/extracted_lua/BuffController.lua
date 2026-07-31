require("GameModel/BuffData")
BuffController = {}
local this = BuffController

function BuffController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function BuffController.RegistEvent()
  this.messageContainer:Regist(BufferMessage.ResAddBuffer, this.ResAddBuffer)
  this.messageContainer:Regist(BufferMessage.ResRemoveBuffer, this.ResRemoveBuffer)
  this.messageContainer:Regist(BufferMessage.ResSwithBuffer, this.ResSwithBuffer)
  this.messageContainer:Regist(BufferMessage.ResBufferChange, this.ResBufferChange)
  this.messageContainer:Regist(BufferMessage.ResBufferChangeList, this.ResBufferChangeList)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.OnGamePlay_Back2Choose)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.OnGamePlay_Leave)
  this.eventContainer:Regist(Event.Role_ModelCreateFinished, this.OnRole_ModelCreateFinished)
end

function BuffController.ResAddBuffer(_, data)
  local buff_struct = BuffData.GenerateBuffStruct(data)
  BuffMgr.AddBuff(buff_struct)
  BuffMgr.RoleBuffAttributeCheck(buff_struct, true)
  EventManager.Dispatch(Event.SkillBuffChange)
end

function BuffController.ResRemoveBuffer(_, data)
  local buff_struct = {}
  buff_struct.buffId = data.buffId
  buff_struct.buffCId = data.buffCId
  buff_struct.removeType = data.removeType
  buff_struct.buffConfig = ClientTable.cfg_Buff_buffManager:TryGetValue(buff_struct.buffCId)
  if buff_struct.buffConfig and buff_struct.buffConfig.show ~= 0 then
    buff_struct.buffAction = ConfigManager.GetConfig("cfg_buffAction", buff_struct.buffConfig.show, "id")
  end
  buff_struct.buffOwnerId = data.beRemovedId
  if buff_struct.buffOwnerId then
    buff_struct.buffOwner = RoleManager.GetRoleById(buff_struct.buffOwnerId)
  end
  BuffMgr.RemoveBuff(buff_struct)
  BuffMgr.RoleBuffAttributeCheck(buff_struct, false)
  EffAnimatorController.RemoveBuffEffAni(buff_struct.buffOwnerId, buff_struct.buffCId)
  if buff_struct.buffConfig.subType == 220 and buff_struct.buffOwnerId == ViewData.meData.id then
    SkillMgr.RequestSkillTest(tonumber(buff_struct.buffConfig.buffParam))
  end
  EventManager.Dispatch(Event.SkillBuffChange)
end

function BuffController.ResSwithBuffer(id, data)
end

function BuffController.ResBufferChange(id, data)
  BuffMgr.ChangeBuff(data)
end

function BuffController.ResBufferChangeList(id, data)
  BuffMgr.ChangeAllBuff(data)
end

function BuffController.OnGamePlay_Back2Choose()
  if ViewData.meData then
    BuffMgr.RemoveAllBuffOwnerID(ViewData.meData.id)
  end
end

function BuffController.OnGamePlay_Leave()
  if ViewData.meData then
    BuffMgr.RemoveAllBuffOwnerID(ViewData.meData.id)
  end
end

function BuffController.OnRole_ModelCreateFinished(id)
  if ViewData.meData == nil then
    return
  end
end

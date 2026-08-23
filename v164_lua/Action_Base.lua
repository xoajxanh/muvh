Action_Base = class()
local MIN_ACTION_SPEED = 0.1

function Action_Base:Init(caster, actionData, speed)
  self.caster = caster
  self.actionData = actionData
  self.actionStatus = ESkillActionStatus.Waiting
  speed = speed or 1
  if speed <= 0 then
    speed = MIN_ACTION_SPEED
  end
  self.processSpeed = speed
  self.reversedProcessSpeed = 1 / self.processSpeed
  if actionData.synchronizationStart then
    self.startTime = Time.time + self.actionData.startTime * self.reversedProcessSpeed
  else
    self.startTime = Time.time + self.actionData.startTime
  end
  if actionData.synchronizationDuration then
    self.duration = self.actionData.duration * self.reversedProcessSpeed
  else
    self.duration = self.actionData.duration
  end
  self.endTime = self.startTime + self.duration
  self.processingTime = 0
  self:InitEvents()
  self:InitMessages()
end

function Action_Base:StartToProcess()
  self:OnStartProcess()
  self.actionStatus = ESkillActionStatus.Processing
end

function Action_Base:WaitToProcess()
  self:OnWaitToProcess()
  if Time.time >= self.startTime then
    self.actionStatus = ESkillActionStatus.Started
  end
end

function Action_Base:Processing()
  self.processingTime = self.processingTime + Time.deltaTime
  self:OnProcessing()
  if self.actionStatus == ESkillActionStatus.Processing and Time.time > self.endTime then
    self.actionStatus = ESkillActionStatus.Finish
  end
end

function Action_Base:Process()
  if self.actionStatus == ESkillActionStatus.Waiting then
    self:WaitToProcess()
  end
  if self.actionStatus == ESkillActionStatus.Started then
    self:StartToProcess()
  end
  if self.actionStatus == ESkillActionStatus.Processing then
    self:Processing()
  end
  if self.actionStatus == ESkillActionStatus.Finish then
    self:Finish()
  end
  if self.actionStatus == ESkillActionStatus.Interrupted then
    self:Interrupted()
  end
  if self.actionStatus == ESkillActionStatus.WaitDestroy then
    self:Destroy()
  end
  return self.actionStatus
end

function Action_Base:Finish()
  self:OnFinish()
  self.actionStatus = ESkillActionStatus.WaitDestroy
end

function Action_Base:Break()
  self:OnBreak()
  self.actionStatus = ESkillActionStatus.Interrupted
end

function Action_Base:Interrupted()
  self:OnInterrupted()
  self.actionStatus = ESkillActionStatus.WaitDestroy
end

function Action_Base:Destroy()
  self:OnDestroy()
  self.actionStatus = ESkillActionStatus.Destroyed
  self.eventContainer:UnRegistAll()
  self.eventContainer = nil
  self.messageContainer:UnRegistAll()
  self.messageContainer = nil
end

function Action_Base:InitEvents()
  self.eventContainer = EventContainer(EventManager)
  self.eventContainer:Regist(Event.Role_RoleDestroyed, self.OnRoleDestroyed, self)
  self.eventContainer:Regist(Event.Role_ChangePos, self.OnRoleClientPosChanged, self)
  self.eventContainer:Regist(Event.Role_PlayerChangePos, self.OnRoleClientPosChanged, self)
end

function Action_Base:InitMessages()
  self.messageContainer = EventContainer(NetManager)
  self.messageContainer:Regist(MapMessage.ResChangePos, self.OnRoleServerPosChanged, self, 2)
end

function Action_Base:OnRoleDestroyed(_, role)
  if self.caster == role then
    self:Break()
    self.caster = nil
  end
end

function Action_Base:OnRoleServerPosChanged(id, msg)
  if self.caster and self.caster.id == msg.lid then
    local reason = msg.reason
    if reason == ERoleChangePosReason.Transport or reason == ERoleChangePosReason.RandomTransport or reason == ERoleChangePosReason.Revive or reason == ERoleChangePosReason.MoveFailed or reason == ERoleChangePosReason.Scene_Interactive or reason == ERoleChangePosReason.Flash_Monster or reason == ERoleChangePosReason.Flash then
      self:Break()
    end
  end
end

function Action_Base:OnRoleClientPosChanged(_, id, reason, reasonParam)
  if self.caster and self.caster.id == id and (reason == ERoleChangePosReason.Transport or reason == ERoleChangePosReason.RandomTransport or reason == ERoleChangePosReason.Revive or reason == ERoleChangePosReason.MoveFailed or reason == ERoleChangePosReason.Scene_Interactive or reason == ERoleChangePosReason.Flash_Monster or reason == ERoleChangePosReason.Flash) then
    self:Break()
  end
end

function Action_Base:OnStartProcess()
end

function Action_Base:OnWaitToProcess()
end

function Action_Base:OnProcessing()
end

function Action_Base:OnFinish()
end

function Action_Base:OnBreak()
end

function Action_Base:OnInterrupted()
end

function Action_Base:OnDestroy()
end

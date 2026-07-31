SequenceSkillAnimationCounter = {}
local this = SequenceSkillAnimationCounter

function SequenceSkillAnimationCounter.Init()
  this.counterMap = {}
end

function SequenceSkillAnimationCounter.RegisterEvent()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Role_RoleDead, this.ResetRoleAnimSequence)
  this.eventContainer:Regist(Event.Role_RoleDestroyed, this.ResetRoleAnimSequence)
end

function SequenceSkillAnimationCounter.ResetRoleAnimSequence(_, role)
  this.counterMap[role.id] = nil
end

function SequenceSkillAnimationCounter.GetCounter(role, skillId, maxSequenceCount)
  local roleCounterMap = this.counterMap[role.id]
  if not roleCounterMap then
    this.counterMap[role.id] = {}
    roleCounterMap = this.counterMap[role.id]
  end
  local skillSeq = roleCounterMap[skillId]
  if not skillSeq then
    roleCounterMap[skillId] = 1
    return 1
  end
  roleCounterMap[skillId] = roleCounterMap[skillId] + 1
  if maxSequenceCount < roleCounterMap[skillId] then
    roleCounterMap[skillId] = 1
  end
  return roleCounterMap[skillId]
end

this.Init()

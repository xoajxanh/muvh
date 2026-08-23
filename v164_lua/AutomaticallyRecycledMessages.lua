local messageAutomaticallyRecycleTime = {
  [BagMessage.ResBagChange] = 0,
  [BagMessage.ResUseItem] = 0,
  [BufferMessage.ResAddBuffer] = 0,
  [BufferMessage.ResRemoveBuffer] = 0,
  [FightMessage.ResBroadcastUseSkill] = 0,
  [FightMessage.ResHpMpChange] = 0,
  [FightMessage.ResPlayerUseSkill] = 0,
  [FightMessage.ResUseSubSkill] = 0,
  [MapMessage.ResChangePos] = 0,
  [MapMessage.ResExitView] = 0,
  [MapMessage.ResItemEnterView] = 0,
  [MapMessage.ResMove] = 0,
  [MapMessage.ResPersonInstance_DemonSquare] = 0,
  [MapMessage.ResUpdateView] = 0,
  [RoleMessage.ResCDChanged] = 0,
  [RoleMessage.ResActorfight] = 0,
  [RoleMessage.ResPlayerExpChange] = 0,
  [RoleMessage.ResRoleAttributeChange] = 0,
  [TaskMessage.ResTasks] = 0,
  [TaskMessage.ResTask] = 0,
  [TipMessage.ResPrompt] = 0,
  [UserMessage.ResHeart] = 0
}

function GetMessageRecycleTime(id)
  return messageAutomaticallyRecycleTime[id]
end

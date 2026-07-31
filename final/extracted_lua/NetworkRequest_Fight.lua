function networkRequest.ReqPlayerUseSkill(skillId, targetId, x, y, position, attackerId)
  local reqTable = {}
  
  if skillId ~= nil then
    reqTable.skillId = skillId
  end
  if targetId ~= nil then
    reqTable.targetId = targetId
  end
  if x ~= nil then
    reqTable.x = x
  end
  if y ~= nil then
    reqTable.y = y
  end
  if position ~= nil then
    reqTable.position = position
  end
  if attackerId ~= nil then
    reqTable.attackerId = attackerId
  end
  NetManager.Send(FightMessage.ReqPlayerUseSkill, reqTable)
end

function networkRequest.ReqRelive(reliveType)
  local reqTable = {}
  if reliveType ~= nil then
    reqTable.reliveType = reliveType
  end
  NetManager.Send(FightMessage.ReqRelive, reqTable)
end

function networkRequest.ReqTerminationCastSkill(skillId)
  local reqTable = {}
  if skillId ~= nil then
    reqTable.skillId = skillId
  end
  NetManager.Send(FightMessage.ReqTerminationCastSkill, reqTable)
end

function networkRequest.ReqBroadcastUseSkill(skillId, targetId, x, y, position, attackerId)
  local reqTable = {}
  if skillId ~= nil then
    reqTable.skillId = skillId
  end
  if targetId ~= nil then
    reqTable.targetId = targetId
  end
  if x ~= nil then
    reqTable.x = x
  end
  if y ~= nil then
    reqTable.y = y
  end
  if position ~= nil then
    reqTable.position = position
  end
  if attackerId ~= nil then
    reqTable.attackerId = attackerId
  end
  NetManager.Send(FightMessage.ReqBroadcastUseSkill, reqTable)
end

function networkRequest.ReqDamageList(attackToRoleId)
  local reqTable = {}
  if attackToRoleId ~= nil then
    reqTable.attackToRoleId = attackToRoleId
  end
  NetManager.Send(FightMessage.ReqDamageList, reqTable)
end

function networkRequest.ReqPlayerAttribute()
  NetManager.Send(FightMessage.ReqPlayerAttribute)
end

function networkRequest.ReqCloseAttribute()
  NetManager.Send(FightMessage.ReqCloseAttribute)
end

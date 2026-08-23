function networkRequest.ReqAcceptTask(taskId)
  local reqTable = {}
  
  if taskId ~= nil then
    reqTable.taskId = taskId
  end
  NetManager.Send(TaskMessage.ReqAcceptTask, reqTable)
end

function networkRequest.ReqSubmitTask(taskId)
  local reqTable = {}
  if taskId ~= nil then
    reqTable.taskId = taskId
  end
  NetManager.Send(TaskMessage.ReqSubmitTask, reqTable)
end

function networkRequest.ReqGiveUpTask(taskId)
  local reqTable = {}
  if taskId ~= nil then
    reqTable.taskId = taskId
  end
  NetManager.Send(TaskMessage.ReqGiveUpTask, reqTable)
end

function networkRequest.ReqCompleteTask(taskId)
  local reqTable = {}
  if taskId ~= nil then
    reqTable.taskId = taskId
  end
  NetManager.Send(TaskMessage.ReqCompleteTask, reqTable)
end

function networkRequest.ReqUpdateGoal(type, id)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(TaskMessage.ReqUpdateGoal, reqTable)
end

function networkRequest.ReqAcceptUTask(taskId)
  local reqTable = {}
  if taskId ~= nil then
    reqTable.taskId = taskId
  end
  NetManager.Send(TaskMessage.ReqAcceptUTask, reqTable)
end

function networkRequest.ReqSubmitUTask(taskId, type)
  local reqTable = {}
  if taskId ~= nil then
    reqTable.taskId = taskId
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(TaskMessage.ReqSubmitUTask, reqTable)
end

function networkRequest.ReqFlushUTask()
  NetManager.Send(TaskMessage.ReqFlushUTask)
end

function networkRequest.ReqAssistUTask(rid, taskId)
  local reqTable = {}
  if rid ~= nil then
    reqTable.rid = rid
  end
  if taskId ~= nil then
    reqTable.taskId = taskId
  end
  NetManager.Send(TaskMessage.ReqAssistUTask, reqTable)
end

function networkRequest.ReqFlushTask()
  NetManager.Send(TaskMessage.ReqFlushTask)
end

function networkRequest.ReqBossBountyReward()
  NetManager.Send(TaskMessage.ReqBossBountyReward)
end

function networkRequest.ReqBossRewardInfo(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(TaskMessage.ReqBossRewardInfo, reqTable)
end

local CombineTaskData = {}
setmetatable(CombineTaskData, LuaClass.CommerceActivity)
CombineTaskData.taskInfoTable = {}

function CombineTaskData:InitData()
end

CombineTaskData.tblData = nil
CombineTaskData.completeTbl = {}
CombineTaskData.getTbl = {}
CombineTaskData.commerceId = 44002

function CombineTaskData:RefreshData(tblData)
  self.completeTbl = {}
  if tblData.goals then
    for i, v in pairs(tblData.goals) do
      self.completeTbl[v] = true
    end
  end
  self.getTbl = {}
  if tblData.getRewards then
    for i, v in pairs(tblData.getRewards) do
      self.getTbl[v] = true
    end
  end
  if tblData.commerceId then
    self.commerceId = tblData.commerceId
  end
end

function CombineTaskData:GetTaskList()
  self.taskInfoTable = {}
  for i, v in pairs(ClientTable.cfg_Commerce_CooperativeserviceTaskManager:GetDic()) do
    if ConditionManager.Check4D(v.condition) and self.commerceId == v.overviewId then
      local cfg = ClientTable.cfg_Task_goalManager:TryGetValue(v.goalId)
      if cfg then
        local state = 1
        if self.getTbl[v.id] then
          state = 0
        elseif self.completeTbl[v.id] then
          state = 2
        end
        local info = {
          taskCfg = cfg,
          status = state,
          sCfg = v
        }
        table.insert(self.taskInfoTable, info)
      end
    end
  end
  table.sort(self.taskInfoTable, function(a, b)
    if a.status ~= b.status then
      return a.status > b.status
    else
      return b.sCfg.id > a.sCfg.id
    end
  end)
  return self.taskInfoTable
end

function CombineTaskData:ReqServerInfo()
  networkRequest.ReqCooperativeServiceInfo()
end

function CombineTaskData:CheckRedPointState()
  for i, v in pairs(self.completeTbl) do
    if self.getTbl[i] ~= true then
      return true
    end
  end
  return false
end

function CombineTaskData:GetTask(taskId)
  if taskId then
    networkRequest.ReqCooperativeServiceReward(taskId)
  end
end

return CombineTaskData

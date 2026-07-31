TaskCondition = class(ConditionBase)
setgetters(TaskCondition, {})
TaskCondition.comparatorMap = {
  [1] = function(self)
    for i = 1, table.count(self.taskIDTab) do
      local task = TaskData.GetCompletedTasksCount(self.taskIDTab[i])
      if task ~= false then
        return true
      end
    end
    return false
  end,
  [2] = function(self)
    for i = 1, table.count(self.taskIDTab) do
      local task = TaskData.GetCompletedTasksCount(self.taskIDTab[i])
      local count = 0
      if #self.strTab >= 2 then
        count = self.strTab[2]
      end
      if task ~= false and count <= task.count then
        return true
      end
    end
    return false
  end,
  [3] = function(self)
    for i = 1, table.count(self.taskIDTab) do
      local task = TaskData.GetTaskById(self.taskIDTab[i])
      if task then
        return true
      end
    end
    return false
  end,
  [4] = function(self)
    local task = TaskData.GetMonsterPeriodicalTask()
    if task == nil then
      return false
    else
      return true
    end
  end,
  [7] = function(self)
    for i = 1, table.count(self.taskIDTab) do
      local task = TaskData.GetTaskById(self.taskIDTab[i])
      if task ~= nil and task:GetState() ~= nil and (task:GetState() == TaskStateType.Completed or task:GetState() == TaskStateType.Submitted) then
        return true
      end
    end
    return false
  end
}

function TaskCondition:InitParam(param)
  self.taskIDTab = {}
  if tonumber(param) then
    table.insert(self.taskIDTab, tonumber(param))
  elseif type(param) == "table" then
    self.taskIDTab = param
    self.strTab = param
  else
    self.strTab = string.split(param, "#")
    if string.contains(param, "|") then
      local tempTab = string.split(param, "|")
      for i = 1, table.count(tempTab) do
        table.insert(self.taskIDTab, tonumber(tempTab[i]))
      end
    end
  end
end

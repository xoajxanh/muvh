TaskGoalCondition = class(ConditionBase)
setgetters(TaskGoalCondition, {})
TaskGoalCondition.comparatorMap = {
  [1] = function(self)
    local task = TaskData.GetCompletedTasksCount(self.taskID)
    if task == false then
      if 0 == self.count then
        return true
      end
    elseif task.count == self.count then
      return true
    end
    return false
  end
}

function TaskGoalCondition:InitParam(param)
  if type(param) == "table" then
    self.taskID = tonumber(param[1])
    self.count = tonumber(param[2])
  else
    local strTab = string.split(param, "#")
    self.taskID = tonumber(strTab[1])
    self.count = tonumber(strTab[2])
  end
end

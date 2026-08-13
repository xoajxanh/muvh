GuideUtility = {}
local this = GuideUtility
GuideUtility.CreateObj = {}
GuideUtility.CreateNameObj = {}
GuideUtility.TaskObj = {}

function GuideUtility.AddCreatObj(uiName, obj, taskId)
  if this.CreateObj[uiName] == nil then
    this.CreateObj[uiName] = {}
  end
  if this.CreateObj[uiName][obj.gameObject.name] == nil then
    this.CreateObj[uiName][obj.gameObject.name] = {}
  end
  for k, v in pairs(this.CreateObj[uiName]) do
    for kk, vv in pairs(v) do
      if vv == obj then
        return
      end
    end
  end
  table.insert(this.CreateObj[uiName][obj.gameObject.name], obj)
  if taskId == nil then
    local msg = {
      name = uiName,
      objName = obj.gameObject.name,
      index = table.count(this.CreateObj[uiName][obj.gameObject.name])
    }
    EventManager.Dispatch(Event.AddCreatObj, msg)
  end
end

function GuideUtility.AddCreatNameObj(uiName, obj)
  if this.CreateNameObj[uiName] == nil then
    this.CreateNameObj[uiName] = {}
  end
  table.insert(this.CreateNameObj[uiName], obj)
  local msg = {
    name = uiName,
    objName = obj.gameObject.name,
    index = table.count(this.CreateNameObj[uiName])
  }
  EventManager.Dispatch(Event.AddCreatObj, msg)
end

function GuideUtility.AddCreatObjInTask(uiName, obj, taskId, index)
  if taskId ~= nil then
    local taskObj = {
      obj = obj,
      taskId = taskId,
      index = index
    }
    this.TaskObj[taskId] = taskObj
    for k, v in pairs(this.TaskObj) do
      if TaskData.AllTasks[v.taskId] ~= nil and TaskData.AllTasks[v.taskId]:GetState() ~= TaskStateType.Accept then
        this.TaskObj[k] = nil
      end
    end
  end
end

function GuideUtility.ClearAssignUIData(uiName)
  if this.CreateObj[uiName] ~= nil then
    this.CreateObj[uiName] = nil
  end
  if this.CreateNameObj[uiName] ~= nil then
    this.CreateNameObj[uiName] = nil
  end
end

function GuideUtility.ClearData()
  this.CreateObj = {}
  this.CreateNameObj = {}
  this.TaskObj = {}
end

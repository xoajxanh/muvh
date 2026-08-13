local FunctionDisableManager = {}
FunctionDisableManager._functionDisableList = nil

function FunctionDisableManager:RefreshFunctionDisableList(data)
  if data == nil or data.disableList == nil then
    return
  end
  self._functionDisableList = {}
  for k, v in pairs(data.disableList) do
    self._functionDisableList[v] = 1
  end
  EventManager.Dispatch(Event.ServerFunctionDisableChange)
end

function FunctionDisableManager:GetFunctionState(functionType)
  return self._functionDisableList == nil or self._functionDisableList[functionType] ~= 1
end

function FunctionDisableManager:Destroy()
  self._functionDisableList = nil
end

return FunctionDisableManager

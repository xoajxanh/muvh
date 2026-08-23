CSUnity = CS.UnityEngine
Global = {}

function Global.OnInit()
end

function Global.OnDestroy(...)
end

function Global.DeepCopy(object)
  local SearchTable = {}
  
  local function Func(object)
    if type(object) ~= "table" then
      return object
    end
    local NewTable = {}
    SearchTable[object] = NewTable
    for k, v in pairs(object) do
      NewTable[Func(k)] = Func(v)
    end
    return setmetatable(NewTable, getmetatable(object))
  end
  
  return Func(object)
end

function _G.Print(...)
  if not GLogSwitch.UnityEditor then
    return
  end
  local strs = table.pack(...)
  for i, v in ipairs(strs) do
    if type(v) == "table" then
      PrintDumpUtility.Dump(v)
    else
      print(v)
    end
  end
end

Global.OnInit()

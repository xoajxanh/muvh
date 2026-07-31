ServerAttributeCalculator = {}
local this = ServerAttributeCalculator

function ServerAttributeCalculator.CalcServerAttributes(attriMap, Servers)
  local attr = {}
  if Servers[EAttributeType.fight] then
    attriMap[EAttributeType.fight] = Servers[EAttributeType.fight]
  else
    attriMap[EAttributeType.fight] = 0
  end
  return attriMap
end

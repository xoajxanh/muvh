CareerCondition = class(ConditionBase)
setgetters(CareerCondition, {
  RoleUtility = function(self)
    return RoleUtility
  end,
  data = function(self)
    return ViewData.meData
  end
})
CareerCondition.comparatorMap = {
  [1] = function(self)
    for i = 1, table.count(self.career) do
      if self.RoleUtility.UpWardCompatibilty(self.data.career, self.career[i]) then
        return true
      end
    end
    return false
  end,
  [2] = function(self)
    return table.contains(self.career, self.data.career)
  end,
  [3] = function(self)
    for i = 1, table.count(self.career) do
      if self.RoleUtility.DownWardCompatibilty(self.data.career, self.career[i]) then
        return true
      end
    end
    return false
  end
}

function CareerCondition:InitParam(param)
  self.career = {}
  if tonumber(param) then
    table.insert(self.career, tonumber(param))
  elseif type(param) == "table" then
    self.career = param
  else
    local strTab = string.split(param, "#")
    for i = 1, table.count(strTab) do
      table.insert(self.career, tonumber(strTab[i]))
    end
  end
end

SkillLimitCondition = class(ConditionBase)
setgetters(SkillLimitCondition, {
  data = function(self)
    return RoleManager.me.data.equipsData.Data
  end
})
SkillLimitCondition.comparatorMap = {
  [1] = function(self)
    for _, v in pairs(self.data) do
      if v and table.contains(self.equipSubtype, v.tblItem.subType) then
        return true
      end
    end
    return false
  end
}

function SkillLimitCondition:InitParam(param)
  self.equipSubtype = {}
  if type(param) == "table" then
    self.equipSubtype = param
  else
    local strTab = string.split(param, "#")
    for i = 1, table.count(strTab) do
      table.insert(self.equipSubtype, tonumber(strTab[i]))
    end
  end
end

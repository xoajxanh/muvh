GuardCondition = class(ConditionBase)
setgetters(GuardCondition, {
  guardInfo = function(self)
    return gameMgr:GetAvatarManager():GetMainPlayer():GetGuardData():GetGuardInfoByType(self.calculateType)
  end
})
GuardCondition.comparatorMap = {
  [1] = function(self)
    if self.guardInfo and self.guardInfo.isEnable then
      return self.guardInfo.petLevel >= self.guardLevel
    else
      return false
    end
  end
}

function GuardCondition:InitParam(param)
  if type(param) ~= "number" then
    return
  end
  local cfg_equip_guard = ClientTable.cfg_Equip_guard_levelManager:TryGetValue(tonumber(param))
  self.calculateType = cfg_equip_guard.petType
  self.guardLevel = cfg_equip_guard.petLevel
end

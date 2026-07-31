local RoleCircleEffectManager = {}

function RoleCircleEffectManager:AllRoleCircleProcessorDic()
  if self.mAllRoleCircleProcessorDic == nil then
    self.mAllRoleCircleProcessorDic = {}
  end
  return self.mAllRoleCircleProcessorDic
end

function RoleCircleEffectManager:Init()
  self.doRefresh = true
  self.loader = LuaClass.RoleCircleEffectLoader:New()
  self.ruler = LuaClass.RoleCircleEffectShowRule:New()
  self.eventContainer = EventContainer(EventManager)
  self:BindEventMsg()
end

function RoleCircleEffectManager:BindEventMsg()
  self.eventContainer:Regist(Event.CallRefreshRoleCircleEffect, self.RefreshCircleEffectCallBack, self)
  self.eventContainer:Regist(Event.CallRemoveRoleCircleEffect, self.RemoveCircleEffectCallBack, self)
  self.eventContainer:Regist(Event.HolyRingWearChange, self.HolyRingWearChangeEffectCallBack, self)
end

function RoleCircleEffectManager:RefreshCircleEffectCallBack(id, msg)
  if msg == nil then
    return
  end
  local role = msg.rid and RoleManager.GetRoleById(msg.rid) or msg.role
  self:ShowCircleEffect(role)
end

function RoleCircleEffectManager:HolyRingWearChangeEffectCallBack(id, msg)
  if msg == nil then
    return
  end
  local role = msg.lid and RoleManager.GetRoleById(msg.lid) or msg.role
  self:ShowCircleEffect(role)
end

function RoleCircleEffectManager:RemoveCircleEffectCallBack(id, role)
  if role and role.transform then
    self:RemoveCircleEffect(role.transform:GetHashCode())
  end
end

function RoleCircleEffectManager:ShowCircleEffect(role, ShowedCallBack)
  if role == nil or role.data == nil or role.transform == nil then
    return
  end
  local type = self:GetShowCircleTypeByRoleData(role)
  self:ShowCircleEffectByType(role, type, ShowedCallBack)
end

function RoleCircleEffectManager:ShowCircleEffectByType(role, type, ShowedCallBack)
  local roleHashCode = role.transform:GetHashCode()
  local curProcessor = self:AllRoleCircleProcessorDic()[roleHashCode]
  if curProcessor then
    if curProcessor:GetType() == type then
      curProcessor:Refresh(ShowedCallBack)
      return
    else
      self:RemoveCircleEffect(roleHashCode)
    end
  end
  local processor = self:NewProcessorByType(type, role)
  if processor == nil then
    return
  end
  self:AllRoleCircleProcessorDic()[roleHashCode] = processor
  processor:Refresh(ShowedCallBack)
end

function RoleCircleEffectManager:HideCircleEffect(rid)
  self:RemoveCircleEffect(rid)
end

function RoleCircleEffectManager:RemoveCircleEffect(hashCode)
  if self:AllRoleCircleProcessorDic()[hashCode] == nil then
    return
  end
  self:AllRoleCircleProcessorDic()[hashCode]:RecycleAll()
  self:AllRoleCircleProcessorDic()[hashCode] = nil
end

function RoleCircleEffectManager:GetShowCircleTypeByRoleData(role)
  return self.ruler:GetEffectTypeByRule(role)
end

function RoleCircleEffectManager:NewProcessorByType(type, role)
  if type == ERoleCircleEffectType.Rein then
    return LuaClass.RoleReinCircleEffectProcessor:New(role)
  elseif type == ERoleCircleEffectType.HolyRing then
    return LuaClass.RoleHolyCircleEffectProcessor:New(role)
  elseif type == ERoleCircleEffectType.ViewRoleHolyRing then
    return LuaClass.ViewRoleHolyCircleEffectProcessor:New(role)
  end
end

function RoleCircleEffectManager:RemoveAll()
  for i, v in pairs(self:AllRoleCircleProcessorDic()) do
    self:RemoveCircleEffect(i)
  end
end

return RoleCircleEffectManager

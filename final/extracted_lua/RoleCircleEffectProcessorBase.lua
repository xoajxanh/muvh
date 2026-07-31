local RoleCircleEffectProcessorBase = {}

function RoleCircleEffectProcessorBase:GetCircleLoader()
  if gameMgr:GetRoleCircleEffectMgr() then
    return gameMgr:GetRoleCircleEffectMgr().loader
  end
  return nil
end

function RoleCircleEffectProcessorBase:GetRole()
  if self.role == nil and self.rid then
    self.role = RoleManager.GetRoleById(self.rid)
  end
  return self.role
end

function RoleCircleEffectProcessorBase:GetParent()
  if self:GetRole() ~= nil and self:GetRole().model ~= nil and self:GetRole().CircleAnchor ~= nil and not IsNil(self:GetRole().CircleAnchor.transform) then
    return self:GetRole().CircleAnchor.transform
  end
  return nil
end

function RoleCircleEffectProcessorBase:GetType()
  return ERoleCircleEffectType.None
end

function RoleCircleEffectProcessorBase:GetEffectObjTbl()
  if self.mEffectObjTbl == nil then
    self.mEffectObjTbl = {}
  end
  return self.mEffectObjTbl
end

function RoleCircleEffectProcessorBase:Init(role)
  self.role = role
  self.rid = role.id
  self.state = true
  
  function self.recycleCallBack()
    self:RecycleCallBack()
  end
  
  function self.loadedCallBack(obj, index)
    self:OnLoadedCallBack(obj, index)
  end
  
  self:InitParams()
end

function RoleCircleEffectProcessorBase:InitParams()
end

function RoleCircleEffectProcessorBase:Refresh(showedCallBack)
  self.refreshCallBack = showedCallBack
  self:TryRefresh()
end

function RoleCircleEffectProcessorBase:TryRefresh()
  self:RefrehData()
  self:ProcessLastData()
  self:ProcessLastCircle()
  self:LoadAll()
end

function RoleCircleEffectProcessorBase:RefrehData()
  self:ResetLoadEffectData()
  self:RefreshLoadEffectData()
end

function RoleCircleEffectProcessorBase:ResetLoadEffectData()
  self.state = true
  self.targetEffectCount = 0
  self.needLoadEffectDataTbl = {}
end

function RoleCircleEffectProcessorBase:RefreshLoadEffectData()
end

function RoleCircleEffectProcessorBase:ProcessLastData()
  if self.waitLoadEffectDataTbl == nil then
    self.waitLoadEffectDataTbl = {}
    return
  end
  local lastCount = table.count(self.waitLoadEffectDataTbl)
  local count = table.count(self.needLoadEffectDataTbl)
  for i = 1, lastCount do
    for i2 = count, 1, -1 do
      if self.needLoadEffectDataTbl[i2] == self.waitLoadEffectDataTbl[i] then
        table.remove(self.needLoadEffectDataTbl, i2)
        count = count - 1
        break
      elseif self.needLoadEffectDataTbl[i2].name == self.waitLoadEffectDataTbl[i].name then
        self.waitLoadEffectDataTbl[i] = self.needLoadEffectDataTbl[i2]
        table.remove(self.needLoadEffectDataTbl, i2)
        count = count - 1
        break
      end
    end
  end
end

function RoleCircleEffectProcessorBase:ProcessLastCircle()
  if self.needLoadEffectDataTbl == nil then
    return
  end
  local removeObjkey = {}
  local isMeet = false
  for i, v in pairs(self:GetEffectObjTbl()) do
    isMeet = false
    for i1 = table.count(self.needLoadEffectDataTbl), 1, -1 do
      if self.needLoadEffectDataTbl[i1].name == i then
        isMeet = true
        self:SetEffectObj(v, self.needLoadEffectDataTbl[i1])
        table.remove(self.needLoadEffectDataTbl, i1)
        break
      end
    end
    if not isMeet then
      table.insert(removeObjkey, i)
    end
  end
  for i, key in pairs(removeObjkey) do
    self:GetCircleLoader():Recycle(self:GetEffectObjTbl()[key], key, self.recycleCallBack)
    self:GetEffectObjTbl()[key] = nil
  end
end

function RoleCircleEffectProcessorBase:LoadAll()
  self.targetEffectCount = table.count(self.needLoadEffectDataTbl)
  if self.targetEffectCount == 0 then
    return
  end
  for i = 1, self.targetEffectCount do
    table.insert(self.waitLoadEffectDataTbl, self.needLoadEffectDataTbl[i])
    self:GetCircleLoader():Spawn(self.needLoadEffectDataTbl[i].name, self.loadedCallBack, i)
  end
end

function RoleCircleEffectProcessorBase:OnLoadedCallBack(obj, index)
  if obj == nil or IsNil(obj) then
    return
  end
  local param = self.waitLoadEffectDataTbl[index]
  if param == nil then
    self:GetCircleLoader():Recycle(obj, obj.transform.name)
    return
  end
  if not self.state then
    self:GetCircleLoader():Recycle(obj, param.name)
    return
  end
  self:SetEffectObjConfig(obj, param)
  self:SetEffectObj(obj, param)
  if index == self.targetEffectCount then
    if self.refreshCallBack then
      self.refreshCallBack()
    end
    self.waitLoadEffectDataTbl = {}
  end
  self:GetEffectObjTbl()[param.name] = obj
end

function RoleCircleEffectProcessorBase:SetEffectObjConfig(obj)
  if self:GetRole() then
    obj:SetLayer(self:GetRole():GetModelLayer())
  end
  if self:GetParent() == nil then
    return
  end
  obj.transform:SetParent(self:GetParent())
  obj.transform.localPosition = self:GetRole() and self:GetRole().data and self:GetRole().data.circlePos ~= nil and self:GetRole().data.circlePos or self:GetCircleLoader():GetDefaultPosition()
  obj.transform.localEulerAngles = self:GetRole() and self:GetRole().data and self:GetRole().data.circleRotation and self:GetRole().data.circleRotation or self:GetCircleLoader():GetDefaultPosition()
  obj.transform.localScale = self:GetRole() and self:GetRole().data and self:GetRole().data.circleScale and self:GetRole().data.circleScale or self:GetCircleLoader():GetDefaultScale()
end

function RoleCircleEffectProcessorBase:SetEffectObj(obj, param)
end

function RoleCircleEffectProcessorBase:RecycleCallBack()
end

function RoleCircleEffectProcessorBase:RecycleAll()
  self.state = false
  for i, v in pairs(self:GetEffectObjTbl()) do
    self:GetCircleLoader():Recycle(v, i, self.recycleCallBack)
  end
  self.mEffectObjTbl = nil
end

function RoleCircleEffectProcessorBase:Destroy()
  self:RecycleAll()
end

return RoleCircleEffectProcessorBase

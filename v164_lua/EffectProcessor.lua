local EffectProcessor = {}
EffectProcessor.EffectObjectTemplate = nil
EffectProcessor.EffectObjList = nil
EffectProcessor.FreeEffectObjList = nil

function EffectProcessor:Initializer(effectObjectTemplate)
  self.EffectObjectTemplate = effectObjectTemplate
end

function EffectProcessor:AddEffects(datas, rootObj, refreshCallBack, callBackParams)
  if type(datas) ~= "table" then
    return
  end
  self:ResetAddNum()
  local curLids = {}
  for k, v in pairs(datas) do
    local lid = self:InstantiationEffect(v, rootObj, refreshCallBack, callBackParams, true)
    if lid ~= nil then
      table.insert(curLids, lid)
    end
  end
  return curLids
end

function EffectProcessor:InstantiationEffect(data, rootObj, refreshCallBack, callBackParams, unResetAddNum)
  if self.EffectObjectTemplate == nil then
    return
  end
  if self.EffectObjList == nil then
    self.EffectObjList = {}
  end
  if not unResetAddNum then
    self:ResetAddNum()
  end
  local sceneEffectObj, lid
  if type(data) == "table" then
    lid = data.lid
  end
  if lid == nil then
    lid = self:GetCustomLid()
  end
  if self.EffectObjList[lid] ~= nil then
    sceneEffectObj = self.EffectObjList[lid]
  end
  if sceneEffectObj == nil and type(self.FreeEffectObjList) == "table" then
    local nextId = next(self.FreeEffectObjList)
    if nextId then
      sceneEffectObj = self.FreeEffectObjList[nextId]
      self.FreeEffectObjList[nextId] = nil
    end
  end
  if sceneEffectObj == nil then
    sceneEffectObj = self.EffectObjectTemplate:New()
  end
  self.EffectObjList[lid] = sceneEffectObj
  sceneEffectObj:RefreshModel(data, rootObj, lid, self, refreshCallBack, callBackParams)
  if string.isNullOrEmpty(sceneEffectObj:GetEffectPath()) then
    self:RemoveEffect(lid)
    return
  end
  return lid
end

function EffectProcessor:RemoveEffects(lids)
  if type(lids) ~= "table" then
    return
  end
  for k, v in pairs(lids) do
    self:RemoveEffect(v)
  end
end

function EffectProcessor:RemoveEffect(lid)
  if type(self.EffectObjList) ~= "table" or self.EffectObjList[lid] == nil then
    return
  end
  local effectObj = self.EffectObjList[lid]
  effectObj:Hide()
  self.EffectObjList[lid] = nil
  if self.FreeEffectObjList == nil then
    self.FreeEffectObjList = {}
  end
  table.insert(self.FreeEffectObjList, effectObj)
end

function EffectProcessor:Destroy()
  if type(self.EffectObjList) == "table" then
    local removeIdList = {}
    for k, v in pairs(self.EffectObjList) do
      table.insert(removeIdList, v.EffectData.Lid)
    end
    for k, v in pairs(removeIdList) do
      self:RemoveEffect(v)
    end
  end
end

function EffectProcessor:GetEffectObject(lid)
  if self.EffectObjList == nil then
    return
  end
  return self.EffectObjList[lid]
end

function EffectProcessor:GetCustomLid()
  return self:GetIncreaseTime()
end

function EffectProcessor:GetIncreaseTime()
  if self.addNum == nil then
    self.addNum = 0
  end
  if self.addNum > 1000000000 then
    self.addNum = 0
  end
  self.addNum = self.addNum + 1
  return self.addNum
end

function EffectProcessor:ResetAddNum()
end

return EffectProcessor

local EffectObject = {}
EffectObject.Processor = nil
EffectObject.Lid = nil
EffectObject.ModelGreater = nil
EffectObject.EffectData = nil
EffectObject.RootObj = nil
EffectObject.EffectObj = nil

function EffectObject:RefreshModel(data, rootObj, lid, processor, refreshCallBack, callBackParams)
  if data == nil or IsNil(rootObj) then
    return
  end
  self.Processor = processor
  self.Lid = lid
  self.EffectData = data
  self.RootObj = rootObj
  self.refreshCallBack = refreshCallBack
  self.callBackParams = callBackParams
  self:Refresh(data)
  self:ControlShowState(true)
  self:TryCreateModelGreater()
  self:LoadEffectModel()
end

function EffectObject:TryCreateModelGreater()
  if self.ModelGreater == nil then
    self.ModelGreater = CS.Framework.GameModel(self:GetEffectName(), self.RootObj, function(effectObj, name)
      self:EffectLoadCallBack(effectObj, name)
    end)
  else
    self.ModelGreater.gameObject.name = self:GetEffectName()
  end
end

function EffectObject:LoadEffectModel()
  local effectPath = self:GetEffectPath()
  if string.isNullOrEmpty(effectPath) then
    return
  end
  if self:IsSameEffect(effectPath) then
    self:EffectLoadCallBack(self.ModelGreater.modelObject)
    return
  end
  self.ModelGreater:LoadAsync(effectPath)
end

function EffectObject:Hide()
  self:ControlShowState(false)
  self.ModelGreater.transform:SetParent(SkillMgr.ROOT)
end

function EffectObject:EffectLoadCallBack(effectObj, name)
  self.EffectObj = effectObj
  if IsNil(effectObj) then
    return
  end
  if self.ModelGreater then
    self.ModelGreater.transform:SetParent(self.RootObj)
  end
  if self:GetEffectPosition() ~= nil then
    self.ModelGreater.transform.localPosition = self:GetEffectPosition()
  end
  if self:GetEffectRotation() ~= nil then
    self.ModelGreater.transform.localEulerAngles = self:GetEffectRotation()
  end
  if self:GetEffectScale() ~= nil then
    self.ModelGreater.transform.localScale = self:GetEffectScale()
  end
  self:RefreshAllLayer(effectObj)
  if self.refreshCallBack ~= nil then
    self.refreshCallBack(self.callBackParams, self)
  end
end

function EffectObject:RefreshAllLayer(effectObj)
  if effectObj.gameObject.layer == self:GetLayer() then
    return
  end
  for k, v in pairs(effectObj.transform) do
    self:RefreshAllLayer(v)
    v.gameObject.layer = self:GetLayer()
  end
end

function EffectObject:GetEffectName()
end

function EffectObject:GetEffectPath()
end

function EffectObject:Refresh(data)
end

function EffectObject:GetEffectPosition()
end

function EffectObject:GetEffectRotation()
end

function EffectObject:GetEffectScale()
end

function EffectObject:GetLayer()
  return 0
end

function EffectObject:ControlShowState(state)
  if type(state) ~= "boolean" then
    return
  end
  if self.ModelGreater ~= nil and IsNil(self.ModelGreater.gameObject) == false then
    self.ModelGreater.gameObject:SetActive(state)
  end
end

function EffectObject:IsSameEffect(effectPath)
  if self.ModelGreater == nil then
    return false
  end
  return self.ModelGreater.Path == effectPath
end

return EffectObject

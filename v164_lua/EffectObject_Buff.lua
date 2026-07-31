local EffectObject_Buff = {}
setmetatable(EffectObject_Buff, LuaClass.EffectObject)

function EffectObject_Buff:GetEffectName()
  return self.effectName
end

function EffectObject_Buff:GetEffectPath()
  return self.effectPath
end

function EffectObject_Buff:Refresh(data)
  if data == nil then
    return
  end
  self.effectPath = data.prefab
  if self:IsSameEffect(self.effectPath) then
    return
  end
  local effectPathList = string.split(self.effectPath, "/")
  local effectNameList = string.split(effectPathList[#effectPathList], ".")
  self.effectName = effectNameList[1]
  self.position = data.panelOffset
  self.rotation = Vector3.zero
  self.scale = data.panelScale
end

function EffectObject_Buff:GetEffectPosition()
  return self.position
end

function EffectObject_Buff:GetEffectRotation()
  return self.rotation
end

function EffectObject_Buff:GetEffectScale()
  return self.scale
end

function EffectObject_Buff:GetLayer()
  return 5
end

return EffectObject_Buff

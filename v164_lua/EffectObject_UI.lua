local EffectObject_UI = {}
setmetatable(EffectObject_UI, LuaClass.EffectObject)

function EffectObject_UI:GetEffectName()
  if self.effectData == nil then
    return ""
  end
  return self.effectData.tbl.name
end

function EffectObject_UI:GetEffectPath()
  if self.effectData == nil then
    return ""
  end
  return self.effectData.prefabPath
end

function EffectObject_UI:Refresh(data)
  if type(data) ~= "table" or data.id == nil then
    return
  end
  self.position = Vector3.zero
  if data.position ~= nil then
    self.position = data.position
  end
  self.effectData = ClientTable.cfg_EffectsManager:TryGetComplexData(data.id)
  if self.effectData == nil then
    return
  end
  self:TimeEndDestroy()
  if self:IsSameEffect(self.effectData.prefabPath) then
    return
  end
end

function EffectObject_UI:GetEffectPosition()
  return self.position
end

function EffectObject_UI:GetEffectRotation()
  if self.effectData.Rotation ~= nil then
    return self.effectData.Rotation
  end
end

function EffectObject_UI:GetEffectScale()
  if self.effectData.Scale ~= nil then
    return self.effectData.Scale
  end
end

function EffectObject_UI:GetLayer()
  return 5
end

function EffectObject_UI:Hide()
  self:ResetTimer()
  self:RunBaseFunction("Hide")
end

function EffectObject_UI:TimeEndDestroy()
  if type(self.effectData.tbl.effectTime) ~= "number" or self.effectData.tbl.effectTime <= 0 then
    return
  end
  self:ResetTimer()
  self.autoDestroy = Timer.Start(self.effectData.tbl.effectTime * 0.001, self.NoticeDestroy, self)
end

function EffectObject_UI:ResetTimer()
  if self.autoDestroy == nil then
    return
  end
  Timer.Stop(self.autoDestroy)
  self.autoDestroy = nil
end

function EffectObject_UI:NoticeDestroy()
  self.Processor:RemoveEffect(self.Lid)
end

return EffectObject_UI

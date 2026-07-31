local EffectActionUtility = {}
EffectActionUtility.SequenceList = nil

function EffectActionUtility:GetEffectProcessor(type)
  return gameMgr:GetEffectManager():GetProcessor(type)
end

function EffectActionUtility:EffectFlyToObject(lid, type, target, time, endFunction)
  if lid == nil or type == nil or IsNil(target) then
    return
  end
  local processor = self:GetEffectProcessor(type)
  if processor == nil then
    return
  end
  local effectObj = processor:GetEffectObject(lid)
  if effectObj == nil then
    return
  end
  local sequence = DOTween.Sequence():Append(effectObj.ModelGreater.transform:DOMove(target.position, time))
  if endFunction ~= nil then
    sequence:Append(endFunction)
  end
end

return EffectActionUtility

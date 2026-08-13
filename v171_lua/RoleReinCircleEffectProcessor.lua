local RoleReinCircleEffectProcessor = {}
setmetatable(RoleReinCircleEffectProcessor, LuaClass.RoleCircleEffectProcessorBase)

function RoleReinCircleEffectProcessor:GetParent()
  if self:GetRole() ~= nil and self:GetRole().model ~= nil and not IsNil(self:GetRole().model.transform) then
    return self:GetRole().model.transform
  end
  return nil
end

function RoleReinCircleEffectProcessor:GetType()
  return ERoleCircleEffectType.Rein
end

function RoleReinCircleEffectProcessor:InitParams()
  self.reinEffectNamePR = "Eff_Rein0"
end

function RoleReinCircleEffectProcessor:RefreshLoadEffectData()
  if self:GetRole() == nil then
    return
  end
  local reinLevel = self:GetRole():GetRoleLevelRein()
  if 0 < reinLevel then
    table.insert(self.needLoadEffectDataTbl, {
      name = self.reinEffectNamePR .. reinLevel
    })
  end
end

return RoleReinCircleEffectProcessor

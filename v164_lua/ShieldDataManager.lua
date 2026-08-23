local ShieldDataManager = {}

function ShieldDataManager:Init()
  self:InitParam()
  self:BindEventMsg()
end

function ShieldDataManager:InitParam()
  self.lastAngelValue = 0
  self.curType = 0
  self.shieldRatio = 1000
end

function ShieldDataManager:BindEventMsg()
end

function ShieldDataManager:RefreshAngelData(data)
  if data == nil then
    return
  end
  self:SetShieldData(ERoleShieldType.AngelShield, data)
end

function ShieldDataManager:RefreshUniversalData(data)
  if data == nil then
    return
  end
  self:SetShieldData(data.type, data)
end

function ShieldDataManager:SetShieldData(_type, data)
  if self.universalShield == nil then
    self.universalShield = {}
  end
  if self.universalShield[_type] == nil then
    self.universalShield[_type] = {}
  end
  local curValue = _type == ERoleShieldType.AngelShield and data.archangelShield or data.shieldValue
  local curMaxValue = _type == ERoleShieldType.AngelShield and data.maxArchangelShield or data.shieldMaxValue
  if self.universalShield[_type].value == curValue and self.universalShield[_type].maxValue == curMaxValue then
    return
  end
  self.universalShield[_type].value = curValue
  self.universalShield[_type].maxValue = curMaxValue
  if self.universalLastShield == nil then
    self.universalLastShield = {}
  end
  local lastValue = self.universalLastShield[_type]
  if lastValue == nil or lastValue <= 0 or lastValue - curValue >= curValue / self.shieldRatio then
    self.universalLastShield[_type] = curValue
    EventManager.Dispatch(Event.Role_RefreshUniversalShield, {
      rid = data.roleId,
      type = _type
    })
  end
end

function ShieldDataManager:GetShieldData()
  if self.universalShield == nil then
    return nil
  end
  for i, v in pairs(ERoleShieldType) do
    if self.universalShield[v] and self.universalShield[v].value > 0 then
      return self.universalShield[v], v
    end
  end
  return nil, nil
end

function ShieldDataManager:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

return ShieldDataManager

LookEnemyCircleEffect = class(EffectNew)

function LookEnemyCircleEffect:ctor(color)
  local effectData = {
    modelType = EEffectModelType.Scene,
    model = color == "yellow" and "Eff_quan_huang" or "Eff_quan_hong"
  }
  self.color = color
  EffectNew.ctor(self, effectData)
end

function LookEnemyCircleEffect:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject(self:GetName())
  self.transform = self.gameObject.transform
  self.transform:SetParent(RoleManager.me.model.BuffAnchor)
end

function LookEnemyCircleEffect:GetName()
  return "V\195\178ng s\195\161ng t\195\172m \196\145\225\187\139ch"
end

function LookEnemyCircleEffect:SetModel()
  local radius = 0.08 * tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390014)) / 2 + 0.07
  self.model:SetModel(radius)
end

function LookEnemyCircleEffect:SetActive(state)
  self.model:SetModelActive(state)
end

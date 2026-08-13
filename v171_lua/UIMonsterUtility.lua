UIMonsterUtility = class()

function UIMonsterUtility:ctor(configId, parent, scale, position, rotate)
  self.configId = configId
  self.parent = parent
  self.scale = scale
  self.position = position
  self.rotate = rotate
  self.curShowMonster = nil
  self:InitGameObject()
  self:InitModel(configId)
end

function UIMonsterUtility:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject("monster")
  self.transform = self.gameObject.transform
  self.transform:SetParent(self.parent.transform)
end

function UIMonsterUtility:DestroyGameObject()
  if self.curShowMonster == nil then
    return
  end
  self.curShowMonster:Destroy()
  CS.Framework.ObjectEx.Destroy(self.gameObject)
  self.gameObject = nil
  self.transform = nil
  self.configId = nil
  self.parent = nil
  self.scale = nil
  self.position = nil
  self.curShowMonster = nil
end

function UIMonsterUtility:InitModel(configId)
  self.monsterBossTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(tonumber(configId), "id")
  if self.monsterBossTbl == nil then
    logError("Kh\195\180ng c\195\179 ID trong b\225\186\163ng cfg_Monster_monster:" .. configId .. "D\225\187\175 li\225\187\135u c\225\187\167a!!!")
    return
  end
  self.curShowMonster = CS.Framework.GameModel(self.monsterBossTbl.name, self.transform, function(go, name)
    self:OnLoadAcceptableModer(go, name)
  end)
  local path = string.format("Model/Monster/%s.prefab", self.monsterBossTbl.model)
  self.curShowMonster:LoadAsync(path)
end

function UIMonsterUtility:OnLoadAcceptableModer(go, name)
  if not self.curShowMonster then
    return
  end
  if self.curShowMonster then
    self:InitLocalPosition()
    self:InitLocalScale()
    self:InitLocalRotate()
    self:SetLayout(UI_LAYER)
  end
end

function UIMonsterUtility:SetParent(parent)
  self.transform:SetParent(parent.transform)
end

function UIMonsterUtility:SetLayout(layout)
  if self.curShowMonster == nil then
    return
  end
  self.gameObject:SetLayer(UI_LAYER)
  self.curShowMonster.gameObject.layer = UI_LAYER
  self.curShowMonster.transform:GetChild(0).gameObject.layer = UI_LAYER
  local skinMeshes = self.curShowMonster.transform:GetChild(0):GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  if skinMeshes then
    for i = 0, skinMeshes.Length - 1 do
      local smr = skinMeshes[i]
      smr.gameObject.layer = UI_LAYER
    end
  end
end

function UIMonsterUtility:InitLocalPosition()
  if self.curShowMonster ~= nil and self.curShowMonster then
    self.transform.localPosition = Vector3(self.position.x, self.position.y, self.position.z)
  end
end

function UIMonsterUtility:SetLocalPosition(position)
  if self.curShowMonster ~= nil and self.curShowMonster and position ~= nil then
    self.transform.localPosition = Vector3(position.x, position.y, position.z)
  end
end

function UIMonsterUtility:InitPosition()
  if self.curShowMonster ~= nil and self.curShowMonster then
    self.transform.position = Vector3(self.position.x, self.position.y, self.position.z)
  end
end

function UIMonsterUtility:SetPosition(position)
  if self.curShowMonster ~= nil and self.curShowMonster and position ~= nil then
    self.transform.position = Vector3(position.x, position.y, position.z)
  end
end

function UIMonsterUtility:InitLocalScale()
  if self.curShowMonster ~= nil and self.curShowMonster then
    self.transform.localScale = Vector3(self.scale.x, self.scale.y, self.scale.z)
  end
end

function UIMonsterUtility:SetLocalScale(scale)
  if self.curShowMonster ~= nil and self.curShowMonster and scale ~= nil then
    self.transform.localScale = Vector3(scale.x, scale.y, scale.z)
  end
end

function UIMonsterUtility:InitLocalRotate()
  if self.curShowMonster ~= nil and self.curShowMonster then
    self.transform.localEulerAngles = Vector3(self.rotate.x, self.rotate.y, self.rotate.z)
  end
end

function UIMonsterUtility:SetLocalRotate(rotate)
  if self.curShowMonster ~= nil and self.curShowMonster and rotate ~= nil then
    self.transform.localEulerAngles = Vector3(rotate.x, rotate.y, rotate.z)
  end
end

function UIMonsterUtility:SetActive()
  if self.curShowMonster ~= nil and self.curShowMonster then
    self.gameObject:SetActive(true)
  end
end

function UIMonsterUtility:SetHide()
  if self.curShowMonster ~= nil and self.curShowMonster then
    self.gameObject:SetActive(false)
  end
end

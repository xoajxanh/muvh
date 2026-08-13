DropItem = class()
DropItem.isDropItem = true
setgetters(DropItem, {
  id = function(self)
    return self.data.id
  end,
  itemId = function(self)
    return self.data.configID
  end,
  serverCoord = function(self)
    return self.data.serverCoord
  end,
  x = function(self)
    return self.data.serverCoord.x
  end,
  y = function(self)
    return self.data.serverCoord.y
  end,
  count = function(self)
    return self.data.item.count
  end
})
local mathLerp = Mathf.Lerp

function DropItem:ctor(data)
  self.middlePos = Vector3.zero
  self.startPos = Vector3.zero
  self.targetPos = Vector3.zero
  self.pos = Vector3(0, 0, 0)
  self:InitData()
  self:SetMove(false)
  self:InitAttribute(data)
  self:SetFinalRotAndPos()
  self:InitGameObject()
  self:InitPosition()
  self:InitScale()
  self:InitModel()
  self:InitRotation()
  self:InitUpDropEffect()
  self:InitStarDropEffect()
end

function DropItem:InitAttribute(data)
  self.data = data
  self.stopTime = 0
  self.passPercent = 1
  self.nextPassPercent = 1
end

function DropItem:Update()
  self:UpdateDropItemPos()
  if self.data ~= nil and self.data.id ~= nil and ViewData ~= nil and ViewData.GetGameObjectInViewById(self.data.id) == nil and self.GameObject_OnGameObjectLeaveView == nil then
    self.GameObject_OnGameObjectLeaveView = true
    EventManager.Dispatch(Event.GameObject_OnGameObjectLeaveView, self.data)
  end
end

function DropItem:InitData()
  self.isModelComplete = false
end

function DropItem:Destroy()
  self:DestroyModel()
  self:DestroyGameObject()
  self:DestroyUI()
  self:DestroyEffect()
end

function DropItem:SetMove(moving)
  self.moving = moving
end

function DropItem:StopMove()
  self:SetMove(false)
  if self.upEffectModel then
    self.upEffectModel:SetModelActive(true)
  end
  self.starEffectModel:SetModelActive(true)
end

function DropItem:SetDropItemPos(finalCell)
  self.jumpHeight = DropItemUtility.jumpHeight
  self.jumpSpeed = DropItemUtility.jumpSpeed
  self:SetBezierPos(finalCell, finalCell)
  self:SetMove(true)
  if self.upEffectModel then
    self.upEffectModel:SetModelActive(false)
  end
  self.starEffectModel:SetModelActive(false)
end

function DropItem:SetBezierPos(startCell, finalCell)
  self.passPercent = 0
  self.nextPassPercent = 0
  Scene.GetPosByCellNoGC(startCell, self.startPos)
  Scene.GetPosByCellNoGC(finalCell, self.targetPos)
  self.middlePos:Set((self.targetPos.x + self.startPos.x) / 2, self.startPos.y + self.jumpHeight, (self.targetPos.z + self.startPos.z) / 2)
end

function DropItem:GetTwoBezierPos(t)
  local t1 = (1 - t) * (1 - t)
  local t2 = 2 * t * (1 - t)
  local t3 = t * t
  local posX = self.startPos.x * t1 + self.middlePos.x * t2 + self.targetPos.x * t3
  local posY = self.startPos.y * t1 + self.middlePos.y * t2 + self.targetPos.y * t3
  local posZ = self.startPos.z * t1 + self.middlePos.z * t2 + self.targetPos.z * t3
  return posX, posY, posZ
end

function DropItem:UpdateDropItemPos()
  if self.moving == false or self.isModelComplete == false then
    return
  end
  if self.passPercent ~= 1 then
    self.passPercent = mathLerp(self.passPercent, 1, self.jumpSpeed * Time.deltaTime / (1 - self.passPercent))
    self.pos:Set(self:GetTwoBezierPos(self.passPercent))
    self:SetPosition(self.pos.x, self.pos.y, self.pos.z)
    self:SetDropItemRotation(-self.passPercent * DropItemUtility.rotateAngle, 0, 0)
  end
  if self.passPercent == 1 then
    self:StopMove()
    self.stopTime = Time.GetServerTime()
  end
end

function DropItem:GetParent()
  local this = DropItem
  if not this.dropItemAnchor then
    this.dropItemAnchor = CS.UnityEngine.GameObject("DropItemRoot").transform
    this.dropItemAnchor:SetParent(DropItemManager.root)
  end
  return this.dropItemAnchor
end

function DropItem:GetName()
  return self.data.name
end

function DropItem:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject(self:GetName())
  self.transform = self.gameObject.transform
  self.transform:SetParent(self:GetParent())
end

function DropItem:InitScale()
  self.scale = Vector3(1, 1, 1)
end

function DropItem:SetScale(x, y, z)
  self.scale:Set(x, y, z)
  self.transform.localScale = Vector3(x, y, z)
end

function DropItem:GetScale()
  return self.scale
end

function DropItem:DestroyGameObject()
  CS.Framework.ObjectEx.Destroy(self.gameObject)
  self.gameObject = nil
  self.transform = nil
end

function DropItem:GetModelLayer()
  return ROLE_LAYER
end

function DropItem:InitModel()
  self.model = DropItemModel(self.transform, nil, self.data)
  self.model.OnLoadModel = bind(self, self.OnLoadItemModelComplete)
  self.model:SetLayer(self:GetModelLayer())
  self.model:Init()
  self:SetModel()
end

function DropItem:GetModelScale()
  return self.data.scale
end

function DropItem:SetModel()
  self.model:SetModel(self:GetModelScale())
end

function DropItem:SetItemModelPosition(x, y, z)
  if not self.model then
    return
  end
  y = self.offsetPosY and self.offsetPosY or y
  local spMapHeightStr = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(6030101)
  local spMapHeight = string.split(spMapHeightStr, "#")
  for i = 1, #spMapHeight / 2 do
    if SceneData.mapId == tonumber(spMapHeight[i]) then
      y = y + spMapHeight[i + 1]
      break
    end
  end
  self.model:SetPosition(x, y, z)
end

function DropItem:OnLoadItemModelComplete(go, name)
  if self.data.modelType == EModelType.EquipItem or self.data.modelType == EModelType.InstanceItem then
    local skinned = go.transform:GetComponentInChildren(typeof(UnityEngineLua.SkinnedMeshRenderer))
    skinned = skinned or go.transform:GetComponentInChildren(typeof(UnityEngineLua.MeshRenderer))
    local center = skinned.bounds.center
    local extents = skinned.bounds.extents
    local itemPos = self:GetPosition()
    local modelPosX = itemPos.x - center.x
    local modelPosY = itemPos.y - center.y + extents.y
    local modelPosZ = itemPos.z - center.z
    self:SetItemModelPosition(modelPosX, modelPosY, modelPosZ)
  else
    local pos = self.model:GetPosition()
    self:SetItemModelPosition(pos.x, pos.y, pos.z)
  end
  if ItemUtility.IsEquipType(self.data.config_Item.type) then
    EquipEffectSet:SetModelEffecByIntensify(self.data.itemData, go)
  end
  self:InitUI()
  self.isModelComplete = true
end

function DropItem:DestroyModel()
  if not self.model then
    return
  end
  self.model:Destroy()
  self.model = nil
end

function DropItem:DestroyEffect()
  if self.upEffectModel then
    self.upEffectModel:Destroy()
  end
  self.starEffectModel:Destroy()
end

function DropItem:InitCell()
  self.cellPos = Vector2Int(0, 0)
  self:SetCell(self.data.x, self.data.y)
end

function DropItem:SetCell(x, y)
  self.cellPos:Set(x, y)
end

function DropItem:GetPosByCell()
  if not self.posCell then
    self.posCell = Scene.GetPosByCell(self.cellPos)
  end
  return self.posCell
end

function DropItem:InitRotation()
  local itemPut = self.data.itemPut or "1"
  local putTable = string.split(itemPut, "#")
  local dirTable = DropItemUtility.GetDropItemDir(putTable[1])
  dirTable.y = self.offsetRotY and self.offsetRotY or dirTable.y
  self:SetRotation(dirTable)
end

function DropItem:SetRotation(dir)
  if not dir then
    return
  end
  self.dir = dir
  self.model:SetRotation(dir.x, dir.y, dir.z)
end

function DropItem:SetDropItemRotation(x, y, z)
  self.transform:SetLocalEulerAngles(x, y, z)
end

function DropItem:GetRotation()
  return self.dir
end

function DropItem:InitPosition()
  self:InitCell()
  local positionX, positionY, positionZ = Scene.GetPosXYZByCell(self.cellPos)
  self:SetPosition(positionX, positionY, positionZ)
end

function DropItem:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
  self.transform:SetLocalPosition(x, y, z)
end

function DropItem:GetPosition()
  return self.pos
end

function DropItem:InitUI()
  self:InitHeadUI()
end

function DropItem:DestroyUI()
  self:DestroyHeadUI()
end

function DropItem:InitHeadUI()
  if not self.gameObject then
    return
  end
  if self.Head then
    self.Head:RefreshData(self, true)
    return
  end
  self.Head = DropItemHead3DMesh(self, self.data)
end

function DropItem:DestroyHeadUI()
  if self.Head ~= nil then
    self.Head:Destroy()
  end
end

function DropItem:SetFinalRotAndPos()
  local itemPut = self.data.itemPut or "1"
  local putTable = string.split(itemPut, "#")
  self.offsetPosY, self.offsetRotY = DropItemUtility.GetDropItemOffset(putTable[1], putTable[2] or "0")
end

function DropItem:InitUpDropEffect()
  local effectModel
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(self.itemId)
  if not string.isNullOrEmpty(itemConfig.dropEffect) then
    effectModel = itemConfig.dropEffect
  else
    effectModel = DropItemUtility.GetDropItemLevelEffect(self.data.item.rarity)
  end
  if not effectModel then
    return
  end
  local effectData = {
    modelType = EEffectModelType.Scene,
    model = effectModel
  }
  self.upEffectModel = EffectModel(self.transform, nil, effectData)
  self.upEffectModel:Init()
  self.upEffectModel:SetLayer(self:GetModelLayer())
  self:SetUpEffectModel()
end

function DropItem:SetUpEffectModel()
  self.upEffectModel:SetModel(1)
end

function DropItem:InitStarDropEffect()
  local effectData = {
    modelType = EEffectModelType.Scene,
    model = "diaoluo_xingxing"
  }
  self.starEffectModel = EffectModel(self.transform, nil, effectData)
  self.starEffectModel:Init()
  self:SetStarEffectModel()
  self.starEffectModel:SetLayer(self:GetModelLayer())
  self.starEffectModel:SetPosition(0, 0.2, 0)
end

function DropItem:SetStarEffectModel()
  self.starEffectModel:SetModel(1)
end

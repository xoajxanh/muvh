require("GamePlay/Role/Model/ModelConfig")
require("GamePlay/Role/Animation/AnimationConfig")
require("GamePlay/Role/Animation/AnimationCtrl")
require("GamePlay/Role/Animation/AnimatorCtrl")
require("GamePlay/Role/Animation/SnowManAnimatorCtrl")
RoleModel = class()

function RoleModel:ctor(parent, name, data, avatar, onLoadMountModel)
  self.parent = parent
  self.name = name
  self.data = data
  self.modelActive = true
  self.avatar = avatar
  self.onLoadMountModel = onLoadMountModel
end

function RoleModel:Init()
  self.gameObject = CS.UnityEngine.GameObject(self.name or DEFAULT_MODEL)
  self.transform = self.gameObject.transform
  self.transform:SetParent(self.parent, false)
  self:InitSkillAnchor(self.transform)
  self:InitBuffAnchor(self.transform)
  self:SetPosition(0, 0, 0)
end

function RoleModel:Destroy()
  self:DestroyMountModel(self.mountModelId)
  self:DestroyRoleModel()
end

function RoleModel:DestroyRoleModel()
  if not self.gameObject or not self.data then
    return
  end
  self:RecycleRoleModel(self.modelObject)
  self.OnLoadModel = nil
  self.modelId = nil
  if self.model then
    self.model:StopLoad()
    self.model:ClearCallBack()
  end
  self.model = nil
  self.transform = nil
  UnityEngineLua.GameObject.Destroy(self.gameObject)
  self.gameObject = nil
end

function RoleModel:RecycleRoleModel(modelObject)
  if modelObject then
    PoolManagerTest.Recycle(self.data.modelType, self.modelId, modelObject)
    self.modelObject = nil
    self.animator = nil
    self.modelId = nil
  end
end

function RoleModel:SetRotation(x, y, z)
  if not self.gameObject then
    return
  end
  self.transform.localEulerAngles = Vector3.GetTemp(x, y, z)
end

function RoleModel:SetPosition(x, y, z)
  if not self.gameObject then
    return
  end
  self.transform.localPosition = Vector3.GetTemp(x, y, z)
end

function RoleModel:ChangeRoleModel(desModel, data, desModelType)
  if not self.gameObject then
    return
  end
  PoolManagerTest.Recycle(desModelType, desModel, self.modelObject)
  self.modelObject = nil
  self.data = data
  self:RefreshModel()
  self:SetModel(self.data.modelScale)
end

function RoleModel:InitModel()
  if not self.model then
    self.model = CS.Framework.GameModel("RoleModel", self.transform, function(go, name)
      self:OnLoadGameModel(go, name)
    end)
  end
  self:RefreshModelLayer()
end

function RoleModel:RefreshModel()
  if self.model then
    local roleModel = self.transform:Find("RoleModel")
    self.model = CS.Framework.GameModel(roleModel.gameObject, function(go, name)
      self:OnLoadGameModel(go, name)
    end)
  end
  self:RefreshModelLayer()
end

function RoleModel:SetModelActive(active)
  if self.modelActive == active then
    return
  end
  self.modelActive = active
  if not self.modelActive then
    self:RecycleRoleModel(self.modelObject)
    self:RecycleMountModel(self.mountModelId)
  elseif self.data.model then
    self:SetModel(self.modelScale)
    self:RefreshModelLayer()
    self:RefreshMountModelLayer()
  end
end

function RoleModel:SetModel(modelScale)
  self.modelScale = modelScale
  if self.data == nil or modelScale == nil then
    return
  end
  if self.modelId == self.data.model or not self.modelActive then
    return
  end
  self.modelId = self.data.model
  if ERoleModelNameType[self.data.model] == ERoleInitEquipType.snowMan then
    self.animator = SnowManAnimatorCtrl(self.avatar)
  else
    self.animator = AnimatorCtrl(self.avatar)
  end
  self:InitModel()
  local modelObjectGo = PoolManagerTest.Spawn(self.data.modelType, self.data.model)
  if modelObjectGo then
    self:OnLoadGameModel(modelObjectGo.gameObject)
  else
    self.model:LoadAsync(ModelConfig.GetModelPath(self.data.modelType, self.modelId))
  end
end

function RoleModel:OnLoadGameModel(go, name)
  if not name then
    self:SetRoleModel(go)
  end
  if self.OnLoadModel then
    self.OnLoadModel(go, name)
  end
  if self.onLoadMountModel then
    self.onLoadMountModel(self.avatar, go, name)
  end
  self:RefreshModelLayer()
end

function RoleModel:SetRoleModel(go)
  if not self.model then
    self:RecycleRoleModel(go)
    return
  end
  self.modelObject = go
  if self.modelObject and self.data then
    local modelTransform = self.modelObject.transform
    modelTransform:SetParent(self.model.transform, false)
    modelTransform:SetLocalPosition(0, self.data.height, 0)
    modelTransform:SetLocalRotation(0, 0, 0, 1)
    self.modelObject:SetActive(self.modelActive)
    self.modelObject.name = self.data.id and self.data.id or self.data.model
    self:InitNodes()
  end
  if self.animator then
    if self.avatar then
      self.animator:Init(go, true, self.avatar.RoleType ~= ERoleType.Player)
    else
      self.animator:Init(go, true, true)
    end
  end
  self:SetModelScale(self.modelScale)
end

function RoleModel:RefreshRoleModel(go)
  self.modelObject = go
  if self.modelObject and self.data then
    local modelTransform = self.modelObject.transform
    modelTransform:SetLocalPosition(0, self.data.height, 0)
  end
end

function RoleModel:InitNodes()
  self.nodeMap = self.modelObject:GetComponent(typeof(CS.ModelNodeMap))
end

function RoleModel:GetModelNode(modelPos)
  if not self.modelObject then
    return
  end
  local nameId = StringPool.ToID(modelPos)
  if self.nodeMap then
    return self.nodeMap:GetNodeTransform(nameId)
  end
  return self.modelObject.transform
end

function RoleModel:GetModelObject()
  return self.modelObject
end

function RoleModel:SetModelScale(scale)
  if scale and self.modelObject then
    self.modelObject.transform:SetLocalScale(scale)
  end
end

function RoleModel:SetModelObjectName(name)
  if self.modelObject then
    self.modelObject.name = name
  end
end

function RoleModel:InitMountModel()
  local mountObject = self.transform:Find("MountModel")
  if mountObject then
    self.mountModel = CS.Framework.GameModel(mountObject.gameObject, function(go, name)
      self:OnLoadMountModel(go, name)
    end)
  end
  if not self.mountModel then
    self.mountModel = CS.Framework.GameModel("MountModel", self.transform, function(go, name)
      self:OnLoadMountModel(go, name)
    end)
  end
  self:RefreshMountModelLayer()
end

function RoleModel:DestroyMountModel(mountId)
  if self.mountModel then
    self.mountModel:StopLoad()
    self.mountModel:ClearCallBack()
    self.mountModel = nil
    self.recycleMountId = self.mountModelId
  end
  self:RecycleMountModel(mountId)
end

function RoleModel:RecycleMountModel(mountId)
  if self.mountModelObject then
    PoolManagerTest.Recycle(EModelType.Mount, mountId, self.mountModelObject)
    self.mountModelObject = nil
    self.mountAnimator = nil
    self.mountModelId = nil
  end
end

function RoleModel:SetMountModel(id)
  if id == 0 then
    id = nil
  end
  if self.mountModelId == id or not self.modelActive then
    return
  end
  if not id then
    local mountId = self.mountModelId
    self.mountModelId = nil
    self:ApplyMount()
    self:DestroyMountModel(mountId)
    return
  end
  self.mountModelId = id
  self.mountAnimator = AnimatorCtrl()
  if not self.mountModel then
    self:InitMountModel()
  end
  local modelObjectGo = PoolManagerTest.Spawn(EModelType.Mount, self.mountModelId)
  if modelObjectGo then
    self:OnLoadMountModel(modelObjectGo.gameObject)
    self.mountModelObject.gameObject:SetActive(true)
  else
    self.mountModel:LoadAsync(ModelConfig.GetModelPath(EModelType.Mount, self.mountModelId))
  end
end

function RoleModel:OnLoadMountModel(go, name)
  if not self.mountModel then
    UnityEngineLua.GameObject.Destroy(go)
    return
  end
  if not name then
    self.mountModelObject = go
    self.mountModelObject.transform:SetParent(self.mountModel.transform, false)
    self.mountModelObject.name = self.mountModelId
    self.mountAnimator:Init(go, false, true)
    self:SetMountModelScale(self.modelScale)
  end
  if self.onLoadMountModel then
    self.onLoadMountModel(self.avatar, go, name)
  end
  self:RefreshAnimation()
  if self.mountModelObject.gameObject:GetComponentInChildren(typeof(CS.Framework.MonsterShadow)) then
    self.mountShadowHeight = self.mountModelObject.gameObject:GetComponentInChildren(typeof(CS.Framework.MonsterShadow))
    self.mountShadowHeight:SetTarget(self.mountModelObject.transform)
    self.mountShadowHeight.Alive = true
  end
  if self.avatar.graphicQuality ~= nil then
    local quality = go:GetComponent(typeof(CS.ModelGraphicQuality))
    if quality ~= nil then
      quality:SetQuality(self.avatar.graphicQuality - 1)
    end
  end
end

function RoleModel:ApplyMount()
  if not self.animator then
    return
  end
  self:RefreshAnimation()
end

function RoleModel:IsMounting()
  return self.mountModelId ~= nil
end

function RoleModel:SetMountModelScale(scale)
  if scale and self.mountModelObject then
    self.mountModelObject.transform:SetLocalScale(scale)
  end
end

function RoleModel:SetForceUpdate()
  if not self.animator then
    return
  end
  self.animator:ForceUpdate()
end

function RoleModel:SetLayer(layer)
  if self.layer == layer then
    return
  end
  self.layer = layer
  self:RefreshModelLayer()
  self:RefreshMountModelLayer()
end

function RoleModel:RefreshModelLayer()
  if self.layer and self.model then
    self.model:SetLayer(self.layer)
  end
end

function RoleModel:RefreshMountModelLayer()
  if self.layer and self.mountModel then
    self.mountModel:SetLayer(self.layer)
  end
end

function RoleModel:PlayAnimation(name, speed, fadeTime, startTime, realTime, callback)
  if self.animator then
    self.animator:SetMountPrefix(self.mountModelId)
    self.animator:Play(name, speed, fadeTime, startTime, realTime, callback)
  end
  if self:IsMounting() then
    self.mountAnimator:PlayMount(name, speed, fadeTime, startTime)
  end
end

function RoleModel:PlayInstantAnimation(animalName, normalizeTime, layer)
  if self.animator then
    self.animator:PlayInstantAnimal(animalName, normalizeTime, layer)
  end
end

function RoleModel:RefreshAnimation()
  local originalName = self.animator.originalName
  if originalName then
    self:PlayAnimation(originalName)
  end
end

function RoleModel:SetAnimatorSpeed(speed)
  if not self.animator then
    return
  end
  self.animator:SetAnimatorSpeed(speed)
end

function RoleModel:InitSkillAnchor(parent)
  self.SkillAnchor = parent:Find("SkillAnchor")
  if self.SkillAnchor then
    return
  end
  self.SkillAnchor = CS.UnityEngine.GameObject("SkillAnchor").transform
  self.SkillAnchor:SetParent(parent, false)
end

function RoleModel:InitBuffAnchor(parent)
  self.BuffAnchor = parent:Find("BuffAnchor")
  if self.BuffAnchor then
    return
  end
  self.BuffAnchor = CS.UnityEngine.GameObject("BuffAnchor").transform
  self.BuffAnchor:SetParent(parent, false)
end

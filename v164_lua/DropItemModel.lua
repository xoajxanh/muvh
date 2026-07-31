require("GamePlay/DropItem/Model/DropItemModelConfig")
DropItemModel = class()

function DropItemModel:ctor(parent, name, data)
  self.parent = parent
  self.name = name
  self.data = data
end

function DropItemModel:Init()
  if self.data.route == "" then
    logError("T\195\170n t\195\160i nguy\195\170n r\198\161i tr\225\187\145ng", self.data.configID)
    return
  end
  self.gameObject = PoolManagerTest.Spawn(self.data.modelType, self.data.route)
  if self.gameObject then
    self.transform = self.gameObject.transform
    self.transform:SetParent(self.parent, false)
  else
    self.gameObject = CS.UnityEngine.GameObject(self.name or DEFAULT_MODEL)
    self.transform = self.gameObject.transform
    self.transform:SetParent(self.parent, false)
  end
  self:SetPosition(0, 0, 0)
end

function DropItemModel:Destroy()
  PoolManagerTest.Recycle(self.data.modelType, self.data.route, self.gameObject)
  self.OnLoadModel = nil
  self.gameObject = nil
  self.transform = nil
  self.modelObject = nil
  if self.model ~= nil then
    self.model:StopLoad()
    self.model:ClearCallBack()
  end
  self.model = nil
end

function DropItemModel:SetRotation(x, y, z)
  self.transform.localEulerAngles = Vector3(x, y, z)
end

function DropItemModel:SetPosition(x, y, z)
  self.transform.localPosition = Vector3(x, y, z)
end

function DropItemModel:GetPosition()
  return self.transform.localPosition
end

function DropItemModel:SetParent(parent)
  self.transform:SetParent(parent, false)
end

function DropItemModel:SetModelActive(active)
  if self.modelObject then
    self.modelObject.gameObject:SetActive(active)
  end
end

function DropItemModel:InitModel()
  if not self.model then
    local itemModel = self.transform:Find("ItemModel")
    if not itemModel then
      self.model = CS.Framework.GameModel("ItemModel", self.transform, function(go, name)
        self:OnLoadGameModel(go, name)
      end)
    else
      self.model = CS.Framework.GameModel(itemModel.gameObject, function(go, name)
        self:OnLoadGameModel(go, name)
      end)
    end
  end
  self:RefreshModelLayer()
end

function DropItemModel:OnLoadGameModel(go, name)
  if not name then
    self:SetDropItemModel(go)
  end
  if self.OnLoadModel then
    self.OnLoadModel(go, name)
  end
end

function DropItemModel:SetDropItemModel(go)
  if not self.model then
    CS.Framework.ResourceManager.Recycle(go)
    return
  end
  self.modelObject = go
  if self.modelObject and self.data then
    local modelObjectTf = self.modelObject.transform
    modelObjectTf:SetParent(self.model.transform, false)
    modelObjectTf:SetLocalPosition(0, 0, 0)
    modelObjectTf:SetLocalRotation(0, 0, 0, 1)
    self.modelObject:SetActive(true)
    self.modelObject.name = self.data.id
  end
  self:SetModelScale(self.modelScale)
end

function DropItemModel:SetModelScale(scale)
  if scale ~= nil and self.modelObject ~= nil then
    self.modelObject.transform:SetLocalScale(scale)
  end
end

function DropItemModel:SetModel(modelScale)
  self.modelScale = modelScale
  if self.data == nil or modelScale == nil then
    return
  end
  if self.modelID == self.data.route or self.modelID == "/" then
    return
  end
  self.modelID = self.data.route
  self:InitModel()
  local modelGo
  if self.model.transform.childCount > 0 then
    modelGo = self.model.transform:GetChild(0)
  end
  if modelGo then
    self:OnLoadGameModel(modelGo.gameObject)
    self:SetModelActive(true)
  else
    self.model:LoadAsync(DropItemModelConfig.GetModelPath(self.data.modelType, self.modelID))
  end
end

function DropItemModel:GetModelScale()
  return self.modelScale
end

function DropItemModel:SetLayer(layer)
  if self.layer == layer then
    return
  end
  self.layer = layer
  self:RefreshModelLayer()
end

function DropItemModel:RefreshModelLayer()
  if self.layer and self.model then
    self.model:SetLayer(self.layer)
  end
end

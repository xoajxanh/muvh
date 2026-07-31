Trap = class()
setgetters(Trap, {
  id = function(self)
    return self.data.id
  end,
  serverCoord = function(self)
    return self.data.serverCoord
  end,
  x = function(self)
    return self.serverCoord.x
  end,
  y = function(self)
    return self.serverCoord.y
  end,
  configId = function(self)
    return self.data.configId
  end,
  createTime = function(self)
    return self.data.createTime
  end,
  name = function(self)
    return self.data.name
  end
})

function Trap:ctor(data)
  self:InitAttribute(data)
  self:InitGameObject()
  self:InitPosition()
  self:InitModel()
end

function Trap:RefreshRoleInfo(data)
  self:InitAttribute(data)
  self:InitPosition()
end

function Trap:Destroy()
  self:DestroyModel()
  self:DestroyGameObject()
end

function Trap:InitAttribute(data)
  self.data = data
end

function Trap:GetParent()
  return TrapManager.root
end

function Trap:GetName()
  return self.name
end

function Trap:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject(self:GetName())
  self.transform = self.gameObject.transform
  self.transform:SetParent(self:GetParent())
end

function Trap:DestroyGameObject()
  CS.Framework.ObjectEx.Destroy(self.gameObject)
  self.gameObject = nil
  self.transform = nil
end

function Trap:Update()
end

function Trap:SetRotation(dir)
  if not dir then
    return
  end
  self.dir = dir
  self.model:SetRotation(dir.x, dir.y, dir.z)
end

function Trap:InitPosition()
  self:InitCell()
  self.pos = Vector3(0, 0, 0)
  self:SetCellAndPos(self.data.x, self.data.y)
end

function Trap:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
  self.transform.localPosition = self.pos
end

function Trap:GetPosition()
  return self.pos
end

function Trap:InitCell()
  self.cellPos = Vector2Int(0, 0)
  self:SetCell(self.data.x or 0, self.data.y or 0)
end

function Trap:SetCell(x, y)
  self.cellPos:Set(x, y)
  if Scene.tileData ~= nil then
    self.cellType = Scene.tileData:GetTileType(x, y)
  else
    self.cellType = 0
  end
  self:CurCellDataChange()
end

function Trap:CurCellDataChange()
  if self.cellType == self.curCellType then
    return
  end
  self.curCellType = self.cellType
end

function Trap:SetCellAndPos(x, y)
  self:SetCell(x, y)
  local position = Scene.GetPosByCell(self.cellPos)
  self:SetPosition(position.x, position.y, position.z)
end

function Trap:GetModelLayer()
  return ROLE_LAYER
end

function Trap:InitModel()
  self.model = EffectModel(self.transform, nil, self.data)
  self.model.OnLoadModel = bind(self, self.OnLoadTrapModelComplete)
  self.model:Init()
  self:SetModel(self.data)
  self.model:SetLayer(self:GetModelLayer())
end

function Trap:GetModelScale()
  if self.data == nil or self.data.configId == nil then
    return 1
  end
  local map_trapConfig = ClientTable.cfg_Map_trapManager:TryGetValue(self.data.configId)
  if map_trapConfig and map_trapConfig.scale ~= 0 then
    return map_trapConfig.scale
  end
  return 1
end

function Trap:SetModel()
  self.model:SetModel(self:GetModelScale())
end

function Trap:SetItemModelPosition(x, y, z)
end

function Trap:OnLoadTrapModelComplete(go, name)
end

function Trap:DestroyModel()
  self.model:Destroy()
  self.model = nil
end

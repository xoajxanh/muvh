BlockBuilding = class()
setgetters(BlockBuilding, {
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
  blockData = function(self)
    return self.data.blockData
  end,
  blockType = function(self)
    return self.data.blockType
  end,
  name = function(self)
    return self.data.name
  end
})

function BlockBuilding:ctor(data)
  self:InitAttribute(data)
  self:InitGameObject()
  self:InitPosition()
end

function BlockBuilding:RefreshBlockBuildInfo(data)
  self:InitAttribute(data)
  self:InitPosition()
end

function BlockBuilding:Destroy()
  self:ResetTileType()
  self:DestroyGameObject()
end

function BlockBuilding:ResetTileType()
  local cell = {
    x = self.x,
    y = self.y
  }
  if self.curCellType then
    Scene.RemoveTileType(cell, self.curCellType)
  end
end

function BlockBuilding:InitAttribute(data)
  self.data = data
end

function BlockBuilding:GetParent()
  return BlockBuildManager.root
end

function BlockBuilding:GetName()
  return self.name
end

function BlockBuilding:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject(self:GetName())
  self.transform = self.gameObject.transform
  self.transform:SetParent(self:GetParent())
end

function BlockBuilding:DestroyGameObject()
  CS.Framework.ObjectEx.Destroy(self.gameObject)
  self.gameObject = nil
  self.transform = nil
end

function BlockBuilding:InitPosition()
  self:InitCell()
  self.pos = Vector3(0, 0, 0)
  self:SetCellAndPos(self.data.x, self.data.y)
end

function BlockBuilding:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
  self.transform.localPosition = self.pos
end

function BlockBuilding:InitCell()
  self.cellPos = Vector2Int(0, 0)
  self:SetCell(self.data.x or 0, self.data.y or 0)
end

function BlockBuilding:SetCell(x, y)
  self.cellPos:Set(x, y)
  self.cellType = Scene.GetTileType(x, y)
end

function BlockBuilding:CurCellDataChange()
  if self.cellType == self.curCellType then
    return
  end
  self.curCellType = self.cellType
end

function BlockBuilding:SetCellAndPos(x, y)
  self:SetCell(x, y)
  local position = Scene.GetPosByCell(self.cellPos)
  self:SetPosition(position.x, position.y, position.z)
end

function BlockBuilding:SetCellType(tileType)
  local cell = {
    x = self.x,
    y = self.y
  }
  if self.curCellType then
    Scene.RemoveTileType(cell, self.curCellType)
  end
  Scene.AddTileType(cell, tileType)
  self.cellType = tileType
  self:CurCellDataChange()
end

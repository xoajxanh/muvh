ItemCellData = class()

function ItemCellData:ctor()
  self:Init()
end

function ItemCellData:Init()
  self.index = -1
  self.itemData = nil
  self.isShow = true
  self.x = 0
  self.y = 0
  self.width = 1
  self.height = 1
  self.state = ItemCellStateEnum.Free
  self.dragState = ItemCellDragStateEnum.None
  self.model = nil
  self.effectModelLoader = nil
  self.selected = false
  self.lock = false
  self.enabled = true
  self.isShowArrow = true
  self.isDrag = false
  self.isNeedShake = false
  self.intensify = -1
  self.meshTag = false
  self.isNewGet = false
  self.isClicked = true
end

function ItemCellData:RefreshData(itemData, customData, noRefreshPosition)
  self.itemData = itemData
  self.state = ItemCellStateEnum.Use
  self.customData = customData
  if itemData ~= nil then
    if itemData.bagGridIndex ~= nil and not noRefreshPosition then
      local index = itemData.bagGridIndex + 1
      self:SetCellPosition(index)
      self:SetCellUnitPosition(index)
    end
    if itemData.tblItem ~= nil then
      self:SetCellSize(itemData.tblItem)
    end
  end
  self.meshTag = false
end

function ItemCellData:RefreshRect(rect)
  local divisor = 1 / BagInfoData.cellSize
  self.x = rect.x
  self.y = rect.y
  self.width = rect.width
  self.height = rect.height
  if rect.x ~= nil then
    self.UnitX = rect.x * divisor
  end
  if rect.y ~= nil then
    self.UnitY = rect.y * -divisor
  end
end

function ItemCellData:Contains(v2, x1, y1)
  x1 = x1 or 0
  y1 = y1 or 0
  local x = self.x - x1
  local y = self.y - y1
  if x <= v2.x and y >= v2.y and v2.x <= x + self.width and v2.y >= y - self.height then
    return true
  end
  return false
end

function ItemCellData:Equal(cellData)
  if self.x == cellData.x and self.y == cellData.y and self.width == cellData.width and self.height == cellData.height then
    return true
  end
  return false
end

function ItemCellData:EqualByParam(x, y, width, height)
  if self.configWidth == nil then
    self:GetCellConfigSize()
  end
  return x == self.UnitX and y == self.UnitY and width == self.configWidth and height == self.configHeight
end

function ItemCellData:CheckCantDrop(flag)
  local cantDrop = flag
  if not cantDrop and (self.state == ItemCellStateEnum.Use or self.lock) then
    cantDrop = true
  end
  return cantDrop
end

function ItemCellData:RecycleRes()
  if self.isSetmaskInfo == true and self.model ~= nil then
    ItemUtility.NewSetShaderParamsValue(self.model)
    self.isSetmaskInfo = false
  end
  if self.model then
    local path = self.model.Path
    local obj = self.model:RemoveModelObj()
    if obj then
      obj.transform.localScale = Vector3.one
      PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(path), obj)
    end
    self.model = nil
    self.intensify = -1
    self.meshTag = false
  end
  if self.effectModelLoader then
    local path = self.effectModelLoader.Path
    local obj = self.effectModelLoader:RemoveModelObj()
    if obj then
      obj.transform.localScale = Vector3.one
      PoolManagerTest.Recycle(ResourceTypeEnum.Effect_UI, ResourceConfig.GetPrefabName(path), obj)
    end
    self.effectModelLoader = nil
  end
end

function ItemCellData:OnReset()
  self.itemData = nil
  self.state = ItemCellStateEnum.Free
  self.selected = false
  self.dragState = ItemCellDragStateEnum.None
  self.isShowArrow = true
  self.isDrag = false
  self.isNeedShake = false
  self.meshTag = false
end

function ItemCellData:Reset(item)
  self:OnReset()
  if item then
    ItemUtility.HideItemCell(item, self)
  else
    self:RecycleRes()
  end
end

function ItemCellData:GetData()
  return self
end

function ItemCellData:GetModelData()
  return self.model and self.model.modelObject
end

function ItemCellData:GetEffectModelData()
  return self.effectModelLoader and self.effectModelLoader.modelObject
end

function ItemCellData:GetBgSpriteName()
  local name = ""
  if self.dragState == ItemCellDragStateEnum.None then
  elseif self.dragState == ItemCellDragStateEnum.cantDrag then
    name = "item_frameNotSelect"
  elseif self.dragState == ItemCellDragStateEnum.canDrag then
    name = "item_frameSelect"
  end
  return name
end

function ItemCellData:SetCellPosition(gridIndex)
  local x, y = SpaceCalcUtility.CalcXy(gridIndex, 8)
  self.x, self.y = x * BagInfoData.cellSize, y * -BagInfoData.cellSize
end

function ItemCellData:SetCellUnitPosition(gridIndex)
  self.UnitX, self.UnitY = SpaceCalcUtility.CalcXy(gridIndex, 8)
end

function ItemCellData:SetCellSize(itemTbl)
  if itemTbl == nil then
    return
  end
  self.width, self.height = BagInfoData.cellSize * itemTbl.xTranslate, BagInfoData.cellSize * itemTbl.yTranslate
end

function ItemCellData:SetCellConfigSize(width, height)
  self.configWidth = width
  self.configHeight = height
end

function ItemCellData:GetCellConfigSize()
  if self.configWidth ~= nil and self.configHeight ~= nil then
    return self.configWidth, self.configHeight
  end
  if self.itemData == nil or self.itemData.tblItem == nil then
    return
  end
  if self.configWidth == nil then
    self.configWidth = self.itemData.tblItem.xTranslate
  end
  if self.configHeight == nil then
    self.configHeight = self.itemData.tblItem.yTranslate
  end
  return self.configWidth, self.configHeight
end

function ItemCellData:CheckHaveBaseData()
  return self.x ~= nil and self.y ~= nil and self.width ~= nil and self.height ~= nil
end

function ItemCellData:GetRightDownPoint()
  if self.itemData == nil then
    return
  end
  if self.rightDownX == nil then
    self.rightDownX = self.x + self.itemData.tblItem.xTranslate
  end
  if self.rightDownY == nil then
    self.rightDownY = self.y + self.itemData.tblItem.yTranslate
  end
  return self.rightDownX, self.rightDownY
end

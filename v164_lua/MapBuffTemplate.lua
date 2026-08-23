local MapBuffTemplate = {}
MapBuffTemplate.baseUI = nil
MapBuffTemplate.pointType = nil
MapBuffTemplate.buffData = nil
MapBuffTemplate.buffTextureName = nil
MapBuffTemplate.scale = nil
MapBuffTemplate.position = nil

function MapBuffTemplate:Init(pointType)
  self.pointType = pointType
end

function MapBuffTemplate:Refresh(data, baseUI)
  self:ResetData()
  if self:AnalysisParams(data, baseUI) == false then
    self:UIControl():SetActive(false)
    return
  end
  self:UIControl():SetActive(true)
  self:RefreshBuffTexture()
  self:RefreshScale()
  self:RefreshPosition()
end

function MapBuffTemplate:ResetData()
  self.baseUI = nil
  self.buffData = nil
  self.buffTextureName = nil
  self.scale = nil
  self.position = nil
end

function MapBuffTemplate:AnalysisParams(data, baseUI)
  self.baseUI = baseUI
  self.buffData = data
  if self.pointType == nil or self.buffData == nil then
    return false
  end
  local scale, position
  if self.pointType == MapPointBuffRefreshType.MINIMAP then
    self.buffTextureName = self.buffData.minimap
    scale = self.buffData.miniScale
    position = self.buffData.miniPosition
  elseif self.pointType == MapPointBuffRefreshType.MAXMAP then
    self.buffTextureName = self.buffData.bigMap
    scale = self.buffData.bigScale
    position = self.buffData.bigPosition
  end
  if string.isNullOrEmpty(scale) == false then
    local scale = string.split(scale, "#")
    if 1 < #scale then
      self.scale = Vector3(tonumber(scale[1]), tonumber(scale[2]), 1)
    end
  end
  if string.isNullOrEmpty(position) == false then
    local position = string.split(position, "#")
    if 1 < #position then
      self.position = Vector2(tonumber(position[1]), tonumber(position[2]))
    end
  end
  return true
end

function MapBuffTemplate:RefreshBuffTexture()
  if self.buffTextureName then
    self.baseUI:SetSprite("Atlas_Common", self.buffTextureName, self:UIControl())
  end
end

function MapBuffTemplate:RefreshScale()
  if self.scale ~= nil then
    self:UIControl():SetScale(self.scale)
  end
end

function MapBuffTemplate:RefreshPosition()
  if self.position ~= nil then
    self:UIControl():SetAnchoredPosition(self.position.x, self.position.y)
  end
end

return MapBuffTemplate

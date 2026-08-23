local OutMiniMapVirusCircleTemplate = {}
setmetatable(OutMiniMapVirusCircleTemplate, LuaComponentTemplates.MiniMap_KaLunTeVirusCircle)

function OutMiniMapVirusCircleTemplate:ChangeShaderPoint(position)
  if position == nil then
    return
  end
  local mapOffset = position - self.sceneCenterPoint
  return Vector2(0.5 + mapOffset.x * self.normalWidth, 0.5 + mapOffset.y * self.normalWidth)
end

function OutMiniMapVirusCircleTemplate:TryShowPredictionVirusCircle()
  local position = self:GetPredictionVirusCirclePosition()
  local width = self:GetPredictionVirusCircleWidth()
  self.previewCircle.rectTransform.localPosition = position
  self.previewCircle:SetSizeDelta(width, width)
  self.previewCircle:SetActive(self.IsLerp)
end

function OutMiniMapVirusCircleTemplate:GetPredictionVirusCirclePosition()
  local mapOffset = (self.changeData.endPoint - self.sceneCenterPoint) * self.baseMapRatio
  return mapOffset
end

function OutMiniMapVirusCircleTemplate:SetMaskWidth(width)
  if width == nil then
    return
  end
  local shaderWidth = self:ChangeShaderWidth(width)
  local changewidth = shaderWidth / 0.0098 * 10
  local nowDic = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager():GetVirusCircle_MiniMap():GetMaskItemChangePosDic(changewidth)
  self.mask1.transform.localPosition = nowDic[1]
  self.mask2.transform.localPosition = nowDic[2]
  self.mask3.transform.localPosition = nowDic[3]
  self.mask4.transform.localPosition = nowDic[4]
end

return OutMiniMapVirusCircleTemplate

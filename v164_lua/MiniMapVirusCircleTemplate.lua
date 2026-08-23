local MiniMapVirusCircleTemplate = {}
MiniMapVirusCircleTemplate.Main_MapDetailUI = nil
MiniMapVirusCircleTemplate.IsLerp = nil
MiniMapVirusCircleTemplate.changeData = nil
MiniMapVirusCircleTemplate.ShowState = false

function MiniMapVirusCircleTemplate:Init(baseUI)
  self.Main_MapDetailUI = baseUI
  self:InitControls()
  self:AnalysisShaderVirusCircleParams(self.Main_MapDetailUI.sp_map.transform.sizeDelta, self.MaskCircle.transform.sizeDelta, self.MaskCircle.transform.localPosition)
  self:InitShader()
end

function MiniMapVirusCircleTemplate:InitControls()
  self.MaskCircle = self:GetControl("MaskCircle")
  self.previewCircle = self:GetControl("previewCircle")
  self.previewTimeCircle = self:GetControl("previewTimeCircle")
  self.newMaskroot = self:GetControl("newMask")
  self.mask1 = self:GetControl("newMask/KaLunTeCircleParent/Image")
  self.mask2 = self:GetControl("newMask/KaLunTeCircleParent/x_add")
  self.mask3 = self:GetControl("newMask/KaLunTeCircleParent/x_y_add")
  self.mask4 = self:GetControl("newMask/KaLunTeCircleParent/y_add")
end

function MiniMapVirusCircleTemplate:InitShader()
end

function MiniMapVirusCircleTemplate:Refresh(data)
  if self:AnalysisData(data) == false then
    return
  end
  self:TryShowVirusCircle()
  self:TryTweenVirusCircle()
  self:TryShowPredictionVirusCircle()
end

function MiniMapVirusCircleTemplate:AnalysisData(data)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager().IsInActivity == false then
    self:LogOut()
    return false
  end
  if data == nil or data.startWidth == nil or data.startPoint == nil then
    return false
  end
  local isLerp = data.startWidth ~= data.endWidth and data.startWidth > data.endWidth
  if isLerp == false and self.changeData ~= nil and self.changeData.endWidth == self.changeData.startWidth then
    return false
  end
  self.IsLerp = isLerp
  self.changeData = data
  return true
end

function MiniMapVirusCircleTemplate:TryShowVirusCircle()
  if self.ShowState == true then
    return
  end
  self:UIControl():SetActive(true)
  self:SetMaskPosition(self.changeData.startPoint)
  self:SetMaskWidth(self.changeData.startWidth)
  self.ShowState = true
end

function MiniMapVirusCircleTemplate:TryTweenVirusCircle()
  if self.ShowState == false or self.IsLerp == false then
    return
  end
  self:StopVirusCircleChangeTween()
  self.LoopTimer = Timer.StartLoopForever(0.02, self.VirusCircleChangeTween, self)
end

function MiniMapVirusCircleTemplate:VirusCircleChangeTween()
  local lerpWidth = self:GetLerpWidth()
  local isEnd = lerpWidth <= self.changeData.endWidth
  self:SetMaskPosition(self:GetLerpPosition())
  self:SetMaskWidth(self:GetLerpWidth())
  self:RefreshPredictionSchedule()
  if isEnd then
    self:StopVirusCircleChangeTween()
    self:RemovePredictionVirusCircle()
  end
end

function MiniMapVirusCircleTemplate:StopVirusCircleChangeTween()
  if self.LoopTimer ~= nil then
    Timer.Stop(self.LoopTimer)
    self.LoopTimer = nil
  end
end

function MiniMapVirusCircleTemplate:RemoveVirusCircle()
  self.ShowState = false
  self:UIControl():SetActive(false)
end

function MiniMapVirusCircleTemplate:Exit()
  self:LogOut()
end

function MiniMapVirusCircleTemplate:GetLerpSchedule()
  if self.changeData == nil or self.changeData.endTime == nil or Time.GetServerTime() >= self.changeData.endTime then
    return 0
  end
  return (self.changeData.endTime - Time.GetServerTime()) / self.changeData.totalTime
end

function MiniMapVirusCircleTemplate:GetLerpPosition()
  local ratio = self:GetLerpSchedule()
  local offsetVector = self.changeData.pointOffset * ratio
  return Vector2(self.changeData.endPoint.x + offsetVector.x, self.changeData.endPoint.y + offsetVector.y)
end

function MiniMapVirusCircleTemplate:GetLerpWidth()
  local ratio = self:GetLerpSchedule()
  local offsetVector = self.changeData.widthOffset * ratio
  return self.changeData.endWidth + offsetVector
end

function MiniMapVirusCircleTemplate:TryShowPredictionVirusCircle()
  local position = self:GetPredictionVirusCirclePosition()
  local width = self:GetPredictionVirusCircleWidth()
  self.previewCircle.rectTransform.localPosition = position
  self.previewCircle:SetSizeDelta(width, width)
  self.previewCircle:SetActive(self.IsLerp)
  self.previewTimeCircle.rectTransform.localPosition = position
  self.previewTimeCircle:SetSizeDelta(width, width)
  self.previewTimeCircle:SetActive(self.IsLerp)
end

function MiniMapVirusCircleTemplate:RefreshPredictionSchedule()
  self.previewTimeCircle:SetFillAmount(self:GetLerpSchedule())
end

function MiniMapVirusCircleTemplate:RemovePredictionVirusCircle()
  self.previewCircle:SetActive(false)
  self.previewTimeCircle:SetActive(false)
end

function MiniMapVirusCircleTemplate:GetPredictionVirusCirclePosition()
  return Vector3(self.changeData.endPoint.x * self.baseMapRatio, self.changeData.endPoint.y * self.baseMapRatio)
end

function MiniMapVirusCircleTemplate:GetPredictionVirusCircleWidth()
  return self.changeData.endWidth * self.baseMapRatio
end

MiniMapVirusCircleTemplate.MiniMapCenterPoint = nil
MiniMapVirusCircleTemplate.normalWidth = nil
MiniMapVirusCircleTemplate.baseMapRatio = nil
MiniMapVirusCircleTemplate.sceneCenterPoint = nil

function MiniMapVirusCircleTemplate:AnalysisShaderVirusCircleParams(mapSize, virusCircleMapSize, virusCircleMapCenterPoint)
  if mapSize == nil or virusCircleMapSize == nil then
    return
  end
  self.baseMapRatio = mapSize.x / SceneData.width
  self.MiniMapCenterPoint = Vector2(virusCircleMapCenterPoint.x, virusCircleMapCenterPoint.y) / self.baseMapRatio
  self.normalWidth = 1 / virusCircleMapSize.x * self.baseMapRatio
  self.sceneCenterPoint = Vector2(SceneData.width * 0.5, SceneData.height * 0.5)
end

function MiniMapVirusCircleTemplate:ChangeShaderPoint(position)
  if position == nil then
    return
  end
  local directionVector = position - self.MiniMapCenterPoint
  return Vector2(0.5 + directionVector.x * self.normalWidth, 0.5 + directionVector.y * self.normalWidth)
end

function MiniMapVirusCircleTemplate:ChangeShaderWidth(width)
  return self.normalWidth * width
end

function MiniMapVirusCircleTemplate:SetShaderVirusCirclePosition(position)
  if position == nil or position.x == nil or position.y == nil then
    return
  end
  local shaderPosition = self:ChangeShaderPoint(position)
  self.MaskCircle:SetImageMaterialFloat("_Center_X", shaderPosition.x)
  self.MaskCircle:SetImageMaterialFloat("_Cetner_Y", shaderPosition.y)
end

function MiniMapVirusCircleTemplate:SetShaderVirusCircleWidth(width)
  if width == nil then
    return
  end
  local shaderWidth = self:ChangeShaderWidth(width)
  self.MaskCircle:SetImageMaterialFloat("_Width", shaderWidth)
end

function MiniMapVirusCircleTemplate:SetMaskPosition(position)
  if position == nil or position.x == nil or position.y == nil then
    return
  end
  local shaderPosition = self:ChangeShaderPoint(position)
  local changex = self.MaskCircle.transform.sizeDelta.x * shaderPosition.x
  local changey = self.MaskCircle.transform.sizeDelta.x * shaderPosition.y
  self.newMaskroot.transform.localPosition = Vector3(changex, changey, 0)
end

function MiniMapVirusCircleTemplate:SetMaskWidth(width)
  if width == nil then
    return
  end
  local shaderWidth = self:ChangeShaderWidth(width)
  local changewidth = shaderWidth / 0.018 * 10
  local nowDic = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager():GetVirusCircle_MiniMap():GetMaskItemChangePosDic(changewidth)
  self.mask1.transform.localPosition = nowDic[1]
  self.mask2.transform.localPosition = nowDic[2]
  self.mask3.transform.localPosition = nowDic[3]
  self.mask4.transform.localPosition = nowDic[4]
end

function MiniMapVirusCircleTemplate:LogOut()
  self:StopVirusCircleChangeTween()
  self:RemoveVirusCircle()
  self.IsLerp = nil
  self.changeData = nil
end

return MiniMapVirusCircleTemplate

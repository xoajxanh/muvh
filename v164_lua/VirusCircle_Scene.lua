local VirusCircle_Scene = {}
VirusCircle_Scene.VirusCircleBaseParams = nil
VirusCircle_Scene.VirusCircle = nil
VirusCircle_Scene.virusCircleRatio = 0.1

function VirusCircle_Scene:GetVirusCircleManager()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager()
end

function VirusCircle_Scene:ChangeVirusCircleByServer(baseParams)
  if self:AnalysisServerData(baseParams) == false then
    return
  end
  self:TryCreateOrRefreshVirusCircle()
  self:TryTweenVirusCircle()
end

function VirusCircle_Scene:AnalysisServerData(baseParams)
  self.VirusCircleBaseParams = baseParams
  return true
end

function VirusCircle_Scene:TryCreateOrRefreshVirusCircle()
  if self.VirusCircle == nil then
    SceneUtility.AddSceneEffect(106, self:GetCreateVirusCircleCenterPoint(), function(effectObj)
      self.VirusCircle = effectObj
      self.virusCircleLocalScaleY = self.VirusCircle.EffectObj.transform.localScale.y
      self.VirusCircle.EffectObj.transform.localScale = self:GetCreateVirusCircleScale()
      self:TryTweenVirusCircle()
    end, 0)
  end
end

function VirusCircle_Scene:GetCreateVirusCircleCenterPoint()
  local isLerp = self:GetVirusCircleManager().IsLerpCirle(self.VirusCircleBaseParams)
  if isLerp == false then
    return self.VirusCircleBaseParams.centerPoint
  end
  return self:GetVirusCircleManager().GetLerpStartPoint(self.VirusCircleBaseParams)
end

function VirusCircle_Scene:GetCreateVirusCircleScale()
  local isLerp = self:GetVirusCircleManager().IsLerpCirle(self.VirusCircleBaseParams)
  local scaleWidth = self.VirusCircleBaseParams.width
  if isLerp then
    scaleWidth = self:GetVirusCircleManager().GetLerpStartWidth(self.VirusCircleBaseParams)
  end
  return Vector3(scaleWidth * 0.1, self.virusCircleLocalScaleY, scaleWidth * 0.1)
end

function VirusCircle_Scene:TryTweenVirusCircle()
  if self.VirusCircle == nil or self:GetVirusCircleManager().IsLerpCirle(self.VirusCircleBaseParams) == false then
    return
  end
  local remainTime = self:GetVirusCircleManager().GetRemainTime(self.VirusCircleBaseParams)
  if remainTime <= 0 then
    return
  end
  self:StopVirusCircleChangeTween()
  self.LoopTimer = Timer.StartLoopForever(0.02, self.VirusCircleChangeTween, self)
end

function VirusCircle_Scene:VirusCircleChangeTween()
  local lerpWidth = self:GetVirusCircleManager().GetLerpStartWidth(self.VirusCircleBaseParams)
  local pos = Scene.GetPosByCell(self:GetCreateVirusCircleCenterPoint())
  local isEnd = lerpWidth <= self.VirusCircleBaseParams.width
  self.VirusCircle.EffectObj.transform.localPosition = Vector3(pos.x, 0, pos.z)
  self.VirusCircle.EffectObj.transform.localScale = Vector3(lerpWidth * 0.1, self.virusCircleLocalScaleY, lerpWidth * 0.1)
  if isEnd then
    self:StopVirusCircleChangeTween()
  end
end

function VirusCircle_Scene:StopVirusCircleChangeTween()
  if self.LoopTimer ~= nil then
    Timer.Stop(self.LoopTimer)
    self.LoopTimer = nil
  end
end

function VirusCircle_Scene:RemoveVirusCircle()
  self:StopVirusCircleChangeTween()
  if self.VirusCircle ~= nil and self.VirusCircle.EffectData ~= nil then
    SceneUtility.RemoveSceneEffect(self.VirusCircle.EffectData.Id)
    self.VirusCircle = nil
  end
end

return VirusCircle_Scene

local SceneEffectData = {}
SceneEffectData.Id = nil
SceneEffectData.ServerData = nil
SceneEffectData.EffectPosition = nil
SceneEffectData.EffectRotation = nil
SceneEffectData.EffectScale = nil
SceneEffectData.EffectTbl = nil
SceneEffectData.AnalysisState = nil
SceneEffectData.LoadedCallBack = nil

function SceneEffectData:RefreshData(data)
  self:ResetData()
  if self:AnalysisParams(data) == false then
    return
  end
  self.EffectPosition = Scene.GetPosByCell({
    x = self.ServerData.x,
    y = self.ServerData.y
  })
  if data.positionY ~= nil then
    self.EffectPosition = Vector3.New(self.EffectPosition.x, data.positionY, self.EffectPosition.z)
  end
  local effectComplexData = ClientTable.cfg_EffectsManager:TryGetComplexData(data.effectId)
  if effectComplexData ~= nil then
    self.EffectRotation = effectComplexData.Rotation
    self.EffectScale = effectComplexData.Scale
  end
  if self.ServerData ~= nil and self.ServerData.dir ~= nil and self.ServerData.dir >= 0 then
    local angle = Direction8Utility:GetAngleByDir(self.ServerData.dir)
    if self.EffectRotation == nil then
      self.EffectRotation = Vector3.New(0, 0, 0)
    end
    self.EffectRotation = Vector3.New(self.EffectRotation.x, angle, self.EffectRotation.z)
  end
  if effectComplexData ~= nil and effectComplexData.tbl.angle and RoleManager.me.TargetAvatar then
    local target1 = Vector2.New(RoleManager.me.TargetAvatar.cellPos.x, RoleManager.me.TargetAvatar.cellPos.y)
    local target2 = Vector2.New(self.ServerData.x, self.ServerData.y)
    local tar = Vector2.Angle(target2, target1)
    self.EffectRotation = Vector3.New(0, tar, 0)
  end
  if effectComplexData ~= nil and effectComplexData.tbl.correctionGround ~= nil then
    local x, y, z = Scene.GetPosXYZByCell({
      x = self.ServerData.x,
      y = self.ServerData.y
    })
    self.EffectPosition = Vector3.New(x, y, z)
  end
  self.LoadedCallBack = data.createCallBack
  self.Id = data.id
end

function SceneEffectData:ResetData()
  self.ServerData = nil
  self.EffectPosition = nil
  self.EffectRotation = nil
  self.EffectScale = nil
  self.EffectTbl = nil
  self.LoadedCallBack = nil
end

function SceneEffectData:AnalysisParams(data)
  if data == nil or data.effectId == nil then
    self.AnalysisState = false
    return false
  end
  self.EffectTbl = ClientTable.cfg_EffectsManager:TryGetValue(data.effectId)
  if self.EffectTbl == nil then
    logError("B\225\186\163ng Effects ch\198\176a c\225\186\165u h\195\172nh id hi\225\187\135u \225\187\169ng" .. data.effectId)
    self.AnalysisState = false
    return false
  end
  self.ServerData = data
  self.AnalysisState = true
  return true
end

function SceneEffectData:GetEffectPath()
  if self.EffectTbl == nil or type(self.EffectTbl.fileType) ~= "number" or type(self.EffectTbl.name) ~= "string" then
    return
  end
  local fileTypePath = SceneEffectPath[self.EffectTbl.fileType]
  if string.isNullOrEmpty(fileTypePath) then
    return
  end
  return fileTypePath .. self.EffectTbl.name .. ".prefab"
end

return SceneEffectData

local SceneEffectObj = {}
SceneEffectObj.ModelGreater = nil
SceneEffectObj.EffectData = nil
SceneEffectObj.RootObj = nil
SceneEffectObj.EffectObj = nil

function SceneEffectObj:RefreshModel(data, rootObj)
  if data == nil then
    return
  end
  self.EffectData = data
  self.RootObj = rootObj
  self:ControlShowState(true)
  self:TryCreateModelGreater()
  self:LoadEffectModel()
  self:TimeEndDestroy()
  self:MainPlayerWithEffectPosition()
end

function SceneEffectObj:TryCreateModelGreater()
  if self.ModelGreater == nil then
    self.ModelGreater = CS.Framework.GameModel(self.EffectData.EffectTbl.name, self.RootObj, function(effectObj, name)
      self:EffectLoadCallBack(effectObj, name)
    end)
  else
    self.ModelGreater.gameObject.name = self.EffectData.EffectTbl.name
  end
end

function SceneEffectObj:LoadEffectModel()
  local effectPath = self.EffectData:GetEffectPath()
  if string.isNullOrEmpty(effectPath) then
    return
  end
  if self.ModelGreater.Path == effectPath then
    self:EffectLoadCallBack(self.ModelGreater.modelObject)
    return
  end
  self.ModelGreater:LoadAsync(effectPath)
end

function SceneEffectObj:EffectLoadCallBack(effectObj, name)
  self.EffectObj = effectObj
  if IsNil(effectObj) then
    return
  end
  effectObj.transform.localPosition = self.EffectData.EffectPosition
  if self.EffectData.EffectRotation ~= nil then
    effectObj.transform.localEulerAngles = self.EffectData.EffectRotation
  end
  if self.EffectData.EffectScale ~= nil then
    effectObj.transform.localScale = self.EffectData.EffectScale
  end
  if self.EffectData.LoadedCallBack ~= nil then
    self.EffectData.LoadedCallBack(self)
  end
end

function SceneEffectObj:TimeEndDestroy()
  if type(self.EffectData.EffectTbl.effectTime) ~= "number" or self.EffectData.EffectTbl.effectTime <= 0 then
    return
  end
  self:ResetTimer()
  self.autoDestroy = Timer.Start(self.EffectData.EffectTbl.effectTime * 0.001, SceneEffectObj.NoticeDestroy, self)
end

function SceneEffectObj:NoticeDestroy()
  gameMgr:GetSceneManager():GetSceneDataManager():GetSceneEffectDataManager():RemoveEffectById(self.EffectData.Id)
end

function SceneEffectObj:MainPlayerWithEffectPosition()
  if self.EffectData.EffectTbl.blankScreen ~= 1 then
    return
  end
  if type(self.EffectData.EffectTbl.effectTime) ~= "number" or self.EffectData.EffectTbl.effectTime <= 0 then
    return
  end
  RoleManager.me:SetMainPlayerPosition(self.EffectData.EffectTbl.effectTime * 0.001, self.EffectData.EffectPosition)
end

function SceneEffectObj:ResetTimer()
  if self.autoDestroy == nil then
    return
  end
  Timer.Stop(self.autoDestroy)
  self.autoDestroy = nil
end

function SceneEffectObj:Hide()
  self:ControlShowState(false)
end

function SceneEffectObj:Destroy()
  if self.ModelGreater ~= nil then
    self.ModelGreater:Destroy()
  end
  self.ModelGreater = nil
  self.EffectData = nil
  self:ResetTimer()
end

function SceneEffectObj:ControlShowState(state)
  if type(state) ~= "boolean" then
    return
  end
  if self.ModelGreater ~= nil and IsNil(self.ModelGreater.gameObject) == false then
    self.ModelGreater.gameObject:SetActive(state)
  end
end

return SceneEffectObj

FireworksEffect = class(EffectNew)

function FireworksEffect:GetName()
  return "Ph\195\161o Hoa"
end

function FireworksEffect:GetParent()
  return MapEffectManager.root
end

function FireworksEffect:DestroyImmediately()
  MapEffectManager.DestroyMapEffectById(self.data.id)
end

function FireworksEffect:InitModel()
  self.model = EffectModel(self.transform, nil, self.data)
  self.model.OnLoadModel = bind(self, self.OnLoadEffectModelComplete)
  self.model:Init()
  
  local function SetModel()
    self:SetModel()
  end
  
  self.fireworksTimer = Timer.StartLoop(self.data.timerInterval, 1, SetModel)
  self.model:SetLayer(self:GetModelLayer())
end

function FireworksEffect:OnLoadEffectModelComplete(go, name)
  local function Destroy()
    self:DestroyImmediately()
  end
  
  self.autoDestroy = Timer.Start(5, Destroy)
end

function FireworksEffect:SetModel()
  self.model:SetModel(self:GetModelScale())
end

function FireworksEffect:Destroy()
  self:DestroyModel()
  self:DestroyGameObject()
  self:DestroyTimer()
end

function FireworksEffect:DestroyTimer()
  if self.fireworksTimer then
    Timer.Stop(self.fireworksTimer)
    self.fireworksTimer = nil
  end
  if self.autoDestroy then
    Timer.Stop(self.autoDestroy)
    self.autoDestroy = nil
  end
end

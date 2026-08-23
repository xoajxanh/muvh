local EffectManager = {}

function EffectManager:GetBuffEffectProcessor()
  if self.mBuffEffectProcessor == nil then
    self.mBuffEffectProcessor = LuaClass.EffectProcessor_Buff:New()
    self.mBuffEffectProcessor:Initializer(LuaClass.EffectObject_Buff)
  end
  return self.mBuffEffectProcessor
end

function EffectManager:GetUIEffectProcessor()
  if self.mUIEffectProcessor == nil then
    self.mUIEffectProcessor = LuaClass.EffectProcessor:New()
    self.mUIEffectProcessor:Initializer(LuaClass.EffectObject_UI)
  end
  return self.mUIEffectProcessor
end

function EffectManager:GetUIModelProcessor()
  if self.mUIModelProcessor == nil then
    self.mUIModelProcessor = LuaClass.EffectProcessor:New()
    self.mUIModelProcessor:Initializer(LuaClass.EffectObject_UIModel)
  end
  return self.mUIModelProcessor
end

function EffectManager:GetTitleProcessor()
  if self.mTitleProcessor == nil then
    self.mTitleProcessor = LuaClass.EffectProcessor:New()
    self.mTitleProcessor:Initializer(LuaClass.EffectObject_Title)
  end
  return self.mTitleProcessor
end

function EffectManager:GetUITitleProcessor()
  if self.mUITitleProcessor == nil then
    self.mUITitleProcessor = LuaClass.EffectProcessor:New()
    self.mUITitleProcessor:Initializer(LuaClass.EffectObject_UITitle)
  end
  return self.mUITitleProcessor
end

function EffectManager:GetEffectActionUtility()
  if self.mEffectActionUtility == nil then
    self.mEffectActionUtility = LuaClass.EffectActionUtility:New()
  end
  return self.mEffectActionUtility
end

function EffectManager:GetProcessor(type)
  if type == EffectProcessorType.BUFF then
    return self:GetBuffEffectProcessor()
  elseif type == EffectProcessorType.UI_EFFECT then
    return self:GetUIEffectProcessor()
  elseif type == EffectProcessorType.UI_Model then
    return self:GetUIModelProcessor()
  elseif type == EffectProcessorType.Title then
    return self:GetTitleProcessor()
  elseif type == EffectProcessorType.UI_Title then
    return self:GetUITitleProcessor()
  end
end

function EffectManager:RemoveAllProcessor()
  for k, v in pairs(self) do
    if type(v) == "table" and v.Destroy ~= nil then
      v:Destroy()
    end
  end
end

return EffectManager

local PromptDataManager = {}

function PromptDataManager:GetDeadStrengthenPromptDataManager()
  if self.mDeadStrengthenPromptDataManager == nil then
    self.mDeadStrengthenPromptDataManager = LuaClass.DeadStrengthenPromptDataManager:New()
  end
  return self.mDeadStrengthenPromptDataManager
end

function PromptDataManager:OnDestruct()
  self:GetDeadStrengthenPromptDataManager():OnDestruct()
end

return PromptDataManager

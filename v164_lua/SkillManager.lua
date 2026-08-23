local SkillManager = {}

function SkillManager:GetSKillGroupAdditionManager()
  if self.mSKillGroupAdditionManager == nil then
    self.mSKillGroupAdditionManager = LuaClass.SkillGroupAdditionManager:New()
  end
  return self.mSKillGroupAdditionManager
end

return SkillManager

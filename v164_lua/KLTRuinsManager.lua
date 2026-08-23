local KLTRuinsManager = {}

function KLTRuinsManager:GetVirusCircleManager()
  if self.mVirusCircleManager == nil then
    self.mVirusCircleManager = LuaClass.VirusCircleManager:New()
  end
  return self.mVirusCircleManager
end

function KLTRuinsManager:GetKLTSettleManager()
  if self.mKLTSettleManager == nil then
    self.mKLTSettleManager = LuaClass.KLTSettleManager:New()
  end
  return self.mKLTSettleManager
end

function KLTRuinsManager:Exit()
  self:GetVirusCircleManager():Remove()
end

return KLTRuinsManager

local MainPlayer = {}
setmetatable(MainPlayer, LuaClass.Player)

function MainPlayer:GetInfo()
  if self.mainPlayerInfo == nil then
    self.mainPlayerInfo = LuaClass.MainPlayerData:New()
  end
  return self.mainPlayerInfo
end

function MainPlayer:GetMe()
  return RoleManager.me
end

function MainPlayer:GetInComeOnHookPointMgr()
  if self.mInComeOnHookPointMgr == nil then
    self.mInComeOnHookPointMgr = LuaClass.InComeOnHookPointManager:New()
  end
  return self.mInComeOnHookPointMgr
end

function MainPlayer:GetExperienceBonusMgr()
  if self.mExperienceBonusMgr == nil then
    self.mExperienceBonusMgr = LuaClass.LuaExperienceBonusDataManager:New()
  end
  return self.mExperienceBonusMgr
end

function MainPlayer:GetMasterSkillDataMgr()
  if self.mMasterSkillDataMgr == nil then
    self.mMasterSkillDataMgr = LuaClass.MasterSkillDataMgr:New()
  end
  return self.mMasterSkillDataMgr
end

function MainPlayer:GetSkillManager()
  if self.mSkillManager == nil then
    self.mSkillManager = LuaClass.SkillManager:New()
  end
  return self.mSkillManager
end

function MainPlayer:GetAppear_CoutureManager()
  if self.mAppear_CoutureData == nil then
    self.mAppear_CoutureData = LuaClass.Appear_CoutureData:New()
  end
  return self.mAppear_CoutureData
end

function MainPlayer:GetCoalitionInfo()
  if self.mCoalitionId ~= nil then
    return gameMgr:GetCoalitionManager():GetCoalitionInfo(self.mCoalitionId)
  end
end

function MainPlayer:GetWarAllianceData()
  return WarAllianceData
end

function MainPlayer:SetCoalitionId(id)
  self.mCoalitionId = id
end

function MainPlayer:GetPrivilegeMgr()
  if self.mPrivilegeMgr == nil then
    self.mPrivilegeMgr = LuaClass.PrivilegeManager:New()
  end
  return self.mPrivilegeMgr
end

function MainPlayer:Init()
end

function MainPlayer:RefreshData(data)
  self:GetInfo():RefreshOtherAttr(data)
end

return MainPlayer

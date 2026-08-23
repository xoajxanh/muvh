local GameMgr = {}
local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode

function GameMgr:GetAvatarManager()
  if self.mAvatarManager == nil then
    self.mAvatarManager = LuaClass.AvatarManager:New()
  end
  return self.mAvatarManager
end

function GameMgr:GetSceneManager()
  if self.mSceneManager == nil then
    self.mSceneManager = LuaClass.SceneManager:New()
  end
  return self.mSceneManager
end

function GameMgr:GetMapManager()
  if self.mMapManager == nil then
    self.mMapManager = LuaClass.MapManager:New()
  end
  return self.mMapManager
end

function GameMgr:GetPromptDataManager()
  if self.mPromptDataManager == nil then
    self.mPromptDataManager = LuaClass.PromptDataManager:New()
  end
  return self.mPromptDataManager
end

function GameMgr:GetGameBookMgr()
  if self.mGameBookMgr == nil then
    self.mGameBookMgr = LuaClass.GameBookMgr:New()
  end
  return self.mGameBookMgr
end

function GameMgr:GetMinMapDataMgr()
  if self.mMinMapDataMgr == nil then
    self.mMinMapDataMgr = LuaClass.MinMapDataMgr:New()
  end
  return self.mMinMapDataMgr
end

function GameMgr:GetGMDataMgr()
  if self.mGMDataMgr == nil then
    self.mGMDataMgr = LuaClass.GMDataManager:New()
  end
  return self.mGMDataMgr
end

function GameMgr:GetCoalitionManager()
  if self.mCoalitionManager == nil then
    self.mCoalitionManager = LuaClass.CoalitionManager:New()
  end
  return self.mCoalitionManager
end

function GameMgr:GetGlobalActivityDataManager()
  if self.mGlobalActivityDataManager == nil then
    self.mGlobalActivityDataManager = LuaClass.GlobalActivityDataManager:New()
  end
  return self.mGlobalActivityDataManager
end

function GameMgr:GetGlobalActivityDataManager()
  if self.mGlobalActivityDataManager == nil then
    self.mGlobalActivityDataManager = LuaClass.GlobalActivityDataManager:New()
  end
  return self.mGlobalActivityDataManager
end

function GameMgr:GetRoleCircleEffectMgr()
  if self.mRoleCircleEffectManager == nil then
    self.mRoleCircleEffectManager = LuaClass.RoleCircleEffectManager:New()
  end
  return self.mRoleCircleEffectManager
end

function GameMgr:GetEffectManager()
  if self.mEffectManager == nil then
    self.mEffectManager = LuaClass.EffectManager:New()
  end
  return self.mEffectManager
end

function GameMgr:GetFunctionDisableManager()
  if self.mFunctionDisableManager == nil then
    self.mFunctionDisableManager = LuaClass.FunctionDisableManager:New()
  end
  return self.mFunctionDisableManager
end

function GameMgr:Initialize()
  self.mRoleCircleEffectManager = LuaClass.RoleCircleEffectManager:New()
end

function GameMgr:EnterGame()
  self:GetGlobalActivityDataManager():EnterGame()
end

function GameMgr:Update()
  self:GetGlobalActivityDataManager():Update()
end

function GameMgr:Logout()
  LoginController.SetIsAgreePrivacyPolicy(false)
  self:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager():Remove()
  self:GetAvatarManager():OnDestruct()
  self:GetMapManager():Logout()
  self:GetSceneManager():OnDestruct()
  self:GetPromptDataManager():OnDestruct()
  ItemCombineData:ResetCombineData()
  UIManager.Logout()
  self:GetGlobalActivityDataManager():ResetAllActivity()
  self:GetRoleCircleEffectMgr():RemoveAll()
  self:GetEffectManager():RemoveAllProcessor()
  self:GetAvatarManager():GetMainPlayer():GetPrivilegeMgr():Destroy()
  KillNoticeMgr:Clear()
  GameLogic.LeaveGame()
  self:GetFunctionDisableManager():Destroy()
  ViewData.meData:ResetData()
end

function GameMgr:TimeAcrossDay()
  self:GetGlobalActivityDataManager():RefreshTimeAcrossDay()
  LoginData.TimeAcrossDay()
end

return GameMgr

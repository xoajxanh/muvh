local AvatarManager = {}
require("GameConst/AvatarEnum")
AvatarManager.AvatarDic = nil
AvatarManager.MeID = 0

function AvatarManager:GetMainPlayer()
  if self.mainPlayer == nil then
    self.mainPlayer = LuaClass.MainPlayer:New()
  end
  return self.mainPlayer
end

function AvatarManager:ClearMainPlayer()
  self.mainPlayer = nil
  self.MeID = 0
end

function AvatarManager:GetOtherPlayer()
  if self.otherPlayer == nil then
    self.otherPlayer = LuaClass.OtherPlayer:New()
  end
  return self.otherPlayer
end

function AvatarManager:RefreshAvatarDic(resUpdateViewData)
  if type(resUpdateViewData) ~= "table" then
    return
  end
  if type(resUpdateViewData.exitIds) == "table" then
    for k, v in pairs(resUpdateViewData.exitIds) do
      self:RemoveAvatar(v)
    end
  end
  if type(resUpdateViewData.addPlayers) == "table" then
    for k, v in pairs(resUpdateViewData.addPlayers) do
      local playerData = v
      if playerData.info ~= nil then
        self:AddAvatar(AvatarEnum.Player, playerData.info.roleId, playerData)
      end
    end
  end
  if type(resUpdateViewData.addMonsters) == "table" then
    for k, v in pairs(resUpdateViewData.addMonsters) do
      local monsterData = v
      self:AddAvatar(AvatarEnum.Monster, monsterData.id, monsterData)
    end
    EventManager.Dispatch(Event.MonstersEnterView, resUpdateViewData.addMonsters)
  end
  if type(resUpdateViewData.addNpcs) == "table" then
    for k, v in pairs(resUpdateViewData.addNpcs) do
      local npcData = v
      self:AddAvatar(AvatarEnum.Npc, npcData.id, npcData)
    end
  end
end

function AvatarManager:AddAvatar(avatarType, Lid, data)
  if type(avatarType) ~= "number" or type(Lid) ~= "number" then
    return
  end
  if self.AvatarDic == nil then
    self.AvatarDic = {}
  end
  if self.AvatarDic[avatarType] == nil then
    self.AvatarDic[avatarType] = {}
  end
  local avatar = self.MeID == Lid and QuickFind.LuaMainPlayer() or self.AvatarDic[avatarType][Lid]
  if avatar == nil then
    if avatarType == AvatarEnum.Player then
      if Lid == self.MeID then
        avatar = QuickFind.LuaMainPlayer()
      else
        avatar = LuaClass.Player:New()
      end
    elseif avatarType == AvatarEnum.Monster then
      avatar = LuaClass.Monster:New()
    elseif avatarType == AvatarEnum.Npc then
      avatar = LuaClass.Npc:New()
    elseif avatarType == AvatarEnum.Pet then
      avatar = LuaClass.Pet:New()
    end
  end
  self.AvatarDic[avatarType][Lid] = avatar
  avatar:RefreshData(data)
  EventManager.Dispatch(Event.UnionCampChange, data)
end

function AvatarManager:GetMeAvatarDic()
  if self.AvatarDic == nil then
    self.AvatarDic = {}
  end
  if self.AvatarDic[AvatarEnum.Player] == nil then
    self.AvatarDic[AvatarEnum.Player] = {}
  end
  local avatar = self.AvatarDic[AvatarEnum.Player][self.MeID]
  if avatar == nil then
    avatar = LuaClass.Player:New()
  end
  self.AvatarDic[AvatarEnum.Player][self.MeID] = avatar
  return avatar
end

function AvatarManager:RemoveAvatar(lid, avatarType)
  if type(self.AvatarDic) ~= "table" then
    return
  end
  local specifyType = type(avatarType) == "number"
  if specifyType then
    local avatarList = self.AvatarDic[avatarType]
    if type(avatarList) ~= "table" then
      return
    end
    avatarList[lid]:Destroy()
    avatarList[lid] = nil
  else
    for k, v in pairs(self.AvatarDic) do
      local avatarList = v
      if avatarList[lid] ~= nil then
        avatarList[lid]:Destroy()
        avatarList[lid] = nil
        return
      end
    end
  end
end

function AvatarManager:RemoveAllAvatar()
  if type(self.AvatarDic) ~= "table" then
    return
  end
  for k, v in pairs(self.AvatarDic) do
    local avatarList = v
    for i, v in pairs(avatarList) do
      v:Destroy()
      v = nil
    end
  end
  gameMgr:GetAvatarManager():GetMainPlayer():Destroy()
  gameMgr:GetAvatarManager():ClearMainPlayer()
end

function AvatarManager:GetAvatarByType(avatarType)
  if type(self.AvatarDic) ~= "table" or type(avatarType) ~= "number" then
    return {}
  end
  return self.AvatarDic[avatarType] or {}
end

function AvatarManager:GetAvatar(avatarType, lid)
  if type(self.AvatarDic) ~= "table" or type(avatarType) ~= "number" or type(lid) ~= "number" then
    return
  end
  self.avatarList = self.AvatarDic[avatarType]
  if type(self.avatarList) ~= "table" then
    return
  end
  return self.avatarList[lid]
end

return AvatarManager

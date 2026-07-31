local RedPointDataManager = {}

function RedPointDataManager:GetRedPointInfoDic()
  if self.mRedPointInfoDic == nil then
    self.mRedPointInfoDic = {}
  end
  return self.mRedPointInfoDic
end

function RedPointDataManager:GetRedPointIdListByTypeDic()
  if self.mRedPointIdListByTypeDic == nil then
    self.mRedPointIdListByTypeDic = {}
  end
  return self.mRedPointIdListByTypeDic
end

function RedPointDataManager:GetNeedRefreshIDCacheList()
  if self.idCacheList == nil then
    self.idCacheList = {}
  end
  return self.idCacheList
end

function RedPointDataManager:Initialize()
  self:InitPatams()
  self:InitData()
end

function RedPointDataManager:InitPatams()
  self.maxDoForCount = 10
  self.curId = 0
  self.cacheCount = 0
  self.curData = nil
  self.isBreak = false
  self.doRefresh = false
end

function RedPointDataManager:InitData()
  local dic = ClientTable.cfg_Red_pointManager:GetDic()
  if dic == nil then
    return
  end
  local key
  for k, v in pairs(dic) do
    if v then
      if self:GetRedPointInfoDic()[k] == nil then
        self:GetRedPointInfoDic()[k] = LuaClass.RedPointData:New(v)
      end
      if v.Type then
        key = tonumber(v.Type)
        if key then
          if self:GetRedPointIdListByTypeDic()[key] == nil then
            self:GetRedPointIdListByTypeDic()[key] = {}
          end
          table.insert(self:GetRedPointIdListByTypeDic()[key], k)
        end
      end
    end
  end
end

function RedPointDataManager:RefreshRedPointById(id)
  local count = table.count(self:GetNeedRefreshIDCacheList())
  for i = 1, count do
    if self:GetNeedRefreshIDCacheList()[i] == id then
      return
    end
  end
  table.insert(self:GetNeedRefreshIDCacheList(), id)
  if not self.doRefresh then
    self.doRefresh = true
  end
end

function RedPointDataManager:RefreshRedPointByPointType(type)
  local idList = self:GetRedPointIdListByTypeDic()[type]
  if idList and table.count(idList) > 0 then
    local count = table.count(idList)
    for i = 1, count do
      if self:CheckNeedAdd(idList[i]) then
        table.insert(self:GetNeedRefreshIDCacheList(), idList[i])
      end
    end
  end
  if not self.doRefresh then
    self.doRefresh = true
  end
end

function RedPointDataManager:RefreshAllRedPoint()
  if self.doRefresh then
    self.isBreak = true
    self.doRefresh = false
    table.remove(self.idCacheList)
  end
  self.idCacheList = {}
  for k, v in pairs(self:GetRedPointInfoDic()) do
    table.insert(self.idCacheList, k)
  end
  self.doRefresh = true
end

function RedPointDataManager:AddGoEventCallBackByClient(msg)
  if self:GetRedPointInfoDic()[msg.id] then
    self:GetRedPointInfoDic()[msg.id]:AddRedPointByClient(msg)
  end
end

function RedPointDataManager:RemoveGoEventCallBackByClient(msg)
  if self:GetRedPointInfoDic()[msg.id] then
    self:GetRedPointInfoDic()[msg.id]:RemoveRedPointByClient(msg)
  end
end

function RedPointDataManager:Update()
  if self.doRefresh then
    self:DoFor()
  end
end

function RedPointDataManager:DoFor()
  self.cacheCount = table.count(self:GetNeedRefreshIDCacheList())
  if self.cacheCount > 0 and RoleManager.me then
    self.cacheCount = self.cacheCount > self.maxDoForCount and self.maxDoForCount or self.cacheCount
    for i = 1, self.maxDoForCount do
      if self.isBreak then
        self.isBreak = false
        return
      end
      self.curId = self:GetNeedRefreshIDCacheList()[1]
      self.curData = self:GetRedPointInfoDic()[self.curId]
      if self.curData then
        self.curData:TryRefeshState()
      end
      table.remove(self:GetNeedRefreshIDCacheList(), 1)
    end
    if table.count(self:GetNeedRefreshIDCacheList()) == 0 then
      self.doRefresh = false
    end
  end
end

function RedPointDataManager:CheckNeedAdd(id)
  local count = table.count(self:GetNeedRefreshIDCacheList())
  for i = 1, count do
    if self:GetNeedRefreshIDCacheList()[i] == id then
      return false
    end
  end
  return true
end

function RedPointDataManager:Destroy()
  for i, v in pairs(self) do
    self[i] = nil
  end
end

return RedPointDataManager

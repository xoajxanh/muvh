local RedPointManager = {}

function RedPointManager:Initialize()
  self:InitParams()
  self:BindClientEvent()
end

function RedPointManager:InitParams()
  self.messageContainer = EventContainer(NetManager)
  self.eventContainer = EventContainer(EventManager)
  self.isLog = false
end

function RedPointManager:BindClientEvent()
  self.eventContainer:Regist(Event.RP_RedPointRefresh, self.OldRefreshRedPointCallBack, self)
  self.eventContainer:Regist(Event.CallRefreshRedPoint, self.CallRefreshRedPointCallBack, self)
  self.eventContainer:Regist(Event.CallRefreshAllRedPoint, self.CallRefreshAllCallBack, self)
  self.eventContainer:Regist(Event.AddRedPointGoByExcel, self.AddRedPointGoCallBack, self)
  self.eventContainer:Regist(Event.AddRedPointGoByClient, self.AddRedPointGoCallBackByClient, self)
  self.eventContainer:Regist(Event.RemoveRedPointGoByClient, self.RemoveRedPointGoCallBackByClient, self)
  self.eventContainer:Regist(Event.RefreshRedPointGo, self.RefreshRedPointGoCallBack, self)
  self.eventContainer:Regist(Event.UI_Show, self.ShowUICallBack, self)
end

function RedPointManager:OldRefreshRedPointCallBack(id, msg)
  if msg and msg.index then
    self:RefreshRedPointStateByType(msg.index)
  end
end

function RedPointManager:CallRefreshRedPointCallBack(id, msg)
  if msg == nil then
    return
  end
  if msg.id then
    self:RefreshRedPointStateById(msg.id)
  end
  if msg.type then
    self:RefreshRedPointStateByType(msg.type)
  end
end

function RedPointManager:CallRefreshAllCallBack()
  RedPointDataManager:RefreshAllRedPoint()
end

function RedPointManager:AddRedPointGoCallBack(id, msg)
  if msg then
    RedPointGoManager:AddGoEventCallBack(msg)
  end
end

function RedPointManager:AddRedPointGoCallBackByClient(id, msg)
  if msg then
    if IsNil(msg.go) then
      logError("L\225\187\151i khi th\195\170m ch\225\186\165m \196\145\225\187\143, Error: Object reference not set to an instance of an object path:" .. msg.path)
      return
    end
    local uiTbl = string.split(msg.path, "#")
    if table.count(uiTbl) < 2 or UIManager.GetUiByName(uiTbl[1]) == nil then
      logError("L\225\187\151i khi th\195\170m ch\225\186\165m \196\145\225\187\143, Error: Incorrect path format path:" .. msg.path)
      return
    end
    RedPointGoManager:AddGoEventCallBackByClient(msg)
    RedPointDataManager:AddGoEventCallBackByClient(msg)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = msg.id
    })
  end
end

function RedPointManager:RemoveRedPointGoCallBackByClient(id, msg)
  if msg then
    RedPointGoManager:RemoveGoEventCallBackByClient(msg)
    RedPointDataManager:RemoveGoEventCallBackByClient(msg)
  end
end

function RedPointManager:RefreshRedPointGoCallBack(id, msg)
  if msg then
    RedPointGoManager:TryRefreshGoEventCallBack(msg)
  end
end

function RedPointManager:ShowUICallBack(id, msg)
  if msg and not string.isNullOrEmpty(msg.name) then
    local tbl = RedPointGoManager:TryGetPointIdListByUIName(msg.name)
    if tbl and table.count(tbl) > 0 then
      for i, v in pairs(tbl) do
        self:RefreshRedPointStateById(v)
      end
    end
  end
end

function RedPointManager:RefreshRedPointStateById(id)
  RedPointDataManager:RefreshRedPointById(id)
end

function RedPointManager:RefreshRedPointStateByType(type)
  RedPointDataManager:RefreshRedPointByPointType(type)
end

function RedPointManager:GetCacheStateByPath(_path)
  return RedPointGoManager:GetCacheStateByPath(_path)
end

function RedPointManager.GedRedIdListByGo(_go)
  return RedPointGoManager:GedRedIdListByGo(_go)
end

function RedPointManager:Update()
  RedPointDataManager:Update()
end

function RedPointManager:Destroy()
  self.eventContainer:UnRegistAll()
  RedPointDataManager:Destroy()
  RedPointGoManager:Destroy()
  RedPointChecker_Ext:Destory()
  for i, v in pairs(self) do
    self[i] = nil
  end
end

return RedPointManager

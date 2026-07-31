local HideUIPointByMapIdMgr = {}

function HideUIPointByMapIdMgr:LastHideUIPointDic()
  if self.mLastHideUIPointDic == nil then
    self.mLastHideUIPointDic = {}
  end
  return self.mLastHideUIPointDic
end

function HideUIPointByMapIdMgr:WaitHideUIPointInfoList()
  if self.mWaitHideUIPointInfoList == nil then
    self.mWaitHideUIPointInfoList = {}
  end
  return self.mWaitHideUIPointInfoList
end

function HideUIPointByMapIdMgr:HideUIPointMapRule()
  if self.mHideUIPointMapRule == nil then
    self.mHideUIPointMapRule = {}
  end
  return self.mHideUIPointMapRule
end

function HideUIPointByMapIdMgr:HideUIPointRuleDic()
  if self.mHideUIPointRuleDic == nil then
    self.mHideUIPointRuleDic = {}
  end
  return self.mHideUIPointRuleDic
end

function HideUIPointByMapIdMgr:Init()
  self:InitParam()
  self:InitHideRule()
  self:BindEventMsg()
end

function HideUIPointByMapIdMgr:InitParam()
  self.lastMapId = nil
  self.eventContainer = EventContainer(EventManager)
end

function HideUIPointByMapIdMgr:InitHideRule()
  local mapRule = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(302)
  mapRule = TableParse:SplitStringToIntListList(mapRule, "&", "#")
  if next(mapRule) == nil then
    return
  end
  local uiPointRule, uiPointRuleTbl, uiPointInfo
  for i, v in pairs(mapRule) do
    if v and table.count(v) > 1 then
      self:HideUIPointMapRule()[v[1]] = v[2]
      if self:HideUIPointRuleDic()[v[2]] == nil then
        uiPointRule = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(v[2])
        uiPointRule = TableParse:SplitStringToStrList(uiPointRule, "&")
        uiPointRuleTbl = {}
        for i1, v1 in pairs(uiPointRule) do
          uiPointInfo = TableParse:SplitStringToStrList(v1, "#")
          if table.count(uiPointInfo) > 1 then
            table.insert(uiPointRuleTbl, {
              uiName = uiPointInfo[1],
              pointName = uiPointInfo[2]
            })
          end
        end
        self:HideUIPointRuleDic()[v[2]] = uiPointRuleTbl
      end
    end
  end
end

function HideUIPointByMapIdMgr:BindEventMsg()
  self.eventContainer:Regist(Event.Scene_SceneDataChange, self.Scene_SceneDataChangeCallBack, self)
  self.eventContainer:Regist(Event.UI_Show, self.ShowUICallBack, self)
  self.eventContainer:Regist(Event.MainChatPanelIsCreate, self.HideUIPointByRule, self)
end

function HideUIPointByMapIdMgr:Scene_SceneDataChangeCallBack(id, mapid)
  self:TryHideUIPointByMapId(mapid)
end

function HideUIPointByMapIdMgr:ShowUICallBack(id, msg)
  if msg == nil or string.isNullOrEmpty(msg.name) then
    return
  end
  local pointGo, pointInfo
  local count = table.count(self:WaitHideUIPointInfoList())
  local acc = 0
  for i = 1, count do
    i = i + acc
    pointInfo = self:WaitHideUIPointInfoList()[i]
    if pointInfo and pointInfo.uiName == msg.name then
      pointGo = UIManager.GetGoByPoint(self:WaitHideUIPointInfoList()[i])
      if pointGo and not IsNil(pointGo.gameObject) then
        pointGo:SetActive(false)
        self:LastHideUIPointDic()[pointInfo] = pointGo
      end
      table.remove(self:WaitHideUIPointInfoList(), i)
      acc = acc - 1
    end
  end
end

function HideUIPointByMapIdMgr:TryHideUIPointByMapId(mapId)
  if mapId == self.lastMapId then
    return
  end
  self.lastMapId = mapId
  self:HideUIPointByRule()
end

function HideUIPointByMapIdMgr:HideUIPointByRule()
  self:ResetAllLastHidePointState()
  local curNeedHideUIPointDic = {}
  local uiPointRule = self:GetRuleByCurMapId()
  if uiPointRule == nil then
    return
  end
  local pointGo
  for i, v in pairs(uiPointRule) do
    pointGo = UIManager.GetGoByPoint(v)
    if pointGo and pointGo.gameObject == nil and pointGo.root ~= nil then
      pointGo = pointGo.root
    end
    if pointGo and not IsNil(pointGo.gameObject) then
      table.insert(curNeedHideUIPointDic, {pointInfo = v, go = pointGo})
    else
      table.insert(self:WaitHideUIPointInfoList(), v)
    end
  end
  for i, v in pairs(curNeedHideUIPointDic) do
    if v and v.go and not IsNil(v.go.gameObject) then
      v.go:SetActive(false)
      self:LastHideUIPointDic()[v.pointInfo] = v.go
    end
  end
end

function HideUIPointByMapIdMgr:ResetAllLastHidePointState()
  for i, v in pairs(self:LastHideUIPointDic()) do
    if v and not IsNil(v.gameObject) then
      v:SetActive(true)
    end
  end
  self.mLastHideUIPointDic = nil
  self.mWaitHideUIPointInfoList = nil
end

function HideUIPointByMapIdMgr:GetRuleByCurMapId()
  local uiPointRuleKey = self:HideUIPointMapRule()[self.lastMapId]
  if uiPointRuleKey == nil then
    return
  end
  local uiPointRule = self:HideUIPointRuleDic()[uiPointRuleKey]
  if uiPointRule == nil then
    return
  end
  return uiPointRule
end

function HideUIPointByMapIdMgr:IsHideByUIName(uiName)
  for i, v in pairs(self:LastHideUIPointDic()) do
    if i.uiName == uiName then
      return true
    end
  end
  for i, v in pairs(self:WaitHideUIPointInfoList()) do
    if v.uiName == uiName then
      return true
    end
  end
  return false
end

function HideUIPointByMapIdMgr:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

return HideUIPointByMapIdMgr

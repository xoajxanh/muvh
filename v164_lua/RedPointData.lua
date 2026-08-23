local RedPointData = {}

function RedPointData:GetId()
  return self.id
end

function RedPointData:GetType()
  return self.type
end

function RedPointData:GetTbl()
  return self.tbl
end

function RedPointData:GetPathList()
  if self.pathList == nil then
    self:RefreshGoDataByTbl()
  end
  return self.pathList
end

function RedPointData:Init(tbl)
  self:ResetData()
  self:InitData(tbl)
end

function RedPointData:InitData(tbl)
  self.tbl = tbl
  self.id = tbl.id
  self.type = tonumber(tbl.Type)
  self:RefreshGoDataByTbl()
end

function RedPointData:RefreshGoDataByTbl()
  if self:GetTbl() then
    self.pathList = {}
    self:AddGoPathByTblStr(self:GetTbl().uiName)
    self:AddGoPathByTblStr(self:GetTbl().parentPosition)
    self:AddGoPathByTblStr(self:GetTbl().childPosition)
  end
end

function RedPointData:AddRedPointByClient(msg)
  table.insert(self:GetPathList(), msg.path)
end

function RedPointData:RemoveRedPointByClient(msg)
  table.Remove(self:GetPathList(), msg.path)
end

function RedPointData:TryRefeshState()
  if RedPointChecker:IsNoProcessing(self:GetId()) then
    return
  end
  local state
  if not RedPointChecker:IsNeedNewProcess(self:GetId()) and self:GetTbl() ~= nil then
    state = RedPointChecker_Ext:JudgeUseMethod(self:GetTbl().uiName, self:GetTbl().parentPosition, self:GetTbl().childPosition, self:GetId())
  else
    state = RedPointChecker:CheckIsNeedShow(self:GetId(), self:GetType(), self:GetTbl().param)
  end
  self:SetPointState(state)
end

function RedPointData:SetPointState(state)
  local count = table.count(self:GetPathList())
  for i = 1, count do
    EventManager.Dispatch(Event.RefreshRedPointGo, {
      path = self:GetPathList()[i],
      id = self:GetId(),
      state = state
    })
  end
end

function RedPointData:AddGoPathByTblStr(str)
  local pathList, listCount
  if not string.isNullOrEmpty(str) then
    pathList = TableParse:SplitStringToStrList(str, "&")
    listCount = table.count(pathList)
    for i = 1, listCount do
      table.insert(self:GetPathList(), pathList[i])
      EventManager.Dispatch(Event.AddRedPointGoByExcel, {
        path = pathList[i],
        id = self:GetId()
      })
    end
  end
end

function RedPointData:ResetData()
  self.id = nil
  self.tbl = nil
  self.type = nil
  self.pathList = nil
  self.GoCount = nil
  self.pathData = nil
end

function RedPointData:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

return RedPointData

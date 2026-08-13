local UnionInfo = {}
UnionInfo.serverData = nil
UnionInfo.id = nil
UnionInfo.analysisState = nil

function UnionInfo:RefreshData(data)
  if self:AnalysisParams(data) == false then
    return
  end
end

function UnionInfo:AnalysisParams(data)
  if data == nil or data.unionId == nil or data.unionName == nil then
    self.analysisState = false
    return self.analysisState
  end
  self.analysisState = true
  self.serverData = data
  self.id = data.unionId
  return self.analysisState
end

return UnionInfo

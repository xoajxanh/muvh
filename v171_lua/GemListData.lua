local GemListData = {}
GemListData.equipIndex = nil
GemListData.GemDataList = nil
GemListData.AnalysisState = nil

function GemListData:InitRefresh(equipIndex)
  self.equipIndex = equipIndex
  self.AnalysisState = false
  local stoneCellList = ClientTable.cfg_EquipCell_cellManager:GetStoneList(equipIndex)
  if type(stoneCellList) ~= "table" or #stoneCellList <= 0 then
    return
  end
  self.AnalysisState = true
  if self.GemDataList == nil then
    self.GemDataList = {}
  end
  for k, v in pairs(stoneCellList) do
    if v.cellTbl.stonetype ~= 0 and self.GemDataList[v.inlayIndex] == nil then
      local gemData = LuaClass.GemData:New()
      gemData:InitRefresh(v)
      self.GemDataList[v.inlayIndex] = gemData
    end
  end
end

function GemListData:RefreshGemData(serverData)
  if serverData == nil or self.GemDataList == nil then
    return
  end
  local gemData = self.GemDataList[serverData.index]
  if gemData == nil then
    CS.UnityEngine.Debug.Log("\230\156\141\229\138\161\229\153\168\229\136\183\230\150\176\231\154\132\232\163\133\229\164\135\228\189\141\229\174\162\230\136\183\231\171\175\232\161\168\228\184\141\229\173\152\229\156\168" .. tostring(serverData.index))
    return
  end
  gemData:Refresh(serverData)
end

function GemListData:CheckHaveGemData()
  return self.AnalysisState
end

function GemListData:GetGemList()
  return self.GemDataList
end

function GemListData:GetGemDataByIndex(inlayIndex)
  if type(inlayIndex) ~= "number" then
    return
  end
  for k, v in pairs(self.GemDataList) do
    if inlayIndex == v.stoneCellInfo.inlayIndex then
      return v
    end
  end
end

return GemListData

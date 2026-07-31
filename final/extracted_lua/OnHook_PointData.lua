local OnHook_PointData = {}

function OnHook_PointData:Init()
  OnHook_PointData:InitData()
end

function OnHook_PointData:InitData()
  self.TablDic = {}
  self.TablList = {}
  self.table = ClientTable.cfg_OnHook_Point_TabManager:GetDic()
  if self.table == nil then
    return
  end
  for i, v in pairs(self.table) do
    local maintype = tonumber(v.mainType)
    local subType = tonumber(v.subType)
    if self.TablDic[maintype] == nil then
      local mainTab = {
        mainType = maintype,
        name = v.mainTab,
        cfg_OnHook_Point_Tab = v,
        subDic = {},
        subList = {},
        condtionsubList = {}
      }
      self.TablDic[maintype] = mainTab
      table.insert(self.TablList, mainTab)
    end
    local subDic = self.TablDic[maintype].subDic
    local SbuTableItem = self:GetSbuTableItem(v)
    subDic[subType] = SbuTableItem
    table.insert(self.TablDic[maintype].subList, SbuTableItem)
  end
  return self.TablDic
end

function OnHook_PointData:GetSbuTableItem(tbl)
  if tbl == nil then
    return nil
  end
  local idlist = {}
  if tbl.point ~= nil and tbl.point ~= "" then
    idlist = string.split(tbl.point, "#")
  end
  local sbuTableItem = {cfg_OnHook_Point_Tab = tbl, IdList = idlist}
  return sbuTableItem
end

function OnHook_PointData:GetMainTabDic()
  return self.TablDic
end

function OnHook_PointData:GetMainTabList(isCondtion)
  if isCondtion == nil or isCondtion == false then
    return self.TablList
  end
  local CondtionTablList = {}
  for i, v in pairs(self.TablList) do
    local condtionsubList = self:GetshowCondtionsubTabList(v.subList)
    if condtionsubList ~= nil and #condtionsubList ~= 0 then
      v.condtionsubList = condtionsubList
      table.insert(CondtionTablList, v)
    end
  end
  return CondtionTablList
end

function OnHook_PointData:GetshowCondtionsubTabList(Point_subTabdata)
  if Point_subTabdata == nil then
    return {}
  end
  local condtionList = {}
  for i, v in pairs(Point_subTabdata) do
    if v.cfg_OnHook_Point_Tab ~= nil and ConditionManager.Check4D(v.cfg_OnHook_Point_Tab.showCondtion) == true then
      table.insert(condtionList, v)
    end
  end
  return condtionList
end

function OnHook_PointData:GetMainTabData(type)
  if self.TablDic ~= nil then
    return self.TablDic[type]
  end
  return nil
end

function OnHook_PointData:GetSubTblData(maintype, subType)
  if self.TablDic == nil or self.TablDic[maintype] == nil or self.TablDic[maintype].subDic == nil then
    return
  end
  return self.TablDic[maintype].subDic[subType]
end

function OnHook_PointData:GetMonsterInfoDic(maintype, subType)
  local MonsterInfoDic = {}
  local subTabData = self:GetSubTblData(maintype, subType)
  if subTabData == nil or subTabData.IdList == nil or subTabData.IdList == {} then
    return self.MonsterInfoDic
  end
  for i, v in pairs(subTabData.IdList) do
    local data = ClientTable.cfg_OnHook_PointManager:TryGetValue(tonumber(v))
    if data ~= nil then
      local montable = ClientTable.cfg_Monster_monsterManager:TryGetValue(tonumber(data.monsterId))
      if MonsterInfoDic[data.monsterId] == nil then
        local monsterData = {
          monsterid = data.monsterId,
          position = self:ModelVector3Info(data, "modelPosition"),
          scale = self:ModelVector3Info(data, "modelScale"),
          rotate = self:ModelVector3Info(data, "position2"),
          monstertable = montable,
          recommendDef = data.recommendDef,
          order = data.order,
          cfg_OnHook_PointList = {}
        }
        MonsterInfoDic[data.monsterId] = monsterData
      end
      table.insert(MonsterInfoDic[data.monsterId].cfg_OnHook_PointList, data)
    end
  end
  return MonsterInfoDic
end

function OnHook_PointData:SortMonsterInfoDic(infoDic)
  if infoDic == nil then
    return {}
  end
  local sorList = {}
  for i, v in pairs(infoDic) do
    table.insert(sorList, v)
  end
  table.sort(sorList, self.distanceSortFunc)
  return sorList
end

function OnHook_PointData.distanceSortFunc(a, b)
  return a.order < b.order
end

function OnHook_PointData:ModelVector3Info(data, field)
  if data == nil or data[field] == nil or data[field] == "" then
    return Vector3(0, 0, 0)
  end
  local tables = string.split(data[field], "#")
  if #tables ~= 3 then
    return Vector3(0, 0, 0)
  end
  return Vector3(tables[1], tables[2], tables[3])
end

function OnHook_PointData:PointList(data)
  if data == nil then
    return
  end
  local pointDataList = {}
  local Strtemp = string.split(data.position, "&")
  for i, v in pairs(Strtemp) do
    local x = "0"
    local y = "0"
    local pointStrS = string.split(v, "#")
    if pointStrS ~= nil and #pointStrS == 2 then
      x = pointStrS[1]
      y = pointStrS[2]
    end
    local des = x .. "." .. y
    local OnHookData_PointIntem = {
      x = x,
      y = y,
      des = des,
      cfg_OnHook_Point = data
    }
    table.insert(pointDataList, OnHookData_PointIntem)
  end
  return pointDataList
end

function OnHook_PointData:GetShowIitemList(data)
  if data == nil or data.dropShow == nil then
    return
  end
  local boxitem = {}
  local tempStrs = string.split(data.dropShow, "#")
  for i, v in pairs(tempStrs) do
    local boxtable = ClientTable.cfg_Box_boxManager:TryGetValue(tonumber(v))
    if boxtable ~= nil then
      local itemInfo = {
        itemId = boxtable.itemId,
        count = boxtable.count
      }
      if string.isNullOrEmpty(boxtable.condition) then
        table.insert(boxitem, itemInfo)
      elseif RoleUtility.CareerJudge(ViewData.meData.career, boxtable.condition[1][1][2][1]) then
        table.insert(boxitem, itemInfo)
      end
    end
  end
  return boxitem
end

function OnHook_PointData:GetDefaultSelect(mainType)
  local mainTypeDef = 0
  local subTypeDef = 0
  if self.TablList == nil or #self.TablList == 0 then
    return mainTypeDef, subTypeDef
  end
  local mainData
  if mainType == nil then
    mainData = self.TablList[1]
    if mainData ~= nil then
      mainTypeDef = mainData.mainType
    end
  else
    mainData = self.TablDic[mainType]
    mainTypeDef = mainType
  end
  if mainData ~= nil and mainData.subList ~= nil and 0 < #mainData.subList then
    local subData = mainData.subList[1]
    if subData ~= nil and subData.cfg_OnHook_Point_Tab ~= nil then
      subTypeDef = subData.cfg_OnHook_Point_Tab.subType
    end
  end
  return tonumber(mainTypeDef), tonumber(subTypeDef)
end

return OnHook_PointData

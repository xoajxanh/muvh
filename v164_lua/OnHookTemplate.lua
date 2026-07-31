local onHookTemplate = {}

function onHookTemplate:Init(data)
end

function onHookTemplate:InitComponents()
  self.mainTblObj = self:GetControl("levelScroll/Viewport/ContentGold")
  self.showItemObj = self:GetControl("grid_rewardsInfo2/goldBossContent/btn_gold3DItem")
  self.showBossObj = self:GetControl("bossScroll/Viewport/goldContent")
  self.sv_pointList = self:GetControl("sv_pointList/Viewport/Content")
  self.sv_pointListObj = self:GetControl("sv_pointList")
  self.sv_point_Close = self:GetControl("sv_pointList/btnBgClose")
  self.sv_point_Close:SetOnClick(self, self.OnClickpoint_Close)
end

function onHookTemplate:InitData(maintype, subType, target)
end

function onHookTemplate:InitBindUIContainerTemp()
  self.showItemObjContainer = UIUtility.BindUIContainerTemp(self.showItemObj, LuaComponentTemplates.UIItemTemplate, self.baseUI, {isShowTips = true})
end

function onHookTemplate:Refresh()
end

function onHookTemplate:RefreshTbl()
end

function onHookTemplate:GetData()
end

function onHookTemplate:RefreshMainTblSelect(selectType)
end

function onHookTemplate:RefreshSubTblSelect(selectType)
end

function onHookTemplate:RefreshTblPos()
  local objList = self.mainTblObj:GetTopGridObjectList()
  if objList == nil then
    return
  end
  local index = 0
  local height = 0
  local CellHeight = self.mainTblObj:GetTopGridCellHeight()
  for i, v in pairs(objList) do
    if self.mainTblDic[v] ~= nil then
      self.mainTblDic[v]:UIControl():SetAnchoredPosition(0, -height)
      local subHight = self.mainTblDic[v]:GetsubTblHeight(self.selectMainType)
      height = height + CellHeight + subHight
    end
    index = index + 1
  end
  self.mainTblObj:SetSizeDelta(10, height)
end

function onHookTemplate:RefreshBossList()
  local tblDatatemp = self:GetData():GetMonsterInfoDic(self.selectMainType, self.selectSubType)
  local tblData = self:GetData():SortMonsterInfoDic(tblDatatemp)
  if tblData == nil then
    self.showBossObj:SetTopGridMaxCount(0)
    return
  end
  if self.bossTblDic == nil then
    self.bossTblDic = {}
  end
  local length = UIUtility.GetDicLength(tblData)
  self.showBossObj:SetTopGridMaxCount(length)
  local index = 0
  for i, v in pairs(tblData) do
    local object = self.showBossObj:GetTopGridObjectList()[index]
    if self.bossTblDic[object] == nil then
      self.bossTblDic[object] = luaTemplateManager.GetNewTemplate(object, LuaComponentTemplates.OnHookBossTemplate)
    end
    self.bossTblDic[object]:Refresh(v, index)
    index = index + 1
  end
end

function onHookTemplate:RefreshBossTblSelect(data)
end

function onHookTemplate:RefreshBossSelect(bossID)
  for i, v in pairs(self.bossTblDic) do
    local isSelect, index = v:RefreshBossSelect(bossID)
    if isSelect then
      local point = -index * 258
      self.showBossObj:SetAnchoredPosition(point, -152)
    end
  end
end

function onHookTemplate:RefreshPointList(data)
  local tblData = self:GetData():PointList(data)
  self.sv_pointListObj:SetActive(data ~= nil)
  if tblData == nil then
    return
  end
  if self.PointDic == nil then
    self.PointDic = {}
  end
  local length = UIUtility.GetDicLength(tblData)
  self.sv_pointList:SetTopGridMaxCount(length)
  local index = 0
  for i, v in pairs(tblData) do
    local object = self.sv_pointList:GetTopGridObjectList()[index]
    if self.PointDic[object] == nil then
      self.PointDic[object] = luaTemplateManager.GetNewTemplate(object, LuaComponentTemplates.OnHookPointTemplate)
    end
    index = index + 1
    self.PointDic[object]:Refresh(v)
  end
end

function onHookTemplate:SetPointListTransform(data)
  if data == nil or data.go == nil then
    return
  end
  local position = data.go.transform.position
  local curPos = Vector3(position.x + 1.5, 359.3, position.z)
  print(self.sv_pointListObj.transform.position.y)
  self.sv_pointListObj.transform.position = curPos
end

function onHookTemplate:OnClickpoint_Close()
  self.sv_pointListObj:SetActive(false)
  if self.bossTblDic ~= nil then
    for i, v in pairs(self.bossTblDic) do
      v:RefreshBossButtonSelect(nil)
    end
  end
end

function onHookTemplate:RfreshShowItem()
  local subTabData = self:GetData():GetSubTblData(self.selectMainType, self.selectSubType)
  if subTabData == nil then
    return
  end
  local tblData = self:GetData():GetShowIitemList(subTabData.cfg_OnHook_Point_Tab)
  if tblData == nil then
    return
  end
  self.showItemObjContainer:SetData(tblData)
end

return onHookTemplate

local RightMonsterListTemplate = {}
RightMonsterListTemplate.mapId = nil

function RightMonsterListTemplate:Init()
  self:InitComponent()
  self:BindUIEvent()
  self:InitListControl()
end

function RightMonsterListTemplate:InitComponent()
  self.titleControl = self:GetControl("btn_eliteBoss/Text")
  self.img_monsterListControl = self:GetControl("sw_eliteBossList/Viewport/Content/img_monsterList")
  self.btn_normal = self:GetControl("Btns/btn_normal_1")
  self.btn_member = self:GetControl("Btns/btn_member_1")
  self.go_normalCheck = self:GetControl("Btns/btn_normal_1/check")
  self.go_memberCheck = self:GetControl("Btns/btn_member_1/check")
end

function RightMonsterListTemplate:InitListControl()
  self.MonsterListControl = UIUtility.BindUIContainerTemp(self.img_monsterListControl, LuaComponentTemplates.RightMonsterList_SingleTemplate, self)
end

function RightMonsterListTemplate:BindUIEvent()
  self.btn_normal:SetOnClick(self, self.NomalGoClickCalBack)
  self.btn_member:SetOnClick(self, self.MemberGoClickCalBack)
end

function RightMonsterListTemplate:NomalGoClickCalBack()
  if self.type == MapPointListType.NORMAL then
    return
  end
  self.type = MapPointListType.NORMAL
  self:RefreshView()
end

function RightMonsterListTemplate:MemberGoClickCalBack()
  if self.type == MapPointListType.VIP then
    return
  end
  self.type = MapPointListType.VIP
  self:RefreshView()
end

function RightMonsterListTemplate:Refresh(mapId, isSpecial, bg)
  if self.mapId == mapId and isSpecial == nil then
    return
  end
  self:RefreshData(mapId, bg)
  self:RefreshView()
end

function RightMonsterListTemplate:RefreshData(mapId, bg)
  self.mapId = mapId
  self.bg = bg
  self:GetMapMonsterPoint(mapId)
  if #self.vipMapMonsterPointList > 0 then
    self.type = 0 < #self.mapMonsterPointList and MapPointListType.NORMAL or MapPointListType.VIP
  else
    self.type = nil
  end
  if gameMgr:GetMapManager():GetMapMonsterPointData():ShowRightMonsterList(mapId) == false then
    self.mapMonsterPointList = {}
    self.vipMapMonsterPointList = {}
  end
end

function RightMonsterListTemplate:GetMapMonsterPoint(mapId)
  local mapMonsterPoint = {}
  local vipMapMonsterPoint = {}
  local totalMapMonsterPointList = gameMgr:GetMapManager():GetMapMonsterPointData():GetTotalMapMonsterPoint(mapId)
  if totalMapMonsterPointList then
    for i, v in ipairs(totalMapMonsterPointList) do
      local isMemberPoint = v.PointTbl.isMemberPoint == 1
      if isMemberPoint then
        table.insert(vipMapMonsterPoint, v)
      else
        table.insert(mapMonsterPoint, v)
      end
    end
  end
  if table.count(vipMapMonsterPoint) > 0 and gameMgr:GetMapManager():GetMapMonsterPointData():CheckAllVipMapMonsterPointNeedDefenseIsLowerMyDefense(vipMapMonsterPoint) then
    local satisfyMapMonsterPointData, dissatisfactionMapMonsterPointData = gameMgr:GetMapManager():GetMapMonsterPointData():GetRecommendMapMonsterPoint()
    local curMapIsVipMap = ClientTable.cfg_Map_mapManager:CurMapIsVipMap(SceneData.mapId)
    if satisfyMapMonsterPointData then
      if curMapIsVipMap == false then
        table.insert(vipMapMonsterPoint, satisfyMapMonsterPointData)
        if table.count(mapMonsterPoint) > 0 then
          table.insert(mapMonsterPoint, satisfyMapMonsterPointData)
        end
      elseif SceneData.mapId ~= satisfyMapMonsterPointData.mapId then
        table.insert(vipMapMonsterPoint, satisfyMapMonsterPointData)
        if table.count(mapMonsterPoint) > 0 then
          table.insert(mapMonsterPoint, satisfyMapMonsterPointData)
        end
      end
    end
    if satisfyMapMonsterPointData and dissatisfactionMapMonsterPointData then
      table.insert(vipMapMonsterPoint, dissatisfactionMapMonsterPointData)
      if table.count(mapMonsterPoint) > 0 then
        table.insert(mapMonsterPoint, dissatisfactionMapMonsterPointData)
      end
    end
  end
  self.mapMonsterPointList = mapMonsterPoint
  self.vipMapMonsterPointList = vipMapMonsterPoint
end

function RightMonsterListTemplate:RefreshView()
  self:RefreshTopView()
  self:RereshListView()
  self:RefreshBtnView()
end

function RightMonsterListTemplate:RefreshTopView()
  self.titleControl:SetText(gameMgr:GetMapManager():GetMapMonsterPointData():GetTitleName())
end

function RightMonsterListTemplate:RereshListView()
  local pointList = self:GetPointTbl()
  if self.bg then
    local num = table.count(pointList) >= 4 and 5 or table.count(pointList)
    local num2 = SkillSettingData.curmode == EPanModeType.All and 140 or 198
    local y = num2 >= 43 * num and 48 * num or num2
    self.bg:SetSizeDelta(228, y)
    local view = UIControl(self.bg.transform, "Viewport")
    if view then
      view:SetSizeDelta(365, y - 4)
    end
  end
  self.MonsterListControl:SetData(pointList)
  self:UIControl():SetActive(not self:CheckHideGo())
  
  local function waitSetNormalizedPosition()
    Coroutine.Wait(0.1)
    self:SetNormalizedPosition()
  end
  
  Coroutine.Start(waitSetNormalizedPosition)
end

function RightMonsterListTemplate:SetNormalizedPosition()
  local pointList = self:GetPointTbl()
  if table.isNullOrEmpty(pointList) or self.bg == nil then
    return
  end
  local countCanEnter = #pointList
  for i, v in ipairs(pointList) do
    if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow) < v.PointTbl.defenseBase then
      countCanEnter = i - 1
      break
    end
  end
  local countAll = #pointList
  local countCanNotEnter = countAll - countCanEnter
  countCanNotEnter = countCanNotEnter <= 1 and 0 or countCanNotEnter + 1
  if 0 < countAll then
    self.bg.scrollRect.verticalNormalizedPosition = Mathf.Clamp01(countCanNotEnter / countAll)
  end
end

function RightMonsterListTemplate:RefreshBtnView()
  if self.type == nil then
    self.btn_normal:SetActive(false)
    self.btn_member:SetActive(false)
    self.titleControl:SetActive(true)
    return
  end
  self.titleControl:SetActive(false)
  self.btn_normal:SetActive(true)
  self.btn_member:SetActive(true)
  self.go_normalCheck:SetActive(self.type == MapPointListType.NORMAL)
  self.go_memberCheck:SetActive(self.type == MapPointListType.VIP)
end

function RightMonsterListTemplate:RefreshAllHintLight()
  if self.MonsterListControl == nil or #self.MonsterListControl.items <= 0 then
    return
  end
  for k, v in pairs(self.MonsterListControl.items) do
    local template = v.itemTemp
    if template ~= nil then
      template:RefreshEffect()
    end
  end
end

function RightMonsterListTemplate:GetPointTbl()
  if self.type == nil or self.type == MapPointListType.NORMAL then
    return self.mapMonsterPointList
  elseif self.type == MapPointListType.VIP then
    return self.vipMapMonsterPointList
  end
  return self.mapMonsterPointList
end

function RightMonsterListTemplate:CheckHideGo()
  return table.count(self.mapMonsterPointList) == 0 and table.count(self.vipMapMonsterPointList) == 0
end

function RightMonsterListTemplate:OnEnable()
  if self.SetNormalizedPosition then
    self:SetNormalizedPosition()
  end
end

return RightMonsterListTemplate

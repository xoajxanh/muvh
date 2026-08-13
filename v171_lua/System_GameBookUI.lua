System_GameBookUI = class(BaseUI)
System_GameBookUI.layer = UILayer.Panel
System_GameBookUI.orderInLayer = 0
System_GameBookUI.hideType = UIHideType.Destroy
System_GameBookUI.hideFunc = UIHideFunc.MoveOutOfScreen
System_GameBookUI.escClose = UIEscClose.DontClose

function System_GameBookUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.grid_type = self:GetControl("grid_type")
  self.mainMenu = self:GetControl("grid_type/Viewport/Content/mainMenu")
  self.mainMenuTemp = self:GetControl("grid_type/Viewport/Content/mainMenu/mainMenuTemp")
  self.panel_Raiders = self:GetControl("panel_Raiders")
  self.content_RaidersContainer = self:GetControl("panel_Raiders/Viewport/DesContent/content_RaidersContainer")
  self.img_Title = self:GetControl("panel_Raiders/Viewport/DesContent/content_RaidersContainer/img_Title")
  self.InfoTemp = self:GetControl("panel_Raiders/Viewport/DesContent/content_RaidersContainer/InfoTemp")
  self.panel_PlayFeature = self:GetControl("panel_PlayFeature")
  self.first_PlayFeatureContainer = self:GetControl("panel_PlayFeature/Viewport/first_PlayFeatureContainer")
  self.activityForecast = self:GetControl("panel_PlayFeature/Viewport/first_PlayFeatureContainer/playFeatureTemp/activityForecast")
  self.panel_CombineWay = self:GetControl("panel_CombineWay")
  self.first_CombineWayContainer = self:GetControl("panel_CombineWay/Viewport/first_CombineWayContainer")
  self.SynthesisInfoGroup = self:GetControl("panel_CombineWay/Viewport/first_CombineWayContainer/SynthesisInfoGroup")
  self.lab_groupTitle = self:GetControl("panel_CombineWay/Viewport/first_CombineWayContainer/SynthesisInfoGroup/lab_groupTitle")
  self.second_Container = self:GetControl("panel_CombineWay/Viewport/first_CombineWayContainer/SynthesisInfoGroup/second_Container")
  self.SynthesisInfoItem = self:GetControl("panel_CombineWay/Viewport/first_CombineWayContainer/SynthesisInfoGroup/second_Container/SynthesisInfoItem")
  self.panel_EquipRaiders = self:GetControl("panel_EquipRaiders")
  self.img_liuguang = self:GetControl("panel_EquipRaiders/Viewport/Content/img_liuguang")
  self.img_liuguang2 = self:GetControl("panel_EquipRaiders/Viewport/Content/img_liuguang2")
  self.img_liuguang3 = self:GetControl("panel_EquipRaiders/Viewport/Content/img_liuguang3")
  self.panel_PlayerRaiders1 = self:GetControl("panel_PlayerRaiders1")
  self.panel_PlayerRaiders2 = self:GetControl("panel_PlayerRaiders2")
  self.panel_PlayerRaiders3 = self:GetControl("panel_PlayerRaiders3")
  self.panel_PlayerRaiders4 = self:GetControl("panel_PlayerRaiders4")
  self.panel_PlayerRaiders5 = self:GetControl("panel_PlayerRaiders5")
end

function System_GameBookUI:Init()
end

function System_GameBookUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function System_GameBookUI:InitUI()
end

function System_GameBookUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function System_GameBookUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.System_GameBookUI)
end

function System_GameBookUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.System_GameBookUI)
end

function System_GameBookUI:btn_MainMenuOnClick(control)
  if self.lastMain_clickeffect ~= nil then
    self.lastMain_clickeffect.gameObject:SetActive(false)
  end
  self.lastMain_clickeffect = UIControl(control.transform, "img_clickeffect")
  self.lastMain_clickeffect:SetActive(true)
  if self.last_SubContainer ~= nil then
    self.last_SubContainer:SetTopGridMaxCount(0)
  end
  self.last_SubContainer = UIControl(control.transform, "subTbl")
  self:SetSubTagContainer(control, control.param.cfg_gameguide)
  self:SetMainMenuTagPos(control.param.clickIndex, self.mainMenu, self.last_SubContainer)
end

function System_GameBookUI:btn_SubMenuOnClick(control)
  if self.lastSub_clickeffect ~= nil then
    self.lastSub_clickeffect.gameObject:SetActive(false)
  end
  self.lastSub_clickeffect = UIControl(control.transform, "img_clickeffect")
  self.lastSub_clickeffect:SetActive(true)
  self.curCfgGameguide = control.param.cfg_gameguide
  self:RefreshRightView()
end

function System_GameBookUI:OnShow()
  self:RegistEvents()
  self:InitData()
  self:Refresh()
  networkRequest.ReqBiBleRedPoint()
end

function System_GameBookUI:RegistEvents()
end

function System_GameBookUI:Refresh()
  self:SetMainTagContainer()
end

function System_GameBookUI:OnHide()
end

function System_GameBookUI:OnDestroy()
end

function System_GameBookUI:InitData()
  if self.args then
    self.leftMainIndex = self.args.openFirstTab or 1
    self.leftSubIndex = self.args.openSecondTab or 1
    self.subPosition = self.args.subPosition or 1
  else
    self.leftMainIndex = 1
    self.leftSubIndex = 1
    self.subPosition = 1
  end
  if self.recordDic == nil then
    self.recordDic = {}
  end
  if self.recordContainsPos == nil then
    self.recordContainsPos = {}
  end
end

function System_GameBookUI:SetMainTagContainer()
  local tabDic = ClientTable.cfg_Game_gameguideManager:GetTabDic()
  local count = table.count(tabDic)
  self.mainMenu:SetTopGridMaxCount(count)
  local index = 1
  local defalutObj
  for key, value in pairs(tabDic) do
    local go = self.mainMenu:GetTopGridObjectList()[index - 1].transform
    local goFirst = UIControl(go)
    local lab_name = UIControl(go, "lab_name")
    local cfg_gameguide = value[1]
    lab_name:SetText(cfg_gameguide.menu)
    local param = {cfg_gameguide = cfg_gameguide, clickIndex = index}
    goFirst:SetOnClickParam(self, self.btn_MainMenuOnClick, param)
    if index == self.leftMainIndex then
      goFirst.param = param
      defalutObj = goFirst
    end
    index = index + 1
  end
  self.leftMainIndex = 1
  self:btn_MainMenuOnClick(defalutObj)
end

function System_GameBookUI:SetSubTagContainer(_goFirst, _data)
  local cfg_gameguide = _data
  local tabDic = ClientTable.cfg_Game_gameguideManager:GetTabDic()
  local subTabList = {}
  for key, value in pairs(tabDic[cfg_gameguide.type]) do
    if value.subtype > 0 then
      if subTabList[value.subtype] == nil then
        subTabList[value.subtype] = {}
      end
      table.insert(subTabList[value.subtype], value)
    end
  end
  if 0 >= table.count(subTabList) then
    self.curCfgGameguide = cfg_gameguide
    self:RefreshRightView()
    return
  end
  local count = table.count(subTabList)
  local subTbl = UIControl(_goFirst.transform, "subTbl")
  subTbl:SetTopGridMaxCount(count)
  local index = 1
  local defalutObj
  for key, value in pairs(subTabList) do
    local go = subTbl:GetTopGridObjectList()[index - 1].transform
    local lab_name = UIControl(go, "lab_name")
    local cfg_gameguide
    for key, value1 in pairs(value) do
      if value1.submenu ~= "" then
        cfg_gameguide = value1
        break
      end
    end
    lab_name:SetText(cfg_gameguide.submenu)
    local goSecond = UIControl(go)
    local param = {cfg_gameguide = cfg_gameguide}
    goSecond:SetOnClickParam(self, self.btn_SubMenuOnClick, param)
    if index == self.leftSubIndex then
      goSecond.param = param
      defalutObj = goSecond
    end
    index = index + 1
  end
  self.leftSubIndex = 1
  self:btn_SubMenuOnClick(defalutObj)
end

function System_GameBookUI:SetMainMenuTagPos(_clickIndex, _mainMenu, _subMenu)
  local mainCount = _mainMenu.Top_gridContainer.MaxCount
  local mainHeight = _mainMenu:GetTopGridCellHeight()
  local offsetY = self.mainMenuTemp.transform.localPosition.y
  for i = 1, mainCount do
    local trans = self.mainMenu:GetTopGridObjectList()[i - 1].transform
    trans.localPosition = Vector3(trans.localPosition.x, offsetY - mainHeight * (i - 1), trans.localPosition.z)
  end
  local subCount = _subMenu.Top_gridContainer.MaxCount
  local subHeight = _subMenu:GetTopGridCellHeight()
  for i = 1, mainCount do
    if _clickIndex < i then
      local trans = self.mainMenu:GetTopGridObjectList()[i - 1].transform
      trans.localPosition = Vector3(trans.localPosition.x, trans.localPosition.y - subHeight * subCount, trans.localPosition.z)
    end
  end
end

function System_GameBookUI:SetMultipleContainsPos(_type, _Contains)
  if self.recordContainsPos[_type] ~= nil and #self.recordContainsPos[_type] > 0 then
    return
  end
  self.recordContainsPos[_type] = {}
  local mainCount = _Contains.Top_gridContainer.MaxCount
  for i = 1, mainCount do
    local go1 = _Contains:GetTopGridObjectList()[i - 1].transform
    local second_Container = UIControl(go1, "second_Container")
    local subCount = second_Container.Top_gridContainer.MaxCount
    local subHeight = second_Container:GetTopGridCellHeight()
    table.insert(self.recordContainsPos[_type], subHeight * subCount)
  end
  for i = 2, mainCount do
    local go = _Contains:GetTopGridObjectList()[i - 1].transform
    local hight = 0
    for j = 1, #self.recordContainsPos[_type] do
      if i > j then
        hight = hight + self.recordContainsPos[_type][j]
      end
    end
    go.localPosition = Vector3(go.localPosition.x, go.localPosition.y - hight, go.localPosition.z)
  end
  local totalHeight = 0
  for j = 1, #self.recordContainsPos[_type] do
    totalHeight = totalHeight + self.recordContainsPos[_type][j]
  end
  local img_GroupTitle = self.lab_groupTitle.transform:GetComponent("RectTransform")
  totalHeight = totalHeight + img_GroupTitle.rect.height * mainCount + Mathf.Abs(img_GroupTitle.localPosition.y)
  local rectTrans = self.first_CombineWayContainer.transform:GetComponent("RectTransform")
  rectTrans.sizeDelta = Vector2(rectTrans.sizeDelta.x, totalHeight)
end

function System_GameBookUI:SetSingleContainsPos(_type, _Contains)
  self.recordContainsPos[_type] = {}
  local mainCount = _Contains.Top_gridContainer.MaxCount
  for i = 1, mainCount do
    local go1 = _Contains:GetTopGridObjectList()[i - 1].transform
    local lab_des = UIControl(go1, "lab_des")
    local lab_desRectTrans = lab_des.transform:GetComponent("RectTransform")
    if lab_desRectTrans and not IsNil(lab_desRectTrans) then
      UnityEngineUI.LayoutRebuilder.ForceRebuildLayoutImmediate(lab_desRectTrans)
      local height = lab_desRectTrans.rect.height + 15
      table.insert(self.recordContainsPos[_type], height)
    end
  end
  for i = 2, mainCount do
    local go = _Contains:GetTopGridObjectList()[i - 1].transform
    local hight = 0
    for j = 1, #self.recordContainsPos[_type] do
      if i > j then
        hight = hight + self.recordContainsPos[_type][j]
      end
    end
    go.localPosition = Vector3(go.localPosition.x, go.localPosition.y - hight, go.localPosition.z)
  end
end

function System_GameBookUI:SetContentSizeDelta(_type)
  if self.recordContainsPos[_type] == nil then
    return
  end
  local totalHeight = 0
  local rectTrans = self.content_RaidersContainer.transform:GetComponent("RectTransform")
  for j = 1, #self.recordContainsPos[_type] do
    totalHeight = totalHeight + self.recordContainsPos[_type][j]
  end
  local img_TitleRectTrans = self.img_Title.transform:GetComponent("RectTransform")
  totalHeight = totalHeight + img_TitleRectTrans.rect.height + Mathf.Abs(img_TitleRectTrans.localPosition.y)
  rectTrans.sizeDelta = Vector2(rectTrans.sizeDelta.x, totalHeight)
end

function System_GameBookUI:RefreshRightView()
  self:SetHideAllPanel()
  local type = self.curCfgGameguide.type
  if type == MainTypeEnum.Raiders then
    self:RefreshRaiders()
  elseif type == MainTypeEnum.PlayFeature then
    self:RefreshPlayFeature()
  elseif type == MainTypeEnum.CombineWay then
    self:RefreshCombineWay()
  elseif type == MainTypeEnum.EquipPlay then
    self:RefreshEquipRaiders()
  elseif type == MainTypeEnum.PlayerRaiders then
    self:RefreshPlayerRaiders()
  end
end

function System_GameBookUI:RefreshPlayFeature()
  local cfg_gameguide = self.curCfgGameguide
  local tabList = ClientTable.cfg_Game_gameguideManager:GetTabsBySubtype(cfg_gameguide.type, cfg_gameguide.subtype)
  local count = table.count(tabList)
  self.first_PlayFeatureContainer:SetTopGridMaxCount(count)
  local index = 1
  for key, value in pairs(tabList) do
    local go = self.first_PlayFeatureContainer:GetTopGridObjectList()[index - 1].transform
    if self.recordDic[go] == nil then
      self.recordDic[go] = luaTemplateManager.GetNewTemplate(go, LuaComponentTemplates.GameBook_PlayFeatureTemplates)
    end
    local templateData = {
      cfg_gameguide = value,
      serverData = {},
      ui = self
    }
    self.recordDic[go]:Refresh(templateData)
    index = index + 1
  end
  self.panel_PlayFeature:SetActive(true)
end

function System_GameBookUI:RefreshCombineWay()
  local tabDic = ClientTable.cfg_Game_gameguideManager:GetTabDic()
  local tabList = tabDic[MainTypeEnum.CombineWay]
  local count = table.count(tabList)
  self.first_CombineWayContainer:SetTopGridMaxCount(count)
  self.first_CombineWayContainer.transform.localPosition = Vector2(self.content_RaidersContainer.transform.localPosition.x, 0)
  local index = 1
  for key, value in pairs(tabList) do
    local go = self.first_CombineWayContainer:GetTopGridObjectList()[index - 1].transform
    if self.recordDic[go] == nil then
      self.recordDic[go] = luaTemplateManager.GetNewTemplate(go, LuaComponentTemplates.GameBook_CombineWayTemplates)
    end
    local templateData = {
      cfg_gameguide = value,
      ui = self,
      serverData = {}
    }
    self.recordDic[go]:Refresh(templateData)
    index = index + 1
  end
  self.panel_CombineWay:SetActive(true)
  self:SetMultipleContainsPos(MainTypeEnum.CombineWay, self.first_CombineWayContainer)
end

function System_GameBookUI:RefreshRaiders()
  local cfg_gameguide = self.curCfgGameguide
  local desArray = string.split(cfg_gameguide.des, "#")
  local count = table.count(desArray)
  self.content_RaidersContainer:SetTopGridMaxCount(0)
  self.content_RaidersContainer.transform.localPosition = Vector2(self.content_RaidersContainer.transform.localPosition.x, 0)
  self.content_RaidersContainer:SetTopGridMaxCount(count)
  local controlTemplate = self.content_RaidersContainer:GetTopGridControlTemplate()
  local index = 1
  for key, value in pairs(desArray) do
    local go = self.content_RaidersContainer:GetTopGridObjectList()[index - 1].transform
    if controlTemplate and IsNil(controlTemplate) == false then
      go.localPosition = Vector3(controlTemplate.transform.localPosition.x, controlTemplate.transform.localPosition.y, controlTemplate.transform.localPosition.z)
    end
    if self.recordDic[go] == nil then
      self.recordDic[go] = luaTemplateManager.GetNewTemplate(go, LuaComponentTemplates.GameBook_RaidersTemplates)
    end
    local templateData = {
      cfg_uIWordId = value,
      ui = self,
      serverData = {}
    }
    self.recordDic[go]:Refresh(templateData)
    index = index + 1
  end
  self.panel_Raiders:SetActive(true)
  self:SetSingleContainsPos(MainTypeEnum.Raiders, self.content_RaidersContainer)
  self:SetContentSizeDelta(MainTypeEnum.Raiders)
end

function System_GameBookUI:RefreshEquipRaiders()
  local mCareer = ViewData.meData.career
  if mCareer == ERoleCareer.SwordMan then
    self.img_liuguang:SetActive(true)
    self.img_liuguang2:SetActive(false)
    self.img_liuguang3:SetActive(false)
  elseif mCareer == ERoleCareer.Magic then
    self.img_liuguang:SetActive(false)
    self.img_liuguang2:SetActive(true)
    self.img_liuguang3:SetActive(false)
  elseif mCareer == ERoleCareer.Archer then
    self.img_liuguang:SetActive(false)
    self.img_liuguang2:SetActive(false)
    self.img_liuguang3:SetActive(true)
  end
  self.panel_EquipRaiders:SetActive(true)
end

function System_GameBookUI:RefreshPlayerRaiders()
  local type = self.curCfgGameguide.type
  local subtype = self.curCfgGameguide.subtype
  local tabList = ClientTable.cfg_Game_gameguideManager:GetTabsBySubtype(type, subtype)
  if tabList == nil or #tabList <= 0 then
    return
  end
  if self.curpanel_PlayerRaiders then
    self.curpanel_PlayerRaiders:SetActive(false)
  end
  if subtype == SubTypeEnum.PlayerRaiders_1 then
    self.curpanel_PlayerRaiders = self.panel_PlayerRaiders1
  elseif subtype == SubTypeEnum.PlayerRaiders_2 then
    self.curpanel_PlayerRaiders = self.panel_PlayerRaiders2
  elseif subtype == SubTypeEnum.PlayerRaiders_3 then
    self.curpanel_PlayerRaiders = self.panel_PlayerRaiders3
  elseif subtype == SubTypeEnum.PlayerRaiders_4 then
    self.curpanel_PlayerRaiders = self.panel_PlayerRaiders4
  elseif subtype == SubTypeEnum.PlayerRaiders_5 then
    self.curpanel_PlayerRaiders = self.panel_PlayerRaiders5
  end
  for key, value in pairs(tabList) do
    local cfg_gameguide = value
    local curPanelTitle = UIControl(self.curpanel_PlayerRaiders.transform, "Des/Viewport/DesContent/txt_Title/lab_Content")
    curPanelTitle:SetText(cfg_gameguide.title)
    self.curpanel_PlayerRaiders:SetActive(true)
  end
end

function System_GameBookUI:SetHideAllPanel()
  self.panel_PlayFeature:SetActive(false)
  self.panel_CombineWay:SetActive(false)
  self.panel_Raiders:SetActive(false)
  self.panel_EquipRaiders:SetActive(false)
  self.panel_PlayerRaiders1:SetActive(false)
  self.panel_PlayerRaiders2:SetActive(false)
  self.panel_PlayerRaiders3:SetActive(false)
  self.panel_PlayerRaiders4:SetActive(false)
  self.panel_PlayerRaiders5:SetActive(false)
end
